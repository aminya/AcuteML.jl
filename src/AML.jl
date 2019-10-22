module AML

using EzXML
import EzXML.Node

export @aml, print
################################################################
# Extractors
"""
    findfirstcontent(element,node)
    findfirstcontent(type,element,node)


Returns first element content. It also convert to the desired format by passing type. element is given as string.
```julia
findfirstcontent("/instrument-name",node)
findfirstcontent(UInt8,"/midi-channel",node)
```
"""
# for strings
function findfirstcontent(::Type{T}, s::String,node::Node) where{T<:Union{String, Nothing}}
    elm = findfirst(s,node)
    if isnothing(elm)
        return nothing
    else
        return elm.content
    end
end
findfirstcontent(s::String,node::Node) = findfirstcontent(Union{String, Nothing}, s::String, node::Node)

# for numbers
function findfirstcontent(::Type{T},s::String,node::Node) where {T<:Union{Number,Nothing}}
    elm = findfirst(s,node)
    if isnothing(elm)
        return nothing
    else
        return parse(T, elm.content)
    end
end

# for defined types
function findfirstcontent(::Type{T},s::String,node::Node) where {T}
    elm = findfirst(s,node)
    if isnothing(elm)
        return nothing
    else
        return T(elm)
    end
end

################################################################
end
