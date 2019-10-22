using AML
using Documenter

makedocs(;
    modules=[AML],
    authors="Amin Yahyaabadi",
    repo="https://github.com/aminya/AML/blob/{commit}{path}#L{line}",
    sitename="AML",
    format=Documenter.HTML(;
        canonical="https://aminya.github.io/AML",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/aminya/AML",
)
