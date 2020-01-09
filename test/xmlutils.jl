using AcuteML, Test
@testset "xmlutils" begin

    n = docOrElmInit(AbsNormal, "a")
    dhtml = docOrElmInit(AbsHtml, "html")
    dxml = docOrElmInit(AbsXml, "xml")
    nsc = docOrElmInit(AbsEmpty, "some")
    ################################################################
    addelementOne!(n, "normalString", "val", AbsNormal)
    @test "val" == findfirstcontent(String, "normalString", n, AbsNormal)
    @test "val" == findfirstcontent("normalString", n, AbsNormal)
    addelementOne!(n, "attString", "val", AbsAttribute)
    @test "val" == findfirstcontent(String, "attString", n, AbsAttribute)


    using Dates
    addelementOne!(n, "Date", Date(2013,7,1), AbsNormal)
    @test Date(2013,7,1) == findfirstcontent(Date, "Date", n, AbsNormal)
    addelementOne!(n, "Time", Time(12,53,40), AbsNormal)
    @test Time(12,53,40) == findfirstcontent(Time, "Time", n, AbsNormal)

    addelementOne!(n, "DateTime", DateTime(2013,5,1,12,53,40), AbsNormal)
    @test DateTime(2013,5,1,12,53,40) == findfirstcontent(DateTime, "DateTime", n, AbsNormal)

    using DataFrames
    addelementOne!(n, "DataFrame",  DataFrame(course = ["Artificial Intelligence", "Robotics"], professor = ["Prof. A", "Prof. B"] ), AbsNormal)
    @test_skip  DataFrame(course = ["Artificial Intelligence", "Robotics"], professor = ["Prof. A", "Prof. B"] ) ==  findfirstcontent(DataFrame, "DataFrame", n, AbsNormal)

    addelementOne!(n, "Nothing", nothing, AbsAttribute)
    @test nothing == findfirstcontent(Nothing, "Nothing", n, AbsNormal)
    @test nothing == findfirstcontent(Union{Nothing,String}, "Nothing", n, AbsNormal)
    ################################################################
    addelementVect!(n, "stringVect", ["aa", "bb"], AbsNormal)
    @test ["aa", "bb"] == findallcontent(Vector{String}, "stringVect", n, AbsNormal)

    addelementVect!(n, "floatVect", [5.6, 7.8], AbsNormal)
    @test [5.6, 7.8] == findallcontent(Vector{Float64}, "floatVect", n, AbsNormal)

    addelementVect!(n, "intVect", [5, 6], AbsNormal)
    @test [5, 6] == findallcontent(Vector{Int64}, "intVect", n, AbsNormal)

    addelementVect!(n, "DateVect", [Date(2013,7,1), Date(2014,7,1)], AbsNormal)
    @test [Date(2013,7,1), Date(2014,7,1)] == findallcontent(Vector{Date}, "DateVect", n, AbsNormal)

    addelementVect!(n, "TimeVect", [Time(12,53,42), Time(12,53,40)], AbsNormal)
    @test [Time(12,53,42), Time(12,53,40)] == findallcontent(Vector{Time}, "TimeVect", n, AbsNormal)

    addelementVect!(n, "AnyVect", ["aa", Time(12,53,40), 2, nothing], AbsNormal)
    @test string.(["aa", Time(12,53,40), 2]) == findallcontent(typeof(["aa", Time(12,53,40), 2, nothing]), "AnyVect", n, AbsNormal)

    ################################################################
    ################################################################

    addelementOne!(dhtml, "normalString", "val", AbsNormal)
    @test "val" == findfirstcontent(String, "normalString", dhtml, AbsNormal)
    @test "val" == findfirstcontent("normalString", dhtml, AbsNormal)
    addelementOne!(dhtml, "attString", "val", AbsAttribute)
    @test "val" == findfirstcontent(String, "attString", dhtml, AbsAttribute)

    using Dates
    addelementOne!(dhtml, "Date", Date(2013,7,1), AbsNormal)
    @test Date(2013,7,1) == findfirstcontent(Date, "Date", dhtml, AbsNormal)
    addelementOne!(dhtml, "Time", Time(12,53,40), AbsNormal)
    @test Time(12,53,40) == findfirstcontent(Time, "Time", dhtml, AbsNormal)

    addelementOne!(dhtml, "DateTime", DateTime(2013,5,1,12,53,40), AbsNormal)
    @test DateTime(2013,5,1,12,53,40) == findfirstcontent(DateTime, "DateTime", dhtml, AbsNormal)

    using DataFrames
    addelementOne!(dhtml, "DataFrame",  DataFrame(course = ["Artificial Intelligence", "Robotics"], professor = ["Prof. A", "Prof. B"] ), AbsNormal)
    @test_skip  DataFrame(course = ["Artificial Intelligence", "Robotics"], professor = ["Prof. A", "Prof. B"] ) == findfirstcontent(DataFrame, "DataFrame", dhtml, AbsNormal)

    addelementOne!(dhtml, "Nothing", nothing, AbsAttribute)
    @test nothing == findfirstcontent(Nothing, "Nothing", dhtml, AbsNormal)
    @test nothing == findfirstcontent(Union{Nothing,String}, "Nothing", dhtml, AbsNormal)
    ################################################################
    addelementVect!(dhtml, "stringVect", ["aa", "bb"], AbsNormal)
    @test ["aa", "bb"] == findallcontent(Vector{String}, "stringVect", dhtml, AbsNormal)

    addelementVect!(dhtml, "floatVect", [5.6, 7.8], AbsNormal)
    @test [5.6, 7.8] == findallcontent(Vector{Float64}, "floatVect", dhtml, AbsNormal)

    addelementVect!(dhtml, "intVect", [5, 6], AbsNormal)
    @test [5, 6] == findallcontent(Vector{Int64}, "intVect", dhtml, AbsNormal)

    addelementVect!(dhtml, "DateVect", [Date(2013,7,1), Date(2014,7,1)], AbsNormal)
    @test [Date(2013,7,1), Date(2014,7,1)] == findallcontent(Vector{Date}, "DateVect", dhtml, AbsNormal)

    addelementVect!(dhtml, "TimeVect", [Time(12,53,42), Time(12,53,40)], AbsNormal)
    @test [Time(12,53,42), Time(12,53,40)] == findallcontent(Vector{Time}, "TimeVect", dhtml, AbsNormal)

    addelementVect!(dhtml, "AnyVect", ["aa", Time(12,53,40), 2, nothing], AbsNormal)
    @test  string.(["aa", Time(12,53,40), 2]) == findallcontent(typeof(["aa", Time(12,53,40), 2, nothing]), "AnyVect", dhtml, AbsNormal)

    ################################################################
    ################################################################
    import EzXML: setroot!
    setroot!(dxml, docOrElmInit(AbsNormal, "node"))

    addelementOne!(dxml, "normalString", "val", AbsNormal)
    @test "val" == findfirstcontent(String, "node/normalString", dxml, AbsNormal)
    @test "val" == findfirstcontent("node/normalString", dxml, AbsNormal)
    addelementOne!(dxml, "attString", "val", AbsAttribute)
    @test "val" == findfirstcontent(String, "attString", dxml, AbsAttribute)

    using Dates
    addelementOne!(dxml, "Date", Date(2013,7,1), AbsNormal)
    @test Date(2013,7,1) == findfirstcontent(Date, "node/Date", dxml, AbsNormal)
    addelementOne!(dxml, "Time", Time(12,53,40), AbsNormal)
    @test Time(12,53,40) == findfirstcontent(Time, "node/Time", dxml, AbsNormal)

    addelementOne!(dxml, "DateTime", DateTime(2013,5,1,12,53,40), AbsNormal)
    @test DateTime(2013,5,1,12,53,40) == findfirstcontent(DateTime, "node/DateTime", dxml, AbsNormal)

    using DataFrames
    addelementOne!(dxml, "DataFrame",  DataFrame(course = ["Artificial Intelligence", "Robotics"], professor = ["Prof. A", "Prof. B"] ), AbsNormal)
    @test_skip  DataFrame(course = ["Artificial Intelligence", "Robotics"], professor = ["Prof. A", "Prof. B"] ) == findfirstcontent(DataFrame, "node/DataFrame", dxml, AbsNormal)

    addelementOne!(dxml, "Nothing", nothing, AbsAttribute)
    @test nothing == findfirstcontent(Nothing, "node/Nothing", dxml, AbsNormal)
    @test nothing == findfirstcontent(Union{Nothing,String}, "node/Nothing", dxml, AbsNormal)
    ################################################################
    addelementVect!(dxml, "stringVect", ["aa", "bb"], AbsNormal)
    @test ["aa", "bb"] == findallcontent(Vector{String}, "node/stringVect", dxml, AbsNormal)

    addelementVect!(dxml, "floatVect", [5.6, 7.8], AbsNormal)
    @test [5.6, 7.8] == findallcontent(Vector{Float64}, "node/floatVect", dxml, AbsNormal)

    addelementVect!(dxml, "intVect", [5, 6], AbsNormal)
    @test [5, 6] == findallcontent(Vector{Int64}, "node/intVect", dxml, AbsNormal)

    addelementVect!(dxml, "DateVect", [Date(2013,7,1), Date(2014,7,1)], AbsNormal)
    @test [Date(2013,7,1), Date(2014,7,1)] == findallcontent(Vector{Date}, "node/DateVect", dxml, AbsNormal)

    addelementVect!(dxml, "TimeVect", [Time(12,53,42), Time(12,53,40)], AbsNormal)
    @test [Time(12,53,42), Time(12,53,40)] == findallcontent(Vector{Time}, "node/TimeVect", dxml, AbsNormal)

    addelementVect!(dxml, "AnyVect", ["aa", Time(12,53,40), 2, nothing], AbsNormal)
    @test  string.(["aa", Time(12,53,40), 2]) == findallcontent(typeof(["aa", Time(12,53,40), 2, nothing]), "node/AnyVect", dxml, AbsNormal)
end
