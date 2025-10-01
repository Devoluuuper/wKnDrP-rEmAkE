local items = exports.ox_inventory:Items()
local activePlayers = {}

RegisterNetEvent('kk-admin2:server:adminMode', function(status)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer.isAdmin() then
        Player(kPlayer.source).state.adminMode = status
        TriggerClientEvent('kk-admin2:client:adminMode', kPlayer.source, staatus)
    end
end)

local function canPunish(sourceIdentifier, targetIdentifier) -- steami baasil
    local sourceLevel = MySQL.prepare.await('SELECT admin_lvl FROM ucp_users WHERE identifier = ?;', { sourceIdentifier })
    local targetLevel = MySQL.prepare.await('SELECT admin_lvl FROM ucp_users WHERE identifier = ?;', { targetIdentifier })

    if sourceLevel > targetLevel then
        return true
    end

    return false
end

exports('canPunish', canPunish)

RegisterNetEvent('kk-admin2:server:triggerLog', function(message) 
	local kPlayer = ESX.GetPlayerFromId(source)

	if kPlayer then
		if kPlayer.isAdmin() then
			exports['kk-scripts']:sendLog(kPlayer.identifier, 'A-TEAM', message)
		end
	end
end)

local function screenLog(source, playerId)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 2 then
            if Player(kPlayer.source).state.adminMode then
                if playerId == 'all' then
                    if kPlayer.adminLevel >= 3 then
                        local Players = ESX.GetPlayers()

                        for i = 1, #Players do
                            if Players[i] then
                                exports['kk-scripts']:screenLog(Players[i].source, 'Screen picture (ALL)')
                            end
                        end

                        TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'success', 'Request saadetud!')
                    else
                        TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
                    end
                else
                    local Target = ESX.GetPlayerFromId(playerId)

                    if Target then
                        exports['kk-scripts']:screenLog(Target.source, 'Screen picture')
                        TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'success', 'Request saadetud!')
                    else
                        TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Valitud mängija ei ole enam aktiivne!')
                    end
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterNetEvent('kk-admin2:server:screenLog', function(playerId)
    screenLog(source, playerId)
end)

RegisterCommand('screenshot', function(source, args)
    if args[1] then
        screenLog(source, args[1])
    end
end)

local function giveItem(source, playerId, item, count)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 3 then
            if Player(kPlayer.source).state.adminMode then
                local Target = ESX.GetPlayerFromId(playerId)

                if Target then
                    if item ~= 'money' and items[item] then
                        exports['kk-scripts']:sendLog(kPlayer.identifier, 'A-TEAM', 'Andis eseme ' .. item .. ' ' .. count .. 'tk.', Target.identifier)

                        if string.upper(item):find('WEAPON_') then
                            exports.ox_inventory:AddItem(Target.source, item, tonumber(count), {registered = false})
                        else
                            exports.ox_inventory:AddItem(Target.source, item, tonumber(count))
                        end

                        TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'success', 'Andsite ' .. items[item].label .. ' mängijale ' .. Target.name .. '.')
                    else
                        TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Valitud eset ei eksisteeri!')
                    end
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Valitud mängija ei ole enam aktiivne!')
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterNetEvent('kk-admin2:server:giveItem', function(playerId, item, count)
    giveItem(source, playerId, item, count)
end)

RegisterCommand('give', function(source, args)
    if args[1] and args[2] and args[3] then
        giveItem(source, args[1], args[2], args[3])
    end
end)

