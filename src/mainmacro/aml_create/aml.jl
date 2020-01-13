# aml functions

"""
check function for the aml struct
"""
function aml_checkFunction(amlFun, argVars)
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
    return amlFunChecker
end
################################################################
function aml_constructor(T, argParams, amlFunChecker, docOrElmconst, argconst, argVars)
    amlConstructor = quote
        function ($(esc(T)))(; $(argParams...))
            $amlFunChecker
            $docOrElmconst
            $(argconst...)
            return ($(esc(T)))($(argVars...), aml)
        end
    end
    return amlConstructor
end
function aml_constructor(SQ, P, argParams, amlFunChecker, docOrElmconst, argconst, argVars)
    amlConstructorCurly = quote
        function ($(esc(SQ)))(; $(argParams...)) where {$(esc.(P)...)}
            $amlFunChecker
            $docOrElmconst
            $(argconst...)
            return ($(esc(SQ)))($(argVars...), aml)
        end
    end
    return amlConstructorCurly
end
################################################################
function aml_extractor(T, argext, amlFunChecker, argVars)
    amlExtractor = quote
        function ($(esc(T)))(aml::Union{Document, Node})
            $(argext...)
            $amlFunChecker
            return ($(esc(T)))($(argVars...), aml)
        end
    end
    return amlExtractor
end
function aml_extractor(SQ, P, argext, amlFunChecker, argVars)
    amlExtractorCurly = quote
        function ($(esc(SQ)))(aml::Union{Document, Node}) where {$(esc.(P)...)}
            $(argext...)
            $amlFunChecker
            return ($(esc(SQ)))($(argVars...), aml)
        end
    end
    return amlExtractorCurly
end
################################################################
function aml_mutablity(mutability, T, argmutability, amlFun, argVarsCall)
    if mutability
        # amlFunCheckerMutability
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

        mutabilityExp = quote
             function Base.setproperty!(str::($(esc(T))),name::Symbol, value)
                 setfield!(str,name,value)
                 $amlFunCheckerMutability
                 $(argmutability...)
             end
         end
    else
        mutabilityExp = nothing
    end
    return mutabilityExp
end
