@testset "errors" begin
    # Invalid usage of the macro
    try
        @aml function(x)
        end
    catch
    end

    # Already defined type field name
    try
        @aml mutable struct yy "~"
            n, "~"
        end

        @aml mutable struct tt "~"
            yy, "~"
        end
    catch
    end

end
