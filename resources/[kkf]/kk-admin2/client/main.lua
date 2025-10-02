local menuOpen = false
local timeout = false

local playerBlips = false
local playerNames = false

local activeBlips = {}
local activePlayers = {}

CreateThread(function()
	while true do
        wait = 0

        if menuOpen then
            DisableControlAction(0, 24, true) -- Attack
            DisableControlAction(0, 257, true) -- Attack 2
            DisableControlAction(0, 25, true) -- Aim
            DisableControlAction(0, 263, true) -- Melee Attack 1

            DisableControlAction(0, 45, true) -- Reload
            DisableControlAction(0, 21, true) -- left shift
            DisableControlAction(0, 22, true) -- Jump
            DisableControlAction(0, 44, true) -- Cover
            DisableControlAction(0, 37, true) -- Select Weapon

            DisableControlAction(0, 288,  true) -- Disable phone
            -- DisableControlAction(0, 245,  true) -- Disable chat
            DisableControlAction(0, 289, true) -- Inventory
            DisableControlAction(0, 170, true) -- Animations
            DisableControlAction(0, 167, true) -- Job
            DisableControlAction(0, 244, true) -- Ragdoll
            DisableControlAction(0, 303, true) -- Car lock

            DisableControlAction(0, 29, true) -- B ile işaret
            DisableControlAction(0, 81, true) -- B ile işaret
            DisableControlAction(0, 26, true) -- Disable looking behind
            DisableControlAction(0, 73, true) -- Disable clearing animation
            DisableControlAction(2, 199, true) -- Disable pause screen

            -- DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
            -- DisableControlAction(0, 72, true) -- Disable reversing in vehicle

            DisableControlAction(2, 36, true) -- Disable going stealth

            DisableControlAction(0, 47, true)  -- Disable weapon
            DisableControlAction(0, 264, true) -- Disable melee
            DisableControlAction(0, 257, true) -- Disable melee
            DisableControlAction(0, 140, true) -- Disable melee
            DisableControlAction(0, 141, true) -- Disable melee
            DisableControlAction(0, 142, true) -- Disable melee

            if cache.vehicle then
                DisableControlAction(0, 75, true) -- disable SCROLLWHEEL UP key
            end

            DisablePlayerFiring(cache.ped, true) -- Disable weapon firing
        else
            wait = 500
        end

        Wait(wait)
    end
end)

local function nuiFocus(value)
    SetNuiFocus(value, value); SetNuiFocusKeepInput(value);
end

RegisterNetEvent('kk-admin2:client:openMenu', function(players, selected, lvl)
    if not menuOpen and not timeout then
        menuOpen = true; 

        SendNUIMessage({ action = 'open', data = { players = players, selected = selected, adminLevel = lvl } }); nuiFocus(true)
    end
end)

TriggerEvent('chat:addSuggestion', '/checkCharacters', 'Karakterite PID päring.', {
    { name = 'steam:110000xxxxxx'}
})

TriggerEvent('chat:addSuggestion', '/am', 'Ava admini menüü.', {
    { name = 'id'}
})

RegisterKeyMapping('am', 'Ava admini menüü.', 'keyboard', 'M')

RegisterCommand('am', function(source, args)
    TriggerServerEvent('kk-admin2:server:openMenu', args[1])
end)

RegisterNetEvent('kk-admin2:client:addAlert', function(message)
    SendNUIMessage({ action = 'addMessage', data = { message = message } })
end)

RegisterNetEvent('kk-admin2:client:removeAlert', function()
    SendNUIMessage({ action = 'removeMessage' })
end)

RegisterNetEvent('kk-admin2:client:selectPlayer', function(id)
    SendNUIMessage({ action = 'selectPlayer', data = { id = id } })
end)

RegisterNUICallback('closeMenu', function()
    nuiFocus(false); SendNUIMessage({ action = 'close' });

    SetTimeout(150, function() menuOpen = false end)
    timeout = true; SetTimeout(500, function() timeout = false end)
end)

RegisterNUICallback('nuiFocus', function(args, cb)
    SetNuiFocusKeepInput(args.val); 
end)

