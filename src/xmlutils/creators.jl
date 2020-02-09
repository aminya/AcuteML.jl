export addelm!
################################################################
# Creators
################################################################
# Document
################################################################
# Any
"""
    addelm!(node, name, value, argAmlType)

Add one element to a node/document
"""
function addelm!(aml::Document, name::String, value::T, argAmlType::Type{<:AbsDocOrNode}) where {T}

    if hasroot(aml)
        amlNode = root(aml)
        addelm!(amlNode, name, value, argAmlType)
    elseif hasfield(T, :aml)
        setroot!(aml, value.aml)
    else
        error("You cannot insert $(T) in the document directly. Define a @aml defined field for xml or html document struct")
    end

end

# Nothing
function addelm!(aml::Document, name::String, value::Nothing, argAmlType::Type{<:AbsDocOrNode})
# do nothing if value is nothing
end
################################################################
# Vector
"""
    addelm!(node, name, value, argAmlType)

Add a vector to a node/document
```
"""
function addelm!(aml::Document, name::String, value::Vector, argAmlType::Type{<:AbsDocOrNode})

    if hasroot(aml)
        amlNode = root(aml)
        addelm!(amlNode, name, value, argAmlType)

    else
        error("You cannot insert a vector in the document directly. Define a @aml defined field for xml or html document struct")
    end

end

################################################################
# Nodes
################################################################
# String
@transform function addelm!(aml::Node, name::String, value::String, argAmlType::Type{allsubtypes(AbsNormal)})
    if !isnothing(value) # do nothing if value is nothing
        addelement!(aml, name, value)
    end
end

function addelm!(aml::Node, name::String, value::String, argAmlType::Type{AbsAttribute})
    if !isnothing(value) # do nothing if value is nothing
        link!(aml, AttributeNode(name, value))
    end
end

function addelm!(aml::Node, indexstr::String, value::String, argAmlType::Type{AbsText})
    index = parse_textindex(indexstr)
    if index < length(elements(aml))
        desired_node = elements(aml)[index]
        if !isnothing(value) # do nothing if value is nothing
            linkprev!(desired_node, TextNode(value))
        end
    else
        desired_node = elements(aml)[end]
        if !isnothing(value) # do nothing if value is nothing
            linknext!(desired_node, TextNode(value))
        end
    end
end

# Number, Bool
@transform function addelm!(aml::Node, name::String, value::T, argAmlType::Type{allsubtypes(AbsNormal)}) where {T<:Union{Number, Bool}}
    if !isnothing(value) # do nothing if value is nothing
        addelement!(aml, name, string(value))
    end
end

function addelm!(aml::Node, name::String, value::T, argAmlType::Type{AbsAttribute}) where {T<:Union{Number, Bool}}
    if !isnothing(value) # do nothing if value is nothing
        link!(aml, AttributeNode(name, string(value)))
    end
end

function addelm!(aml::Node, indexstr::String, value::T, argAmlType::Type{AbsText}) where {T<:Union{Number, Bool}}
    index = parse_textindex(indexstr)
    if index < length(elements(aml))
        desired_node = elements(aml)[index]
        if !isnothing(value) # do nothing if value is nothing
            linkprev!(desired_node, TextNode(string(value)))
        end
    else
        desired_node = elements(aml)[end]
        if !isnothing(value) # do nothing if value is nothing
            linknext!(desired_node, TextNode(string(value)))
        end
    end
end

# Defined
function addelm!(aml::Node, name::String, value::T, argAmlType::Type{<:AbsNormal}) where {T}
    if hasfield(T, :aml)
        link!(aml,value.aml)

    elseif Tables.istable(value)
        link!(aml,amlTable(value))

    elseif hasmethod(aml, Tuple{T})
        link!(aml,aml(value))

    else
        addelement!(aml, name, string(value))
    end
end

function addelm!(aml::Node, name::String, value::T, argAmlType::Type{AbsAttribute}) where {T}
    if hasfield(T, :aml)
        link!(aml, AttributeNode(name, value.aml))

    elseif Tables.istable(value)
        link!(aml, AttributeNode(name, amlTable(value)))

    elseif hasmethod(aml, Tuple{T})
        link!(aml, AttributeNode(name, aml(value)))

    else
        link!(aml, AttributeNode(name, string(value)))
    end
end

function addelm!(aml::Node, indexstr::String, value::T, argAmlType::Type{AbsText}) where {T}
    index = parse_textindex(indexstr)
    if index < length(elements(aml))

        desired_node = elements(aml)[index]
        if hasfield(T, :aml)
            linkprev!(desired_node, TextNode(value.aml))

        elseif Tables.istable(value)
            linkprev!(desired_node, TextNode(amlTable(value)))

        elseif hasmethod(aml, Tuple{T})
            linkprev!(desired_node, TextNode(aml(value)))

        else
            linkprev!(desired_node, TextNode(string(value)))
        end

    else
        desired_node = elements(aml)[end]
        if hasfield(T, :aml)
            linknext!(desired_node, TextNode(value.aml))

        elseif Tables.istable(value)
            linknext!(desired_node, TextNode(amlTable(value)))

        elseif hasmethod(aml, Tuple{T})
            linknext!(desired_node, TextNode(aml(value)))

        else
            linknext!(desired_node, TextNode(string(value)))
        end
    end
end


@transform function addelm!(aml::Node, name::String, value::Nothing, argAmlType::Type{allsubtypes(AbsDocOrNode)})
    # do nothing
end
################################################################

# Vector
allsubtypes_butAbsText(t) = setdiff(allsubtypes(AbsDocOrNode), [AbsText])

@transform function addelm!(aml::Node, name::String, value::Vector, argAmlType::Type{allsubtypes_butAbsText(AbsDocOrNode)})
    foreach(x-> addelm!(aml, name, x, argAmlType), value)
end

function addelm!(aml::Node, indicesstr::String, value::Vector, argAmlType::Type{AbsText})
    indices = parse_textindices(indicesstr)
    if indices isa Colon
        indices = 1:length(elements(aml))
    end
    foreach((x, i)-> addelm!(aml, string(i), x, argAmlType), zip(value, indices))
end
