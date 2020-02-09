using SnoopCompile

@snoopi_bot "AcuteML" begin
    using AcuteML

    # Use runtests.jl
    # include(joinpath(dirname(dirname(pathof(AcuteML))), "test","runtests.jl"))
    include(joinpath(dirname(dirname(pathof(AcuteML))), "test","xmlutils.jl"))

    # Ues examples
    include(joinpath(dirname(dirname(pathof(AcuteML))), "examples","examples.jl"))
    include(joinpath(dirname(dirname(pathof(AcuteML))), "examples","templating","templating.jl"))

end
