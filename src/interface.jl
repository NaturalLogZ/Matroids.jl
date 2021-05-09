"""
Contains the public facing methods.
Some may be overridden by specific matroid implemenations.
"""


function groundset(M::AbstractMatroid)
    return copy(_groundset(M))
end

"""
    size(M)

Return the size of the groundset.
"""
function Base.size(M::AbstractMatroid)
    return _size(M)
end

function Base.eltype(M::AbstractMatroid)
    return eltype(groundset(M))
end

function rank(M::AbstractMatroid)
    return _rank(M)
end

function corank(M::AbstractMatroid)
    return _corank(M)
end

function fullrank(M::AbstractMatroid)
    return rank(M)
end

function fullcorank(M::AbstractMatroid)
    return corank(M)
end

function rank(M::AbstractMatroid, X)
    if length(X) == 0
        return 0
    end
    return _rank(M, _subsetcheck(M, X))
end

function basis(M::AbstractMatroid)
    return _maxindependent(M, _groundset(M))
end

function maxindependent(M::AbstractMatroid, X)
    return _maxindependent(M, _subsetcheck(M, X))
end

function circuit(M::AbstractMatroid)
    return _circuit(M, _groundset(M))
end

function circuit(M::AbstractMatroid, X)
    return _circuit(M, _subsetcheck(M, X))
end

function fundamentalcircuit(M::AbstractMatroid, B, e)
    if !isbasis(M, B)
        error("B is not a basis of the matroid")
    end
    if !(e in _groundset(M))
        error("e is not in the groundset")
    end
    return _fundamentalcircuit(M, B, e)
end

function closure(M::AbstractMatroid, X)
    return _closure(M, _subsetcheck(M, X))
end

# I don't want to deal with k closures.
# Pretty sure this works though.
# function kclosure(M::AbstractMatroid, X, k::Int)
# 
#     cur = 0
#     S = _subsetcheck(M, X)
#     while cur != length(S)
#         cur = length(S)
#         temp = Set()
#         for T in combinations(S, min(k, cur))
#             union!(temp, _closure(M, T))
#         end
#         S = collect(temp)
#     end
#     return S
# end

function corank(M::AbstractMatroid, X)
    return _corank(M, _subsetcheck(M, X))
end

function cobasis(M::AbstractMatroid)
    return _maxcoindependent(M, _groundset(M))
end

function maxcoindependent(M::AbstractMatroid, X)
    return _maxcoindependent(M, _subsetcheck(M, X))
end

function coclosure(M::AbstractMatroid, X)
    return _coclosure(M, _subsetcheck(M, X))
end

function cocircuit(M::AbstractMatroid)
    return _cocircuit(M, _groundset(M))
end

function cocircuit(M::AbstractMatroid, X)
    return _cocircuit(M, _subsetcheck(M, X))
end

function fundamentalcocircuit(M::AbstractMatroid, B, e)
    if !isbasis(M, B)
        error("B is not a basis of the matroid")
    end
    if !(e in B)
        error("e is not in B")
    end
    return _fundamentalcocircuit(M, B, e)
end

function loops(M::AbstractMatroid)
    return _closure(M, [])
end

function isindependent(M::AbstractMatroid, X)
    return _isindependent(M, _subsetcheck(M, X))
end

function isdependent(M::AbstractMatroid, X)
    return !_isindependent(M, _subsetcheck(M, X))
end

function isbasis(M::AbstractMatroid, X)
    return _isbasis(M, _subsetcheck(M, X))
end

function isclosed(M::AbstractMatroid, X)
    return _isclosed(M, _subsetcheck(M, X))
end

function iscircuit(M::AbstractMatroid, X)
    return _iscircuit(M, _subsetcheck(M, X))
end

function coloops(M::AbstractMatroid)
    return _coclosure(M, [])
end

function iscoindependent(M::AbstractMatroid, X)
    return _iscoindependent(M, _subsetcheck(M, X))
end

function iscodependent(M::AbstractMatroid, X)
    return !_iscoindependent(M, _subsetcheck(M, X))
end

function iscobasis(M::AbstractMatroid, X)
    return _iscobasis(M, _subsetcheck(M, X))
end