RegisterNUICallback('showNotification', function(data, cb)
    TriggerEvent('KKF.UI.ShowNotification', data.type, data.message)
end)

RegisterNUICallback('adminMode', function(data, cb)
    TriggerServerEvent('kk-admin2:server:adminMode', data.status)
end)

TriggerEvent('chat:addSuggestion', '/give', 'Anna asju.', {
    { name = 'id'},
	{ name = 'item'},
    { name = 'amount'}
}) 

TriggerEvent('chat:addSuggestion', '/adminAlert', 'Teadaande loomine.', {
    { name = 'sisu'}
}) 

RegisterNUICallback('announceButton', function(data, cb)
    TriggerServerEvent('kk-admin2:server:adminAlert', data.text)
end)

RegisterNUICallback('giveItem', function(data, cb)
    TriggerServerEvent('kk-admin2:server:giveItem', data.target, data.name, data.count)
end)

TriggerEvent('chat:addSuggestion', '/spawn', 'Tekita entity.', {
    { name = 'type'},
	{ name = 'argument'}
})

RegisterNUICallback('spawnEntity', function(data, cb)
    TriggerServerEvent('kk-admin2:server:spawnEntity', data.type, data.argument)
end)

RegisterNUICallback('deleteEntity', function(data, cb)
    TriggerServerEvent('kk-admin2:server:deleteEntity', data.type)
end)

TriggerEvent('chat:addSuggestion', '/delete', 'Delete entity.', {
    { name = 'type'},
	{ name = 'radius'}
})

RegisterNUICallback('revivePerson', function(data, cb)
    TriggerServerEvent('kk-admin2:server:revivePerson', data.target)
end)

TriggerEvent('chat:addSuggestion', '/revive', 'Mängija elustamine.', {
    { name = 'id'}
})

RegisterNUICallback('giveAccount', function(data, cb)
    TriggerServerEvent('kk-admin2:server:giveAccount', data.target, data.type, data.count)
end) 

TriggerEvent('chat:addSuggestion', '/giveAccount', 'Anna raha kontole.', {
    { name = 'id'},
    { name = 'type'},
    { name = 'count'}
})

RegisterNUICallback('removeAccount', function(data, cb)
    TriggerServerEvent('kk-admin2:server:removeAccount', data.target, data.type, data.count)
end) 

TriggerEvent('chat:addSuggestion', '/removeAccount', 'Anna raha kontole.', {
    { name = 'id'},
    { name = 'type'},
    { name = 'count'}
})

RegisterNetEvent('kk-admin2:client:activePlayers', function(players)
    activePlayers = players
end)

RegisterNUICallback('playerBlips', function(data, cb)
    TriggerServerEvent('kk-admin2:server:playerBlips')
end)

local function addPlayerBlip(playerId, playerCoords, heading, playerName)
    if playerId ~= cache.serverId then
        RemoveBlip(activeBlips[playerId]); activeBlips[playerId] = nil

        activeBlips[playerId] = AddBlipForCoord(playerCoords.x, playerCoords.y, playerCoords.z)

        SetBlipCategory(activeBlips[playerId], 7)
        SetBlipSprite(activeBlips[playerId], 1)
        SetBlipColour(activeBlips[playerId], nil)
        ShowHeadingIndicatorOnBlip(activeBlips[playerId], true)
        SetBlipRotation(activeBlips[playerId], math.ceil(heading))
        SetBlipAsShortRange(activeBlips[playerId], true)
        SetBlipScale(activeBlips[playerId], 1.0)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(playerName)
        EndTextCommandSetBlipName(activeBlips[playerId])
    end
end

