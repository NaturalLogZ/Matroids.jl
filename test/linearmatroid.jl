@testset "linearmatroid" begin
	mtx = [1 0 0 0 1 1 1; 0 1 0 1 0 1 1; 0 0 1 1 1 0 1]
	M1 = Matroids.LinearMatroid(mtx)
	M2 = Matroids.LinearMatroid(M1)
	@test string(M1) == "Matroid of rank 3 on 7 elements represented as a matrix."
	@test M1 == M2
	@test isvalidmatroid(M1)


end