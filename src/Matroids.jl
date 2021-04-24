module Matroids

import Combinatorics: combinations

export AbstractMatroid, BasisMatroid, Matroid,

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




# Put all matroid implementations before here

function Matroid(groundset=nothing, data=nothing; kwargs...)
    if isnothing(data)
        if :bases in keys(kwargs)
            bases = kwargs[:bases]
            if isnothing(groundset)
                groundset = Vector()
                for b in bases
                    union!(groundset, b)
                end
            end
            M = BasisMatroid(groundset=groundset, bases=bases)
            
        elseif :independentsets in keys(kwargs)
            isets = kwargs[:independentsets]

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

        elseif :circuits in keys(kwargs)
            circuits = kwargs[:circuits]

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

        end

    end

    # TODO: handle empty input.

    return M

end



# Put other complicated things after...
include("./catalog.jl")

end