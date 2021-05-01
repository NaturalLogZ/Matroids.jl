mutable struct RankMatroid{T} <: AbstractMatroid{T}
    groundset::Vector{T}
    rankfunction::Function



    function RankMatroid{T}(groundset::Vector{T},
        rankfunction::Function) where T



        return new{T}(deepcopy(groundset), rankfunction)
    end

end

function RankMatroid(groundset::Vector{T}, 
    rankfunction::Function) where T

    return RankMatroid{T}(groundset, rankfunction)
end

function _groundset(M::RankMatroid)
    return M.groundset
end

function _rank(M::RankMatroid, X::Vector)
    return M.rankfunction(X)
end