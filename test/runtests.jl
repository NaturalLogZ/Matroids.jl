using Matroids
using Test




m = Matroids.Catalog.Fano()
@test size(m) == 7


include("catalog.jl")
include("interface.jl")