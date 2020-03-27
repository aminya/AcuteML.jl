using AcuteML, Test
@testset "xmlutils" begin

    nsc = initialize_node(AbsEmpty, "some")

    @testset "Node" begin
        n = initialize_node(AbstractElement, "a")
        ################################################################
        addelm!(n, "normalString", "val", AbstractElement)
        @test "val" == findcontent(String, "normalString", n, AbstractElement)
        @test ["val"] == findcontent("normalString", n, AbstractElement)

        updatecontent!("val2", "normalString", n, AbstractElement)
        @test "val2" == findcontent(String, "normalString", n, AbstractElement)

        addelm!(n, "attString", "val", AbsAttribute)
        @test "val" == findcontent(String, "attString", n, AbsAttribute)
        updatecontent!("val2", "attString", n, AbsAttribute)
        @test "val2" == findcontent(String, "attString", n, AbsAttribute)

        using Dates
        addelm!(n, "Date", Date(2013,7,1), AbstractElement)
        @test Date(2013,7,1) == findcontent(Date, "Date", n, AbstractElement)
        updatecontent!(Date(2013,7,2), "Date", n, AbstractElement)
        @test Date(2013,7,2) == findcontent(Date, "Date", n, AbstractElement)

        addelm!(n, "Time", Time(12,53,40), AbstractElement)
        @test Time(12,53,40) == findcontent(Time, "Time", n, AbstractElement)
        updatecontent!(Time(12,53,41), "Time", n, AbstractElement)
        @test Time(12,53,41) == findcontent(Time, "Time", n, AbstractElement)

        addelm!(n, "DateTime", DateTime(2013,5,1,12,53,40), AbstractElement)
        @test DateTime(2013,5,1,12,53,40) == findcontent(DateTime, "DateTime", n, AbstractElement)
        updatecontent!( DateTime(2013,5,1,12,53,41), "DateTime", n, AbstractElement)
        @test DateTime(2013,5,1,12,53,41) == findcontent(DateTime, "DateTime", n, AbstractElement)


        using DataFrames
        addelm!(n, "DataFrame",  DataFrame(course = ["Artificial Intelligence", "Robotics"], professor = ["Prof. A", "Prof. B"] ), AbstractElement)
        @test_skip  DataFrame(course = ["Artificial Intelligence", "Robotics"], professor = ["Prof. A", "Prof. B"] ) ==  findcontent(DataFrame, "DataFrame", n, AbstractElement)
        # updatecontent!( DataFrame(course = ["Artificial Intelligence", "Robotics2"], professor = ["Prof. A", "Prof. B"] ),"DataFrame", n, AbstractElement)
        # @test_skip  DataFrame(course = ["Artificial Intelligence", "Robotics2"], professor = ["Prof. A", "Prof. B"] ) ==  findcontent(DataFrame, "DataFrame", n, AbstractElement)

        addelm!(n, "Nothing", nothing, AbsAttribute)
        @test nothing == findcontent(Nothing, "Nothing", n, AbsAttribute)
        @test nothing == findcontent(Union{Nothing,String}, "Nothing", n, AbsAttribute)

        # updatecontent!(nothing, "Nothing", n, AbsAttribute)
        # @test nothing == findcontent(Nothing, "Nothing", n, AbsAttribute)

        ################################################################
        addelm!(n, "stringVect", ["aa", "bb"], AbstractElement)
        @test ["aa", "bb"] == findcontent(Vector{String}, "stringVect", n, AbstractElement)
        updatecontent!(["aa2", "bb"], "stringVect", n, AbstractElement)
        @test ["aa2", "bb"] == findcontent(Vector{String}, "stringVect", n, AbstractElement)

        addelm!(n, "floatVect", [5.6, 7.8], AbstractElement)
        @test [5.6, 7.8] == findcontent(Vector{Float64}, "floatVect", n, AbstractElement)
        updatecontent!([5.6, 7.9], "floatVect", n, AbstractElement)
        @test [5.6, 7.9] == findcontent(Vector{Float64}, "floatVect", n, AbstractElement)

        addelm!(n, "intVect", [5, 6], AbstractElement)
        @test [5, 6] == findcontent(Vector{Int64}, "intVect", n, AbstractElement)
        updatecontent!([5, 7], "intVect", n, AbstractElement)
        @test [5, 7] == findcontent(Vector{Int64}, "intVect", n, AbstractElement)

        addelm!(n, "DateVect", [Date(2013,7,1), Date(2014,7,1)], AbstractElement)
        @test [Date(2013,7,1), Date(2014,7,1)] == findcontent(Vector{Date}, "DateVect", n, AbstractElement)
        updatecontent!([Date(2013,7,2), Date(2014,7,1)], "DateVect", n, AbstractElement)
        @test [Date(2013,7,2), Date(2014,7,1)] == findcontent(Vector{Date}, "DateVect", n, AbstractElement)

        addelm!(n, "TimeVect", [Time(12,53,42), Time(12,53,40)], AbstractElement)
        @test [Time(12,53,42), Time(12,53,40)] == findcontent(Vector{Time}, "TimeVect", n, AbstractElement)
        updatecontent!([Time(12,53,43), Time(12,53,40)], "TimeVect", n, AbstractElement)
        @test [Time(12,53,43), Time(12,53,40)] == findcontent(Vector{Time}, "TimeVect", n, AbstractElement)

        addelm!(n, "AnyVect", ["aa", Time(12,53,40), 2, nothing], AbstractElement)
        @test string.(["aa", Time(12,53,40), 2]) == findcontent(typeof(["aa", Time(12,53,40), 2, nothing]), "AnyVect", n, AbstractElement)
        updatecontent!( ["aa", Time(12,53,40), 3, nothing], "AnyVect", n, AbstractElement)
        @test string.(["aa", Time(12,53,40), 3]) == findcontent(typeof(["aa", Time(12,53,40), 2, nothing]), "AnyVect", n, AbstractElement)
    end

    @testset "Html Document" begin
        dhtml = initialize_node(AbstractHTML, "html")

        addelm!(dhtml, "normalString", "val", AbstractElement)
        @test "val" == findcontent(String, "normalString", dhtml, AbstractElement)
        @test ["val"] == findcontent("normalString", dhtml, AbstractElement)

        updatecontent!("val2", "normalString", dhtml, AbstractElement)
        @test "val2" == findcontent(String, "normalString", dhtml, AbstractElement)

        addelm!(dhtml, "attString", "val", AbsAttribute)
        @test "val" == findcontent(String, "attString", dhtml, AbsAttribute)
        updatecontent!("val2", "attString", dhtml, AbsAttribute)
        @test "val2" == findcontent(String, "attString", dhtml, AbsAttribute)

        using Dates
        addelm!(dhtml, "Date", Date(2013,7,1), AbstractElement)
        @test Date(2013,7,1) == findcontent(Date, "Date", dhtml, AbstractElement)
        updatecontent!(Date(2013,7,2), "Date", dhtml, AbstractElement)
        @test Date(2013,7,2) == findcontent(Date, "Date", dhtml, AbstractElement)

        addelm!(dhtml, "Time", Time(12,53,40), AbstractElement)
        @test Time(12,53,40) == findcontent(Time, "Time", dhtml, AbstractElement)
        updatecontent!(Time(12,53,41), "Time", dhtml, AbstractElement)
        @test Time(12,53,41) == findcontent(Time, "Time", dhtml, AbstractElement)

        addelm!(dhtml, "DateTime", DateTime(2013,5,1,12,53,40), AbstractElement)
        @test DateTime(2013,5,1,12,53,40) == findcontent(DateTime, "DateTime", dhtml, AbstractElement)
        updatecontent!( DateTime(2013,5,1,12,53,41), "DateTime", dhtml, AbstractElement)
        @test DateTime(2013,5,1,12,53,41) == findcontent(DateTime, "DateTime", dhtml, AbstractElement)


        using DataFrames
        addelm!(dhtml, "DataFrame",  DataFrame(course = ["Artificial Intelligence", "Robotics"], professor = ["Prof. A", "Prof. B"] ), AbstractElement)
        @test_skip  DataFrame(course = ["Artificial Intelligence", "Robotics"], professor = ["Prof. A", "Prof. B"] ) ==  findcontent(DataFrame, "DataFrame", dhtml, AbstractElement)
        # updatecontent!( DataFrame(course = ["Artificial Intelligence", "Robotics2"], professor = ["Prof. A", "Prof. B"] ),"DataFrame", dhtml, AbstractElement)
        # @test_skip  DataFrame(course = ["Artificial Intelligence", "Robotics2"], professor = ["Prof. A", "Prof. B"] ) ==  findcontent(DataFrame, "DataFrame", dhtml, AbstractElement)

        addelm!(dhtml, "Nothing", nothing, AbsAttribute)
        @test nothing == findcontent(Nothing, "Nothing", dhtml, AbsAttribute)
        @test nothing == findcontent(Union{Nothing,String}, "Nothing", dhtml, AbsAttribute)

        # updatecontent!(nothing, "Nothing", dhtml, AbsAttribute)
        # @test nothing == findcontent(Nothing, "Nothing", dhtml, AbsAttribute)

        ################################################################
        addelm!(dhtml, "stringVect", ["aa", "bb"], AbstractElement)
        @test ["aa", "bb"] == findcontent(Vector{String}, "stringVect", dhtml, AbstractElement)
        updatecontent!(["aa2", "bb"], "stringVect", dhtml, AbstractElement)
        @test ["aa2", "bb"] == findcontent(Vector{String}, "stringVect", dhtml, AbstractElement)

        addelm!(dhtml, "floatVect", [5.6, 7.8], AbstractElement)
        @test [5.6, 7.8] == findcontent(Vector{Float64}, "floatVect", dhtml, AbstractElement)
        updatecontent!([5.6, 7.9], "floatVect", dhtml, AbstractElement)
        @test [5.6, 7.9] == findcontent(Vector{Float64}, "floatVect", dhtml, AbstractElement)

        addelm!(dhtml, "intVect", [5, 6], AbstractElement)
        @test [5, 6] == findcontent(Vector{Int64}, "intVect", dhtml, AbstractElement)
        updatecontent!([5, 7], "intVect", dhtml, AbstractElement)
        @test [5, 7] == findcontent(Vector{Int64}, "intVect", dhtml, AbstractElement)

        addelm!(dhtml, "DateVect", [Date(2013,7,1), Date(2014,7,1)], AbstractElement)
        @test [Date(2013,7,1), Date(2014,7,1)] == findcontent(Vector{Date}, "DateVect", dhtml, AbstractElement)
        updatecontent!([Date(2013,7,2), Date(2014,7,1)], "DateVect", dhtml, AbstractElement)
        @test [Date(2013,7,2), Date(2014,7,1)] == findcontent(Vector{Date}, "DateVect", dhtml, AbstractElement)

        addelm!(dhtml, "TimeVect", [Time(12,53,42), Time(12,53,40)], AbstractElement)
        @test [Time(12,53,42), Time(12,53,40)] == findcontent(Vector{Time}, "TimeVect", dhtml, AbstractElement)
        updatecontent!([Time(12,53,43), Time(12,53,40)], "TimeVect", dhtml, AbstractElement)
        @test [Time(12,53,43), Time(12,53,40)] == findcontent(Vector{Time}, "TimeVect", dhtml, AbstractElement)

        addelm!(dhtml, "AnyVect", ["aa", Time(12,53,40), 2, nothing], AbstractElement)
        @test string.(["aa", Time(12,53,40), 2]) == findcontent(typeof(["aa", Time(12,53,40), 2, nothing]), "AnyVect", dhtml, AbstractElement)
        updatecontent!( ["aa", Time(12,53,40), 3, nothing], "AnyVect", dhtml, AbstractElement)
        @test string.(["aa", Time(12,53,40), 3]) == findcontent(typeof(["aa", Time(12,53,40), 2, nothing]), "AnyVect", dhtml, AbstractElement)
    end

    @testset "XML Document" begin
        dxml = initialize_node(AbstractXML, "xml")

        import EzXML: setroot!
        setroot!(dxml, initialize_node(AbstractElement, "node"))

        addelm!(dxml, "normalString", "val", AbstractElement)
        @test "val" == findcontent(String, "normalString", dxml, AbstractElement)
        @test ["val"] == findcontent("normalString", dxml, AbstractElement)

        updatecontent!("val2", "normalString", dxml, AbstractElement)
        @test "val2" == findcontent(String, "normalString", dxml, AbstractElement)

        addelm!(dxml, "attString", "val", AbsAttribute)
        @test "val" == findcontent(String, "attString", dxml, AbsAttribute)
        updatecontent!("val2", "attString", dxml, AbsAttribute)
        @test "val2" == findcontent(String, "attString", dxml, AbsAttribute)

        using Dates
        addelm!(dxml, "Date", Date(2013,7,1), AbstractElement)
        @test Date(2013,7,1) == findcontent(Date, "Date", dxml, AbstractElement)
        updatecontent!(Date(2013,7,2), "Date", dxml, AbstractElement)
        @test Date(2013,7,2) == findcontent(Date, "Date", dxml, AbstractElement)

        addelm!(dxml, "Time", Time(12,53,40), AbstractElement)
        @test Time(12,53,40) == findcontent(Time, "Time", dxml, AbstractElement)
        updatecontent!(Time(12,53,41), "Time", dxml, AbstractElement)
        @test Time(12,53,41) == findcontent(Time, "Time", dxml, AbstractElement)

        addelm!(dxml, "DateTime", DateTime(2013,5,1,12,53,40), AbstractElement)
        @test DateTime(2013,5,1,12,53,40) == findcontent(DateTime, "DateTime", dxml, AbstractElement)
        updatecontent!( DateTime(2013,5,1,12,53,41), "DateTime", dxml, AbstractElement)
        @test DateTime(2013,5,1,12,53,41) == findcontent(DateTime, "DateTime", dxml, AbstractElement)


        using DataFrames
        addelm!(dxml, "DataFrame",  DataFrame(course = ["Artificial Intelligence", "Robotics"], professor = ["Prof. A", "Prof. B"] ), AbstractElement)
        @test_skip  DataFrame(course = ["Artificial Intelligence", "Robotics"], professor = ["Prof. A", "Prof. B"] ) ==  findcontent(DataFrame, "DataFrame", dxml, AbstractElement)
        # updatecontent!( DataFrame(course = ["Artificial Intelligence", "Robotics2"], professor = ["Prof. A", "Prof. B"] ),"DataFrame", dxml, AbstractElement)
        # @test_skip  DataFrame(course = ["Artificial Intelligence", "Robotics2"], professor = ["Prof. A", "Prof. B"] ) ==  findcontent(DataFrame, "DataFrame", dxml, AbstractElement)

        addelm!(dxml, "Nothing", nothing, AbsAttribute)
        @test nothing == findcontent(Nothing, "Nothing", dxml, AbsAttribute)
        @test nothing == findcontent(Union{Nothing,String}, "Nothing", dxml, AbsAttribute)

        # updatecontent!(nothing, "Nothing", dxml, AbsAttribute)
        # @test nothing == findcontent(Nothing, "Nothing", dxml, AbsAttribute)

        ################################################################
        addelm!(dxml, "stringVect", ["aa", "bb"], AbstractElement)
        @test ["aa", "bb"] == findcontent(Vector{String}, "stringVect", dxml, AbstractElement)
        updatecontent!(["aa2", "bb"], "stringVect", dxml, AbstractElement)
        @test ["aa2", "bb"] == findcontent(Vector{String}, "stringVect", dxml, AbstractElement)

        addelm!(dxml, "floatVect", [5.6, 7.8], AbstractElement)
        @test [5.6, 7.8] == findcontent(Vector{Float64}, "floatVect", dxml, AbstractElement)
        updatecontent!([5.6, 7.9], "floatVect", dxml, AbstractElement)
        @test [5.6, 7.9] == findcontent(Vector{Float64}, "floatVect", dxml, AbstractElement)

        addelm!(dxml, "intVect", [5, 6], AbstractElement)
        @test [5, 6] == findcontent(Vector{Int64}, "intVect", dxml, AbstractElement)
        updatecontent!([5, 7], "intVect", dxml, AbstractElement)
        @test [5, 7] == findcontent(Vector{Int64}, "intVect", dxml, AbstractElement)

        addelm!(dxml, "DateVect", [Date(2013,7,1), Date(2014,7,1)], AbstractElement)
        @test [Date(2013,7,1), Date(2014,7,1)] == findcontent(Vector{Date}, "DateVect", dxml, AbstractElement)
        updatecontent!([Date(2013,7,2), Date(2014,7,1)], "DateVect", dxml, AbstractElement)
        @test [Date(2013,7,2), Date(2014,7,1)] == findcontent(Vector{Date}, "DateVect", dxml, AbstractElement)

        addelm!(dxml, "TimeVect", [Time(12,53,42), Time(12,53,40)], AbstractElement)
        @test [Time(12,53,42), Time(12,53,40)] == findcontent(Vector{Time}, "TimeVect", dxml, AbstractElement)
        updatecontent!([Time(12,53,43), Time(12,53,40)], "TimeVect", dxml, AbstractElement)
        @test [Time(12,53,43), Time(12,53,40)] == findcontent(Vector{Time}, "TimeVect", dxml, AbstractElement)

        addelm!(dxml, "AnyVect", ["aa", Time(12,53,40), 2, nothing], AbstractElement)
        @test string.(["aa", Time(12,53,40), 2]) == findcontent(typeof(["aa", Time(12,53,40), 2, nothing]), "AnyVect", dxml, AbstractElement)
        updatecontent!( ["aa", Time(12,53,40), 3, nothing], "AnyVect", dxml, AbstractElement)
        @test string.(["aa", Time(12,53,40), 3]) == findcontent(typeof(["aa", Time(12,53,40), 2, nothing]), "AnyVect", dxml, AbstractElement)
    end


end
