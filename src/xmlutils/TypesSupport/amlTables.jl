using Tables, PrettyTables
import EzXML.parsehtml

function amlTable(x)
  io = IOBuffer()
  pretty_table(io, x, backend = :html, standalone = false)
  str = String(resize!(io.data, io.size))

  html = Base.findfirst("html/body/table",parsehtml(str))
  unlink!(html)
  return html
end
