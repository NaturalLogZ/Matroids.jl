# Matroids.jl
Matroids in Julia!


### A poor development guide
Will need to investigate proper documentation & testing and maybe more about packages later.

For now, the only required package is Combinatorics.jl (and Revise.jl too I guess). 

#### How to develop.
This is my development cycle.

- Open Julia repl at this directory.
- type `]` to enter Pkg mode, and `activate .`
- still in Pkg mode, probably `instantiate` to install all the packages in Project.toml
- backspace to exit Pkg mode, then `using Revise` (you may need to add Revise first)
- then `using Matroids`. This allows you to use any exported functions without prefixing them.

Revise package means that whenever you save changes in the source code, next command
run in the Julia REPL recompiles the code first. (Though some major changes will
still break it; requiring you to restart the REPL.)

#### Code structure

First, we define an AbstractMatroid type which supports a lot of functions.
For now, each implementation of AbstractMatroid needs to provide a constructor,
a `_rank(M, X)` function, and a `_groundset(M)` function. However, for performance,
many other functions should be overwritten (especially `isvalidmatroid`). (Now, please also
include copy, ==, and update the show function.)

There are some private utility things in `utils.jl` (need more documentation for these)
and then private universal implementations of functions in `core.jl`. The basic public
facing functions are in `interface.jl`, but more advanced things like isomorphism live in 
a separate file.

Then the universal matroid constructor code is in `Matroids.jl` after the includes,
which currently processes input and redirects to construct the correct kind of matroid.

Specifically, we still need to implement:
- dual matroids
- minor matroids
- coflats, hyperplanes, broken circuts, etc
- expand the catalog and add infinite categories to the catalog (like uniform, wheel, etc)
- (more optional) regular matroids, unions, sums, connections

Almost all documentation is missing but the infrastructure is in place. 

Test coverage is at ~50% before the above is implemented; missing tests on validity,
isomorphism, and some constructors.


#### How to get code coverage:

First run the tests with code coverage on. Probably something like: `] test --coverage` to generate .cov files.
Then in julia repl:

```
using Coverage
coverage = process_folder()
covered_lines, total_lines = get_summary(coverage)
println("coverage: ", covered_lines/total_lines)
```
