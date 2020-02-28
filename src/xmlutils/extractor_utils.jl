export findalllocal, findfirstlocal, findtext, findtextloacl, findvecttextlocal
################################################################
# Searchers Utils
################################################################
# Local searchers (no namespace)
"""
    findfirstlocal(string, node)

findfirst with ignoring namespaces. It considers element.name for returning the elements

Much faster than EzXML.findfirst
"""
function findfirstlocal(name::String, node::Node)
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
    findalllocal(string, node)

findalllocal with ignoring namespaces. It considers element.name for returning the elements

Much faster than EzXML.findall
"""
function findalllocal(name::String, node::Node)
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
    findtextlocal(index::Integer, node)

finds the text node at position given by index.

faster than `findtext()`
"""
function findtextlocal(index::Integer, node::Node)
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
function findtextlocal(index::Float64, node::Node)
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
    findvecttextlocal(indices, node)

finds the text node at positions given by indices.

faster than `findvecttext()`
"""
function findvecttextlocal(indices::Colon, node::Node)
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

function findvecttextlocal(indices::AbstractVector, node::Node)
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
