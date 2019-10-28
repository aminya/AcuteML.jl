using EzXML
import EzXML: Document, Node

export findalllocal, findfirstlocal, findfirstcontent, findallcontent, addelementOne!, addelementVect!, docOrElmInit, print, UN
################################################################
UN{T}= Union{T, Nothing}
################################################################
# Extractors

"""
    findfirstlocal(s, node)

findfirst with ignoring namespaces. It considers element.name for returning the elements
"""
function findfirstlocal(s::String, node::Union{Node, Document})
    out = nothing # return nothing if nothing is found
    for child in eachelement(node)
        if child.name == s
            out = child
            break
        end
    end
    return out
end

"""
    findalllocal(s,node)

findalllocal with ignoring namespaces. It considers element.name for returning the elements
"""
function findalllocal(s::String, node::Union{Node, Document})
    out = Node[]
    for child in eachelement(node)
        if child.name == s
            push!(out, child)
        end
    end
    if !isempty(out)
        return out
    else # return nothing if nothing is found
        return nothing
    end
end
################################################################
# Single extraction
"""
    findfirstcontent(element,node)
    findfirstcontent(type,element,node)


Returns first element content. It also convert to the desired format by passing type. element is given as string.
```julia
findfirstcontent("/instrument-name",node)
findfirstcontent(UInt8,"/midi-channel",node)
```
"""
function findfirstcontent(::Type{T}, s::String, node::Union{Node, Document}, amlType::Int64) where{T<:Union{String, Nothing}} # for strings


    if amlType == 0 # normal elements

        if typeof(node) == Document || hasdocument(node)
            elm = findfirst(s,node)
        else
            elm = findfirstlocal(s,node)
        end

        if isnothing(elm) # return nothing if nothing is found
            return nothing
        else
            return elm.content
        end

    elseif amlType == 2 # Attributes

        elm = node[s]

        if isnothing(elm) # return nothing if nothing is found
            return nothing
        else
            return elm
        end

    end



end


# if no type is provided consider it to be string
findfirstcontent(s::String,node::Union{Node, Document}, amlType::Int64) = findfirstcontent(Union{String, Nothing}, s, node, amlType)

# for numbers
function findfirstcontent(::Type{T},s::String,node::Union{Node, Document}, amlType::Int64) where {T<:Union{Number,Bool,Nothing}}

    if amlType == 0 # normal elements

        if typeof(node) == Document || hasdocument(node)
            elm = findfirst(s,node)
        else
            elm = findfirstlocal(s,node)
        end

        if isnothing(elm) # return nothing if nothing is found
            return nothing
        else
            return parse(T, elm.content)
        end

    elseif amlType == 2 # Attributes

        elm = parse(T, node[s])

        if isnothing(elm) # return nothing if nothing is found
            return nothing
        else
            return elm
        end
    end


end

# for defined types
function findfirstcontent(::Type{T},s::String,node::Union{Node, Document}, amlType::Int64) where {T}

    if amlType == 0 # normal elements

        if typeof(node) == Document || hasdocument(node)
            elm = findfirst(s,node)
        else
            elm = findfirstlocal(s,node)
        end

        if isnothing(elm) # return nothing if nothing is found
            return nothing
        else
            return T(elm)
        end

    elseif amlType == 2 # Attributes

        elm = node[s]

        if isnothing(elm) # return nothing if nothing is found
            return nothing
        else
            return elm
        end

    end


end

# Union with Nothing
findfirstcontent(::Type{UN{T}},s::String,node::Union{Node, Document}, amlType::Int64) where {T} = findfirstcontent(T,s,node, amlType)
################################################################
# Vector extraction
"""
    findallcontent(type, string, node)

Finds all the elements with the address of string in the node, and converts the elements to Type object.
"""
function findallcontent(::Type{Vector{T}}, s::String, node::Union{Node, Document}, amlType::Int64) where{T<:Union{String, Nothing}} # for strings


    if amlType == 0 # normal elements

        if typeof(node) == Document || hasdocument(node)
            elmsNode = findall(s, node) # a vector of Node elements
        else
            elmsNode = findalllocal(s, node) # a vector of Node elements
        end

        if isnothing(elmsNode)  # return nothing if nothing is found
            return nothing
        else
            elmsType = Vector{T}(undef, length(elmsNode)) # a vector of Type elements
            i=1
            for elm in elmsNode
                elmsType[i]=elm.content
                i+=1
            end
            return elmsType
        end

    elseif amlType == 2 # Attributes

        elmsNode = node[s]

        if isnothing(elmsNode)  # return nothing if nothing is found
            return nothing
        else
            elmsType = Vector{T}(undef, length(elmsNode)) # a vector of Type elements
            i=1
            for elm in elmsNode
                elmsType[i]=elm
                i+=1
            end
            return elmsType
        end

    end



end
# if no type is provided consider it to be string
findallcontent(s::String, node::Union{Node, Document}, amlType::Int64) = findallcontent(Vector{Union{String, Nothing}},s, node, amlType)

