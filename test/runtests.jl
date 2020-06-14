using AcuteML
using Test, Suppressor, DataFrames

stripall(x::String) = replace(x, r"\s|\n" => "")

##
include("struct_definition.jl")
include("creator.jl")
include("extractor.jl")
include("tables.jl")
include("xmlutils.jl")
include("customcode.jl")
include("errors.jl")

@testset "templating" begin
    include("../examples/templating/templating.jl")
end
@testset "simple" begin
    include("../examples/simple.jl")
end

## MusicXML tests
# TODO does Pkg.test("MusicXML", coverage=true) add to AcuteML coverage?
include("musicxml/musicxml.jl")
