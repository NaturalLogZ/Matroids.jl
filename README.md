# Matroids.jl
Matroids in Julia!


### A poor development guide
Will need to investigate proper documentation & testing and maybe more about packages later.

For now, the only required package is Combinatorics.jl (and Revise.jl too I guess). 

#### How to develop.
This is my development cycle.

- Open Julia repl at this directory.
- type `]` to enter Pkg mode, and `activate .`
- backspace to exit Pkg mode, then `using Revise` (you may need to add Revise first)
- then `using Matroids`. This allows you to use any exported functions.

Revise package means that whenever you save changes in the source code, next command
run in the Julia REPL recompiles the code first. (Though some major changes will
still break it; requiring you to restart the REPL.)

#### Code structure

Julia reads the code in the files included in Matroids.jl in order. 
First, we define an AbstractMatroid type which supports a lot of functions.
For now, each implementation of AbstractMatroid needs to provide a constructor,
a `_rank(M, X)` function, and a `_groundset(M)` function. However, for performance,
many other functions should be overwritten (especially `isvalidmatroid`). 

There are some private utility things in `utils.jl` (need more documentation)
and then private universal implementations of functions in `core.jl`. The basic public
facing functions are in `interface.jl`, but more advance things will probably be
in a separate file in the future.

One specific implementation of matroids & some functions for them is in `basismatroid.jl`.
Linear matroids (matrices) are in `linearmatroid.jl`. 
Any other implementations (like graphic matroids, linear matroids) should be put
in similar files.
Then the universal matroid constructor code is in `Matroids.jl` after the includes,
which currently processes input and redirects to construct a BasisMatroid.

Specifically, we still need to implement:
- graphic matroids,
- rank function matroids <- very easy
- circuit closure matroids
- dual matroids, minor matroids, other operations like union, sum, connections? (as objects),
- regular matroids?


