@testset "isomorphism" begin
	M1 = Matroids.Catalog.Fano()
	M2 = Matroids.Catalog.NonFano()
	gs = [0,1,2,3,4,5,6]
	ccs = Dict(2=>[[0,1,3], [0,2,4], [1,2,5], [0,5,6], [1,4,6], [2,3,6], [3,4,5]], 3=>[[0,1,2,3,4,5,6]])
	M3 = Matroids.CircuitClosuresMatroid(groundset=gs, circuitclosures=ccs)
	@test !isisomorphic(M1, M2)
	@test !(M1 == M3)
	@test isisomorphic(M1, M3)


end