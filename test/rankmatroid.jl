@testset "rankmatroid" begin
	gs = collect("abcd")
	function r1(X)
		rank = length(X)
		if issubset(['a','b','c'], X)
			rank -= 1
		end
	end
	M1 = Matroids.RankMatroid(gs, r1)
	M2 = copy(M1)
	@test string(M1) == "Matroid of rank 3 on 7 elements represented as a rank function."
	@test M1 == M2
	


end