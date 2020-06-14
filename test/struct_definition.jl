
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

################################################################

# parametric
@aml mutable struct MyGeneralXML{T} "~"
    myfield::T, "~"
end
pxml_string = MyGeneralXML{String}(myfield = "a")
pprint(pxml_string)
pxml_vector = MyGeneralXML{Vector{String}}(myfield = ["b","c"])
pprint(pxml_vector)

@aml mutable struct MyGeneralXML2{T} "MyGeneralXML2"
    myfield::T, "~"
end
################################################################

# empty or no aml
@aml mutable struct NoAMLFields empty"no-aml-fields"
    a, "~"
    b = 1
    c::String = 10
    d
    e::String
    f = "hey", "~"
end

function meta_check(a, b, c, d, e, f)
    return d
end

@aml mutable struct NoAMLFields2 empty"~", meta_check
    a, "~"
    b = 1
    c::String = 10
    d
    e::String
    f = "hey", "~"
end

# The method does not create keyword arguments for normal fiels
@test_throws MethodError NoAMLFields2(a="a", d=true)
@test_broken NoAMLFields2(a="a")

# TODO Should make @aml add keyword arguments on top of normal arguments


@aml mutable struct NoAMLFields3 empty"NoAMLFields3", meta_check
    a, "~"
    b = 1
    c::String = 10
    d
    e::String
    f = "hey", "~"
end
