export findcontent
################################################################
# Extractors
################################################################
# Documents
################################################################
function findcontent(::Type{T}, name::String, doc::Document, argAmlType::Type{<:AbstractNode}) where {T}
    findcontent(T, name, root(doc), argAmlType)
end

# if no type is provided consider it to be Vector{Union{String, Nothing}}
function findcontent(name::String, doc::Document, argAmlType::Type{<:AbstractNode})
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
findcontent("instrument-name",node, AbstractElement)
findcontent(UInt8,"midi-channel",node, AbstractElement)
```
"""
@transform function findcontent(::Type{T},  name::String, node::Node, argAmlType::Type{allsubtypes(AbstractElement)}) where {T<:AbstractString}  # Strings

    # if hasdocument(node)
    #     elm = findfirst(name,node)
    # else
        elm = findfirstlocal(name,node)
    # end

    if isnothing(elm) # return nothing if nothing is found
        return nothing
    else
        return elm.content
    end
end

function findcontent(::Type{T}, name::String, node::Node, argAmlType::Type{AbstractAttribute}) where {T<:AbstractString}
    if haskey(node, name)
        elm = node[name]
        return elm

    else # return nothing if nothing is found
        elm = nothing
        return elm
    end
end

function findcontent(::Type{T}, indexstr::String, node::Node, argAmlType::Type{AbstractText}) where {T<:AbstractString}
    index = parse_textindex(indexstr)
    elm = findtextlocal(index, node)
    if isnothing(elm) # return nothing if nothing is found
        return nothing
    else
        return elm.content
    end
end

# Number  (and also Bool <:Number)
@transform function findcontent(::Type{T}, name::String, node::Node, argAmlType::Type{allsubtypes(AbstractElement)}) where {T<:Number}

    # if hasdocument(node)
    #     elm = findfirst(name,node)
    # else
        elm = findfirstlocal(name,node)
    # end

    if isnothing(elm) # return nothing if nothing is found
        return nothing
    else
        return parse(T, elm.content)
    end

end

function findcontent(::Type{T}, name::String, node::Node, argAmlType::Type{AbstractAttribute}) where {T<:Number}
    if haskey(node, name)
        elm = parse(T, node[name])
        return elm

    else # return nothing if nothing is found
        elm = nothing
        return elm
    end
end

function findcontent(::Type{T}, indexstr::String, node::Node, argAmlType::Type{AbstractText}) where {T<:Number}
    index = parse_textindex(indexstr)
    elm = findtextlocal(index, node)
    if isnothing(elm) # return nothing if nothing is found
        return nothing
    else
        return parse(T, elm.content)
    end
end

# for defined types
function findcontent(::Type{T}, name::String,node::Node, argAmlType::Type{<:AbstractElement}) where {T}

    # if hasdocument(node)
    #     elm = findfirst(name,node)
    # else
        elm = findfirstlocal(name,node)
    # end

    if isnothing(elm) # return nothing if nothing is found
        return nothing
    else
        # TODO: better specialized method detection
        # https://julialang.slack.com/archives/C6A044SQH/p1578442480438100
        if hasmethod(T, Tuple{String}) &&  Core.Compiler.return_type(T, Tuple{Node})=== Union{}
            return T(elm.content)
        else
            return T(elm)
        end
    end

end


function findcontent(::Type{T}, name::String,node::Node, argAmlType::Type{AbstractAttribute}) where {T}

    if haskey(node, name)
        elm = node[name]
        return elm

    else # return nothing if nothing is found
        elm = nothing
        return elm
    end

end

function findcontent(::Type{T}, indexstr::String,node::Node, argAmlType::Type{AbstractText}) where {T}
    index = parse_textindex(indexstr)
    elm = findtextlocal(index, node)
    if isnothing(elm) # return nothing if nothing is found
        return nothing
    else
        # TODO: better specialized method detection
        # https://julialang.slack.com/archives/C6A044SQH/p1578442480438100
        if hasmethod(T, Tuple{String}) &&  Core.Compiler.return_type(T, Tuple{Node})=== Union{}
            return T(elm.content)
        else
            return T(elm)
        end
    end
end

# Union with Nothing
@transform function findcontent(::Type{UN{T}}, name::String, node::Node, argAmlType::Type{allsubtypes(DocumentOrNode)}) where {T}
    return findcontent(T, name, node, argAmlType)
end

# Nothing Alone
@transform function findcontent(::Type{Nothing}, name::String, node::Node, argAmlType::Type{allsubtypes(DocumentOrNode)})
    return nothing
end

################################################################
# Vector extraction

# String
@transform function findcontent(::Type{Vector{T}}, name::String, node::Node, argAmlType::Type{allsubtypes(AbstractElement)}) where {T<:AbstractString}

    # if hasdocument(node)
    #     elmsNode = findall(name, node) # a vector of Node elements
    # else
        elmsNode = findalllocal(name, node) # a vector of Node elements
    # end

    if isnothing(elmsNode)  # return nothing if nothing is found
        return nothing
    else
        elmsType = Vector{T}(undef, length(elmsNode)) # a vector of Type elements
        for (i, elm) in enumerate(elmsNode)
            elmsType[i]=elm.content
        end
        return elmsType
    end
end

function findcontent(::Type{Vector{T}},  name::String, node::Node, argAmlType::Type{AbstractAttribute}) where {T<:AbstractString}
    if haskey(node, name)
        elmsNode = node[name]
        elmsType = Vector{T}(undef, length(elmsNode)) # a vector of Type elements
        for (i, elm) in enumerate(elmsNode)
            elmsType[i]=elm
        end
        return elmsType
    else  # return nothing if nothing is found
        elmsNode = nothing
    end
end

function findcontent(::Type{Vector{T}}, indicesstr::String, node::Node, argAmlType::Type{AbstractText}) where {T<:AbstractString}
    indices = parse_textindices(indicesstr)
    elmsNode = findvecttextlocal(indices, node)
    if isnothing(elmsNode)  # return nothing if nothing is found
        return nothing
    else
        elmsType = Vector{T}(undef, length(elmsNode)) # a vector of Type elements
        for (i, elm) in enumerate(elmsNode)
            elmsType[i]=elm.content
        end
        return elmsType
    end
end

# Number  (and also Bool <:Number)
@transform function findcontent(::Type{Vector{T}},  name::String, node::Node, argAmlType::Type{allsubtypes(AbstractElement)}) where {T<:Number}

    # if hasdocument(node)
    #     elmsNode = findall(name, node) # a vector of Node elements
    # else
        elmsNode = findalllocal(name, node) # a vector of Node elements
    # end

    if isnothing(elmsNode) # return nothing if nothing is found
        return nothing
    else
        elmsType = Vector{T}(undef, length(elmsNode)) # a vector of Type elements
        for (i, elm) in enumerate(elmsNode)
            elmsType[i]=parse(T, elm.content)
        end
        return elmsType
    end
end

function findcontent(::Type{Vector{T}},  name::String, node::Node, argAmlType::Type{AbstractAttribute}) where {T<:Number}
    if haskey(node, name)
        elmsNode = parse(T, node[name])
        elmsType = Vector{T}(undef, length(elmsNode)) # a vector of Type elements
        for (i, elm) in enumerate(elmsNode)
            elmsType[i]=parse(T, elm)
        end
        return elmsType
    else  # return nothing if nothing is found
        elmsNode = nothing
    end
end

function findcontent(::Type{Vector{T}},  indicesstr::String, node::Node, argAmlType::Type{AbstractText}) where {T<:Number}
    indices = parse_textindices(indicesstr)
    elmsNode = findvecttextlocal(indices, node)
    if isnothing(elmsNode) # return nothing if nothing is found
        return nothing
    else
        elmsType = Vector{T}(undef, length(elmsNode)) # a vector of Type elements
        for (i, elm) in enumerate(elmsNode)
            elmsType[i]=parse(T, elm.content)
        end
        return elmsType
    end
end


# for defined types
function findcontent(::Type{Vector{T}},  name::String, node::Node, argAmlType::Type{<:AbstractElement}) where{T}

    # if hasdocument(node)
    #     elmsNode = findall(name, node) # a vector of Node elements
    # else
        elmsNode = findalllocal(name, node) # a vector of Node elements
    # end

    if isnothing(elmsNode) # return nothing if nothing is found
        return nothing
    else
        if hasmethod(T, Tuple{String}) && Core.Compiler.return_type(T, Tuple{Node}) === Union{}
            elmsType = Vector{T}(undef, length(elmsNode)) # a vector of Type elements
            for (i, elm) in enumerate(elmsNode)
                elmsType[i]=T(elm.content)
            end
        else
            elmsType = Vector{T}(undef, length(elmsNode)) # a vector of Type elements
            for (i, elm) in enumerate(elmsNode)
                elmsType[i]=T(elm)
            end
        end
        return elmsType
    end

end
function findcontent(::Type{Vector{T}}, name::String, node::Node, argAmlType::Type{AbstractAttribute}) where{T}

    if haskey(node, name)
        elmsNode = node[name]
    else  # return nothing if nothing is found
        elmsNode = nothing
    end

    if isnothing(elmsNode) # return nothing if nothing is found
        return nothing
    else
        if hasmethod(T, Tuple{String}) && Core.Compiler.return_type(T, Tuple{Node}) === Union{}
            elmsType = Vector{T}(undef, length(elmsNode)) # a vector of Type elements
            for (i, elm) in enumerate(elmsNode)
                elmsType[i]=T(elm.content)
            end
        else
            elmsType = Vector{T}(undef, length(elmsNode)) # a vector of Type elements
            for (i, elm) in enumerate(elmsNode)
                elmsType[i]=T(elm)
            end
        end
        return elmsType
    end

end

function findcontent(::Type{Vector{T}}, indicesstr::String, node::Node, argAmlType::Type{AbstractText}) where{T}
    indices = parse_textindices(indicesstr)
    elmsNode = findvecttextlocal(indices, node)
    if isnothing(elmsNode) # return nothing if nothing is found
        return nothing
    else
        if hasmethod(T, Tuple{String}) && Core.Compiler.return_type(T, Tuple{Node}) === Union{}
            elmsType = Vector{T}(undef, length(elmsNode)) # a vector of Type elements
            for (i, elm) in enumerate(elmsNode)
                elmsType[i]=T(elm.content)
            end
        else
            elmsType = Vector{T}(undef, length(elmsNode)) # a vector of Type elements
            for (i, elm) in enumerate(elmsNode)
                elmsType[i]=T(elm)
            end
        end
        return elmsType
    end
end

# Union with Nothing
@transform function findcontent(::Type{Vector{UN{T}}}, name::String,node::Node, argAmlType::Type{allsubtypes(DocumentOrNode)}) where {T}
    return findcontent(Vector{T},name,node, argAmlType)
end

# Nothing Alone
@transform function findcontent(::Type{Vector{Nothing}}, name::String,node::Node, argAmlType::Type{allsubtypes(DocumentOrNode)})
    return nothing
end

# vector of Any - consider it to be string
@transform function findcontent(::Type{Vector{Any}}, name::String,node::Node, argAmlType::Type{allsubtypes(DocumentOrNode)})
    return findcontent(Vector{String},name,node, argAmlType)
end

# if no type is provided consider it to be Vector{Union{String, Nothing}}
@transform function findcontent(name::String, node::Node, argAmlType::Type{allsubtypes(DocumentOrNode)})
    return findcontent(Vector{Union{String, Nothing}},name, node, argAmlType)
end

################################################################
# Dict Extraction
function findcontent(::Type{AbstractDict}, name, node, argAmlType)
    throw(MethodError("Dicts are not supported for extraction/updating"))
end