local function spawnEntity(source, type, argument)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 3 then
            if Player(kPlayer.source).state.adminMode then
                local playerPed = GetPlayerPed(kPlayer.source)

                if type == 'vehicle' then
                    local model = GetHashKey(argument)

                    lib.callback('ESX.RPC.IsModelReal', kPlayer.source, function(response)
                        if response then
                            local coords = GetEntityCoords(playerPed)
                            local plate = math.random(11, 99) .. 'ADM' .. math.random(111, 999) 
                            local vehicle = exports['kk-scripts']:createVehicle(model, coords, GetEntityHeading(playerPed))

                            if vehicle then
                                Entity(vehicle).state.vehicleData = json.encode({plate = plate})

                                local timer = GetGameTimer()
                                
                                while GetVehiclePedIsIn(playerPed) ~= vehicle do
                                    Wait(0)
                                    SetPedIntoVehicle(playerPed, vehicle, -1)

                                    if timer - GetGameTimer() > 15000 then
                                        break
                                    end
                                end

                                TriggerClientEvent('chatMessage', kPlayer.source, 'SÜSTEEM', 'success', 'Sõiduk tekitatud.');
                                exports['kk-scripts']:sendLog(kPlayer.identifier, 'A-TEAM', 'Tekitas sõiduki ' .. argument .. '.')
                            else
                                TriggerClientEvent('chatMessage', kPlayer.source, 'SÜSTEEM', 'error', 'Sõiduk tekitamine ebaõnnestus!');
                            end
                        else
                            TriggerClientEvent('chatMessage', kPlayer.source, 'SÜSTEEM', 'error', 'Antud sõiduki modelit ei eksisteeri.')
                        end
                    end, model)
                elseif type == 'object' then
                    local model = GetHashKey(argument)

                    lib.callback('ESX.RPC.IsModelReal', kPlayer.source, function(response)
                        if response then
                            local coords = GetEntityCoords(playerPed)
                            local object = CreateObject(model, coords.x, coords.y, coords.z - 1, true, true, false)

                            while not DoesEntityExist(object) do Wait(50) end
                            
                            TriggerClientEvent('chatMessage', kPlayer.source, 'SÜSTEEM', 'success', 'Objekt tekitatud.')
                            exports['kk-scripts']:sendLog(kPlayer.identifier, 'A-TEAM', 'Tekitas objekti ' .. argument .. '.')
                        else
                            TriggerClientEvent('chatMessage', kPlayer.source, 'SÜSTEEM', 'error', 'Antud objekti modelit ei eksisteeri.')
                        end
                    end, model)
                elseif type == 'ped' then
                    local model = GetHashKey(argument)

                    lib.callback('ESX.RPC.IsModelReal', kPlayer.source, function(response)
                        if response then
                            local coords = GetEntityCoords(playerPed)
                            local object = CreatePed(4, model, coords.x, coords.y, coords.z - 1, true, true, false)

                            while not DoesEntityExist(object) do Wait(50) end
                            
                            TriggerClientEvent('chatMessage', kPlayer.source, 'SÜSTEEM', 'success', 'Ped tekitatud.')
                            exports['kk-scripts']:sendLog(kPlayer.identifier, 'A-TEAM', 'Tekitas pedi ' .. argument .. '.')
                        else
                            TriggerClientEvent('chatMessage', kPlayer.source, 'SÜSTEEM', 'error', 'Antud objekti modelit ei eksisteeri.')
                        end
                    end, model)
                elseif type == 'plate' then
                    argument = argument:upper()
                    local result = MySQL.prepare.await('SELECT * FROM user_vehicles WHERE plate = ?', { tostring(argument) })

                    if result then
                        local coords = GetEntityCoords(playerPed)
                        local vehicleData = json.decode(result.vehicle)
                        vehicleData.plate = result.plate
                        local model = vehicleData.model
                        local vehicle = exports['kk-scripts']:createVehicle(model, coords, GetEntityHeading(playerPed))

                        if vehicle then
                            local extraRequest = MySQL.prepare.await('SELECT * FROM user_vehicles_data WHERE plate = ?', { tostring(result.plate) })

						    Entity(vehicle).state.serverModel = model
                            Entity(vehicle).state.plate = result.plate
                            Entity(vehicle).state.vehicleData = json.encode(vehicleData)

                            local timer = GetGameTimer()
                            
                            while GetVehiclePedIsIn(playerPed) ~= vehicle do
                                Wait(0)
                                SetPedIntoVehicle(playerPed, vehicle, -1)

                                if timer - GetGameTimer() > 15000 then
                                    break
                                end
                            end

                            if result.custom_sound then
                                Entity(vehicle).state.engineSound = result.custom_sound
                            end

                            TriggerClientEvent('kk-vehicles:client:syncVehicle', kPlayer.source, NetworkGetNetworkIdFromEntity(vehicle))
                        
                            exports['kk-scripts']:sendLog(kPlayer.identifier, 'A-TEAM', 'Tekitas omatud sõiduki ' .. argument .. '.')
                            TriggerClientEvent('chatMessage', kPlayer.source, 'SÜSTEEM', 'success', 'Sõiduk ' .. argument .. ' tekitatud.');
                        else
                            TriggerClientEvent('chatMessage', kPlayer.source, 'SÜSTEEM', 'error', 'Sõiduk tekitamine ebaõnnestus!');
                        end
                    else
                        TriggerClientEvent('chatMessage', kPlayer.source, 'SÜSTEEM', 'error', 'Sõiduk ' .. argument .. ' ei eksisteeri.')
                    end
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end 

RegisterNetEvent('kk-admin2:server:spawnEntity', function(type, argument)
    spawnEntity(source, type, argument)
end)

RegisterCommand('spawn', function(source, args)
    if args[1] and args[2] then
        spawnEntity(source, args[1], args[2])
    end
end)

