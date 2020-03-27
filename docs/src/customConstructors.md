# Custom Constructors

## Adding Custom code to the structures

AcuteML introduces three `@creator`, `@extractor`, and `@updater` macros to be used inside `@aml` definition. The location of the macros specifies their location in the function. For example, putting `@creator` at the begining, adds the code to begining of creator function.


- Put `@creator` inside `@aml` to add a custom code to the creator function (DOM creation when the struct is instanciated).

  This macro only affects creation (not extraction/updating), but can be used in combination with other macros.

- Put `@extractor` inside `@aml` to add a custom code to the extractor function (DOM parsing when a html/xml text is used for instanciation of a struct).

  This macro only affects creation (not creation/updating), but can be used in combination with other macros.

  Be careful that setting struct fields using `@extractor` only changes the struct field and not the xml code.

- Put `@updater` inside `@aml` to add a custom code to the updater function (DOM updating after instanciation of a struct).

  This macro only affects updating (not creation/extraction), but can be used in combination with other macros.

In the following example `IQ` and `average` are calculated automatically. Also, in the following example `log` is filled automatically (which doesn't have an associated xml element).

```julia
using AcuteML
# Definition
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
    # add custom code to the end of extractor function

    log::UN{String} = nothing, "~"

    @extractor begin
        if GPA > 4.0
            log = "A genius with a GPA of $GPA is found" # setting fields using @extractor only changes the field and not the xml code
        end
    end
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

################################################################
# Creation
smarts = [Student(name = "Jack-smart", GPA = 2.0), Student(name = "Sara-genius", GPA = 5.0)]
mathclass = MathClass(students = smarts)

mathclass.students[1].name # "Jack"
mathclass.students[2].name # "Sara"
mathclass.average # 3.5

pprint(mathclass)
# <math-class>
#     <student IQ="smart">
#       <name>Jack</name>
#       <GPA>2.0</GPA>
#     </student>
#     <student IQ="genius">
#       <name>Sara</name>
#       <GPA>5.0</GPA>
#     </student>
#     <average>3.5</average>
#   </math-class>

################################################################
# Extraction

xml = parsexml("""
<math-class>
    <student>
      <name>Jack</name>
      <GPA>2.0</GPA>
    </student>
    <student>
      <name>Sara</name>
      <GPA>5.0</GPA>
    </student>
    <average>3.5</average>
  </math-class>
""")

mathclass = MathClass(xml)

mathclass.students[2].log # "A genius with a GPA of 5.0 is found"
```

## Making a Type and constructor from scratch using AcuteML Backend

You can use AcuteML utilities to define custom type constructors from scratch or to override `@aml` defined constructors.

Notice that if you don't use `@aml`, you should include `aml::Node` as one of your fields.

Functions to use for custom html/xml constructor:
- [initialize_node](@ref): function to initialize the aml
- [addelm!](@ref) : to add elements (single or a vector of elements)
Use these functions, to make a method that calculates the `aml` inside the function and returns all of the fields.

Functions to use for custom html/xml extractor:
- [findcontent](@ref) : to extract elements
Use these functions, to make a method that gets the `aml::Node` and calculates and returns all of the fields.

Functions to support mutability:
- [updatecontent!](@ref): Finds all the elements with the address of string in the node, and updates the content.

# Example:
In this example we define `Identity` with custom constructors:
```julia
using AcuteML

mutable struct Identity
    pitch::UN{Pitch}
    rest::UN{Rest}
    unpitched::UN{Unpitched}
    aml::Node
end

function Identity(;pitch = nothing, rest = nothing, unpitched = nothing)

    # This constructor only allows one the fields to exist - similar to choice element in XS

    aml = initialize_node(AbsNormal, "identity")

    if pitch != nothing
        addelm!(aml, "pitch", pitch, AbsNormal)
    elseif rest != nothing
        addelm!(aml, "rest", rest, AbsNormal)
    elseif unpitched != nothing
        addelm!(aml, "unpitched", unpitched, AbsNormal)
    else
        error("one of the pitch, rest or unpitched should be given")
    end

    return Identity(pitch, rest, unpitched, aml)
end

function Identity(;aml)

        pitch = findcontent(Pitch, "pitch", aml, AbsNormal)
        rest = findcontent(Rest, "rest", aml, AbsNormal)
        unpitched = findcontent(Unpitched, "unpitched", aml, AbsNormal)

        return Identity(pitch, rest, unpitched, aml)
end
```
