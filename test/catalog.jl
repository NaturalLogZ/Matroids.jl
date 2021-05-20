@testset "catalog" begin
    @test string(Matroids.Catalog.Fano()) == "Matroid of rank 3 on 7 elements represented as a matrix."
	@test string(Matroids.Catalog.Q6()) == "Matroid of rank 3 on 6 elements represented as a matrix."
	@test string(Matroids.Catalog.R6()) == "Matroid of rank 3 on 6 elements represented as a matrix."
	# @test Matroids.Catalog.Q6() != Matroids.Catalog.R6() # != isn't really what we want to test
	@test string(Matroids.Catalog.NonFano()) == "Matroid of rank 3 on 7 elements represented as a matrix."
	@test string(Matroids.Catalog.Pappus()) == "Matroid of rank 3 on 9 elements represented as circuit closures."
	@test string(Matroids.Catalog.Block_10_5()) == "Matroid of rank 5 on 10 elements represented as circuit closures."
	@test string(Matroids.Catalog.Uniform(2,4)) == "Matroid of rank 2 on 4 elements represented as circuit closures."
	@test string(Matroids.Catalog.Uniform(4,4)) == "Matroid of rank 4 on 4 elements represented as circuit closures."
	@test string(Matroids.Catalog.Uniform(6,4)) == "Matroid of rank 4 on 4 elements represented as circuit closures."

end