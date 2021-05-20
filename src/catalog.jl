"""
Intended to be a catalog of matroids to use without doing
lots of work.
"""

module Catalog
using Matroids
import AbstractAlgebra
import Nemo: FiniteField



"""
    Fano()

Returns the Fano matroid, represented as a linear matroid over GF(2).
"""
function Fano()
    F = AbstractAlgebra.GF(2)
    mtx = AbstractAlgebra.matrix(F, [1 0 0 0 1 1 1;
                                     0 1 0 1 0 1 1;
                                     0 0 1 1 1 0 1])
    return LinearMatroid(mtx, groundset=collect("abcdefg"))
end

"""
    Q6()

Returns the Q6 matroid, represented as a linear matroid over GF(4).
"""
function Q6()
    F, x = FiniteField(2, 2, "x")
    mtx = AbstractAlgebra.matrix(F, [1 0 0 1 0 1;
                                     0 1 0 1 1 x;
                                     0 0 1 0 1 1])

    return LinearMatroid(mtx, groundset=collect("abcdef"))
end

"""
    R6()

Returns the R6 matroid, represented as a linear matroid over GF(3).
"""
function R6()
    F = AbstractAlgebra.GF(3)
    mtx = AbstractAlgebra.matrix(F, [1 0 0 1 1 1;
                                     0 1 0 1 2 1;
                                     0 0 1 1 0 2])

    return LinearMatroid(mtx, groundset=collect("abcdef"))
end

"""
    NonFano()

Returns the non-Fano matroid, represented as a linear matroid over GF(3).
"""
function NonFano()
    F = AbstractAlgebra.GF(3)
    mtx = AbstractAlgebra.matrix(F, [1 0 0 0 1 1 1;
                                     0 1 0 1 0 1 1;
                                     0 0 1 1 1 0 1])
    return LinearMatroid(mtx, groundset=collect("abcdefg"))
end

"""
    Pappus()

Returns the Pappus matroid, represented as circuit closures.
"""
function Pappus()
    gs = collect("abcdefghi")
    ccs = Dict(2=>[collect(c) for c in ["abc", "def", "ceg", "bfg", "cdh", "afh", "bdi", "aei", "ghi"]], 3=>[collect("abcdefghi")])
    return CircuitClosuresMatroid(groundset=gs, circuitclosures=ccs)
end




"""
    Block_10_5()

Return the paving matroid whose non-spanning circuits form of a 3-(10, 5, 3) design, represented as circuit closures.
"""
function Block_10_5()
    ccs = Dict(4 => ["abcde", "acdfg", "bdefg", "bcdfh", "abefh", "abcgh", "adegh",
                    "cefgh", "bcefi", "adefi", "bcdgi", "acegi", "abfgi", "abdhi",
                    "cdehi", "acfhi", "beghi", "dfghi", "abdfj", "acefj", "abegj",
                    "cdegj", "bcfgj", "acdhj", "bcehj", "defhj", "bdghj", "afghj",
                    "abcij", "bdeij", "cdfij", "adgij", "efgij", "aehij", "bfhij",
                    "cghij"],
               5 => ["abcdefghij"])

    return Matroid(circuitclosures=ccs)
end

"""
    Uniform(r, n)

Return the uniform matroid of rank `r` on `n` elements represented as circuit closures.
"""
function Uniform(r::Int, n::Int)
    E = collect(1:n)
    if r < n
        CC = Dict(r => [E])
    else
        CC = Dict{Int,Vector{Vector{Int}}}()
    end
    return CircuitClosuresMatroid(groundset=E, circuitclosures=CC)
end


end
