"""
Each argument constructor
"""
function arg_const(isVector::Bool, hasCheckFunction::Bool, argTypesI, argVarsI, argNamesI, argAmlTypesI, argFunsI, argSymI, argVarsCallI)

    if !isVector
        if !hasCheckFunction
            argconstI=:(addelementOne!(aml, $argNamesI, $argVarsI, $argAmlTypesI))
        else
            argconstI=quote
                if !isnothing($argVarsI) && ($(esc(argFunsI)))($argVarsI)
                    addelementOne!(aml, $argNamesI, $argVarsI, $argAmlTypesI)
                else
                    error("$($argNamesI) doesn't meet criteria function")
                end
            end
        end
    else
        if !hasCheckFunction
            argconstI=:(addelementVect!(aml, $argNamesI, $argVarsI, $argAmlTypesI))
        else
            argconstI=quote
                if !isnothing($argVarsI) && ($(esc(argFunsI)))($argVarsI)
                    addelementVect!(aml, $argNamesI, $argVarsI, $argAmlTypesI)
                else
                    error("$($argNamesI) doesn't meet criteria function")
                end
            end
        end
    end
    return argconstI
end
################################################################
"""
Each argument extractor
"""
function arg_ext(isVector::Bool, hasCheckFunction::Bool, argTypesI, argVarsI, argNamesI, argAmlTypesI, argFunsI, argSymI, argVarsCallI)

    if !isVector
        if !hasCheckFunction
            argextI=:($argVarsI = findfirstcontent($(esc(argTypesI)), $argNamesI, aml, $argAmlTypesI))
        else
            argextI=quote

                $argVarsI = findfirstcontent($(esc(argTypesI)), $argNamesI, aml, $argAmlTypesI)

                if !isnothing($argVarsI) && !(($(esc(argFunsI)))($argVarsI))
                    error("$($argNamesI) doesn't meet criteria function")
                end
            end
        end
    else
        if !hasCheckFunction
            argextI=:($argVarsI = findallcontent($(esc(argTypesI)), $argNamesI, aml, $argAmlTypesI))
        else
            argextI=quote

                $argVarsI = findallcontent($(esc(argTypesI)), $argNamesI, aml, $argAmlTypesI)

                if !isnothing($argVarsI) && !(($(esc(argFunsI)))($argVarsI))
                    error("$($argNamesI) doesn't meet criteria function")
                end
            end
        end
    end
    return argextI
end
################################################################
"""
Each argument mutability
"""
function arg_mutability(isVector::Bool, hasCheckFunction::Bool, argTypesI, argVarsI, argNamesI, argAmlTypesI, argFunsI, argSymI, argVarsCallI)

    if !isVector
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
    else
        if !hasCheckFunction
            argmutabilityI = quote
                if name == $argSymI
                    updateallcontent!(value, $argNamesI, str.aml, $argAmlTypesI)
                end
            end
        else
            argmutabilityI = quote
                if name == $argSymI
                    if !isnothing($(argVarsCallI)) && ($(esc(argFunsI)))($(argVarsCallI))
                        updateallcontent!(value, $argNamesI, str.aml, $argAmlTypesI)
                    else
                        error("$($argNamesI) doesn't meet criteria function")
                    end
                end
            end
        end
    end
    return argmutabilityI
end
