module AML

import EzXML.Node

include("utilities.jl")
include("templating.jl")

# main macro
export @aml
# types
export Node, Document
# literals
export @xd_str, @hd_str, @sc_str, @a_str
################################################################
"""
  @aml typedef

Use @aml macro to define a Julia type, and then the package automatically creates a xml or html associated with the defined type.

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

# Example 1 - constructor
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

# Example 2 - extractor
```julia
using AML

xml = parsexml(\"\"\"
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
\"\"\")

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
"""
macro aml(expr)
    expr = macroexpand(__module__, expr) # to expand @static
    #  check if aml is used before struct
    expr isa Expr && expr.head == :struct || error("Invalid usage of @aml")
    T = expr.args[2] # Type name
    # amlName = exprt.args[3].args[2] # Type aml name

    aml = Symbol(:aml)

    # expr.args[3] # arguments
     # argParams.args # empty
    expr.args[3], argParams, argDefVal, argTypes, argVars, argNames, amlTypes, amlName, docOrElmType = _aml(expr.args[3])


    # defining outter constructors
    # Only define a constructor if the type has fields, otherwise we'll get a stack
    # overflow on construction
    if !isempty(argVars)

        # Type name is a single name (symbol)
        if T isa Symbol

            idAmlArgs = (!).(ismissing.(argNames)) # non aml arguments

            amlNames = argNames[idAmlArgs]
            amlVars = argVars[idAmlArgs]
            amlParams = argParams[idAmlArgs]
            amlDefVal = argDefVal[idAmlArgs]
            amlTypes = amlTypes[idAmlArgs]
            argTypes  = argTypes[idAmlArgs]

            numAml = length(amlVars)

            amlconst=Vector{Expr}(undef,numAml)
            amlext=Vector{Expr}(undef,numAml)

            for i=1:numAml
                argTypesI = argTypes[i]
                amlVarsI = amlVars[i]
                amlNamesI = amlNames[i]
                amlTypesI = amlTypes[i]
                if isa(argTypesI, Expr) || (!isa(argTypesI, Symbol) && argTypesI <: Array) # vector

                        amlconst[i]=:(addelementVect!(aml, $amlNamesI, $amlVarsI, $amlTypesI))

                        amlext[i]=:($amlVarsI = findallcontent($(esc(argTypesI)), $amlNamesI, aml, $amlTypesI))

                elseif isa(argTypesI, Symbol) || !(argTypesI <: Array)   # non vector

                    amlconst[i]=:(addelementOne!(aml, $amlNamesI, $amlVarsI, $amlTypesI))
                    amlext[i]=:($amlVarsI = findfirstcontent($(esc(argTypesI)), $amlNamesI, aml, $amlTypesI))

                end

            end

            docOrElmconst = :( aml = docOrElmInit($docOrElmType, $amlName) )

            typeDefinition =:($expr)

            amlConstructor = quote
                function ($(esc(T)))(; $(argParams...))
                    $docOrElmconst
                    $(amlconst...)
                    return ($(esc(T)))($(argVars...), aml)
                end
            end

            amlExtractor = quote
                 function ($(esc(T)))(aml::Union{Document, Node})
                     $(amlext...)
                     return ($(esc(T)))($(argVars...), aml)
                  end

            end

            nothingMethod = :( ($(esc(T)))(::Nothing) = nothing )
            selfMethod = :( ($(esc(T)))(in::$(esc(T))) = $(esc(T))(in.aml) )

            out = quote
               Base.@__doc__($(esc(typeDefinition)))
               $amlConstructor
               $amlExtractor
               $nothingMethod
               $selfMethod
            end

        else
            error("Invalid usage of @aml")
        end
    else
        out = nothing
    end

    return out
end