local function deleteEntity(source, type, argument)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 2 then
            if Player(kPlayer.source).state.adminMode then
                local playerPed = GetPlayerPed(kPlayer.source)
                local radius = tonumber(argument)

                if type == 'vehicle' then
                    lib.callback('ESX.RPC.GetVehiclesInArea', kPlayer.source, function(response)
                        for k,v in pairs(response) do
                            DeleteEntity(NetworkGetEntityFromNetworkId(v))
                        end

                        exports['kk-scripts']:sendLog(kPlayer.identifier, 'A-TEAM', 'Kustutas ' .. #response .. ' sõidukit.')
                        TriggerClientEvent('chatMessage', kPlayer.source, 'SÜSTEEM', 'success', 'Kustutasite ' .. #response .. ' sõidukit.')
                    end, radius or 3.0)
                elseif type == 'ped' then
                    lib.callback('ESX.RPC.GetPedsInArea', kPlayer.source, function(response)
                        for k,v in pairs(response) do
                            DeleteEntity(NetworkGetEntityFromNetworkId(v))
                        end

                        exports['kk-scripts']:sendLog(kPlayer.identifier, 'A-TEAM', 'Kustutas ' .. #response .. ' pedi.')
                        TriggerClientEvent('chatMessage', kPlayer.source, 'SÜSTEEM', 'success', 'Kustutasite ' .. #response .. ' pedi.')
                    end, radius or 3.0)
                elseif type == 'object' then
                    lib.callback('ESX.RPC.GetObjectsInArea', kPlayer.source, function(response)
                        DeleteEntity(NetworkGetEntityFromNetworkId(v))

                        exports['kk-scripts']:sendLog(kPlayer.identifier, 'A-TEAM', 'Kustutas ' .. #response .. ' objekti.')
                        TriggerClientEvent('chatMessage', kPlayer.source, 'SÜSTEEM', 'success', 'Kustutasite ' .. #response .. ' objekti.')
                    end, radius or 3.0)
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end 

RegisterNetEvent('kk-admin2:server:deleteEntity', function(type, radius)
    deleteEntity(source, type, radius)
end)

RegisterCommand('delete', function(source, args)
    if args[1] then
        deleteEntity(source, args[1], args[2] or 1)
    end
end)

local function revivePerson(source, target)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 2 then
            if Player(kPlayer.source).state.adminMode then
                local Target = ESX.GetPlayerFromId(target)

                if Target then
                    TriggerClientEvent('kk-ambulance:revive', Target.source, false, true)
                    exports['kk-scripts']:sendLog(kPlayer.identifier, 'A-TEAM', 'Elustas mängija.', Target.identifier)
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'success', 'Elustasite mängija ' .. Target.name .. '.')
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Valitud mängija ei ole enam aktiivne!')
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterNetEvent('kk-admin2:server:revivePerson', function(target)
    revivePerson(source, target)
end)

RegisterCommand('revive', function(source, args)
    revivePerson(source, args[1] or source)
end)

local function giveAccount(source, playerId, type, count)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 3 then
            if Player(kPlayer.source).state.adminMode then
                local Target = ESX.GetPlayerFromId(playerId)

                if Target then
                    if tonumber(count) > 0 then
                        if type == 'money' or type == 'bank' then
                            Target.addAccountMoney(type, tonumber(count))
                            exports['kk-scripts']:sendLog(kPlayer.identifier, 'A-TEAM', 'Andis raha kontole ' .. type .. ' summas $' .. count .. '.', Target.identifier)
                            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'success', 'Andsite mängijale ' .. Target.name .. ' kontole ' .. type .. ' raha summas $' .. count .. '.')
                        else
                            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Sisestage korrektne tüüp!')
                        end
                    else
                        TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Sisestage korrektne summa!')
                    end
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Valitud mängija ei ole enam aktiivne!')
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterNetEvent('kk-admin2:server:giveAccount', function(playerId, type, count)
    giveAccount(source, playerId, type, count)
end)

RegisterCommand('giveAccount', function(source, args)
    if args[1] and args[2] and args[3] then
        giveAccount(source, args[1], args[2], args[3])
    end
end)

local function playerBlips(source)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 3 then
            if Player(kPlayer.source).state.adminMode then
                TriggerClientEvent('kk-admin2:client:playerBlips', kPlayer.source)
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterNetEvent('kk-admin2:server:playerBlips', function()
    playerBlips(source)
end)

RegisterCommand('playerBlips', function(source, args)
    playerBlips(source)
end)

local function playerNames(source)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 3 then
            if Player(kPlayer.source).state.adminMode then
                TriggerClientEvent('kk-admin2:client:playerNames', kPlayer.source)
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterNetEvent('kk-admin2:server:playerNames', function()
    playerNames(source)
end)

RegisterCommand('playerNames', function(source, args)
    playerNames(source)
end)

local function adminVehicleFix(source)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 2 then
            if Player(kPlayer.source).state.adminMode then
                TriggerClientEvent('kk-admin2:client:adminVehicleFix', kPlayer.source)
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterNetEvent('kk-admin2:server:adminVehicleFix', function()
    adminVehicleFix(source)
end)

RegisterCommand('afix', function(source, args)
    adminVehicleFix(source)
end)

local function adminVehicleFuel(source)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 2 then
            if Player(kPlayer.source).state.adminMode then
                TriggerClientEvent('kk-admin2:client:adminVehicleFuel', kPlayer.source)
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterNetEvent('kk-admin2:server:adminVehicleFuel', function()
    adminVehicleFuel(source)
end)

RegisterCommand('afuel', function(source, args)
    adminVehicleFuel(source)
end)

RegisterNetEvent('kk-admin2:server:openMenu', function(playerId)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.isAdmin() then -- sinu custom funktsioon admini kontrolliks
            local playerSources = ESX.GetPlayers() -- see tagastab numbrid
            local returnable = {}
            local selected = nil

            for i = 1, #playerSources do
                local xPlayer = ESX.GetPlayerFromId(playerSources[i])
                if xPlayer then
                    returnable[#returnable + 1] = {
                        identifier = xPlayer.getIdentifier(),
                        source = xPlayer.source,
                        name = xPlayer.getName(),
                        playerName = GetPlayerName(xPlayer.source)
                    }
                end
            end

            if playerId then
                selected = tonumber(playerId)
            end

            TriggerClientEvent('kk-admin2:client:openMenu', source, returnable, selected, tonumber(kPlayer.adminLevel or 1))
        end
    end
end)

RegisterCommand('noclip', function(source, args)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 2 then
            if Player(kPlayer.source).state.adminMode then
                TriggerClientEvent('kk-admin2:client:noclip', kPlayer.source)
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end)

RegisterNetEvent('kk-admin2:server:activePlayers', function()
    TriggerClientEvent('kk-admin2:client:activePlayers', source, activePlayers)
end)

local function teleportTo(source, playerId)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 2 then
            if Player(kPlayer.source).state.adminMode then
                local Target = ESX.GetPlayerFromId(playerId)

                if Target then
                    local playerPed = GetPlayerPed(kPlayer.source)
                    local targetPed = GetPlayerPed(Target.source)

                    SetEntityCoords(playerPed, GetEntityCoords(targetPed))

                    exports['kk-scripts']:sendLog(kPlayer.identifier, 'A-TEAM', 'Teleportis mängija juurde.', Target.identifier)
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Valitud mängija ei ole enam aktiivne!')
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterNetEvent('kk-admin2:server:teleportTo', function(playerId)
    teleportTo(source, playerId)
end)

RegisterCommand('tp', function(source, args)
    if args[1] then
        teleportTo(source, args[1])
    end
end)

local function teleportToMe(source, playerId)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 2 then
            if Player(kPlayer.source).state.adminMode then
                local Target = ESX.GetPlayerFromId(playerId)

                if Target then
                    local playerPed = GetPlayerPed(kPlayer.source)
                    local targetPed = GetPlayerPed(Target.source)

                    SetEntityCoords(targetPed, GetEntityCoords(playerPed))

                    exports['kk-scripts']:sendLog(kPlayer.identifier, 'A-TEAM', 'Teleportis mängija enda juurde.', Target.identifier)
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Valitud mängija ei ole enam aktiivne!')
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterNetEvent('kk-admin2:server:teleportToMe', function(playerId)
    teleportToMe(source, playerId)
end)

RegisterCommand('tpMe', function(source, args)
    if args[1] then
        teleportToMe(source, args[1])
    end
end)

local function teleportToMarker(source)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 2 then
            if Player(kPlayer.source).state.adminMode then
                TriggerClientEvent('kk-admin2:client:teleportToMarker', kPlayer.source)
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterNetEvent('kk-admin2:server:teleportToMarker', function()
    teleportToMarker(source)
end)

RegisterCommand('tpMarker', function(source, args)
    teleportToMarker(source)
end)

CreateThread(function()
    while true do
        local tempPlayers = {}
        local Players = ESX.GetPlayers()

        for i = 1, #Players do
            local entity = GetPlayerPed(Players[i].source)

            tempPlayers[#tempPlayers + 1] = { identifier = Players[i].identifier, source = Players[i].source, name = Players[i].name, playerName = GetPlayerName(Players[i].source), coords = GetEntityCoords(entity), heading = GetEntityHeading(entity) }
        end

        -- Sort players list by source ID (1,2,3,4,5, etc) --
        table.sort(tempPlayers, function(a, b)
            return a.source < b.source
        end)

        activePlayers = tempPlayers
        Wait(1500)
    end
end)

exports('insertPunishment', function(identifier, type, reason, admin, expire)
    CreateThread(function()
        MySQL.insert.await('INSERT INTO `ucp_punishments` (`identifier`, `type`, `reason`, `admin`, `expire`) VALUES (?, ?, ?, ?, ?);', { identifier, type, reason, admin, expire })
    end)
end)

local function checkInventory(source, playerId)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 2 then
            if Player(kPlayer.source).state.adminMode then
                local Target = ESX.GetPlayerFromId(playerId)

                if Target then
                    local string = ''

                    for k,v in pairs(Target.inventory) do
                        string = string .. ' ' .. v.count .. 'x ' .. v.label .. ';'
                    end
    
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'info', 'Isikul ' .. Target.name .. ' on' .. string, 15000)
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Valitud mängija ei ole enam aktiivne!')
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterNetEvent('kk-admin2:server:checkInventory', function(playerId)
    checkInventory(source, playerId)
end)

RegisterCommand('checkInventory', function(source, args)
    if args[1] then
        checkInventory(source, args[1])
    end
end)

local function slayPlayer(source, playerId)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 2 then
            if Player(kPlayer.source).state.adminMode then
                local Target = ESX.GetPlayerFromId(playerId)

                if Target then
                    TriggerClientEvent('ESX.Player.SetHealth', Target.source, 0)
                    exports['kk-scripts']:sendLog(kPlayer.identifier, 'A-TEAM', 'Slays playeri.', Target.identifier)
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Valitud mängija ei ole enam aktiivne!')
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterNetEvent('kk-admin2:server:slayPlayer', function(playerId)
    slayPlayer(source, playerId)
end)

RegisterCommand('slay', function(source, args)
    if args[1] then
        slayPlayer(source, args[1])
    end
end)

local function addFaction(source, playerId, faction, grade)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 3 then
            if Player(kPlayer.source).state.adminMode then
                local Target = ESX.GetPlayerFromId(playerId)

                if Target then
                    local factions = MySQL.prepare.await('SELECT societies FROM users WHERE pid = ?', {Target.identifier})

                    if ESX.DoesJobExist(faction, grade) then
                        local factions = json.decode(factions)

                        factions[faction] = grade
                        exports['kk-scripts']:sendLog(kPlayer.identifier, 'A-TEAM', 'Lisas mängijale fraktsiooni ' .. faction .. ' auastmel ' .. grade .. '.', Target.identifier)
                        MySQL.update.await('UPDATE users SET societies = ? WHERE pid = ?', {json.encode(factions), Target.identifier})
                        TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'success', 'Lisasid mängijale ' .. Target.name .. ' fraktsiooni ' .. faction .. ' auastmel ' .. grade .. '.')
                    else
                        TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Antud fraktsiooni, või auastet ei eksisteeri!')
                    end
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Valitud mängija ei ole enam aktiivne!')
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterNetEvent('kk-admin2:server:addFaction', function(playerId, faction, grade)
    addFaction(source, playerId, faction, grade)
end)

RegisterCommand('addFaction', function(source, args)
    if args[1] and args[2] and args[3] then
        addFaction(source, args[1], args[2], args[3])
    end
end)

local function freezePlayer(source, playerId, option)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 2 then
            if Player(kPlayer.source).state.adminMode then
                local Target = ESX.GetPlayerFromId(playerId)

                if Target then
                    TriggerClientEvent('kk-admin2:client:freezePlayer', Target.source, option)
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'info', 'Mängija ' .. Target.name .. ' freeze staatus: ' .. option .. '.')
                    exports['kk-scripts']:sendLog(kPlayer.identifier, 'A-TEAM', 'Freeze: ' .. option, Target.identifier)
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Valitud mängija ei ole enam aktiivne!')
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterNetEvent('kk-admin2:server:freezePlayer', function(playerId, faction, grade)
    freezePlayer(source, playerId, faction)
end)

RegisterCommand('freeze', function(source, args)
    if args[1] and args[2] then
        freezePlayer(source, args[1], args[2]:upper())
    end
end)

local function skinMenu(source, playerId)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 3 then
            if Player(kPlayer.source).state.adminMode then
                local Target = ESX.GetPlayerFromId(playerId)

                if Target then
                    TriggerClientEvent('kk-skin:client:openMenu', Target.source, option)
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'success', 'Andsite mängijale ' .. Target.name .. ' riietemenüü.')
                    exports['kk-scripts']:sendLog(kPlayer.identifier, 'A-TEAM', 'Andis riietemenüü.', Target.identifier)
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Valitud mängija ei ole enam aktiivne!')
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterNetEvent('kk-admin2:server:skinMenu', function(playerId)
    skinMenu(source, playerId)
end)

RegisterCommand('skin', function(source, args)
    if args[1] then
        skinMenu(source, args[1])
    end
end)

local function adminKeys(source)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 2 then
            if Player(kPlayer.source).state.adminMode then
                TriggerClientEvent('kk-admin2:client:adminKeys', kPlayer.source)
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterNetEvent('kk-admin2:server:adminKeys', function()
    adminKeys(source)
end)

RegisterCommand('akeys', function(source, args)
    adminKeys(source)
end)

RegisterCommand('staff', function(source)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer.isAdmin() then
        if Player(kPlayer.source).state.adminMode then
            local Players = ESX.GetPlayers()
			local administrators = {}
			local string = ''

			for i = 1, #Players, 1 do
				if Players[i].isAdmin() and Player(Players[i].source).state.adminMode then
					administrators[#administrators + 1] = {
                        adminLevel = Players[i].adminLevel,
                        characterName = Players[i].name,
                        userName = GetPlayerName(Players[i].source)
                    }
				end
			end

			for k,v in pairs(administrators) do
				string = string .. ' ' .. v.userName .. ' (LVL: ' .. v.adminLevel .. '; KARAKTER: ' .. v.characterName .. ');'
			end

            TriggerClientEvent('chatMessage', kPlayer.source, 'ADMINID SERVERIS', 'info', string);
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
        end
    else
        TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
    end
end)

RegisterCommand('savePos', function(source, args)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer.adminLevel > 0 then
        if args[1] then
            local plyPed = GetPlayerPed(kPlayer.source)
            local playerPos = json.decode(json.encode(GetEntityCoords(plyPed)))
            playerPos.h = GetEntityHeading(GetPlayerPed(kPlayer.source))
            local vecPos = 'vec4(' .. playerPos.x .. ', ' .. playerPos.y .. ', ' .. playerPos.z .. ', ' .. playerPos.h .. ')'
            local tablePos = '{ x = ' .. playerPos.x .. ', y = ' .. playerPos.y .. ', z = ' .. playerPos.z .. ', h = ' .. playerPos.h .. '}'
            local message = ''

            for k,v in ipairs(args) do
                message = message .. " " .. v
            end

            MySQL.insert('INSERT INTO saved_coords (coords, coords_vector3, description) VALUES (?, ?, ?)', {tablePos, vecPos, message}, function(res)
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'success', 'Kordinaat salvestatud.')
            end)
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Sisesta kommentaar punkti märkimiseks.')
        end
    else
        TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
    end
end)

