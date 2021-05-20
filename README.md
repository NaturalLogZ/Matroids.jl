# Matroids.jl
Matroids in Julia!

### Quick Start

Matroids.jl is not a registered package. You can install it directly from the github repository:

```
pkg> add https://github.coecis.cornell.edu/rls499/Matroids.jl.git
```

Then load the package and start working with matroids. Create them with the constructor, or use matroids from the catalog.
```
julia> using Matroids
julia> M1 = Matroid("abcd", bases=["ab", "ac"])
julia> M2 = Matroids.Catalog.Fano()
julia> circuits(M2)
```

The full documentation is available, but not currently hosted anywhere. 
The generated HTML files are in the docs/build directory, and can be viewed locally.

### Acknowledgments

A large part of this project is based off of the [SageMath](https://www.sagemath.org/) implementation of matroids.


### Development guide
- Clone this repository & open Julia REPL from it.
- Type `]` to enter Pkg mode, and `activate .`
- Still in Pkg mode, probably `instantiate` to install all the packages in Project.toml
- Backspace to exit Pkg mode, then (optionally) `using Revise` (you may need to add Revise first)
- Then `using Matroids`. This allows you to use any exported functions without prefixing them.

Revise package means that whenever you save changes in the source code, next command
run in the Julia REPL recompiles the code first. (Though some major changes will
still break it; requiring you to restart the REPL.)


#### Things that should still be implemented:
- dual matroids
- minor matroids
- coflats, hyperplanes, broken circuts, etc
- expand the catalog and add infinite categories to the catalog (like wheel, PG, etc)
- (more optional) regular matroids, unions, sums, connections


#### Testing
Test coverage is at ~71% before the above is implemented.


How to get code coverage:

First run the tests with code coverage on. Probably something like: `] test --coverage` to generate .cov files.
Then in julia repl:

```
using Coverage
coverage = process_folder()
covered_lines, total_lines = get_summary(coverage)
println("coverage: ", covered_lines/total_lines)
```
