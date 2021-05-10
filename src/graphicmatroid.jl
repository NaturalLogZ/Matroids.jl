
# Note: I would have liked to use a graph library here. But all
# seem to lack something.
# LightGraphs doesn't support multigraphs. And Multigraphs.jl has
# some problems with loops. 

# So for now, we just accept graphs as edgelists and deal with them 
# on our own. (We don't need a lot of complicated functionality anyway.)

mutable struct GraphicMatroid{T,W} <: AbstractMatroid{T}
    groundset::Vector{T}
    edgelist::Vector{Tuple{W,W,T}}
    elmap::Dict{T,Int}
    # repr::Union{AbstractAlgebra.MatrixElem, Nothing}


    # In the future, maybe add support for reduced matrix and keep orig. repr.

    # adj list, adj mat, 

    function GraphicMatroid{T,W}(edgelist::Union{Vector{Tuple{W,W}},Vector{Pair{W,W}}}; 
        groundset::Union{Vector{T}, Nothing}=nothing) where T where W

        if isnothing(groundset)
            groundset = collect(1:length(edgelist))
        end

        if length(groundset) != length(edgelist)
            error("groundset must match number of edges in graph")
        end

        # make an edgelist with labels
        edges = Vector{Tuple{W,W,T}}()
        for i in 1:length(edgelist)
            push!(edges, (edgelist[i][1],edgelist[i][2],groundset[i]))
        end
        idxs = Dict{T,Int}()
        for i in 1:length(groundset)
            idxs[groundset[i]] = i
        end

        return new{T,W}(deepcopy(groundset), edges, idxs)
    end

end


function GraphicMatroid(edgelist::Union{Vector{Tuple{W,W}},Vector{Pair{W,W}}}; 
    groundset::Union{Vector{T}, Nothing}=nothing) where T where W

    if isnothing(groundset)
        return GraphicMatroid{Int64,W}(edgelist,groundset=groundset)
    end

    return GraphicMatroid{T,W}(edgelist,groundset=groundset)
end

==(M::GraphicMatroid, N::GraphicMatroid) = 
M.groundset == N.groundset &&
M.edgelist == N.edgelist

function copy(M::GraphicMatroid) 
    edgelist = [(edge[1], edge[2]) for edge in M.edgelist]
    N = GraphicMatroid(edgelist, groundset=M.groundset)
    return N
end

function _groundset(M::GraphicMatroid)
    return M.groundset
end

function _rank(M::GraphicMatroid{T,W}, X::Vector) where T where W
    if length(M.edgelist) == 0
        return 0
    end
    
    edges = Vector{eltype(M.edgelist)}()
    for x in X
        if !(x in keys(M.elmap))
            error("input not a subset of groundset")
        end
        push!(edges, M.edgelist[M.elmap[x]])
    end
    vertices = Set{W}()
    for edge in edges
        push!(vertices, edge[1])
        push!(vertices, edge[2])
    end

    dsverts = DisjointSets(vertices)
    for (u,v,l) in edges
        union!(dsverts, u, v)
    end

    return length(vertices) - num_groups(dsverts)
end