local function format(data, comm)
	local pattern = {
		('\t%s, -- %s \n'):format(data:gsub('%"', ''), comm)
	}

	return table.concat(pattern)
end

RegisterCommand('formatCoords', function(source)
    if source == 0 then
        local output = (LoadResourceFile('kk-admin2', 'items.lua') or '')

        MySQL.Async.fetchAll('SELECT * FROM saved_coords', {}, function(result)
            for k,v in pairs(result) do
                output = output .. format(v.coords_vector3, v.description)
            end

            SaveResourceFile('kk-admin2', 'items.lua', output, -1)
        end)
    end
end)

local function clearInventory(source, playerId)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 3 then
            if Player(kPlayer.source).state.adminMode then
                local Target = ESX.GetPlayerFromId(playerId)

                if Target then
                    exports.ox_inventory:ClearInventory(Target.source)
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'success', 'Tühjendasite mängija ' .. Target.name .. ' inventory.')
                    exports['kk-scripts']:sendLog(kPlayer.identifier, 'A-TEAM', 'Tühjendas inventory.', Target.identifier)
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Valitud mängija ei ole enam aktiivne!')
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterNetEvent('kk-admin2:server:clearInventory', function(playerId)
    clearInventory(source, playerId)
end)

RegisterCommand('clearInventory', function(source, args)
    if args[1] then
        clearInventory(source, args[1])
    end
end)

