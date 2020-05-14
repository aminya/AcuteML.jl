################################################################
# Utilities
################################################################
function Base.get(node::Node, name::String, defval)
    if haskey(node, name)
        return node[name]
    else
        return defval
    end
end
################################################################

"""
    findfirstatt(name, node)

Finds the first attribute with `name`

findfirst with ignoring namespaces. It considers att.name for returning the elements

Much faster than EzXML.findfirst
"""
function findfirstatt(name::String, node::Node)
    out = nothing # return nothing if nothing is found
    for att in eachattribute(node)
        if att.name == name
            out = att
            break
        end
    end
    return out
end

"""
    findallatt(string, node)

Finds all the attributes with `name`

findallatt with ignoring namespaces. It considers att.name for returning the elements

Much faster than EzXML.findall
"""
function findallatt(name::String, node::Node)
    out = Node[]
    for att in eachattribute(node)
        if att.name == name
            push!(out, att)
        end
    end
    if !isempty(out)
        return out
    else # return nothing if nothing is found
        return nothing
    end
end


################################################################
# Local searchers (no namespace)
"""
    findfirstelm(string, node)

findfirst with ignoring namespaces. It considers element.name for returning the elements

Much faster than EzXML.findfirst
"""
function findfirstelm(name::String, node::Node)
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
    findallelm(string, node)

findallelm with ignoring namespaces. It considers element.name for returning the elements

Much faster than EzXML.findall
"""
function findallelm(name::String, node::Node)
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
# Text node utils

function findtext(indexstr::String, node::Node)
    if indexstr == ""
        index = 1
    else
        index = eval(Meta.parse(indexstr))
    end
    xpath = "text()[position() = $index]"
    out = findfirst(xpath, node)
    return out
end

# function findvecttext(indexstr::String, node::Node)
#     if indexstr == ""
#         index = Colon()
#     else
#         index = eval(Meta.parse(indexstr))
#     end
#     xpath = "text()"
#     out = findfirst(xpath, node)
#     return out
# end

"""
    parse_textindex(indexstr::String)

Index is a String of an Integer e.g. "2". If indexstr is empty (`""`) it returns the first one found.
"""
function parse_textindex(indexstr::String)
    if indexstr == ""
        index = 1
    elseif indexstr == "end"
        index = Inf
    else
        indexExpr = Meta.parse(indexstr)
        indexExpr isa Integer || error("give index as an Integer e.g. \"2\"")
        index = eval(indexExpr)
    end
    return index
end

"""
    findfirsttext(index::Integer, node)

finds the text node at position given by index.

faster than `findtext()`
"""
function findfirsttext(index::Integer, node::Node)
    iText = 0
    out = nothing # return nothing if nothing is found
    for child in eachnode(node)
        if istext(child)
            iText +=1
            if iText == index
                out = child
                break
            end
        end
    end
    return out
end
function findfirsttext(index::Float64, node::Node)
    if index != Inf
        error("index should be \"end\"")
    end
    out = nothing # return nothing if nothing is found
    for child in eachnode(node)
        if istext(child)
            out = child
        end
    end
    return out
end

"""
    parse_textindices(indicesstr::String)

Index is a String of an Integer e.g. "2". If indicesstr is empty (`""`) it returns the all of the text nodes.
"""
function parse_textindices(indicesstr::String)
    if indicesstr == ""
        indices = Colon()
    else
        indicesExpr = Meta.parse(indicesstr)
        indicesExpr.head == :vect || error("give indices as a vetor e.g. [2:3], [2, 3] ,[:]")
        indices = eval(indexExpr)
    end
    return indices
end

"""
    findalltext(indices, node)

finds the text node at positions given by indices.

faster than `findvecttext()`
"""
function findalltext(indices::Colon, node::Node)
    out = Node[]
    for child in eachnode(node)
        if istext(child)
            push!(out, child)
        end
    end
    if !isempty(out)
        return out
    else # return nothing if nothing is found
        return nothing
    end
end

function findalltext(indices::AbstractVector, node::Node)
    out = Node[]
    iText = 0
    for child in eachnode(node)
        if istext(child)
            iText +=1
            if iText in indices
                push!(out, child)
            end
        end
    end
    if !isempty(out)
        return out
    else # return nothing if nothing is found
        return nothing
    end
end

################################################################
