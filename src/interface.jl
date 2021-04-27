"""
Contains the public facing methods.
Some may be overridden by specific matroid implemenations.
"""


function groundset(M::AbstractMatroid)
    return _groundset(M)
end

function size(M::AbstractMatroid)
    return _size(M)
end

function rank(M::AbstractMatroid)
    return _rank(M)
end

function rank(M::AbstractMatroid, X::Vector)
    if length(X) == 0
        return 0
    end
    _subsetcheck(M, X)
    return _rank(M, X)
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