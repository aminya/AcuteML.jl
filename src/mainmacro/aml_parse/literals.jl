################################################################
function aml_dispatch(docOrElmType::Type{AbsDocument}, name::String)
    if name == "html"
        docOrElmType = AbsHtml
    else
        docOrElmType = AbsXml
    end
    return docOrElmType
end

function aml_dispatch(docOrElmType, name::String) # itself
    return docOrElmType
end

################################################################
# Literal Macros
################################################################
# Document
macro doc_str(s)
    docOrElmType = AbsDocument
    return docOrElmType, s
end

# Empty (self-closing)
macro empty_str(s)
    docOrElmType = AbsEmpty
    return docOrElmType, s
end
################################################################
# attribute
macro att_str(s)
    argAmlType = AbsAttribute
    return argAmlType, s
end
################################################################
# text node
macro t_str(s)
    argAmlType = AbsText
    return argAmlType, s
end
################################################################
# # namespace
# macro ns_str(s)
#     argAmlType = 18
#     return argAmlType, s
# end
