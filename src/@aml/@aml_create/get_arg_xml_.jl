# functions that return the xml manipulation expressions for the each argument

################################################################
"""
Get a argument creator expression
"""
function get_arg_xmlcreator(argcustomcreator, has_arg_xmlchecker::Bool, argtype, argvar, argname, argliteraltype, argfunction, argsym, argvarcall)
    esc_argvar = esc(argvar)

    if !has_arg_xmlchecker
        arg_creator = quote
            $(esc(argcustomcreator))
            appendchild!(aml, $argname, $esc_argvar, $argliteraltype)
        end
    else
        arg_creator=quote
            $(esc(argcustomcreator))
            if isnothing($esc_argvar) || ($(esc(argfunction)))($esc_argvar)
                appendchild!(aml, $argname, $esc_argvar, $argliteraltype)
            else
                error("$($argname) doesn't meet criteria function")
            end
        end
    end
    return arg_creator
end
################################################################
"""
Get a argument extractor expression
"""
function get_arg_xmlextractor(argcustomextractor, has_arg_xmlchecker::Bool, argtype, argvar, argname, argliteraltype, argfunction, argsym, argvarcall)
    esc_argvar = esc(argvar)

    if !has_arg_xmlchecker
        arg_extractor=quote
            $(esc(argcustomextractor))
            $esc_argvar = findcontent($(esc(argtype)), $argname, aml, $argliteraltype)
        end
    else
        arg_extractor=quote
            $(esc(argcustomextractor))

            $esc_argvar = findcontent($(esc(argtype)), $argname, aml, $argliteraltype)

            if !isnothing($esc_argvar) && !(($(esc(argfunction)))($esc_argvar))
                error("$($argname) doesn't meet criteria function")
            end
        end
    end
    return arg_extractor
end
################################################################
"""
Get a argument updater expression
"""
function get_arg_xmludpater(argcustomupdater, has_arg_xmlchecker::Bool, argtype, argvar, argname, argliteraltype, argfunction, argsym, argvarcall)

    if !has_arg_xmlchecker
        arg_updater = quote
            $(esc(argcustomupdater))

            if name == $argsym
                updatecontent!(value, $argname, str.aml, $argliteraltype)
            end
        end
    else
        arg_updater = quote
            $(esc(argcustomupdater))

            if name == $argsym
                if isnothing($(argvarcall)) || ($(esc(argfunction)))($(argvarcall))
                    updatecontent!(value, $argname, str.aml, $argliteraltype)
                else
                    error("$($argname) doesn't meet criteria function")
                end
            end
        end
    end
    return arg_updater
end

################################################################
"""
Parses argument type for sentence creation. Only three output are considered:
- Vector
- Dict
- Other (Any)

Not used anymore, but can be used to determine the correct xml utils sets of functions
"""
function parse_argtype(argtype)
    # Vector
    if (isa(argtype, Expr) && argtype.args[1] == :Vector) ||
       (!isa(argtype, Union{Symbol,Expr}) && argtype <: AbstractVector)

       arg_parsedtype = AbstractVector

    # Dict
    elseif (isa(argtype, Expr) && argtype.args[1] == :Dict) ||
           (!isa(argtype, Union{Symbol,Expr}) && argtype <: AbstractDict)

        arg_parsedtype = AbstractDict

    # # Non Vector
    # elseif isa(argtype, Symbol) ||
    #        (isa(argtype, Expr) && argtype.args[1] == :Union) ||
    #        (isa(argtype, Expr) && argtype.args[1] == :UN) ||
    #        !(argtype <: AbstractVector)
    else
        arg_parsedtype = Any
    end

    return arg_parsedtype
end
