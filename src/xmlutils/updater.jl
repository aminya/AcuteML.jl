export updatecontent!
################################################################
# Updaters
################################################################
# Update based on the elm
################################################################
# Nothing remove
"""
    updatecontent!(value, elm::Node|Nothing, node, argAmlType)
    updatecontent!(value, elms::Vector{Node|Nothing}, node, argAmlType)

In the given `node`, update the content of all the given `elm` or `elms` to `value`.

    updatecontent!(value, name::String, node, argAmlType)

In the given `node`, update the content of all the elements with given `name` to `value`.
"""
function updatecontent!(value::Nothing, elm::Node, node::Node, argAmlType::Type)
    unlink!(elm)
end

# Nothing Nothing
function updatecontent!(value::Nothing, elm::Nothing, node::Node, argAmlType::Type)
    # nothing
end

################################################################
# Number and String
function updatecontent!(value::T, elm::Node, node::Node, argAmlType::Type) where {T<:Union{AbstractString, Number}}
    elm.content = value
end

# Number and String Vector
function updatecontent!(values::Vector{T}, elms::Vector{Node}, node::Node, argAmlType::Type) where {T<:Union{AbstractString, Number}}
    for (i, elm) in enumerate(elms)
        elm.content = values[i]
    end
end

################################################################
# General Type
function updatecontent!(value::T, elm::Node, node::Node, argAmlType::Type)  where {T}
    if hasmethod(string, Tuple{T})
        elm.content = string(value)
    else
        unlink!(elm)
        link!(node, value.aml)
    end
end

# General Type Vector
function updatecontent!(values::Vector{T}, elms::Vector{Node}, node::Node, argAmlType::Type)  where {T}
    for (i, elm) in enumerate(elms)
        if isnothing(values[i])
            unlink!(elm)
        else
            if hasmethod(string, Tuple{T})
                elm.content = string(values[i])
            else
                unlink!(elm)
                link!(node, values[i].aml)
            end
        end
    end
end

################################################################
# Update based on the name
################################################################
# Documents
function updatecontent!(value, name::String, doc::Document, argAmlType::Type{<:AbsNode})
    updatecontent!(value, name, root(doc), argAmlType)
end
################################################################
# Nodes
# Single Updater

function updatecontent!(value, name::String, node::Node, argAmlType::Type{<:Union{AbsNormal, AbsText}})
    elm = findfirst(name, node, argAmlType)
    if !isnothing(elm)
        updatecontent!(value, elm, node, argAmlType)
    else
        # addnode! if nothing is found
        addnode!(node, name, value, argAmlType)
    end
end

# Fast attribute updater
function updatecontent!(value, name::String, node::Node, argAmlType::Type{<:AbsAttribute})
    if haskey(node, name)
        node[name] = value
    else
        # addnode! if nothing is found
        addnode!(node, name, value, argAmlType)
    end
end


################################################################
# Vector update

function updatecontent!(values::Vector, name::String, node::Node, argAmlType::Type{<:Union{AbsNormal, AbsText}})
    elms = findall(name, node, argAmlType)
    if !isnothing(elms)
        updatecontent!(values, elms, node, argAmlType)
    else
        # addnode! if nothing is found
        addnode!(node, name, values, argAmlType)
    end
end

# Fast attribute updater
function updatecontent!(values::Vector, name::String, node::Node, argAmlType::Type{<:AbsAttribute})
    if haskey(node, name)
        node[name] .= values
    else
        # addnode! if nothing is found
        addnode!(node, name, values, argAmlType)
    end
end

################################################################
# Dict Updating
function updatecontent!(value::Type{AbstractDict}, name::Union{Node, String, Nothing}, node::Union{Node, Document}, argAmlType::Type{<:AbsNode})
    throw(MethodError("Dicts are not supported for extraction/updating"))
end
