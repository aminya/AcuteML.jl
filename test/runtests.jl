using AcuteML
using Test, Suppressor, DataFrames

# Type Definition
@aml mutable struct Person "person", courseCheck
    age::UInt64, "~"
    field, "study-field"
    GPA::Float64 = 4.5, "~", GPAcheck
    courses::Vector{String}, "taken-courses"
    professors::UN{DataFrame} = nothing, "table"
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

stripall(x::String) = replace(x, r"\s|\n"=>"")

@testset "constructor" begin

    P1 = Person(age=24, field="Mechanical Engineering", courses = ["Artificial Intelligence", "Robotics"], id = 1)

    P2 = Person(age=18, field="Computer Engineering", GPA=4, courses=["Julia"], id = 2)

    U = University(name="Julia University", people=[P1, P2])

    D = Doc(university = U)

    D.university.people[2].GPA=4.2 # mutability support after Doc creation

    @test stripall(@capture_out(pprint(P1))) == stripall("""
    <person id="1">
      <age>24</age>
      <study-field>Mechanical Engineering</study-field>
      <GPA>4.5</GPA>
      <taken-courses>Artificial Intelligence</taken-courses>
      <taken-courses>Robotics</taken-courses>
    </person>
    """)

    @test stripall(@capture_out(pprint(P2))) == stripall("""
    <person id="2">
      <age>18</age>
      <study-field>Computer Engineering</study-field>
      <GPA>4.2</GPA>
      <taken-courses>Julia</taken-courses>
    </person>
    """)

    @test stripall(@capture_out(pprint(U.aml))) == stripall("""
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
    """)

    @test stripall(@capture_out(pprint(D))) == stripall("""
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
    """)
end

@testset "Tables" begin

    # Tables
    Profs1 = DataFrame(course = ["Artificial Intelligence", "Robotics"], professor = ["Prof. A", "Prof. B"] )

    P3 = Person(age=24, field="Mechanical Engineering", courses = ["Artificial Intelligence", "Robotics"], professors= Profs1, id = 1)

    @test stripall(@capture_out(pprint(P3))) == stripall("""
    <person id="1">
  <age>24</age>
  <study-field>Mechanical Engineering</study-field>
  <GPA>4.5</GPA>
  <taken-courses>Artificial Intelligence</taken-courses>
  <taken-courses>Robotics</taken-courses>
  <table>
<tr class="header">
<th style="text-align: right; ">course</th>
<th style="text-align: right; ">professor</th>
</tr>
<tr class="subheader headerLastRow">
<th style="text-align: right; ">String</th>
<th style="text-align: right; ">String</th>
</tr>
<tr>
<td style="text-align: right; ">Artificial Intelligence</td>
<td style="text-align: right; ">Prof. A</td>
</tr>
<tr>
<td style="text-align: right; ">Robotics</td>
<td style="text-align: right; ">Prof. B</td>
</tr>
</table>
</person>
    """)

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

    @test stripall(@capture_out(pprint(P2))) == stripall("""
    <person id="2">
        <age>18</age>
        <study-field>Computer Engineering</study-field>
        <GPA>4</GPA>
        <taken-courses>Julia</taken-courses>
      </person>
    """)

end
