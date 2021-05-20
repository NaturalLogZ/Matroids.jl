@testset "circuitclosuresmatroid" begin
	gs = collect("abcd")
	function r1(X)
		rank = length(X)
		if issubset(['a','b','c'], X)
			rank -= 1
		end
	end
	M1 = Matroids.RankMatroid(gs, r1)
	M2 = Matroids.CircuitClosuresMatroid(M=M1)
	M3 = Matroids.CircuitClosuresMatroid(groundset=collect("abcd"), circuitclosures=Dict(2=>[collect("abc")], 3=>[collect("abcd")]))
	@test string(M1) == "Matroid of rank 3 on 4 elements represented as a rank function."
	@test string(M2) == "Matroid of rank 3 on 4 elements represented as circuit closures."
	@test string(M3) == "Matroid of rank 3 on 4 elements represented as circuit closures."
	@test M3 == M2
	


end