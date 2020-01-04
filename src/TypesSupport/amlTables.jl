using Tables, PrettyTables
import EzXML.parsehtml

function amlTable(x)
  io = IOBuffer()
  pretty_table(io, x, backend = :html)
  str = String(resize!(io.data, io.size))

  html = root(parsehtml(str))
  return html
end
