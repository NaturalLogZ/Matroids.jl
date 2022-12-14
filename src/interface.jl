"""
Contains the public facing methods.
Some may be overridden by specific matroid implemenations.
"""


function show(io::IO, M::AbstractMatroid)
    if typeof(M) <: BasisMatroid
        repr = "bases"
    elseif typeof(M) <: CircuitClosuresMatroid
        repr = "circuit closures"
    elseif typeof(M) <: GraphicMatroid
        repr = "a graph"
    elseif typeof(M) <: LinearMatroid
        repr = "a matrix"
    elseif typeof(M) <: RankMatroid
        repr = "a rank function"
    else
        repr = "something mysterious"
    end

    print(io, "Matroid of rank $(rank(M)) on $(size(M)) elements represented as $repr.")
end

"""
    groundset(M)

Return the groundset of the matroid `M`.
"""
function groundset(M::AbstractMatroid)
    return copy(_groundset(M))
end

"""
    size(M)

Return the size of the groundset of the matroid `M`.
"""
function size(M::AbstractMatroid)
    return _size(M)
end

"""
    eltype(M)

Return the type of groundset elements of the matroid `M`.
"""
function eltype(M::AbstractMatroid)
    return eltype(groundset(M))
end

"""
    rank(M)

Return the rank of the matroid `M`. Equivalent to `fullrank(M)`.
"""
function rank(M::AbstractMatroid)
    return _rank(M)
end

"""
    corank(M)

Return the corank of the matroid `M`. Equivalent to `fullcorank(M)`.
"""
function corank(M::AbstractMatroid)
    return _corank(M)
end

"""
    fullrank(M)

Return the rank of the matroid `M`. Equivalent to `rank(M)`.
"""
function fullrank(M::AbstractMatroid)
    return rank(M)
end

"""
    fullcorank(M)

Return the corank of the matroid `M`. Equivalent to `corank(M)`.
"""
function fullcorank(M::AbstractMatroid)
    return corank(M)
end

"""
    rank(M, X)

Return the rank of the subset `X` in the matroid `M`. 
`X` shold be a subset of the groundset of `M`. 
"""
function rank(M::AbstractMatroid, X)
    if length(X) == 0
        return 0
    end
    return _rank(M, _subsetcheck(M, X))
end

"""
    basis(M)

Return an arbitrary basis of the matroid `M`.
"""
function basis(M::AbstractMatroid)
    return _maxindependent(M, _groundset(M))
end

"""
    maxindependent(M, X)

Return a maximal independent subset of `X` in matroid `M`.
`X` should be a subset of the groundset of `M`.
"""
function maxindependent(M::AbstractMatroid, X)
    return _maxindependent(M, _subsetcheck(M, X))
end

"""
    circuit(M)

Return a circuit of `M` if one exists. Otherwise raise an error.
"""
function circuit(M::AbstractMatroid)
    return _circuit(M, _groundset(M))
end

"""
    circuit(M, X)

Return a circuit of `M` contained in `X`. Otherwise raise an error.
`X` should be a subset of the groundset of `M`.
"""
function circuit(M::AbstractMatroid, X)
    return _circuit(M, _subsetcheck(M, X))
end

"""
    fundamentalcircuit(M, B, e)

Return the `B`-fundamental circuit using `e` in matroid `M`.
This is the unique matroid circuit contained in ``B \\cup e``.
`B` should be a basis of `M` and `e` should be an element of `M` not in `B`.
"""
function fundamentalcircuit(M::AbstractMatroid, B, e)
    if !isbasis(M, B)
        error("B is not a basis of the matroid")
    end
    if !(e in _groundset(M))
        error("e is not in the groundset")
    end
    return _fundamentalcircuit(M, B, e)
end

"""
    closure(M, X)

Return the closure of `X` in matroid `M`.
`X` should be a subset of the groundset of `M`.
"""
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

"""
    corank(M, X)

Return the corank of the subset `X` in the matroid `M`. 
`X` shold be a subset of the groundset of `M`. 
"""
function corank(M::AbstractMatroid, X)
    return _corank(M, _subsetcheck(M, X))
end

"""
    cobasis(M)

Return an arbitrary cobasis of the matroid `M`.
"""
function cobasis(M::AbstractMatroid)
    return _maxcoindependent(M, _groundset(M))
end

"""
    maxcoindependent(M, X)

Return a maximal coindependent subset of `X` in matroid `M`.
`X` should be a subset of the groundset of `M`.
"""
function maxcoindependent(M::AbstractMatroid, X)
    return _maxcoindependent(M, _subsetcheck(M, X))
end

"""
    coclosure(M, X)

Return the coclosure of `X` in matroid `M`.
`X` should be a subset of the groundset of `M`.
"""
function coclosure(M::AbstractMatroid, X)
    return _coclosure(M, _subsetcheck(M, X))
end

"""
    cocircuit(M)

Return a cocircuit of `M` if one exists. Otherwise raise an error.
"""
function cocircuit(M::AbstractMatroid)
    return _cocircuit(M, _groundset(M))
