using Tricks: static_hasmethod
# TODO use traits for static_hasmethod checks

# Scalar parsers

# content input
"""
    noedparse(type::Type, node)
    nodeparse(type::Type, content)
    noedparse(::Type{Vector{T}}, nodes)
    nodeparse(::Type{Vector{T}}, contents)
Parses a node content with the specidied type
"""
nodeparse(type::Type{<:Number}, content::String) = parse(type, content)
nodeparse(type::Type{<:AbstractString}, content::String) = content
function nodeparse(type::Type, content::String)
    # TODO: better specialized method detection
    # https://julialang.slack.com/archives/C6A044SQH/p1578442480438100
    if hasmethod(type, Tuple{String}) &&  Core.Compiler.return_type(type, Tuple{Node})=== Union{}
        return type(content)
    elseif static_hasmethod(convert, Tuple{String, type})
        return convert(type, content)
    elseif static_hasmethod(parse, Tuple{type, String})
        return parse(type, content)
    else
        error("Could not parse a String as type $type")
    end
end

# elm input
nodeparse(type::Type{<:Union{Number, AbstractString}}, elm::Node) = nodeparse(type, elm.content)
function nodeparse(type::Type, elm::Node)
    content = elm.content
    if hasmethod(type, Tuple{String}) &&  Core.Compiler.return_type(type, Tuple{Node})=== Union{}
        return type(content)
    elseif static_hasmethod(convert, Tuple{String, type})
        return convert(type, content)
    elseif static_hasmethod(parse, Tuple{type, String})
        return parse(type, content)
    else
        # should be the last to avoid invoking generic methods
        return type(elm)
    end
end

# Vector parsers
# both elm and content input

# TODO slow for other than String|Number but compact
numorstr(::Nothing) = [Number, AbstractString]
@transform function nodeparse(type::Type{<:numorstr()}, elmsOrContents::Vector{Node})
    return nodeparse.(type, elmsOrContents)
end
@transform function nodeparse(type::Type{<:numorstr()}, elmsOrContents::Vector{String})
    return nodeparse.(type, elmsOrContents)
end
# TODO Faster code, but has redundancy:

function nodeparse(::Type{T}, contents::Vector{String}) where {T}
    elms_typed = Vector{T}(undef, length(contents))
    i = 1
    # TODO https://github.com/oxinabox/Tricks.jl/issues/2#issuecomment-630450764
    if hasmethod(type, Tuple{String}) &&  Core.Compiler.return_type(type, Tuple{Node})=== Union{}
        for content in contents
            elms_typed[i] = type(content)
            i+=1
        end
    elseif static_hasmethod(convert, Tuple{String, type})
        for content in contents
            elms_typed[i] = convert(type, content)
            i+=1
        end
    elseif static_hasmethod(parse, Tuple{type, String})
        for content in contents
            elms_typed[i] = parse(type, content)
            i+=1
        end
    else
        error("Could not parse a String as type $type")
    end
    return elms_typed
end

function nodeparse(type::Type{T}, elms::Vector{Node}) where {T}
    elms_typed = Vector{T}(undef, length(elms))
    i = 1
    # TODO https://github.com/oxinabox/Tricks.jl/issues/2#issuecomment-630450764
    if hasmethod(type, Tuple{String}) &&  Core.Compiler.return_type(type, Tuple{Node})=== Union{}
        for elm in elms
            elms_typed[i] = type(elm.content)
            i+=1
        end
    elseif static_hasmethod(convert, Tuple{String, type})
        for elm in elms
            elms_typed[i] = convert(type, elm.content)
            i+=1
        end
    elseif static_hasmethod(parse, Tuple{type, String})
        for elm in elms
            elms_typed[i] = parse(type, elm.content)
            i+=1
        end
    else
        # should be the last to avoid invoking generic methods
        for elm in elms
            elms_typed[i] = type(elm)
            i+=1
        end
    end
    return elms_typed
end
