local currentUser = 0
local tokenJewels = 0
local timeout = 0

lib.callback.register('kk-robberies:breakGlass', function(source, id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if id ~= 0 then
            local currentItem = Config.Items[math.random(1, #Config.Items)]

            if xPlayer.canCarryItem(currentItem.name, currentItem.count) then
                xPlayer.addInventoryItem(currentItem.name, currentItem.count)
                TriggerClientEvent('kk-needs:client:addNeed', xPlayer.source, 'stress', math.random(1900, 2300))

                exports['kk-scripts']:sendLog(xPlayer.identifier, 'RÖÖVID', 'Sai juveelipoeröövilt eseme ' .. currentItem.name .. ' ' .. currentItem.count .. 'tk.')
                TriggerClientEvent('kk-robberies:removeGlass', -1, id)

                tokenJewels = tokenJewels + 1

                if tokenJewels == 20 then TriggerClientEvent('kk-robberies:endJewelry', -1); timeout = 45; tokenJewels = 0; currentUser = 0 end

                returnable = true
            else
                TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'success', 'Teie taskud on täis! Proovige uuesti!')
                returnable = false
            end
        else
            returnable = false
        end
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

AddEventHandler('KKF.Player.Dropped', function(playerId)
    if currentUser == playerId then
        TriggerClientEvent('kk-robberies:endJewelry', -1)
        TriggerClientEvent('kk-robberies:client:setBlip', -1, false)

        timeout = 45
        tokenJewels = 0
        currentUser = 0
    end
end)

lib.callback.register('kk-robberies:startJewelry', function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if xPlayer.job.name ~= 'police' then
            if timeout < 1 then
                TriggerClientEvent('kk-robberies:startJewelry', -1)
    
                for k,v in pairs(ESX.GetPlayers()) do
                    local xTarget = ESX.GetPlayerFromId(v)
    
                    if xTarget.job.name == 'police' and xTarget.job.onDuty then
                        TriggerClientEvent('kk-robberies:client:setBlip', xTarget.source, true, GetEntityCoords(GetPlayerPed(xPlayer.source)))
                    end
                end
                
                TriggerClientEvent('kk-robberies:jewelryStatus', -1, true)
                TriggerClientEvent('kk-dispatch:client:sendDispatch', xPlayer.source, '10-62', 'police', 'JUVEELIPOES KÄIVITUS TURVAALARM')
        
                currentUser = xPlayer.source 
                returnable = true
            else
                returnable = false
            end
        else
            returnable = false
        end
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

RegisterNetEvent('kk-robberies:endJewelry')
AddEventHandler('kk-robberies:endJewelry', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer then
        TriggerClientEvent('kk-robberies:endJewelry', -1)
        TriggerClientEvent('kk-robberies:client:setBlip', -1, false)
		TriggerClientEvent('kk-robberies:jewelryStatus', -1, false)

        timeout = 45
        tokenJewels = 0
        currentUser = 0
    end
end)

Citizen.CreateThread(function() -- do not touch this thread function!
	while true do
        if timeout > 0 then
            timeout = timeout - 1
        end

        Citizen.Wait(60000)
	end
end)