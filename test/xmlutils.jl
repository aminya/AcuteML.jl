using AcuteML, Test
@testset "xmlutils" begin

    nsc = createnode(AbsEmpty, "some")

    @testset "Node" begin
        n = createnode(AbsNormal, "a")
        ################################################################
        addnode!(n, "normalString", "val", AbsNormal)
        @test "val" == findcontent(String, "normalString", n, AbsNormal)
        @test ["val"] == findcontent("normalString", n, AbsNormal)

        updatecontent!("val2", "normalString", n, AbsNormal)
        @test "val2" == findcontent(String, "normalString", n, AbsNormal)

        addnode!(n, "attString", "val", AbsAttribute)
        @test "val" == findcontent(String, "attString", n, AbsAttribute)
        updatecontent!("val2", "attString", n, AbsAttribute)
        @test "val2" == findcontent(String, "attString", n, AbsAttribute)
        @test "val2" == get(n, "attString", nothing)
        @test nothing == get(n, "attString1", nothing)

        using Dates
        addnode!(n, "Date", Date(2013,7,1), AbsNormal)
        @test Date(2013,7,1) == findcontent(Date, "Date", n, AbsNormal)
        updatecontent!(Date(2013,7,2), "Date", n, AbsNormal)
        @test Date(2013,7,2) == findcontent(Date, "Date", n, AbsNormal)

        addnode!(n, "Time", Time(12,53,40), AbsNormal)
        @test Time(12,53,40) == findcontent(Time, "Time", n, AbsNormal)
        updatecontent!(Time(12,53,41), "Time", n, AbsNormal)
        @test Time(12,53,41) == findcontent(Time, "Time", n, AbsNormal)

        addnode!(n, "DateTime", DateTime(2013,5,1,12,53,40), AbsNormal)
        @test DateTime(2013,5,1,12,53,40) == findcontent(DateTime, "DateTime", n, AbsNormal)
        updatecontent!( DateTime(2013,5,1,12,53,41), "DateTime", n, AbsNormal)
        @test DateTime(2013,5,1,12,53,41) == findcontent(DateTime, "DateTime", n, AbsNormal)


        using DataFrames
        addnode!(n, "DataFrame",  DataFrame(course = ["Artificial Intelligence", "Robotics"], professor = ["Prof. A", "Prof. B"] ), AbsNormal)
        @test_skip  DataFrame(course = ["Artificial Intelligence", "Robotics"], professor = ["Prof. A", "Prof. B"] ) ==  findcontent(DataFrame, "DataFrame", n, AbsNormal)
        # updatecontent!( DataFrame(course = ["Artificial Intelligence", "Robotics2"], professor = ["Prof. A", "Prof. B"] ),"DataFrame", n, AbsNormal)
        # @test_skip  DataFrame(course = ["Artificial Intelligence", "Robotics2"], professor = ["Prof. A", "Prof. B"] ) ==  findcontent(DataFrame, "DataFrame", n, AbsNormal)

        addnode!(n, "Nothing", nothing, AbsAttribute)
        @test nothing == findcontent(Nothing, "Nothing", n, AbsAttribute)
        @test nothing == findcontent(Union{Nothing,String}, "Nothing", n, AbsAttribute)

        # updatecontent!(nothing, "Nothing", n, AbsAttribute)
        # @test nothing == findcontent(Nothing, "Nothing", n, AbsAttribute)

        ################################################################
        addnode!(n, "stringVect", ["aa", "bb"], AbsNormal)
        @test ["aa", "bb"] == findcontent(Vector{String}, "stringVect", n, AbsNormal)
        updatecontent!(["aa2", "bb"], "stringVect", n, AbsNormal)
        @test ["aa2", "bb"] == findcontent(Vector{String}, "stringVect", n, AbsNormal)

        addnode!(n, "floatVect", [5.6, 7.8], AbsNormal)
        @test [5.6, 7.8] == findcontent(Vector{Float64}, "floatVect", n, AbsNormal)
        updatecontent!([5.6, 7.9], "floatVect", n, AbsNormal)
        @test [5.6, 7.9] == findcontent(Vector{Float64}, "floatVect", n, AbsNormal)

        addnode!(n, "intVect", [5, 6], AbsNormal)
        @test [5, 6] == findcontent(Vector{Int64}, "intVect", n, AbsNormal)
        updatecontent!([5, 7], "intVect", n, AbsNormal)
        @test [5, 7] == findcontent(Vector{Int64}, "intVect", n, AbsNormal)

        addnode!(n, "DateVect", [Date(2013,7,1), Date(2014,7,1)], AbsNormal)
        @test [Date(2013,7,1), Date(2014,7,1)] == findcontent(Vector{Date}, "DateVect", n, AbsNormal)
        updatecontent!([Date(2013,7,2), Date(2014,7,1)], "DateVect", n, AbsNormal)
        @test [Date(2013,7,2), Date(2014,7,1)] == findcontent(Vector{Date}, "DateVect", n, AbsNormal)

        addnode!(n, "TimeVect", [Time(12,53,42), Time(12,53,40)], AbsNormal)
        @test [Time(12,53,42), Time(12,53,40)] == findcontent(Vector{Time}, "TimeVect", n, AbsNormal)
        updatecontent!([Time(12,53,43), Time(12,53,40)], "TimeVect", n, AbsNormal)
        @test [Time(12,53,43), Time(12,53,40)] == findcontent(Vector{Time}, "TimeVect", n, AbsNormal)

        addnode!(n, "AnyVect", ["aa", Time(12,53,40), 2, nothing], AbsNormal)
        @test string.(["aa", Time(12,53,40), 2]) == findcontent(typeof(["aa", Time(12,53,40), 2, nothing]), "AnyVect", n, AbsNormal)
        updatecontent!( ["aa", Time(12,53,40), 3, nothing], "AnyVect", n, AbsNormal)
        @test string.(["aa", Time(12,53,40), 3]) == findcontent(typeof(["aa", Time(12,53,40), 2, nothing]), "AnyVect", n, AbsNormal)


        addnode!(n, "Dict", Dict("class"=>"h1", "id"=>"h2"), AbsNormal)
        pprint(n)
        @test_throws MethodError findcontent(Dict("class"=>"h1", "id"=>"h2"), "Dict", n, AbsNormal)
        @test_broken updatecontent!(Dict("class"=>"h1", "id"=>"h2"), "Dict", n, AbsNormal)

        n = createnode(AbsNormal, "a")
        addnode!(n, "1", "val1", AbsText)
        @test "val1" == findcontent(String, "1", n, AbsText)
        updatecontent!("val2", "", n, AbsText)
        @test "val2" == findcontent(String, "", n, AbsText)

        n = createnode(AbsNormal, "a")
        addnode!(n, "1", 1, AbsText)
        @test 1 == findcontent(Int64, "1", n, AbsText)
        updatecontent!(2, "", n, AbsText)
        @test 2 == findcontent(Int64, "", n, AbsText)

        n = createnode(AbsNormal, "p")
        addnode!(n, "n1", "1", AbsNormal)
        addnode!(n, "n2", "2", AbsNormal)
        addnode!(n, "n3", "3", AbsNormal)
        addnode!(n, "n4", "4", AbsNormal)
        addnode!(n, "[2:3]", ["txt2", "txt3"], AbsText) # Adds text inside n1 and n2
        @test ["txt2", "txt3"] == findcontent(Vector{String}, "[2:3]", n, AbsText)
        updatecontent!(["txt2-u", "txt3-u"] , "[2:3]", n, AbsText)
        @test ["txt2-u", "txt3-u"] == findcontent(Vector{String}, "[2:3]", n, AbsText)
        # TODO will throw error if text nodes don't exist
        @test_broken updatecontent!(["txt1-uu", "txt2-uu"] , "[1:2]", n, AbsText)
        @test_broken ["txt1-uu", "txt2-uu"] == findcontent(Vector{String}, "[1:2]", n, AbsText)
        @test_broken ["txt1-uu", "txt2-uu", "txt3-u"] == findcontent(Vector{String}, "[1:2]", n, AbsText)

        n = createnode(AbsNormal, "p")
        addnode!(n, "n1", "1", AbsNormal)
        addnode!(n, "n2", "2", AbsNormal)
        addnode!(n, "n3", "3", AbsNormal)
        addnode!(n, "n4", "4", AbsNormal)
        # puts form 1 to end
        addnode!(n, "[:]", ["txt1", "txt2"], AbsText) # Adds text inside n1 and n2
        @test ["txt1", "txt2"] == findcontent(Vector{String}, "[:]", n, AbsText)
        updatecontent!(["txt1-u", "txt2"], "[:]", n, AbsText)
        @test ["txt1-u", "txt2"] == findcontent(Vector{String}, "[:]", n, AbsText)

        n = createnode(AbsNormal, "a")
        addnode!(n, "1", 1, AbsText)
        @test 1 == findcontent(Int64, "1", n, AbsText)
        updatecontent!(2, "", n, AbsText)
        @test 2 == findcontent(Int64, "", n, AbsText)


        @testset "Node link" begin
            # Linking two nodes
            n1 = createnode(AbsNormal, "n1")
            n2 = createnode(AbsNormal, "n2")
            pprint(n1)
            pprint(n2)
            addnode!(n1, "n2", n2, AbsNormal)
            pprint(n1)
            pprint(n2)

            # Linking a node and a type
            n3 = createnode(AbsNormal, "n3")
            @aml mutable struct n4 "~"
                a::UN{String} = nothing, "~"
            end
            n4i = n4(a="1")
            pprint(n3)
            pprint(n4i)
            addnode!(n3, "n2", n4i, AbsNormal)
            pprint(n3)
            pprint(n4i)

            # Linking a node and an empty type
            n5 = createnode(AbsNormal, "n5")
            @aml mutable struct n6 "~"
                a::UN{String} = nothing, "~"
            end
            n6i = n6()
            pprint(n5)
            pprint(n6i)
            addnode!(n5, "n2", n6i, AbsNormal)
            pprint(n5)
            pprint(n6i)
        end
    end



    @testset "Html Document" begin
        dhtml = createnode(AbsHtml, "html")

        addnode!(dhtml, "normalString", "val", AbsNormal)
        @test "val" == findcontent(String, "normalString", dhtml, AbsNormal)
        @test "val" == findfirst("normalString", dhtml, AbsNormal).content
        @test ["val"] == findcontent("normalString", dhtml, AbsNormal)

        updatecontent!("val2", "normalString", dhtml, AbsNormal)
        @test "val2" == findcontent(String, "normalString", dhtml, AbsNormal)

        addnode!(dhtml, "attString", "val", AbsAttribute)
        @test "val" == findcontent(String, "attString", dhtml, AbsAttribute)
        updatecontent!("val2", "attString", dhtml, AbsAttribute)
        @test "val2" == findcontent(String, "attString", dhtml, AbsAttribute)

        using Dates
        addnode!(dhtml, "Date", Date(2013,7,1), AbsNormal)
        @test Date(2013,7,1) == findcontent(Date, "Date", dhtml, AbsNormal)
        updatecontent!(Date(2013,7,2), "Date", dhtml, AbsNormal)
        @test Date(2013,7,2) == findcontent(Date, "Date", dhtml, AbsNormal)

        addnode!(dhtml, "Time", Time(12,53,40), AbsNormal)
        @test Time(12,53,40) == findcontent(Time, "Time", dhtml, AbsNormal)
        updatecontent!(Time(12,53,41), "Time", dhtml, AbsNormal)
        @test Time(12,53,41) == findcontent(Time, "Time", dhtml, AbsNormal)

        addnode!(dhtml, "DateTime", DateTime(2013,5,1,12,53,40), AbsNormal)
        @test DateTime(2013,5,1,12,53,40) == findcontent(DateTime, "DateTime", dhtml, AbsNormal)
        updatecontent!( DateTime(2013,5,1,12,53,41), "DateTime", dhtml, AbsNormal)
        @test DateTime(2013,5,1,12,53,41) == findcontent(DateTime, "DateTime", dhtml, AbsNormal)


        using DataFrames
        addnode!(dhtml, "DataFrame",  DataFrame(course = ["Artificial Intelligence", "Robotics"], professor = ["Prof. A", "Prof. B"] ), AbsNormal)
        @test_skip  DataFrame(course = ["Artificial Intelligence", "Robotics"], professor = ["Prof. A", "Prof. B"] ) ==  findcontent(DataFrame, "DataFrame", dhtml, AbsNormal)
        # updatecontent!( DataFrame(course = ["Artificial Intelligence", "Robotics2"], professor = ["Prof. A", "Prof. B"] ),"DataFrame", dhtml, AbsNormal)
        # @test_skip  DataFrame(course = ["Artificial Intelligence", "Robotics2"], professor = ["Prof. A", "Prof. B"] ) ==  findcontent(DataFrame, "DataFrame", dhtml, AbsNormal)

        addnode!(dhtml, "Nothing", nothing, AbsAttribute)
        @test nothing == findcontent(Nothing, "Nothing", dhtml, AbsAttribute)
        @test nothing == findcontent(Union{Nothing,String}, "Nothing", dhtml, AbsAttribute)

        # updatecontent!(nothing, "Nothing", dhtml, AbsAttribute)
        # @test nothing == findcontent(Nothing, "Nothing", dhtml, AbsAttribute)

        ################################################################
        addnode!(dhtml, "stringVect", ["aa", "bb"], AbsNormal)
        @test ["aa", "bb"] == findcontent(Vector{String}, "stringVect", dhtml, AbsNormal)
        updatecontent!(["aa2", "bb"], "stringVect", dhtml, AbsNormal)
        @test ["aa2", "bb"] == findcontent(Vector{String}, "stringVect", dhtml, AbsNormal)
        @test ["aa2", "bb"] == getproperty.(findall("stringVect", dhtml, AbsNormal), :content)

        addnode!(dhtml, "floatVect", [5.6, 7.8], AbsNormal)
        @test [5.6, 7.8] == findcontent(Vector{Float64}, "floatVect", dhtml, AbsNormal)
        updatecontent!([5.6, 7.9], "floatVect", dhtml, AbsNormal)
        @test [5.6, 7.9] == findcontent(Vector{Float64}, "floatVect", dhtml, AbsNormal)

        addnode!(dhtml, "intVect", [5, 6], AbsNormal)
        @test [5, 6] == findcontent(Vector{Int64}, "intVect", dhtml, AbsNormal)
        updatecontent!([5, 7], "intVect", dhtml, AbsNormal)
        @test [5, 7] == findcontent(Vector{Int64}, "intVect", dhtml, AbsNormal)

        addnode!(dhtml, "DateVect", [Date(2013,7,1), Date(2014,7,1)], AbsNormal)
        @test [Date(2013,7,1), Date(2014,7,1)] == findcontent(Vector{Date}, "DateVect", dhtml, AbsNormal)
        updatecontent!([Date(2013,7,2), Date(2014,7,1)], "DateVect", dhtml, AbsNormal)
        @test [Date(2013,7,2), Date(2014,7,1)] == findcontent(Vector{Date}, "DateVect", dhtml, AbsNormal)

        addnode!(dhtml, "TimeVect", [Time(12,53,42), Time(12,53,40)], AbsNormal)
        @test [Time(12,53,42), Time(12,53,40)] == findcontent(Vector{Time}, "TimeVect", dhtml, AbsNormal)
        updatecontent!([Time(12,53,43), Time(12,53,40)], "TimeVect", dhtml, AbsNormal)
        @test [Time(12,53,43), Time(12,53,40)] == findcontent(Vector{Time}, "TimeVect", dhtml, AbsNormal)

        addnode!(dhtml, "AnyVect", ["aa", Time(12,53,40), 2, nothing], AbsNormal)
        @test string.(["aa", Time(12,53,40), 2]) == findcontent(typeof(["aa", Time(12,53,40), 2, nothing]), "AnyVect", dhtml, AbsNormal)
        updatecontent!( ["aa", Time(12,53,40), 3, nothing], "AnyVect", dhtml, AbsNormal)
        @test string.(["aa", Time(12,53,40), 3]) == findcontent(typeof(["aa", Time(12,53,40), 2, nothing]), "AnyVect", dhtml, AbsNormal)


        @testset "HTML Document link" begin
            # Linking two nodes
            x1 = createnode(AbsHtml)
            nx1 = createnode(AbsNormal, "nx1")
            pprint(x1)
            pprint(nx1)
            addnode!(x1, "nx1", nx1, AbsNormal)
            pprint(x1)
            pprint(nx1)

            # Linking a node and a type
            x2 = createnode(AbsHtml)
            @aml mutable struct nx2 "~"
                a::UN{String} = nothing, "~"
            end
            nx2i = nx2(a="1")
            pprint(x2)
            pprint(nx2i)
            addnode!(x2, "nx2", nx2i, AbsNormal)
            pprint(x2)
            pprint(nx2i)

            # Linking a node and an empty type
            x3 = createnode(AbsHtml)
            @aml mutable struct nx3 "~"
                a::UN{String} = nothing, "~"
            end
            nx3i = nx3()
            pprint(x3)
            pprint(nx3i)
            addnode!(x3, "nx3", nx3i, AbsNormal)
            pprint(x3)
            pprint(nx3i)
        end

    end

    @testset "XML Document" begin
        dxml = createnode(AbsXml, "xml")

        import EzXML: setroot!
        setroot!(dxml, createnode(AbsNormal, "node"))

        addnode!(dxml, "normalString", "val", AbsNormal)
        @test "val" == findcontent(String, "normalString", dxml, AbsNormal)
        @test ["val"] == findcontent("normalString", dxml, AbsNormal)

        updatecontent!("val2", "normalString", dxml, AbsNormal)
        @test "val2" == findcontent(String, "normalString", dxml, AbsNormal)

        addnode!(dxml, "attString", "val", AbsAttribute)
        @test "val" == findcontent(String, "attString", dxml, AbsAttribute)
        updatecontent!("val2", "attString", dxml, AbsAttribute)
        @test "val2" == findcontent(String, "attString", dxml, AbsAttribute)

        using Dates
        addnode!(dxml, "Date", Date(2013,7,1), AbsNormal)
        @test Date(2013,7,1) == findcontent(Date, "Date", dxml, AbsNormal)
        updatecontent!(Date(2013,7,2), "Date", dxml, AbsNormal)
        @test Date(2013,7,2) == findcontent(Date, "Date", dxml, AbsNormal)

        addnode!(dxml, "Time", Time(12,53,40), AbsNormal)
        @test Time(12,53,40) == findcontent(Time, "Time", dxml, AbsNormal)
        updatecontent!(Time(12,53,41), "Time", dxml, AbsNormal)
        @test Time(12,53,41) == findcontent(Time, "Time", dxml, AbsNormal)

        addnode!(dxml, "DateTime", DateTime(2013,5,1,12,53,40), AbsNormal)
        @test DateTime(2013,5,1,12,53,40) == findcontent(DateTime, "DateTime", dxml, AbsNormal)
        updatecontent!( DateTime(2013,5,1,12,53,41), "DateTime", dxml, AbsNormal)
        @test DateTime(2013,5,1,12,53,41) == findcontent(DateTime, "DateTime", dxml, AbsNormal)


        using DataFrames
        addnode!(dxml, "DataFrame",  DataFrame(course = ["Artificial Intelligence", "Robotics"], professor = ["Prof. A", "Prof. B"] ), AbsNormal)
        @test_skip  DataFrame(course = ["Artificial Intelligence", "Robotics"], professor = ["Prof. A", "Prof. B"] ) ==  findcontent(DataFrame, "DataFrame", dxml, AbsNormal)
        # updatecontent!( DataFrame(course = ["Artificial Intelligence", "Robotics2"], professor = ["Prof. A", "Prof. B"] ),"DataFrame", dxml, AbsNormal)
        # @test_skip  DataFrame(course = ["Artificial Intelligence", "Robotics2"], professor = ["Prof. A", "Prof. B"] ) ==  findcontent(DataFrame, "DataFrame", dxml, AbsNormal)

        addnode!(dxml, "Nothing", nothing, AbsAttribute)
        @test nothing == findcontent(Nothing, "Nothing", dxml, AbsAttribute)
        @test nothing == findcontent(Union{Nothing,String}, "Nothing", dxml, AbsAttribute)

        # updatecontent!(nothing, "Nothing", dxml, AbsAttribute)
        # @test nothing == findcontent(Nothing, "Nothing", dxml, AbsAttribute)

        ################################################################
        addnode!(dxml, "stringVect", ["aa", "bb"], AbsNormal)
        @test ["aa", "bb"] == findcontent(Vector{String}, "stringVect", dxml, AbsNormal)
        updatecontent!(["aa2", "bb"], "stringVect", dxml, AbsNormal)
        @test ["aa2", "bb"] == findcontent(Vector{String}, "stringVect", dxml, AbsNormal)

        addnode!(dxml, "floatVect", [5.6, 7.8], AbsNormal)
        @test [5.6, 7.8] == findcontent(Vector{Float64}, "floatVect", dxml, AbsNormal)
        updatecontent!([5.6, 7.9], "floatVect", dxml, AbsNormal)
        @test [5.6, 7.9] == findcontent(Vector{Float64}, "floatVect", dxml, AbsNormal)

        addnode!(dxml, "intVect", [5, 6], AbsNormal)
        @test [5, 6] == findcontent(Vector{Int64}, "intVect", dxml, AbsNormal)
        updatecontent!([5, 7], "intVect", dxml, AbsNormal)
        @test [5, 7] == findcontent(Vector{Int64}, "intVect", dxml, AbsNormal)

        addnode!(dxml, "DateVect", [Date(2013,7,1), Date(2014,7,1)], AbsNormal)
        @test [Date(2013,7,1), Date(2014,7,1)] == findcontent(Vector{Date}, "DateVect", dxml, AbsNormal)
        updatecontent!([Date(2013,7,2), Date(2014,7,1)], "DateVect", dxml, AbsNormal)
        @test [Date(2013,7,2), Date(2014,7,1)] == findcontent(Vector{Date}, "DateVect", dxml, AbsNormal)

        addnode!(dxml, "TimeVect", [Time(12,53,42), Time(12,53,40)], AbsNormal)
        @test [Time(12,53,42), Time(12,53,40)] == findcontent(Vector{Time}, "TimeVect", dxml, AbsNormal)
        updatecontent!([Time(12,53,43), Time(12,53,40)], "TimeVect", dxml, AbsNormal)
        @test [Time(12,53,43), Time(12,53,40)] == findcontent(Vector{Time}, "TimeVect", dxml, AbsNormal)

        addnode!(dxml, "AnyVect", ["aa", Time(12,53,40), 2, nothing], AbsNormal)
        @test string.(["aa", Time(12,53,40), 2]) == findcontent(typeof(["aa", Time(12,53,40), 2, nothing]), "AnyVect", dxml, AbsNormal)
        updatecontent!( ["aa", Time(12,53,40), 3, nothing], "AnyVect", dxml, AbsNormal)
        @test string.(["aa", Time(12,53,40), 3]) == findcontent(typeof(["aa", Time(12,53,40), 2, nothing]), "AnyVect", dxml, AbsNormal)

        @testset "XML Document link" begin
            # Linking two nodes
            x1 = createnode(AbsXml)
            nx1 = createnode(AbsNormal, "nx1")
            pprint(x1)
            pprint(nx1)
            addnode!(x1, "nx1", nx1, AbsNormal)
            pprint(x1)
            pprint(nx1)

            # Linking a node and a type
            x2 = createnode(AbsXml)
            @aml mutable struct nx2 "~"
                a::UN{String} = nothing, "~"
            end
            nx2i = nx2(a="1")
            pprint(x2)
            pprint(nx2i)
            addnode!(x2, "nx2", nx2i, AbsNormal)
            pprint(x2)
            pprint(nx2i)

            # Linking a node and an empty type
            x3 = createnode(AbsXml)
            @aml mutable struct nx3 "~"
                a::UN{String} = nothing, "~"
            end
            nx3i = nx3()
            pprint(x3)
            pprint(nx3i)
            addnode!(x3, "nx3", nx3i, AbsNormal)
            pprint(x3)
            pprint(nx3i)
        end
    end

end
