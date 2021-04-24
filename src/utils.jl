


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

function unmapidxs(set, gs::Vector{T}) where T
    out = Vector{T}()
    for idx in set
        push!(out, gs[idx])
    end
    return out
end