# Extra Constructors
## Constructors on top of `@aml`

You can add constructors to your `@aml` defined type. In the function that you define you should return a call to the type with keywords assigned to the values.

### Example
In the following example we define two custom constructors for our `@aml` defined struct.
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
