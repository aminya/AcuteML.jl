# literals
export @doc_str, @empty_str, @att_str, @txt_str
################################################################
function aml_dispatch(struct_nodetype::Type{AbstractDocument}, name::String)
    if name == "html"
        struct_nodetype = AbstractHTML
    else
        struct_nodetype = AbstractXML
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
    struct_nodetype = AbstractDocument
    return struct_nodetype, s
end

# Empty (self-closing)
macro empty_str(s)
    struct_nodetype = AbstractEmpty
    return struct_nodetype, s
end
################################################################
# attribute
macro att_str(s)
    argAmlType = AbstractAttribute
    return argAmlType, s
end
################################################################
# text node
macro txt_str(s)
    argAmlType = AbstractText
    return argAmlType, s
end
################################################################
# # namespace
# macro ns_str(s)
#     argAmlType = 18
#     return argAmlType, s
# end
