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

    end



end

# for defined types
function updatefirstcontent!(value::T, s::String,node::Union{Node, Document}, argAmlType::Int64) where {T}

    if argAmlType === 0 # normal elements

        if typeof(node) == Document || hasdocument(node)
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

    elseif argAmlType === 2 # Attributes

        if haskey(node, s)
            elm = node[s]
            unlink!(elm)
            link!(node, value.aml)

        else # error if nothing is found
            return error("field not found in aml")
        end

    end


end

# Nothing Alone
function updatefirstcontent!(value::Nothing, s::String,node::Union{Node, Document}, argAmlType::Int64)

    if argAmlType === 0 # normal elements

        if typeof(node) == Document || hasdocument(node)
            elm = findfirst(s,node)
        else
            elm = findfirstlocal(s,node)
        end

        if isnothing(elm) # error if nothing is found
            return error("field not found in aml")
        else
            unlink!(elm)
        end

    elseif argAmlType === 2 # Attributes

        if haskey(node, s)
            elm = node[s]
            unlink!(elm)

        else # error if nothing is found
            return error("field not found in aml")
        end

    end


end
################################################################
# Vector update
"""
    updateallcontent!(value, string, node, argAmlType)

Finds all the elements with the address of string in the node, and updates the content
"""
function updateallcontent!(value::Vector{T}, s::String, node::Union{Node, Document}, argAmlType::Int64) where{T<:Union{String, Number, Bool}} # for stringsm numbers, and bool


    if argAmlType === 0 # normal elements

        if typeof(node) == Document || hasdocument(node)
            elmsNode = findall(s, node) # a vector of Node elements
        else
            elmsNode = findalllocal(s, node) # a vector of Node elements
        end

        if isnothing(elmsNode) # error if nothing is found
            return error("field not found in aml")
        else
            i = 1
            for elm in elmsNode
                elm = value[i]
                i+=1
            end
        end

    elseif argAmlType === 2 # Attributes

        if haskey(node, s)
            elmsNode = node[s]
            i = 1
            for elm in elmsNode
                elm = value[i]
                i+=1
            end
        else # error if nothing is found
            return error("field not found in aml")
        end
    end
end

# for defined types and nothing
function updateallcontent!(value::Vector{T}, s::String, node::Union{Node, Document}, argAmlType::Int64) where{T}

    if argAmlType === 0 # normal elements

        if typeof(node) == Document || hasdocument(node)
            elmsNode = findall(s, node) # a vector of Node elements
        else
            elmsNode = findalllocal(s, node) # a vector of Node elements
        end

    elseif argAmlType === 2 # Attributes

        if haskey(node, s)
            elmsNode = node[s]
        else # error if nothing is found
            return error("field not found in aml")
        end
    end


    if isnothing(elmsNode) # error if nothing is found
        return error("field not found in aml")
    else
        i = 1
        for elm in elmsNode
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
            i+=1
        end
        return elmsType
    end

end
