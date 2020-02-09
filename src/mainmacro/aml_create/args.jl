"""
Parses argument type for sentence creation. Only three output are considered:
- Vector
- Dict
- Other (Any)

Only used to determine the correct xml utils sets of functions
"""
function arg_typeparse(argTypesI)
    # Vector
    if (isa(argTypesI, Expr) && argTypesI.args[1] == :Vector) ||
       (!isa(argTypesI, Union{Symbol,Expr}) && argTypesI <: AbstractVector)

       argParsedTypeI = AbstractVector

    # Dict
    elseif (isa(argTypesI, Expr) && argTypesI.args[1] == :Dict) ||
           (!isa(argTypesI, Union{Symbol,Expr}) && argTypesI <: AbstractDict)

        argParsedTypeI = AbstractDict

    # # Non Vector
    # elseif isa(argTypesI, Symbol) ||
    #        (isa(argTypesI, Expr) && argTypesI.args[1] == :Union) ||
    #        (isa(argTypesI, Expr) && argTypesI.args[1] == :UN) ||
    #        !(argTypesI <: AbstractVector)
    else
        argParsedTypeI = Any
    end

    return argParsedTypeI
end
################################################################
"""
Each argument constructor
"""
function arg_const(argParsedTypeI, hasCheckFunction::Bool, argTypesI, argVarsI, argNamesI, argAmlTypesI, argFunsI, argSymI, argVarsCallI)

    if !hasCheckFunction
        argconstI=:(addelm!(aml, $argNamesI, $argVarsI, $argAmlTypesI))
    else
        argconstI=quote
            if !isnothing($argVarsI) && ($(esc(argFunsI)))($argVarsI)
                addelm!(aml, $argNamesI, $argVarsI, $argAmlTypesI)
            else
                error("$($argNamesI) doesn't meet criteria function")
            end
        end
    end
    return argconstI
end
################################################################
"""
Each argument extractor
"""
function arg_ext(argParsedTypeI, hasCheckFunction::Bool, argTypesI, argVarsI, argNamesI, argAmlTypesI, argFunsI, argSymI, argVarsCallI)
    if !hasCheckFunction
        argextI=:($argVarsI = findcontent($(esc(argTypesI)), $argNamesI, aml, $argAmlTypesI))
    else
        argextI=quote

            $argVarsI = findcontent($(esc(argTypesI)), $argNamesI, aml, $argAmlTypesI)

            if !isnothing($argVarsI) && !(($(esc(argFunsI)))($argVarsI))
                error("$($argNamesI) doesn't meet criteria function")
            end
        end
    end
    return argextI
end
################################################################
"""
Each argument mutability
"""
function arg_mutability(argParsedTypeI, hasCheckFunction::Bool, argTypesI, argVarsI, argNamesI, argAmlTypesI, argFunsI, argSymI, argVarsCallI)
    if !hasCheckFunction
        argmutabilityI = quote
            if name == $argSymI
                updatefirstcontent!(value, $argNamesI, str.aml, $argAmlTypesI)
            end
        end
    else
        argmutabilityI = quote
            if name == $argSymI
                if !isnothing($(argVarsCallI)) && ($(esc(argFunsI)))($(argVarsCallI))
                    updatefirstcontent!(value, $argNamesI, str.aml, $argAmlTypesI)
                else
                    error("$($argNamesI) doesn't meet criteria function")
                end
            end
        end
    end
    return argmutabilityI
end
