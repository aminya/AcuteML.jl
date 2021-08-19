# Use
#    @warnpcfail precompile(args...)
# if you want to be warned when a precompile directive fails
macro warnpcfail(ex::Expr)
    modl = __module__
    file = __source__.file === nothing ? "?" : String(__source__.file)
    line = __source__.line
    quote
        $(esc(ex)) || @warn """precompile directive
     $($(Expr(:quote, ex)))
 failed. Please report an issue in $($modl) (after checking for duplicates) or remove this directive.""" _file=$file _line=$line
    end
end


function _precompile_()
    ccall(:jl_generating_output, Cint, ()) == 1 || return nothing
    Base.precompile(Tuple{Core.kwftype(typeof(render2file)),NamedTuple{(:id, :age, :field, :GPA, :courses), Tuple{Int64, Int64, String, Float64, Vector{String}}},typeof(render2file),String,Bool})
    Base.precompile(Tuple{typeof(addnode!),Node,String,Vector{Float64},Type{AbsNormal}})
    Base.precompile(Tuple{typeof(aml_create),Expr,Vector{Union{Expr, Symbol}},Vector{Any},Vector{Union{Expr, Symbol, Type}},Vector{Union{Expr, Symbol}},Vector{Union{Missing, String}},Vector{Union{Missing, Function, Symbol}},Vector{Union{Missing, Type}},String,Type,Array{Union{Missing, Function, Symbol}, 0},Bool,Vector{Union{Nothing, Expr}},Vector{Union{Nothing, Expr}},Vector{Union{Nothing, Expr}},Expr})
    Base.precompile(Tuple{typeof(aml_create),Expr,Vector{Union{Expr, Symbol}},Vector{Any},Vector{Union{Expr, Symbol, Type}},Vector{Union{Expr, Symbol}},Vector{Union{Missing, String}},Vector{Union{Missing, Function, Symbol}},Vector{Union{Missing, Type}},String,Type,Array{Union{Missing, Function, Symbol}, 0},Bool,Vector{Union{Nothing, Expr}},Vector{Union{Nothing, Expr}},Vector{Union{Nothing, Expr}},Symbol})
    Base.precompile(Tuple{typeof(aml_parse),Expr})
    Base.precompile(Tuple{typeof(findcontent),Type{Vector{Float64}},String,Node,Type{AbsNormal}})
    Base.precompile(Tuple{typeof(findcontent),Type{Vector{Int64}},String,Node,Type{AbsNormal}})
    Base.precompile(Tuple{typeof(findfirsttext),Int64,Node})
    Base.precompile(Tuple{typeof(multiString),Vector{String}})
    Base.precompile(Tuple{typeof(updatecontent!),Dict{String, String},String,Node,Type{AbsNormal}})
    Base.precompile(Tuple{typeof(updatecontent!),Vector{Any},String,Node,Type{AbsNormal}})
end
