# Custom Contructors

# Define constructors on top of `@aml`
You can add constructors to your `@aml` defined type. In the function that you define you should return a call to the type with keywords assigned to the values.

### Example
In the following example we define two costom constuctors for our `@aml` defined struct.
```julia

# define a struct using @aml
@aml struct Pitch "pitch"
    step::String, "step"
    alter::UN{Float16} = nothing, "alter"
    octave::Int8, "octave"
end
```
```julia
import MusicXML.pitch2xml  # some function from MusicXML.jl

# 1st custom constructor:
function Pitch(; pitch::Int64)

    step, alter, octave = pitch2xml(pitch)

    return Pitch(step = step, alter = alter, octave = octave) # return the main struct constructor with values assigned as keyword arguments
end
```
```julia
# 2nd custom constructor:
function Pitch(; step::String)

    if step == "C"
        octave = 0
    else
        octave = 10
    end

    return Pitch(step = step, octave = octave) # return the main struct constructor with values assigned as keyword arguments
end

```


Functions to use for custom html/xml constructor:
- [docOrElmInit](@ref): Function to initialize the aml
- [addelementOne!](@ref) : to add single elements
- [addelementVect!](@ref) : to add multiple elements (vector)
Use these functions, to make a method that calculates the `aml` inside the function and returns all of the fields.

Functions to use for custom html/xml extractor:
- [findfirstcontent](@ref) : to extract single elements
- [findallcontent](@ref) : to extract multiple elements (vector)
Use these functions, to make a method that gets the `aml::Node` and calculates and returns all of the fields.

Notice that if you don't use `@aml`, you should include `aml::Node` as one of your fields.

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

    aml = docOrElmInit("identity")

    if pitch != nothing
        addelementOne!(aml, "pitch", pitch)
    elseif rest != nothing
        addelementOne!(aml, "rest", rest)
    elseif unpitched != nothing
        addelementOne!(aml, "unpitched", unpitched)
    else
        error("one of the pitch, rest or unpitched should be given")
    end

    return Identity(pitch, rest, unpitched, aml)
end

function Identity(;aml)

        pitch = findfirstcontent(Pitch, "pitch", aml, 0)
        rest = findfirstcontent(Rest, "rest", aml, 0)
        unpitched = findfirstcontent(Unpitched, "unpitched", aml, 0)

        return Identity(pitch, rest, unpitched, aml)
end
```
