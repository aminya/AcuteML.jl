# Custom Constructors - AcuteML Backend
## Making a Type and constructor from scratch

You can use AcuteML utilities to define custom type constructors from scratch or to override `@aml` defined constructors.

Notice that if you don't use `@aml`, you should include `aml::Node` as one of your fields.

Functions to use for custom html/xml constructor:
- [init_docorelm](@ref): function to initialize the aml
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

    aml = init_docorelm(AbsNormal, "identity")

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
