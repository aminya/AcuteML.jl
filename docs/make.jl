using AcuteML
using Documenter

makedocs(;
    modules=[AcuteML],
    authors="Amin Yahyaabadi",
    repo="https://github.com/aminya/AcuteML.jl/blob/{commit}{path}#L{line}",
    sitename="AcuteML.jl",
    format=Documenter.HTML(;
        prettyurls = prettyurls = get(ENV, "CI", nothing) == "true",
        # canonical="https://aminya.github.io/AcuteML.jl",
        # assets=String[],
    ),
    pages=[
        "Home" => "index.md",

        "Value Checking" => "valueChecking.md",
        "Supported Value Types" => "supportedValueTypes.md",
        "Extra Contructors" => "extraConstructors.md",

        "Custom Value Types" => "customValueTypes.md",
        "Custom Contructors - AcuteML Backend" => "customConstructors.md",

        "Templating" => "templating.md",
        "Syntax Reference" => "SyntaxReference.md"
    ],
)

deploydocs(;
    repo="github.com/aminya/AcuteML.jl",
)
