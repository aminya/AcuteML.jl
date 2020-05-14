export findcontent
################################################################
# Content Extractor
################################################################
# Documents
################################################################
function findcontent(::Type{T}, name::String, doc::Document, argAmlType::Type{<:AbsNode}) where {T}
    findcontent(T, name, root(doc), argAmlType)
end

# if no type is provided consider it to be Vector{Union{String, Nothing}}
function findcontent(name::String, doc::Document, argAmlType::Type{<:AbsNode})
    findcontent(Vector{Union{String, Nothing}}, name, root(doc), argAmlType)
end
################################################################
# Nodes
################################################################
# Single extraction

"""

    findcontent(type, element::String, node, argAmlType)

Finds all the elements with the address of string in the node and converts to the passed type.

    findcontent(element::String, node, argAmlType)

If no type is provided consider it to be Vector{Union{String, Nothing}}

```julia
findcontent("instrument-name",node, AbsNormal)
findcontent(UInt8,"midi-channel",node, AbsNormal)
```
"""
function findcontent(::Type{T}, name::String, node::Node, argAmlType::Type{<:AbsNode}) where {T}
    elm = findfirst(name, node, argAmlType)
    if isnothing(elm) # return nothing if nothing is found
        return nothing
    else
        return nodeparse(T, elm)
    end
end

# Union with Nothing
@transform function findcontent(::Type{UN{T}}, name::String, node::Node, argAmlType::Type{allsubtypes(AbsDocOrNode)}) where {T}
    return findcontent(T, name, node, argAmlType)
end

# Nothing Alone
@transform function findcontent(::Type{Nothing}, name::String, node::Node, argAmlType::Type{allsubtypes(AbsDocOrNode)})
    return nothing
end

################################################################
# Vector extraction

function findcontent(::Type{Vector{T}},  name::String, node::Node, argAmlType::Type{<:Union{AbsNormal, AbsText}}) where{T}
    elms = findall(name, node, argAmlType)
    if isnothing(elms) # return nothing if nothing is found
        return nothing
    else
        return nodeparse(T, elms)
    end
end

# Fast attribute extractor
function findcontent(::Type{Vector{T}},  name::String, node::Node, argAmlType::Type{<:Union{AbsAttribute}}) where{T}
    if haskey(node, name)
        elms = node[name]
        return nodeparse(T, elms)
    else  # return nothing if nothing is found
        return nothing
    end
end

# Union with Nothing
@transform function findcontent(::Type{Vector{UN{T}}}, name::String,node::Node, argAmlType::Type{allsubtypes(AbsDocOrNode)}) where {T}
    return findcontent(Vector{T},name,node, argAmlType)
end

# Nothing Alone
@transform function findcontent(::Type{Vector{Nothing}}, name::String,node::Node, argAmlType::Type{allsubtypes(AbsDocOrNode)})
    return nothing
end

# vector of Any - consider it to be string
@transform function findcontent(::Type{Vector{Any}}, name::String,node::Node, argAmlType::Type{allsubtypes(AbsDocOrNode)})
    return findcontent(Vector{String},name,node, argAmlType)
end

# if no type is provided consider it to be Vector{Union{String, Nothing}}
@transform function findcontent(name::String, node::Node, argAmlType::Type{allsubtypes(AbsDocOrNode)})
    return findcontent(Vector{Union{String, Nothing}}, name, node, argAmlType)
end

################################################################
# Dict Extraction
function findcontent(::Type{AbstractDict}, name, node, argAmlType)
    throw(MethodError("Dicts are not supported for extraction/updating"))
end
