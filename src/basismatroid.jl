

mutable struct BasisMatroid <: AbstractMatroid
    gs::Vector{Int}
    rk::Int
    bb::BitSet
    bcount::Int
    idxs::Dict{Int,Int}


    function BasisMatroid(;M::Union{AbstractMatroid, Nothing}=nothing, 
                          gs::Union{Vector{Int}, Nothing}=nothing, 
                          bs::Union{Vector{Vector{Int}}, Nothing}=nothing, 
                          nbs::Union{Vector{Vector{Int}}, Nothing}=nothing, 
                          rk::Union{Int, Nothing}=nothing)

        # TODO: first check stuff about M
        # it is possible to do things more efficiently if M is already a Basis Matroid


        if !isnothing(M)
            rk = full_rank(M)
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
        idxs = Dict()
        for i in 1:length(gs)
            idxs[gs[i]] = i
        end

        

        # then for every basis
        # check if it is a subset of the groundset (how to do efficeintly?)
        # store the basis as a bitset
        # i = settoindex of this bitset


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

        
        return new(gs,rk,bb,bcount,idxs)
    end

end

"""
Compute the rank of a set of integers amongst the sets of integers 
of the same cardinality.
Assume sets have values >= 1.
"""
function settoindex(a::BitSet)
    index = 1
    count = 1
    for s in a
        index += binomial(s-1, count)
        count += 1
    end
    return index
end

"""
Given an index, number of elements and some large enough n,
recover the set.
"""
function indextoset(index::Int, k::Int, n::Int)
    a = BitSet()
    s = n + 1
    while s > 1
        s -= 1
        if binomial(s-1,k) < index
            index -= binomial(s-1,k)
            k -= 1
            push!(a, s)
        end
    end
    return a
end

function packset(elements, indexmap::Dict)
    b = BitSet()
    for el in elements
        push!(b, indexmap[el])
    end
    return b
end