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
]add https://github.com/aminya/AcuteML.jl
```
# Usage
Use the package:
```julia
using AcuteML
```

# Documentation
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://aminya.github.io/AcuteML.jl/dev)

-------------------------------------------------------

# Type defnition
Use `@aml` macro to define a Julia type, and then the package automatically creates a xml or html associated with the defined type.

### Document Defnition
* Use `xd""` or `hd""` to define a XML or HTML document:
```julia
@aml mutable struct Doc xd""
  # add fields (elements) here
end
```

### Nodes (Elements) Defnition
* Specify the html/xml struct name as a string after the struct name after a space
```julia
@aml mutable struct Person "person"
  # add fields (elements) here
end
```
* If the html/xml name is the same as struct name, you can use `"~"` instead
```julia
@aml mutable struct person "~"
  # add fields (elements) here
end
```

### Fields Names
* Sepecify the html/xml field name as a string in front of the field after `,`
```julia
field, "study-field"
```
* If the html/xml name is the same as variable name, you can use `"~"` instead
```julia
age::UInt, "~"
```

### Attributes
* If the value is going to be an attribute put `a` before its name
```julia
id::Int64, a"~"
```

### Default Value
* You can specify the default value for an argument by using `= defVal` syntax
```julia
GPA::Float64 = 4.5, "~"
```

### Value Types
You can use Julia types or  defined types for values.

* If you don't specify the type of a variable, it is considered to be string:
```julia
field, "study-field"
```

* For already `@aml` defined types, name should be the same as the defined type root name
```julia
university::University, "university"
```

### Value Checking
You can define any restriction for values using functions.

* To define any restrictions for the values of one field, define a function that checks a criteria for the field value and returns Bool, and put its name after a `,` after the field name:
```julia
GPA::Float64, "~", GPAcheck
```

* To define any restrictions for multiple values of a struct, define a function that gets all the variables and checks a criteria and returns Bool, and put its name after a `,` after the struct name:
```julia
@aml mutable struct Person "person", courseCheck
# ...
end
```

Refer to https://aminya.github.io/AcuteML.jl/dev/valueChecking/ for some of these functions examples.

### Optional Fields
* If a field is optional, don't forget to define its type as `UN{}` (Union with Nothing), and set the default value as `nothing`.
```julia
residence::UN{String}=nothing, "residence-stay" # optional with nothing as default value
```
```julia
funds::UN{String}, "financial-funds"   # optional, but you should pass nothing manually in construction
```

### Empty Elements (Self-Closing) Defnition
* Use `sc"name"` to define a self-closing (empty) element (e.g. `<rest />`)
```julia
@aml struct rest sc"~"
end
```
-------------------------------------------------------

# Example - Type Definition
```julia
using AcuteML

# Types definition

# Person Type
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

```julia

P1 = Person(age=24, field="Mechanical Engineering", courses=["Artificial Intelligence", "Robotics"], id = 1)
P2 = Person(age=18, field="Computer Engineering", GPA=4, courses=["Julia"], id = 2)

P2.GPA=4.2 # mutability support

U = University(name="Julia University", people=[P1, P2])

D = Doc(university = U)
```

```julia
# An example that doesn't meet the critertia function for GPA because GPA is more than 4.5
P3 = Person(age=99, field="Macro Wizard", GPA=10, courses=["Julia Magic"], id = 3)
julia>
GPA doesn't meet criteria function
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
    <GPA>4.2</GPA>
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
    <GPA>4.2</GPA>
    <taken-courses>Julia</taken-courses>
  </person>
</university>
```
-------------------------------------------------------

# Example - Extractor
```julia
using AcuteML

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

# you pass `true` as the 2nd argument to owerwrite person.html statically.
```
