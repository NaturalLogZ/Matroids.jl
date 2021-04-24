

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

