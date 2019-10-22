# AML

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://aminya.github.io/AML/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://aminya.github.io/AML/dev)
[![Build Status](https://travis-ci.com/aminya/AML.svg?branch=master)](https://travis-ci.com/aminya/AML)

AML web development framework in Julia

It automatically creates/extracts HTML/XML files from Julia types!

Use @aml macro to define a Julia type, and then the package automatically creates a xml or html associated with the defined type.

# Examples
```julia
using AML

@aml mutable struct Person "person"
    age::UInt, "age"
    field::String, "study-field"
    courses::Vector{String}, "taken courses"
end

P1 = Person(age=24, field="Mechanical Engineering", courses=["Artificial Intelligence", "Robotics"])
P2 = Person(age=18, field="Computer Engineering", courses=["Julia"])

julia>print(P1.aml)
<person>
  <age>24</age>
  <study-field>Mechanical Engineering</study-field>
  <taken courses>Artificial Intelligence</taken courses>
  <taken courses>Robotics</taken courses>
</person>

julia>print(P2.aml)
<person>
  <age>18</age>
  <study-field>Computer Engineering</study-field>
  <taken courses>Julia</taken courses>
</person>

```