local function onlinePlayers(source)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 3 then
            if Player(kPlayer.source).state.adminMode then
                local count = { ambulance = 0, police = 0, queue = exports['kk-queue']:getSize() }
                local Players = ESX.GetPlayers()

                for i = 1, #Players do
                    if Players[i].job.onDuty then
                        if Players[i].job.name == 'police' then
                            count.police += 1
                        elseif Players[i].job.name == 'ambulance' then
                            count.ambulance += 1
                        end
                    end
                end

                TriggerClientEvent('chatMessage', kPlayer.source, 'MÄNGIJAID SERVERIS', 'info', 'Kokku: ' .. #Players .. ', nendest ' .. count.ambulance .. ' on meedikud ja ' .. count.police .. ' on politseinikud! Queues on: ' .. count.queue .. ' inimest.');
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    else
        if source == 0 then
            local count = { ambulance = 0, police = 0, queue = exports['kk-queue']:getSize() }
            local Players = ESX.GetPlayers()

            for i = 1, #Players do
                if Players[i].job.onDuty then
                    if Players[i].job.name == 'police' then
                        count.police += 1
                    elseif Players[i].job.name == 'ambulance' then
                        count.ambulance += 1
                    end
                end
            end

            print('Kokku: ' .. #Players .. ', nendest ' .. count.ambulance .. ' on meedikud ja ' .. count.police .. ' on politseinikud! Queues on: ' .. count.queue .. ' inimest.');
        end
    end
end

RegisterCommand('players', function(source, args)
    onlinePlayers(source)
end)

local function clearOfflineInventory(source, target)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 3 then
            if Player(kPlayer.source).state.adminMode then
                local Target = ESX.GetPlayerFromIdentifier(target)

                if not Target then
                    local result = MySQL.Sync.fetchScalar('SELECT COUNT(*) FROM users WHERE pid = ?', { target })

                    if result > 0 then
                        MySQL.update.await('UPDATE users SET inventory = ? WHERE pid = ?', {'[]', target})
                        TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'success', 'Tühjendasite mängija PID: ' .. target .. ' inventory.')
                        exports['kk-scripts']:sendLog(kPlayer.identifier, 'A-TEAM', 'Tühjendas inventory.', target)
                    else
                        TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Valitud mängijat ei eksisteeri!')
                    end
                else
                    clearInventory(kPlayer.source, Target.source)
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterNetEvent('kk-admin2:server:clearOfflineInventory', function(target)
    clearOfflineInventory(source, target)
end)

RegisterCommand('clearOfflineInventory', function(source, args)
    if args[1] then
        clearOfflineInventory(source, args[1])
    end
end)

local function triggerTroll(source, playerId)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 4 then
            if Player(kPlayer.source).state.adminMode then
                local Target = ESX.GetPlayerFromId(playerId)

                if Target then
                    TriggerClientEvent('kk-troll:client:triggerTroll', Target.source)
                    exports['kk-scripts']:sendLog(kPlayer.identifier, 'A-TEAM', 'Trollis.', Target.identifier)
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Valitud mängija ei ole enam aktiivne!')
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterCommand('troll', function(source, args)
    if args[1] then
        triggerTroll(source, args[1])
    end
end)

local function toggleDuty(source)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 1 then
            Player(kPlayer.source).state.adminMode = not Player(kPlayer.source).state.adminMode
            TriggerClientEvent('kk-admin2:client:adminMode', kPlayer.source, Player(kPlayer.source).state.adminMode)

            local newStatus = Player(kPlayer.source).state.adminMode and 'ON' or not Player(kPlayer.source).state.adminMode and 'OFF'

            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'info', 'Admin status: ' .. newStatus .. '!')
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterCommand('toggleDuty', function(source, args)
    toggleDuty(source)
end)

