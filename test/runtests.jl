using Matroids
using Test




m = Matroids.Catalog.Fano()
@test size(m) == 7