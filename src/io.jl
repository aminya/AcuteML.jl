export pprint, pwrite

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
    pprint(io, x)
    pprint(filename, x)

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

function pprint(filename::AbstractString, x::T) where {T<:Union{Document, Node}}
    open(io->pprint(io, x), filename, "w")
end

function pprint(io::IO, x)
    println("")
    prettyprint(io, x.aml)
end

function pprint(x)
    println("")
    prettyprint(x.aml)
end

function pprint(filename::AbstractString, x)
    open(io->pprint(io, x.aml), filename, "w")
end

const pwrite = pprint
const write = pprint
const print = pprint
