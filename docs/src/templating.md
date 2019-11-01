# Templating
AcuteML also provides a templating engine if you want to use templates instead of creating the types.

-------------------------------------------------------

# Template Rendering using Functions

This method only uses functions that return string. You can build your desired string and call the function for rendering.

```julia
## create person function to store out html template
newTemplate("person", :function)


function person(;id, age, field, GPA, courses)

  # Build the taken courses section
  loopOut=""
  for course in courses
    loopOut = loopout * """ <taken-courses>$(course)</taken-courses>   """
  end

  # Append all the sections and variables together
  out = """
  <person id=$(id)>
    <age>$(age)</age>
    <study-field>$(field)</study-field>
    <GPA>$(GPA)</GPA>
    $loopout
  </person>
  """

  return out
end

# Call the function for rendering
out = person(
  id = "1",
  age = "24",
  field = "Mechanical Engineering",
  GPA = "4.5",
  courses = ["Artificial Intelligence", "Robotics"]
)

print(out)

# you can also write the output to a file:
file = open(filePath, "r"); print(file, out); close(file)
```

-------------------------------------------------------
# Template Rendering using Files

You can render variables into html/xml files. However, you can't have multiline control flow Julia code in this method.

```julia
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
```
