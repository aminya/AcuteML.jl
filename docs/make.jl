using AML
using Documenter

makedocs(;
    modules=[AML],
    authors="Amin Yahyaabadi",
    repo="https://github.com/aminya/AML.jl/blob/{commit}{path}#L{line}",
    sitename="AML.jl",
    format=Documenter.HTML(;
        canonical="https://aminya.github.io/AML.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/aminya/AML.jl",
)
