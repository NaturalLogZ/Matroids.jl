mutable struct LinearMatroid{T} <: AbstractMatroid{T}
    groundset::Vector{T}
    rank::Int
    ring::AbstractAlgebra.Ring
    A::AbstractAlgebra.MatrixElem
    prow::Dict{Int,Int}
    elmap::Dict{T,Int}
    repr::Union{AbstractAlgebra.MatrixElem, Nothing}


    # In the future, maybe add support for reduced matrix.

    function LinearMatroid{T}(matrix::Union{Array{W,2}, AbstractAlgebra.MatrixElem}; 
        groundset::Union{Vector{T}, Nothing}=nothing,
        ring::Union{String, Nothing, AbstractAlgebra.Ring}=nothing, 
        keepinitialrepresentation::Bool=true) where T where W

        

        P = Vector{Int}()
        if isnothing(ring)
            ring = ""
        end
        if (typeof(ring) <: String)
            ring = stringtoring(ring)
        end

        # First convert to ring version
        if typeof(matrix) <: Array
            _matrix = AbstractAlgebra.matrix(ring, matrix)
        else
            _matrix = matrix
            matrix = Matrix(_matrix)
        end

        repr = nothing
        if keepinitialrepresentation
            repr = copy(_matrix)
        end
        
        # Compute A
        rref = AbstractAlgebra.rref(_matrix)
        stdrref = Matrix(rref[2])
        
        for i in 1:rref[1]
            push!(P, findfirst(!iszero, stdrref[i,:]))
        end
        A = matrix[1:rref[1],[c for c in 1:Base.size(matrix,2) if !(c in P)]]
        ringA = AbstractAlgebra.matrix(ring, A)

        # And compute prow
        prow = Dict{Int,Int}()
        for r in 1:length(P)
            prow[P[r]] = r
        end
        r = 1
        for c in 1:Base.size(matrix,2)
            if !(c in P)
                prow[c] = r
                r += 1
            end
        end

        # Figure out groundset if not provided
        if isnothing(groundset)
            groundset = collect(1:Base.size(A,1)+Base.size(A,2))
        else
            if length(groundset) != Base.size(A,1)+Base.size(A,2)
                error("size of groundset doesn't match matrix")
            end
        end

        rank = length(P)

        idxs = Dict{T,Int}()
        for i in 1:length(groundset)
            idxs[groundset[i]] = i
        end

        return new{T}(groundset,rank,ring,ringA,prow,idxs)
    end

end

function LinearMatroid(matrix::Union{Array{W,2}, AbstractAlgebra.MatrixElem}; 
    groundset::Union{Vector{T}, Nothing}=nothing,
    ring::Union{String, Nothing, AbstractAlgebra.Ring}=nothing, 
    keepinitialrepresentation::Bool=true) where T where W

    if isnothing(groundset)
        return LinearMatroid{Int64}(matrix,groundset=groundset,ring=ring,keepinitialrepresentation=keepinitialrepresentation)
    end

    return LinearMatroid{T}(matrix,groundset=groundset,ring=ring,keepinitialrepresentation=keepinitialrepresentation)
end

function stringtoring(string::String)
    # The following are the list of supported rings
    if string == ""
        return AbstractAlgebra.ZZ
    elseif string == "ZZ"
        return AbstractAlgebra.ZZ
    elseif string == "QQ"
        return AbstractAlgebra.QQ
    elseif string == "RR"
        return AbstractAlgebra.RealField
    elseif string[1:2] == "GF"
        return AbstractAlgebra.GF(parse(Int,string[3:end]))
    end

    error("ring is unrecognized")
end