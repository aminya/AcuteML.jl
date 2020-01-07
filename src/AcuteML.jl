module AcuteML

import EzXML.Node

if VERSION < v"1.2.0"
    hasfield(::Type{T}, name::Symbol) where T  = fieldindex(T, name, false) > 0
    isnothing(x) = x === nothing
end

# aml macro
include("xmlutils.jl")
include("amlParse.jl")
# include("deprecated/amlParseDynamic.jl") # kept only for the record
include("amlCreate.jl")

# io
include("io.jl")

# DataTypesSupport
include("amlTypesSupport.jl")

# templating
include("templating.jl")

# main macro
export @aml
# types
export Node, Document
# literals
export @xd_str, @hd_str, @sc_str, @a_str
################################################################
"""
  @aml

# Type Definition
Use `@aml` macro to define a Julia type, and then the package automatically creates a xml or html associated with the defined type.

### Document Definition
* Use `xd""` or `hd""` to define a XML or HTML document:
```julia
@aml mutable struct Doc xd""
# add fields (elements) here
end
```

### Nodes (Elements) Definition
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
You can use Julia types or defined types for values. see and [Supported Value Types](https://aminya.github.io/AcuteML.jl/dev/supportedValueTypes/)  [Custom Value Types](https://aminya.github.io/AcuteML.jl/dev/customValueTypes/) for more information.

* If you don't specify the type of a variable, it is considered to be string for aml manipulations:
```julia
field, "study-field"
```
However, for a high performance code specify String type (`field::String, "study-field"`)

* For already `@aml` defined types, name should be the same as the defined type root name
```julia
university::University, "university"
```

* Table types are supported through PrettyTables.jl.

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

### Empty Elements (Self-Closing) Definition
* Use `sc"name"` to define a self-closing (empty) element (e.g. `<rest />`)
```julia
@aml struct rest sc"~"
end
```
-------------------------------------------------------

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

xml = parsexml(\"\"\"
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
\"\"\")

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
"""
macro aml(expr)
    expr = macroexpand(__module__, expr) # to expand @static

    #  check if aml is used before struct
    if expr isa Expr && expr.head == :struct

        # expr.args[3] # arguments
        # argParams.args # empty
        expr.args[3], argParams, argDefVal, argTypes, argVars, argNames, argFuns, argAmlTypes, amlName, docOrElmType, amlFun, mutability, T = amlParse(expr)

        out = amlCreate(expr, argParams, argDefVal, argTypes, argVars, argNames, argFuns, argAmlTypes, amlName, docOrElmType, amlFun, mutability, T)

    # elseif expr isa Expr && expr.head == :tuple
    #     amlTypesSupport(expr)
    else
        error("Invalid usage of @aml")
    end

    return out
end
################################################################

include("../deps/SnoopCompile/precompile/precompile_AcuteML.jl")
_precompile_()

end