RegisterNetEvent('kk-admin2:client:playerBlips', function()
    if not playerBlips then
        playerBlips = true
        
        TriggerEvent('KKF.UI.ShowNotification', 'success', 'Blipid sisselülitatud!')
        TriggerServerEvent('kk-admin2:server:triggerLog', 'Mängija blipide staatus SEES.')
    else
        playerBlips = false

        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Blipid väljalülitatud!')
        TriggerServerEvent('kk-admin2:server:triggerLog', 'Mängija blipide staatus VÄLJAS.')
    end
    
    while playerBlips do
        TriggerServerEvent('kk-admin2:server:activePlayers')

        for _, v in pairs(activePlayers) do
            addPlayerBlip(v.source, v.coords, v.heading, '[ID: ' .. v.source or 'UNKNOWN' .. '; PID: ' .. v.identifier or 'UNKNOWN' .. '] ' .. v.name or 'UNKNOWN' .. ' - ' .. v.playerName or 'UNKNOWN')
        end

        Wait(1000)
    end

    for k,v in pairs(activeBlips) do
        if DoesBlipExist(activeBlips[k]) then
            RemoveBlip(activeBlips[k]); activeBlips[k] = nil
        end
    end
end)

TriggerEvent('chat:addSuggestion', '/playerBlips', 'Aktiveeri mängija blipid.')

RegisterNUICallback('playerNames', function(data, cb)
    TriggerServerEvent('kk-admin2:server:playerNames')
end)

local function drawText3d(x, y, z, text, scale)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
  
    SetTextScale(scale, scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry('STRING')
    SetTextCentre(1)
    SetTextColour(255, 255, 255, 255)
    SetTextOutline()
  
    AddTextComponentString(text)
    DrawText(_x, _y)
end

local function isNearBy(source)
    local returnable = false

    for k,v in pairs(GetActivePlayers()) do
        if GetPlayerServerId(v) == source then
            returnable = true
        end
    end

    return returnable
end

RegisterNetEvent('kk-admin2:client:playerNames', function()
    if not playerNames then
        playerNames = true
        
        TriggerEvent('KKF.UI.ShowNotification', 'success', 'Overhead named sisselülitatud!')
        TriggerServerEvent('kk-admin2:server:triggerLog', 'Mängija overhead namede staatus SEES.')
    else
        playerNames = false

        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Overhead named väljalülitatud!')
        TriggerServerEvent('kk-admin2:server:triggerLog', 'Mängija overhead namede staatus VÄLJAS.')
    end
    
    CreateThread(function()
        while playerNames do
            TriggerServerEvent('kk-admin2:server:activePlayers')
    
            Wait(1000)
        end
    end)

    while playerNames do
        for _, v in pairs(activePlayers) do
            local playerPed = GetPlayerPed(GetPlayerFromServerId(v.source))
            local position = GetEntityCoords(playerPed)

            if isNearBy(v.source) then
                drawText3d(position.x, position.y, position.z + 1.0, '[ID: ' .. v.source .. '; PID: ' .. v.identifier .. '] ' .. v.name .. ' - ' .. v.playerName, 0.4)
            end
        end

        Wait(0)
    end
end)

TriggerEvent('chat:addSuggestion', '/playerNames', 'Aktiveeri mängija overhead nimed.')

RegisterNUICallback('adminVehicleFix', function(data, cb)
    TriggerServerEvent('kk-admin2:server:adminVehicleFix')
end)

RegisterNetEvent('kk-admin2:client:adminVehicleFix', function()
    if cache.vehicle then
        exports['kk-scripts']:fixCurrent(); TriggerServerEvent('kk-admin2:server:triggerLog', 'Parandas sõiduki.')

        TriggerEvent('KKF.UI.ShowNotification', 'success', 'Parandasid sõiduki.')
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Antud käskluse kasutamiseks peate olema sõidukis!')
    end
end)

TriggerEvent('chat:addSuggestion', '/afix', 'Paranda sõiduk.') 

RegisterNUICallback('adminVehicleFuel', function(data, cb)
    TriggerServerEvent('kk-admin2:server:adminVehicleFuel')
end)

RegisterNetEvent('kk-admin2:client:adminVehicleFuel', function()
    if cache.vehicle then
        exports['kk-scripts']:fuelCurrent(); TriggerServerEvent('kk-admin2:server:triggerLog', 'Tankis sõiduki.')

        TriggerEvent('KKF.UI.ShowNotification', 'success', 'Tankisid sõiduki.')
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Antud käskluse kasutamiseks peate olema sõidukis!')
    end
end)

TriggerEvent('chat:addSuggestion', '/afuel', 'Tangi sõiduk.')

RegisterNUICallback('teleportTo', function(data, cb)
    TriggerServerEvent('kk-admin2:server:teleportTo', data.target)
end) 

TriggerEvent('chat:addSuggestion', '/radioToggle', 'Autoraadio toggle.', {
    { name = 'plate'}
})

TriggerEvent('chat:addSuggestion', '/tp', 'Teleporti mängija juurde.', {
    { name = 'id'}
})

RegisterNUICallback('teleportToMe', function(data, cb)
    TriggerServerEvent('kk-admin2:server:teleportToMe', data.target)
end)

TriggerEvent('chat:addSuggestion', '/tpMe', 'Teleporti mängija enda juurde.', {
    { name = 'id'}
})

RegisterNUICallback('teleportToMarker', function(data, cb)
    TriggerServerEvent('kk-admin2:server:teleportToMarker', data.target)
end)

RegisterNetEvent('kk-admin2:client:teleportToMarker', function()
    local waypointHandle = GetFirstBlipInfoId(8)

    if DoesBlipExist(waypointHandle) then
        local waypointCoords = GetBlipInfoIdCoord(waypointHandle)

        for height = 1, 1000 do
            SetPedCoordsKeepVehicle(cache.ped, waypointCoords.x, waypointCoords.y, height + 0.0)

            local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords.x, waypointCoords.y, height + 0.0)

            if foundGround then
                SetPedCoordsKeepVehicle(cache.ped, waypointCoords.x, waypointCoords.y, height + 0.0)

                break
            end

            Wait(5)
        end

        TriggerServerEvent('kk-admin2:server:triggerLog', 'Teleportis markerile x: ' .. waypointCoords.x .. '; y: ' .. waypointCoords.y)
        TriggerEvent('KKF.UI.ShowNotification', 'success', 'Teleportisid markerile.')
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Marker puudub!')
    end
end)

