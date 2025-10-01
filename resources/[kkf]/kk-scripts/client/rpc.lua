lib.callback.register('KKF.RPC.IsModelReal', function(model)
    return IsModelInCdimage(model)
end)

lib.callback.register('KKF.RPC.GetVehiclesInArea', function(radius)
    local vehicles = ESX.Game.GetVehiclesInArea(GetEntityCoords(cache.ped), radius)
    local returnable = {}

    for k, entity in pairs(vehicles) do
        local attempt = 0
    
        while not NetworkHasControlOfEntity(entity) and attempt < 100 and DoesEntityExist(entity) do
            Wait(100)
            NetworkRequestControlOfEntity(entity)
            attempt = attempt + 1
        end
    
        if DoesEntityExist(entity) and NetworkHasControlOfEntity(entity) then
            returnable[#returnable + 1] = NetworkGetNetworkIdFromEntity(entity)
        end
    end

    return returnable
end)

lib.callback.register('KKF.RPC.GetPedsInArea', function(radius)
    local peds = ESX.Game.GetPedsInArea(GetEntityCoords(cache.ped), radius)
    local returnable = {}

    for k, entity in pairs(peds) do
        local attempt = 0
    
        while not NetworkHasControlOfEntity(entity) and attempt < 100 and DoesEntityExist(entity) do
            Wait(100)
            NetworkRequestControlOfEntity(entity)
            attempt = attempt + 1
        end
    
        if DoesEntityExist(entity) and NetworkHasControlOfEntity(entity) then
            returnable[#returnable + 1] = NetworkGetNetworkIdFromEntity(entity)
        end
    end

    return returnable
end)

lib.callback.register('KKF.RPC.GetObjectsInArea', function(radius)
    local objects = ESX.Game.GetObjectsInArea(GetEntityCoords(cache.ped), radius)
    local returnable = {}

    for k, entity in pairs(objects) do
        local attempt = 0
    
        while not NetworkHasControlOfEntity(entity) and attempt < 100 and DoesEntityExist(entity) do
            Wait(100)
            NetworkRequestControlOfEntity(entity)
            attempt = attempt + 1
        end
    
        if DoesEntityExist(entity) and NetworkHasControlOfEntity(entity) then
            returnable[#returnable + 1] = NetworkGetNetworkIdFromEntity(entity)
        end
    end

    return returnable
end)

lib.callback.register('KKF.RPC.DeleteObject', function(entity)
    SetEntityAsMissionEntity(entity, true, true)
    DeleteObject(entity)

    return true
end)