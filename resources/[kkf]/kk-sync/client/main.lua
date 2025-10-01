RegisterNetEvent('sync:execute', function(native, netID, ...)
    local entity = NetworkGetEntityFromNetworkId(netID)
    
    if not DoesEntityExist(entity) then
        return TriggerServerEvent('sync:execute:aborted', native, netID)
    end

    if Sync[native] then
        Sync[native](entity, ...)
    end
end)