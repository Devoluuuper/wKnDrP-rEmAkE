function weightedElement(input)
    local i
    local weights = {}

    for i = 1, #input do
        weights[i] = input[i].chance + (weights[i - 1] or 0)
    end

    local random = math.random() * weights[#weights]

    for i = 1, #weights do
        if weights[i] > random then
            return input[i]
        end
    end
end

function arrayContains(array, item)
    for k,v in pairs(array) do
        if v == item then
            return true
        end
    end

    return false
end

function randomArrElement(array)
    return array[math.random(1, #array)]
end