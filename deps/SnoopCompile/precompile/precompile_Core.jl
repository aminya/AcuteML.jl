function _precompile_()
    ccall(:jl_generating_output, Cint, ()) == 1 || return nothing
    isdefined(Core, Symbol("#kw#Type")) && precompile(Tuple{getfield(Core, Symbol("#kw#Type")), NamedTuple{(:university,), Tuple{Main.University}}, Type{Main.Doc}})
    isdefined(Core, Symbol("#kw#Type")) && precompile(Tuple{getfield(Core, Symbol("#kw#Type")), NamedTuple{(:university,), Tuple{Main.University}}, Type{Main.Doc}})
    isdefined(Core, Symbol("#kw#Type")) && precompile(Tuple{getfield(Core, Symbol("#kw#Type")), NamedTuple{(:name, :people), Tuple{String, Array{Main.Person, 1}}}, Type{Main.University}})
    isdefined(Core, Symbol("#kw#Type")) && precompile(Tuple{getfield(Core, Symbol("#kw#Type")), NamedTuple{(:age, :field, :GPA, :courses, :id), Tuple{Int64, String, Int64, Array{String, 1}, Int64}}, Type{Main.Person}})
    isdefined(Core, Symbol("#kw#Type")) && precompile(Tuple{getfield(Core, Symbol("#kw#Type")), NamedTuple{(:age, :field, :courses, :id), Tuple{Int64, String, Array{String, 1}, Int64}}, Type{Main.Person}})
    isdefined(Core, Symbol("#kw#Type")) && precompile(Tuple{getfield(Core, Symbol("#kw#Type")), NamedTuple{(:name, :people), Tuple{String, Array{Main.Person, 1}}}, Type{Main.University}})
    isdefined(Core, Symbol("#kw#Type")) && precompile(Tuple{getfield(Core, Symbol("#kw#Type")), NamedTuple{(:age, :field, :courses, :id), Tuple{Int64, String, Array{String, 1}, Int64}}, Type{Main.Person}})
    isdefined(Core, Symbol("#kw#Type")) && precompile(Tuple{getfield(Core, Symbol("#kw#Type")), NamedTuple{(:age, :field, :GPA, :courses, :id), Tuple{Int64, String, Int64, Array{String, 1}, Int64}}, Type{Main.Person}})
end
