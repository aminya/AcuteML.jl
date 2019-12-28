"""
@aml parser function
"""
function amlParse(expr)

    # reminder:
    # var is a symbol
    # var::T or anything more complex is an expression

    argExpr = expr.args[3] # arguments of the type
    T = expr.args[2] # Type name +(curly braces)

    argParams = Union{Expr,Symbol}[] # Expr(:parameters)[]
    argVars = Union{Expr,Symbol}[]
    argDefVal = Any[]
    argTypes = Union{Missing,Type, Symbol, Expr}[]
    argNames = Union{Missing,String}[]
    argFun = Union{Missing, Symbol, Function}[]
    amlTypes = Int64[]
    amlName = "my type"
    docOrElmType = 0
    amlFun = Array{Union{Missing, Symbol, Function},0}(undef)

    for i in eachindex(argExpr.args) # iterating over arguments of each type argument
        ei = argExpr.args[i] # type argument element i

        ########################
        # Line number skipper
        if typeof(ei) == LineNumberNode
            continue
        end

        ########################
        # Single struct name - "aml name"
        if isa(ei, String)

            amlFun[1]=missing # function

            # Self-name checker
            if ei == "~"
                if T isa Symbol
                    amlName = string(T)
                elseif T isa Expr && T.head == :curly
                    amlName = string(T.args[1]) # S
                end
            else
                amlName = ei  # Type aml name
            end

            argExpr.args[i]= nothing # removing "aml name" from expr args
            docOrElmType = 0

        ################################################################
        # Literal Struct name - xd/hd"aml name"
        elseif isa(ei, Tuple)
            ################################################################
            # Struct aml
            ########################
            # Literal only  xd/hd"aml name"
            if isa(ei, Tuple{Int64,String})

                amlFun[1]=missing # function

                # Self-name checker
                if ei[2] == "~"
                    if T isa Symbol
                        amlName = string(T)
                    elseif T isa Expr && T.head == :curly
                        amlName = string(T.args[1]) # S
                    end
                else
                    amlName = ei[2] # Type aml name
                end

                docOrElmType = ei[1]

                argExpr.args[i]= nothing # removing "aml name" from expr args
            end

        elseif ei.head == :tuple
                ########################
                # Struct Function - "aml name", F
            if isa(ei.args[1], String) && isa(ei.args[2], Union{Symbol,Function}) # "aml name", F

                amlFun[1]=ei.args[2] # function

                # Self-name checker
                if ei.args[1] == "~"
                    if T isa Symbol
                        amlName = string(T)
                    elseif T isa Expr && T.head == :curly
                        amlName = string(T.args[1]) # S
                    end
                else
                    amlName = ei.args[1] # Type aml name
                end

                docOrElmType = 0
                argExpr.args[i]= nothing # removing "aml name" from expr args

                ########################
                # Literal and Struct Function - xd/hd"aml name", F
            elseif isa(ei.args[1], Tuple)  && isa(ei.args[2], Union{Symbol,Function})

                amlFun[1]=ei.args[2] # function

                # Self-name checker
                if ei.args[1][2] == "~"
                    if T isa Symbol
                        amlName = string(T)
                    elseif T isa Expr && T.head == :curly
                        amlName = string(T.args[1]) # S
                    end
                else
                    amlName = ei.args[1][2] # Type aml name
                end

                docOrElmType = ei.args[1][1]
                argExpr.args[i]= nothing # removing "aml name" from expr args
        ################################################################
        # Arguments
            ########################
            # No Def Value
            elseif ei.args[1] isa Union{Symbol,Expr} # var/var::T, "name"

                # Def Value
                push!(argDefVal, missing)

                # Type Checker
                lhs = ei.args[1]
                if lhs isa Symbol #  var, "name"

                    var = ei.args[1]

                    push!(argTypes, String) # consider String as the type
                    push!(argParams, var)
                    push!(argVars, var)

                    argExpr.args[i]=var  # removing "name",...

                elseif lhs isa Expr && lhs.head == :(::) && lhs.args[1] isa Symbol # var::T, "name"

                    var = lhs.args[1]
                    varType = lhs.args[2] # Type

                    push!(argTypes, varType)
                    push!(argParams, var)
                    push!(argVars, var)

                    argExpr.args[i]=lhs  # removing "name",...

                end

                # Literal Checker
                if length(ei.args[2]) == 2 # literal

                    elmType = ei.args[2][1]
                    push!(amlTypes, elmType) # literal type

                    ni = ei.args[2][2]

                    # Self-name checker
                    if ni == "~"
                        push!(argNames,string(var))
                    else
                        push!(argNames,ni)
                    end

                else
                    push!(amlTypes, 0) # non-literal

                    ni = ei.args[2]

                    # Self-name checker
                    if ni == "~"
                        push!(argNames,string(var))
                    else
                        push!(argNames,ni)
                    end
                end

                # Function Checker
                if length(ei.args) == 3 && isa(ei.args[3], Union{Function, Symbol}) #  var/var::T, "name", f

                    fun = ei.args[3]   # function
                    push!(argFun, fun)

                else # function name isn't given
                    push!(argFun, missing)
                end



            end  # end Tuple sub possibilities
        ################################################################
        # Def Value
        elseif ei.head == :(=) # def value provided

            # aml name Checker
            if ei.args[2].head == :tuple # var/var::T = defVal, "name"

                # Def Value
                defVal = ei.args[2].args[1]

                push!(argDefVal, defVal)

                lhs = ei.args[1]

                argExpr.args[i]=lhs # remove =defVal for type definition

                # Type Checker
                if lhs isa Symbol #  var = defVal, "name"

                    var = ei.args[1]

                    push!(argTypes, String) # consider String as the type
                    push!(argParams, Expr(:kw, var, defVal))
                    push!(argVars, var)

                    argExpr.args[i]=var  # removing "name",...

                elseif lhs isa Expr && lhs.head == :(::) && lhs.args[1] isa Symbol # var::T = defVal, "name"

                    var = lhs.args[1]
                    varType = lhs.args[2] # Type

                    push!(argTypes, varType)
                    push!(argParams, Expr(:kw, var, defVal)) # TODO also put type expression
                    push!(argVars, var)

                    argExpr.args[i]=lhs  # removing "name",...

                end

                # Literal Checker
                if length(ei.args[2].args[2]) == 2 # literal

                    elmType = ei.args[2].args[2][1]
                    push!(amlTypes, elmType) # literal type

                    ni = ei.args[2].args[2][2]

                    # Self-name checker
                    if ni == "~"
                        push!(argNames,string(var))
                    else
                        push!(argNames,ni)
                    end

                else
                    push!(amlTypes, 0) # non-literal

                    ni = ei.args[2].args[2]

                    # Self-name checker
                    if ni == "~"
                        push!(argNames,string(var))
                    else
                        push!(argNames,ni)
                    end

                end

                # Function Checker
                if length(ei.args[2].args) == 3 && isa(ei.args[2].args[3], Union{Function, Symbol}) #  var/var::T  = defVal, "name", f

                    fun = ei.args[2].args[3]  # function
                    push!(argFun, fun)

                else # function name isn't given
                    push!(argFun, missing)
                end

            ########################
            #  No aml Name - But defVal
            else # var/var::T = defVal # ignored for creating aml

                # Type Checker
                lhs = ei.args[1]
                if lhs isa Symbol #  var = defVal

                    defVal = ei.args[2]

                    push!(argDefVal, defVal)
                    push!(argNames,missing) # ignored for creating aml
                    push!(argFun, missing) # ignored for creating aml

                    var = ei.args[1]

                    push!(argTypes, Any)
                    push!(argParams, Expr(:kw, var, defVal))
                    push!(argVars, var)

                    argExpr.args[i]=var # remove =defVal for type definition

                elseif lhs isa Expr && lhs.head == :(::) && lhs.args[1] isa Symbol # var::T = defVal

                    defVal = ei.args[2]

                    push!(argDefVal, defVal)
                    push!(argNames,missing) # ignored for creating aml
                    push!(argFun, missing) # ignored for creating aml

                    var = lhs.args[1]
                    varType = lhs.args[2] # Type

                    push!(argTypes, varType)
                    push!(argParams, Expr(:kw, var, defVal)) # TODO also put type expression
                    push!(argVars, var)

                    argExpr.args[i]=lhs # remove =defVal for type definition

                else
                    # something else, e.g. inline inner constructor
                    #   F(...) = ...
                    continue
                end

            end

        ################################################################
        # No aml name - No defVal
        else  # var/var::T  # ignored for creating aml

            # Type Checker
            if ei isa Symbol #  var
                push!(argNames, missing) # argument ignored for aml
                push!(argFun, missing) # ignored for creating aml

                push!(argTypes, String)

                var = ei

                push!(argParams, var)
                push!(argVars, var)

            elseif ei.head == :(::) && ei.args[1] isa Symbol # var::T
                push!(argNames, missing) # argument ignored for aml
                push!(argFun, missing) # ignored for creating aml

                var = ei.args[1]
                varType = ei.args[2] # Type

                push!(argTypes, varType)
                push!(argParams, var)
                push!(argVars, var)

            elseif ei.head == :block  # anything else should be evaluated again
                # can arise with use of @static inside type decl
                argExpr, argParams, argDefVal, argTypes, argVars, argNames, argFun, amlTypes, amlName, docOrElmType, amlFun = amlParse(expr)
            else
                continue
            end



        end # end ifs
    end # endfor

    ########################
    # self closing tags checker
    if  docOrElmType == 10
        # add a field with nothing type
        push!(argNames, "content") # argument ignored for aml
        push!(argTypes, Nothing)
        push!(argFun,missing)
        push!(amlTypes,10)
        push!(argParams, Expr(:kw, :content, nothing))
        push!(argVars, :content)
        push!(argDefVal, nothing)
        push!(argExpr.args,:(content::Nothing))
        # argParams, argDefVal, argTypes, argVars, argNames, amlTypes, amlName, docOrElmType = amlParse(argExpr)
    end

    ########################
    # aml::Node adder
    push!(argExpr.args,:(aml::Union{Document,Node}))

    return argExpr, argParams, argDefVal, argTypes, argVars, argNames, argFun, amlTypes, amlName, docOrElmType, amlFun
end
