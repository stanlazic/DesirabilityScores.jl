using Pkg
Pkg.activate(".")
Pkg.develop(PackageSpec(path=".."))
Pkg.instantiate()

using Documenter
using DesirabilityScores

DocMeta.setdocmeta!(DesirabilityScores, :DocTestSetup, :(using DesirabilityScores); recursive=true)

makedocs(;
    modules=[DesirabilityScores],
    authors="Stanley E. Lazic, Gabriel C. Phelan",
    repo=Documenter.Remotes.GitHub("stanlazic", "DesirabilityScores.jl"), 
    sitename="DesirabilityScores.jl",
    format=Documenter.HTML(;
        canonical="https://stanlazic.github.io/DesirabilityScores.jl",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/stanlazic/DesirabilityScores.jl",
    devbranch="master",
)
