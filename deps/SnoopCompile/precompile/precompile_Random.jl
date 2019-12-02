function _precompile_()
    ccall(:jl_generating_output, Cint, ()) == 1 || return nothing
    precompile(Tuple{typeof(Random.seed!), Array{UInt32, 1}})
    precompile(Tuple{typeof(Random.default_rng)})
end
