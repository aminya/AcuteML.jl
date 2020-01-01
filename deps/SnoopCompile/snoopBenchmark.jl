using SnoopCompile

println("loading infer benchmark")

@snoopiBenchBot "AcuteML" using AcuteML


println("examples infer benchmark")

@snoopiBenchBot "AcuteML" begin
    using AcuteML

    # Use runtests.jl
    # include(joinpath(dirname(dirname(pathof(AcuteML))), "test","runtests.jl"))

    # Ues examples
    include(joinpath(dirname(dirname(pathof(AcuteML))), "examples","extractor.jl"))
    include(joinpath(dirname(dirname(pathof(AcuteML))), "examples","constructor.jl"))
    include(joinpath(dirname(dirname(pathof(AcuteML))), "examples","templating","templating.jl"))
end


# @snoopiBenchBot "AcuteML"
