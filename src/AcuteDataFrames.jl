using AcuteML

################################################################
"""
    compositeWrap

A struct that is used to store the data for non-aml defined composite types (Like Tables, DataFrame, etc).
"""
mutable struct compositeWrap
    inicialized::Bool
    values::Dict{Symbol,T} where {T<:Any}
end

# Extending the struct to support compositeWrap.field value reading:
function Base.getproperty(a::compositeWrap, symbol::Symbol)
    if getfield(a, :inicialized) == true
        return getfield(a, :values)[symbol]
    else
        throw(error("not inicialized!"))
    end
end

# Extending the struct to support compositeWrap.field value assignment
function Base.setproperty!(a::compositeWrap, symbol::Symbol, value)
    if getfield(a, :inicialized) == true
        getfield(a, :values)[symbol] = value
    else
        throw(error("not inicialized!"))
    end
end
