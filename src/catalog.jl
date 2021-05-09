"""
Intended to be a catalog of matroids to use without doing
lots of work.
"""

module Catalog
using Matroids
import AbstractAlgebra
# This will always print a banner unless disabled under env variables.
# TODO: maybe https://github.com/Nemocas/Nemo.jl/issues/817 will eventually result
# in a way around this.
import Nemo: FiniteField

# TODO: compare these two definitions of fano when is_isomorphic is done

# function Fano()
#     gs = collect("abcdefg")
#     nbs = [
#               ['a','d','b'],
#               ['b','e','c'],
#               ['a','f','c'],
#               ['a','g','e'],
#               ['d','g','c'],
#               ['b','g','f'],
#               ['d','e','f']
#           ]
# 
#     return BasisMatroid(groundset=gs, nonbases=nbs)
# end

function Fano()
    F = AbstractAlgebra.GF(2)
    mtx = AbstractAlgebra.matrix(F, [1 0 0 0 1 1 1;
                                     0 1 0 1 0 1 1;
                                     0 0 1 1 1 0 1])
    return LinearMatroid(mtx, groundset=collect("abcdefg"))
end

function Q6()
    F, x = FiniteField(2, 2, "x")
    mtx = AbstractAlgebra.matrix(F, [1 0 0 1 0 1;
                                     0 1 0 1 1 x;
                                     0 0 1 0 1 1])

    return LinearMatroid(mtx, groundset=collect("abcdef"))
end

function R6()
    F = AbstractAlgebra.GF(3)
    mtx = AbstractAlgebra.matrix(F, [1 0 0 1 1 1;
                                     0 1 0 1 2 1;
                                     0 0 1 1 0 2])

    return LinearMatroid(mtx, groundset=collect("abcdef"))
end

function NonFano()
    F = AbstractAlgebra.GF(3)
    mtx = AbstractAlgebra.matrix(F, [1 0 0 0 1 1 1;
                                     0 1 0 1 0 1 1;
                                     0 0 1 1 1 0 1])
    return LinearMatroid(mtx, groundset=collect("abcdefg"))
end


function Pappus()
    gs = collect("abcdefghi")
    ccs = Dict(2=>[collect(c) for c in ["abc", "def", "ceg", "bfg", "cdh", "afh", "bdi", "aei", "ghi"]], 3=>[collect("abcdefghi")])
    return CircuitClosuresMatroid(groundset=gs, circuitclosures=ccs)
end





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


end
