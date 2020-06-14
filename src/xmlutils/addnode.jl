export addnode!
################################################################
# Add node
################################################################
# Document
################################################################
# Any
"""
    addnode!(node, name, value, argAmlType)

To add nodes (single or a vector of nodes) as a child of given a node/document.
"""
function addnode!(aml::Document, name::String, value::T, argAmlType::Type{<:AbsDocOrNode}) where {T}

    if hasroot(aml)
        amlNode = root(aml)
        elm = addnode!(amlNode, name, value, argAmlType)
        return elm
    elseif hasfield(T, :aml)
        elm = setroot!(aml, value.aml)
        return elm
    else
        error("You cannot insert $(T) in the document directly. Define a @aml defined field for xml or html document struct")
    end

end

# Nothing
function addnode!(aml::Document, name::String, value::Nothing, argAmlType::Type{<:AbsDocOrNode})
# do nothing if value is nothing
end
################################################################
# Vector
"""
    addnode!(node, name, value, argAmlType)

Add a vector to a node/document
```
"""
function addnode!(aml::Document, name::String, value::Vector, argAmlType::Type{<:AbsDocOrNode})

    if hasroot(aml)
        amlNode = root(aml)
        elm = addnode!(amlNode, name, value, argAmlType)
        return elm
    else
        error("You cannot insert a vector in the document directly. Define a @aml defined field for xml or html document struct")
    end

end

################################################################
# Nodes
################################################################
# String
@transform function addnode!(aml::Node, name::String,value::AbstractString, argAmlType::Type{allsubtypes(AbsNormal)})
    if !isnothing(value) # do nothing if value is nothing
        elm = addelement!(aml, name, value)
        return elm
    end
end

function addnode!(aml::Node, name::String,value::AbstractString, argAmlType::Type{AbsAttribute})
    if !isnothing(value) # do nothing if value is nothing
        elm = link!(aml, AttributeNode(name, value))
        return elm
    end
end

function addnode!(aml::Node, indexstr::String, value::AbstractString, argAmlType::Type{AbsText})
    index = parse_textindex(indexstr)
    aml_elms = elements(aml)
    aml_elms_len = length(aml_elms)
    if length(aml_elms) == 0
        desired_node = aml
        if !isnothing(value) # do nothing if value is nothing
            elm = link!(desired_node, TextNode(value))
            return elm
        end
    elseif index < aml_elms_len
        desired_node = aml_elms[index]
        if !isnothing(value) # do nothing if value is nothing
            elm = linkprev!(desired_node, TextNode(value))
            return elm
        end
    else
        desired_node = aml_elms[end]
        if !isnothing(value) # do nothing if value is nothing
            elm = linknext!(desired_node, TextNode(value))
            return elm
        end
    end
end

# Number (and also Bool <:Number)
@transform function addnode!(aml::Node, name::String, value::Number, argAmlType::Type{allsubtypes(AbsNode)})
    addnode!(aml, name, string(value), argAmlType)
end

# Other
function addnode!(aml::Node, name::String, value::T, argAmlType::Type{<:AbsNormal}) where {T}
    if hasfield(T, :aml)
        elm = link!(aml,value.aml)
    elseif Tables.istable(value)
        elm = link!(aml, amlTable(value))
    elseif hasmethod(aml, Tuple{T})
        elm = link!(aml,aml(value))
    else
        elm = addelement!(aml, name, string(value))
    end
    return elm
end

function addnode!(aml::Node, name::String, value::T, argAmlType::Type{AbsAttribute}) where {T}
    if hasfield(T, :aml)
        elm = link!(aml, AttributeNode(name, value.aml))
    elseif Tables.istable(value)
        elm = link!(aml, AttributeNode(name, amlTable(value)))
    elseif hasmethod(aml, Tuple{T})
        elm = link!(aml, AttributeNode(name, aml(value)))
    else
        elm = link!(aml, AttributeNode(name, string(value)))
    end
    return elm
end

function addnode!(aml::Node, indexstr::String, value::T, argAmlType::Type{AbsText}) where {T}
    index = parse_textindex(indexstr)
    if index < length(elements(aml))

        desired_node = elements(aml)[index]
        if hasfield(T, :aml)
            elm = linkprev!(desired_node, TextNode(value.aml))
            return elm

        elseif Tables.istable(value)
            elm = linkprev!(desired_node, TextNode(amlTable(value)))
            return elm

        elseif hasmethod(aml, Tuple{T})
            elm = linkprev!(desired_node, TextNode(aml(value)))
            return elm

        else
            elm = linkprev!(desired_node, TextNode(string(value)))
            return elm

        end

    else
        desired_node = elements(aml)[end]
        if hasfield(T, :aml)
            elm = linknext!(desired_node, TextNode(value.aml))
            return elm

        elseif Tables.istable(value)
            elm = linknext!(desired_node, TextNode(amlTable(value)))
            return elm

        elseif hasmethod(aml, Tuple{T})
            elm = linknext!(desired_node, TextNode(aml(value)))
            return elm

        else
            elm = linknext!(desired_node, TextNode(string(value)))
            return elm

        end
    end
end

# Nothing
@transform function addnode!(aml::Node, name::String, value::Nothing, argAmlType::Type{allsubtypes(AbsDocOrNode)})
    # do nothing
end
################################################################
# Vector

allsubtypes_butAbsText(t) = setdiff(allsubtypes(AbsDocOrNode), [AbsText])

@transform function addnode!(aml::Node, name::String, values::Vector, argAmlType::Type{allsubtypes_butAbsText(AbsDocOrNode)})
    elms = Vector{Union{Node, Nothing}}(undef, length(values))
    for (ielm, value) in enumerate(values)
        elms[ielm] = addnode!(aml, name, value, argAmlType)
    end
    return elms
end

function addnode!(aml::Node, indicesstr::String, values::Vector, argAmlType::Type{AbsText})
    indices = parse_textindices(indicesstr)
    if indices isa Colon
        indices = 1:length(elements(aml))
    end
    elms = Vector{Union{Node, Nothing}}(undef, length(indices))
    ielm = 1
    for (value, index) in zip(values, indices)
        elms[ielm] = addnode!(aml, string(index), value, argAmlType)
        ielm += 1
    end
    return elms
end

################################################################
# Dict

@transform function addnode!(aml::Node, name::String, values::AbstractDict, argAmlType::Type{allsubtypes(AbsDocOrNode)})
    # name is discarded now: actual names are stored in the Dict itself
    # elements are added directly
    # for AbsText, v_name is considered as the text index
    elms = Vector{Union{Node, Nothing}}(undef, length(values))
    ielm = 1
    for (v_name, v_value) in values
        elms[ielm] = addnode!(aml, v_name, v_value, argAmlType)
        ielm += 1
    end
end
