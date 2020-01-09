export findalllocal, findfirstlocal, findfirstcontent, findallcontent
################################################################
# Extractors
################################################################
# Documents
function findfirstcontent(::Type{T}, name::String, doc::Document, argAmlType::Type{<:AbsNormal}) where {T}
    name = "//"* name
    findfirstcontent(T, name, root(doc), argAmlType)
end

function findfirstcontent(name::String, doc::Document, argAmlType::Type{<:AbsNormal})
    name = "//"* name
    findfirstcontent(String, name, root(doc), argAmlType)
end

function findallcontent(::Type{T}, name::String, doc::Document, argAmlType::Type{<:AbsNormal}) where {T}
    name = "//"* name
    findallcontent(T, name, root(doc), argAmlType)
end

function findallcontent(name::String, doc::Document, argAmlType::Type{<:AbsNormal})
    name = "//"* name
    findallcontent(Vector{String}, name, root(doc), argAmlType)
end

# For attributes search in the root
function findfirstcontent(::Type{T}, name::String, doc::Document, argAmlType::Type{AbsAttribute}) where {T}
    findfirstcontent(T, name, root(doc), argAmlType)
end

function findfirstcontent(name::String, doc::Document, argAmlType::Type{AbsAttribute})
    findfirstcontent(String, name, root(doc), argAmlType)
end

function findallcontent(::Type{T},  name::String, doc::Document, argAmlType::Type{AbsAttribute}) where {T}
    findallcontent(T, name, root(doc), argAmlType)
end

function findallcontent(name::String, doc::Document, argAmlType::Type{AbsAttribute})
    findallcontent(Vector{String}, name, root(doc), argAmlType)
end
################################################################
# Nodes
################################################################
# Local searchers (no namespace)
"""
    findfirstlocal(string, node)

findfirst with ignoring namespaces. It considers element.name for returning the elements
"""
function findfirstlocal( name::String, node::Node)
    out = nothing # return nothing if nothing is found
    for child in eachelement(node)
        if child.name == name
            out = child
            break
        end
    end
    return out
end

"""
    findfirstlocal(string, node)

findalllocal with ignoring namespaces. It considers element.name for returning the elements
"""
function findalllocal( name::String, node::Node)
    out = Node[]
    for child in eachelement(node)
        if child.name == name
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
    findfirstcontent(element,node, argAmlType)
    findfirstcontent(type,element,node, argAmlType)

Returns first element content. It also convert to the desired format by passing type. element is given as string.
```julia
findfirstcontent("/instrument-name",node, 0)
findfirstcontent(UInt8,"/midi-channel",node, 0)
```
"""
function findfirstcontent(::Type{T},  name::String, node::Node, argAmlType::Type{<:AbsNormal}) where{T<:String} # for strings

    if hasdocument(node)
        elm = findfirst(name,node)
    else
        elm = findfirstlocal(name,node)
    end

    if isnothing(elm) # return nothing if nothing is found
        return nothing
    else
        return elm.content
    end
end

function findfirstcontent(::Type{T}, name::String, node::Node, argAmlType::Type{AbsAttribute}) where{T<:String} # for strings
    if haskey(node, name)
        elm = node[name]
        return elm

    else # return nothing if nothing is found
        elm = nothing
        return elm
    end
end


# if no type is provided consider it to be string
findfirstcontent( name::String,node::Node, argAmlType::Type{<:AbsDocOrNode}) = findfirstcontent(Union{String, Nothing}, name, node, argAmlType) # Union!!!

# Number,Bool
function findfirstcontent(::Type{T}, name::String, node::Node, argAmlType::Type{<:AbsNormal}) where {T<:Union{Number,Bool}}

    if hasdocument(node)
        elm = findfirst(name,node)
    else
        elm = findfirstlocal(name,node)
    end

    if isnothing(elm) # return nothing if nothing is found
        return nothing
    else
        return parse(T, elm.content)
    end

end

function findfirstcontent(::Type{T}, name::String, node::Node, argAmlType::Type{AbsAttribute}) where {T<:Union{Number,Bool}}
    if haskey(node, name)
        elm = parse(T, node[name])
        return elm

    else # return nothing if nothing is found
        elm = nothing
        return elm
    end
end


# for defined types
function findfirstcontent(::Type{T}, name::String,node::Node, argAmlType::Type{<:AbsNormal}) where {T}

    if hasdocument(node)
        elm = findfirst(name,node)
    else
        elm = findfirstlocal(name,node)
    end

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


function findfirstcontent(::Type{T}, name::String,node::Node, argAmlType::Type{AbsAttribute}) where {T}

    if haskey(node, name)
        elm = node[name]
        return elm

    else # return nothing if nothing is found
        elm = nothing
        return elm
    end

end

# Union with Nothing
findfirstcontent(::Type{UN{T}}, name::String, node::Node, argAmlType::Type{<:AbsDocOrNode}) where {T} = findfirstcontent(T, name, node, argAmlType)

findfirstcontent(::Type{UN{T}}, name::String, node::Node, argAmlType::Type{<:AbsNormal}) where {T} = findfirstcontent(T, name, node, argAmlType)

findfirstcontent(::Type{UN{T}}, name::String, node::Node, argAmlType::Type{AbsAttribute}) where {T} = findfirstcontent(T, name, node, argAmlType)

# Nothing Alone
findfirstcontent(::Type{Nothing}, name::String, node::Node, argAmlType::Type{<:AbsDocOrNode}) = nothing

findfirstcontent(::Type{Nothing}, name::String, node::Node, argAmlType::Type{<:AbsNormal}) = nothing

findfirstcontent(::Type{Nothing}, name::String, node::Node, argAmlType::Type{AbsAttribute}) = nothing

################################################################
# Vector extraction
"""
    findallcontent(type, string, node, argAmlType)