# @aml helper function
# var is a symbol
# var::T or anything more complex is an expression
function _aml(argExpr)

    argParams = Union{Expr,Symbol}[] # Expr(:parameters)[]
    argVars = Union{Expr,Symbol}[]
    argDefVal = Any[]
    argTypes = Union{Missing,Type, Symbol, Expr}[]
    argNames = Union{Missing,String}[]
    amlTypes = Int64[]
    amlName = "my type"
    docOrElmType = 0
    lineNumber=1
    for i in eachindex(argExpr.args) # iterating over arguments of each type argument
        ei = argExpr.args[i] # type argument element i

        if typeof(ei) == LineNumberNode
            lineNumber +=2
            continue
        end

        if isa(ei, String)  # struct name "aml name"

            amlName = ei # Type aml name
            argExpr.args[i]= LineNumberNode(lineNumber+1)  # removing "aml name" from expr args
            docOrElmType = 0

        elseif isa(ei, Tuple) # literal# struct name xd/hd"aml name"

            amlName = ei[2]
            docOrElmType = ei[1]

            argExpr.args[i]= LineNumberNode(lineNumber+1)  # removing "aml name" from expr args

        else
            if ei.head == :tuple # var/var::T, "name"

                if length(ei.args[2]) == 2 # literal

                    elmType = ei.args[2][1]
                    push!(amlTypes, elmType) # literal type

                    ni = ei.args[2][2]
                    push!(argNames,ni)

                else
                    push!(amlTypes, 0) # non-literal

                    ni = ei.args[2]
                    push!(argNames,ni)
                end

                push!(argDefVal, missing)

                lhs = ei.args[1]
                if lhs isa Symbol #  var, "name"

                    var = ei.args[1]

                    push!(argTypes, String) # consider String as the type
                    push!(argParams, var)
                    push!(argVars, var)

                    argExpr.args[i]=var  # removing "name"

                elseif lhs isa Expr && lhs.head == :(::) && lhs.args[1] isa Symbol # var::T, "name"

                    var = lhs.args[1]
                    varType = lhs.args[2] # Type

                    push!(argTypes, varType)
                    push!(argParams, var)
                    push!(argVars, var)

                    argExpr.args[i]=lhs  # removing "name"

                end

            elseif ei.head == :(=) # def value provided

                if ei.args[2].head == :tuple # var/var::T = defVal, name

                    defVal = ei.args[2].args[1]

                    if length(ei.args[2].args[2]) == 2 # literal

                        elmType = ei.args[2].args[2][1]
                        push!(amlTypes, elmType) # literal type

                        ni = ei.args[2].args[2][2]
                        push!(argNames,ni)

                    else
                        push!(amlTypes, 0) # non-literal

                        ni = ei.args[2].args[2]
                        push!(argNames,ni)
                    end

                    push!(argDefVal, defVal)

                    lhs = ei.args[1]

                    argExpr.args[i]=lhs # remove =defVal for type definition

                    if lhs isa Symbol #  var = defVal, "name"

                        var = ei.args[1]

                        push!(argTypes, String) # consider String as the type
                        push!(argParams, Expr(:kw, var, defVal))
                        push!(argVars, var)

                        argExpr.args[i]=var  # removing "name"

                    elseif lhs isa Expr && lhs.head == :(::) && lhs.args[1] isa Symbol # var::T = defVal, "name"

                        var = lhs.args[1]
                        varType = lhs.args[2] # Type

                        push!(argTypes, varType)
                        push!(argParams, Expr(:kw, var, defVal)) # TODO also put type expression
                        push!(argVars, var)

                        argExpr.args[i]=lhs  # removing "name"

                    end

                else # var/var::T = defVal # ignored for creating aml

                    lhs = ei.args[1]
                    if lhs isa Symbol #  var = defVal

                        defVal = ei.args[2]

                        push!(argDefVal, defVal)
                        push!(argNames,missing) # ignored for creating aml

                        var = ei.args[1]

                        push!(argTypes, Any)
                        push!(argParams, Expr(:kw, var, defVal))
                        push!(argVars, var)

                        argExpr.args[i]=var # remove =defVal for type definition

                    elseif lhs isa Expr && lhs.head == :(::) && lhs.args[1] isa Symbol # var::T = defVal

                        defVal = ei.args[2]

                        push!(argDefVal, defVal)
                        push!(argNames,missing) # ignored for creating aml

                        var = lhs.args[1]
                        varType = lhs.args[2] # Type

                        push!(argTypes, varType)
                        push!(argParams, Expr(:kw, var, defVal)) # TODO also put type expression
                        push!(argVars, var)

                        argExpr.args[i]=lhs # remove =defVal for type definition

                    else
                        # something else, e.g. inline inner constructor
                        #   F(...) = ...
                        continue
                    end

                end

            else  # var/var::T  # ignored for creating aml
                if ei isa Symbol #  var
                    push!(argNames, missing) # argument ignored for aml

                    push!(argTypes, String)

                    var = ei

                    push!(argParams, var)
                    push!(argVars, var)

                elseif ei.head == :(::) && ei.args[1] isa Symbol # var::T
                    push!(argNames, missing) # argument ignored for aml

                    var = ei.args[1]
                    varType = ei.args[2] # Type

                    push!(argTypes, varType)
                    push!(argParams, var)
                    push!(argVars, var)

                elseif vi.head == :block  # anything else should be evaluated again
                    # can arise with use of @static inside type decl
                    argParams, argDefVal, argTypes, argVars, argNames, amlTypes, amlName, docOrElmType = _aml(argExpr)
                else
                    continue
                end
            end

        end
    end # endfor

    push!(argExpr.args,LineNumberNode(lineNumber+2))
    push!(argExpr.args,:(aml::Union{Document,Node}))

    return argExpr, argParams, argDefVal, argTypes, argVars, argNames, amlTypes, amlName, docOrElmType
end

# html document
macro hd_str(s)
    docOrElmType = -1
    return docOrElmType, s
end


# xml document
macro xd_str(s)
    docOrElmType = -2
    return docOrElmType, s
end

# self-closing
macro sc_str(s)
    docOrElmType= 10
    return docOrElmType, s
end


# attribute
macro a_str(s)
    elmType = 2
    return elmType, s
end

# namespace
macro ns_str(s)
    elmType = 18
    return elmType, s
end

################################################################
import EzXML: parsexml, parsehtml, readxml, readhtml
# from EzXML
funs = [:parsexml, :parsehtml, :readxml, :readhtml]
for fun in funs

    @eval begin

        # doc
        @doc (@doc $(fun)) $(fun)

        # exporting
        export $(fun)
    end
end

end
