@testset "interface" begin
    M = Matroids.Catalog.Block_10_5()
    X1 = []
    X2 = collect("abcdefghij")
    X3 = collect("abfi")
    X4 = collect("abcde")
    X5 = collect("beghij")
    X6 = ['x']

    @test size(M) == 10
    @test sort(groundset(M)) == collect("abcdefghij")
    @test eltype(M) == Char
    @test rank(M) == 5
    @test fullrank(M) == 5
    @test corank(M) == 5
    @test fullcorank(M) == 5

    @test rank(M, X1) == 0
    @test rank(M, X2) == 5
    @test rank(M, X3) == 4
    @test rank(M, X4) == 4
    @test rank(M, X5) == 5
    @test_throws Exception rank(M, X6)

    @test length(basis(M)) == 5
    @test rank(M, basis(M)) == 5

    res = maxindependent(M, X5)
    @test isindependent(M, res)
    @test all([isdependent(M, union(res, [y])) for y in setdiff(X5, res)])
    @test_throws Exception maxindependent(M, X6)

    @test isdependent(M, circuit(M))
    @test_throws Exception circuit(M, X3)
    @test sort(circuit(M, collect("abcdef"))) == collect("abcde")
    
    @test sort(fundamentalcircuit(M, collect("abcdf"), 'e')) == collect("abcde")
    @test_throws Exception fundamentalcircuit(M, X4, 'e')
    @test_throws Exception fundamentalcircuit(M, collect("abcdf"), 'x')

    @test sort(closure(M, collect("abcd"))) == collect("abcde")
    @test_throws Exception closure(M, X6)

    @test corank(M, X1) == 0
    @test corank(M, X2) == 5
    @test corank(M, X3) == 4
    @test corank(M, X4) == 5
    @test corank(M, X5) == 5
    @test_throws Exception corank(M, X6)

    @test length(cobasis(M)) == 5
    @test corank(M, cobasis(M)) == 5

    res = maxcoindependent(M, X5)
    @test iscoindependent(M, res)
    @test all([iscodependent(M, union(res, [y])) for y in setdiff(X5, res)])
    @test_throws Exception maxcoindependent(M, X6)

    @test sort(coclosure(M, collect("abcd"))) == collect("abcdh")
    @test_throws Exception coclosure(M, X6)

    @test iscodependent(M, cocircuit(M))
    @test_throws Exception cocircuit(M, X3)
    @test sort(cocircuit(M, collect("abcdef"))) == collect("abdef")
    
    @test sort(fundamentalcocircuit(M, collect("abcdf"), 'a')) == collect("aegij")
    @test_throws Exception fundamentalcocircuit(M, X4, 'e')
    @test_throws Exception fundamentalcocircuit(M, collect("abcdf"), 'x')

    @test loops(M) == []
    m2 = Matroid("abcd", ["ab","ac"])
    @test loops(m2) == ['d']

end