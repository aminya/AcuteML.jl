function _precompile_()
    ccall(:jl_generating_output, Cint, ()) == 1 || return nothing
    Base.precompile(Tuple{Core.kwftype(typeof(AcuteML.render2file)),NamedTuple{(:id, :age, :field, :GPA, :courses), Tuple{Int64, Int64, String, Float64, Vector{String}}},typeof(render2file),String,Bool})
    Base.precompile(Tuple{typeof(AcuteML.aml_create),Expr,Vector{Union{Expr, Symbol}},Vector{Any},Vector{Union{Expr, Symbol, Type}},Vector{Union{Expr, Symbol}},Vector{Union{Missing, String}},Vector{Union{Missing, Function, Symbol}},Vector{Union{Missing, Type}},String,Type,Array{Union{Missing, Function, Symbol}, 0},Bool,Vector{Union{Nothing, Expr}},Vector{Union{Nothing, Expr}},Vector{Union{Nothing, Expr}},Expr})
    Base.precompile(Tuple{typeof(AcuteML.aml_create),Expr,Vector{Union{Expr, Symbol}},Vector{Any},Vector{Union{Expr, Symbol, Type}},Vector{Union{Expr, Symbol}},Vector{Union{Missing, String}},Vector{Union{Missing, Function, Symbol}},Vector{Union{Missing, Type}},String,Type,Array{Union{Missing, Function, Symbol}, 0},Bool,Vector{Union{Nothing, Expr}},Vector{Union{Nothing, Expr}},Vector{Union{Nothing, Expr}},Symbol})
    Base.precompile(Tuple{typeof(AcuteML.aml_parse),Expr})
    Base.precompile(Tuple{typeof(AcuteML.findalltext),UnitRange{Int64},Node})
    Base.precompile(Tuple{typeof(AcuteML.multiString),Vector{String}})
    Base.precompile(Tuple{typeof(findcontent),Type{Vector{Float64}},String,Node,Type{AbsNormal}})
    Base.precompile(Tuple{typeof(findcontent),Type{Vector{Int64}},String,Node,Type{AbsNormal}})
    Base.precompile(Tuple{typeof(updatecontent!),Dict{String, String},String,Node,Type{AbsNormal}})
    Base.precompile(Tuple{typeof(updatecontent!),Vector{String},String,Node,Type{AbsText}})
end
