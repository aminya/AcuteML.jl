"""
@aml creator function
"""
function amlCreate(expr::Expr, argParams, argDefVal, argTypes, argVars, argNames, argFuns, argAmlTypes, amlName, docOrElmType, amlFun, mutability, T)

    expr.head == :struct || error("Invalid usage of amlCreate")

    # defining outter constructors
    # Only define a constructor if the type has fields, otherwise we'll get a stack
    # overflow on construction
    if !isempty(argVars)

        ################################################################
        # Arguments methods

        # Non-aml arguments are ignored
        idAmlArgs = (!).(ismissing.(argNames)) # missing argName means not aml

        argNamesA = argNames[idAmlArgs]
        argFunsA = argFuns[idAmlArgs]
        argVarsA = argVars[idAmlArgs]
        argParamsA = argParams[idAmlArgs]
        argDefValA = argDefVal[idAmlArgs]
        argAmlTypes = argAmlTypes[idAmlArgs]
        argTypes  = argTypes[idAmlArgs]

        numAml = length(argVarsA)

        amlconst=Vector{Expr}(undef,numAml)
        amlext=Vector{Expr}(undef,numAml)
        amlmutability=Vector{Expr}(undef,numAml)

        argVarsCall = Vector{Expr}(undef,numAml)

        ##########################
        # Each argument of the struct
        for i=1:numAml
            argTypesI = argTypes[i]
            argVarsI = argVarsA[i]
            argNamesI = argNamesA[i]
            argAmlTypesI = argAmlTypes[i]
            argFunsI=argFunsA[i]
            argSymI=QuoteNode(argVarsI)
            ##########################
            # call Expr - For mutability
            argVarsCall[i] = :(str.$argVarsI)

            # Vector
            if (isa(argTypesI, Expr) && argTypesI.args[1] == :Vector) || (!isa(argTypesI, Union{Symbol, Expr}) && argTypesI <: Array)


                # Function missing
                if ismissing(argFunsI)

                    amlconst[i]=:(addelementVect!(aml, $argNamesI, $argVarsI, $argAmlTypesI))

                    amlext[i]=:($argVarsI = findallcontent($(esc(argTypesI)), $argNamesI, aml, $argAmlTypesI))

                    if mutability
                        amlmutability[i] = quote
                            if name == $argSymI
                                updateallcontent!(value, $argNamesI, str.aml, $argAmlTypesI)
                            end
                        end
                    end

                # Function provided
                else
                    amlconst[i]=quote
                        if !isnothing($argVarsI) && ($(esc(argFunsI)))($argVarsI)
                            addelementVect!(aml, $argNamesI, $argVarsI, $argAmlTypesI)
                        else
                            error("$($argNamesI) doesn't meet criteria function")
                        end
                    end


                    amlext[i]=quote

                        $argVarsI = findallcontent($(esc(argTypesI)), $argNamesI, aml, $argAmlTypesI)

                        if !isnothing($argVarsI) && !(($(esc(argFunsI)))($argVarsI))
                            error("$($argNamesI) doesn't meet criteria function")
                        end
                    end

                    if mutability
                        amlmutability[i] = quote
                            if name == $argSymI
                                if !isnothing($(argVarsCall[i])) && ($(esc(argFunsI)))($(argVarsCall[i]))
                                    updateallcontent!(value, $argNamesI, str.aml, $argAmlTypesI)
                                else
                                    error("$($argNamesI) doesn't meet criteria function")
                                end
                            end
                        end
                    end

                end

            ##########################
            # Non Vector
            elseif isa(argTypesI, Symbol) || (isa(argTypesI, Expr) && argTypesI.args[1] == :Union ) || (isa(argTypesI, Expr) && argTypesI.args[1] == :UN) || !(argTypesI <: Array)

                # Function missing
                if ismissing(argFunsI)

                    amlconst[i]=:(addelementOne!(aml, $argNamesI, $argVarsI, $argAmlTypesI))
                    amlext[i]=:($argVarsI = findfirstcontent($(esc(argTypesI)), $argNamesI, aml, $argAmlTypesI))

                    if mutability

                        amlmutability[i] = quote
                            if name == $argSymI
                                updatefirstcontent!(value, $argNamesI, str.aml, $argAmlTypesI)
                            end
                        end
                    end

                # Function provided
                else
                    amlconst[i]=quote
                        if !isnothing($argVarsI) && ($(esc(argFunsI)))($argVarsI)
                            addelementOne!(aml, $argNamesI, $argVarsI, $argAmlTypesI)
                        else
                            error("$($argNamesI) doesn't meet criteria function")
                        end
                    end

                    amlext[i]=quote

                        $argVarsI = findfirstcontent($(esc(argTypesI)), $argNamesI, aml, $argAmlTypesI)

                        if !isnothing($argVarsI) && !(($(esc(argFunsI)))($argVarsI))
                            error("$($argNamesI) doesn't meet criteria function")
                        end
                    end
                    if mutability
                        amlmutability[i] = quote
                            if name == $argSymI
                                if !isnothing($(argVarsCall[i])) && ($(esc(argFunsI)))($(argVarsCall[i]))
                                    updatefirstcontent!(value, $argNamesI, str.aml, $argAmlTypesI)
                                else
                                    error("$($argNamesI) doesn't meet criteria function")
                                end
                            end
                        end
                    end

                end

            end

        end # endfor

        ################################################################
        # aml Function
        if !ismissing(amlFun[1])
            F=amlFun[1]
            amlFunChecker = quote
                if !( ($(esc(F)))($(argVars...)) )
                    error("struct criteria function ($($(esc(F)))) isn't meet")
                end
            end
        else
            amlFunChecker = nothing
        end

        if mutability
            if !ismissing(amlFun[1])
                F=amlFun[1]
                amlFunCheckerMutability = quote
                    if !( ($(esc(F)))($(argVarsCall...)) )
                        error("struct criteria function ($($(esc(F)))) isn't meet")
                    end
                end
            else
                amlFunCheckerMutability = nothing
            end
        end

        ################################################################
        # Type name is a single name (symbol)
        if T isa Symbol

            docOrElmconst = :( aml = docOrElmInit($docOrElmType, $amlName) )

            typeDefinition =:($expr)

            amlConstructor = quote
                function ($(esc(T)))(; $(argParams...))
                    $amlFunChecker
                    $docOrElmconst
                    $(amlconst...)
                    return ($(esc(T)))($(argVars...), aml)
                end
            end

            amlExtractor = quote
                function ($(esc(T)))(aml::Union{Document, Node})
                    $(amlext...)
                    $amlFunChecker
                    return ($(esc(T)))($(argVars...), aml)
                end

            end

            nothingMethod = :( ($(esc(T)))(::Nothing) = nothing )
            # convertNothingMethod = :(Base.convert(::Type{($(esc(T)))}, ::Nothing) = nothing) # for passing nothing to function without using Union{Nothing, T} in the definition
            selfMethod = :( ($(esc(T)))(in::$(esc(T))) = $(esc(T))(in.aml) )
            pprintMethod = :( AcuteML.pprint(in::$(esc(T))) = pprint(in.aml) )


            if mutability
                mutabilityExp = quote
                     function Base.setproperty!(str::($(esc(T))),name::Symbol, value)
                         setfield!(str,name,value)
                         $amlFunCheckerMutability
                         $(amlmutability...)
                     end
                 end
            else
                mutabilityExp = nothing
            end

            out = quote
                Base.@__doc__($(esc(typeDefinition)))
                $amlConstructor
                $amlExtractor
                $nothingMethod
                # $convertNothingMethod
                $selfMethod
                $pprintMethod
                $mutabilityExp
            end

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

            docOrElmconst = :( aml = docOrElmInit($docOrElmType, $amlName) )

            typeDefinition =:($expr)

            amlConstructor = quote
                function ($(esc(S)))(; $(argParams...))
                    $amlFunChecker
                    $docOrElmconst
                    $(amlconst...)
                    return ($(esc(S)))($(argVars...), aml)
                end
            end

            amlConstructorCurly = quote
                function ($(esc(SQ)))(; $(argParams...)) where {$(esc.(P)...)}
                    $amlFunChecker
                    $docOrElmconst
                    $(amlconst...)
                    return ($(esc(SQ)))($(argVars...), aml)
                end
            end

            amlExtractor = quote
                function ($(esc(S)))(aml::Union{Document, Node})
                    $(amlext...)
                    $amlFunChecker
                    return ($(esc(S)))($(argVars...), aml)
                end

            end

            amlExtractorCurly = quote
                function ($(esc(SQ)))(aml::Union{Document, Node}) where {$(esc.(P)...)}
                    $(amlext...)
                    $amlFunChecker
                    return ($(esc(SQ)))($(argVars...), aml)
                end

            end

            nothingMethod = :( ($(esc(S)))(::Nothing) = nothing )
            # convertNothingMethod = :(Base.convert(::Type{($(esc(S)))}, ::Nothing) = nothing) # for passing nothing to function without using Union{Nothing, ...} in the definition
            selfMethod = :( ($(esc(S)))(in::$(esc(S))) = $(esc(S))(in.aml) )
            pprintMethod = :( AcuteML.pprint(in::$(esc(T))) = pprint(in.aml) )

            if mutability
                mutabilityExp = quote
                     function Base.setproperty!(str::($(esc(T))),name::Symbol, value)
                         setfield!(str,name,value)
                         $amlFunCheckerMutability
                         $(amlmutability...)
                     end
                 end
             else
                 mutabilityExp = nothing
            end

             out = quote
                 Base.@__doc__($(esc(typeDefinition)))
                 $amlConstructor
                 $amlConstructorCurly
                 $amlExtractor
                 $amlExtractorCurly
                 $nothingMethod
                 # $convertNothingMethod
                 $selfMethod
                 $pprintMethod
                 $mutabilityExp
             end
        ################################################################
        else
            error("Invalid usage of @aml")
        end
    else
        out = nothing
    end
    return out
end
