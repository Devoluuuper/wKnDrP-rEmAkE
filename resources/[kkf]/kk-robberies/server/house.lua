local houses = {
    -- MIRROR PARK
    {pos = vec3(861.928, -509.434, 57.329), locked = true, cooldown = 0, owner = 0},
    {pos = vec3(934.413, -650.862, 58.026), locked = true, cooldown = 0, owner = 0},
    {pos = vec3(945.77142333984, -519.01977539062, 60.620483398438), locked = true, cooldown = 0, owner = 0},
    {pos = vec3(1006.125, -511.167, 60.834), locked = true, cooldown = 0, owner = 0},
    {pos = vec3(1010.396, -423.405, 65.349), locked = true, cooldown = 0, owner = 0},

    -- VAGOS KORTERMAJA
    {pos = vec3(290.683, -2047.33, 19.646), locked = true, cooldown = 0, owner = 0},
    {pos = vec3(332.437, -2070.513, 20.937), locked = true, cooldown = 0, owner = 0},
    {pos = vec3(365.105, -2064.565, 21.744), locked = true, cooldown = 0, owner = 0},
    {pos = vec3(360.769, -2042.335, 22.354), locked = true, cooldown = 0, owner = 0},
    {pos = vec3(373.59, -2002.75, 24.246), locked = true, cooldown = 0, owner = 0},

	-- BALLAS KORTERMAJA
    {pos = vec3(148.686447, -1904.44629, 23.5316658), locked = true, cooldown = 0, owner = 0},
    {pos = vec3(112.943069, -1900.46729, 23.9315186), locked = true, cooldown = 0, owner = 0},
    {pos = vec3(92.43218, -1891.03772,24.311327), locked = true, cooldown = 0, owner = 0},
    {pos = vec3(176.3898, -1857.7688, 24.3915), locked = true, cooldown = 0, owner = 0},
    {pos = vec3(208.6304, -1895.14185, 24.8141174), locked = true, cooldown = 0, owner = 0},

    -- SANDY
    {pos = vec3(1916.342, 3824.26, 32.44), locked = true, cooldown = 0, owner = 0},
    {pos = vec3(1880.705, 3810.478,32.779), locked = true, cooldown = 0, owner = 0},
    {pos = vec3(1848.617, 3786.886, 33.06), locked = true, cooldown = 0, owner = 0},
    {pos = vec3(1857.73, 3854.672, 33.101), locked = true, cooldown = 0, owner = 0},
    {pos = vec3(1834.351, 3863.44, 34.297), locked = true, cooldown = 0, owner = 0},
    {pos = vec3(1830.8, 3737.893, 33.962), locked = true, cooldown = 0, owner = 0},
    {pos = vec3(1880.438, 3920.67, 33.214), locked = true, cooldown = 0, owner = 0},
    {pos = vec3(1915.74, 3909.327, 33.442), locked = true, cooldown = 0, owner = 0},

    -- PALETO
    {pos = vec3(-379.935, 6252.722, 31.851), locked = true, cooldown = 0, owner = 0},
    {pos = vec3(-360.242, 6260.621, 31.9), locked = true, cooldown = 0, owner = 0},
    {pos = vec3(-352.65, 6231.249, 31.489), locked = true, cooldown = 0, owner = 0},
    {pos = vec3(-407.401, 6314.156, 28.941), locked = true, cooldown = 0, owner = 0},
    {pos = vec3(-302.26, 6327.016, 32.887), locked = true, cooldown = 0, owner = 0},
    {pos = vec3(-243.127, 6358.005, 31.838), locked = true, cooldown = 0, owner = 0},
    {pos = vec3(-227.271, 6377.482, 31.759), locked = true, cooldown = 0, owner = 0},
    {pos = vec3(-229.656, 6445.628, 31.197), locked = true, cooldown = 0, owner = 0},

    -- BEACH 
    {pos = vec3(-1073.8154296875, -1152.5010986328126, 2.151611328125), locked = true, cooldown = 0, owner = 0},
    {pos = vec3(-952.4439697265625, -1077.7449951171876, 2.6571044921875), locked = true, cooldown = 0, owner = 0},
    {pos = vec3(-1023.006591796875, -998.0703125, 2.134765625), locked = true, cooldown = 0, owner = 0},
    {pos = vec3(-1104.11865234375, -1059.75830078125, 2.7244873046875), locked = true, cooldown = 0, owner = 0}
}

local players = {}

lib.callback.register('kk-robberies:getHouses', function(source)
    return houses
end)

