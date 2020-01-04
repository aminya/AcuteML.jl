using AcuteML, BenchmarkTools

# Type Definition

@aml mutable struct Person "person", courseCheck
    age::UInt64, "~"
    field, "study-field"
    GPA::Float64 = 4.5, "~", GPAcheck
    courses::Vector{String}, "taken-courses"
    id::Int64, a"~"
end

@aml mutable struct University "university"
    name, a"university-name"
    people::Vector{Person}, "person"
end

@aml mutable struct Doc xd""
    university::University, "~"
end

# Value Checking Functions
GPAcheck(x) = x <= 4.5 && x >= 0

function courseCheck(age, field, GPA, courses, id)

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
#Benchmark
function creation()
    P1 = Person(age=24, field="Mechanical Engineering", courses=["Artificial Intelligence", "Robotics"], id = 1)

    P2 = Person(age=18, field="Computer Engineering", GPA=4, courses=["Julia"], id = 2)

    U = University(name="Julia University", people=[P1, P2])

    D = Doc(university = U)
    return P1, P2, U, D
end

function mutability(P1, P2, U, D)
    P1.age = UInt(22)
    # P1.courses = ["Artificial Intelligence", "Robotics", "Machine Design"]

    P2.GPA=4.2 # mutability support
    U.name = "MIT"
    return P1, P2, U, D
end

@btime creation();

P1, P2, U, D = creation();

@btime mutability($P1, $P2, $U, $D);
