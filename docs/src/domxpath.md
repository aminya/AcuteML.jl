# AcuteML DOM/Xpath API

AcuteML provides a DOM/Xpath API that you can use to do lower level XML/HTML manipulation if needed.

You can use AcuteML utilities to define custom type constructors from scratch or to override `@aml` defined constructors.

Notice that if you don't use `@aml`, you should include `aml::Node` as one of your fields.

Functions to use for custom html/xml constructor:
- [createnode](@ref): function to create a node/document
- [addnode!](@ref) : To add nodes (single or a vector of nodes) as a child of given a node/document.
Use these functions, to make a method that calculates the `aml` inside the function and returns all of the fields.

Functions to use for custom html/xml extractor:
- [findfirst](@ref): to find the first node based on the given node name
- [findall](@ref): to find all of the nodes based on the given node name
- [findcontent](@ref) : to get the content of a node based on the given name
Use these functions, to make a method that gets the `aml::Node` and calculates and returns all of the fields.

Functions to support mutability:
- [updatecontent!](@ref): Finds all the elements with the address of string in the node, and updates the content.

 Additionally, all the EzXML API are reexported.
 
## Making a Type and constructor from scratch using AcuteML Backend

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

    aml = createnode(AbsNormal, "identity")

    if pitch != nothing
        addnode!(aml, "pitch", pitch, AbsNormal)
    elseif rest != nothing
        addnode!(aml, "rest", rest, AbsNormal)
    elseif unpitched != nothing
        addnode!(aml, "unpitched", unpitched, AbsNormal)
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
