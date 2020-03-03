using MusicXML

cd(@__DIR__)

@testset "parsing example" begin
    include("parsing.jl")
    @test scorepartwise isa ScorePartwise
    @test scoreparts isa Vector{ScorePart}
    @test parts isa Vector{Part}
end

@testset "creating example" begin
    include("creating.jl")
    @test isfile("myscore.musicxml")
end
