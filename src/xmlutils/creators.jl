export addelementOne!, addelementVect!
################################################################
# Creators
################################################################

# Document
#  defined or nothing for Documents # add strings and others for documents
"""
    addelementOne!(node, name, value, amlType)

Add one element to a node/document
```
"""
function addelementOne!(aml::Document, name::String, value, amlType::Int64)

    if !isnothing(value) # do nothing if value is nothing

        if hasroot(aml)
            amlNode = root(aml)
            if hasmethod(string, Tuple{T})
                if amlType == 0 # normal elements

                    addelement!(aml, name, string(value))
                elseif amlType == 2 # Attributes

                    link!(aml, AttributeNode(name, string(value)))

                end
            else
                link!(amlNode,value.aml)
            end
        else
            setroot!(aml, value.aml)
        end

    end

end

# strings
function addelementOne!(aml::Document, name::String, value::String, amlType::Int64)

    if !isnothing(value) # do nothing if value is nothing

        if hasroot(aml)
            amlNode = root(aml)

            if amlType == 0 # normal elements

                addelement!(amlNode, name, value)

            elseif amlType == 2 # Attributes

                link!(amlNode, AttributeNode(name, value))

            end
        else
            error("You cannot insert a string in the document directly. Define a @aml defined field for xd/hd struct")
        end

    end
end

# number
function addelementOne!(aml::Document, name::String, value::T, amlType::Int64) where {T<:Union{Number, Bool}}

    if !isnothing(value) # do nothing if value is nothing

        if hasroot(aml)
            amlNode = root(aml)

            if amlType == 0 # normal elements

                addelement!(amlNode, name, string(value))
            elseif amlType == 2 # Attributes

                link!(amlNode, AttributeNode(name, string(value)))

            end
        else
            error("You cannot insert a number in the document directly. Define a @aml defined field for xd/hd struct")
        end

    end
end
################################################################
# vector of strings
"""
    addelementVect!(node, name, value, amlType)

Add a vector to a node/document
```
"""
function addelementVect!(aml::Document, name::String, value::Vector{String}, amlType::Int64)


    if hasroot(aml)
        amlNode = root(aml)

        if amlType == 0 # normal elements

            for ii = 1:length(value)
                if !isnothing(value[ii]) # do nothing if value is nothing
                    addelement!(amlNode, name, value[ii])
                end
            end

        elseif amlType == 2 # Attributes

            for ii = 1:length(value)
                if !isnothing(value[ii]) # do nothing if value is nothing
                    link!(amlNode, AttributeNode(name, value[ii]))
                end
            end
        end

    else
        error("You cannot insert a vector in the document directly. Define a @aml defined field for xd/hd struct")
    end

end

# vector of numbers
function addelementVect!(aml::Document, name::String, value::Vector{T}, amlType::Int64) where {T<:Union{Number, Bool}}

    if hasroot(aml)
        amlNode = root(aml)

        if amlType == 0 # normal elements

            for ii = 1:length(value)
                if !isnothing(value[ii]) # do nothing if value is nothing
                    addelement!(amlNode, name, string(value[ii]))
                end
            end

        elseif amlType == 2 # Attributes

            for ii = 1:length(value)
                if !isnothing(value[ii]) # do nothing if value is nothing
                    link!(amlNode, AttributeNode(name, string(value[ii])))
                end
            end
        end

    else
        error("You cannot put string in the document directly.Define a @aml defined field for xd/hd struct")
    end

end

#  vector of defined or nothing
function addelementVect!(aml::Document, name::String, value::Vector{T}, amlType::Int64) where {T}
    if hasroot(aml)
        amlNode = root(aml)

        for ii = 1:length(value)
            if !isnothing(value[ii]) # do nothing if value is nothing
                if hasmethod(string, Tuple{T})
                    if amlType == 0 # normal elements

                        addelement!(amlNode, name, string(value[ii]))
                    elseif amlType == 2 # Attributes

                        link!(amlNode, AttributeNode(name, string(value[ii])))

                    end
                else
                    link!(amlNode,value[ii].aml)
                end
            end
        end

    else
        error("You cannot put string in the document directly. Define a @aml defined field for xd/hd struct")
    end

end

################################################################
# Nodes
# strings
function addelementOne!(aml::Node, name::String, value::String, amlType::Int64)

    if !isnothing(value) # do nothing if value is nothing

        if amlType == 0 # normal elements

            addelement!(aml, name, value)

        elseif amlType == 2 # Attributes

            link!(aml, AttributeNode(name, value))

        end
    end
end

# number
function addelementOne!(aml::Node, name::String, value::T, amlType::Int64) where {T<:Union{Number, Bool}}

    if !isnothing(value) # do nothing if value is nothing

        if amlType == 0 # normal elements

            addelement!(aml, name, string(value))
        elseif amlType == 2 # Attributes

            link!(aml, AttributeNode(name, string(value)))

        end
    end
end

#  defined or nothing
function addelementOne!(aml::Node, name::String, value::T, amlType::Int64) where {T}
    if !isnothing(value)
        if hasmethod(string, Tuple{T})
            if amlType == 0 # normal elements

                addelement!(aml, name, string(value))
            elseif amlType == 2 # Attributes

                link!(aml, AttributeNode(name, string(value)))

            end
        else
            link!(aml,value.aml)
        end
    end
end

# vector of strings
function addelementVect!(aml::Node, name::String, value::Vector{String}, amlType::Int64)


    if amlType == 0 # normal elements

        for ii = 1:length(value)
            if !isnothing(value[ii]) # do nothing if value is nothing
                addelement!(aml, name, value[ii])
            end
        end

    elseif amlType == 2 # Attributes

        for ii = 1:length(value)
            if !isnothing(value[ii]) # do nothing if value is nothing
                link!(aml, AttributeNode(name, value[ii]))
            end
        end
    end
end

# vector of numbers
function addelementVect!(aml::Node, name::String, value::Vector{T}, amlType::Int64) where {T<:Union{Number, Bool}}

    if amlType == 0 # normal elements

        for ii = 1:length(value)
            if !isnothing(value[ii]) # do nothing if value is nothing
                addelement!(aml, name, string(value[ii]))
            end
        end

    elseif amlType == 2 # Attributes

        for ii = 1:length(value)
            if !isnothing(value[ii]) # do nothing if value is nothing
                link!(aml, AttributeNode(name, string(value[ii])))
            end
        end
    end
end

#  vector of defined or nothing
function addelementVect!(aml::Node, name::String, value::Vector{T}, amlType::Int64) where {T}
    for ii = 1:length(value)
        if !isnothing(value[ii]) # do nothing if value is nothing
            if hasmethod(string, Tuple{T})
                if amlType == 0 # normal elements

                    addelement!(aml, name, string(value[ii]))
                elseif amlType == 2 # Attributes

                    link!(aml, AttributeNode(name, string(value[ii])))

                end
            else
                link!(aml,value[ii].aml)
            end
        end
    end
end
