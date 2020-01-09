################################################################
# Init
################################################################
# doc or element initialize
"""
    docOrElmInit(docOrElmType)

Function to initialize the aml
"""
function docOrElmInit(::Type{AbsHtml}, amlName::String = "html")
    out = HTMLDocument() # no URI and external id
    htmlNode = ElementNode(amlName)
    setroot!(out, htmlNode) # adding html node
    return out
end

function docOrElmInit(::Type{AbsXml}, amlName::String = "xml")
    out = XMLDocument() # version 1
    return out
end

function docOrElmInit(::Type{<:AbsNormal}, amlName::String)
    out = ElementNode(amlName) # element node
    return out
end
