export creator, extractor, updater
macro creator(exp)
    return :creator, exp
end

macro extractor(exp)
    return :extractor, exp
end

macro updater(exp)
    return :updater, exp
end
