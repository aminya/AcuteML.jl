# Custom Value Types

In order to make a custom type work with `@aml`, you need to define two methods for your type:

1)
```julia
# String printing
string(x::yourType) = some_string_as_your_type_content

# or

# Node creation
aml(x::yourType) = a_Node
```

2)
```julia
# String parsing
yourType(x::String) = a_type_made_from_a_string

# or

# Node parsing
yourType(x::Node) = a_type_made_from_a_Node
```
-----------------------------------

Date and Time types are supported through string printing and parsing. Tables compatible types are supported through Node creation and parsing. A combination of two options for each method is also possible.


## Example - String printing and parsing:

```julia
# Defining
Date(2013,7,1)

# Methods Check
string(Date(2013,7,1))
Date("2013-7-1")
############################
# Defining
Time(12,53,40)

# Methods Check
string(Time(12,53,40))
Time("12:53:40")
############################
# Defining
DateTime(2013,5,1,12,53,40)

# Methods Check
# check
string(DateTime(2013,5,1,12,53,40))
DateTime("2013-05-01T12:53:40")
```

## Example - Node creation and parsing:

You can directly create a Node using AcuteML utilities. See [Custom Constructors](https://aminya.github.io/AcuteML.jl/dev/customConstructors/) for more information.

You can also use a templating features of AcuteML to make a html as a string. For example, write a `html_as_string` function that returns the html as a string then, use `findfirst("html/body/HeaderName",parsehtml(str))` to parse it.

```julia
function aml(x::YourType)
  str::Stirng = hmtl_as_string(x)

  html = findfirst("html/body/HeaderName",parsehtml(str))
  unlink!(html)
  return html
end

```
