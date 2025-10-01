local isBusy = false

lib.callback.register('kk-robberies:checkGlobal', function(source)
    local returnable = nil

    returnable = isBusy
    while returnable == nil do Wait(50) end; return returnable
end)

lib.callback.register('kk-robberies:setBusy', function(source, value)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        local text = "TUNDMATU? BAN MAYBE? HEA ADMIN RÄÄGI KKASUTAJAGA!"

        if value then
            text = "LUBATUD"
        else
            text = "KEELATUD"
        end
            
        exports['kk-scripts']:sendLog(xPlayer.identifier, 'RÖÖVID', 'Seadis röövide sooritamise staatuseks: ' .. text .. '.')
        isBusy = value
        
        returnable = true
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

RegisterCommand('arobbery', function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer then
        isBusy = not isBusy

        if isBusy then
            exports['kk-scripts']:sendLog(xPlayer.identifier, 'A-TEAM', 'Seadis röövide sooritamise staatuseks: KEELATUD.')
            TriggerClientEvent("chatMessage", xPlayer.source, 'SÜSTEEM', 7, 'Uus röövide staatus: KEELATUD')
        else
            exports['kk-scripts']:sendLog(xPlayer.identifier, 'A-TEAM', 'Seadis röövide sooritamise staatuseks: LUBATUD.')
            TriggerClientEvent("chatMessage", xPlayer.source, 'SÜSTEEM', 7, 'Uus röövide staatus: LUBATUD')
        end
    end
end)

------------- heists
RegisterServerEvent('kk-heists:server:startParticle')
AddEventHandler('kk-heists:server:startParticle', function(position)
    TriggerClientEvent('kk-heists:client:startParticle', -1, position)
end)
