```@meta
CurrentModule = AcuteML
```

# AcuteML
## Acute Markup Language

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

# Main macro and I/O

Use `@aml` macro to define a Julia type, and then the package automatically creates a xml or html associated with the defined type.

# Type defnition

* Use `xd""` or `hd""` to define a XML or HTML document:
```julia
@aml struct Doc xd""
  # add fields(elements) here
end
```
* Specify the element name in a string after the struct name
```julia
@aml struct Person "person"
  # add fields(elements) here
end
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
* To define any restrictions for the values of one field, put the function name that checks a criteria and returns Bool:
```julia
GPA::Float64, "GPA", GPAcheck
```
* Use `sc"name"` to define a self-closing (empty) element (e.g. `<rest />`)
```julia
@aml struct rest sc"rest"
  # add fields(elements) here
end
```
-------------------------------------------------------

# Example 1 - Constructor
```julia
using AcuteML

GPAcheck(x) = x <= 4.5 && x >= 0

@aml struct Person "person"
    age::UInt, "age"
    field::String, "study-field"
    GPA::Float64 = 4.5, "GPA", GPAcheck
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

```julia
# An example that doesn't meet the critertia function for GPA because GPA is more than 4.5
P3 = Person(age=99, field="Macro Wizard", GPA=10, courses=["Julia Magic"], ID = 3)
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

# Example for Common Restriction functions

Restrictions should be given as a function that returns Bool and the function checks for elements.

For example, for a vector of strings:
```julia
@aml struct Person "person"
   member::Vector{String}, "member", memberCheck
end
```
Value limit check:
```julia
memberCheck(x) = any( x>10 || x<5 )  # in a compact form: x-> any(x>10 || x<5)
# x is all the values as a vector in this case
```

Check of the length of the vector:
```julia
memberCheck(x) = 0 < length(x) && length(x) < 10
```
User should know if the vector is going to be 0-element, its type should be union with nothing, i.e., UN{}. This is because of the EzXML implementation of findfirst and findall.

Set of valuse:
```julia
setOfValues = [2,4,10]
memberCheck(x) = in.(x, setOfValues)
```
