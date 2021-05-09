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

    @test isindependent(M, X1) == true
    @test isindependent(M, X2) == false
    @test isindependent(M, X3) == true
    @test_throws Exception isindependent(M, X6)

    @test isdependent(M, X1) == false
    @test isdependent(M, X2) == true
    @test isdependent(M, X3) == false
    @test_throws Exception isindependent(M, X6)

    @test isbasis(M, X1) == false
    @test isbasis(M, X2) == false
    @test isbasis(M, X3) == false
    @test isbasis(M, "abcdf") == true
    @test_throws Exception isbasis(M, X6)

    @test isclosed(M, X1) == true
    @test isclosed(M, X2) == true
    @test isclosed(M, X3) == false
    @test isclosed(M, X4) == true
    @test_throws Exception isclosed(M, X6)

    @test iscircuit(M, X1) == false
    @test iscircuit(M, X2) == false
    @test iscircuit(M, X4) == true
    @test_throws Exception iscircuit(M, X6)

    @test coloops(M) == []
    @test coloops(m2) == ['a']

    @test iscoindependent(M, X1) == true
    @test iscoindependent(M, X2) == false
    @test iscoindependent(M, X3) == true
    @test iscoindependent(M, X4) == true
    @test_throws Exception iscoindependent(M, X6)

    @test iscodependent(M, X1) == false
    @test iscodependent(M, X2) == true
    @test iscodependent(M, X3) == false
    @test iscodependent(M, X4) == false
    @test_throws Exception iscodependent(M, X6)

    @test iscobasis(M, X1) == false
    @test iscobasis(M, X2) == false
    @test iscobasis(M, X3) == false
    @test iscobasis(M, X4) == true
    @test_throws Exception iscobasis(M, X6)

    @test iscocircuit(M, X1) == false
    @test iscocircuit(M, X2) == false
    @test iscocircuit(M, X4) == false
    @test iscocircuit(M, "abcdh") == true
    @test_throws Exception iscocircuit(M, X6)

    @test iscoclosed(M, X1) == true
    @test iscoclosed(M, X2) == true
    @test iscoclosed(M, X3) == false
    @test iscoclosed(M, X4) == false
    @test iscoclosed(M, "abcdh") == true
    @test_throws Exception iscoclosed(M, X6)

    res = circuits(M)
    @test length(res) == 66
    @test sort([sort(c) for c in res])[13] == collect("abdhi")

    res = cocircuits(M)
    @test length(res) == 66
    @test sort([sort(c) for c in res])[13] == collect("abdij")

    res = circuitclosures(M)
    @test length(res[4]) == 36
    @test length(res[5]) == 1
    @test sort([sort(c) for c in res[4]])[13] == collect("acfhi")

    res = bases(M)
    @test length(res) == 216
    @test sort([sort(c) for c in res])[113] == collect("bcdej")

    res = nonbases(M)
    @test length(res) == 36
    @test sort([sort(c) for c in res])[13] == collect("acfhi")

    res = independentsets(M)
    @test length(res) == 602
    @test sort([sort(c) for c in res])[113] == collect("acefi")

    res = flats(M, 2)
    @test length(res) == 45
    @test sort([sort(c) for c in res])[13] == collect("bf")
    @test length(flats(M, 5)) == 1
    @test length(flats(M, 4)) == 66


end