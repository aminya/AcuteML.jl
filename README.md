# AML

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://aminya.github.io/AML.jl/dev)
[![Build Status](https://travis-ci.com/aminya/AML.jl.svg?branch=master)](https://travis-ci.com/aminya/AML.jl)

AML web development package in Julia

It automatically creates/extracts HTML/XML files from Julia types!

# Installation
Add the package
```julia
]add https://github.com/aminya/AML.jl
```
# Usage
Use the package:
```julia
using AML
```

# Documentation
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://aminya.github.io/AML.jl/dev)

-------------------------------------------------------

Use `@aml` macro to define a Julia type, and then the package automatically creates a xml or html associated with the defined type.

# Type defnition

* Use `xd""` or `hd""` to define a XML or HTML document:
```julia
@aml struct Doc xd""
```
* Specify the element name in a string after the struct name
```julia
@aml struct Person "person"
```
* Sepecify the html/xml name for childs in a string in front of the field after `,`
```julia
age::UInt, "age"
```
* For already `@aml` defined types, name should be the same as its html/xml name
```julia
university::University, "university"
```
* If the value is going to be an attribute put `a` before its name
```julia
ID::Int64, a"id"
```
* You can specify the default value for an argument by using `= defVal` syntax
```julia
GPA::Float64 = 4.5, "GPA"
```
-------------------------------------------------------

# Example 1 - Constructor
```julia
using AML

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


P1 = Person(age=24, field="Mechanical Engineering", courses=["Artificial Intelligence", "Robotics"], ID = 1)
P2 = Person(age=18, field="Computer Engineering", GPA=4, courses=["Julia"], ID = 2)

U = University(name="Julia University", people=[P1, P2])

D = Doc(university = U)
```

```html
julia> print(P1.aml)
<person id="1">
  <age>24</age>
  <study-field>Mechanical Engineering</study-field>
  <GPA>4.5</GPA>
  <taken-courses>Artificial Intelligence</taken-courses>
  <taken-courses>Robotics</taken-courses>
</person>

julia> print(P2.aml)
<person id="2">
  <age>18</age>
  <study-field>Computer Engineering</study-field>
  <GPA>4</GPA>
  <taken-courses>Julia</taken-courses>
</person>

julia> print(U.aml)
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

julia> print(D.aml)
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

```
-------------------------------------------------------

# Example 2 - Extractor
```julia
using AML

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

# extract Doc

D = Doc(xml)


# extract University

U = University(D.university)

julia>U.name
"Julia University"


# extract Person

P1 = Person(U.people[1])

julia>P1.age
24

julia>P1.field
Mechanical Engineering

julia>P1.GPA
4.5

julia>P1.courses
["Artificial Intelligence", "Robotics"]

julia>P1.ID
1

P2 = Person(U.people[2])

```

-------------------------------------------------------
# Templating
AML also provides a templating engine if you want to use templates instead of creating the types.

-------------------------------------------------------

# Example 3 - Template Rendering using Functions

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
# Example 4 - Template Rendering using Files

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
