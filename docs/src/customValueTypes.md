# Custom Value Types

In order to make a custom type work with `@aml`, you need to define two methods for your type:

```julia
# Returning Node
aml(x::yourType) = a_Node

# or

# String printing
string(x::yourType) = some_string_as_your_type_content
```

```julia
# string parsing
yourType(x::String) = a_type_made_from_a_string
```

For example, in Julia, these types already have defined the methods required:
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
