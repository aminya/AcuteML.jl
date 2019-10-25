using EzXML
import EzXML.Node

export findfirstcontent, findallcontent, addelementOne!, addelementVect!, print


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
function addelementOne!(aml::Node, name::String, value::String, amlType::Int8)

    if amlType == 0 # normal elements

        if !isnothing(value)
            addelement!(aml, name, value)
        end

    elseif amlType == 2 # Attributes

        link!(aml, AttributeNode(name, value))

    end
end

# number
function addelementOne!(aml::Node, name::String, value::T, amlType::Int8) where {T<:Number}

    if amlType == 0 # normal elements

        addelement!(aml, name, string(value))

    elseif amlType == 2 # Attributes

        link!(aml, AttributeNode(name, string(value)))

    end
end

#  defined or nothing
function addelementOne!(aml::Node, name::String, value, amlType::Int8)
    if !isnothing(value)
        link!(aml,value.aml)
    end
end

# vector of strings
function addelementVect!(aml::Node, name::String, value::Vector{String}, amlType::Int8)


    if amlType == 0 # normal elements

        for ii = 1:length(value)
            addelement!(aml, name, value[ii])
        end

    elseif amlType == 2 # Attributes

        for ii = 1:length(value)
            link!(aml, AttributeNode(name, value[ii]))
        end
    end
end

# vector of numbers
function addelementVect!(aml::Node, name::String, value::Vector{T}, amlType::Int8) where {T<:Number}

    if amlType == 0 # normal elements

        for ii = 1:length(value)
            addelement!(aml, name, string(value[ii]))
        end

    elseif amlType == 2 # Attributes

        for ii = 1:length(value)
            link!(aml, AttributeNode(name, string(value[ii])))
        end
    end
end

#  vector of defined or nothing
function addelementVect!(aml::Node, name::String, value::Vector{T}, amlType::Int8) where {T}
    for ii = 1:length(value)
        link!(aml,value[ii].aml)
    end
end

# doc or element initialize
function docOrElmInit(type::Int64, name::String = nothing)

    if type == 0 # element node

        out = ElementNode(name)

    elseif type == -1 # html

        out = XMLDocument() # version 1

    elseif type == -2 # xml

        out = HTMLDocument() # no URI and external ID
    end

    return out
end
################################################################
function Base.print(x::Node)
    println("")
    prettyprint(x)
end