function iscocircuit(M::AbstractMatroid, X)
    return _iscocircuit(M, _subsetcheck(M, X))
end

function iscoclosed(M::AbstractMatroid, X)
    return _iscoclosed(M, _subsetcheck(M, X))
end

function circuits(M::AbstractMatroid)
    # need to lots of conversion to sets to check duplicates.
    C = Set()
    for B in bases(M)
        for e in setdiff(groundset(M), B)
            ct = Set(_circuit(M, union(B, [e])))
            push!(C, ct)
        end
    end
    return [collect(c) for c in C]
end

function cocircuits(M::AbstractMatroid)
    C = Set()
    for B in bases(M)
        for e in B
            ct = Set(_cocircuit(M, union(setdiff(groundset(M), B), [e])))
            push!(C, ct)
        end
    end
    return [collect(c) for c in C]
end

function circuitclosures(M::AbstractMatroid)
    CC = [Set() for _ in 0:rank(M)]
    for C in circuits(M)
        push!(CC[length(C)], Set(closure(M, C)))
    end
    out = Dict{Int, Vector}(r=>[collect(c) for c in CC[r+1]] 
                            for r in 1:rank(M) if !isempty(CC[r+1]))
    return out
end

function bases(M::AbstractMatroid)
    E = _groundset(M)
    r = _rank(M)

    allbases = Vector()
    for X in combinations(E, r)
        if _rank(M, X) == length(X)
            push!(allbases, X)
        end
    end
    return allbases
end

function nonbases(M::AbstractMatroid)
    E = _groundset(M)
    r = _rank(M)

    allnonbases = Vector()
    for X in combinations(E, r)
        if _rank(M, X) < length(X)
            push!(allnonbases, X)
        end
    end
    return allnonbases
end

function independentsets(M::AbstractMatroid)
    rk = rank(M)
    res = Vector()
    push!(res, [])
    T = [Set() for _ in 1:rk]
    typ = eltype(groundset(M))
    I = [Vector{typ}() for _ in 0:rk]

    r = 1
    T[1] = setdiff(Set(groundset(M)), _closure(M, []))
    while r >= 1
        if r == rk
            for x in T[r]
                I[r+1] = union(I[r], [x])
                push!(res, I[r+1])
            end
            T[r] = Set()
            r -= 1
        elseif !isempty(T[r])
            I[r+1] = union(I[r], [pop!(T[r])])
            push!(res, I[r+1])
            T[r+1] = setdiff(T[r], _closure(M, I[r+1]))
            r += 1
        else
            r -= 1
        end
    end
    return res
end

function flats(M::AbstractMatroid, r::Int)
    if r < 0
        return []
    end

    E = groundset(M)

    # dict of elements to ints so can do max/min
    idxs = Dict()
    for i in 1:length(E)
        idxs[E[i]] = i
    end

    lps = loops(M)
    flags = [(lps, [], setdiff(E, lps))]
    for _ in 1:r
        newflags = []
        for (F, B, X) in flags
            while !isempty(X)
                x = E[minimum(map(w->idxs[w], X))]
                newbase = union(B, [x])
                newflat = _closure(M, newbase)
                newX = setdiff(X, newflat)
                if maximum(map(w->idxs[w], newbase)) == idxs[x]
                    if minimum(map(w->idxs[w], setdiff(newflat, F))) == idxs[x]
                        push!(newflags, (newflat, newbase, newX))
                    end
                end
                X = newX
            end
        end
        flags = newflags
    end
    return [f[1] for f in flags]
end

# coflats depends on dual


# TODO: - should override this based on implementation
# if we care about speed. (and accuracy...)
function isvalidmatroid(M::AbstractMatroid)
    E = _groundset(M)
    for i in 0:_size(M)
        for X in combinations(E, i)
            rX = _rank(M, X)
            if rX > i
                return false
            end
            for j in 0:_size(M)
                for Y in combinations(E, j)
                    rY = _rank(M, Y)
                    if issubset(X, Y) && rX > rY
                        return false
                    end
                    if (_rank(M, union(X,Y)) + _rank(M, intersect(X,Y)) > rX + rY)
                        return false
                    end
                end
            end
        end
    end
    return true
end