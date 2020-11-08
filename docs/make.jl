using PointInPoly
using Documenter

makedocs(;
    modules=[PointInPoly],
    authors="Hetao Z.",
    repo="https://github.com/HetaoZ/PointInPoly.jl/blob/{commit}{path}#L{line}",
    sitename="PointInPoly.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://HetaoZ.github.io/PointInPoly.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/HetaoZ/PointInPoly.jl",
)
