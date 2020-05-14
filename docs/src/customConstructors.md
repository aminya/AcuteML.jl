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
