Util = {}

function Util.safeindex(array, index)
    return ((index - 1 + #array) % #array) + 1
end
