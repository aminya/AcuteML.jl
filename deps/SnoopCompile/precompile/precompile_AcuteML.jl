function _precompile_()
    ccall(:jl_generating_output, Cint, ()) == 1 || return nothing
    precompile(Tuple{Core.kwftype(typeof(AcuteML.render2file)),NamedTuple{(:id, :age, :field, :GPA, :courses),Tuple{Int64,Int64,String,Float64,Array{String,1}}},typeof(render2file),String,Bool})
    precompile(Tuple{typeof(AcuteML.amlCreate),Expr,Array{Union{Expr, Symbol},1},Array{Any,1},Array{Union{Missing, Expr, Symbol, Type},1},Array{Union{Expr, Symbol},1},Array{Union{Missing, String},1},Array{Union{Missing, Function, Symbol},1},Array{Int64,1},String,String,Array{Union{Missing, Function, Symbol},0},Bool,Symbol})
    precompile(Tuple{typeof(AcuteML.amlParse),Expr})
    precompile(Tuple{typeof(AcuteML.multiString),Array{String,1}})
    precompile(Tuple{typeof(AcuteML.multiString),Float64})
    precompile(Tuple{typeof(AcuteML.multiString),Int64})
    precompile(Tuple{typeof(AcuteML.multiString),String})
    precompile(Tuple{typeof(newTemplate),String,Symbol})
    precompile(Tuple{typeof(newTemplate),String})
end
