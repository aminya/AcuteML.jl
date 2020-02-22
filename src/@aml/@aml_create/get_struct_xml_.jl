# functions that return the expressions for the whole @aml struct

"""
check function for the aml struct
"""
function get_struct_xmlchecker(struct_function, args_var)
    # aml Function
    if !ismissing(struct_function[1])
        F=struct_function[1]
        struct_xmlchecker = quote
            if !( ($(esc(F)))($(args_var...)) )
                error("struct criteria function ($($(esc(F)))) isn't meet")
            end
        end
    else
        struct_xmlchecker = nothing
    end
    return struct_xmlchecker
end
################################################################
function get_struct_xmlcreator(T, args_param, struct_xmlchecker, node_initializer, args_xmlcreator, args_var)
    struct_xmlcreator = quote
        function ($(esc(T)))(; $(args_param...))
            $struct_xmlchecker
            $node_initializer
            $(args_xmlcreator...)
            return ($(esc(T)))($(args_var...), aml)
        end
    end
    return struct_xmlcreator
end
function get_struct_xmlcreator(SQ, P, args_param, struct_xmlchecker, node_initializer, args_xmlcreator, args_var)
    struct_xmlcreator_curly = quote
        function ($(esc(SQ)))(; $(args_param...)) where {$(esc.(P)...)}
            $struct_xmlchecker
            $node_initializer
            $(args_xmlcreator...)
            return ($(esc(SQ)))($(args_var...), aml)
        end
    end
    return struct_xmlcreator_curly
end
################################################################
function get_struct_xmlextractor(T, args_xmlextractor, struct_xmlchecker, args_var)
    struct_xmlextractor = quote
        function ($(esc(T)))(aml::Union{Document, Node})
            $(args_xmlextractor...)
            $struct_xmlchecker
            return ($(esc(T)))($(args_var...), aml)
        end
    end
    return struct_xmlextractor
end
function get_struct_xmlextractor(SQ, P, args_xmlextractor, struct_xmlchecker, args_var)
    struct_xmlextractor_curly = quote
        function ($(esc(SQ)))(aml::Union{Document, Node}) where {$(esc.(P)...)}
            $(args_xmlextractor...)
            $struct_xmlchecker
            return ($(esc(SQ)))($(args_var...), aml)
        end
    end
    return struct_xmlextractor_curly
end
################################################################
function get_struct_xmlupdater(is_struct_mutable, T, args_xmludpater, struct_function, args_varcall)
    if is_struct_mutable
        # struct_xmlchecker
        if !ismissing(struct_function[1])
            F=struct_function[1]
            struct_xmlchecker = quote
                if !( ($(esc(F)))($(args_varcall...)) )
                    error("struct criteria function ($($(esc(F)))) isn't meet")
                end
            end
        else
            struct_xmlchecker = nothing
        end

        struct_xmlupdater = quote
             function Base.setproperty!(str::($(esc(T))),name::Symbol, value)
                 setfield!(str,name,value)
                 $struct_xmlchecker
                 $(args_xmludpater...)
             end
         end
    else
        struct_xmlupdater = nothing
    end
    return struct_xmlupdater
end
