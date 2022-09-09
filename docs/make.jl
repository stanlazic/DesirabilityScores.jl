using DesirabilityScores
using Documenter

#DocMeta.setdocmeta!(DesirabilityScores, :DocTestSetup, :(using DesirabilityScores); recursive=true)

makedocs(;
    modules=[DesirabilityScores],
    authors="Stanley E. Lazic, Gabriel C. Phelan",
    repo="https://github.com/stanlazic/DesirabilityScores.jl/blob/{commit}{path}#{line}",
    sitename="DesirabilityScores.jl",
    #format=Documenter.HTML(;
    #    prettyurls=get(ENV, "CI", "false") == "true",
    #    assets=String[],
    #),
    #format=Documenter.HTML(),
    format=Documenter.LaTeX(), 
    pages=[
        "index.md"
    ],
)
