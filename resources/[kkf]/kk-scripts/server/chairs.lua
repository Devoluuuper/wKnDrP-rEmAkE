local chairsOccupied = {}

lib.callback.register('kk-scripts:sitDown', function(source, obj)
    local returnable = false

    if not chairsOccupied[obj] then
        chairsOccupied[obj] = source
        returnable = true
    end

    return returnable
end)

RegisterServerEvent('kk-scripts:server:leaveChair', function(obj)
    if chairsOccupied[obj] == source then
        chairsOccupied[obj] = nil
    end
end)