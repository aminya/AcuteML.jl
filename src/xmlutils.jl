using EzXML
import EzXML: Document, Node

export docOrElmInit, UN
################################################################
UN{T}= Union{T, Nothing}
################################################################
include("xmlutils/creators.jl")
include("xmlutils/extractors.jl")
include("xmlutils/updaters.jl")
################################################################
# doc or element initialize
"""
    docOrElmInit(name)
    docOrElmInit(type, name)

Function to initialize the aml

type:
0 : element node # default
10: empty element node
-1: xml
-2: html
"""
function docOrElmInit(type::Int64 = 0, name::String = nothing)

    if type == 0 # element node

        out = ElementNode(name)

    elseif type == 10 # empty element node

        out = ElementNode(name)

    elseif type == -1 # xml

        out = XMLDocument() # version 1

    elseif type == -2 # html

        out = HTMLDocument() # no URI and external id
    end

    return out
end
################################################################
