using AcuteML, Test
@testset "xmlutils" begin

    n = docOrElmInit(AbsNormal, "a")
    dhtml = docOrElmInit(AbsHtml, "html")
    dxml = docOrElmInit(AbsXml, "xml")
    nsc = docOrElmInit(AbsEmpty, "some")
    ################################################################
    addelm!(n, "normalString", "val", AbsNormal)
    @test "val" == findcontent(String, "normalString", n, AbsNormal)
    @test ["val"] == findcontent("normalString", n, AbsNormal)
    addelm!(n, "attString", "val", AbsAttribute)
    @test "val" == findcontent(String, "attString", n, AbsAttribute)


    using Dates
    addelm!(n, "Date", Date(2013,7,1), AbsNormal)
    @test Date(2013,7,1) == findcontent(Date, "Date", n, AbsNormal)
    addelm!(n, "Time", Time(12,53,40), AbsNormal)
    @test Time(12,53,40) == findcontent(Time, "Time", n, AbsNormal)

    addelm!(n, "DateTime", DateTime(2013,5,1,12,53,40), AbsNormal)
    @test DateTime(2013,5,1,12,53,40) == findcontent(DateTime, "DateTime", n, AbsNormal)

    using DataFrames
    addelm!(n, "DataFrame",  DataFrame(course = ["Artificial Intelligence", "Robotics"], professor = ["Prof. A", "Prof. B"] ), AbsNormal)
    @test_skip  DataFrame(course = ["Artificial Intelligence", "Robotics"], professor = ["Prof. A", "Prof. B"] ) ==  findcontent(DataFrame, "DataFrame", n, AbsNormal)

    addelm!(n, "Nothing", nothing, AbsAttribute)
    @test nothing == findcontent(Nothing, "Nothing", n, AbsNormal)
    @test nothing == findcontent(Union{Nothing,String}, "Nothing", n, AbsNormal)
    ################################################################
    addelm!(n, "stringVect", ["aa", "bb"], AbsNormal)
    @test ["aa", "bb"] == findcontent(Vector{String}, "stringVect", n, AbsNormal)

    addelm!(n, "floatVect", [5.6, 7.8], AbsNormal)
    @test [5.6, 7.8] == findcontent(Vector{Float64}, "floatVect", n, AbsNormal)

    addelm!(n, "intVect", [5, 6], AbsNormal)
    @test [5, 6] == findcontent(Vector{Int64}, "intVect", n, AbsNormal)

    addelm!(n, "DateVect", [Date(2013,7,1), Date(2014,7,1)], AbsNormal)
    @test [Date(2013,7,1), Date(2014,7,1)] == findcontent(Vector{Date}, "DateVect", n, AbsNormal)

    addelm!(n, "TimeVect", [Time(12,53,42), Time(12,53,40)], AbsNormal)
    @test [Time(12,53,42), Time(12,53,40)] == findcontent(Vector{Time}, "TimeVect", n, AbsNormal)

    addelm!(n, "AnyVect", ["aa", Time(12,53,40), 2, nothing], AbsNormal)
    @test string.(["aa", Time(12,53,40), 2]) == findcontent(typeof(["aa", Time(12,53,40), 2, nothing]), "AnyVect", n, AbsNormal)

    ################################################################
    ################################################################

    addelm!(dhtml, "normalString", "val", AbsNormal)
    @test "val" == findcontent(String, "normalString", dhtml, AbsNormal)
    @test ["val"] == findcontent("normalString", dhtml, AbsNormal)
    addelm!(dhtml, "attString", "val", AbsAttribute)
    @test "val" == findcontent(String, "attString", dhtml, AbsAttribute)

    using Dates
    addelm!(dhtml, "Date", Date(2013,7,1), AbsNormal)
    @test Date(2013,7,1) == findcontent(Date, "Date", dhtml, AbsNormal)
    addelm!(dhtml, "Time", Time(12,53,40), AbsNormal)
    @test Time(12,53,40) == findcontent(Time, "Time", dhtml, AbsNormal)

    addelm!(dhtml, "DateTime", DateTime(2013,5,1,12,53,40), AbsNormal)
    @test DateTime(2013,5,1,12,53,40) == findcontent(DateTime, "DateTime", dhtml, AbsNormal)

    using DataFrames
    addelm!(dhtml, "DataFrame",  DataFrame(course = ["Artificial Intelligence", "Robotics"], professor = ["Prof. A", "Prof. B"] ), AbsNormal)
    @test_skip  DataFrame(course = ["Artificial Intelligence", "Robotics"], professor = ["Prof. A", "Prof. B"] ) == findcontent(DataFrame, "DataFrame", dhtml, AbsNormal)

    addelm!(dhtml, "Nothing", nothing, AbsAttribute)
    @test nothing == findcontent(Nothing, "Nothing", dhtml, AbsNormal)
    @test nothing == findcontent(Union{Nothing,String}, "Nothing", dhtml, AbsNormal)
    ################################################################
    addelm!(dhtml, "stringVect", ["aa", "bb"], AbsNormal)
    @test ["aa", "bb"] == findcontent(Vector{String}, "stringVect", dhtml, AbsNormal)

    addelm!(dhtml, "floatVect", [5.6, 7.8], AbsNormal)
    @test [5.6, 7.8] == findcontent(Vector{Float64}, "floatVect", dhtml, AbsNormal)

    addelm!(dhtml, "intVect", [5, 6], AbsNormal)
    @test [5, 6] == findcontent(Vector{Int64}, "intVect", dhtml, AbsNormal)

    addelm!(dhtml, "DateVect", [Date(2013,7,1), Date(2014,7,1)], AbsNormal)
    @test [Date(2013,7,1), Date(2014,7,1)] == findcontent(Vector{Date}, "DateVect", dhtml, AbsNormal)

    addelm!(dhtml, "TimeVect", [Time(12,53,42), Time(12,53,40)], AbsNormal)
    @test [Time(12,53,42), Time(12,53,40)] == findcontent(Vector{Time}, "TimeVect", dhtml, AbsNormal)

    addelm!(dhtml, "AnyVect", ["aa", Time(12,53,40), 2, nothing], AbsNormal)
    @test  string.(["aa", Time(12,53,40), 2]) == findcontent(typeof(["aa", Time(12,53,40), 2, nothing]), "AnyVect", dhtml, AbsNormal)

    ################################################################
    ################################################################
    import EzXML: setroot!
    setroot!(dxml, docOrElmInit(AbsNormal, "node"))

    addelm!(dxml, "normalString", "val", AbsNormal)
    @test "val" == findcontent(String, "node/normalString", dxml, AbsNormal)
    @test ["val"] == findcontent("node/normalString", dxml, AbsNormal)
    addelm!(dxml, "attString", "val", AbsAttribute)
    @test "val" == findcontent(String, "attString", dxml, AbsAttribute)

    using Dates
    addelm!(dxml, "Date", Date(2013,7,1), AbsNormal)
    @test Date(2013,7,1) == findcontent(Date, "node/Date", dxml, AbsNormal)
    addelm!(dxml, "Time", Time(12,53,40), AbsNormal)
    @test Time(12,53,40) == findcontent(Time, "node/Time", dxml, AbsNormal)

    addelm!(dxml, "DateTime", DateTime(2013,5,1,12,53,40), AbsNormal)
    @test DateTime(2013,5,1,12,53,40) == findcontent(DateTime, "node/DateTime", dxml, AbsNormal)

    using DataFrames
    addelm!(dxml, "DataFrame",  DataFrame(course = ["Artificial Intelligence", "Robotics"], professor = ["Prof. A", "Prof. B"] ), AbsNormal)
    @test_skip  DataFrame(course = ["Artificial Intelligence", "Robotics"], professor = ["Prof. A", "Prof. B"] ) == findcontent(DataFrame, "node/DataFrame", dxml, AbsNormal)

    addelm!(dxml, "Nothing", nothing, AbsAttribute)
    @test nothing == findcontent(Nothing, "node/Nothing", dxml, AbsNormal)
    @test nothing == findcontent(Union{Nothing,String}, "node/Nothing", dxml, AbsNormal)
    ################################################################
    addelm!(dxml, "stringVect", ["aa", "bb"], AbsNormal)
    @test ["aa", "bb"] == findcontent(Vector{String}, "node/stringVect", dxml, AbsNormal)

    addelm!(dxml, "floatVect", [5.6, 7.8], AbsNormal)
    @test [5.6, 7.8] == findcontent(Vector{Float64}, "node/floatVect", dxml, AbsNormal)

    addelm!(dxml, "intVect", [5, 6], AbsNormal)
    @test [5, 6] == findcontent(Vector{Int64}, "node/intVect", dxml, AbsNormal)

    addelm!(dxml, "DateVect", [Date(2013,7,1), Date(2014,7,1)], AbsNormal)
    @test [Date(2013,7,1), Date(2014,7,1)] == findcontent(Vector{Date}, "node/DateVect", dxml, AbsNormal)

    addelm!(dxml, "TimeVect", [Time(12,53,42), Time(12,53,40)], AbsNormal)
    @test [Time(12,53,42), Time(12,53,40)] == findcontent(Vector{Time}, "node/TimeVect", dxml, AbsNormal)

    addelm!(dxml, "AnyVect", ["aa", Time(12,53,40), 2, nothing], AbsNormal)
    @test  string.(["aa", Time(12,53,40), 2]) == findcontent(typeof(["aa", Time(12,53,40), 2, nothing]), "node/AnyVect", dxml, AbsNormal)
end
