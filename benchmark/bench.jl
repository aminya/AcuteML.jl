using AcuteML, BenchmarkTools

# Type Definition

@aml mutable struct Person "person", check_course
    age::UInt64, "~"
    field, "study-field"
    GPA::Float64 = 4.5, "~", GPAcheck
    courses::Vector{String}, "taken-courses"
    id::Int64, att"~"
end

@aml mutable struct University
    doc"university"
    name, att"university-name"
    people::Vector{Person}, "person"
end

# Value Checking Functions
GPAcheck(x) = x <= 4.5 && x >= 0

function check_course(age, field, GPA, courses, id)

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
    P1 = Person(age = 24, field = "Mechanical Engineering", courses = ["Artificial Intelligence", "Robotics"], id = 1)

    P2 = Person(age = 18, field = "Computer Engineering", GPA = 4, courses = ["Julia"], id = 2)

    U = University(name = "Julia University", people = [P1, P2])

    return P1, P2, U
end

function mutability(P1, P2, U)
    P1.age = UInt(22)
    # P1.courses = ["Artificial Intelligence", "Robotics", "Machine Design"]

    P2.GPA = 4.2 # mutability support
    U.name = "MIT"
    return P1, P2, U
end

function extraction()
    xml = parsexml("""
      <?xml version="1.0" encoding="UTF-8"?>
      <university university-name="MIT">
        <person id="1">
          <age>22</age>
          <study-field>Mechanical Engineering</study-field>
          <GPA>4.5</GPA>
          <taken-courses>Artificial Intelligence</taken-courses>    <taken-courses>Robotics</taken-courses>
        </person>
        <person id="2">
          <age>18</age>
          <study-field>Computer Engineering</study-field>
          <GPA>4.2</GPA>
          <taken-courses>Julia</taken-courses>
        </person>
      </university>
      """)
    U = University(xml)
end

@btime creation();

P1, P2, U = creation();

@btime mutability($P1, $P2, $U);

@btime extraction();
