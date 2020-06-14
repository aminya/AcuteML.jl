using MusicXML
using Test

cd(@__DIR__)

@testset "parsing example" begin
    include("parsing.jl")
    @test scorepartwise isa MX.ScorePartwise
    @test scoreparts isa Vector{MX.ScorePart}
    @test parts isa Vector{MX.Part}
end

@testset "creating example" begin
    include("creating.jl")
    @test isfile("myscore.musicxml")
end

@testset "grace note" begin
    include("grace.jl")
end
