export UN
UN{T}= Union{T, Nothing}

abstract type DocumentOrNode end

abstract type AbstractDocument <:DocumentOrNode end
abstract type AbstractNode <:DocumentOrNode end

# Documents
abstract type AbsXml <: AbstractDocument end
abstract type AbsHtml <: AbstractDocument end

# Nodes
abstract type AbsNormal <: AbstractNode end
abstract type AbsAttribute <: AbstractNode end
abstract type AbsText <: AbstractNode end

abstract type AbsEmpty <: AbsNormal end

# Ignore
abstract type AbsIgnore <: DocumentOrNode end
