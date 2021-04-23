module Matroids


export AbstractMatroid, BasisMatroid

"""
    AbstractMatroid

An abstract type representing a matroid.
"""
abstract type AbstractMatroid end

# I don't if it needs to be parametric... but abstract graph is parametric.
# For now, I guess we assume the ground set is made up of integers. 
# If we want to be able to have groundsets of different kinds of things, we would make this parametric.

# We will want to do some sort of checking to make sure all the things
# are implemented. (See LightGraphs interface.jl)


include("./basismatroid.jl")

end
