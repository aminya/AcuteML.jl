using AcuteML
using Test, Suppressor

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

@testset "constructor" begin

    P1 = Person(age=24, field="Mechanical Engineering", courses=["Artificial Intelligence", "Robotics"], id = 1)
    P2 = Person(age=18, field="Computer Engineering", GPA=4, courses=["Julia"], id = 2)

    P2.GPA=4.2 # mutability support

    U = University(name="Julia University", people=[P1, P2])

    D = Doc(university = U)

    @test @capture_out(print(P1.aml)) == @capture_out(print(strip("""
    <person id="1">
      <age>24</age>
      <study-field>Mechanical Engineering</study-field>
      <GPA>4.5</GPA>
      <taken-courses>Artificial Intelligence</taken-courses>
      <taken-courses>Robotics</taken-courses>
    </person>
    """)))

    @test @capture_out(print(P2.aml)) == print(strip("""
    <person id="2">
      <age>18</age>
      <study-field>Computer Engineering</study-field>
      <GPA>4.2</GPA>
      <taken-courses>Julia</taken-courses>
    </person>
    """))

    @test @capture_out(print(U.aml)) == print(strip("""
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
    """))

    @test @capture_out(print(D.aml)) == print(strip("""
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
    """))


end

@testset "extractor" begin

    xml = parsexml("""
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
        <GPA>4</GPA>
        <taken-courses>Julia</taken-courses>
      </person>
    </university>
    """)

    # extract Doc

    D = Doc(xml)

    # extract University

    U = D.university

    @test U.name == "Julia University"


    # extract Person

    P1 = U.people[1]

    @test P1.age == 24
    @test P1.field == "Mechanical Engineering"
    @test P1.GPA == 4.5
    @test P1.courses == ["Artificial Intelligence", "Robotics"]
    @test P1.id == 1

    P2 = U.people[2]

    @test @capture_out(print(P2.aml)) == print(strip("""
    <person id="2">
        <age>18</age>
        <study-field>Computer Engineering</study-field>
        <GPA>4</GPA>
        <taken-courses>Julia</taken-courses>
      </person>
    """))

end
