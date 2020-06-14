@aml mutable struct MyGeneralXML{T} "my-general-xml"
    myfield::T, "~"
end
pxml_string = MyGeneralXML{String}(myfield = "a")
pprint(pxml_string)
pxml_vector = MyGeneralXML{Vector{String}}(myfield = ["b","c"])
pprint(pxml_vector)
