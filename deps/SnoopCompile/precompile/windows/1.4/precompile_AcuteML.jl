function _precompile_()
    ccall(:jl_generating_output, Cint, ()) == 1 || return nothing
    Base.precompile(Tuple{Core.kwftype(typeof(AcuteML.render2file)),NamedTuple{(:id, :age, :field, :GPA, :courses),Tuple{Int64,Int64,String,Float64,Array{String,1}}},typeof(render2file),String,Bool})
    Base.precompile(Tuple{typeof(AcuteML.aml_create),Expr,Array{Union{Expr, Symbol},1},Array{Any,1},Array{Union{Expr, Symbol, Type},1},Array{Union{Expr, Symbol},1},Array{Union{Missing, String},1},Array{Union{Missing, Function, Symbol},1},Array{Union{Missing, Type},1},String,Type{T} where T,Array{Union{Missing, Function, Symbol},0},Bool,Array{Union{Nothing, Expr},1},Array{Union{Nothing, Expr},1},Array{Union{Nothing, Expr},1},Expr})
    Base.precompile(Tuple{typeof(AcuteML.aml_create),Expr,Array{Union{Expr, Symbol},1},Array{Any,1},Array{Union{Expr, Symbol, Type},1},Array{Union{Expr, Symbol},1},Array{Union{Missing, String},1},Array{Union{Missing, Function, Symbol},1},Array{Union{Missing, Type},1},String,Type{T} where T,Array{Union{Missing, Function, Symbol},0},Bool,Array{Union{Nothing, Expr},1},Array{Union{Nothing, Expr},1},Array{Union{Nothing, Expr},1},Symbol})
    Base.precompile(Tuple{typeof(AcuteML.aml_parse),Expr})
    Base.precompile(Tuple{typeof(AcuteML.get_struct_xmlcreator),Expr,Array{Any,1},Array{Union{Expr, Symbol},1},Nothing,Expr,Array{Expr,1},Array{Expr,1},Nothing})
    Base.precompile(Tuple{typeof(AcuteML.multiString),Array{String,1}})
    Base.precompile(Tuple{typeof(addnode!),Node,String,Array{Any,1},Type{AbsNormal}})
    Base.precompile(Tuple{typeof(addnode!),Node,String,Array{Float64,1},Type{AbsNormal}})
    Base.precompile(Tuple{typeof(addnode!),Node,String,Array{String,1},Type{AbsText}})
    Base.precompile(Tuple{typeof(addnode!),Node,String,Node,Type{AbsNormal}})
    Base.precompile(Tuple{typeof(findcontent),Type{Array{Float64,1}},String,Node,Type{AbsNormal}})
    Base.precompile(Tuple{typeof(findcontent),Type{Array{Int64,1}},String,Node,Type{AbsNormal}})
    Base.precompile(Tuple{typeof(get),Node,String,Nothing})
    Base.precompile(Tuple{typeof(updatecontent!),Array{Any,1},String,Node,Type{AbsNormal}})
    Base.precompile(Tuple{typeof(updatecontent!),Dict{String,String},String,Node,Type{AbsNormal}})
end
