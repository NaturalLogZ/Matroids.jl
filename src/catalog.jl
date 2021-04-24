"""
Intended to be a catalog of matroids to use without doing
lots of work.
"""

module Catalog

using Matroids

# TODO: redefine via matrix or smth...
# But for now, this works I think.

function Fano()
    gs = ['a','b','c','d','e','f','g']
    nbs = [
              ['a','d','b'],
              ['b','e','c'],
              ['a','f','c'],
              ['a','g','e'],
              ['d','g','c'],
              ['b','g','f'],
              ['d','e','f']
          ]

    return BasisMatroid(groundset=gs, nonbases=nbs)
end









end
