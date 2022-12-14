mutable struct LinearMatroid{T} <: AbstractMatroid{T}
    groundset::Vector{T}
    rank::Int
    A::AbstractAlgebra.MatrixElem
    prow::Dict{Int,Int}
    elmap::Dict{T,Int}
    basis::Vector{Int}

    # In the future, maybe add support for reduced matrix and keep orig. repr.

    function LinearMatroid{T}(matrix::Union{Array{W,2}, AbstractAlgebra.MatrixElem}; 
        groundset::Union{Vector{T}, Nothing}=nothing,
        field::Union{String, Nothing, AbstractAlgebra.Field}=nothing,
        M::Union{LinearMatroid, Nothing}=nothing) where T where W

        if !isnothing(M)
            gs = deepcopy(M.groundset)
            rank = M.rank
            A = copy(M.A)
            prow = copy(M.prow)
            elmap = copy(M.elmap)
            basis = copy(M.basis)
            return new{T}(gs, rank, A, prow, elmap, basis)
        end

        P = Vector{Int}()
        if isnothing(field) && (typeof(matrix) <: Array)
            field = ""
        end
        if (typeof(field) <: String)
            field = stringtofield(field)
        end

        # First convert to field version
        if typeof(matrix) <: Array
            _matrix = AbstractAlgebra.matrix(field, matrix)
        else
            if !(typeof(AbstractAlgebra.base_ring(matrix)) <: AbstractAlgebra.Field)
                error("base ring of matrix should be a field")
            end
            _matrix = matrix
        end

        
        # Compute A
        rref = AbstractAlgebra.rref(_matrix)
        stdrref = Matrix(rref[2])
        
        for i in 1:rref[1]
            push!(P, findfirst(!iszero, stdrref[i,:]))
        end
        fieldA = _matrix[1:rref[1],[c for c in 1:size(_matrix,2) if !(c in P)]]

        # And compute prow
        prow = Dict{Int,Int}()
        for r in 1:length(P)
            prow[P[r]] = r
        end
        r = 1
        for c in 1:size(_matrix,2)
            if !(c in P)
                prow[c] = r
                r += 1
            end
        end

        # Figure out groundset if not provided
        if isnothing(groundset)
            groundset = collect(1:size(fieldA,1)+size(fieldA,2))
        else
            if length(groundset) != size(fieldA,1)+size(fieldA,2)
                error("size of groundset doesn't match matrix")
            end
        end

        rank = length(P)

        idxs = Dict{T,Int}()
        for i in 1:length(groundset)
            idxs[groundset[i]] = i
        end

        return new{T}(deepcopy(groundset), rank, fieldA, prow, idxs, P)
    end

end

function LinearMatroid(matrix::Union{Array{W,2}, AbstractAlgebra.MatrixElem}; 
    groundset::Union{Vector{T}, Nothing}=nothing,
    field::Union{String, Nothing, AbstractAlgebra.Field}=nothing,
    M::Union{LinearMatroid, Nothing}=nothing) where T where W

    if isnothing(groundset)
        return LinearMatroid{Int64}(matrix,groundset=groundset,field=field,M=M)
    end

    return LinearMatroid{T}(matrix,groundset=groundset,field=field,M=M)
end

function stringtofield(string::String)
    # The following are the list of supported fields
    if string == ""
        return AbstractAlgebra.RealField
    elseif string == "QQ"
        # This can have some really weird numerical precision problems...
        # I would say avoid. (M.A can become filled with MB sized fractions)
        return AbstractAlgebra.QQ
    elseif string == "RR"
        return AbstractAlgebra.RealField
    elseif string[1:2] == "GF"
        # Note this only supports finite fields of prime order.
        # If you want other finite fields; generate the matrix of them
        # yourself using Nemo.jl
        return AbstractAlgebra.GF(parse(Int,string[3:end]))
    end

    error("field is unrecognized")
end


_rank(M::LinearMatroid) = M.rank
_groundset(M::LinearMatroid) = M.groundset

"""Super specific ==. almost any function will modify
equality result. """
==(M::LinearMatroid, N::LinearMatroid) = 
M.groundset == N.groundset &&
M.rank == N.rank &&
M.A == N.A &&
M.prow == N.prow

function copy(M::LinearMatroid)
    N = LinearMatroid{eltype(M.groundset)}(M.A, M=M)
    return N
end

function _rank(M::LinearMatroid, X::Vector)
    packedinput = packset(X, M.elmap)
    # then find max indep set

    currentbasis = BitSet(M.basis)
    inside = setdiff(currentbasis, packedinput)
    outside = setdiff(packedinput, currentbasis)

    # then __move
    for x in inside
        for y in outside
            # this corresponds to __is_exchange_pair(x,y)
            if !iszero(M.A[M.prow[x],M.prow[y]])

                px = M.prow[x]
                py = M.prow[y]
                piv = M.A[px,py]
                pivi = piv ^ (-1)

                AbstractAlgebra.multiply_row!(M.A, pivi, px)
                M.A[px, py] = pivi + one(first(M.A))

                for r in 1:size(M.A, 1)
                    a = M.A[r, py]
                    if !iszero(a) && (r != px)
  
                        AbstractAlgebra.add_row!(M.A, -a, px, r)
                    end
                end
                M.A[px, py] = pivi
                M.prow[y] = px
                M.prow[x] = py

                delete!(currentbasis, x)
                push!(currentbasis, y)
                
                delete!(inside, x)
                delete!(outside, y)
                break
            end
        end
    end
    #
    M.basis = collect(currentbasis)
    return length(intersect(currentbasis, packedinput))

end

# All linear matroids (defined on fields) are valid!
isvalidmatroid(M::LinearMatroid) = true