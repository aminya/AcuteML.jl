# see exmaples.jl first

# Type Definition
@aml mutable struct Person "person", check_course
    age::UInt64, "~"
    field, "study-field"
    GPA::Float64 = 4.5, "~", GPAcheck
    courses::Vector{String}, "taken-courses"
    professors::UN{DataFrame} = nothing, "table"
    id::Int64, att"~"
    comment::UN{String} = nothing, txt"end"
end

@aml mutable struct University doc"university"
    name, att"university-name"
    people::Vector{Person}, "person"
end

# Value Checking Functions
GPAcheck(x) = x <= 4.5 && x >= 0

function check_course(age, field, GPA, courses, professors, id, comment)

    if field == "Mechanical Engineering"
        relevant = ["Artificial Intelligence", "Robotics", "Machine Design"]
    elseif field == "Computer Engineering"
        relevant = ["Julia", "Algorithms"]
    else
        error("study field is not known")
    end

    return any(in.(courses, Ref(relevant)))
end
