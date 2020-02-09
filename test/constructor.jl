@testset "constructor" begin

    P1 = Person(age=24, field="Mechanical Engineering", courses = ["Artificial Intelligence", "Robotics"], id = 1)

    P2 = Person(age=18, field="Computer Engineering", GPA=4, courses=["Julia"], id = 2)

    U = University(name="Julia University", people=[P1, P2])

    U.people[2].GPA=4.2 # mutability support after Doc creation

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
    <?xml version="1.0" encoding="UTF-8"?>
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
