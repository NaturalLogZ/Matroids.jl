

mutable struct BasisMatroid{T} <: AbstractMatroid{T}
    groundset::Vector{T}
    rank::Int
    bitbases::BitSet
    bcount::Int
    elmap::Dict{T,Int}

    function BasisMatroid{T}(;M::Union{AbstractMatroid{T}, Nothing}=nothing, 
                          groundset::Union{Vector{T}, Nothing}=nothing, 
                          bases::Union{Vector{Vector{T}}, Nothing}=nothing, 
                          nonbases::Union{Vector{Vector{T}}, Nothing}=nothing, 
                          rank::Union{Int, Nothing}=nothing) where T

        # TODO: first check stuff about M
        # it is possible to do things more efficiently if M is already a Basis Matroid

        if !isnothing(M)
            rank = Matroids.rank(M)
            bases = Matroids.bases(M)
            groundset = sort(Matroids.groundset(M))
        end
        
        if isnothing(groundset)
            groundset = Int[]
        end

        if !allunique(groundset)
            error("ground set has repeated elements")
        end

        if !isnothing(bases) && length(bases) == 0
            error("set of bases must be nonempty")
        end

        if isnothing(rank)
            if !isnothing(bases)
                rank = length(bases[1])
            elseif !isnothing(nonbases)
                rank = length(nonbases[1])
            else
                rank = 0
            end
        end

        # THis part corresponds to initing basis exchange mat

        # we have a dictionary _idx 
        # that maps from elements of the ground set
        # to integers
        idxs = Dict{T,Int}()
        for i in 1:length(groundset)
            idxs[groundset[i]] = i
        end

        bb = BitSet()
        bcount = 0

        if !isnothing(bases)
            bcount = 0
            for B in bases
                b = Set(B)
                if length(b) != rank
                    error("basis has wrong cardinality")
                end
                if !issubset(b, groundset)
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
            bcount = binomial(length(groundset),rank)
            bb = BitSet(1:bcount)
            if !isnothing(nonbases)
                for B in nonbases
                    b = Set(B)
                    if length(b) != rank
                        error("nonbasis has wrong cardinality")
                    end
                    if !issubset(b, groundset)
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
        return new{T}(groundset,rank,bb,bcount,idxs)
    end

end

function BasisMatroid(;M::Union{AbstractMatroid{T}, Nothing}=nothing, 
    groundset::Union{Vector{T}, Nothing}=nothing, 
    bases::Union{Vector{Vector{T}}, Nothing}=nothing, 
    nonbases::Union{Vector{Vector{T}}, Nothing}=nothing, 
    rank::Union{Int, Nothing}=nothing) where T

    return BasisMatroid{T}(M=M,groundset=groundset,bases=bases,nonbases=nonbases,rank=rank)
end


_rank(M::BasisMatroid) = M.rank
_groundset(M::BasisMatroid) = M.groundset

"""
Overwrites default bases implementation.
"""
function bases(M::BasisMatroid)
    r = _rank(M)
    n = _size(M)

    allbases = Vector()
    for bindex in M.bitbases
        basisset = indextoset(bindex, r, n)
        basis = unmapidxs(basisset, M.groundset)
        push!(allbases, basis)
    end
    return allbases
end

function _rank(M::BasisMatroid, X::Vector)
    packedinput = packset(X, M.elmap)
    # then find max indep set

    currentbasis = indextoset(first(M.bitbases), _rank(M), _size(M))
    inside = setdiff(currentbasis, packedinput)
    outside = setdiff(packedinput, currentbasis)

    # then __move
    for x in inside
        for y in outside
            # this corresponds to __is_exchange_pair
            cp = copy(currentbasis)
            delete!(cp, x)
            push!(cp, y)
            if in(settoindex(cp), M.bitbases)
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

function nonbases(M::BasisMatroid)
    r = _rank(M)
    n = _size(M)
    input = BitSet(1:r)

    allnonbases = Vector()
    for idx in 1:binomial(n,r)
        if !(idx in M.bitbases)
            nbasisset = indextoset(idx, r, n)
            nbasis = unmapidxs(nbasisset, _groundset(M))
            push!(allnonbases, nbasis)
        end
    end
    return allnonbases
end

function isvalidmatroid(M::BasisMatroid)
    r = _rank(M)
    n = _size(M)
    currentbasis = indextoset(first(M.bitbases), r, n)
    
    for indexX in M.bitbases
        subsetX = indextoset(indexX, r, n)
        for indexY in M.bitbases
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
                    if in(settoindex(cp), M.bitbases)
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
                    if in(settoindex(cp), M.bitbases)
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
