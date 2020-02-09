export updateallcontent!, updatefirstcontent!
################################################################
# Updaters
################################################################
# Documents
function updatefirstcontent(::Type{T}, name::String, doc::Document, argAmlType::Type{<:AbsNormal}) where {T}
    name = '/'* name
    updatefirstcontent(T, name, root(doc), argAmlType)
end

function updatefirstcontent(name::String, doc::Document, argAmlType::Type{<:AbsNormal})
    name = '/'* name
    updatefirstcontent(String, name, root(doc), argAmlType)
end

function updateallcontent(::Type{T}, name::String, doc::Document, argAmlType::Type{<:AbsNormal}) where {T}
    name = '/'* name
    updateallcontent(T, name, root(doc), argAmlType)
end

function updateallcontent(name::String, doc::Document, argAmlType::Type{<:AbsNormal})
    name = '/'* name
    updateallcontent(Vector{String}, name, root(doc), argAmlType)
end

# For attributes search in the root
function updatefirstcontent(::Type{T}, name::String, doc::Document, argAmlType::Type{AbsAttribute}) where {T}
    updatefirstcontent(T, name, root(doc), argAmlType)
end

function updatefirstcontent(name::String, doc::Document, argAmlType::Type{AbsAttribute})
    updatefirstcontent(String, name, root(doc), argAmlType)
end

function updateallcontent(::Type{T},  name::String, doc::Document, argAmlType::Type{AbsAttribute}) where {T}
    updateallcontent(T, name, root(doc), argAmlType)
end

function updateallcontent(name::String, doc::Document, argAmlType::Type{AbsAttribute})
    updateallcontent(Vector{String}, name, root(doc), argAmlType)
end
################################################################
# Nodes
# Single Updater
"""
    updatefirstcontent(value, string, node, argAmlType)

Updates first element content. It also converts any type to string. element is given as string.
"""
@transform function updatefirstcontent!(value::T, s::String, node::Node, argAmlType::Type{allsubtypes(AbsNormal)}) where{T<:Union{String, Number, Bool}} # for strings, number and bool
    if hasdocument(node)
        elm = findfirst(s, node)
    else
        elm = findfirstlocal(s, node)
    end

    if isnothing(elm) # error if nothing is found
        return error("field not found in aml")
    else
        elm.content = value
    end
end

function updatefirstcontent!(value::T, s::String, node::Node, argAmlType::Type{AbsAttribute}) where{T<:Union{String, Number, Bool}} # for strings, number and bool
    if haskey(node, s)
        node[s] = value

    else # error if nothing is found
        return error("field not found in aml")
    end
end

# Defined types
function updatefirstcontent!(value::T, s::String,node::Node, argAmlType::Type{<:AbsNormal}) where {T}
    if hasdocument(node)
        elm = findfirst(s,node)
    else
        elm = findfirstlocal(s,node)
    end

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

function updatefirstcontent!(value::T, s::String,node::Node, argAmlType::Type{AbsAttribute}) where {T}
    if haskey(node, s)
        elm = node[s]
        unlink!(elm)
        link!(node, value.aml)

    else # error if nothing is found
        return error("field not found in aml")
    end
end

# Nothing Alone
@transform function updatefirstcontent!(value::Nothing, s::String,node::Node, argAmlType::Type{allsubtypes(AbsNormal)})
    if hasdocument(node)
        elm = findfirst(s,node)
    else
        elm = findfirstlocal(s,node)
    end

    if isnothing(elm) # error if nothing is found
        return error("field not found in aml")
    else
        unlink!(elm)
    end
end

function updatefirstcontent!(value::Nothing, s::String,node::Node, argAmlType::Type{AbsAttribute})
    if haskey(node, s)
        elm = node[s]
        unlink!(elm)

    else # error if nothing is found
        return error("field not found in aml")
    end
end
################################################################
# Vector update
"""
    updateallcontent!(value, string, node, argAmlType)

Finds all the elements with the address of string in the node, and updates the content
"""
@transform function updateallcontent!(value::Vector{T}, s::String, node::Node, argAmlType::Type{allsubtypes(AbsNormal)}) where{T<:Union{String, Number, Bool}} # for stringsm numbers, and bool
    if hasdocument(node)
        elmsNode = findall(s, node) # a vector of Node elements
    else
        elmsNode = findalllocal(s, node) # a vector of Node elements
    end

    if isnothing(elmsNode) # error if nothing is found
        return error("field not found in aml")
    else
        for (i, elm) in enumerate(elmsNode)
            elm = value[i]
        end
    end
end

function updateallcontent!(value::Vector{T}, s::String, node::Node, argAmlType::Type{AbsAttribute}) where{T<:Union{String, Number, Bool}} # for stringsm numbers, and bool
    if haskey(node, s)
        elmsNode = node[s]
        for (i, elm) in enumerate(elmsNode)
            elm = value[i]
        end
    else # error if nothing is found
        return error("field not found in aml")
    end
end

# for defined types and nothing
function updateallcontent!(value::Vector{T}, s::String, node::Node, argAmlType::Type{<:AbsNormal}) where{T}

    if typeof(node) == Document || hasdocument(node)
        elmsNode = findall(s, node) # a vector of Node elements
    else
        elmsNode = findalllocal(s, node) # a vector of Node elements
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
        return elmsType
    end

end


function updateallcontent!(value::Vector{T}, s::String, node::Node, argAmlType::Type{AbsAttribute}) where{T}
    if haskey(node, s)
        elmsNode = node[s]
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
        return elmsType
    end

end
