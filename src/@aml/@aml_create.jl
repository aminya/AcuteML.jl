include("@aml_create/get_arg_xml_.jl")
include("@aml_create/get_struct_xml_.jl")

"""
@aml creator function
"""
function aml_create(expr::Expr, args_param, args_defaultvalue, args_type, args_var, args_name, args_function, args_literaltype, struct_name, struct_nodetype, struct_function, is_struct_mutable, args_custom_creator, args_custom_extractor, args_custom_updater, T)

    expr.head == :struct || error("Invalid usage of aml_create")

    # defining outter constructors
    # Only define a constructor if the type has fields, otherwise we'll get a stack
    # overflow on construction
    if !isempty(args_var)

        ################################################################
        # Arguments methods

        # Non-aml arguments are ignored
        isaml_args = (!).(ismissing.(args_name)) # missing arg_name means not aml

        amlargs_name = args_name[isaml_args]
        amlargs_function = args_function[isaml_args]
        amlargs_var = args_var[isaml_args]
        amlargs_param = args_param[isaml_args]
        amlargs_defaultvalue = args_defaultvalue[isaml_args]
        amlargs_literaltype = args_literaltype[isaml_args]
        amlargs_type  = args_type[isaml_args]
        amlargs_custom_creator = args_custom_creator[isaml_args]
        custom_creator_end = args_custom_creator[end]
        amlargs_custom_extractor = args_custom_extractor[isaml_args]
        custom_extractor_end = args_custom_creator[end]
        amlargs_custom_updater = args_custom_updater[isaml_args]
        custom_updater_end = args_custom_creator[end]

        amlargs_num = length(amlargs_var)

        args_xmlcreator=Vector{Expr}(undef,amlargs_num)
        args_xmlextractor=Vector{Expr}(undef,amlargs_num)
        args_xmludpater=Vector{Expr}(undef,amlargs_num)

        args_varcall = Vector{Expr}(undef,amlargs_num)

        ##########################
        # Each argument of the struct
        for iArg=1:amlargs_num
            argtype = amlargs_type[iArg]
            argvar = amlargs_var[iArg]
            argname = amlargs_name[iArg]
            argliteraltype = amlargs_literaltype[iArg]
            argfunction=amlargs_function[iArg]
            argcustomcreator = amlargs_custom_creator[iArg]
            argcustomextractor = amlargs_custom_extractor[iArg]
            argcustomupdater = amlargs_custom_updater[iArg]
            argsym=QuoteNode(argvar)
            ##########################
            # call Expr - For mutability
            args_varcall[iArg] = :(str.$argvar)
            argvarcall = args_varcall[iArg]
            ##########################
            has_arg_xmlchecker = !ismissing(argfunction)

            inps = (has_arg_xmlchecker, argtype, argvar, argname, argliteraltype, argfunction, argsym, argvarcall)

            args_xmlcreator[iArg]=get_arg_xmlcreator(argcustomcreator, inps...)

            args_xmlextractor[iArg]=get_arg_xmlextractor(argcustomextractor, inps...)

            if is_struct_mutable
                args_xmludpater[iArg] = get_arg_xmludpater(argcustomupdater, inps...)
            end

        end # endfor
        ################################################################
        # Type name is a single name (symbol)
        if T isa Symbol
            S = T
            iscurly = false
        ################################################################
        # Parametric type structs
        elseif T isa Expr && T.head == :curly
            # if T == S{A<:AA,B<:BB}, define two methods
            #   S(...) = ...
            #   S{A,B}(...) where {A<:AA,B<:BB} = ...
            S = T.args[1]
            P = T.args[2:end]
            Q = [U isa Expr && U.head == :<: ? U.args[1] : U for U in P]
            SQ = :($S{$(Q...)})

            iscurly = true
        ################################################################
        else
            error("Invalid usage of @aml")
        end
        ################################################################
        node_initializer = :( aml = initialize_node($struct_nodetype, $struct_name) )

        struct_definition =:($expr)

        struct_xmlchecker = get_struct_xmlchecker(struct_function, args_var)

        # Creator
        struct_xmlcreator = get_struct_xmlcreator(S, amlargs_param, struct_xmlchecker, node_initializer, args_xmlcreator, args_var, custom_creator_end)
        # Extractor
        struct_xmlextractor = get_struct_xmlextractor(S, args_xmlextractor, struct_xmlchecker, args_var, custom_extractor_end)

        if iscurly
            # Creator
            struct_xmlcreator_curly = get_struct_xmlcreator(SQ, P, amlargs_param, struct_xmlchecker, node_initializer, args_xmlcreator, args_var, custom_creator_end)
            # Extractor
            struct_xmlextractor_curly = get_struct_xmlextractor(SQ, P, args_xmlextractor, struct_xmlchecker, args_var, custom_extractor_end)
        else
            struct_xmlcreator_curly = nothing
            struct_xmlextractor_curly = nothing
        end

        nothing_method = :( ($(esc(S)))(::Nothing) = nothing )
        # convertNothingMethod = :(Base.convert(::Type{($(esc(S)))}, ::Nothing) = nothing) # for passing nothing to function without using Union{Nothing, S} in the definition
        self_method = :( ($(esc(S)))(in::$(esc(S))) = $(esc(S))(in.aml) )
        pprint_method = :( AcuteML.pprint(in::$(esc(S))) = pprint(in.aml) )

        struct_xmlupdater = get_struct_xmlupdater(is_struct_mutable, S, args_xmludpater, struct_function, args_varcall, custom_updater_end)

        out = quote
            Base.@__doc__($(esc(struct_definition)))
            $struct_xmlcreator
            $struct_xmlcreator_curly
            $struct_xmlextractor
            $struct_xmlextractor_curly
            $nothing_method
            # $convertNothingMethod
            $self_method
            $pprint_method
            $struct_xmlupdater
        end
    else
        out = nothing
    end
    return out
end
