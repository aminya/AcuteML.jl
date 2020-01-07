# AcuteML
## Acute Markup Language

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://aminya.github.io/AcuteML.jl/dev)
[![Build Status (Travis)](https://travis-ci.com/aminya/AcuteML.jl.svg?branch=master)](https://travis-ci.com/aminya/AcuteML.jl)
[![Build status (Appveyor)](https://ci.appveyor.com/api/projects/status/65fuh2yi0qx99rv4?svg=true)](https://ci.appveyor.com/project/aminya/acuteml-jl)


AcuteML is an Acute Markup Language (AML) for Web/XML development in Julia.

* It automatically creates or extracts HTML/XML files from Julia types!

* It also has a general templating engine, which can be used for any type of documents.

# Installation
Add the package
```julia
using Pkg
Pkg.add("AcuteML")
```
# Usage
Use the package:
```julia
using AcuteML
```

# Documentation
Click on the badge: [![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://aminya.github.io/AcuteML.jl/dev)

See [Type Definition](https://aminya.github.io/AcuteML.jl/dev/#Main-macro-and-I/O-1) for comprehensive introduction to syntax. You can use `@aml` macro to define a Julia type, and then the package automatically creates a xml or html associated with the defined type.

-----------------------------------------------

# Example - Struct Definition

First, we define the structs using `@aml` to store the data in:

```julia
using AcuteML

# Types definition

# Person Type
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

@aml mutable struct Doc "xml"
    university::University, "~"
end

```

```julia
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
```
-------------------------------------------------------

# Example - Constructor

After we defined the structs, we can create instances of them by passing our data to the fields:

```julia

P1 = Person(age=24, field="Mechanical Engineering", courses=["Artificial Intelligence", "Robotics"], id = 1)
P2 = Person(age=18, field="Computer Engineering", GPA=4, courses=["Julia"], id = 2)

U = University(name="Julia University", people=[P1, P2])

D = Doc(university = U)

D.university.people[2].GPA=4.2 # mutability support after Doc creation

```

```julia
# An example that doesn't meet the criteria function for GPA because GPA is more than 4.5
P3 = Person(age=99, field="Macro Wizard", GPA=10, courses=["Julia Magic"], id = 3)
julia>
GPA doesn't meet criteria function
```

```html
julia> pprint(P1) # or print(P1.aml)
<person id="1">
  <age>24</age>
  <study-field>Mechanical Engineering</study-field>
  <GPA>4.5</GPA>
  <taken-courses>Artificial Intelligence</taken-courses>
  <taken-courses>Robotics</taken-courses>
</person>

julia> pprint(U) # or print(U.aml)
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

julia> pprint(D) # or print(D.aml)
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
```

P3 with Tables.jl type:
```julia
Profs1 = DataFrame(course = ["Artificial Intelligence", "Robotics"], professor = ["Prof. A", "Prof. B"] )

P3 = Person(age=24, field="Mechanical Engineering", courses = ["Artificial Intelligence", "Robotics"], professors= Profs1, id = 1)
```
```html
julia> pprint(P3)

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
```
-------------------------------------------------------

# Example - Extractor

After we defined the structs, we can automatically extract and store the data in their fields:


```julia
using AcuteML

xml = parsexml("""
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

# extract Doc
D = Doc(xml) # StructName(xml) like Doc(xml) extracts the data and stores them in proper format

# Now you can access all of the data by calling the fieldnames

# extract University
U = D.university

julia>U.name
"Julia University"

# extract Person

P1 = U.people[1]

julia>P1.age
24

julia>P1.field
Mechanical Engineering

julia>P1.GPA
4.5

julia>P1.courses
["Artificial Intelligence", "Robotics"]

julia>P1.id
1
```

-------------------------------------------------------
# Templating
AcuteML also provides a templating engine if you want to use templates instead of creating the types.

-------------------------------------------------------

# Example - Template Rendering using Functions

This method only uses functions that return string. You can build your desired string and call the function for rendering.

```julia
## create person function to store out html template
newTemplate("person", :function)


function person(;id, age, field, GPA, courses)

  # Build the taken courses section
  loopOut=""
  for course in courses
    loopOut = loopOut * """ <taken-courses>$(course)</taken-courses>   """
  end

  # Append all the sections and variables together
  out = """
  <person id=$(id)>
    <age>$(age)</age>
    <study-field>$(field)</study-field>
    <GPA>$(GPA)</GPA>
    $loopOut
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
# Example - Template Rendering using Files

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

# you pass `true` as the 2nd argument to overwrite person.html statically.
```
