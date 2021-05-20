push!(LOAD_PATH,"../src/")

using Documenter

using Matroids


makedocs(
    modules = [Matroids],
    sitename="Matroids",
    format=Documenter.HTML(prettyurls = false),
    pages=[
        "Home" => "index.md",
        "User Guide" => "userguide.md",
        "Library" => "library.md",
        "Catalog" => "catalog.md"
    ]
    
)