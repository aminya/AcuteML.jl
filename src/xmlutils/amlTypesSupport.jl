export aml
import EzXML.parsehtml

# function amlTypesSupport(expr::Expr)
#   expr.head == :tuple || error("Invalid usage of amlTypeSupport")
#
#   numEl = length(expr.args)
#
#   var = expr.args[1]
#
#
# end

include("TypesSupport/amlTables.jl")
