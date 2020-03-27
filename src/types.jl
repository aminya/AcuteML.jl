export DocumentOrNode, AbsDocument, AbsNode, AbsXml, AbsHtml, AbsAttribute, AbsNormal, AbsEmpty, AbsIgnore, AbsText, UN

UN{T}= Union{T, Nothing}

abstract type DocumentOrNode end

abstract type AbsDocument <:DocumentOrNode end
abstract type AbsNode <:DocumentOrNode end

# Documents
abstract type AbsXml <: AbsDocument end
abstract type AbsHtml <: AbsDocument end

# Nodes
abstract type AbsNormal <: AbsNode end
abstract type AbsAttribute <: AbsNode end
abstract type AbsText <: AbsNode end

abstract type AbsEmpty <: AbsNormal end

# Ignore
abstract type AbsIgnore <: DocumentOrNode end
