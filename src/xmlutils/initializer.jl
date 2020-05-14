export createnode

################################################################
# Init
################################################################
# doc or element initialize
"""
    createnode(struct_nodetype)

Function to initialize the aml
"""
function createnode(::Type{AbsHtml}, struct_name::String = "html")
    out = HTMLDocument() # no URI and external id
    htmlNode = ElementNode(struct_name)
    setroot!(out, htmlNode) # adding html node
    return out
end

function createnode(::Type{AbsXml}, struct_name::String = "xml_root")
    out = XMLDocument() # version 1
    xmlNode = ElementNode(struct_name)
    setroot!(out, xmlNode) # adding html node
    return out
end

function createnode(::Type{<:AbsNormal}, struct_name::String)
    out = ElementNode(struct_name) # element node
    return out
end

function createnode(::Type{AbsText}, struct_name::String)
    out = TextNode(struct_name) # text node
    return out
end

# no type method
function createnode(struct_name::String)
    out = ElementNode(struct_name) # element node
    return out
end
