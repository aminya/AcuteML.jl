export pprint

################################################################
# I/O
import EzXML: parsexml, parsehtml, readxml, readhtml
# from EzXML
funs = [:parsexml, :parsehtml, :readxml, :readhtml]
for fun in funs

    @eval begin

        # doc
        @doc (@doc $(fun)) $(fun)

        # exporting
        export $(fun)
    end
end
################################################################
"""
    pprint(x)
    pprint(io::IO, x::T)

Pretty prints the xml/html content of a aml type. Also, pretty prints a Node or Document type.
"""
function pprint(io::IO, x::T) where {T<:Union{Document, Node}}
    println("")
    prettyprint(io, x)
end

function pprint(x::T) where {T<:Union{Document, Node}}
    println("")
    prettyprint(x)
end
