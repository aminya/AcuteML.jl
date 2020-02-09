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
