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
function addelm!(aml::Document, name::String, value::T, argAmlType::Type{<:DocumentOrNode}) where {T}

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
function addelm!(aml::Document, name::String, value::Nothing, argAmlType::Type{<:DocumentOrNode})
# do nothing if value is nothing
end
################################################################
# Vector
"""
    addelm!(node, name, value, argAmlType)

Add a vector to a node/document
```
"""
function addelm!(aml::Document, name::String, value::Vector, argAmlType::Type{<:DocumentOrNode})

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
@transform function addelm!(aml::Node, name::String,value::AbstractString, argAmlType::Type{allsubtypes(AbstractElement)})
    if !isnothing(value) # do nothing if value is nothing
        addelement!(aml, name, value)
    end
end

function addelm!(aml::Node, name::String,value::AbstractString, argAmlType::Type{AbstractAttribute})
    if !isnothing(value) # do nothing if value is nothing
        link!(aml, AttributeNode(name, value))
    end
end

function addelm!(aml::Node, indexstr::String,value::AbstractString, argAmlType::Type{AbsText})
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

# Number  (and also Bool <:Number)
@transform function addelm!(aml::Node, name::String, value::Number, argAmlType::Type{allsubtypes(AbstractElement)})
    if !isnothing(value) # do nothing if value is nothing
        addelement!(aml, name, string(value))
    end
end

function addelm!(aml::Node, name::String, value::Number, argAmlType::Type{AbstractAttribute})
    if !isnothing(value) # do nothing if value is nothing
        link!(aml, AttributeNode(name, string(value)))
    end
end

function addelm!(aml::Node, indexstr::String, value::Number, argAmlType::Type{AbsText})
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

# Other
function addelm!(aml::Node, name::String, value::T, argAmlType::Type{<:AbstractElement}) where {T}
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

function addelm!(aml::Node, name::String, value::T, argAmlType::Type{AbstractAttribute}) where {T}
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

# Nothing
@transform function addelm!(aml::Node, name::String, value::Nothing, argAmlType::Type{allsubtypes(DocumentOrNode)})
    # do nothing
end
################################################################
# Vector

allsubtypes_butAbsText(t) = setdiff(allsubtypes(DocumentOrNode), [AbsText])

@transform function addelm!(aml::Node, name::String, values::Vector, argAmlType::Type{allsubtypes_butAbsText(DocumentOrNode)})
    foreach(x-> addelm!(aml, name, x, argAmlType), values)
end

function addelm!(aml::Node, indicesstr::String, values::Vector, argAmlType::Type{AbsText})
    indices = parse_textindices(indicesstr)
    if indices isa Colon
        indices = 1:length(elements(aml))
    end
    foreach((x, i)-> addelm!(aml, string(i), x, argAmlType), zip(values, indices))
end

################################################################
# Dict

@transform function addelm!(aml::Node, name::String, values::AbstractDict, argAmlType::Type{allsubtypes(DocumentOrNode)})
    # name is discarded now: actual names are stored in the Dict itself
    # elements are added directly
    # for AbsText, v_name is considered as the text index
    for (v_name, v_value) in values
        addelm!(aml, v_name, v_value, argAmlType)
    end
end
