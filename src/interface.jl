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


# The following I think is a far upper limit to what we should attempt
rank(M::AbstractMatroid) = _NI("rank") # corresponds to full_rank
rank(M::AbstractMatroid, X::Vector) = _NI("rank func set")
_rank(M::AbstractMatroid, X::Vector) = _NI("unsafe rank func set")
groundset(M::AbstractMatroid) = _NI("groundset")
size(M::AbstractMatroid) = _NI("size")
corank(M::AbstractMatroid) = _NI("corank") # corresponds to full_corank

isvalid(M::AbstractMatroid) = _NI("isvalid")

# enumerative things
circuits(M::AbstractMatroid) = _NI("circuits")
cocircuits(M::AbstractMatroid) = _NI("cocircuits")
bases(M::AbstractMatroid) = _NI("bases")
nonbases(M::AbstractMatroid) = _NI("nonbases")
flats(M::AbstractMatroid) = _NI("flats")
coflats(M::AbstractMatroid) = _NI("coflats")
hyperplanes(M::AbstractMatroid) = _NI("hyperplanes")
brokencircuits(M::AbstractMatroid) = _NI("brokencircuits")

loops(M::AbstractMatroid) = _NI("loops")
coloops(M::AbstractMatroid) = _NI("coloops")

isisomorphic(M::AbstractMatroid, N::AbstractMatroid) = _NI("isisomorphic")
equals(M::AbstractMatroid, N::AbstractMatroid) = _NI("equals")

contract(M::AbstractMatroid, X) = _NI("contract")
delete(M::AbstractMatroid, X) = _NI("delete")
dual(M::AbstractMatroid) = _NI("dual")
hasminor(M::AbstractMatroid, N::AbstractMatroid) = _NI("hasminor")

tuttepolynomial(M::AbstractMatroid) = _NI("tuttepolynomial")
#characteristic(M::AbstractMatroid) = _NI("loops") redundant i guess

