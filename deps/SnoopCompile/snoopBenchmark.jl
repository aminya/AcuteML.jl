# dev your package

# comment the precompile part of your package ("include() and _precompile_()")
# run this benchmark
# restart Julia

# uncomment the precompile part of your package ("include() and _precompile_()")
# run this benchmark
# restart Julia

# now compare the result

################################################################
function timesum(snoop)

    timeSum = 0
    for x in snoop
        timeSum+=x[1]
    end

    println(timeSum)

    return timeSum
end
################################################################
using SnoopCompile

println("Package load time:")
loadSnoop = @snoopi using MatLang

timesum(loadSnoop)

################################################################
println("Running Examples/Tests:")
runSnoop = @snoopi begin

    using AcuteML

    include(joinpath(dirname(dirname(pathof(AcuteML))), "test","runtests.jl"))
    include(joinpath(dirname(dirname(pathof(AcuteML))), "examples","extractor.jl"))
    include(joinpath(dirname(dirname(pathof(AcuteML))), "examples","constructor.jl"))
    include(joinpath(dirname(dirname(pathof(AcuteML))), "examples","templating","templating.jl"))


end

timesum(runSnoop)
