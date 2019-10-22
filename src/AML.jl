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
"""
    findallcontent(type, string, node)

Finds all the elements with the address of string in the node, and converts the elements to Type object.
"""
# for strings
function findallcontent(::Type{T}, s::String, node::Node) where{T<:Union{String, Nothing}}

    elmsNode = findall(s, node) # a vector of Node elements
    if isnothing(elmsNode)
        return nothing
    else
        elmsType = Vector{T}(undef, length(elmsNode)) # a vector of Type elements
        i=1
        for elm in elmsNode
            elmsType[i]=elm.content
            i=+1
        end
        return elmsType
    end

end
findallcontent(s::String, node::Node) = findallcontent(Union{String, Nothing},s, node)

# for numbers
function findallcontent(::Type{T}, s::String, node::Node) where{T<:Union{Number,Nothing}}

    elmsNode = findall(s, node) # a vector of Node elements
    if isnothing(elmsNode)
        return nothing
    else
        elmsType = Vector{T}(undef, length(elmsNode)) # a vector of Type elements
        i=1
        for elm in elmsNode
            elmsType[i]=parse(T, elm.content)
            i=+1
        end
        return elmsType
    end

end

# for defined types
function findallcontent(::Type{T}, s::String, node::Node) where{T}

    elmsNode = findall(s, node) # a vector of Node elements
    if isnothing(elmsNode)
        return nothing
    else
        elmsType = Vector{T}(undef, length(elmsNode)) # a vector of Type elements
        i=1
        for elm in elmsNode
            elmsType[i]=T(elm)
            i=+1
        end
        return elmsType
    end

end
################################################################
# Constructors

# strings
function addelementOne!(aml::Node, name::String, value::String)
    if !isnothing(value)
        addelement!(aml, name, value)
    end
end

# number
function addelementOne!(aml::Node, name::String, value::T) where {T<:Number}
    addelement!(aml, name, string(value))
end

#  defined or nothing
function addelementOne!(aml::Node, name::String, value)
    if !isnothing(value)
        link!(aml,value.aml)
    end
end

# vector of strings
function addelementVect!(aml::Node, name::String, value::Vector{String})
    for ii = 1:length(value)
        addelement!(aml, name, value[ii])
    end
end

# vector of numbers
function addelementVect!(aml::Node, name::String, value::Vector{T}) where {T<:Number}
    for ii = 1:length(value)
        addelement!(aml, name, string(value[ii]))
    end
end

#  vector of defined or nothing
function addelementVect!(aml::Node, name::String, value::Vector{T}) where {T}
    for ii = 1:length(value)
        link!(aml,value[ii].aml)
    end
end

Base.print(x::Node) = prettyprint(x)
# @aml helper function
# var is a symbol
# var::T or anything more complex is an expression
function _aml(tArgs, params_args, idxDefexp, defexpVal, argType, call_args, name_args, Tn)
    for i in eachindex(tArgs.args) # iterating over arguments of each type argument
        ei = tArgs.args[i] # type argument element i

        if typeof(ei) == LineNumberNode
            continue
        end

        if isa(ei, String) # struct name "aml name"
            Tn = ei # Type aml name
        else
            if ei.head == :tuple # argument is an aml argument , "some name" or "~"
                vi = ei.args[1]
                ni = ei.args[2]
                push!(name_args,ni)
            else  # argument is ignored for aml
                vi = ei
                ni = missing
                push!(name_args,ni)
            end

            # Determining the argument among (var,var::Type, var = defexpr, var::T = defexpr, etc)
            if vi isa Symbol
                #  var
                var = vi

                push!(argType, String)
                push!(defexpVal, missing)
                push!(idxDefexp, false)
                push!(params_args, var)
                push!(call_args, var)
            elseif vi isa Expr # something more than a symbol = an expression
                if vi.head == :(=) # either default value or a function
                    lhs = vi.args[1]
                    if lhs isa Symbol
                        #  var = defexpr
                        push!(argType, String)
                        var = lhs
                    elseif lhs isa Expr && lhs.head == :(::) && lhs.args[1] isa Symbol
                        #  var::T = defexpr
                        var = lhs.args[1]
                        tvar = lhs.args[2] # Type
                        push!(argType, eval(tvar))
                    else
                        push!(argType, String)
                        # something else, e.g. inline inner constructor
                        #   F(...) = ...
                        continue
                    end
                    defexpr = vi.args[2]  # defexpr
                    push!(defexpVal, defexpr)
                    push!(idxDefexp, true)
                    push!(params_args, Expr(:kw, var, esc(defexpr)))
                    push!(call_args, var)
                    tArgs.args[i] = lhs # storing argument i (var or var::T)
                elseif vi.head == :(::) && vi.args[1] isa Symbol # var with Type annotation
                    # var::Type
                    var = vi.args[1]
                    tvar = vi.args[2]
                    push!(argType, eval(tvar))
                    push!(defexpVal, missing)
                    push!(idxDefexp, false)
                    push!(params_args, var)
                    push!(call_args, var)

                elseif vi.head == :block  # anything else should be evaluated again
                    # can arise with use of @static inside type decl
                    tArgs, params_args, idxDefexp, defexpVal, argType, call_args, name_args, Tn = _aml(tArgs, params_args, idxDefexp, defexpVal, argType, call_args, name_args, Tn)
                end
            end

        end
    end # endfor
    tArgs
    return tArgs, params_args, idxDefexp, defexpVal, argType, call_args, name_args, Tn
end
end
