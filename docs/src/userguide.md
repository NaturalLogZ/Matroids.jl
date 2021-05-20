# User Guide

---


Load the package:

```@repl userguide
using Matroids
```

To create a matroid, we do not need to call any specific matroid, we can simply call the general matroid constructor:

```@repl userguide
M1 = Matroid("abcd", bases=["ab", "ac"])
M2 = Matroid("abcd", circuitclosures=Dict(2 => ["abcd"]))
M3 = Matroid([(0,0), (0,1), (0,2), (0,3), (1,2), (1,3)])
M4 = Matroid([1 0 0 2; 0 1 0 1; 0 0 1 1])
```

We can also use matroids from the [Catalog](@ref):

```@repl userguide
M5 = Matroids.Catalog.Fano()
M6 = Matroids.Catalog.Uniform(2,4)
```

Then, we can call some basic functions on the matroids:

```@repl userguide
isvalidmatroid(M1)
circuits(M2)
independentsets(M3)
isisomorphic(M2, M6)
isisomorphic(M1, M2)
```

See other functions in the [Library](@ref).