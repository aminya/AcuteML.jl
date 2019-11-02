# Cutom Value Types

You can use Julia types or defined types for values.

## `@aml` defined types

For already `@aml` defined types, name should be the same as the defined type root name
```julia
university::University, "university"
```

## Dates and Time:

- [Date](https://docs.julialang.org/en/v1/stdlib/Dates/#Dates.Date-Tuple{Int64,Int64,Int64})
Is covered under defined types, and it automatically is coneverted to the correct format
```julia
# Defining
Date(2013,7,1)
Date("2013-7-1")
```

```xml
<some-date>YYYY-MM-DD</some-date>
<some-date>2013-07-01</some-date>
```
- [Time](https://docs.julialang.org/en/v1/stdlib/Dates/#Dates.Time-NTuple{5,Int64})
Is covered under defined types, and it automatically is coneverted to the correct format
```julia
# Defining
Time(12,53,40)
Time("12:53:40")
```
```xml
<some-time>hh:mm:ss</some-time>
<some-time>12:53:40</some-time>
```

- [DateTime](https://docs.julialang.org/en/v1/stdlib/Dates/#Dates.DateTime-NTuple{7,Int64})
Is covered under defined types, and it automatically is coneverted to the correct format
```julia
# Defining
DateTime(2013,5,1,12,53,40)
DateTime("2013-05-01T12:53:40")
```
```xml
<some-datatime>YYYY-MM-DDThh:mm:ss</some-datatime>
<some-datatime>2013-05-01T12:53:40</some-datatime>
```

## Custom Types
In order to make a custom type work with `@aml`, you need to define two methods for your type:

```julia
# string printing
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
