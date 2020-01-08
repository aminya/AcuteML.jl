using AcuteML, Test
@testset "xmlutils" begin

    n = docOrElmInit("", "a")
    dhtml = docOrElmInit("", "html")
    dxml = docOrElmInit("", "xml")
    nsc = docOrElmInit("sc", "some")
    ################################################################
    addelementOne!(n, "normalString", "val", 0)
    @test "val" == findfirstcontent(String, "normalString", n, 0)
    @test "val" == findfirstcontent("normalString", n, 0)
    addelementOne!(n, "attString", "val", 2)
    @test "val" == findfirstcontent(String, "attString", n, 2)


    using Dates
    addelementOne!(n, "Date", Date(2013,7,1), 0)
    @test Date(2013,7,1) == findfirstcontent(Date, "Date", n, 0)
    addelementOne!(n, "Time", Time(12,53,40), 0)
    @test Time(12,53,40) == findfirstcontent(Time, "Time", n, 0)

    addelementOne!(n, "DateTime", DateTime(2013,5,1,12,53,40), 0)
    @test DateTime(2013,5,1,12,53,40) == findfirstcontent(DateTime, "DateTime", n, 0)

    using DataFrames
    addelementOne!(n, "DataFrame",  DataFrame(course = ["Artificial Intelligence", "Robotics"], professor = ["Prof. A", "Prof. B"] ), 0)
    @test_skip  DataFrame(course = ["Artificial Intelligence", "Robotics"], professor = ["Prof. A", "Prof. B"] ) ==  findfirstcontent(DataFrame, "DataFrame", n, 0)

    addelementOne!(n, "Nothing", nothing, 2)
    @test nothing == findfirstcontent(Nothing, "Nothing", n, 0)
    @test nothing == findfirstcontent(Union{Nothing,String}, "Nothing", n, 0)
    ################################################################
    addelementVect!(n, "stringVect", ["aa", "bb"], 0)
    @test ["aa", "bb"] == findallcontent(Vector{String}, "stringVect", n, 0)

    addelementVect!(n, "floatVect", [5.6, 7.8], 0)
    @test [5.6, 7.8] == findallcontent(Vector{Float64}, "floatVect", n, 0)

    addelementVect!(n, "intVect", [5, 6], 0)
    @test [5, 6] == findallcontent(Vector{Int64}, "intVect", n, 0)

    addelementVect!(n, "DateVect", [Date(2013,7,1), Date(2014,7,1)], 0)
    @test [Date(2013,7,1), Date(2014,7,1)] == findallcontent(Vector{Date}, "DateVect", n, 0)

    addelementVect!(n, "TimeVect", [Time(12,53,42), Time(12,53,40)], 0)
    @test [Time(12,53,42), Time(12,53,40)] == findallcontent(Vector{Time}, "TimeVect", n, 0)

    addelementVect!(n, "AnyVect", ["aa", Time(12,53,40), 2, nothing], 0)
    @test string.(["aa", Time(12,53,40), 2]) == findallcontent(typeof(["aa", Time(12,53,40), 2, nothing]), "AnyVect", n, 0)

    ################################################################
    ################################################################

    addelementOne!(dhtml, "normalString", "val", 0)
    @test "val" == findfirstcontent(String, "normalString", dhtml, 0)
    @test "val" == findfirstcontent("normalString", dhtml, 0)
    addelementOne!(dhtml, "attString", "val", 2)
    @test "val" == findfirstcontent(String, "attString", dhtml, 2)

    using Dates
    addelementOne!(dhtml, "Date", Date(2013,7,1), 0)
    @test Date(2013,7,1) == findfirstcontent(Date, "Date", dhtml, 0)
    addelementOne!(dhtml, "Time", Time(12,53,40), 0)
    @test Time(12,53,40) == findfirstcontent(Time, "Time", dhtml, 0)

    addelementOne!(dhtml, "DateTime", DateTime(2013,5,1,12,53,40), 0)
    @test DateTime(2013,5,1,12,53,40) == findfirstcontent(DateTime, "DateTime", dhtml, 0)

    using DataFrames
    addelementOne!(dhtml, "DataFrame",  DataFrame(course = ["Artificial Intelligence", "Robotics"], professor = ["Prof. A", "Prof. B"] ), 0)
    @test_skip  DataFrame(course = ["Artificial Intelligence", "Robotics"], professor = ["Prof. A", "Prof. B"] ) == findfirstcontent(DataFrame, "DataFrame", dhtml, 0)

    addelementOne!(dhtml, "Nothing", nothing, 2)
    @test nothing == findfirstcontent(Nothing, "Nothing", dhtml, 0)
    @test nothing == findfirstcontent(Union{Nothing,String}, "Nothing", dhtml, 0)
    ################################################################
    addelementVect!(dhtml, "stringVect", ["aa", "bb"], 0)
    @test ["aa", "bb"] == findallcontent(Vector{String}, "stringVect", dhtml, 0)

    addelementVect!(dhtml, "floatVect", [5.6, 7.8], 0)
    @test [5.6, 7.8] == findallcontent(Vector{Float64}, "floatVect", dhtml, 0)

    addelementVect!(dhtml, "intVect", [5, 6], 0)
    @test [5, 6] == findallcontent(Vector{Int64}, "intVect", dhtml, 0)

    addelementVect!(dhtml, "DateVect", [Date(2013,7,1), Date(2014,7,1)], 0)
    @test [Date(2013,7,1), Date(2014,7,1)] == findallcontent(Vector{Date}, "DateVect", dhtml, 0)

    addelementVect!(dhtml, "TimeVect", [Time(12,53,42), Time(12,53,40)], 0)
    @test [Time(12,53,42), Time(12,53,40)] == findallcontent(Vector{Time}, "TimeVect", dhtml, 0)

    addelementVect!(dhtml, "AnyVect", ["aa", Time(12,53,40), 2, nothing], 0)
    @test  string.(["aa", Time(12,53,40), 2]) == findallcontent(typeof(["aa", Time(12,53,40), 2, nothing]), "AnyVect", dhtml, 0)

    ################################################################
    ################################################################
    import EzXML: setroot!
    setroot!(dxml, docOrElmInit("", "node"))

    addelementOne!(dxml, "normalString", "val", 0)
    @test "val" == findfirstcontent(String, "node/normalString", dxml, 0)
    @test "val" == findfirstcontent("node/normalString", dxml, 0)
    addelementOne!(dxml, "attString", "val", 2)
    @test_skip "val" == findfirstcontent(String, "attString", root(dxml), 2)

    using Dates
    addelementOne!(dxml, "Date", Date(2013,7,1), 0)
    @test Date(2013,7,1) == findfirstcontent(Date, "node/Date", dxml, 0)
    addelementOne!(dxml, "Time", Time(12,53,40), 0)
    @test Time(12,53,40) == findfirstcontent(Time, "node/Time", dxml, 0)

    addelementOne!(dxml, "DateTime", DateTime(2013,5,1,12,53,40), 0)
    @test DateTime(2013,5,1,12,53,40) == findfirstcontent(DateTime, "node/DateTime", dxml, 0)

    using DataFrames
    addelementOne!(dxml, "DataFrame",  DataFrame(course = ["Artificial Intelligence", "Robotics"], professor = ["Prof. A", "Prof. B"] ), 0)
    @test_skip  DataFrame(course = ["Artificial Intelligence", "Robotics"], professor = ["Prof. A", "Prof. B"] ) == findfirstcontent(DataFrame, "node/DataFrame", dxml, 0)

    addelementOne!(dxml, "Nothing", nothing, 2)
    @test nothing == findfirstcontent(Nothing, "node/Nothing", dxml, 0)
    @test nothing == findfirstcontent(Union{Nothing,String}, "node/Nothing", dxml, 0)
    ################################################################
    addelementVect!(dxml, "stringVect", ["aa", "bb"], 0)
    @test ["aa", "bb"] == findallcontent(Vector{String}, "node/stringVect", dxml, 0)

    addelementVect!(dxml, "floatVect", [5.6, 7.8], 0)
    @test [5.6, 7.8] == findallcontent(Vector{Float64}, "node/floatVect", dxml, 0)

    addelementVect!(dxml, "intVect", [5, 6], 0)
    @test [5, 6] == findallcontent(Vector{Int64}, "node/intVect", dxml, 0)

    addelementVect!(dxml, "DateVect", [Date(2013,7,1), Date(2014,7,1)], 0)
    @test [Date(2013,7,1), Date(2014,7,1)] == findallcontent(Vector{Date}, "node/DateVect", dxml, 0)

    addelementVect!(dxml, "TimeVect", [Time(12,53,42), Time(12,53,40)], 0)
    @test [Time(12,53,42), Time(12,53,40)] == findallcontent(Vector{Time}, "node/TimeVect", dxml, 0)

    addelementVect!(dxml, "AnyVect", ["aa", Time(12,53,40), 2, nothing], 0)
    @test  string.(["aa", Time(12,53,40), 2]) == findallcontent(typeof(["aa", Time(12,53,40), 2, nothing]), "node/AnyVect", dxml, 0)
end
