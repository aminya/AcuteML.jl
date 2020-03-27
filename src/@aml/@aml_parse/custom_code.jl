export @creator, @extractor, @updater

"""
    @creator

Put `@creator` inside `@aml` to add a custom code to the creator function (DOM creation when the struct is instanciated).

The location of the macro specifies its location in the function. For example, putting it at the begining, adds the code to begining of creator function.

This macro only affects creation (not extraction/updating), but can be used in combination with other macros.

In the following example `IQ` and `average` are calculated automatically.

# Example
```julia
@aml mutable struct Student "student"

    # add custom code to the begining of creator function
    # the following automatically fills IQ based on the name
    @creator begin
        if occursin("smart", name)
            name = replace(name, "-smart" => "") # remove smart from name
            IQ = "smart"
        elseif occursin("genius", name)
            name = replace(name, "-genius" => "") # remove smart from name
            IQ = "genius"
        else
            error("Give a smart student.")
        end
    end

    name::String, "~"
    GPA::Float64, "~"
    IQ::UN{String} = nothing, att"~" # default to nothing, but filled automatically by first @cretor macro
end

@aml mutable struct MathClass "math-class"
    @creator begin
        GPAsum = 0.0
        for student in students
            GPAsum = GPAsum + student.GPA
        end
        average = GPAsum / length(students) # fill average field
    end

    students::Vector{Student}, "student"
    average::UN{Float64} = nothing, "average" # calculated automatically
end

smarts = [Student(name = "Jack-smart", GPA = 2.0), Student(name = "Sara-genius", GPA = 5.0)]
mathclass = MathClass(students = smarts)
```
"""
macro creator(exp)
    return :creator, exp
end

"""
    @extractor

Put `@extractor` inside `@aml` to add a custom code to the extractor function (DOM parsing when a html/xml text is used for instanciation of a struct).

The location of the macro specifies its location in the function. For example, putting it at the begining, adds the code to begining of extractor function.

This macro only affects creation (not creation/updating), but can be used in combination with other macros.

Be careful that setting struct fields using `@extractor` only changes the struct field and not the xml code.

In the following example `log` is filled automatically (which doesn't have an associated xml element).

# Example
```julia
@aml mutable struct Student "student"

    name::String, "~"
    GPA::Float64, "~"

    log::UN{String} = nothing, "~"

    # add custom code to the end of extractor function
    @extractor begin
        if GPA > 4.0
            log = "A genius with a GPA of \$GPA is found" # setting fields using @extractor only changes the field and not the xml code
        end
    end
end

@aml mutable struct MathClass "math-class"
    students::Vector{Student}, "student"
end

smarts = [Student(name = "Jack-smart", GPA = 2.0), Student(name = "Sara-genius", GPA = 5.0)]
mathclass = MathClass(students = smarts)
```
"""
macro extractor(exp)
    return :extractor, exp
end

"""
    @updater

Put `@updater` inside `@aml` to add a custom code to the updater function (DOM updating after instanciation of a struct).

The location of the macro specifies its location in the function. For example, putting it at the begining, adds the code to begining of updater function.

This macro only affects updating (not creation/extraction), but can be used in combination with other macros.

See [`@creator`](@ref) and [`@extractor`](@ref) for some examples.
"""
macro updater(exp)
    return :updater, exp
end
