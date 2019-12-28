module AcuteML

import EzXML.Node

include("utilities.jl")
include("templating.jl")
include("io.jl")

# main macro
export @aml
# types
export Node, Document
# literals
export @xd_str, @hd_str, @sc_str, @a_str
################################################################
"""
  @aml typedef


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

* If you don't specify the type of a variable, it is considered to be string for aml manipulations:
```julia
field, "study-field"
```
However, for a high performance code specify String type (`field::String, "study-field"`)

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

After we defined the structs, we can create instances of them by passing our data to the fields:

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

After we defined the structs, we can automatically extract and store the data in their fields:


```julia
using AcuteML

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
    expr isa Expr && expr.head == :struct || error("Invalid usage of @aml")

    mutability = expr.args[1]
    T = expr.args[2] # Type name +(curly braces)

    # expr.args[3] # arguments
    # argParams.args # empty
    expr.args[3], argParams, argDefVal, argTypes, argVars, argNames, argFun, amlTypes, amlName, docOrElmType, amlFun = amlParse(expr)


    # defining outter constructors
    # Only define a constructor if the type has fields, otherwise we'll get a stack
    # overflow on construction
    if !isempty(argVars)

        ################################################################
        # Arguments methods

        # Non-aml arguments are ignored
        idAmlArgs = (!).(ismissing.(argNames)) # missing argName means not aml

        amlNames = argNames[idAmlArgs]
        amlFuns = argFun[idAmlArgs]
        amlVars = argVars[idAmlArgs]
        amlParams = argParams[idAmlArgs]
        amlDefVal = argDefVal[idAmlArgs]
        amlTypes = amlTypes[idAmlArgs]
        argTypes  = argTypes[idAmlArgs]

        numAml = length(amlVars)

        amlconst=Vector{Expr}(undef,numAml)
        amlext=Vector{Expr}(undef,numAml)
        amlmutability=Vector{Expr}(undef,numAml)

        amlVarsCall = Vector{Expr}(undef,numAml)

        ##########################
        # Each argument of the struct
        for i=1:numAml
            argTypesI = argTypes[i]
            amlVarsI = amlVars[i]
            amlNamesI = amlNames[i]
            amlTypesI = amlTypes[i]
            amlFunsI=amlFuns[i]
            amlSymI=QuoteNode(amlVarsI)
            ##########################
            # call Expr - For mutability
            amlVarsCall[i] = :(str.$amlVarsI)

            # Vector
            if (isa(argTypesI, Expr) && argTypesI.args[1] == :Vector) || (!isa(argTypesI, Union{Symbol, Expr}) && argTypesI <: Array)


                # Function missing
                if ismissing(amlFunsI)

                    amlconst[i]=:(addelementVect!(aml, $amlNamesI, $amlVarsI, $amlTypesI))

                    amlext[i]=:($amlVarsI = findallcontent($(esc(argTypesI)), $amlNamesI, aml, $amlTypesI))

                    if mutability
                        amlmutability[i] = quote
                            if name == $amlSymI
                                updateallcontent!(value, $amlNamesI, str.aml, $amlTypesI)
                            end
                        end
                    end

                # Function provided
                else
                    amlconst[i]=quote
                        if !isnothing($amlVarsI) && ($(esc(amlFunsI)))($amlVarsI)
                            addelementVect!(aml, $amlNamesI, $amlVarsI, $amlTypesI)
                        else
                            error("$($amlNamesI) doesn't meet criteria function")
                        end
                    end


                    amlext[i]=quote

                        $amlVarsI = findallcontent($(esc(argTypesI)), $amlNamesI, aml, $amlTypesI)

                        if !isnothing($amlVarsI) && !(($(esc(amlFunsI)))($amlVarsI))
                            error("$($amlNamesI) doesn't meet criteria function")
                        end
                    end

                    if mutability
                        amlmutability[i] = quote
                            if name == $amlSymI
                                if !isnothing($(amlVarsCall[i])) && ($(esc(amlFunsI)))($(amlVarsCall[i]))
                                    updateallcontent!(value, $amlNamesI, str.aml, $amlTypesI)
                                else
                                    error("$($amlNamesI) doesn't meet criteria function")
                                end
                            end
                        end
                    end

                end

            ##########################
            # Non Vector
            elseif isa(argTypesI, Symbol) || (isa(argTypesI, Expr) && argTypesI.args[1] == :Union ) || (isa(argTypesI, Expr) && argTypesI.args[1] == :UN) || !(argTypesI <: Array)

                # Function missing
                if ismissing(amlFunsI)

                    amlconst[i]=:(addelementOne!(aml, $amlNamesI, $amlVarsI, $amlTypesI))
                    amlext[i]=:($amlVarsI = findfirstcontent($(esc(argTypesI)), $amlNamesI, aml, $amlTypesI))

                    if mutability

                        amlmutability[i] = quote
                            if name == $amlSymI
                                updatefirstcontent!(value, $amlNamesI, str.aml, $amlTypesI)
                            end
                        end
                    end

                # Function provided
                else
                    amlconst[i]=quote
                        if !isnothing($amlVarsI) && ($(esc(amlFunsI)))($amlVarsI)
                            addelementOne!(aml, $amlNamesI, $amlVarsI, $amlTypesI)
                        else
                            error("$($amlNamesI) doesn't meet criteria function")
                        end
                    end

                    amlext[i]=quote

                        $amlVarsI = findfirstcontent($(esc(argTypesI)), $amlNamesI, aml, $amlTypesI)

                        if !isnothing($amlVarsI) && !(($(esc(amlFunsI)))($amlVarsI))
                            error("$($amlNamesI) doesn't meet criteria function")
                        end
                    end
                    if mutability
                        amlmutability[i] = quote
                            if name == $amlSymI
                                if !isnothing($(amlVarsCall[i])) && ($(esc(amlFunsI)))($(amlVarsCall[i]))
                                    updatefirstcontent!(value, $amlNamesI, str.aml, $amlTypesI)
                                else
                                    error("$($amlNamesI) doesn't meet criteria function")
                                end
                            end
                        end
                    end

                end

            end

        end # endfor

        ################################################################
        # aml Function
        if !ismissing(amlFun[1])
            F=amlFun[1]
            amlFunChecker = quote
                if !( ($(esc(F)))($(argVars...)) )
                    error("struct criteria function ($($(esc(F)))) isn't meet")
                end
            end
        else
            amlFunChecker = nothing
        end

        if mutability
            if !ismissing(amlFun[1])
                F=amlFun[1]
                amlFunCheckerMutability = quote
                    if !( ($(esc(F)))($(amlVarsCall...)) )
                        error("struct criteria function ($($(esc(F)))) isn't meet")
                    end
                end
            else
                amlFunCheckerMutability = nothing
            end
        end

        ################################################################
        # Type name is a single name (symbol)
        if T isa Symbol

            docOrElmconst = :( aml = docOrElmInit($docOrElmType, $amlName) )

            typeDefinition =:($expr)

            amlConstructor = quote
                function ($(esc(T)))(; $(argParams...))
                    $amlFunChecker
                    $docOrElmconst
                    $(amlconst...)
                    return ($(esc(T)))($(argVars...), aml)
                end
            end

            amlExtractor = quote
                function ($(esc(T)))(aml::Union{Document, Node})
                    $(amlext...)
                    $amlFunChecker
                    return ($(esc(T)))($(argVars...), aml)
                end

            end

            nothingMethod = :( ($(esc(T)))(::Nothing) = nothing )
            # convertNothingMethod = :(Base.convert(::Type{($(esc(T)))}, ::Nothing) = nothing) # for passing nothing to function without using Union{Nothing, T} in the definition
            selfMethod = :( ($(esc(T)))(in::$(esc(T))) = $(esc(T))(in.aml) )

            if mutability
                mutabilityExp = quote
                     function Base.setproperty!(str::($(esc(T))),name::Symbol, value)
                         setfield!(str,name,value)
                         $amlFunCheckerMutability
                         $(amlmutability...)
                     end
                 end
            else
                mutabilityExp = nothing
            end

            out = quote
                Base.@__doc__($(esc(typeDefinition)))
                $amlConstructor
                $amlExtractor
                $nothingMethod
                # $convertNothingMethod
                $selfMethod
                $mutabilityExp
            end

        ################################################################
        # Parametric type structs
        elseif T isa Expr && T.head == :curly
            # if T == S{A<:AA,B<:BB}, define two methods
            #   S(...) = ...
            #   S{A,B}(...) where {A<:AA,B<:BB} = ...
            S = T.args[1]
            P = T.args[2:end]
            Q = [U isa Expr && U.head == :<: ? U.args[1] : U for U in P]
            SQ = :($S{$(Q...)})

            docOrElmconst = :( aml = docOrElmInit($docOrElmType, $amlName) )

            typeDefinition =:($expr)

            amlConstructor = quote
                function ($(esc(S)))(; $(argParams...))
                    $amlFunChecker
                    $docOrElmconst
                    $(amlconst...)
                    return ($(esc(S)))($(argVars...), aml)
                end
            end

            amlConstructorCurly = quote
                function ($(esc(SQ)))(; $(argParams...)) where {$(esc.(P)...)}
                    $amlFunChecker
                    $docOrElmconst
                    $(amlconst...)
                    return ($(esc(SQ)))($(argVars...), aml)
                end
            end

            amlExtractor = quote
                function ($(esc(S)))(aml::Union{Document, Node})
                    $(amlext...)
                    $amlFunChecker
                    return ($(esc(S)))($(argVars...), aml)
                end

            end

            amlExtractorCurly = quote
                function ($(esc(SQ)))(aml::Union{Document, Node}) where {$(esc.(P)...)}
                    $(amlext...)
                    $amlFunChecker
                    return ($(esc(SQ)))($(argVars...), aml)
                end

            end

            nothingMethod = :( ($(esc(S)))(::Nothing) = nothing )
            # convertNothingMethod = :(Base.convert(::Type{($(esc(S)))}, ::Nothing) = nothing) # for passing nothing to function without using Union{Nothing, ...} in the definition
            selfMethod = :( ($(esc(S)))(in::$(esc(S))) = $(esc(S))(in.aml) )

            if mutability
                mutabilityExp = quote
                     function Base.setproperty!(str::($(esc(T))),name::Symbol, value)
                         setfield!(str,name,value)
                         $amlFunCheckerMutability
                         $(amlmutability...)
                     end
                 end
             else
                 mutabilityExp = nothing
            end

             out = quote
                 Base.@__doc__($(esc(typeDefinition)))
                 $amlConstructor
                 $amlConstructorCurly
                 $amlExtractor
                 $amlExtractorCurly
                 $nothingMethod
                 # $convertNothingMethod
                 $selfMethod
                 $mutabilityExp
             end
        ################################################################
        else
            error("Invalid usage of @aml")
        end
    else
        out = nothing
    end
    return out
end
################################################################
"""
@aml parser function
"""
function amlParse(expr)

    # reminder:
    # var is a symbol
    # var::T or anything more complex is an expression

    argExpr = expr.args[3] # arguments of the type
    T = expr.args[2] # Type name +(curly braces)

    argParams = Union{Expr,Symbol}[] # Expr(:parameters)[]
    argVars = Union{Expr,Symbol}[]
    argDefVal = Any[]
    argTypes = Union{Missing,Type, Symbol, Expr}[]
    argNames = Union{Missing,String}[]
    argFun = Union{Missing, Symbol, Function}[]
    amlTypes = Int64[]
    amlName = "my type"
    docOrElmType = 0
    amlFun = Array{Union{Missing, Symbol, Function},0}(undef)

    for i in eachindex(argExpr.args) # iterating over arguments of each type argument
        ei = argExpr.args[i] # type argument element i

        ########################
        # Line number skipper
        if typeof(ei) == LineNumberNode
            continue
        end

        ########################
        # Single struct name - "aml name"
        if isa(ei, String)

            amlFun[1]=missing # function

            # Self-name checker
            if ei == "~"
                if T isa Symbol
                    amlName = string(T)
                elseif T isa Expr && T.head == :curly
                    amlName = string(T.args[1]) # S
                end
            else
                amlName = ei  # Type aml name
            end

            argExpr.args[i]= nothing # removing "aml name" from expr args
            docOrElmType = 0

        ################################################################
        # Literal Struct name - xd/hd"aml name"
        elseif isa(ei, Tuple)
            ################################################################
            # Struct aml
            ########################
            # Literal only  xd/hd"aml name"
            if isa(ei, Tuple{Int64,String})

                amlFun[1]=missing # function

                # Self-name checker
                if ei[2] == "~"
                    if T isa Symbol
                        amlName = string(T)
                    elseif T isa Expr && T.head == :curly
                        amlName = string(T.args[1]) # S
                    end
                else
                    amlName = ei[2] # Type aml name
                end

                docOrElmType = ei[1]

                argExpr.args[i]= nothing # removing "aml name" from expr args
            end

        elseif ei.head == :tuple
                ########################
                # Struct Function - "aml name", F
            if isa(ei.args[1], String) && isa(ei.args[2], Union{Symbol,Function}) # "aml name", F

                amlFun[1]=ei.args[2] # function

                # Self-name checker
                if ei.args[1] == "~"
                    if T isa Symbol
                        amlName = string(T)
                    elseif T isa Expr && T.head == :curly
                        amlName = string(T.args[1]) # S
                    end
                else
                    amlName = ei.args[1] # Type aml name
                end

                docOrElmType = 0
                argExpr.args[i]= nothing # removing "aml name" from expr args

                ########################
                # Literal and Struct Function - xd/hd"aml name", F
            elseif isa(ei.args[1], Tuple)  && isa(ei.args[2], Union{Symbol,Function})

                amlFun[1]=ei.args[2] # function

                # Self-name checker
                if ei.args[1][2] == "~"
                    if T isa Symbol
                        amlName = string(T)
                    elseif T isa Expr && T.head == :curly
                        amlName = string(T.args[1]) # S
                    end
                else
                    amlName = ei.args[1][2] # Type aml name
                end

                docOrElmType = ei.args[1][1]
                argExpr.args[i]= nothing # removing "aml name" from expr args
        ################################################################
        # Arguments
            ########################
            # No Def Value
            elseif ei.args[1] isa Union{Symbol,Expr} # var/var::T, "name"

                # Def Value
                push!(argDefVal, missing)

                # Type Checker
                lhs = ei.args[1]
                if lhs isa Symbol #  var, "name"

                    var = ei.args[1]

                    push!(argTypes, String) # consider String as the type
                    push!(argParams, var)
                    push!(argVars, var)

                    argExpr.args[i]=var  # removing "name",...

                elseif lhs isa Expr && lhs.head == :(::) && lhs.args[1] isa Symbol # var::T, "name"

                    var = lhs.args[1]
                    varType = lhs.args[2] # Type

                    push!(argTypes, varType)
                    push!(argParams, var)
                    push!(argVars, var)

                    argExpr.args[i]=lhs  # removing "name",...

                end

                # Literal Checker
                if length(ei.args[2]) == 2 # literal

                    elmType = ei.args[2][1]
                    push!(amlTypes, elmType) # literal type

                    ni = ei.args[2][2]

                    # Self-name checker
                    if ni == "~"
                        push!(argNames,string(var))
                    else
                        push!(argNames,ni)
                    end

                else
                    push!(amlTypes, 0) # non-literal

                    ni = ei.args[2]

                    # Self-name checker
                    if ni == "~"
                        push!(argNames,string(var))
                    else
                        push!(argNames,ni)
                    end
                end

                # Function Checker
                if length(ei.args) == 3 && isa(ei.args[3], Union{Function, Symbol}) #  var/var::T, "name", f

                    fun = ei.args[3]   # function
                    push!(argFun, fun)

                else # function name isn't given
                    push!(argFun, missing)
                end



            end  # end Tuple sub possibilities
        ################################################################
        # Def Value
        elseif ei.head == :(=) # def value provided

            # aml name Checker
            if ei.args[2].head == :tuple # var/var::T = defVal, "name"

                # Def Value
                defVal = ei.args[2].args[1]

                push!(argDefVal, defVal)

                lhs = ei.args[1]

                argExpr.args[i]=lhs # remove =defVal for type definition

                # Type Checker
                if lhs isa Symbol #  var = defVal, "name"

                    var = ei.args[1]

                    push!(argTypes, String) # consider String as the type
                    push!(argParams, Expr(:kw, var, defVal))
                    push!(argVars, var)

                    argExpr.args[i]=var  # removing "name",...

                elseif lhs isa Expr && lhs.head == :(::) && lhs.args[1] isa Symbol # var::T = defVal, "name"

                    var = lhs.args[1]
                    varType = lhs.args[2] # Type

                    push!(argTypes, varType)
                    push!(argParams, Expr(:kw, var, defVal)) # TODO also put type expression
                    push!(argVars, var)

                    argExpr.args[i]=lhs  # removing "name",...

                end

                # Literal Checker
                if length(ei.args[2].args[2]) == 2 # literal

                    elmType = ei.args[2].args[2][1]
                    push!(amlTypes, elmType) # literal type

                    ni = ei.args[2].args[2][2]

                    # Self-name checker
                    if ni == "~"
                        push!(argNames,string(var))
                    else
                        push!(argNames,ni)
                    end

                else
                    push!(amlTypes, 0) # non-literal

                    ni = ei.args[2].args[2]

                    # Self-name checker
                    if ni == "~"
                        push!(argNames,string(var))
                    else
                        push!(argNames,ni)
                    end

                end

                # Function Checker
                if length(ei.args[2].args) == 3 && isa(ei.args[2].args[3], Union{Function, Symbol}) #  var/var::T  = defVal, "name", f

                    fun = ei.args[2].args[3]  # function
                    push!(argFun, fun)

                else # function name isn't given
                    push!(argFun, missing)
                end

            ########################
            #  No aml Name - But defVal
            else # var/var::T = defVal # ignored for creating aml

                # Type Checker
                lhs = ei.args[1]
                if lhs isa Symbol #  var = defVal

                    defVal = ei.args[2]

                    push!(argDefVal, defVal)
                    push!(argNames,missing) # ignored for creating aml
                    push!(argFun, missing) # ignored for creating aml

                    var = ei.args[1]

                    push!(argTypes, Any)
                    push!(argParams, Expr(:kw, var, defVal))
                    push!(argVars, var)

                    argExpr.args[i]=var # remove =defVal for type definition

                elseif lhs isa Expr && lhs.head == :(::) && lhs.args[1] isa Symbol # var::T = defVal

                    defVal = ei.args[2]

                    push!(argDefVal, defVal)
                    push!(argNames,missing) # ignored for creating aml
                    push!(argFun, missing) # ignored for creating aml

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

        ################################################################
        # No aml name - No defVal
        else  # var/var::T  # ignored for creating aml

            # Type Checker
            if ei isa Symbol #  var
                push!(argNames, missing) # argument ignored for aml
                push!(argFun, missing) # ignored for creating aml

                push!(argTypes, String)

                var = ei

                push!(argParams, var)
                push!(argVars, var)

            elseif ei.head == :(::) && ei.args[1] isa Symbol # var::T
                push!(argNames, missing) # argument ignored for aml
                push!(argFun, missing) # ignored for creating aml

                var = ei.args[1]
                varType = ei.args[2] # Type

                push!(argTypes, varType)
                push!(argParams, var)
                push!(argVars, var)

            elseif ei.head == :block  # anything else should be evaluated again
                # can arise with use of @static inside type decl
                argExpr, argParams, argDefVal, argTypes, argVars, argNames, argFun, amlTypes, amlName, docOrElmType, amlFun = amlParse(expr)
            else
                continue
            end



        end # end ifs
    end # endfor

    ########################
    # self closing tags checker
    if  docOrElmType == 10
        # add a field with nothing type
        push!(argNames, "content") # argument ignored for aml
        push!(argTypes, Nothing)
        push!(argFun,missing)
        push!(amlTypes,10)
        push!(argParams, Expr(:kw, :content, nothing))
        push!(argVars, :content)
        push!(argDefVal, nothing)
        push!(argExpr.args,:(content::Nothing))
        # argParams, argDefVal, argTypes, argVars, argNames, amlTypes, amlName, docOrElmType = amlParse(argExpr)
    end

    ########################
    # aml::Node adder
    push!(argExpr.args,:(aml::Union{Document,Node}))

    return argExpr, argParams, argDefVal, argTypes, argVars, argNames, argFun, amlTypes, amlName, docOrElmType, amlFun
end

################################################################
# Literal Macros:
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

include("../deps/SnoopCompile/precompile/precompile_AcuteML.jl")
_precompile_()

end
