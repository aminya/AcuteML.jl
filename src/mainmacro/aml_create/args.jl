"""
Each argument constructor
"""
function arg_const(isVector::Bool, hasCheckFunction::Bool, argTypesI, argVarsI, argNamesI, argAmlTypesI, argFunsI, argSymI, argVarsCallI)

    if !isVector
        if !hasCheckFunction
            amlconstI=:(addelementOne!(aml, $argNamesI, $argVarsI, $argAmlTypesI))
        else
            amlconstI=quote
                if !isnothing($argVarsI) && ($(esc(argFunsI)))($argVarsI)
                    addelementOne!(aml, $argNamesI, $argVarsI, $argAmlTypesI)
                else
                    error("$($argNamesI) doesn't meet criteria function")
                end
            end
        end
    else
        if !hasCheckFunction
            amlconstI=:(addelementVect!(aml, $argNamesI, $argVarsI, $argAmlTypesI))
        else
            amlconstI=quote
                if !isnothing($argVarsI) && ($(esc(argFunsI)))($argVarsI)
                    addelementVect!(aml, $argNamesI, $argVarsI, $argAmlTypesI)
                else
                    error("$($argNamesI) doesn't meet criteria function")
                end
            end
        end
    end
    return amlconstI
end
################################################################
"""
Each argument extractor
"""
function arg_ext(isVector::Bool, hasCheckFunction::Bool, argTypesI, argVarsI, argNamesI, argAmlTypesI, argFunsI, argSymI, argVarsCallI)

    if !isVector
        if !hasCheckFunction
            amlextI=:($argVarsI = findfirstcontent($(esc(argTypesI)), $argNamesI, aml, $argAmlTypesI))
        else
            amlextI=quote

                $argVarsI = findfirstcontent($(esc(argTypesI)), $argNamesI, aml, $argAmlTypesI)

                if !isnothing($argVarsI) && !(($(esc(argFunsI)))($argVarsI))
                    error("$($argNamesI) doesn't meet criteria function")
                end
            end
        end
    else
        if !hasCheckFunction
            amlextI=:($argVarsI = findallcontent($(esc(argTypesI)), $argNamesI, aml, $argAmlTypesI))
        else
            amlextI=quote

                $argVarsI = findallcontent($(esc(argTypesI)), $argNamesI, aml, $argAmlTypesI)

                if !isnothing($argVarsI) && !(($(esc(argFunsI)))($argVarsI))
                    error("$($argNamesI) doesn't meet criteria function")
                end
            end
        end
    end
    return amlextI
end
################################################################
"""
Each argument mutability
"""
function arg_mutability(isVector::Bool, hasCheckFunction::Bool, argTypesI, argVarsI, argNamesI, argAmlTypesI, argFunsI, argSymI, argVarsCallI)

    if !isVector
        if !hasCheckFunction
            amlmutabilityI = quote
                if name == $argSymI
                    updatefirstcontent!(value, $argNamesI, str.aml, $argAmlTypesI)
                end
            end
        else
            amlmutabilityI = quote
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
            amlmutabilityI = quote
                if name == $argSymI
                    updateallcontent!(value, $argNamesI, str.aml, $argAmlTypesI)
                end
            end
        else
            amlmutabilityI = quote
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
    return amlmutabilityI
end
