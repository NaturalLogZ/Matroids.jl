using Matroids
using Test




m = Matroids.Catalog.Fano()
@test size(m) == 7


include("catalog.jl")
include("isomorphism.jl")
include("interface.jl")