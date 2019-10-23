```@meta
CurrentModule = AML
```

# AML

AML web development framework in Julia

It automatically creates/extracts HTML/XML files from Julia types!

Use @aml macro to define a Julia type, and then the package automatically creates a xml or html associated with the defined type.

# Examples
```julia

@aml mutable struct Person "person"
    age::UInt, "age"
    field::String, "study-field"
    GPA::Float64, "GPA"
    courses::Vector{String}, "taken courses"
end


P1 = Person(age=24, field="Mechanical Engineering", GPA=4.5, courses=["Artificial Intelligence", "Robotics"])
P2 = Person(age=18, field="Computer Engineering", GPA=4, courses=["Julia"])
```

```html
julia> P1.aml
<person>
  <age>24</age>
  <study-field>Mechanical Engineering</study-field>
  <GPA>4.5</GPA>
  <taken courses>Artificial Intelligence</taken courses>
  <taken courses>Robotics</taken courses>
</person>


julia> P2.aml
<person>
  <age>18</age>
  <study-field>Computer Engineering</study-field>
  <GPA>4</GPA>
  <taken courses>Julia</taken courses>
</person>

```

```@index
```

```@autodocs
Modules = [AML]
```
