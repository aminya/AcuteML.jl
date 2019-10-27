export newTemplate, render2file
################################################################
"""
    newTemplate(name)

Create new destination html file as the template

    newTemplate(name, :function)

Prints a function to be used as a template

# Examples
```julia
# you can create a file and edit the file directly by using
newTemplate("person")
function newTemplate(name, type::Symbol = :file, template::Union{String,Nothing} = nothing)

    if type == :file

        try
            mkpath(joinpath("app", "destination"))
        catch e

        end
        filePath = joinpath("app", "destination", "$(name).html")
        touch(filePath)

        if !isnothing(template)

            file = open(filePath, "w")
            print(file, template)
            close(file)

        else # open file in Atom for editing
            if !isdefined(Main, :Atom)
                Atom.edit(filePath)
            end
        end
    end
end
################################################################
