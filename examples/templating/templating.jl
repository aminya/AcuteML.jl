using AML

#################################################################
# Rendering using Files - example:

# only to set path to current file
cd(@__DIR__)



# you can create a file and edit the file directly by using
newTemplate("person")

# Add the following html code to the generated html file
#=
<person id=$(id)>
  <age>$(age)</age>
  <study-field>$(field)</study-field>
  <GPA>$(GPA)</GPA>
  <taken-courses>$(courses[1])</taken-courses>
  <taken-courses>$(courses[2])</taken-courses>
</person>
=#

# Specify the template (or its path), and also the variables for rendering
out =render2file("person", false,
  id = 1,
  age = 24,
  field = "Mechanical Engineering",
  GPA = 4.5,
  courses = ["Artificial Intelligence", "Robotics"])

# you pass `true` as the 2nd argument to owerwrite person.html statically.

#################################################################
# Rendering using Functions - example:

## create person function to store out html template
newTemplate("person", :function)


function person(;id, age, field, GPA, courses)

"""
<person id=$(id)>
  <age>$(age)</age>
  <study-field>$(field)</study-field>
  <GPA>$(GPA)</GPA>
  <taken-courses>$(courses[1])</taken-courses>
  <taken-courses>$(courses[2])</taken-courses>
</person>
"""

end

out = person(
  id = "1",
  age = "24",
  field = "Mechanical Engineering",
  GPA = "4.5",
  courses = ["Artificial Intelligence", "Robotics"]
)

print(out)