end

"""
    cocircuit(M, X)

Return a cocircuit of `M` contained in `X`. Otherwise raise an error.
`X` should be a subset of the groundset of `M`.
"""
function cocircuit(M::AbstractMatroid, X)
    return _cocircuit(M, _subsetcheck(M, X))
end

"""
    fundamentalcircuit(M, B, e)

Return the `B`-fundamental cocircuit using `e` in matroid `M`.
This is the unique matroid cocircuit that intersects `B` only at `e`.
`B` should be a basis of `M` and `e` should be an element of `M` not in `B`.
"""
function fundamentalcocircuit(M::AbstractMatroid, B, e)
    if !isbasis(M, B)
        error("B is not a basis of the matroid")
    end
    if !(e in B)
        error("e is not in B")
    end
    return _fundamentalcocircuit(M, B, e)
end

"""
    loops(M)

Return all the loops of the matroid `M`.
"""
function loops(M::AbstractMatroid)
    return _closure(M, [])
end

"""
    isindependent(M, X)

Test whether the subset `X` is independent in the matroid `M`.
`X` should be a subset of the groundset of `M`.
"""
function isindependent(M::AbstractMatroid, X)
    return _isindependent(M, _subsetcheck(M, X))
end

"""
    isdependent(M, X)

Test whether the subset `X` is dependent in the matroid `M`.
`X` should be a subset of the groundset of `M`.
"""
function isdependent(M::AbstractMatroid, X)
    return !_isindependent(M, _subsetcheck(M, X))
end

"""
    isbasis(M, X)

Test whether the subset `X` is a basis in the matroid `M`.
`X` should be a subset of the groundset of `M`.
"""
function isbasis(M::AbstractMatroid, X)
    return _isbasis(M, _subsetcheck(M, X))
end

"""
    isclosed(M, X)

Test whether the subset `X` is closed in the matroid `M`.
`X` should be a subset of the groundset of `M`.
"""
function isclosed(M::AbstractMatroid, X)
    return _isclosed(M, _subsetcheck(M, X))
end

"""
    iscircuit(M, X)

Test whether the subset `X` is a circuit in the matroid `M`.
`X` should be a subset of the groundset of `M`.
"""
function iscircuit(M::AbstractMatroid, X)
    return _iscircuit(M, _subsetcheck(M, X))
end

"""
    coloops(M)

Return all the coloops of the matroid `M`.
"""
function coloops(M::AbstractMatroid)
    return _coclosure(M, [])
end

"""
    iscoindependent(M, X)

Test whether the subset `X` is coindependent in the matroid `M`.
`X` should be a subset of the groundset of `M`.
"""
function iscoindependent(M::AbstractMatroid, X)
    return _iscoindependent(M, _subsetcheck(M, X))
end

"""
    iscodependent(M, X)

Test whether the subset `X` is codependent in the matroid `M`.
`X` should be a subset of the groundset of `M`.
"""
function iscodependent(M::AbstractMatroid, X)
    return !_iscoindependent(M, _subsetcheck(M, X))
end

"""
    iscobasis(M, X)

Test whether the subset `X` is a cobasis in the matroid `M`.
`X` should be a subset of the groundset of `M`.
"""
function iscobasis(M::AbstractMatroid, X)
    return _iscobasis(M, _subsetcheck(M, X))
end

"""
    iscocircuit(M, X)

Test whether the subset `X` is a cocircuit in the matroid `M`.
`X` should be a subset of the groundset of `M`.
"""
function iscocircuit(M::AbstractMatroid, X)
    return _iscocircuit(M, _subsetcheck(M, X))
end

"""
    iscoclosed(M, X)

Test whether the subset `X` is coclosed in the matroid `M`.
`X` should be a subset of the groundset of `M`.
"""
function iscoclosed(M::AbstractMatroid, X)
    return _iscoclosed(M, _subsetcheck(M, X))
end

"""
    circuits(M)

Return all the circuits of the matroid `M`.
"""
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

"""
    cocircuits(M)

Return all the cocircuits of the matroid `M`.
"""
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

"""
    circuitclosures(M)

Return all the circuit closures of the matroid `M`.
"""
function circuitclosures(M::AbstractMatroid)
    CC = [Set() for _ in 0:rank(M)]
    for C in circuits(M)
        push!(CC[length(C)], Set(closure(M, C)))
    end
    out = Dict{Int, Vector}(r=>[collect(c) for c in CC[r+1]] 
                            for r in 1:rank(M) if !isempty(CC[r+1]))
    return out
end

"""
    bases(M)

Return all the bases of the matroid `M`.
"""
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

"""
    nonbases(M)

Return all the nonbases of the matroid `M`.
"""
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

"""
    independentsets(M)

Return all the independent sets of the matroid `M`.
"""
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

"""
    flats(M, r)

Return all the flats of rank `r` in the matroid `M`.
"""
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
"""
    isvalidmatroid(M)

Test whether `M` is a valid matroid, i.e. it satisfies the matroid axioms.
"""
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