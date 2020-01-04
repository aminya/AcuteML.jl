using AcuteML, DataFrames

# Type Definition
@aml mutable struct Person "person", courseCheck
    age::UInt64, "~"
    field, "study-field"
    GPA::Float64 = 4.5, "~", GPAcheck
    courses::Vector{String}, "taken-courses"
    professors::UN{DataFrame} = nothing, "~"
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


# Constructor

P1 = Person(age=24, field="Mechanical Engineering", courses = ["Artificial Intelligence", "Robotics"], id = 1)

P2 = Person(age=18, field="Computer Engineering", GPA=4, courses=["Julia"], id = 2)

# Two examples that doesn't meet the critertia function for GPA because GPA is more than 4.5
#=
P3 = Person(age=99, field="Macro Wizard", GPA=10, courses=["Julia Magic"], id = 3)
# GPA doesn't meet criteria function

P1.GPA=5.0
# GPA doesn't meet criteria function
=#

U = University(name="Julia University", people=[P1, P2])

D = Doc(university = U)

D.university.people[2].GPA=4.2 # mutability support after Doc creation


pprint(P1) # or print(P1.aml)
#=
<person id="1">
  <age>24</age>
  <study-field>Mechanical Engineering</study-field>
  <GPA>4.5</GPA>
  <taken-courses>Artificial Intelligence</taken-courses>
  <taken-courses>Robotics</taken-courses>
</person>
=#

pprint(P2) # or print(P2.aml)
#=
<person id="2">
  <age>18</age>
  <study-field>Computer Engineering</study-field>
  <GPA>4.2</GPA>
  <taken-courses>Julia</taken-courses>
</person>
=#

pprint(U) # or print(U.aml)
#=
<university university-name="Julia University">
  <person id="1">
    <age>24</age>
    <study-field>Mechanical Engineering</study-field>
    <GPA>4.5</GPA>
    <taken-courses>Artificial Intelligence</taken-courses>
    <taken-courses>Robotics</taken-courses>
  </person>
  <person id="2">
    <age>18</age>
    <study-field>Computer Engineering</study-field>
    <GPA>4.2</GPA>
    <taken-courses>Julia</taken-courses>
  </person>
</university>
=#

pprint(D) # or print(D.aml)
#=
<?xml version="1.0" encoding="UTF-8" standalone="yes"?><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
<university university-name="Julia University">
  <person id="1">
    <age>24</age>
    <study-field>Mechanical Engineering</study-field>
    <GPA>4.5</GPA>
    <taken-courses>Artificial Intelligence</taken-courses>
    <taken-courses>Robotics</taken-courses>
  </person>
  <person id="2">
    <age>18</age>
    <study-field>Computer Engineering</study-field>
    <GPA>4.2</GPA>
    <taken-courses>Julia</taken-courses>
  </person>
</university>
=#
