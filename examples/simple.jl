using AcuteML
@aml mutable struct Body "~"
    h1, "~"
    p::Vector{String}, "~"
end

@aml mutable struct Page doc"html"
    body::Body, "~"
end

b = Body(h1 = "My heading", p = ["Paragraph1", "Paragraph2"])
d = Page(body = b)
pprint(d)
