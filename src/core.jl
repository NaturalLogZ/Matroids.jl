
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


# TODO: - should override this based on implementation
# if we care about speed.
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