# for numbers
function findallcontent(::Type{Vector{T}}, s::String, node::Union{Node, Document}, amlType::Int64) where{T<:Union{Number,Bool,Nothing}}

    if amlType == 0 # normal elements

        if typeof(node) == Document || hasdocument(node)
            elmsNode = findall(s, node) # a vector of Node elements
        else
            elmsNode = findalllocal(s, node) # a vector of Node elements
        end

        if isnothing(elmsNode) # return nothing if nothing is found
            return nothing
        else
            elmsType = Vector{T}(undef, length(elmsNode)) # a vector of Type elements
            i=1
            for elm in elmsNode
                elmsType[i]=parse(T, elm.content)
                i+=1
            end
            return elmsType
        end

    elseif amlType == 2 # Attributes

        elmsNode = parse(T, node[s])

        if isnothing(elmsNode) # return nothing if nothing is found
            return nothing
        else
            elmsType = Vector{T}(undef, length(elmsNode)) # a vector of Type elements
            i=1
            for elm in elmsNode
                elmsType[i]=parse(T, elm)
                i+=1
            end
            return elmsType
        end

    end



end

# for defined types
function findallcontent(::Type{Vector{T}}, s::String, node::Union{Node, Document}, amlType::Int64) where{T}

    if amlType == 0 # normal elements

        if typeof(node) == Document || hasdocument(node)
            elmsNode = findall(s, node) # a vector of Node elements
        else
            elmsNode = findalllocal(s, node) # a vector of Node elements
        end

    elseif amlType == 2 # Attributes

        elmsNode = node[s]

    end


    if isnothing(elmsNode) # return nothing if nothing is found
        return nothing
    else
        elmsType = Vector{T}(undef, length(elmsNode)) # a vector of Type elements
        i=1
        for elm in elmsNode
            elmsType[i]=T(elm)
            i+=1
        end
        return elmsType
    end

end

# Union with Nothing
findallcontent(::Type{Vector{UN{T}}},s::String,node::Union{Node, Document}, amlType::Int64) where {T} = findallcontent(Vecotr{T},s,node, amlType)
################################################################
# Constructors

#  defined or nothing for Documents
function addelementOne!(aml::Document, name::String, value, amlType::Int64)

    if !isnothing(value) # do nothing if value is nothing

        if hasroot(aml)
            amlNode = root(aml)
            link!(amlNode,value.aml)
        else
            setroot!(aml, value.aml)
        end
    end

end

# strings
function addelementOne!(aml::Node, name::String, value::String, amlType::Int64)

    if !isnothing(value) # do nothing if value is nothing

        if amlType == 0 # normal elements

            addelement!(aml, name, value)

        elseif amlType == 2 # Attributes

            link!(aml, AttributeNode(name, value))

        end
    end
end

# number
function addelementOne!(aml::Node, name::String, value::T, amlType::Int64) where {T<:Union{Number, Bool}}

    if !isnothing(value) # do nothing if value is nothing

        if amlType == 0 # normal elements

            addelement!(aml, name, string(value))
        elseif amlType == 2 # Attributes

            link!(aml, AttributeNode(name, string(value)))

        end
    end
end

#  defined or nothing
function addelementOne!(aml::Node, name::String, value, amlType::Int64)
    if !isnothing(value)
        link!(aml,value.aml)
    end
end

# vector of strings
function addelementVect!(aml::Node, name::String, value::Vector{String}, amlType::Int64)


    if amlType == 0 # normal elements

        for ii = 1:length(value)
            if !isnothing(value[ii]) # do nothing if value is nothing
                addelement!(aml, name, value[ii])
            end
        end

    elseif amlType == 2 # Attributes

        for ii = 1:length(value)
            if !isnothing(value[ii]) # do nothing if value is nothing
                link!(aml, AttributeNode(name, value[ii]))
            end
        end
    end
end

# vector of numbers
function addelementVect!(aml::Node, name::String, value::Vector{T}, amlType::Int64) where {T<:Union{Number, Bool}}

    if amlType == 0 # normal elements

        for ii = 1:length(value)
            if !isnothing(value[ii]) # do nothing if value is nothing
                addelement!(aml, name, string(value[ii]))
            end
        end

    elseif amlType == 2 # Attributes

        for ii = 1:length(value)
            if !isnothing(value[ii]) # do nothing if value is nothing
                link!(aml, AttributeNode(name, string(value[ii])))
            end
        end
    end
end

#  vector of defined or nothing
function addelementVect!(aml::Node, name::String, value::Vector{T}, amlType::Int64) where {T}
    for ii = 1:length(value)
        if !isnothing(value[ii]) # do nothing if value is nothing
            link!(aml,value[ii].aml)
        end
    end
end

# doc or element initialize
function docOrElmInit(type::Int64, name::String = nothing)

    if type == 0 # element node

        out = ElementNode(name)

    elseif type == 10 # empty element node

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
function Base.print(x::Document)
    println("")
    prettyprint(x)
end
