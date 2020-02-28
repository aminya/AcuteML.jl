using AcuteML
@aml mutable struct body "~"
    h1, "~"
    p::Vector{String}, "~"
end

@aml mutable struct html doc"html"
    body::body, "~"
end

b = body(h1 = "My heading", p = ["Paragraph1", "Paragraph2"])
d = html(body = b)
pprint(d)
