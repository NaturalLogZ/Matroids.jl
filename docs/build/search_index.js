var documenterSearchIndex = {"docs":
[{"location":"library.html#Library","page":"Library","title":"Library","text":"","category":"section"},{"location":"library.html","page":"Library","title":"Library","text":"","category":"page"},{"location":"library.html","page":"Library","title":"Library","text":"CurrentModule = Matroids","category":"page"},{"location":"library.html#Module","page":"Library","title":"Module","text":"","category":"section"},{"location":"library.html","page":"Library","title":"Library","text":"Matroids","category":"page"},{"location":"library.html#Matroids.Matroids","page":"Library","title":"Matroids.Matroids","text":"Matroids\n\nA Julia package for matroids.\n\nThe basic constructor is Matroid.\n\n\n\n\n\n","category":"module"},{"location":"library.html","page":"Library","title":"Library","text":"Order = [:type, :function]\r\nPages = [\"library.md\"]","category":"page"},{"location":"library.html#Types","page":"Library","title":"Types","text":"","category":"section"},{"location":"library.html","page":"Library","title":"Library","text":"AbstractMatroid","category":"page"},{"location":"library.html#Matroids.AbstractMatroid","page":"Library","title":"Matroids.AbstractMatroid","text":"AbstractMatroid\n\nAn abstract type representing a matroid.\n\n\n\n\n\n","category":"type"},{"location":"library.html#Functions","page":"Library","title":"Functions","text":"","category":"section"},{"location":"library.html","page":"Library","title":"Library","text":"Modules = [Matroids]\r\nOrder = [:function]\r\nPages = [\r\n    \"Matroids.jl\",\r\n    \"interface.jl\",\r\n    \"isomorphism.jl\"\r\n]\r\nPrivate = false","category":"page"},{"location":"library.html#Matroids.Matroid","page":"Library","title":"Matroids.Matroid","text":"Matroid(groundset=nothing, data=nothing; kwargs...)\n\nConstruct a matroid.\n\nYou will need to provide a graph or a matrix as data, or one of the optional kwargs.\n\nArguments\n\ngroundset : labels for the groundset of the matroid\ndata : a matrix or a graph\nbases : optional; the set of bases of the matroid\nindependentsets : optional; the set of the independent sets of the matroid\ncircuits : optional; the set of circuits of the matroid\nmatroid : optional; an existing matroid\n\n\n\n\n\n","category":"function"},{"location":"library.html#Base.size-Tuple{AbstractMatroid}","page":"Library","title":"Base.size","text":"size(M)\n\nReturn the size of the groundset of the matroid M.\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.bases-Tuple{AbstractMatroid}","page":"Library","title":"Matroids.bases","text":"bases(M)\n\nReturn all the bases of the matroid M.\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.basis-Tuple{AbstractMatroid}","page":"Library","title":"Matroids.basis","text":"basis(M)\n\nReturn an arbitrary basis of the matroid M.\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.circuit-Tuple{AbstractMatroid,Any}","page":"Library","title":"Matroids.circuit","text":"circuit(M, X)\n\nReturn a circuit of M contained in X. Otherwise raise an error. X should be a subset of the groundset of M.\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.circuit-Tuple{AbstractMatroid}","page":"Library","title":"Matroids.circuit","text":"circuit(M)\n\nReturn a circuit of M if one exists. Otherwise raise an error.\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.circuitclosures-Tuple{AbstractMatroid}","page":"Library","title":"Matroids.circuitclosures","text":"circuitclosures(M)\n\nReturn all the circuit closures of the matroid M.\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.circuits-Tuple{AbstractMatroid}","page":"Library","title":"Matroids.circuits","text":"circuits(M)\n\nReturn all the circuits of the matroid M.\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.closure-Tuple{AbstractMatroid,Any}","page":"Library","title":"Matroids.closure","text":"closure(M, X)\n\nReturn the closure of X in matroid M. X should be a subset of the groundset of M.\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.cobasis-Tuple{AbstractMatroid}","page":"Library","title":"Matroids.cobasis","text":"cobasis(M)\n\nReturn an arbitrary cobasis of the matroid M.\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.cocircuit-Tuple{AbstractMatroid,Any}","page":"Library","title":"Matroids.cocircuit","text":"cocircuit(M, X)\n\nReturn a cocircuit of M contained in X. Otherwise raise an error. X should be a subset of the groundset of M.\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.cocircuit-Tuple{AbstractMatroid}","page":"Library","title":"Matroids.cocircuit","text":"cocircuit(M)\n\nReturn a cocircuit of M if one exists. Otherwise raise an error.\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.cocircuits-Tuple{AbstractMatroid}","page":"Library","title":"Matroids.cocircuits","text":"cocircuits(M)\n\nReturn all the cocircuits of the matroid M.\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.coclosure-Tuple{AbstractMatroid,Any}","page":"Library","title":"Matroids.coclosure","text":"coclosure(M, X)\n\nReturn the coclosure of X in matroid M. X should be a subset of the groundset of M.\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.coloops-Tuple{AbstractMatroid}","page":"Library","title":"Matroids.coloops","text":"coloops(M)\n\nReturn all the coloops of the matroid M.\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.corank-Tuple{AbstractMatroid,Any}","page":"Library","title":"Matroids.corank","text":"corank(M, X)\n\nReturn the corank of the subset X in the matroid M.  X shold be a subset of the groundset of M. \n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.corank-Tuple{AbstractMatroid}","page":"Library","title":"Matroids.corank","text":"corank(M)\n\nReturn the corank of the matroid M. Equivalent to fullcorank(M).\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.flats-Tuple{AbstractMatroid,Int64}","page":"Library","title":"Matroids.flats","text":"flats(M, r)\n\nReturn all the flats of rank r in the matroid M.\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.fullcorank-Tuple{AbstractMatroid}","page":"Library","title":"Matroids.fullcorank","text":"fullcorank(M)\n\nReturn the corank of the matroid M. Equivalent to corank(M).\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.fullrank-Tuple{AbstractMatroid}","page":"Library","title":"Matroids.fullrank","text":"fullrank(M)\n\nReturn the rank of the matroid M. Equivalent to rank(M).\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.fundamentalcircuit-Tuple{AbstractMatroid,Any,Any}","page":"Library","title":"Matroids.fundamentalcircuit","text":"fundamentalcircuit(M, B, e)\n\nReturn the B-fundamental circuit using e in matroid M. This is the unique matroid circuit contained in B cup e. B should be a basis of M and e should be an element of M not in B.\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.fundamentalcocircuit-Tuple{AbstractMatroid,Any,Any}","page":"Library","title":"Matroids.fundamentalcocircuit","text":"fundamentalcircuit(M, B, e)\n\nReturn the B-fundamental cocircuit using e in matroid M. This is the unique matroid cocircuit that intersects B only at e. B should be a basis of M and e should be an element of M not in B.\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.groundset-Tuple{AbstractMatroid}","page":"Library","title":"Matroids.groundset","text":"groundset(M)\n\nReturn the groundset of the matroid M.\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.independentsets-Tuple{AbstractMatroid}","page":"Library","title":"Matroids.independentsets","text":"independentsets(M)\n\nReturn all the independent sets of the matroid M.\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.isbasis-Tuple{AbstractMatroid,Any}","page":"Library","title":"Matroids.isbasis","text":"isbasis(M, X)\n\nTest whether the subset X is a basis in the matroid M. X should be a subset of the groundset of M.\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.iscircuit-Tuple{AbstractMatroid,Any}","page":"Library","title":"Matroids.iscircuit","text":"iscircuit(M, X)\n\nTest whether the subset X is a circuit in the matroid M. X should be a subset of the groundset of M.\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.isclosed-Tuple{AbstractMatroid,Any}","page":"Library","title":"Matroids.isclosed","text":"isclosed(M, X)\n\nTest whether the subset X is closed in the matroid M. X should be a subset of the groundset of M.\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.iscobasis-Tuple{AbstractMatroid,Any}","page":"Library","title":"Matroids.iscobasis","text":"iscobasis(M, X)\n\nTest whether the subset X is a cobasis in the matroid M. X should be a subset of the groundset of M.\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.iscocircuit-Tuple{AbstractMatroid,Any}","page":"Library","title":"Matroids.iscocircuit","text":"iscocircuit(M, X)\n\nTest whether the subset X is a cocircuit in the matroid M. X should be a subset of the groundset of M.\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.iscoclosed-Tuple{AbstractMatroid,Any}","page":"Library","title":"Matroids.iscoclosed","text":"iscoclosed(M, X)\n\nTest whether the subset X is coclosed in the matroid M. X should be a subset of the groundset of M.\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.iscodependent-Tuple{AbstractMatroid,Any}","page":"Library","title":"Matroids.iscodependent","text":"iscodependent(M, X)\n\nTest whether the subset X is codependent in the matroid M. X should be a subset of the groundset of M.\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.iscoindependent-Tuple{AbstractMatroid,Any}","page":"Library","title":"Matroids.iscoindependent","text":"iscoindependent(M, X)\n\nTest whether the subset X is coindependent in the matroid M. X should be a subset of the groundset of M.\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.isdependent-Tuple{AbstractMatroid,Any}","page":"Library","title":"Matroids.isdependent","text":"isdependent(M, X)\n\nTest whether the subset X is dependent in the matroid M. X should be a subset of the groundset of M.\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.isindependent-Tuple{AbstractMatroid,Any}","page":"Library","title":"Matroids.isindependent","text":"isindependent(M, X)\n\nTest whether the subset X is independent in the matroid M. X should be a subset of the groundset of M.\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.isvalidmatroid-Tuple{AbstractMatroid}","page":"Library","title":"Matroids.isvalidmatroid","text":"isvalidmatroid(M)\n\nTest whether M is a valid matroid, i.e. it satisfies the matroid axioms.\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.loops-Tuple{AbstractMatroid}","page":"Library","title":"Matroids.loops","text":"loops(M)\n\nReturn all the loops of the matroid M.\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.maxcoindependent-Tuple{AbstractMatroid,Any}","page":"Library","title":"Matroids.maxcoindependent","text":"maxcoindependent(M, X)\n\nReturn a maximal coindependent subset of X in matroid M. X should be a subset of the groundset of M.\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.maxindependent-Tuple{AbstractMatroid,Any}","page":"Library","title":"Matroids.maxindependent","text":"maxindependent(M, X)\n\nReturn a maximal independent subset of X in matroid M. X should be a subset of the groundset of M.\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.nonbases-Tuple{AbstractMatroid}","page":"Library","title":"Matroids.nonbases","text":"nonbases(M)\n\nReturn all the nonbases of the matroid M.\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.rank-Tuple{AbstractMatroid,Any}","page":"Library","title":"Matroids.rank","text":"rank(M, X)\n\nReturn the rank of the subset X in the matroid M.  X shold be a subset of the groundset of M. \n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.rank-Tuple{AbstractMatroid}","page":"Library","title":"Matroids.rank","text":"rank(M)\n\nReturn the rank of the matroid M. Equivalent to fullrank(M).\n\n\n\n\n\n","category":"method"},{"location":"library.html#Matroids.isisomorphic-Tuple{AbstractMatroid,AbstractMatroid}","page":"Library","title":"Matroids.isisomorphic","text":"isisomorphic(M, N)\n\nTest whether matroids M and N are isomorphic.\n\n\n\n\n\n","category":"method"},{"location":"catalog.html#Catalog","page":"Catalog","title":"Catalog","text":"","category":"section"},{"location":"catalog.html","page":"Catalog","title":"Catalog","text":"Many common or useful matroids.","category":"page"},{"location":"catalog.html","page":"Catalog","title":"Catalog","text":"","category":"page"},{"location":"catalog.html","page":"Catalog","title":"Catalog","text":"Order = [:function]\r\nPages = [\"catalog.md\"]","category":"page"},{"location":"catalog.html#Functions","page":"Catalog","title":"Functions","text":"","category":"section"},{"location":"catalog.html","page":"Catalog","title":"Catalog","text":"Modules = [Matroids.Catalog]\r\nOrder = [:function]\r\nPages = [\r\n    \"catalog.jl\"\r\n    ]\r\nPrivate = true","category":"page"},{"location":"catalog.html#Matroids.Catalog.Block_10_5-Tuple{}","page":"Catalog","title":"Matroids.Catalog.Block_10_5","text":"Block_10_5()\n\nReturn the paving matroid whose non-spanning circuits form of a 3-(10, 5, 3) design, represented as circuit closures.\n\n\n\n\n\n","category":"method"},{"location":"catalog.html#Matroids.Catalog.Fano-Tuple{}","page":"Catalog","title":"Matroids.Catalog.Fano","text":"Fano()\n\nReturns the Fano matroid, represented as a linear matroid over GF(2).\n\n\n\n\n\n","category":"method"},{"location":"catalog.html#Matroids.Catalog.NonFano-Tuple{}","page":"Catalog","title":"Matroids.Catalog.NonFano","text":"NonFano()\n\nReturns the non-Fano matroid, represented as a linear matroid over GF(3).\n\n\n\n\n\n","category":"method"},{"location":"catalog.html#Matroids.Catalog.Pappus-Tuple{}","page":"Catalog","title":"Matroids.Catalog.Pappus","text":"Pappus()\n\nReturns the Pappus matroid, represented as circuit closures.\n\n\n\n\n\n","category":"method"},{"location":"catalog.html#Matroids.Catalog.Q6-Tuple{}","page":"Catalog","title":"Matroids.Catalog.Q6","text":"Q6()\n\nReturns the Q6 matroid, represented as a linear matroid over GF(4).\n\n\n\n\n\n","category":"method"},{"location":"catalog.html#Matroids.Catalog.R6-Tuple{}","page":"Catalog","title":"Matroids.Catalog.R6","text":"R6()\n\nReturns the R6 matroid, represented as a linear matroid over GF(3).\n\n\n\n\n\n","category":"method"},{"location":"catalog.html#Matroids.Catalog.Uniform-Tuple{Int64,Int64}","page":"Catalog","title":"Matroids.Catalog.Uniform","text":"Uniform(r, n)\n\nReturn the uniform matroid of rank r on n elements represented as circuit closures.\n\n\n\n\n\n","category":"method"},{"location":"userguide.html#User-Guide","page":"User Guide","title":"User Guide","text":"","category":"section"},{"location":"userguide.html","page":"User Guide","title":"User Guide","text":"","category":"page"},{"location":"userguide.html","page":"User Guide","title":"User Guide","text":"Load the package:","category":"page"},{"location":"userguide.html","page":"User Guide","title":"User Guide","text":"using Matroids","category":"page"},{"location":"userguide.html","page":"User Guide","title":"User Guide","text":"To create a matroid, we do not need to call any specific matroid, we can simply call the general matroid constructor:","category":"page"},{"location":"userguide.html","page":"User Guide","title":"User Guide","text":"M1 = Matroid(\"abcd\", bases=[\"ab\", \"ac\"])\r\nM2 = Matroid(\"abcd\", circuitclosures=Dict(2 => [\"abcd\"]))\r\nM3 = Matroid([(0,0), (0,1), (0,2), (0,3), (1,2), (1,3)])\r\nM4 = Matroid([1 0 0 2; 0 1 0 1; 0 0 1 1])","category":"page"},{"location":"userguide.html","page":"User Guide","title":"User Guide","text":"We can also use matroids from the Catalog:","category":"page"},{"location":"userguide.html","page":"User Guide","title":"User Guide","text":"M5 = Matroids.Catalog.Fano()\r\nM6 = Matroids.Catalog.Uniform(2,4)","category":"page"},{"location":"userguide.html","page":"User Guide","title":"User Guide","text":"Then, we can call some basic functions on the matroids:","category":"page"},{"location":"userguide.html","page":"User Guide","title":"User Guide","text":"isvalidmatroid(M1)\r\ncircuits(M2)\r\nindependentsets(M3)\r\nisisomorphic(M2, M6)\r\nisisomorphic(M1, M2)","category":"page"},{"location":"userguide.html","page":"User Guide","title":"User Guide","text":"See other functions in the Library.","category":"page"},{"location":"index.html#Matroids.jl","page":"Home","title":"Matroids.jl","text":"","category":"section"},{"location":"index.html","page":"Home","title":"Home","text":"A Julia package for matroids.","category":"page"},{"location":"index.html#Installation","page":"Home","title":"Installation","text":"","category":"section"},{"location":"index.html","page":"Home","title":"Home","text":"Matroids.jl is not a registered package. You can install it directly from the github repository:","category":"page"},{"location":"index.html","page":"Home","title":"Home","text":"pkg> add https://github.coecis.cornell.edu/rls499/Matroids.jl.git","category":"page"},{"location":"index.html#Acknowledgments","page":"Home","title":"Acknowledgments","text":"","category":"section"},{"location":"index.html","page":"Home","title":"Home","text":"A large part of this project is based off of the SageMath implementation of matroids.","category":"page"}]
}
