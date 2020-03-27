export UN
UN{T}= Union{T, Nothing}

abstract type DocumentOrNode end

abstract type AbstractDocument <:DocumentOrNode end
abstract type AbstractNode <:DocumentOrNode end

# Documents
abstract type AbstractXML <: AbstractDocument end
abstract type AbstractHTML <: AbstractDocument end

# Nodes
abstract type AbstractElement <: AbstractNode end
abstract type AbstractAttribute <: AbstractNode end
abstract type AbstractText <: AbstractNode end

abstract type AbstractEmpty <: AbstractElement end

# Ignore
abstract type AbstractIgnore <: DocumentOrNode end
