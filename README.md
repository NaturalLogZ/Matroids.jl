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
First, we define an AbstractMatroid type which supports a lot of functions,
defined in `interface.jl`. (These are the functions that need to be implemented
for each kind of matroid. If we get a universal implementation, it should be
commented out.)

There are some private utility things in `utils.jl` (need more documentation)
and then some universal implementations of functions in `core.jl`.

One specific implementation of matroids & some functions for them is in `basismatroid.jl`.
Any other implementations (like graphic matroids, linear matroids) should be put
in similar files.
Then the universal matroid constructor code is in `Matroids.jl` after the includes,
which currently processes input and redirects to construct a BasisMatroid.

Fancy later functionality should probably go in an include after that.

