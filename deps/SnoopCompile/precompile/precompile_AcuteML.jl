function _precompile_()
    ccall(:jl_generating_output, Cint, ()) == 1 || return nothing
    precompile(Tuple{typeof(AcuteML.amlCreate),Expr,Array{Union{Expr, Symbol},1},Array{Any,1},Array{Union{Missing, Expr, Symbol, Type},1},Array{Union{Expr, Symbol},1},Array{Union{Missing, String},1},Array{Union{Missing, Function, Symbol},1},Array{Int64,1},String,Int64,Array{Union{Missing, Function, Symbol},0},Bool,Symbol})
    precompile(Tuple{typeof(AcuteML.amlParse),Expr})
end
