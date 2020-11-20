# see examples.jl first

# Creator

P1 = Person(age=24, field="Mechanical Engineering", courses = ["Artificial Intelligence", "Robotics"], id = 1, comment = "He is a genius")

P2 = Person(age=18, field="Computer Engineering", GPA=4, courses=["Julia"], id = 2)

# Two examples that doesn't meet the critertia function for GPA because GPA is more than 4.5
#=
P3 = Person(age=99, field="Macro Wizard", GPA=10, courses=["Julia Magic"], id = 3)
# GPA doesn't meet criteria function

P1.GPA=5.0
# GPA doesn't meet criteria function
=#

U = University(name="Julia University", people=[P1, P2])

U.people[2].GPA=4.2 # mutability support after Doc creation

pprint(P1) # or print(P1.aml)
#=
<person id="1">
  <age>24</age>
  <study-field>Mechanical Engineering</study-field>
  <GPA>4.5</GPA>
  <taken-courses>Artificial Intelligence</taken-courses>
  <taken-courses>Robotics</taken-courses>
  He is a genius
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
<?xml version="1.0" encoding="UTF-8"?>
<university university-name="Julia University">
  <person id="1"><age>24</age><study-field>Mechanical Engineering</study-field><GPA>4.5</GPA><taken-courses>Artificial Intelligence</taken-courses><taken-courses>Robotics</taken-courses>He is a genius</person>
  <person id="2">
    <age>18</age>
    <study-field>Computer Engineering</study-field>
    <GPA>4.2</GPA>
    <taken-courses>Julia</taken-courses>
  </person>
</university>
=#
