using AML
using Test


@aml struct Person "person"
    age::UInt, "age"
    field::String, "study-field"
    GPA::Float64 = 4.5, "GPA"
    courses::Vector{String}, "taken-courses"
end


@aml struct University "university"
    name, "university-name"
    people::Vector{Person}, "students"
end

P1 = Person(age=24, field="Mechanical Engineering", courses=["Artificial Intelligence", "Robotics"])
P2 = Person(age=18, field="Computer Engineering", GPA=4, courses=["Julia"])

U = University(name="Julia University", people=[P1, P2])

@testset "AML.jl" begin


    @test print(P1.aml) == print(strip("""
    <person>
      <age>24</age>
      <study-field>Mechanical Engineering</study-field>
      <GPA>4.5</GPA>
      <taken-courses>Artificial Intelligence</taken-courses>
      <taken-courses>Robotics</taken-courses>
    </person>
    """))

    @test print(P2.aml) == print(strip("""
    <person>
      <age>18</age>
      <study-field>Computer Engineering</study-field>
      <GPA>4</GPA>
      <taken-courses>Julia</taken-courses>
    </person>
    """))

    @test print(U.aml) == print(strip("""
    <university>
      <university-name>Julia University</university-name>
      <person>
        <age>24</age>
        <study-field>Mechanical Engineering</study-field>
        <GPA>4.5</GPA>
        <taken-courses>Artificial Intelligence</taken-courses>
        <taken-courses>Robotics</taken-courses>
      </person>
      <person>
        <age>18</age>
        <study-field>Computer Engineering</study-field>
        <GPA>4</GPA>
        <taken-courses>Julia</taken-courses>
      </person>
    </university>
    """))


end
