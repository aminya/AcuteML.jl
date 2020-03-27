include("@aml_parse/literals.jl")
include("@aml_parse/custom_code.jl")

"""
@aml parser function
"""
function aml_parse(expr::Expr)

    expr.head == :struct || error("Invalid usage of aml_parse")

    # reminder:
    # var is a symbol
    # var::T or anything more complex is an expression

    is_struct_mutable = expr.args[1]
    T = expr.args[2] # Type name +(curly braces)

    argsexpr = expr.args[3] # arguments of the type

    # TODO: optimize and fuse these
    areargs_inds = findall(x->!(isa(x, LineNumberNode)), argsexpr.args)
    macronum = count(x-> isa(x, Tuple{Symbol, Expr}), argsexpr.args)

    data = argsexpr.args[areargs_inds]

    datanum = length(areargs_inds)
    argsnum = datanum - (1 + macronum) # 1 for struct name

    args_param = Vector{Union{Expr,Symbol}}(undef, argsnum) # Expr(:parameters)[]
    args_var = Vector{Union{Expr,Symbol}}(undef, argsnum)
    args_defaultvalue = Vector{Any}(missing, argsnum)
    args_type = Vector{Union{Type, Symbol, Expr}}(undef, argsnum)
    args_name =Vector{Union{Missing,String}}(missing, argsnum)
    args_function = Vector{Union{Missing, Symbol, Function}}(missing, argsnum)
    args_literaltype = Vector{Union{Missing, Type}}(missing, argsnum)
    args_custom_creator = Vector{Union{Nothing, Expr}}(nothing, argsnum+1) # +1 for the end
    args_custom_extractor = Vector{Union{Nothing, Expr}}(nothing, argsnum+1)
    args_custom_updater = Vector{Union{Nothing, Expr}}(nothing, argsnum+1)
    struct_name = "name"
    struct_nodetype = DocumentOrNode
    struct_function = Array{Union{Missing, Symbol, Function},0}(missing)

    iMacro = 0
    for iData = 1:datanum # iterating over arguments of each type argument

        iArg = iData - (1+ iMacro)
        i = areargs_inds[iData] # used for argsexpr.args[i]

        ei = data[iData] # type argument element i

        ########################
        # Single struct name - "aml name"
        if isa(ei, String)

            # struct_function[1]=missing # function

            # Self-name checker
            if ei == "~"
                if T isa Symbol
                    struct_name = string(T)
                elseif T isa Expr && T.head == :curly
                    struct_name = string(T.args[1]) # S
                end
            else
                struct_name = ei  # Type aml name
            end

            argsexpr.args[i] =  nothing # removing "aml name" from expr args
            struct_nodetype = AbstractElement

        ################################################################
        # Literal Struct name - empty"aml name"
        elseif isa(ei, Tuple)
            ################################################################
            # Struct aml
            ########################
            # Literal only  empty"aml name"
            if isa(ei, Tuple{Type,String})

                # struct_function[1]=missing # function

                # Self-name checker
                if ei[2] == "~"
                    if T isa Symbol
                        struct_name = string(T)
                    elseif T isa Expr && T.head == :curly
                        struct_name = string(T.args[1]) # S
                    end
                else
                    struct_name = ei[2] # Type aml name
                end

                struct_nodetype = ei[1]
                struct_nodetype = aml_dispatch(struct_nodetype, struct_name)

                argsexpr.args[i] =  nothing # removing "aml name" from expr args

            # Custom Code
            elseif isa(ei, Tuple{Symbol, Expr})
                iMacro += 1
                # Row for code insertion (insert before iArg-th argument)
                if ei[1] == :creator
                    args_custom_creator[iArg] = ei[2]
                elseif ei[1]  == :extractor
                    args_custom_extractor[iArg] = ei[2]
                elseif ei[1]  == :updater
                    args_custom_updater[iArg] = ei[2]
                end

                argsexpr.args[i] =  nothing # removing custom code macro from expr args

            end


        elseif ei.head == :tuple
            ########################
            # Struct Function - "aml name", F
            if isa(ei.args[1], String) && isa(ei.args[2], Union{Symbol,Function}) # "aml name", F

                struct_function[1]=ei.args[2] # function

                # Self-name checker
                if ei.args[1] == "~"
                    if T isa Symbol
                        struct_name = string(T)
                    elseif T isa Expr && T.head == :curly
                        struct_name = string(T.args[1]) # S
                    end
                else
                    struct_name = ei.args[1] # Type aml name
                end

                struct_nodetype = AbstractElement
                argsexpr.args[i] =  nothing # removing "aml name" from expr args

            ########################
            # Literal and Struct Function - empty"aml name", F
            elseif isa(ei.args[1], Tuple)  && isa(ei.args[2], Union{Symbol,Function})

                struct_function[1]=ei.args[2] # function

                # Self-name checker
                if ei.args[1][2] == "~"
                    if T isa Symbol
                        struct_name = string(T)
                    elseif T isa Expr && T.head == :curly
                        struct_name = string(T.args[1]) # S
                    end
                else
                    struct_name = ei.args[1][2] # Type aml name
                end

                struct_nodetype = ei.args[1][1]
                struct_nodetype = aml_dispatch(struct_nodetype, struct_name)

                argsexpr.args[i] =  nothing # removing "aml name" from expr args
        ################################################################
        # Arguments
        ########################
            # No Def Value
            elseif ei.args[1] isa Union{Symbol,Expr} # var/var::T, "name"

                # Def Value
                # args_defaultvalue[iArg] = missing

                # Type Checker
                lhs = ei.args[1]
                if lhs isa Symbol #  var, "name"

                    var = ei.args[1]

                    args_type[iArg] = String # consider String as the type
                    args_param[iArg] = var
                    args_var[iArg] = var

                    argsexpr.args[i] = var  # removing "name",...

                elseif lhs isa Expr && lhs.head == :(::) && lhs.args[1] isa Symbol # var::T, "name"

                    var = lhs.args[1]
                    varType = lhs.args[2] # Type

                    args_type[iArg] = varType
                    args_param[iArg] =  var
                    args_var[iArg] =  var

                    argsexpr.args[i] = lhs  # removing "name",...

                end

                # Literal Checker
                if length(ei.args[2]) == 2 # literal

                    argAmlType = ei.args[2][1]
                    args_literaltype[iArg] = argAmlType # literal type

                    ni = ei.args[2][2]

                    # Self-name checker
                    if ni == "~"
                        args_name[iArg] = string(var)
                    else
                        args_name[iArg] = ni
                    end

                else
                    args_literaltype[iArg] = AbstractElement # non-literal

                    ni = ei.args[2]

                    # Self-name checker
                    if ni == "~"
                        args_name[iArg] = string(var)
                    else
                        args_name[iArg] = ni
                    end
                end

                # Function Checker
                if length(ei.args) == 3 && isa(ei.args[3], Union{Function, Symbol}) #  var/var::T, "name", f

                    fun = ei.args[3]   # function
                    args_function[iArg] = fun

                # else # function name isn't given
                    # args_function[iArg] =  missing
                end


            end  # end Tuple sub possibilities
        ################################################################
        # Def Value
        elseif ei.head == :(=) # def value provided

            # aml name Checker
            if ei.args[2].head == :tuple # var/var::T = defVal, "name"

                # Def Value
                defVal = ei.args[2].args[1]

                args_defaultvalue[iArg] = defVal

                lhs = ei.args[1]

                argsexpr.args[i] = lhs # remove =defVal for type definition

                # Type Checker
                if lhs isa Symbol #  var = defVal, "name"

                    var = ei.args[1]

                    args_type[iArg] = String # consider String as the type
                    args_param[iArg] = Expr(:kw, var, defVal)
                    args_var[iArg] =  var

                    argsexpr.args[i] = var  # removing "name",...

                elseif lhs isa Expr && lhs.head == :(::) && lhs.args[1] isa Symbol # var::T = defVal, "name"

                    var = lhs.args[1]
                    varType = lhs.args[2] # Type

                    args_type[iArg] = varType
                    args_param[iArg] = Expr(:kw, var, defVal) # TODO also put type expression
                    args_var[iArg] =  var

                    argsexpr.args[i] = lhs  # removing "name",...

                end

                # Literal Checker
                if length(ei.args[2].args[2]) == 2 # literal

                    argAmlType = ei.args[2].args[2][1]
                    args_literaltype[iArg] = argAmlType # literal type

                    ni = ei.args[2].args[2][2]

                    # Self-name checker
                    if ni == "~"
                        args_name[iArg] = string(var)
                    else
                        args_name[iArg] = ni
                    end

                else
                    args_literaltype[iArg] = AbstractElement # non-literal

                    ni = ei.args[2].args[2]

                    # Self-name checker
                    if ni == "~"
                        args_name[iArg] = string(var)
                    else
                        args_name[iArg] = ni
                    end

                end

                # Function Checker
                if length(ei.args[2].args) == 3 && isa(ei.args[2].args[3], Union{Function, Symbol}) #  var/var::T  = defVal, "name", f

                    fun = ei.args[2].args[3]  # function
                    args_function[iArg] = fun

                # else # function name isn't given
                    # args_function[iArg] = missing
                end

            ########################
            #  No aml Name - But defVal
            else # var/var::T = defVal # ignored for creating aml

                # Type Checker
                lhs = ei.args[1]
                if lhs isa Symbol #  var = defVal

                    defVal = ei.args[2]

                    args_defaultvalue[iArg] = defVal
                    # args_name[iArg] = missing # ignored for creating aml
                    # args_function[iArg] =  missing # ignored for creating aml

                    var = ei.args[1]

                    args_type[iArg] = Any
                    args_param[iArg] = Expr(:kw, var, defVal)
                    args_var[iArg] =  var

                    argsexpr.args[i] = var # remove =defVal for type definition

                elseif lhs isa Expr && lhs.head == :(::) && lhs.args[1] isa Symbol # var::T = defVal

                    defVal = ei.args[2]

                    args_defaultvalue[iArg] = defVal
                    # args_name[iArg] = missing # ignored for creating aml
                    # args_function[iArg] = missing # ignored for creating aml

                    var = lhs.args[1]
                    varType = lhs.args[2] # Type

                    args_type[iArg] = varType
                    args_param[iArg] =  Expr(:kw, var, defVal) # TODO also put type expression
                    args_var[iArg] =  var

                    argsexpr.args[i] = lhs # remove =defVal for type definition

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
                # args_name[iArg] = missing # argument ignored for aml
                # args_function[iArg] =  missing # ignored for creating aml

                args_type[iArg] = String

                var = ei

                args_param[iArg] = var
                args_var[iArg] =  var

            elseif ei.head == :(::) && ei.args[1] isa Symbol # var::T
                # args_name[iArg] = missing # argument ignored for aml
                # args_function[iArg] =  missing # ignored for creating aml

                var = ei.args[1]
                varType = ei.args[2] # Type

                args_type[iArg] = varType
                args_param[iArg] = var
                args_var[iArg] = var

            elseif ei.head == :block  # anything else should be evaluated again
                # can arise with use of @static inside type decl
                argsexpr, args_param, args_defaultvalue, args_type, args_var, args_name, args_function, args_literaltype, struct_name, struct_nodetype, struct_function, is_struct_mutable, args_custom_creator, args_custom_extractor, args_custom_updater, T = aml_parse(expr)
            else
                continue
            end



        end # end ifs
    end # endfor

    ########################
    # self closing tags checker
    if  struct_nodetype == AbstractEmpty
        # add a field with nothing type
        push!(args_name, "content") # argument ignored for aml
        push!(args_type, Nothing)
        push!(args_function,missing)
        push!(args_literaltype, AbsIgnore)
        push!(args_param, Expr(:kw, :content, nothing))
        push!(args_var, :content)
        push!(args_defaultvalue, nothing)
        push!(argsexpr.args,:(content::Nothing))
        push!(args_custom_creator, nothing)
        push!(args_custom_extractor, nothing)
        push!(args_custom_updater, nothing)

        # argsexpr, args_param, args_defaultvalue, args_type, args_var, args_name, args_function, args_literaltype, struct_name, struct_nodetype, struct_function, is_struct_mutable, args_custom_creator, args_custom_extractor, args_custom_updater, T = aml_parse(expr)
    end

    ########################
    # aml::Node adder
    push!(argsexpr.args,:(aml::Union{Document,Node}))

    return argsexpr, args_param, args_defaultvalue, args_type, args_var, args_name, args_function, args_literaltype, struct_name, struct_nodetype, struct_function, is_struct_mutable, args_custom_creator, args_custom_extractor, args_custom_updater, T
end
