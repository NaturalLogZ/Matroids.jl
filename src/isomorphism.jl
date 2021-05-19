# Should contain all code for determining isomorphisms. 

# The following will be slow for large matroids.


function isisomorphic(M::AbstractMatroid, N::AbstractMatroid)
    # since we do generate the isomorphism, it would be easy to modify
    # this to return the isomorphism.

    if fullrank(M) != fullrank(N)
        return false
    end
    return !isnothing(_isomorphism(nonbases(M), groundset(M), nonbases(N), groundset(N)))
end




function _isomorphism(S, GS, O, GO, SP=nothing, OP=nothing)
    # get equitable partitions of both:
    if isnothing(SP) || isnothing(OP)
        SP, SEP, sh = _equitablepartition(S, GS)
        OP, OEP, oh = _equitablepartition(O, GO)
        if sh != oh
            return nothing
        end
    end
    
    if length(SP) != length(OP)
        return nothing
    end

    p = length(GS) + 1
    for i in 1:length(SP)
        l = length(SP[i])
        if l != length(OP[i])
            return nothing
        end
        if l != 1 && l < p
            p = l
        end
    end

    # Perform a recursive check on possible matchings between elements in the 
    # two matroids.
    for i in 1:length(SP)
        if length(SP[i]) == p
            SP2, SEP2, sh = _equitablepartition(S, GS, _distinguish(SP, SP[i][1]))
            for v in OP[i]
                OP2, OEP2, oh = _equitablepartition(O, GO, _distinguish(OP, v))
                if sh == oh
                    m = _isomorphism(S, GS, O, GO, SP2, OP2)
                    if !isnothing(m)
                        return m
                    end
                end
            end
            return nothing
        end
    end

    if sort([_subsetchar(SP, S[i]) for i in 1:length(S)]) != sort([_subsetchar(OP, O[i]) for i in 1:length(O)])
        return nothing
    end
    return Dict(SP[i][1] => OP[i][1] for i in 1:length(SP))

end

# a helper function to count total occurences of all elements in a set of sets.
function _incidencecnt(S, G)
    cnt = Dict(x => 0 for x in G)
    for s in S
        for el in s
            cnt[el] += 1
        end
    end
    return cnt
end

# partition into elements that are equivalent
function _equitablepartition(S, G, P=nothing, EP=nothing)
    cnt = _incidencecnt(S,G) 

    if isnothing(P)
        P = [copy(G)]
    else
        P = copy(P)
    end
    if isnothing(EP)
        EP = _subsetpartition(S, P, collect(1:length(S)))[1] # some list of list of indices
    end

    h = length(EP) # stores a list of the hashes or something.
    pl = 0
    while length(P) > pl
        H = Int128[h] 
        pl = length(P)
        EP2 = []
        for ep in EP
            SP, h = _subsetpartition(S, P, ep)
            push!(H, h)
            for p in SP
                cnt = _incidencecnt(S[p], G)
                _groundsetpartition(P, cnt)
                if length(p) > 1
                    push!(EP2, p)
                end
            end
        end
        EP = EP2
        h = hash(H)
    end

    return P, EP, h

end

function _groundsetpartition(P, cnt)
    for i in 1:length(P)
        if length(P[i]) == 0
            continue
        end
        cnts = [cnt[el] for el in P[i]]
        if minimum(cnts) != maximum(cnts)
            t0 = minimum(cnts)
            C = Dict()

            for el in P[i]
                t = cnt[el]
                if t != t0
                    if t in keys(C)
                        push!(C[t], el)
                    else
                        C[t] = Set([el])
                    end
                end
            end

            for t in keys(C)
                newp = collect(C[t])
                setdiff!(P[i], newp)
                push!(P, newp)
            end
        end
    end
end


function _subsetchar(P, s)
    # seems like a simple characteristic function for a set of subsets P
    # in relation to another subset s.
    # s should be equivalent to S[e]
    c = 0
    for p in P
        c <<= length(p)
        c += length(intersect(p, s))
    end
    return c
end

function _subsetpartition(S, P, E)
    if length(E) == 0
        return [E]
    end
    ED = [(_subsetchar(P, S[e]), e) for e in E]
    sort!(ED)

    # I'm not totally sure what's happening here..
    # seems like partitioning on result of the
    # characteristic function.
    EP = []
    ep = []
    d = ED[1][1]
    eh = [d]

    for ed in ED
        if ed[1] != d
            push!(EP, ep)
            ep = [ed[2]]
            d = ed[1]
        else
            push!(ep, ed[2])
        end
        push!(eh, ed[1])
    end
    push!(EP, ep)
    return EP, hash(eh)
end


function _distinguish(S, v)
    S2 = copy(S)
    for s in S2
        setdiff!(s, [v])
    end
    push!(S2, [v])
    return S2
end