module Matroids

import Combinatorics: combinations
import AbstractAlgebra
import Nemo

export AbstractMatroid, BasisMatroid, LinearMatroid, Matroid,

groundset, size, rank, corank, fullrank, fullcorank,

basis, maxindependent, circuit, fundamentalcircuit, closure,
cobasis, maxcoindependent, cocircuit, coclosure, fundamentalcocircuit,
loops, isindependent, isdependent, isbasis, isclosed, iscircuit,
coloops, iscoindependent, iscodependent, iscobasis, iscoclosed, iscocircuit,

circuits, cocircuits, circuitclosures, bases, nonbases, independentsets, 
flats, 

isvalidmatroid,


# below are not done yet.
coflats, hyperplanes, brokencircuits,


isisomorphic, equals,

contract, delete, dual, hasminor,

tuttepolynomial


"""
    AbstractMatroid

An abstract type representing a matroid.
"""
abstract type AbstractMatroid{T} end



# We will want to do some sort of checking to make sure all the things
# are implemented. (See LightGraphs interface.jl)


include("./utils.jl")
include("./core.jl")


# Each specific matroid implementation only needs to define
# a constructor, _groundset(M) and _rank(M, X).
# However, it is probably good to redefine some other things
# (like validity) for speed purposes.
include("./basismatroid.jl")
include("./linearmatroid.jl")




# Put all matroid implementations before here
# TODO: convert inputs to vectors properly, or do type validation.
"""
    Matroid(groundset=nothing, data=nothing; kwargs...)

Construct a matroid.

You will need to provide a graph or a matrix as `data`, or
one of the optional kwargs.

# Arguments
- `groundset` : labels for the groundset of the matroid
- `data` : a matrix or a graph
- `bases` : optional; the set of bases of the matroid
- `independentsets` : optional; the set of the independent sets of the matroid
- `circuits` : optional; the set of circuits of the matroid
- `matroid` : optional; an existing matroid
"""
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

    return M

end



# Put other complicated things after...
include("./interface.jl")
include("./catalog.jl")

end