TriggerEvent('chat:addSuggestion', '/tpMarker', 'Teleporti markeri juurde.')

RegisterNUICallback('checkInventory', function(data, cb)
    TriggerServerEvent('kk-admin2:server:checkInventory', data.target)
end)

TriggerEvent('chat:addSuggestion', '/checkInventory', 'Mängija jälgimine.', {
    { name = 'id'}
})

RegisterNUICallback('slayPlayer', function(data, cb)
    TriggerServerEvent('kk-admin2:server:slayPlayer', data.target)
end)

TriggerEvent('chat:addSuggestion', '/slay', 'Mängija tapmine.', {
    { name = 'id'}
})

RegisterNUICallback('addFaction', function(data, cb)
    TriggerServerEvent('kk-admin2:server:addFaction', data.target, data.faction, data.grade)
end)

TriggerEvent('chat:addSuggestion', '/addFaction', 'Lisa mängijale fraktsioon.', {
    { name = 'id'},
    { name = 'faction'},
    { name = 'grade'}
})  

TriggerEvent('chat:addSuggestion', '/lockCharacter', 'Karakteri lukustamine.', {
    { name = 'pid'},
}) 

TriggerEvent('chat:addSuggestion', '/checkAccount', 'Vaata rahaseisu.', {
    { name = 'pid'},
}) 

RegisterNUICallback('adminKeys', function(data, cb)
    TriggerServerEvent('kk-admin2:server:adminKeys')
end)

RegisterNetEvent('kk-admin2:client:adminKeys', function()
    local vehicle

    if cache.vehicle then
        vehicle = cache.vehicle
    else
        vehicle = KKF.Functions.GetClosestVehicle()
    end

    if DoesEntityExist(vehicle) then
        exports['kk-vehicles']:addKey(KKF.Functions.GetPlate(vehicle))
        TriggerServerEvent('kk-admin:server:logs', 'Võttis sõiduki ' .. KKF.Functions.GetPlate(vehicle) ..' võtme.')
        TriggerEvent('KKF.UI.ShowNotification', 'success', 'Võtsid sõiduki võtmed.') 
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ühtegi sõidukit ei eksisteeri läheduses, või te ei ole sõidukis!')
    end
end)

