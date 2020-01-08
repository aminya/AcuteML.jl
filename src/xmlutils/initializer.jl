################################################################
# Init
################################################################
# doc or element initialize
"""
    docOrElmInit(docOrElmType)

Function to initialize the aml
"""
function docOrElmInit(::Type{AbsHtml})
    out = HTMLDocument() # no URI and external id
    htmlNode = ElementNode("html")
    setroot!(out, htmlNode) # adding html node
    return out
end

function docOrElmInit(::Type{AbsXml})
    out = XMLDocument() # version 1
    return out
end

function docOrElmInit(::Type{Union{AbsNormal, AbsEmpty}})
    out = ElementNode(name) # element node
    return out
end
