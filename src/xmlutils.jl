using EzXML, TypeTransform
import EzXML: Document, Node

# to prevent EzXML error: https://github.com/bicycle1885/EzXML.jl/pull/125
function Base.show(io::IO, node::Node)
    # prefix = isdefined(Main, :Node) ? "Node" : "EzXML.Node"
    prefix = "Node"
    ntype = EzXML.nodetype(node)
    if ntype ∈ (EzXML.ELEMENT_NODE, EzXML.ATTRIBUTE_NODE) && EzXML.hasnodename(node)
        desc = string(repr(ntype), '[', EzXML.nodename(node), ']')
    else
        desc = repr(ntype)
    end
    print(io, "$(prefix)(<$desc>)")
end

################################################################
import Tables
# DataTypesSupport
include("xmlutils/aml_type_support.jl")
################################################################
include("xmlutils/initializer.jl")
include("xmlutils/creators.jl")
include("xmlutils/extractor_utils.jl")
include("xmlutils/extractors.jl")
include("xmlutils/updaters.jl")
################################################################
