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
    Base.precompile(Tuple{Core.kwftype(typeof(render2file)),NamedTuple{(:id, :age, :field, :GPA, :courses),Tuple{Int64,Int64,String,Float64,Array{String,1}}},typeof(render2file),String,Bool})
    Base.precompile(Tuple{typeof(addnode!),Node,String,Array{Float64,1},Type{AbsNormal}})
    Base.precompile(Tuple{typeof(addnode!),Node,String,Array{String,1},Type{AbsText}})
    Base.precompile(Tuple{typeof(addnode!),Node,String,Node,Type{AbsNormal}})
    Base.precompile(Tuple{typeof(aml_create),Expr,Array{Union{Expr, Symbol},1},Array{Any,1},Array{Union{Expr, Symbol, Type},1},Array{Union{Expr, Symbol},1},Array{Union{Missing, String},1},Array{Union{Missing, Function, Symbol},1},Array{Union{Missing, Type},1},String,Type{T} where T,Array{Union{Missing, Function, Symbol},0},Bool,Array{Union{Nothing, Expr},1},Array{Union{Nothing, Expr},1},Array{Union{Nothing, Expr},1},Expr})
    Base.precompile(Tuple{typeof(aml_create),Expr,Array{Union{Expr, Symbol},1},Array{Any,1},Array{Union{Expr, Symbol, Type},1},Array{Union{Expr, Symbol},1},Array{Union{Missing, String},1},Array{Union{Missing, Function, Symbol},1},Array{Union{Missing, Type},1},String,Type{T} where T,Array{Union{Missing, Function, Symbol},0},Bool,Array{Union{Nothing, Expr},1},Array{Union{Nothing, Expr},1},Array{Union{Nothing, Expr},1},Symbol})
    Base.precompile(Tuple{typeof(aml_parse),Expr})
    Base.precompile(Tuple{typeof(findcontent),Type{Array{Float64,1}},String,Node,Type{AbsNormal}})
    Base.precompile(Tuple{typeof(findcontent),Type{Array{Int64,1}},String,Node,Type{AbsNormal}})
    Base.precompile(Tuple{typeof(get),Node,String,Nothing})
    Base.precompile(Tuple{typeof(get_struct_xmlcreator),Expr,Array{Any,1},Array{Union{Expr, Symbol},1},Nothing,Expr,Array{Expr,1},Array{Expr,1},Nothing})
    Base.precompile(Tuple{typeof(multiString),Array{String,1}})
    Base.precompile(Tuple{typeof(updatecontent!),Array{Any,1},String,Node,Type{AbsNormal}})
    Base.precompile(Tuple{typeof(updatecontent!),Array{String,1},String,Node,Type{AbsText}})
    Base.precompile(Tuple{typeof(updatecontent!),Dict{String,String},String,Node,Type{AbsNormal}})
end
