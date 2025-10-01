RegisterNetEvent('KKF.Player.Loaded', function(src)
    local xPlayer = ESX.GetPlayerFromId(src)
end)



RegisterNetEvent('taxi:updateBlips', function(playerId, activeBlips)
    TriggerClientEvent('taxi:updateBlips', -1, activeBlips)
end)

RegisterNetEvent('taxi:removeUnit', function(playerId)
    TriggerClientEvent('taxi:removeUnit', playerId)
end)

RegisterNetEvent('taxi:removeBlips', function()
    TriggerClientEvent('taxi:removeBlips', -1)
end)
