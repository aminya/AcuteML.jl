include("aml_create/args.jl")
include("aml_create/aml.jl")

"""
@aml creator function
"""
function aml_create(expr::Expr, argParams, argDefVal, argTypes, argVars, argNames, argFuns, argAmlTypes, amlName, docOrElmType, amlFun, mutability, T)

    expr.head == :struct || error("Invalid usage of aml_create")

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

        argconst=Vector{Expr}(undef,numAml)
        argext=Vector{Expr}(undef,numAml)
        argmutability=Vector{Expr}(undef,numAml)

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
            argVarsCallI = argVarsCall[i]
            ##########################
            hasCheckFunction = !ismissing(argFunsI)

            inputargs = (hasCheckFunction, argTypesI, argVarsI, argNamesI, argAmlTypesI, argFunsI, argSymI, argVarsCallI)

            argconst[i]=arg_const(inputargs...)

            argext[i]=arg_ext(inputargs...)

            if mutability
                argmutability[i] = arg_mutability(inputargs...)
            end

        end # endfor
        ################################################################
        # Type name is a single name (symbol)
        if T isa Symbol
            S = T
            isCurly = false
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

            isCurly = true
        ################################################################
        else
            error("Invalid usage of @aml")
        end
        ################################################################
        docOrElmconst = :( aml = docOrElmInit($docOrElmType, $amlName) )

        typeDefinition =:($expr)

        amlFunChecker = aml_checkFunction(amlFun, argVars)

        # Constructor
        amlConstructor = aml_constructor(S, argParams, amlFunChecker, docOrElmconst, argconst, argVars)
        # Extractor
        amlExtractor = aml_extractor(S, argext, amlFunChecker, argVars)

        if isCurly
            # Constructor
            amlConstructorCurly = aml_constructor(SQ, P, argParams, amlFunChecker, docOrElmconst, argconst, argVars)
            # Extractor
            amlExtractorCurly = aml_extractor(SQ, P, argext, amlFunChecker, argVars)
        else
            amlConstructorCurly = nothing
            amlExtractorCurly = nothing
        end

        nothingMethod = :( ($(esc(S)))(::Nothing) = nothing )
        # convertNothingMethod = :(Base.convert(::Type{($(esc(S)))}, ::Nothing) = nothing) # for passing nothing to function without using Union{Nothing, S} in the definition
        selfMethod = :( ($(esc(S)))(in::$(esc(S))) = $(esc(S))(in.aml) )
        pprintMethod = :( AcuteML.pprint(in::$(esc(S))) = pprint(in.aml) )

        mutabilityExp = aml_mutablity(mutability, S, argmutability, amlFun, argVarsCall)

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
    else
        out = nothing
    end
    return out
end
