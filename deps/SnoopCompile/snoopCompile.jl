using SnoopCompile

################################################################
packageName = "AcuteML"

function precompileDeactivator(packageName)

    filePath = joinpath(pwd(),"src","$packageName.jl")
    file = open(filePath,"r")
    packageText = read(file, String)
    close(file)

    packageEdited = foldl(replace,
                 (
                  "include(\"../deps/SnoopCompile/precompile/precompile_$packageName.jl\")" => "#include(\"../deps/SnoopCompile/precompile/precompile_$packageName.jl\")",
                  "_precompile_()" => "#_precompile_()",
                 ),
                 init = packageText)

     file = open(filePath,"w")
     write(file, packageEdited)
     close(file)
end

function precompileActivator(packageName)

    filePath = joinpath(pwd(),"src","$packageName.jl")
    file = open(filePath,"r")
    packageText = read(file, String)
    close(file)

    packageEdited = foldl(replace,
                 (
                  "#include(\"../deps/SnoopCompile/precompile/precompile_$packageName.jl\")" => "include(\"../deps/SnoopCompile/precompile/precompile_$packageName.jl\")",
                  "#_precompile_()" => "_precompile_()",
                 ),
                 init = packageText)

     file = open(filePath,"w")
     write(file, packageEdited)
     close(file)
end

################################################################
precompileDeactivator(packageName);

rootPath = pwd()
cd(@__DIR__)

### Log the compiles
# This only needs to be run once (to generate log file)

SnoopCompile.@snoopc "$(pwd())/Snoop.log" begin

    # Use runtests.jl or your exmaples that uses package:

    using AcuteML, Pkg

    include(joinpath(dirname(dirname(pathof(AcuteML))), "test","runtests.jl"))
    include(joinpath(dirname(dirname(pathof(AcuteML))), "examples","extractor.jl"))
    include(joinpath(dirname(dirname(pathof(AcuteML))), "examples","constructor.jl"))
    # include(joinpath(dirname(dirname(pathof(AcuteML))), "examples","templating","templating.jl"))


end

################################################################

### Parse the compiles and generate precompilation scripts
# This can be run repeatedly to tweak the scripts

data = SnoopCompile.read("$(pwd())/Snoop.log")

pc = SnoopCompile.parcel(reverse!(data[2]))
SnoopCompile.write("$(pwd())/precompile", pc)

################################################################
precompileActivator(packageName)
cd(rootPath)
