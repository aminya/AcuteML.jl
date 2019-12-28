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