lib.callback.register('kk-robberies:startBurglary', function(source, id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if houses[id].cooldown == 0 and houses[id].locked and houses[id].owner == 0 then
            houses[id].owner = xPlayer.identifier
            returnable = true
        else
            returnable = false
        end
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

RegisterNetEvent('kk-robberies:openFailed')
AddEventHandler('kk-robberies:openFailed', function(id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer then
        houses[id].owner = 0
    end
end)

RegisterNetEvent('kk-robberies:openHouse')
AddEventHandler('kk-robberies:openHouse', function(id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer then
        if houses[id].cooldown == 0 and houses[id].locked then
            houses[id].locked = false
            TriggerClientEvent('kk-dispatch:client:sendDispatch', xPlayer.source, '10-62', 'police', 'ELUMAJA TURVAALARM')
            TriggerClientEvent('kk-robberies:reloadHouses', -1, houses)
        end
    end
end)

lib.callback.register('kk-robberies:searchBurglary', function(source, id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if id ~= 0 then
            local chance = math.random(1, 333)

            if chance ~= 33 then
                local currentItem = Config.HouseItems[math.random(1, #Config.HouseItems)]

                if xPlayer.canCarryItem(currentItem.name, currentItem.count) then
                    xPlayer.addInventoryItem(currentItem.name, currentItem.count)

                    exports['kk-scripts']:sendLog(xPlayer.identifier, 'RÖÖVID', 'Sai majaröövilt eseme ' .. currentItem.name .. ' ' .. currentItem.count .. 'tk.')
                    TriggerClientEvent('kk-robberies:tryRemoveShelf', -1, id)

                    returnable = true
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Teie taskud on täis! Proovige uuesti!')
                    returnable = false
                end
            else -- sahapi lemmik
                if xPlayer.canCarryItem('WEAPON_PISTOL', 1) then
                    xPlayer.addInventoryItem('WEAPON_PISTOL', 1)

                    exports['kk-scripts']:sendLog(xPlayer.identifier, 'RÖÖVID', 'Sai majaröövilt eseme Pistol 1tk.')
                    TriggerClientEvent('kk-robberies:tryRemoveShelf', -1, id)

                    returnable = true
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Teie taskud on täis! Proovige uuesti!')
                    returnable = false
                end
            end
        else
            returnable = false
        end
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

lib.callback.register('kk-robberies:enterHouse', function(source, id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if not houses[id].locked then
            local playerPed = GetPlayerPed(xPlayer.source)

            if DoesEntityExist(playerPed) then
                players[xPlayer.identifier] = id
                TriggerClientEvent('kk-robberies:addPlaces', xPlayer.source, id)
                SetPlayerRoutingBucket(xPlayer.source, id)
                returnable = true
            end
        end
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

RegisterNetEvent('KKF.Player.Loaded')
AddEventHandler('KKF.Player.Loaded', function(playerId, xPlayer)
    if players[xPlayer.identifier] then
        if houses[players[xPlayer.identifier]].owner == 0 then SetEntityCoords(GetPlayerPed(playerId), houses[players[xPlayer.identifier]].pos) return end
        SetPlayerRoutingBucket(playerId, players[xPlayer.identifier])
    end
end)

lib.callback.register('kk-robberies:leaveHouse', function(source, id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        local playerPed = GetPlayerPed(xPlayer.source)

        if DoesEntityExist(playerPed) then
            players[xPlayer.identifier] = nil
            SetPlayerRoutingBucket(xPlayer.source, 0)

            if houses[id].owner == xPlayer.identifier then
                for k,v in pairs(ESX.GetPlayers()) do
                    local xTarget = ESX.GetPlayerFromId(v)

                    if players[xTarget.identifier] == id then
                        SetPlayerRoutingBucket(xTarget.source, 0)
                        SetEntityCoords(GetPlayerPed(xTarget.source), houses[id].pos)
                        players[xTarget.identifier] = nil
                    end
                end

                TriggerClientEvent('kk-robberies:endBurglary', -1, id)
                houses[id].locked = true
                houses[id].owner = 0
                houses[id].cooldown = 30
                TriggerClientEvent('kk-robberies:reloadHouses', -1, houses)
            end

            TriggerClientEvent('kk-robberies:setOutOfHouse', xPlayer.source)
            returnable = houses[id].pos
        end
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

Citizen.CreateThread(function()
	while true do
        for i = 1, #houses do
            if houses[i].cooldown > 0 then
                houses[i].cooldown = houses[i].cooldown - 1
            end
        end

        Citizen.Wait(60000)
	end
end)

AddEventHandler('KKF.Player.Dropped', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local playerPed = GetPlayerPed(xPlayer.source)

    if DoesEntityExist(playerPed) then
        local id = players[xPlayer.identifier]

        if id then
            players[xPlayer.identifier] = nil
            SetPlayerRoutingBucket(xPlayer.source, 0)

            if houses[id].owner == xPlayer.identifier then
                for k,v in pairs(ESX.GetPlayers()) do
                    local xTarget = ESX.GetPlayerFromId(v)

                    if players[xTarget.identifier] == id then
                        SetPlayerRoutingBucket(xTarget.source, 0)
                        SetEntityCoords(GetPlayerPed(xTarget.source), houses[id].pos)
                        players[xTarget.identifier] = nil
                    end
                end

                TriggerClientEvent('kk-robberies:endBurglary', -1, id)
                houses[id].locked = true
                houses[id].owner = 0
                houses[id].cooldown = 30
                TriggerClientEvent('kk-robberies:reloadHouses', -1, houses)
            end

            TriggerClientEvent('kk-robberies:setOutOfHouse', xPlayer.source)

            SetTimeout(1000, function()
                MySQL.Sync.execute('UPDATE users SET position = ? WHERE pid = ?', { json.encode({x = houses[id].pos.x, y = houses[id].pos.y, z = houses[id].pos.z }), xPlayer.identifier})
            end)
        end
    end
end)