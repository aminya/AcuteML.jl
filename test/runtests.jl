using AML
using Test


@aml struct Person "person"
    age::UInt, "age"
    field::String, "study-field"
    GPA::Float64 = 4.5, "GPA"
    courses::Vector{String}, "taken-courses"
    ID::Int64, a"id"
end

@aml struct University "university"
    name, a"university-name"
    people::Vector{Person}, "person"
end

@aml struct Doc xd""
    university::University, "university"
end

@testset "constructor" begin

    P1 = Person(age=24, field="Mechanical Engineering", courses=["Artificial Intelligence", "Robotics"], ID = 1)
    P2 = Person(age=18, field="Computer Engineering", GPA=4, courses=["Julia"], ID = 2)

    U = University(name="Julia University", people=[P1, P2])

    D = Doc(university = U)


    @test print(P1.aml) == print(strip("""
    <person id="1">
      <age>24</age>
      <study-field>Mechanical Engineering</study-field>
      <GPA>4.5</GPA>
      <taken-courses>Artificial Intelligence</taken-courses>
      <taken-courses>Robotics</taken-courses>
    </person>
    """))

    @test print(P2.aml) == print(strip("""
    <person id="2">
      <age>18</age>
      <study-field>Computer Engineering</study-field>
      <GPA>4</GPA>
      <taken-courses>Julia</taken-courses>
    </person>
    """))

    @test print(U.aml) == print(strip("""
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
    """))

    @test print(D.aml) == print(strip("""
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

    U = University(D.university)

    @test U.name == "Julia University"


    # extract Person

    P1 = Person(U.people[1])

    @test P1.age == 24
    @test P1.field == "Mechanical Engineering"
    @test P1.GPA == 4.5
    @test P1.courses == ["Artificial Intelligence", "Robotics"]
    @test P1.ID == 1

    P2 = Person(U.people[2])

    @test print(P2.aml) == print(strip("""
    <person id="2">
        <age>18</age>
        <study-field>Computer Engineering</study-field>
        <GPA>4</GPA>
        <taken-courses>Julia</taken-courses>
      </person>
    """))

end
