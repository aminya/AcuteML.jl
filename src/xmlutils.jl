using EzXML, TypeTransform
import EzXML: Document, Node

import Tables

export init_docorelm, UN
################################################################
UN{T}= Union{T, Nothing}
################################################################
include("xmlutils/types.jl")
include("xmlutils/initializer.jl")
include("xmlutils/creators.jl")
include("xmlutils/extractors.jl")
include("xmlutils/updaters.jl")
################################################################
