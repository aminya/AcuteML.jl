using AcuteML
using Test, Suppressor, DataFrames

stripall(x::String) = replace(x, r"\s|\n"=>"")

##
include("struct_definition.jl")
include("struct_parametric.jl")
include("struct_empty.jl")
include("creator.jl")
include("extractor.jl")
include("tables.jl")
include("xmlutils.jl")
include("customcode.jl")
# include("musicxml/musicxml.jl")

@testset "templating" begin
    include("../examples/templating/templating.jl")
end

@testset "simple" begin
    include("../examples/simple.jl")
end

include("errors.jl")


include("musicxml/musicxml.jl")
