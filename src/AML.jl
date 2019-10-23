module AML

using EzXML
import EzXML.Node

export @aml, print, show
################################################################
# Extractors
"""
    findfirstcontent(element,node)
    findfirstcontent(type,element,node)


Returns first element content. It also convert to the desired format by passing type. element is given as string.
```julia
findfirstcontent("/instrument-name",node)
findfirstcontent(UInt8,"/midi-channel",node)
```
"""
# for strings
function findfirstcontent(::Type{T}, s::String,node::Node) where{T<:Union{String, Nothing}}
    elm = findfirst(s,node)
    if isnothing(elm)
        return nothing
    else
        return elm.content
    end
end
findfirstcontent(s::String,node::Node) = findfirstcontent(Union{String, Nothing}, s::String, node::Node)

# for numbers
function findfirstcontent(::Type{T},s::String,node::Node) where {T<:Union{Number,Nothing}}
    elm = findfirst(s,node)
    if isnothing(elm)
        return nothing
    else
        return parse(T, elm.content)
    end
end

# for defined types
function findfirstcontent(::Type{T},s::String,node::Node) where {T}
    elm = findfirst(s,node)
    if isnothing(elm)
        return nothing
    else
        return T(elm)
    end
end

################################################################
"""
    findallcontent(type, string, node)

Finds all the elements with the address of string in the node, and converts the elements to Type object.
"""
# for strings
function findallcontent(::Type{T}, s::String, node::Node) where{T<:Union{String, Nothing}}

    elmsNode = findall(s, node) # a vector of Node elements
    if isnothing(elmsNode)
        return nothing
    else
        elmsType = Vector{T}(undef, length(elmsNode)) # a vector of Type elements
        i=1
        for elm in elmsNode
            elmsType[i]=elm.content
            i=+1
        end
        return elmsType
    end

end
findallcontent(s::String, node::Node) = findallcontent(Union{String, Nothing},s, node)

# for numbers
function findallcontent(::Type{T}, s::String, node::Node) where{T<:Union{Number,Nothing}}

    elmsNode = findall(s, node) # a vector of Node elements
    if isnothing(elmsNode)
        return nothing
    else
        elmsType = Vector{T}(undef, length(elmsNode)) # a vector of Type elements
        i=1
        for elm in elmsNode
            elmsType[i]=parse(T, elm.content)
            i=+1
        end
        return elmsType
    end

end

# for defined types
function findallcontent(::Type{T}, s::String, node::Node) where{T}

    elmsNode = findall(s, node) # a vector of Node elements
    if isnothing(elmsNode)
        return nothing
    else
        elmsType = Vector{T}(undef, length(elmsNode)) # a vector of Type elements
        i=1
        for elm in elmsNode
            elmsType[i]=T(elm)
            i=+1
        end
        return elmsType
    end

end
################################################################
# Constructors

# strings
function addelementOne!(aml::Node, name::String, value::String)
    if !isnothing(value)
        addelement!(aml, name, value)
    end
end

# number
function addelementOne!(aml::Node, name::String, value::T) where {T<:Number}
    addelement!(aml, name, string(value))
end

#  defined or nothing
function addelementOne!(aml::Node, name::String, value)
    if !isnothing(value)
        link!(aml,value.aml)
    end
end

# vector of strings
function addelementVect!(aml::Node, name::String, value::Vector{String})
    for ii = 1:length(value)
        addelement!(aml, name, value[ii])
    end
end

# vector of numbers
function addelementVect!(aml::Node, name::String, value::Vector{T}) where {T<:Number}
    for ii = 1:length(value)
        addelement!(aml, name, string(value[ii]))
    end
end

#  vector of defined or nothing
function addelementVect!(aml::Node, name::String, value::Vector{T}) where {T}
    for ii = 1:length(value)
        link!(aml,value[ii].aml)
    end
end
################################################################
function Base.print(x::Node)
    println("")
    prettyprint(x)
end
function Base.show(io::IO,x::Node)
    println("")
    prettyprint(io, x)
