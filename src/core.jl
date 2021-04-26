
# For functions that don't depend on implementation

size(M::AbstractMatroid) = length(groundset(M))

corank(M::AbstractMatroid) = size(M) - rank(M)

function rank(M::AbstractMatroid, X::Vector)
    if length(X) == 0
        return 0
    end
    if !issubset(X, groundset(M))
        error("X is not a subset of the groundset")
    end
    return _rank(M, X)
end

function bases(M::AbstractMatroid)
    E = groundset(M)
    r = rank(M)

    allbases = Vector()
    for X in combinations(E, r)
        if _rank(M, X) == length(X)
            push!(allbases, X)
        end
    end
    return allbases
end

function nonbases(M::AbstractMatroid)
    E = groundset(M)
    r = rank(M)

    allnonbases = Vector()
    for X in combinations(E, r)
        if _rank(M, X) < length(X)
            push!(allnonbases, X)
        end
    end
    return allnonbases
end 

"""
returns a maximal independent subset of X in M.
does no checking
"""
function _maxindependent(M::AbstractMatroid, X::Vector)
    out = Vector()
    r = 0
    for el in X
        push!(out, el)
        if _rank(M, out) > r
            r += 1
        else
            pop!(out)
        end
    end
    return out
end

"""
returns a minimal dependent subset of X in M.
does no checking
"""
function _circuit(M::AbstractMatroid, X::Vector)
    if _isindependent(M, X)
        error("no circuit in independent set")
    end
    Z = Set(X)
    l = length(X) - 1
    for el in X
        delete!(Z, el)
        if _rank(M, collect(Z)) == l
            push!(Z, el)
        else
            l -= 1
        end
    end
    return collect(Z)
end

"""
return the fundamental circuit for basis B & element e
does no input checking
"""
function _fundamentalcircuit(M::AbstractMatroid, B::Vector, e)
    return _circuit(M, union(B, [e]))
end

"""
return closure of a set in M
no input checking
"""
function _closure(M::AbstractMatroid, X::Vector)
    out = copy(X)
    r = _rank(M, X)
    Y = setdiff(groundset(M), X)
    for el in Y
        push!(out, el)
        if _rank(M, out) > r
            pop!(out)
        end
    end
    return out
end


"""
return corank of a subset
no input checking
"""
function _corank(M::AbstractMatroid, X::Vector)
    return length(X) + _rank(M, setdiff(groundset(M), X)) - rank(M)
end

function _maxcoindependent(M::AbstractMatroid, X::Vector)
    out = Vector()
    r = 0
    for el in X
        push!(out, el)
        if _corank(M, out) > r
            r += 1
        else
            pop!(out)
        end
    end
    return out
end

function _cocircuit(M::AbstractMatroid, X::Vector)
    if _iscoindependent(M, X)
        error("no cocircuit in coindependent set")
    end
    Z = Set(X)
    l = length(X) - 1
    for el in X
        delete!(Z, el)
        if _corank(M, collect(Z)) == l
            push!(Z, el)
        else
            l -= 1
        end
    end
    return collect(Z)
end

function _fundamentalcocircuit(M::AbstractMatroid, B::Vector, e)
    return _cocircuit(M, union(setdiff(groundset(M), B), [e]))
end

function _coclosure(M::AbstractMatroid, X::Vector)
    out = copy(X)
    Y = setdiff(groundset(M), X)
    r = _corank(M, X)
    for el in Y
        push!(out, el)
        if _corank(M, out) > r
            pop!(out)
        end
    end
    return out
end

function _isindependent(M::AbstractMatroid, X::Vector)
    return length(X) == _rank(M, X)
end

function _iscoindependent(M::AbstractMatroid, X::Vector)
    return _corank(M, X) == length(X)
end

function _isbasis(M::AbstractMatroid, X::Vector)
    if rank(M) == length(X)
        return _isindependent(M, X)
    end
    return false
end

function _iscobasis(M::AbstractMatroid, X::Vector)
    return _isbasis(setdiff(groundset(M), X))
end

function _iscircuit(M::AbstractMatroid, X::Vector)
    l = length(X) - 1
    if _rank(M, X) != l
        return false
    end
    for el in X
        if _rank(M, setdiff(X, [el])) < l
            return false
        end
    end
    return true
end

function _iscocircuit(M::AbstractMatroid, X::Vector)
    l = length(X) - 1
    if _corank(M, X) != l
        return false
    end
    for el in X
        if _corank(M, setdiff(X, [el])) < l
            return false
        end
    end
    return true
end

function _isclosed(M::AbstractMatroid, X::Vector)
    X2 = copy(X)
    Y = setdiff(groundset(M), X)
    r = _rank(M, X)
    for el in Y
        push!(X2, el)
        if _rank(M, X2) == r
            return false
        end
        pop!(X2)
    end
    return true
end

function _iscoclosed(M::AbstractMatroid, X::Vector)
    X2 = copy(X)
    Y = setdiff(groundset(M), X)
    r = _corank(M, X)
    for el in Y
        push!(X2, el)
        if _corank(M, X2) == r
            return false
        end
        pop!(X2)
    end
    return true
end


# TODO: - should override this based on implementation
# if we care about speed. (and accuracy...)
function isvalidmatroid(M::AbstractMatroid)
    E = groundset(M)
    for i in 0:size(M)
        for X in combinations(E, i)
            rX = _rank(M, X)
            if rX > i
                return false
            end
            for j in 0:size(M)
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