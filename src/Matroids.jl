module Matroids

import Combinatorics: combinations
import AbstractAlgebra
import Nemo

export AbstractMatroid, BasisMatroid, LinearMatroid, Matroid,

rank, groundset, size, corank,

isvalidmatroid,

circuits, cocircuits, bases, nonbases,
flats, coflats, hyperplanes, brokencircuits,

loops, coloops,

isisomorphic, equals,

contract, delete, dual, hasminor,

tuttepolynomial,


# temp
_rank





# We will want to do some sort of checking to make sure all the things
# are implemented. (See LightGraphs interface.jl)

include("./interface.jl")
include("./utils.jl")
include("./core.jl")

include("./basismatroid.jl")
include("./linearmatroid.jl")




# Put all matroid implementations before here

function Matroid(groundset=nothing, data=nothing; kwargs...)
    key = nothing
    if isnothing(data)
        for k in [:bases, :independentsets, :circuits, :graph, :matrix, :rankfunction, :circuitclosure, :matroid]
            if k in keys(kwargs)
                data = kwargs[k]
                key = k
                break
            end
        end
        if isnothing(key)
            data = groundset
            groundset = nothing
        end
    end

    if isnothing(key)
        # check the data type and set appropriate things to key.

        # TODO: graph
        if isnothing(data)
            error("no input data to matroid")
        elseif typeof(data) <: AbstractMatroid
            key = :matroid
        elseif typeof(data) <: Union{Array{W,2}, AbstractAlgebra.MatrixElem} where W
            key = :matrix
        elseif typeof(data) <: Nothing # Graph here
            key = :graph
        else
            key = :independentsets
        end
    end


    if key == :bases
        bases = data
        if isnothing(groundset)
            groundset = Vector()
            for b in bases
                union!(groundset, b)
            end
        end
        M = BasisMatroid(groundset=groundset, bases=bases)
        
    elseif key == :independentsets
        isets = data

        rk = -1

        if isnothing(groundset)
            groundset = Vector()
            for i in isets
                union!(groundset, i)
            end
        end

        # cast a type so stuff doesn't mess up so badly.
        if eltype(eltype(isets)) == Any
            isets = convert(Vector{Vector{eltype(groundset)}}, isets)
        end
        for iset in isets
            if length(iset) == rk
                push!(bases, iset)
            elseif length(iset) > rk
                bases = [iset]
                rk = length(iset)
            end
        end
        
        M = BasisMatroid(groundset=groundset, bases=bases)

    elseif key == :circuits
        circuits = data

        if isnothing(groundset)
            groundset = Vector()
            for c in circuits
                union!(groundset, c)
            end
        end

        # construct a basis element to determine rank
        b = Set(groundset)
        for circuit in circuits
            int = intersect(b, circuit)
            if length(int) >= length(circuit)
                delete!(b, pop!(int))
            end
        end
        rk = length(b)

        # try the comprehension
        bases = [candidate for candidate in combinations(groundset, rk) if !any(circuit->issubset(circuit, candidate), circuits)]
        M = BasisMatroid(groundset=groundset, bases=bases)
    
    elseif key == :matrix
        mtx = data
        if !(typeof(data) <: Union{Array{W,2}, AbstractAlgebra.MatrixElem} where W)
            error("cannot recognize matrix")
        end
        field = nothing
        if :field in keys(kwargs)
            field = kwargs[:field]
        end
        
        if !isnothing(groundset)
            if length(groundset) != Base.size(mtx, 2)
                error("groundset doesn't match matrix size")
            end
        end
        
        M = LinearMatroid(mtx, groundset=groundset, field=field)

    elseif key == :matroid
        if !(typeof(data) <: AbstractMatroid)
            error("not a matroid")
        end
        M = data
    end


    # TODO: handle empty input.

    return M

end



# Put other complicated things after...
include("./catalog.jl")

end