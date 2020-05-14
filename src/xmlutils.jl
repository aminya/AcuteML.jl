using EzXML, TypeTransform
import EzXML: Document, Node

# to prevent EzXML error: https://github.com/bicycle1885/EzXML.jl/pull/125
# function Base.show(io::IO, node::Node)
#     # prefix = isdefined(Main, :Node) ? "Node" : "EzXML.Node"
#     prefix = "Node"
#     ntype = EzXML.nodetype(node)
#     if ntype ∈ (EzXML.ELEMENT_NODE, EzXML.ATTRIBUTE_NODE) && EzXML.hasnodename(node)
#         desc = string(repr(ntype), '[', EzXML.nodename(node), ']')
#     else
#         desc = repr(ntype)
#     end
#     print(io, "$(prefix)(<$desc>)")
# end

################################################################
import Tables
# DataTypesSupport
include("xmlutils/TypesSupport/amlTables.jl")
################################################################
include("xmlutils/initializer.jl")
include("xmlutils/addnode.jl")
include("xmlutils/nodeparse.jl")
include("xmlutils/findnode.jl")
include("xmlutils/findcontent.jl")
include("xmlutils/updater.jl")
################################################################

@deprecate addelm!(args...) addnode!(args...)
@deprecate initialize_node(args...) createnode(args...)
