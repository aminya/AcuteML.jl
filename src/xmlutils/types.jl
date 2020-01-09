export AbsDocOrNode, AbsDocument, AbsNode, AbsXml, AbsHtml, AbsAttribute, AbsNormal, AbsEmpty

abstract type AbsDocOrNode end

abstract type AbsDocument <:AbsDocOrNode end
abstract type AbsNode <:AbsDocOrNode end

# Documents
abstract type AbsXml <: AbsDocument end
abstract type AbsHtml <: AbsDocument end

# Nodes
abstract type AbsNormal <: AbsNode end
abstract type AbsAttribute <: AbsNode end

abstract type AbsEmpty <: AbsNormal end

# Ignore
abstract type AbsIgnore <: AbsDocOrNode end

################################################################
function aml_dispatch(docOrElmType::Type{AbsDocOrNode}, name::String)

    if name == "html"
        docOrElmType = AbsHtml
    elseif name == "xml"
        docOrElmType = AbsXml
    else
        docOrElmType = AbsNormal
    end

    return docOrElmType
end

################################################################
# Literal Macros
################################################################
# Empty (self-closing)
macro sc_str(s)
    docOrElmType = AbsEmpty
    return docOrElmType, s
end
################################################################
# attribute
macro a_str(s)
    argAmlType = AbsAttribute
    return argAmlType, s
end
################################################################
# # namespace
# macro ns_str(s)
#     argAmlType = 18
#     return argAmlType, s
# end
