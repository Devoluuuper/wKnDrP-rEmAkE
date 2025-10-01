local playerAccessories = {}

RegisterNetEvent('kk-police:server:saveAccessory', function(model, drawable, texture)
    local src = source
    if model and drawable and texture then
        playerAccessories[src] = {drawable, texture}
    else
        --
    end
end)

lib.callback.register('kk-police:restoreAccessory', function(source)
    local src = source
    if playerAccessories[src] then
        return playerAccessories[src]
    else
        return {0, 0}
    end
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    playerAccessories[src] = nil
end)