local function lockCharacter(source, target)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 3 then
            if Player(kPlayer.source).state.adminMode then
                local doesExist = MySQL.Sync.fetchScalar('SELECT COUNT(*) FROM users WHERE pid = ?;', { target }) > 0

                if doesExist then   
                    local identifier = MySQL.prepare.await('SELECT identifier FROM users WHERE pid = ?', { target })

                    if exports['kk-admin2']:canPunish(kPlayer.steamid, identifier) or kPlayer.adminLevel >= 5 then
                        local banInfo = MySQL.query.await('SELECT * FROM `baninfo` WHERE `identifier` = ?', { identifier })[1]
                        local lockStatus = MySQL.prepare.await('SELECT disabled FROM users WHERE pid = ?', { target }) == 1
                        
                        if lockStatus then
                            MySQL.update.await('UPDATE users SET disabled = ? WHERE pid = ?', {0, target})
                            exports['kk-scripts']:sendLog(kPlayer.identifier, 'A-TEAM', 'Karakteri lukustuse eemaldamine.', target)
                            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'info', 'Karakteri lukustus eemaldatud!')
                            exports['kk-admin2']:adminNotification('PID: ' .. target .. ' lukustus eemaldati!', {steam = banInfo.identifier, pid = banInfo.pid, name = banInfo.playername, discord = banInfo.discord})
                        else
                            MySQL.update.await('UPDATE users SET disabled = ? WHERE pid = ?', {1, target})
                            exports['kk-scripts']:sendLog(kPlayer.identifier, 'A-TEAM', 'Karakteri lukustamine.', target)
                            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'info', 'Karakter lukustatud!')
                            exports['kk-admin2']:adminNotification('PID: ' .. target .. ' lukustati!', {steam = banInfo.identifier, pid = banInfo.pid, name = banInfo.playername, discord = banInfo.discord})
                        end
                    else
                        TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
                    end
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Antud karakterit ei eksisteeri!')
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterNetEvent('kk-admin2:server:lockCharacter', function(target)
    lockCharacter(source, target)
end)

