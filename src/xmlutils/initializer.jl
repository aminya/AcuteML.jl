################################################################
# Init
################################################################
# doc or element initialize
"""
    init_docorelm(docOrElmType)

Function to initialize the aml
"""
function init_docorelm(::Type{AbsHtml}, amlName::String = "html")
    out = HTMLDocument() # no URI and external id
    htmlNode = ElementNode(amlName)
    setroot!(out, htmlNode) # adding html node
    return out
end

function init_docorelm(::Type{AbsXml}, amlName::String = "xml")
    out = XMLDocument() # version 1
    return out
end

function init_docorelm(::Type{<:AbsNormal}, amlName::String)
    out = ElementNode(amlName) # element node
    return out
end

# no type method
function init_docorelm(amlName::String)
    out = ElementNode(amlName) # element node
    return out
end