Finds all the elements with the address of string in the node, and converts the elements to Type object.
```julia
findallcontent(UInt8,"midi-channel", node, AbsNormal)
```
"""
function findallcontent(::Type{Vector{T}}, name::String, node::Node, argAmlType::Type{<:AbsNormal}) where{T<:String} # for strings

    if hasdocument(node)
        elmsNode = findall(name, node) # a vector of Node elements
    else
        elmsNode = findalllocal(name, node) # a vector of Node elements
    end

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

function findallcontent(::Type{Vector{T}},  name::String, node::Node, argAmlType::Type{AbsAttribute}) where{T<:String} # for strings
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
# if no type is provided consider it to be string
findallcontent(name::String, node::Node, argAmlType::Type{<:AbsDocOrNode}) = findallcontent(Vector{Union{String, Nothing}},name, node, argAmlType)

# Number,Bool
function findallcontent(::Type{Vector{T}},  name::String, node::Node, argAmlType::Type{<:AbsNormal}) where{T<:Union{Number,Bool}}

    if hasdocument(node)
        elmsNode = findall(name, node) # a vector of Node elements
    else
        elmsNode = findalllocal(name, node) # a vector of Node elements
    end

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

function findallcontent(::Type{Vector{T}},  name::String, node::Node, argAmlType::Type{AbsAttribute}) where{T<:Union{Number,Bool}}
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

# for defined types
function findallcontent(::Type{Vector{T}},  name::String, node::Node, argAmlType::Type{<:AbsNormal}) where{T}

    if hasdocument(node)
        elmsNode = findall(name, node) # a vector of Node elements
    else
        elmsNode = findalllocal(name, node) # a vector of Node elements
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
function findallcontent(::Type{Vector{T}}, name::String, node::Node, argAmlType::Type{AbsAttribute}) where{T}

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
# Union with Nothing
findallcontent(::Type{Vector{UN{T}}}, name::String,node::Node, argAmlType::Type{<:AbsDocOrNode}) where {T} = findallcontent(Vector{T},name,node, argAmlType)

findallcontent(::Type{Vector{UN{T}}}, name::String,node::Node, argAmlType::Type{<:AbsNormal}) where {T} = findallcontent(Vector{T},name,node, argAmlType)


findallcontent(::Type{Vector{UN{T}}}, name::String,node::Node, argAmlType::Type{AbsAttribute}) where {T} = findallcontent(Vector{T},name,node, argAmlType)


# Nothing Alone
findallcontent(::Type{Vector{Nothing}}, name::String,node::Node, argAmlType::Type{<:AbsDocOrNode}) = nothing

findallcontent(::Type{Vector{Nothing}}, name::String,node::Node, argAmlType::Type{<:AbsNormal}) = nothing

findallcontent(::Type{Vector{Nothing}}, name::String,node::Node, argAmlType::Type{AbsAttribute}) = nothing


# vector of Any - consider it to be string
findallcontent(::Type{Vector{Any}}, name::String,node::Node, argAmlType::Type{<:AbsDocOrNode}) = findallcontent(Vector{String},name,node, argAmlType)

findallcontent(::Type{Vector{Any}}, name::String,node::Node, argAmlType::Type{<:AbsNormal}) = findallcontent(Vector{String},name,node, argAmlType)

findallcontent(::Type{Vector{Any}}, name::String,node::Node, argAmlType::Type{<:AbsAttribute}) = findallcontent(Vector{String},name,node, argAmlType)
