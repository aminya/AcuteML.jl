using AML

@aml mutable struct Person "person"
    age::UInt, "age"
    field::String, "study-field"
    GPA::Float64 = 4.3 , "GPA (/4.5)"
    courses::Vector{String}, "taken courses"
end


P1 = Person(age=24, field="Mechanical Engineering", GPA=2, courses=["Artificial Intelligence", "Robotics"])
P2 = Person(age=18, field="Computer Engineering", GPA=4, courses=["Julia"])

print(P1.aml)
#=
<person>
  <age>24</age>
  <study-field>Mechanical Engineering</study-field>
  <taken courses>Artificial Intelligence</taken courses>
  <taken courses>Robotics</taken courses>
</person>
=#

print(P2.aml)
#=
<person>
  <age>18</age>
  <study-field>Computer Engineering</study-field>
  <taken courses>Julia</taken courses>
</person>
=#
