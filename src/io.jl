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

Pretty prints the xml/html content of a aml type. Also, pretty prints a Node or Document type.
"""
function pprint(x::T) where {T<:Union{Document, Node}}
    println("")
    prettyprint(x)
end
