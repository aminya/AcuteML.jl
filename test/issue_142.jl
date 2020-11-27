using AcuteML

@aml mutable struct inner "~"
    id1::Int, att"~"
    desc1::String, "~"
end

@aml mutable struct outer doc"outer"
    id2::Int, att"~"
    innerList::Vector{inner}, "inner"
end

i1 = inner(id1 = 1, desc1 = "desc1")
i2 = inner(id1 = 2, desc1 = "desc2")
o1 = outer(id2 = 3, innerList = [i1, i2])
pprint(o1)

pprint("./o1.xml", o1)


xml = readxml("./o1.xml")

o2 = outer(xml)


rm("./o1.xml")
