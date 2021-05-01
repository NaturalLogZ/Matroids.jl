mutable struct CircuitClosuresMatroid{T} <: AbstractMatroid{T}
    groundset::Vector{T}
    circuitclosures::Dict{Int, Vector{Vector{T}}}


    function CircuitClosuresMatroid{T}(;M::Union{AbstractMatroid{T}, Nothing}=nothing, 
        groundset::Union{Vector{T}, Nothing}=nothing, 
        circuitclosures::Union{Dict{Int, Vector{Vector{T}}}, Nothing}=nothing) where T

        if !isnothing(M)
            groundset = Matroids.groundset(M)
            circuitclosures = Matroids.circuitclosures(M)
        else
            if isnothing(groundset) || isnothing(circuitclosures)
                error("need to provide both groundset and circuitclosures")
            end
        end
        return new{T}(deepcopy(groundset), deepcopy(circuitclosures))
    end
end

function CircuitClosuresMatroid(;M::Union{AbstractMatroid{T}, Nothing}=nothing, 
    groundset::Union{Vector{T}, Nothing}=nothing, 
    circuitclosures::Union{Dict{Int, Vector{Vector{T}}}, Nothing}=nothing) where T
    
    return CircuitClosuresMatroid{T}(M=M, groundset=groundset, circuitclosures=circuitclosures)
end

function _groundset(M::CircuitClosuresMatroid)
    return M.groundset
end

function _rank(M::CircuitClosuresMatroid, X::Vector)
    I = Set(X)
    for r in sort(collect(keys(M.circuitclosures)))
        if isempty(I)
            break
        end
        for C in M.circuitclosures[r]
            if isempty(I)
                break
            end
            S = intersect(I, C)
            while length(S) > r
                delete!(I, pop!(S))
            end
        end
    end
    return length(I)
end