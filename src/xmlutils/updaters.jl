export updatecontent!
################################################################
# Updaters
################################################################
# Documents
function updatecontent!(value, name::String, doc::Document, argAmlType::Type{<:AbstractNode})
    updatecontent!(value, name, root(doc), argAmlType)
end
################################################################
# Nodes
# Single Updater

# for String, Number and bool
"""
    updatecontent!(value, element::String, node, argAmlType)

Finds all the elements with the address of string in the node, and updates the content.
"""
@transform function updatecontent!(value::T, name::String, node::Node, argAmlType::Type{allsubtypes(AbsNormal)}) where {T<:Union{AbstractString, Number}}
    # if hasdocument(node)
    #     elm = findfirst(name, node)
    # else
        elm = findfirstlocal(name, node)
    # end

    if isnothing(elm) # error if nothing is found
        return error("field not found in aml")
    else
        elm.content = value
    end
end

function updatecontent!(value::T, name::String, node::Node, argAmlType::Type{AbsAttribute}) where {T<:Union{AbstractString, Number}}
    if haskey(node, name)
        node[name] = value

    else # error if nothing is found
        return error("field not found in aml")
    end
end

function updatecontent!(value::T, indexstr::String, node::Node, argAmlType::Type{AbsText}) where {T<:Union{AbstractString, Number}}
    index = parse_textindex(indexstr)
    elm = findtextlocal(index, node)
    if isnothing(elm) # return nothing if nothing is found
        return error("field not found in aml")
    else
        elm.content = value
    end
end

# Defined types
function updatecontent!(value::T, name::String, node::Node, argAmlType::Type{<:AbsNormal}) where {T}
    # if hasdocument(node)
    #     elm = findfirst(name,node)
    # else
        elm = findfirstlocal(name,node)
    # end

    if isnothing(elm) # error if nothing is found
        return error("field not found in aml")
    else
        if hasmethod(string, Tuple{T})
            elm.content = string(value)
        else
            unlink!(elm)
            link!(node, value.aml)
        end
    end
end

function updatecontent!(value::T, name::String, node::Node, argAmlType::Type{AbsAttribute}) where {T}
    if haskey(node, name)
        elm = node[name]
        unlink!(elm)
        link!(node, value.aml)

    else # error if nothing is found
        return error("field not found in aml")
    end
end

function updatecontent!(value::T, indexstr::String, node::Node, argAmlType::Type{AbsText}) where {T}
    index = parse_textindex(indexstr)
    elm = findtextlocal(index, node)
    if isnothing(elm) # error if nothing is found
        return error("field not found in aml")
    else
        if hasmethod(string, Tuple{T})
            elm.content = string(value)
        else
            unlink!(elm)
            link!(node, value.aml)
        end
    end
end

# Nothing Alone
@transform function updatecontent!(value::Nothing, name::String, node::Node, argAmlType::Type{allsubtypes(AbsNormal)})
    # if hasdocument(node)
    #     elm = findfirst(name,node)
    # else
        elm = findfirstlocal(name,node)
    # end

    if isnothing(elm) # error if nothing is found
        return error("field not found in aml")
    else
        unlink!(elm)
    end
end

function updatecontent!(value::Nothing, name::String,node::Node, argAmlType::Type{AbsAttribute})
    if haskey(node, name)
        elm = node[name]
        unlink!(elm)

    else # error if nothing is found
        return error("field not found in aml")
    end
end

function updatecontent!(value::Nothing, indexstr::String, node::Node, argAmlType::Type{AbsText})
    index = parse_textindex(indexstr)
    elm = findtextlocal(index, node)
    if isnothing(elm) # error if nothing is found
        return error("field not found in aml")
    else
        unlink!(elm)
    end
end
################################################################
# Vector update

@transform function updatecontent!(value::Vector{T}, name::String, node::Node, argAmlType::Type{allsubtypes(AbsNormal)}) where {T<:Union{AbstractString, Number}}
    # if hasdocument(node)
    #     elmsNode = findall(name, node) # a vector of Node elements
    # else
        elmsNode = findalllocal(name, node) # a vector of Node elements
    # end

    if isnothing(elmsNode) # error if nothing is found
        return error("field not found in aml")
    else
        for (i, elm) in enumerate(elmsNode)
            elm.content = value[i]
        end
    end
end

function updatecontent!(value::Vector{T}, name::String, node::Node, argAmlType::Type{AbsAttribute}) where {T<:Union{AbstractString, Number}}
    if haskey(node, name)
        elmsNode = node[name]
        for (i, elm) in enumerate(elmsNode)
            elm.content = value[i]
        end
    else # error if nothing is found
        return error("field not found in aml")
    end
end

function updatecontent!(value::Vector{T}, indicesstr::String, node::Node, argAmlType::Type{AbsText}) where {T<:Union{AbstractString, Number}}
    indices = parse_textindices(indicesstr)
    elmsNode = findvecttextlocal(indices, node)
    if isnothing(elmsNode) # error if nothing is found
        return error("field not found in aml")
    else
        for (i, elm) in enumerate(elmsNode)
            elm.content = value[i]
        end
    end
end

# for defined types and nothing
function updatecontent!(value::Vector{T}, name::String, node::Node, argAmlType::Type{<:AbsNormal}) where{T}

    # if hasdocument(node)
    #     elmsNode = findall(name, node) # a vector of Node elements
    # else
        elmsNode = findalllocal(name, node) # a vector of Node elements
    # end

    if isnothing(elmsNode) # error if nothing is found
        return error("field not found in aml")
    else
        for (i, elm) in enumerate(elmsNode)
            if isnothing(value[i])
                unlink!(elm)
            else
                if hasmethod(string, Tuple{T})
                    elm.content = string(value[i])
                else
                    unlink!(elm)
                    link!(node, value[i].aml)
                end
            end
        end
    end

end


function updatecontent!(value::Vector{T}, name::String, node::Node, argAmlType::Type{AbsAttribute}) where{T}
    if haskey(node, name)
        elmsNode = node[name]
    else # error if nothing is found
        return error("field not found in aml")
    end

    if isnothing(elmsNode) # error if nothing is found
        return error("field not found in aml")
    else
        for (i, elm) in enumerate(elmsNode)
            if isnothing(value[i])
                unlink!(elm)
            else
                if hasmethod(string, Tuple{T})
                    elm.content = string(value[i])
                else
                    unlink!(elm)
                    link!(node, value[i].aml)
                end
            end
        end
    end
end

function updatecontent!(value::Vector{T}, indicesstr::String, node::Node, argAmlType::Type{AbsText}) where{T}
    indices = parse_textindices(indicesstr)
    elmsNode = findvecttextlocal(indices, node)
    if isnothing(elmsNode) # error if nothing is found
        return error("field not found in aml")
    else
        for (i, elm) in enumerate(elmsNode)
            if isnothing(value[i])
                unlink!(elm)
            else
                if hasmethod(string, Tuple{T})
                    elm.content = string(value[i])
                else
                    unlink!(elm)
                    link!(node, value[i].aml)
                end
            end
        end
    end

end
################################################################
# Dict Updating
function updatecontent!(value::Type{AbstractDict}, name, node, argAmlType)
    throw(MethodError("Dicts are not supported for extraction/updating"))
end
