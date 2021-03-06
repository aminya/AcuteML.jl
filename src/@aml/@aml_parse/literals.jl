# literals
export @doc_str, @empty_str, @att_str, @txt_str
################################################################
function aml_dispatch(struct_nodetype::Type{AbsDocument}, name::String)
    if name == "html"
        struct_nodetype = AbsHtml
    else
        struct_nodetype = AbsXml
    end
    return struct_nodetype
end

function aml_dispatch(struct_nodetype, name::String) # itself
    return struct_nodetype
end

################################################################
# Literal Macros
################################################################
# Document
macro doc_str(s)
    struct_nodetype = AbsDocument
    return struct_nodetype, s
end

# Empty (self-closing)
macro empty_str(s)
    struct_nodetype = AbsEmpty
    return struct_nodetype, s
end
################################################################
# attribute
macro att_str(s)
    argAmlType = AbsAttribute
    return argAmlType, s
end
################################################################
# text node
macro txt_str(s)
    argAmlType = AbsText
    return argAmlType, s
end
################################################################
# # namespace
# macro ns_str(s)
#     argAmlType = 18
#     return argAmlType, s
# end
