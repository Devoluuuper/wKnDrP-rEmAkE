local activeSnakecams = {}

RegisterNetEvent('kk-police:server:placeSnake', function()
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)

    if not xPlayer then
        return
    end
    -- if not xPlayer.job.name == 'police' then
    --     return
    -- end

    local playerId = xPlayer.identifier

    local hasItem = exports.ox_inventory:Search(src, 'count', 'snake') > 0
    if not hasItem then
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Sul ei ole vajalikku vahendit!')
        return
    end
    exports.ox_inventory:RemoveItem(src, 'snake', 1)
    TriggerClientEvent('KKF.UI.ShowNotification', src, 'success', 'Sa paigaldasid kaamera.')
    TriggerClientEvent('kk-police:client:attemptSnakecam', src)

    activeSnakecams[playerId] = true
end)

RegisterNetEvent('kk-police:server:requestRefund', function()
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)

    if not xPlayer then
        return
    end
    -- if not xPlayer.job.name == 'police' then
    --     return
    -- end

    local playerId = xPlayer.identifier

    if activeSnakecams[playerId] then
        exports.ox_inventory:AddItem(src, 'snake', 1)
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'info', 'Sa said kaamera tagasi.')
        activeSnakecams[playerId] = nil
    else
    end
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)

    if xPlayer then
        local playerId = xPlayer.identifier
        if activeSnakecams[playerId] then
            activeSnakecams[playerId] = nil
        end
    else
    end
end)
