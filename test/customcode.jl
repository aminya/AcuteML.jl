# Definition
@aml mutable struct Student "student"

    # add custom code to the begining of creator function
    # the following automatically fills IQ based on the name
    @creator begin
        if occursin("smart", name)
            name = replace(name, "-smart" => "") # remove smart from name
            IQ = "smart"
        elseif occursin("genius", name)
            name = replace(name, "-genius" => "") # remove smart from name
            IQ = "genius"
        else
            error("Give a smart student.")
        end
    end

    name::String, "~"
    GPA::Float64, "~"
    IQ::UN{String} = nothing, att"~" # default to nothing, but filled automatically by first @cretor macro

    log::UN{String} = nothing, "~"

    # add custom code to the end of extractor function
    @extractor begin
        if GPA > 4.0
            log = "A genius with a GPA of $GPA is found" # setting fields using @extractor only changes the field and not the xml code
        end
    end
end

@aml mutable struct MathClass "math-class"
    @creator begin
        GPAsum = 0.0
        for student in students
            GPAsum = GPAsum + student.GPA
        end
        average = GPAsum / length(students) # fill average field
    end

    students::Vector{Student}, "student"
    average::UN{Float64} = nothing, "average" # calculated automatically
end

################################################################
# Creation
smarts = [Student(name = "Jack-smart", GPA = 2.0), Student(name = "Sara-genius", GPA = 5.0)]
mathclass = MathClass(students = smarts)

@testset "Custom Code - Creation" begin
    @test mathclass.students[1].name == "Jack"
    @test mathclass.students[2].name == "Sara"
    @test mathclass.average == 3.5
    @test stripall(@capture_out(pprint(mathclass))) == stripall("""
    <math-class>
        <student IQ="smart">
          <name>Jack</name>
          <GPA>2.0</GPA>
        </student>
        <student IQ="genius">
          <name>Sara</name>
          <GPA>5.0</GPA>
        </student>
        <average>3.5</average>
      </math-class>
    """)
end

################################################################
# Extraction

@testset "Custom Code - Extraction" begin
    xml = parsexml("""
    <math-class>
        <student>
          <name>Jack</name>
          <GPA>2.0</GPA>
        </student>
        <student>
          <name>Sara</name>
          <GPA>5.0</GPA>
        </student>
        <average>3.5</average>
      </math-class>
    """)

    mathclass = MathClass(xml)

    @test mathclass.students[2].log == "A genius with a GPA of 5.0 is found"
end

################################################################
# io
@testset "io" begin
    pprint(mathclass)
    pprint("mathclass.xml", mathclass)
    pprint(stdout, mathclass)
    pprint(mathclass.aml)
end
