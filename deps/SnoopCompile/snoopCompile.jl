using SnoopCompile

@snoopiBot "AcuteML" begin
    using AcuteML, Pkg

    # Use runtests.jl
    # include(joinpath(dirname(dirname(pathof(AcuteML))), "test","runtests.jl"))

    # Ues examples
    include(joinpath(dirname(dirname(pathof(AcuteML))), "test","runtests.jl"))
    include(joinpath(dirname(dirname(pathof(AcuteML))), "examples","extractor.jl"))
    include(joinpath(dirname(dirname(pathof(AcuteML))), "examples","constructor.jl"))
    # include(joinpath(dirname(dirname(pathof(AcuteML))), "examples","templating","templating.jl"))

end
