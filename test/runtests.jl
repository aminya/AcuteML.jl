using AcuteML
using Test, Suppressor, DataFrames

stripall(x::String) = replace(x, r"\s|\n"=>"")

# Type Definition
@aml mutable struct Person "person", courseCheck
    age::UInt64, "~"
    field, "study-field"
    GPA::Float64 = 4.5, "~", GPAcheck
    courses::Vector{String}, "taken-courses"
    professors::UN{DataFrame} = nothing, "table"
    id::Int64, att"~"
end

@aml mutable struct University doc"university"
    name, att"university-name"
    people::Vector{Person}, "person"
end

# Value Checking Functions
GPAcheck(x) = x <= 4.5 && x >= 0

function courseCheck(age, field, GPA, courses, professors, id)

    if field == "Mechanical Engineering"
        relevant = ["Artificial Intelligence", "Robotics", "Machine Design"]
    elseif field == "Computer Engineering"
        relevant = ["Julia", "Algorithms"]
    else
        error("study field is not known")
    end

    return any(in.(courses, Ref(relevant)))
end

include("constructor.jl")
include("extractor.jl")
include("tables.jl")
include("xmlutils.jl")