RegisterCommand('lockCharacter', function(source, args)
    if args[1] then
        lockCharacter(source, args[1])
    end
end)

local function checkAccount(source, target)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 2 then
            if Player(kPlayer.source).state.adminMode then
                local Target = ESX.GetPlayerFromIdentifier(target)

                if Target then
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'info', 'Isikul ' .. Target.name .. ' on ' .. json.encode(Target.getAccounts(true)), 15000)
                else
                    local doesExist = MySQL.prepare.await('SELECT firstname, lastname, accounts FROM users WHERE pid = ?', { target })

                    if doesExist then
                        TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'info', 'Isikul ' .. doesExist.firstname .. ' ' .. doesExist.lastname .. ' on ' .. doesExist.accounts, 15000)
                    else
                        TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Antud karakterit ei eksisteeri!')
                    end
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterNetEvent('kk-admin2:server:checkAccount', function(playerId)
    checkAccount(source, playerId)
end)

RegisterCommand('checkAccount', function(source, args)
    if args[1] then
        checkAccount(source, args[1])
    end
end)

local function lockRace(source, target)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 3 then
            if Player(kPlayer.source).state.adminMode then
                local doesExist = MySQL.Sync.fetchScalar('SELECT COUNT(*) FROM users WHERE pid = ?;', { target }) > 0

                if doesExist then
                    local lockStatus = MySQL.prepare.await('SELECT race_disabled FROM users WHERE pid = ?', { target }) == 1
                    
                    if lockStatus then
                        MySQL.update.await('UPDATE users SET race_disabled = ? WHERE pid = ?', {0, target})
                        exports['kk-scripts']:sendLog(kPlayer.identifier, 'A-TEAM', 'Race lukustuse eemaldamine.', target)
                        TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'info', 'Race lukustus eemaldatud!')
                    else
                        MySQL.update.await('UPDATE users SET race_disabled = ? WHERE pid = ?', {1, target})
                        exports['kk-scripts']:sendLog(kPlayer.identifier, 'A-TEAM', 'Race lukustamine.', target)
                        TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'info', 'Race lukustatud!')
                    end
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Antud karakterit ei eksisteeri!')
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterNetEvent('kk-admin2:server:lockRace', function(target)
    lockRace(source, target)
end)

RegisterCommand('lockRace', function(source, args)
    if args[1] then
        lockRace(source, args[1])
    end
end)

local function checkCharacters(source, target)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 2 then
            if Player(kPlayer.source).state.adminMode then
                local result = MySQL.Sync.fetchScalar('SELECT COUNT(*) FROM users WHERE identifier = ?', { target })

                if result > 0 then
                    local string = ''
                    local chars = MySQL.query.await('SELECT * FROM `users` WHERE `identifier` = ?', { target })

                    for i = 1, #chars do
                        if string == '' then
                            string = string .. ' PID: ' .. chars[i].pid
                        else
                            string = string .. ', PID: ' .. chars[i].pid
                        end
                    end

                    TriggerClientEvent('chatMessage', kPlayer.source, 'SÜSTEEM', 'info', 'SteamID ' .. target .. ' karakterid: ' .. string);
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Isikul ei ole ühtegi karakterit!')
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterNetEvent('kk-admin2:server:checkCharacters', function(playerId)
    checkCharacters(source, playerId)
end)

RegisterCommand('checkCharacters', function(source, args)
    if args[1] then
        checkCharacters(source, args[1])
    end
end)

