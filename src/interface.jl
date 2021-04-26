# A common interface for matroids, taken from the interface in LightGraphs.jl

"""
    NotImplementedError{M}(m)
`Exception` thrown when a method from the `AbstractGraph` interface
is not implemented by a given graph type.
"""
struct NotImplementedError{M} <: Exception
    m::M
    NotImplementedError(m::M) where {M} = new{M}(m)
end

Base.showerror(io::IO, ie::NotImplementedError) = print(io, "method $(ie.m) not implemented.")

_NI(m) = throw(NotImplementedError(m))

"""
    AbstractMatroid

An abstract type representing a matroid.
"""
abstract type AbstractMatroid{T} end

# TODO: put the documentation on the functions here!

# These are all the things sage supports
# https://github.com/sagemath/sage/blob/develop/src/sage/matroids/matroid.pyx has a list


# The following uncommented ones need to be done for each implementation
rank(M::AbstractMatroid) = _NI("rank") # corresponds to full_rank
# rank(M::AbstractMatroid, X::Vector) = _NI("rank func set") # done in core.jl
_rank(M::AbstractMatroid, X::Vector) = _NI("unsafe rank func set")
groundset(M::AbstractMatroid) = _NI("groundset")
# size(M::AbstractMatroid) = _NI("size") # done in core.jl
# corank(M::AbstractMatroid) = _NI("corank") # (FULL_RANK) core.jl

# isvalid(M::AbstractMatroid) = _NI("isvalid") # core.jl

# enumerative things
circuits(M::AbstractMatroid) = _NI("circuits")
cocircuits(M::AbstractMatroid) = _NI("cocircuits")
# bases(M::AbstractMatroid) = _NI("bases")
# nonbases(M::AbstractMatroid) = _NI("nonbases")
flats(M::AbstractMatroid) = _NI("flats")
coflats(M::AbstractMatroid) = _NI("coflats")
hyperplanes(M::AbstractMatroid) = _NI("hyperplanes")
brokencircuits(M::AbstractMatroid) = _NI("brokencircuits")

loops(M::AbstractMatroid) = _NI("loops")
coloops(M::AbstractMatroid) = _NI("coloops")


# This is ~ Graph isomorphism. Sage has an interesting algorithm in matroids.setsystem
# Maybe try doing that instead of pure brute force.
isisomorphic(M::AbstractMatroid, N::AbstractMatroid) = _NI("isisomorphic")
equals(M::AbstractMatroid, N::AbstractMatroid) = _NI("equals")

contract(M::AbstractMatroid, X) = _NI("contract")
delete(M::AbstractMatroid, X) = _NI("delete")
dual(M::AbstractMatroid) = _NI("dual")
hasminor(M::AbstractMatroid, N::AbstractMatroid) = _NI("hasminor")

tuttepolynomial(M::AbstractMatroid) = _NI("tuttepolynomial")
#characteristic(M::AbstractMatroid) = _NI("loops") redundant i guess

