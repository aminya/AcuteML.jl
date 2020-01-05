# Supported Value Types

You can use Julia types such as
- String
- Number
- Bool
- Dates and Time
- Tables.jl compatible types
- ...

In addition you can use your `@aml` defined types in another `@aml` definition.

see [Custom Value Types](https://aminya.github.io/AcuteML.jl/dev/customValueTypes/) for more information about all supported value types and custom value types.

---------------------------------------------------

## `@aml` defined types

For already `@aml` defined types, name should be the same as the defined type root name
```julia
university::University, "university"
```

---------------------------------------------------

# Tables
AcuteML uses PrettyTables.jl to crate HTML from Table type data.
```julia
# Tables
Profs1 = DataFrame(course = ["Artificial Intelligence", "Robotics"], professor = ["Prof. A", "Prof. B"] )

P3 = Person(age=24, field="Mechanical Engineering", courses = ["Artificial Intelligence", "Robotics"], professors= Profs1, id = 1)

pprint(P3)
#=
<person id="1">
<age>24</age>
<study-field>Mechanical Engineering</study-field>
<GPA>4.5</GPA>
<taken-courses>Artificial Intelligence</taken-courses>
<taken-courses>Robotics</taken-courses>
<table>
<tr class="header">
<th style="text-align: right; ">course</th>
<th style="text-align: right; ">professor</th>
</tr>
<tr class="subheader headerLastRow">
<th style="text-align: right; ">String</th>
<th style="text-align: right; ">String</th>
</tr>
<tr>
<td style="text-align: right; ">Artificial Intelligence</td>
<td style="text-align: right; ">Prof. A</td>
</tr>
<tr>
<td style="text-align: right; ">Robotics</td>
<td style="text-align: right; ">Prof. B</td>
</tr>
</table>
</person>
=#
```

---------------------------------------------------

## Dates and Time:

- [Date](https://docs.julialang.org/en/v1/stdlib/Dates/#Dates.Date-Tuple{Int64,Int64,Int64})
Is covered under defined types, and it automatically is converted to the correct format
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
Is covered under defined types, and it automatically is converted to the correct format
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
Is covered under defined types, and it automatically is converted to the correct format
```julia
# Defining
DateTime(2013,5,1,12,53,40)
DateTime("2013-05-01T12:53:40")
```
```xml
<some-datatime>YYYY-MM-DDThh:mm:ss</some-datatime>
<some-datatime>2013-05-01T12:53:40</some-datatime>
```
