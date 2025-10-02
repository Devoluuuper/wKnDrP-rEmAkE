local sharedAnimations = {}

RegisterNetEvent('kk-emotes:server:syncPtfx', function(particles, nearbyPlayers)
    local src = source
    for _, playerId in ipairs(nearbyPlayers) do
        TriggerClientEvent('kk-emotes:client:playPtfx', playerId, src, particles)
    end
end)

RegisterNetEvent('kk-emotes:server:removePtfx', function()
    local src = source
    TriggerClientEvent('kk-emotes:client:removePtfx', -1, src)
end)

RegisterNetEvent('kk-emotes:server:sharedAnimation', function(targetId, animationData)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local targetPlayer = KKF.GetPlayerFromId(targetId)

    if targetPlayer then
        sharedAnimations[src] = { targetId = targetId, animationData = animationData }
        TriggerClientEvent('kk-emotes:client:animationAccept', targetId, src, animationData)
    else
    end
end)

RegisterNetEvent('kk-emotes:server:animationAccepted', function(accepted, sourcePlayer, animationData)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local sourceXPlayer = KKF.GetPlayerFromId(sourcePlayer)

    if accepted then
        if sharedAnimations[sourcePlayer] and sharedAnimations[sourcePlayer].targetId == src then
            TriggerClientEvent('kk-emotes:client:startShared', sourcePlayer, animationData, src, true)
            TriggerClientEvent('kk-emotes:client:startShared', src, animationData, sourcePlayer, false)
        else
        end
    else
    end
    sharedAnimations[sourcePlayer] = nil
end)

RegisterNetEvent('kk-emotes:server:saveSettings', function(settings)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    if xPlayer then
        local identifier = xPlayer.identifier
        SetResourceKvp('emote_settings_' .. identifier, json.encode(settings))
    end
end)

RegisterNetEvent('kk-emotes:server:loadSettings', function()
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    if xPlayer then
        local identifier = xPlayer.identifier
        local settings = GetResourceKvpString('emote_settings_' .. identifier)
        if settings then
            TriggerClientEvent('kk-emotes:client:syncSettings', src, json.decode(settings))
        else
            TriggerClientEvent('kk-emotes:client:syncSettings', src, {})
        end
    end
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    TriggerClientEvent('onPlayerDropped', -1, src)
    sharedAnimations[src] = nil
end)
