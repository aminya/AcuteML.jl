using AcuteML

# `~` means that the struct property name is the same as xml/html name

@aml mutable struct Body "body"
    h1, "~"
    p::Vector{String}, "~"
end

@aml mutable struct Page doc"html"
    body::Body, "~"
end

b = Body(h1 = "My heading", p = ["Paragraph1", "Paragraph2"])
d = Page(body = b)
pprint(d)
