# AML

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://aminya.github.io/AML/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://aminya.github.io/AML/dev)
[![Build Status](https://travis-ci.com/aminya/AML.svg?branch=master)](https://travis-ci.com/aminya/AML)

AML web development framework in Julia

It automatically creates/extracts HTML/XML files from Julia types!

Use `@aml` macro to define a Julia type, and then the package automatically creates a xml or html associated with the defined type.

* Specify the root html/xml name in a string after the struct name
* Sepecify the html/xml names for childs in strings in front of the struct fields after `,`
* You can specify the default value for a argument by using `= defVal` syntax

# Example
```julia
using AML

@aml struct Person "person"
    age::UInt, "age"
    field::String, "study-field"
    GPA::Float64 = 4.5, "GPA"
    courses::Vector{String}, "taken courses"
end


@aml struct University "university"
    name, "university-name"
    people::Vector{Person}, "students"
end

P1 = Person(age=24, field="Mechanical Engineering", courses=["Artificial Intelligence", "Robotics"])
P2 = Person(age=18, field="Computer Engineering", GPA=4, courses=["Julia"])

U = University(name="Julia University", people=[P1, P2])
```

```html
julia> print(P1.aml)
<person>
  <age>24</age>
  <study-field>Mechanical Engineering</study-field>
  <GPA>4.5</GPA>
  <taken courses>Artificial Intelligence</taken courses>
  <taken courses>Robotics</taken courses>
</person>


julia> print(P2.aml)
<person>
  <age>18</age>
  <study-field>Computer Engineering</study-field>
  <GPA>4</GPA>
  <taken courses>Julia</taken courses>
</person>

julia> print(U.aml)
<university>
  <university-name>Julia University</university-name>
  <person>
    <age>24</age>
    <study-field>Mechanical Engineering</study-field>
    <GPA>4.5</GPA>
    <taken courses>Artificial Intelligence</taken courses>
    <taken courses>Robotics</taken courses>
  </person>
  <person>
    <age>18</age>
    <study-field>Computer Engineering</study-field>
    <GPA>4</GPA>
    <taken courses>Julia</taken courses>
  </person>
</university>

```