end
################################################################
"""
  @aml typedef

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
"""
macro aml(expr)
    expr = macroexpand(__module__, expr) # to expand @static
    #  check if aml is used before struct
    expr isa Expr && expr.head == :struct || error("Invalid usage of @aml")
    T = expr.args[2] # Type name
    # amlName = exprt.args[3].args[2] # Type aml name

    aml = Symbol(:aml)
    argParams = Union{Expr,Symbol}[] # Expr(:parameters)[]
    argVars = Union{Expr,Symbol}[]
    argDefVal = Any[]
    argTypes = Union{Missing,Type, Symbol, Expr}[]
    argNames = Union{Missing,String}[]
    amlName = "name"
    # expr.args[3] # arguments
     # argParams.args # empty
    argParams, argDefVal, argTypes, argVars, argNames, amlName = _aml(expr.args[3], argParams, argDefVal, argTypes, argVars, argNames, amlName)

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
            argTypes  = argTypes[idAmlArgs]

            numAml = length(amlVars)

            amlconst=Vector{Expr}(undef,numAml)
            amlext=Vector{Expr}(undef,numAml)

            for i=1:numAml
                argTypesI = argTypes[i]
                amlVarsI = amlVars[i]
                amlNamesI = amlNames[i]
                if isa(argTypesI, Symbol) || !(argTypesI <: Array)   # non vector

                    amlconst[i]=:(addelementOne!(aml, $amlNamesI, $amlVarsI))
                    amlext[i]=:($amlVarsI = findfirstcontent($argTypesI, $amlNamesI, aml))

                else # vector

                    amlconst[i]=:(addelementVect!(aml, $amlNamesI, $amlVarsI))
                    amlext[i]=:($amlVarsI = findallcontent($argTypesI, $amlNamesI, aml))
                end
            end

            # functions to make the type
            sexpr = replace(string(expr),r"\"(.*)\"" => "") # removing type string name
            sexpr = replace(sexpr,r"\((.*)\,(.*)\)" => s"\1") # removing all the arguments string names
            sexpr = replace(sexpr,r"end" => s"aml::Node \n end")
            typeExpr= Meta.parse(sexpr)

            typeDefinition =:($typeExpr)

            amlConstructor = quote
                function ($(esc(T)))(; $(argParams...))
                    aml = ElementNode($amlName)
                    $(amlconst...)
                    return ($(esc(T)))($(argVars...),aml)
                end
            end

            amlExtractor = quote
                 function ($(esc(T)))(aml::Node)
                     $(amlext...)
                     return ($(esc(T)))($(argVars...),aml)
                  end

            end
            out = quote
               $typeDefinition
               $amlConstructor
               $amlExtractor
            end
        else
            error("Invalid usage of @aml")
        end
    else
        out = nothing
    end
    quote
        # Base.@__doc__($(esc(typeDefinition)))
        $out
    end
end


# @aml helper function
# var is a symbol
# var::T or anything more complex is an expression
function _aml(argExpr, argParams, argDefVal, argTypes, argVars, argNames, amlName)
    for i in eachindex(argExpr.args) # iterating over arguments of each type argument
        ei = argExpr.args[i] # type argument element i

        if typeof(ei) == LineNumberNode
            continue
        end

        if isa(ei, String) # struct name "aml name"
            amlName = ei # Type aml name
        else
            if ei.head == :tuple # var/var::T, "name"

                ni = ei.args[2]

                push!(argDefVal, missing)
                push!(argNames,ni)

                lhs = ei.args[1]
                if lhs isa Symbol #  var, "name"

                    var = ei.args[1]

                    push!(argTypes, String) # consider String as the type
                    push!(argParams, var)
                    push!(argVars, var)

                elseif lhs isa Expr && lhs.head == :(::) && lhs.args[1] isa Symbol # var::T, "name"

                    var = lhs.args[1]
                    varType = lhs.args[2] # Type

                    push!(argTypes, eval(varType))
                    push!(argParams, var)
                    push!(argVars, var)
                end

            elseif ei.head == :(=) # def value provided

                if ei.args[2].head == :tuple # var/var::T = defVal, name

                    defVal = ei.args[2].args[1]
                    ni = ei.args[2].args[2]

                    push!(argDefVal, defVal)
                    push!(argNames,ni)

                    lhs = ei.args[1]
                    if lhs isa Symbol #  var = defVal, "name"

                        var = ei.args[1]

                        push!(argTypes, String) # consider String as the type
                        push!(argParams, Expr(:kw, var, defVal))
                        push!(argVars, var)

                    elseif lhs isa Expr && lhs.head == :(::) && lhs.args[1] isa Symbol # var::T = defVal, "name"

                        var = lhs.args[1]
                        varType = lhs.args[2] # Type

                        push!(argTypes, eval(varType))
                        push!(argParams, Expr(:kw, var, defVal)) # TODO also put type expression
                        push!(argVars, var)
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

                    elseif lhs isa Expr && lhs.head == :(::) && lhs.args[1] isa Symbol # var::T = defVal

                        defVal = ei.args[2]

                        push!(argDefVal, defVal)
                        push!(argNames,missing) # ignored for creating aml

                        var = lhs.args[1]
                        varType = lhs.args[2] # Type

                        push!(argTypes, eval(varType))
                        push!(argParams, Expr(:kw, var, defVal)) # TODO also put type expression
                        push!(argVars, var)
                    else
                        # something else, e.g. inline inner constructor
                        #   F(...) = ...
                        continue
                    end

                end

            else  # var/var::T
                if ei isa Symbol #  var = defVel
                    push!(argNames, missing) # argument ignored for aml

                    push!(argTypes, String)

                    var = ei

                    push!(argParams, var)
                    push!(argVars, var)

                elseif ei.head == :(::) && ei.args[1] isa Symbol # var::T = defVel
                    push!(argNames, missing) # argument ignored for aml

                    var = ei.args[1]
                    varType = ei.args[2] # Type

                    push!(argTypes, eval(varType))
                    push!(argParams, var)
                    push!(argVars, var)

                elseif vi.head == :block  # anything else should be evaluated again
                    # can arise with use of @static inside type decl
                    argParams, argDefVal, argTypes, argVars, argNames, amlName = _aml(argExpr, argParams, argDefVal, argTypes, argVars, argNames, amlName)
                else
                    continue
                end
            end

        end
    end # endfor
    return argParams, argDefVal, argTypes, argVars, argNames, amlName
end




end