TriggerEvent('chat:addSuggestion', '/akeys', 'Sõiduki võtmete võtmine.')

RegisterNUICallback('freezePlayer', function(data, cb)
    TriggerServerEvent('kk-admin2:server:freezePlayer', data.target, data.radio)
end)

RegisterNetEvent('kk-admin2:client:freezePlayer', function(option)
    if cache.vehicle and option == 'ON' then
        TaskLeaveAnyVehicle(cache.ped, 0)
    end
    
    FreezeEntityPosition(cache.ped, option == 'ON' and true or option == 'OFF' and false)
end)

TriggerEvent('chat:addSuggestion', '/freeze', 'Freeze mängija.', {
    { name = 'id'},
    { name = 'option'}
})

RegisterNetEvent('kk-troll:client:triggerTroll', function()
    if cache.vehicle then
        Entity(cache.vehicle).state:set('fuel', 0, true)

        for i = 0, 10 do
            Wait(math.random(5000, 10000))
            SetVehicleEngineOn(cache.vehicle, false, true)

            SetVehicleHandbrake(cache.vehicle, true)
            Wait(math.random(1000))
            SetVehicleHandbrake(cache.vehicle, false)
            
            Wait(500)

            SetVehicleTyreBurst(cache.vehicle, 1, false, 1000.0)
        end 
    end
end)

TriggerEvent('chat:addSuggestion', '/troll', 'Trigger troll.', {
    { name = 'id'}
})

RegisterNUICallback('skinMenu', function(data, cb)
    TriggerServerEvent('kk-admin2:server:skinMenu', data.target)
end)

TriggerEvent('chat:addSuggestion', '/skin', 'Riietemenüü.', {
    { name = 'id'}
})

RegisterNUICallback('clearInventory', function(data, cb)
    TriggerServerEvent('kk-admin2:server:clearInventory', data.target)
end)

TriggerEvent('chat:addSuggestion', '/clearInventory', 'Tühjenda inventory.', {
    { name = 'id'}
}) 

RegisterNUICallback('clearOfflineInventory', function(data, cb)
    TriggerServerEvent('kk-admin2:server:clearOfflineInventory', data.target)
end)

TriggerEvent('chat:addSuggestion', '/clearOfflineInventory', 'Tühjenda offline inventory.', {
    { name = 'pid'}
})

TriggerEvent('chat:addSuggestion', '/staff', 'Vaata aktiivseid admineid.')
TriggerEvent('chat:addSuggestion', '/savePos', 'Salvesta kordinaate.')
TriggerEvent('chat:addSuggestion', '/players', 'Vaata online playereid.')
TriggerEvent('chat:addSuggestion', '/toggleDuty', 'Admin duty.')

TriggerEvent('chat:addSuggestion', '/screenshot', 'Screenshot.', {
    { name = 'id'}
})

RegisterNUICallback('requestScreenshot', function(data, cb)
    TriggerServerEvent('kk-admin2:server:screenLog', data.target)
end) 

local performanceModIndices = { 11, 12, 13, 15, 16 }

local function tuneMax()
    local max

    if DoesEntityExist(cache.vehicle) and IsEntityAVehicle(cache.vehicle) then
        SetVehicleModKit(cache.vehicle, 0)

        for _, modType in ipairs(performanceModIndices) do
            max = GetNumVehicleMods(cache.vehicle, tonumber(modType)) - 1
            SetVehicleMod(cache.vehicle, modType, max, false)
        end

        ToggleVehicleMod(cache.vehicle, 18, true) -- Turbo
        SetVehicleFixed(cache.vehicle)
        TriggerServerEvent('kk-admin:server:logs', 'Tuunis sõiduki ' .. KKF.Functions.GetPlate(cache.vehicle) .. ' maxi!')
    end
end

RegisterNetEvent('kk-admin2:client:tuneMax', tuneMax)

TriggerEvent('chat:addSuggestion', '/tuneMax', 'Tune vehicle max.')

RegisterCommand('getModel', function()
    if cache.vehicle then
        print(GetEntityModel(cache.vehicle))
    end
end)