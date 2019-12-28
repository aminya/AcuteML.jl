# dev your package

# comment the precompile part of your package ("include() and _precompile_()")
# run this benchmark
# restart Julia

# uncomment the precompile part of your package ("include() and _precompile_()")
# run this benchmark
# restart Julia

# now compare the result
################################################################
using SnoopCompile

println("Package load time:")
loadSnoop = @snoopi using AcuteML

println(timesum(loadSnoop))

################################################################
println("Running Examples/Tests:")
runSnoop = @snoopi begin

    using AcuteML

    # Use runtests.jl
    # include(joinpath(dirname(dirname(pathof(AcuteML))), "test","runtests.jl"))

    # Ues examples
    include(joinpath(dirname(dirname(pathof(AcuteML))), "test","runtests.jl"))
    include(joinpath(dirname(dirname(pathof(AcuteML))), "examples","extractor.jl"))
    include(joinpath(dirname(dirname(pathof(AcuteML))), "examples","constructor.jl"))
    # include(joinpath(dirname(dirname(pathof(AcuteML))), "examples","templating","templating.jl"))

end

println(timesum(runSnoop))
