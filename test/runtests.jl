using AcuteML
using Test, Suppressor, DataFrames

stripall(x::String) = replace(x, r"\s|\n"=>"")

##
include("struct_definition.jl")
include("creator.jl")
include("extractor.jl")
include("tables.jl")
include("xmlutils.jl")
include("customcode.jl")
# include("musicxml/musicxml.jl")
