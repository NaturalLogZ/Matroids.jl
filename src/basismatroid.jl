# TODO: figure out what to do about these variable names
# for example, using gs instead of groundset as a variable,
# since we have groundset as a function; and we actually call 
# that function within the same scope.

mutable struct BasisMatroid{T} <: AbstractMatroid{T}
    gs::Vector{T}
    rk::Int
    bb::BitSet
    bcount::Int
    idxs::Dict{T,Int}

    function BasisMatroid{T}(;M::Union{AbstractMatroid{T}, Nothing}=nothing, 
                          gs::Union{Vector{T}, Nothing}=nothing, 
                          bs::Union{Vector{Vector{T}}, Nothing}=nothing, 
                          nbs::Union{Vector{Vector{T}}, Nothing}=nothing, 
                          rk::Union{Int, Nothing}=nothing) where T

        # TODO: first check stuff about M
        # it is possible to do things more efficiently if M is already a Basis Matroid

        if !isnothing(M)
            rk = rank(M)
            nbs = nonbases(M)
            gs = sort(groundset(M))
        end
        
        if isnothing(gs)
            gs = Int[]
        end

        if !allunique(gs)
            error("ground set has repeated elements")
        end

        if !isnothing(bs) && length(bs) == 0
            error("set of bases must be nonempty")
        end

        if isnothing(rk)
            if !isnothing(bs)
                rk = length(bs[1])
            elseif !isnothing(nbs)
                rk = length(nbs[1])
            else
                rk = 0
            end
        end

        # THis part corresponds to initing basis exchange mat

        # we have a dictionary _idx 
        # that maps from elements of the ground set
        # to integers
        idxs = Dict{T,Int}()
        for i in 1:length(gs)
            idxs[gs[i]] = i
        end

        bb = BitSet()
        bcount = 0

        if !isnothing(bs)
            bcount = 0
            for B in bs
                b = Set(B)
                if length(b) != rk
                    error("basis has wrong cardinality")
                end
                if !issubset(b, gs)
                    error("basis is not subset of the groundset")
                end
                bitbasis = packset(b, idxs)
                i = settoindex(bitbasis)

                if !in(i, bb)
                    bcount += 1
                end
                push!(bb, i)
            end
        else
            bcount = binomial(length(gs),rk)
            bb = BitSet(1:bcount)
            if !isnothing(nbs)
                for B in nbs
                    b = Set(B)
                    if length(b) != rk
                        error("nonbasis has wrong cardinality")
                    end
                    if !issubset(b, gs)
                        error("nonbasis is not subset of the groundset")
                    end
                    bitnonbasis = packset(b, idxs)
                    i = settoindex(bitnonbasis)
                    if in(i, bb)
                        bcount -= 1
                    end
                    delete!(bb, i)
                end
            end
        end
        return new{T}(gs,rk,bb,bcount,idxs)
    end

end

function BasisMatroid(;M::Union{AbstractMatroid{T}, Nothing}=nothing, 
    gs::Union{Vector{T}, Nothing}=nothing, 
    bs::Union{Vector{Vector{T}}, Nothing}=nothing, 
    nbs::Union{Vector{Vector{T}}, Nothing}=nothing, 
    rk::Union{Int, Nothing}=nothing) where T

    return BasisMatroid{T}(M=M,gs=gs,bs=bs,nbs=nbs,rk=rk)
end


rank(M::BasisMatroid) = M.rk
groundset(M::BasisMatroid) = M.gs


function bases(M::BasisMatroid)
    r = rank(M)
    n = size(M)

    allbases = Vector()
    for bindex in M.bb
        basisset = indextoset(bindex, r, n)
        basis = unmapidxs(basisset, M.gs)
        println(basis)
        push!(allbases, basis)
    end
    return allbases
end

function _rank(M::BasisMatroid, X::Vector)
    packedinput = packset(X, M.idxs)
    # then find max indep set

    currentbasis = indextoset(first(M.bb), rank(M), size(M))
    inside = setdiff(currentbasis, packedinput)
    outside = setdiff(packedinput, currentbasis)

    # then __move
    for x in inside
        for y in outside
            # this corresponds to __is_exchange_pair
            cp = copy(currentbasis)
            delete!(cp, x)
            push!(cp, y)
            if in(settoindex(cp), M.bb)
                currentbasis = cp
                delete!(inside, x)
                delete!(outside, y)
                break
            end
        end
    end
    #
    return length(intersect(currentbasis, packedinput))

end

function isvalidmatroid(M::BasisMatroid)
    r = rank(M)
    n = size(M)
    currentbasis = indextoset(first(M.bb), r, n)
    
    for indexX in M.bb
        subsetX = indextoset(indexX, r, n)
        for indexY in M.bb
            subsetY = indextoset(indexY, r, n)
            inside = setdiff(currentbasis, subsetY)
            outside = setdiff(subsetY, currentbasis)

            # __move (copied from above)
            # try to get from this basis to Y using exchanges.
            for x in inside
                for y in outside
                    # this corresponds to __is_exchange_pair
                    cp = copy(currentbasis)
                    delete!(cp, x)
                    push!(cp, y)
                    if in(settoindex(cp), M.bb)
                        currentbasis = cp
                        delete!(inside, x)
                        delete!(outside, y)
                        break
                    end
                end
            end
            if currentbasis != subsetY
                # violates exchange axiom
                return false
            end

            input1 = setdiff(subsetX, subsetY)
            input2 = setdiff(subsetY, subsetX)
            
            for x in input1
                foundpair = false
                for y in input2
                    cp = copy(currentbasis)
                    delete!(cp, y)
                    push!(cp, x)
                    if in(settoindex(cp), M.bb)
                        foundpair = true
                        break
                    end
                end
                if !foundpair
                    return false
                end
            end
        end
    end
    return true
end
