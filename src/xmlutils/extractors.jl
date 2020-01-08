export findalllocal, findfirstlocal, findfirstcontent, findallcontent
################################################################
# Extractors
################################################################
# Documents
function findfirstcontent(::Type{T},  name::String, doc::Document, argAmlType::Type{AbsNormal}) where {T}
    name = '/'* name
    findfirstcontent(T, name, root(doc), argAmlType)
end

function findfirstcontent( name::String, doc::Document, argAmlType::Type{AbsNormal})
    name = '/'* name
    findfirstcontent(String, name, root(doc), argAmlType)
end

function findallcontent(::Type{T},  name::String, doc::Document, argAmlType::Type{AbsNormal}) where {T}
    name = '/'* name
    findallcontent(T, name, root(doc), argAmlType)
end

function findallcontent( name::String, doc::Document, argAmlType::Type{AbsNormal})
    name = '/'* name
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
function findfirstlocal(s::String, node::Node)
    out = nothing # return nothing if nothing is found
    for child in eachelement(node)
        if child.name == s
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
function findalllocal(s::String, node::Node)
    out = Node[]
    for child in eachelement(node)
        if child.name == s
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
function findfirstcontent(::Type{T},  name::String, node::Node, argAmlType::Type{AbsNormal}) where{T<:String} # for strings

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
function findfirstcontent(::Type{T}, name::String, node::Node, argAmlType::Type{AbsNormal}) where {T<:Union{Number,Bool}}

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
function findfirstcontent(::Type{T}, name::String,node::Node, argAmlType::Type{AbsNormal}) where {T}

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

findfirstcontent(::Type{UN{T}}, name::String, node::Node, argAmlType::Type{AbsNormal}) where {T} = findfirstcontent(T, name, node, argAmlType)

# Nothing Alone
findfirstcontent(::Type{Nothing}, name::String, node::Node, argAmlType::Type{<:AbsDocOrNode}) = nothing

findfirstcontent(::Type{Nothing}, name::String, node::Node, argAmlType::Type{AbsNormal}) = nothing

################################################################
# Vector extraction
"""
    findallcontent(type, string, node, argAmlType)

Finds all the elements with the address of string in the node, and converts the elements to Type object.
```julia
findallcontent(UInt8,"/midi-channel",node, 0)
```
"""
function findallcontent(::Type{Vector{T}}, s::String, node::Node, argAmlType::Int64) where{T<:String} # for strings


    if argAmlType === 0 # normal elements

        if hasdocument(node)
            elmsNode = findall(s, node) # a vector of Node elements
        else
            elmsNode = findalllocal(s, node) # a vector of Node elements
        end

        if isnothing(elmsNode)  # return nothing if nothing is found
            return nothing
        else
            elmsType = Vector{T}(undef, length(elmsNode)) # a vector of Type elements
            i=1
            for elm in elmsNode
                elmsType[i]=elm.content
                i+=1
            end
            return elmsType
        end

    elseif argAmlType === 2 # Attributes

        if haskey(node, s)
            elmsNode = node[s]
            elmsType = Vector{T}(undef, length(elmsNode)) # a vector of Type elements
            i=1
            for elm in elmsNode
                elmsType[i]=elm
                i+=1
            end
            return elmsType
        else  # return nothing if nothing is found
            elmsNode = nothing
        end
    end
end
# if no type is provided consider it to be string
findallcontent(s::String, node::Node, argAmlType::Int64) = findallcontent(Vector{Union{String, Nothing}},s, node, argAmlType)

# for numbers
function findallcontent(::Type{Vector{T}}, s::String, node::Node, argAmlType::Int64) where{T<:Union{Number,Bool}}

    if argAmlType === 0 # normal elements

        if hasdocument(node)
            elmsNode = findall(s, node) # a vector of Node elements
        else
            elmsNode = findalllocal(s, node) # a vector of Node elements
        end

        if isnothing(elmsNode) # return nothing if nothing is found
            return nothing
        else
            elmsType = Vector{T}(undef, length(elmsNode)) # a vector of Type elements
            i=1
            for elm in elmsNode
                elmsType[i]=parse(T, elm.content)
                i+=1
            end
            return elmsType
        end

    elseif argAmlType === 2 # Attributes

        if haskey(node, s)
            elmsNode = parse(T, node[s])
            elmsType = Vector{T}(undef, length(elmsNode)) # a vector of Type elements
            i=1
            for elm in elmsNode
                elmsType[i]=parse(T, elm)
                i+=1
            end
            return elmsType
        else  # return nothing if nothing is found
            elmsNode = nothing
        end

    end



end

# for defined types
function findallcontent(::Type{Vector{T}}, s::String, node::Node, argAmlType::Int64) where{T}

    if argAmlType === 0 # normal elements

        if hasdocument(node)
            elmsNode = findall(s, node) # a vector of Node elements
        else
            elmsNode = findalllocal(s, node) # a vector of Node elements
        end

    elseif argAmlType === 2 # Attributes

        if haskey(node, s)
            elmsNode = node[s]
        else  # return nothing if nothing is found
            elmsNode = nothing
        end
    end


    if isnothing(elmsNode) # return nothing if nothing is found
        return nothing
    else
        if hasmethod(T, Tuple{String}) && Core.Compiler.return_type(T, Tuple{Node}) === Union{}
            elmsType = Vector{T}(undef, length(elmsNode)) # a vector of Type elements
            i=1
            for elm in elmsNode
                elmsType[i]=T(elm.content)
                i+=1
            end
        else
            elmsType = Vector{T}(undef, length(elmsNode)) # a vector of Type elements
            i=1
            for elm in elmsNode
                elmsType[i]=T(elm)
                i+=1
            end
        end
        return elmsType
    end

end

# Union with Nothing
findallcontent(::Type{Vector{UN{T}}},s::String,node::Node, argAmlType::Int64) where {T} = findallcontent(Vector{T},s,node, argAmlType)

# Nothing Alone
findallcontent(::Type{Vector{Nothing}},s::String,node::Node, argAmlType::Int64) = nothing

# vector of Any - consider it to be string
findallcontent(::Type{Vector{Any}},s::String,node::Node, argAmlType::Int64) = findallcontent(Vector{String},s,node, argAmlType)