local adminMessage = nil

AddEventHandler('ESX.Player.Loaded', function(source)
    if adminMessage then
        TriggerClientEvent('kk-admin2:client:addAlert', source, adminMessage)
    end
end)

AddEventHandler('ESX.Player.Unloaded', function(source)
    if adminMessage then
        TriggerClientEvent('kk-admin2:client:removeAlert', source)
    end
end)

local function adminAlert(source, args, menu)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 3 then
            if Player(kPlayer.source).state.adminMode then
                if not menu then
                    if args[1] == 'off' and #args == 1 then
                        adminMessage = nil

                        TriggerClientEvent('kk-admin2:client:removeAlert', -1)
                    else
                        adminMessage = table.concat(args, ' ', 1)

                        TriggerClientEvent('kk-admin2:client:addAlert', -1, adminMessage)
                    end
                else
                    if args == 'off' then
                        adminMessage = nil

                        TriggerClientEvent('kk-admin2:client:removeAlert', -1)
                    elseif #args > 1 then
                        adminMessage = args
                        
                        TriggerClientEvent('kk-admin2:client:addAlert', -1, adminMessage)
                    end
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterNetEvent('kk-admin2:server:adminAlert', function(text)
    adminAlert(source, text, true)
end)

RegisterCommand('adminAlert', function(source, args)
    if args[1] then
        adminAlert(source, args)
    end
end)

local function radioToggle(source, target)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 3 then
            if Player(kPlayer.source).state.adminMode then
                target = target:upper()
                local doesExist = MySQL.Sync.fetchScalar('SELECT COUNT(*) FROM user_vehicles WHERE plate = ?;', { tostring(target) }) > 0

                if doesExist then
                    local lockStatus = MySQL.prepare.await('SELECT car_radio FROM user_vehicles WHERE plate = ?', { tostring(target) }) == 1
                    
                    if lockStatus then
                        MySQL.update.await('UPDATE user_vehicles SET car_radio = ? WHERE plate = ?', {0, tostring(target)})
                        exports['kk-scripts']:sendLog(kPlayer.identifier, 'A-TEAM', 'Autoraadio eemaldamine.', tostring(target))
                        TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'info', 'Raadio eemaldatud!')
                    else
                        MySQL.update.await('UPDATE user_vehicles SET car_radio = ? WHERE plate = ?', {1, tostring(target)})
                        exports['kk-scripts']:sendLog(kPlayer.identifier, 'A-TEAM', 'Autoraadio lubamine.', tostring(target))
                        TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'info', 'Raadio lisatud!')
                    end
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Antud sõidukit ei eksisteeri!')
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterNetEvent('kk-admin2:server:radioToggle', function(target)
    radioToggle(source, target)
end)

RegisterCommand('radioToggle', function(source, args)
    if args[1] then
        radioToggle(source, args[1])
    end
end)

local function tuneMax(source)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 3 then
            if Player(kPlayer.source).state.adminMode then
                TriggerClientEvent('kk-admin2:client:tuneMax', kPlayer.source)
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterNetEvent('kk-admin2:server:tuneMax', function()
    tuneMax(source)
end)

RegisterCommand('tuneMax', function(source, args)
    tuneMax(source)
end)

local function checkRadio(source, target)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.isAdmin() then
            if Player(kPlayer.source).state.adminMode then
                local Target = ESX.GetPlayerFromId(target)

                if Target then
                    local channel = Player(Target.source).state.radioChannel

                    if channel then
                        TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'info', 'Side: ' .. channel .. ' Mhz!')
                    else
                        TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'info', 'Sidet ei leitud!')
                    end

                    exports['kk-scripts']:sendLog(kPlayer.identifier, 'A-TEAM', 'Side checkimine.', Target.identifier)
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Valitud mängija ei ole enam aktiivne!')
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterNetEvent('kk-admin2:server:checkRadio', function(target)
    checkRadio(source, target)
end)

RegisterCommand('checkRadio', function(source, args)
    if args[1] then
        checkRadio(source, args[1])
    end
end)

local function removeAccount(source, playerId, type, count)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 3 then
            if Player(kPlayer.source).state.adminMode then
                local Target = ESX.GetPlayerFromId(playerId)

                if Target then
                    if tonumber(count) > 0 then
                        if type == 'money' or type == 'bank' then
                            Target.removeAccountMoney(type, tonumber(count))
                            exports['kk-scripts']:sendLog(kPlayer.identifier, 'A-TEAM', 'Eemaldas raha kontolt ' .. type .. ' summas $' .. count .. '.', Target.identifier)
                            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'success', 'Eemaldastie mängijalt ' .. Target.name .. ' kontol ' .. type .. ' raha summas $' .. count .. '.')
                        else
                            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Sisestage korrektne tüüp!')
                        end
                    else
                        TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Sisestage korrektne summa!')
                    end
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Valitud mängija ei ole enam aktiivne!')
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterNetEvent('kk-admin2:server:removeAccount', function(playerId, type, count)
    giveAccount(source, playerId, type, count)
end)

RegisterCommand('removeAccount', function(source, args)
    if args[1] and args[2] and args[3] then
        removeAccount(source, args[1], args[2], args[3])
    end
end)