
function DoesEntityExistOnServer(netId)
    return DoesEntityExist(NetworkGetEntityFromNetworkId(netId))
end

RegisterNetEvent('sync:request')
AddEventHandler('sync:request', function(resource, native, playerServerId, netId, ...)

    if not resource or not native or not playerServerId or not netId then
        return
    end


    if not DoesEntityExistOnServer(netId) then
        TriggerClientEvent('sync:execute:aborted', playerServerId, native, netId)
        return
    end
    local entity = NetworkGetEntityFromNetworkId(netId)
    local entityOwner = NetworkGetEntityOwner(entity)

    if not entityOwner then
        TriggerClientEvent('sync:execute:aborted', playerServerId, native, netId)
        return
    end

    TriggerClientEvent('sync:execute', entityOwner, native, netId, ...)
end)

RegisterNetEvent('sync:execute:aborted')
AddEventHandler('sync:execute:aborted', function(native, netId)
    local source = source 
end)