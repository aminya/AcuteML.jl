using SnoopCompile

@snoopiBot "AcuteML" begin
    using AcuteML

    # Use runtests.jl
    # include(joinpath(dirname(dirname(pathof(AcuteML))), "test","runtests.jl"))

    # Ues examples
    include(joinpath(dirname(dirname(pathof(AcuteML))), "examples","examples.jl"))
    include(joinpath(dirname(dirname(pathof(AcuteML))), "examples","templating","templating.jl"))

end
