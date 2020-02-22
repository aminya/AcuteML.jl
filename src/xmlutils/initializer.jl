export initialize_node

################################################################
# Init
################################################################
# doc or element initialize
"""
    initialize_node(struct_nodetype)

Function to initialize the aml
"""
function initialize_node(::Type{AbsHtml}, struct_name::String = "html")
    out = HTMLDocument() # no URI and external id
    htmlNode = ElementNode(struct_name)
    setroot!(out, htmlNode) # adding html node
    return out
end

function initialize_node(::Type{AbsXml}, struct_name::String = "xml_root")
    out = XMLDocument() # version 1
    xmlNode = ElementNode(struct_name)
    setroot!(out, xmlNode) # adding html node
    return out
end

function initialize_node(::Type{<:AbsNormal}, struct_name::String)
    out = ElementNode(struct_name) # element node
    return out
end

function initialize_node(::Type{AbsText}, struct_name::String)
    out = TextNode(struct_name) # text node
    return out
end

# no type method
function initialize_node(struct_name::String)
    out = ElementNode(struct_name) # element node
    return out
end
