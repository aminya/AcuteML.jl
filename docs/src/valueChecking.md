# Value Checking

## Example for Common Value Restriction functions

Restrictions should be given as a function that returns Bool and the function checks for elements.

For example, for a vector of strings:
```julia
@aml struct Person "person"
   member::Vector{String}, "member", memberCheck
end
```
Value limit check:
```julia
memberCheck(x) = any( x>10 || x<5 )  # in a compact form: x-> any(x>10 || x<5)
# x is all the values as a vector in this case
```

Check of the length of the vector:
```julia
memberCheck(x) = 0 < length(x) && length(x) < 10
```
User should know if the vector is going to be 0-element, its type should be union with nothing, i.e., UN{}. This is because of the EzXML implementation of findfirst and findall.

Set of valuse:
```julia
setOfValues = [2,4,10]
memberCheck(x) = in.(x, setOfValues)
```
