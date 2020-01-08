export addelementOne!, addelementVect!
################################################################
# Creators
################################################################
# Document
################################################################
# Any
"""
    addelementOne!(node, name, value, argAmlType)

Add one element to a node/document
```
"""
function addelementOne!(aml::Document, name::String, value::T, argAmlType::Type) where {T}

    if hasroot(aml)
        amlNode = root(aml)
        addelementOne!(amlNode, name, value, argAmlType)
    elseif hasfield(T, :aml)
        setroot!(aml, value.aml)
    else
        error("You cannot insert $(T) in the document directly. Define a @aml defined field for xd/hd struct")
    end

end

# Nothing
function addelementOne!(aml::Document, name::String, value::Nothing, argAmlType::Type)
# do nothing if value is nothing
end
################################################################
# vector of Any
"""
    addelementVect!(node, name, value, argAmlType)

Add a vector to a node/document
```
"""
function addelementVect!(aml::Document, name::String, value::Vector{T}, argAmlType::Type) where {T}

    if hasroot(aml)
        amlNode = root(aml)
        addelementVect!(amlNode, name, value, argAmlType)

    else
        error("You cannot insert a vector in the document directly. Define a @aml defined field for xd/hd struct")
    end

end

################################################################
# Nodes
################################################################
# String
function addelementOne!(aml::Node, name::String, value::String, argAmlType::AbsNormal)
    if !isnothing(value) # do nothing if value is nothing
        addelement!(aml, name, value)
    end
end

function addelementOne!(aml::Node, name::String, value::String, argAmlType::AbsAttribute)
    if !isnothing(value) # do nothing if value is nothing
        link!(aml, AttributeNode(name, value))
    end
end

# Number, Bool
function addelementOne!(aml::Node, name::String, value::T, argAmlType::AbsNormal) where {T<:Union{Number, Bool}}
    if !isnothing(value) # do nothing if value is nothing
        addelement!(aml, name, string(value))
    end
end

function addelementOne!(aml::Node, name::String, value::T, argAmlType::AbsAttribute) where {T<:Union{Number, Bool}}
    if !isnothing(value) # do nothing if value is nothing
        link!(aml, AttributeNode(name, string(value)))
    end
end

# Defined
function addelementOne!(aml::Node, name::String, value::T, argAmlType::AbsNormal) where {T}
    if hasfield(T, :aml)
        link!(aml,value.aml)

    elseif Tables.istable(value)
        link!(aml,amlTable(value))

    elseif hasmethod(aml, Tuple{T})
        link!(aml,aml(value))

    else
        addelement!(aml, name, string(value))
    end
end

function addelementOne!(aml::Node, name::String, value::T, argAmlType::AbsAttribute) where {T}
    if hasfield(T, :aml)
        link!(aml, AttributeNode(name, value.aml))

    elseif Tables.istable(value)
        link!(aml, AttributeNode(name, amlTable(value)))

    elseif hasmethod(aml, Tuple{T})
        link!(aml, AttributeNode(name, aml(value)))

    else
        link!(aml, AttributeNode(name, string(value)))
    end
end

function addelementOne!(aml::Node, name::String, value::Nothing, argAmlType::Type)
    # do nothing
end
################################################################
# vector of strings
function addelementVect!(aml::Node, name::String, value::Vector{String}, argAmlType::Int64)


    if argAmlType === 0 # normal elements

        for i = 1:length(value)
            if !isnothing(value[i]) # do nothing if value is nothing
                addelement!(aml, name, value[i])
            end
        end

    elseif argAmlType === 2 # Attributes

        for i = 1:length(value)
            if !isnothing(value[i]) # do nothing if value is nothing
                link!(aml, AttributeNode(name, value[i]))
            end
        end
    end
end

# vector of numbers
function addelementVect!(aml::Node, name::String, value::Vector{T}, argAmlType::Int64) where {T<:Union{Number, Bool}}

    if argAmlType === 0 # normal elements

        for i = 1:length(value)
            if !isnothing(value[i]) # do nothing if value is nothing
                addelement!(aml, name, string(value[i]))
            end
        end

    elseif argAmlType === 2 # Attributes

        for i = 1:length(value)
            if !isnothing(value[i]) # do nothing if value is nothing
                link!(aml, AttributeNode(name, string(value[i])))
            end
        end
    end
end

# Vector of defined or nothing
function addelementVect!(aml::Node, name::String, value::Vector{T}, argAmlType::Int64) where {T}
    for i = 1:length(value)
        vi = value[i]
        Ti = typeof(vi)

        if Ti !== Nothing # do nothing if value is nothing

            if hasfield(Ti, :aml)
                link!(aml,vi.aml)

            elseif Tables.istable(vi)
                link!(aml, amlTable(vi))

            elseif hasmethod(aml, Tuple{Ti})
                link!(aml, aml(vi))

            else
                if argAmlType === 0 # normal elements

                    addelement!(aml, name, string(vi))
                elseif argAmlType === 2 # Attributes

                    link!(aml, AttributeNode(name, string(vi)))

                end
            end

        end
    end
end
