module Matroids


export AbstractMatroid, BasisMatroid,

rank, groundset, size, corank,

isvalid,

circuits, cocircuits, bases, nonbases,
flats, coflats, hyperplanes, brokencircuits,

loops, coloops,

isisomorphic, equals,

contract, delete, dual, hasminor,

tuttepolynomial





# We will want to do some sort of checking to make sure all the things
# are implemented. (See LightGraphs interface.jl)

include("./interface.jl")
include("./utils.jl")

include("./basismatroid.jl")

end
