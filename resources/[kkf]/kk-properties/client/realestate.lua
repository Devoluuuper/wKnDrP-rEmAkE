local ox_inventory = exports.ox_inventory
local location = vec3(-115.21318054199219,-603.6527709960938,36.2725830078125)
local exit = vec3(-141.226, -614.166, 167.820)
local guiEnabled = false

local iplList = {
    ['modern'] = {ipl = 'apa_v_mp_h_01_a', pos = vec3(-786.8663, 315.7642, 217.6385)},
    ['mody'] = {ipl = 'apa_v_mp_h_02_a', pos = vec3(-787.0749, 315.8198, 217.6386)},
    ['vibrant'] = {ipl = 'apa_v_mp_h_03_a', pos = vec3(-786.6245, 315.6175, 217.6385)},
    ['sharp'] = {ipl = 'apa_v_mp_h_04_a', pos = vec3(-787.0902, 315.7039, 217.6384)},
    ['monochrome'] = {ipl = 'apa_v_mp_h_05_a', pos = vec3(-786.9887, 315.7393, 217.6386)},
    ['seductive'] = {ipl = 'apa_v_mp_h_06_a', pos = vec3(-787.1423, 315.6943, 217.6384)},
    ['regal'] = {ipl = 'apa_v_mp_h_07_a', pos = vec3(-787.029, 315.7113, 217.6385)},
    ['aqua'] = {ipl = 'apa_v_mp_h_08_a', pos = vec3(-786.9469, 315.5655, 217.6383)}
}

CreateThread(function()
    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('KKF.Player.Loaded')
AddEventHandler('KKF.Player.Loaded', function(playerData)
    ESX.PlayerData = playerData
end)

RegisterNetEvent('KKF.Player.Unloaded', function() 
	ESX.PlayerData = {}
end)

local function showTablet()
    if LocalPlayer.state.isCuffed then return end
	if IsEntityDead(PlayerPedId()) then	return end
	if IsEntityInWater(PlayerPedId()) then return end
	
    SendNUIMessage({ action = "showTablet" })
	
    local isInVeh = IsPedInAnyVehicle(PlayerPedId(), false)

    if not isInVeh then
        SetPlayerControl(PlayerId(), 0, 0)
    end

    guiEnabled = true
    SetNuiFocus(true, true)

    exports['kk-scripts']:toggleTab(true)
end

RegisterCommand('propertiesCad', function()
    if not LocalPlayer.state.isLoggedIn then return end
    
    if ESX.PlayerData.job.name == 'properties' and ESX.PlayerData.job.onDuty and ESX.PlayerData.job.permissions.jobMenu then
        showTablet()
    end
end) 

RegisterKeyMapping('propertiesCad', 'Ava maakleri infosüsteem', 'keyboard', 'F7')

RegisterNUICallback("markLocation", function(args, cb)
    lib.callback('kk-properties:getLocation', false, function(loc)
        SetNewWaypoint(loc.x, loc.y)
	end, args.id)
end)

RegisterNUICallback("upgradeApartment", function(args, cb)

    if ESX.PlayerData.identifier == tonumber(args.pid) then
        SendNUIMessage({action = 'showNotification', data = {title = 'Korteri uuendamine', text = 'Enda korterit ei saa ise uuendada, kutse parem mõni teine maakler!', type = 'error'}})
    else
        lib.callback('kk-properties:upgradeApartment', false, function(response)
            if response == 'done' then
                SendNUIMessage({action = 'showNotification', data = {title = 'Korteri uuendamine', text = 'Uuendasite mängija korterit $80000 eest.', type = 'success'}})
            elseif response == 'hasgot' then
                SendNUIMessage({action = 'showNotification', data = {title = 'Korteri uuendamine', text = 'Isikul on juba uue taseme korter.', type = 'error'}})
            elseif response == 'nomoney' then
                SendNUIMessage({action = 'showNotification', data = {title = 'Korteri uuendamine', text = 'Isikul ei ole piisavalt raha (vaja $80000).', type = 'error'}})
            elseif response == 'notonline' then
                SendNUIMessage({action = 'showNotification', data = {title = 'Korteri uuendamine', text = 'Isik ei viibi hetkel linnas.', type = 'error'}})
            end
        end, args.pid)
    end
end)

RegisterNUICallback("removeWarehouse", function(args, cb)
    SendNUIMessage({action = 'showNotification', data = {title = 'ARENDUSES', text = 'EI TÖÖTA VEEL.', type = 'error'}})

    lib.callback('kk-properties:removeWarehouse', false, function(loc)
        
	end, args.id)
end)

RegisterNUICallback("forceOpen", function(args, cb)
    SendNUIMessage({action = 'showNotification', data = {title = 'ARENDUSES', text = 'EI TÖÖTA VEEL.', type = 'error'}})

    lib.callback('kk-properties:forceOpen', false, function(loc)
        
	end, args.id)
end)

RegisterNUICallback("sellWarehouse", function(args, cb)
    if ESX.PlayerData.job.name == 'properties' and ESX.PlayerData.job.onDuty then
        local currentPos = GetEntityCoords(cache.ped)
        local playerId, playerPed, playerCoords = lib.getClosestPlayer(currentPos, 3.0, false)
        
        if DoesEntityExist(playerPed) then
            local price = tonumber(args.price)
    
            if price >= 100000 then
                lib.callback('kk-properties:sellWarehouse', false, function(response)
                    if response then
                        SendNUIMessage({action = 'showNotification', data = {title = 'Lao müük', text = 'Lao müük õnnestus.', type = 'success'}})
                    else
                        SendNUIMessage({action = 'showNotification', data = {title = 'Lao müük', text = 'Ostjal tekkis probleem lao ostmisega.', type = 'error'}})
                    end
                end, GetPlayerServerId(playerId), price)
            else
                SendNUIMessage({action = 'showNotification', data = {title = 'Lao müük', text = 'Sisestasite ebakorrektse summa või hind peab olema vähemalt $100000.', type = 'error'}})
            end
        else
            SendNUIMessage({action = 'showNotification', data = {title = 'Lao müük', text = 'Ühtegi mängijat ei ole läheduses.', type = 'error'}})
        end
    end
end)

RegisterNUICallback("sellHouse", function(args, cb)
    local type = iplList[args.sisustus]

    if ESX.PlayerData.job.name == 'properties' and ESX.PlayerData.job.onDuty then
        local closestPlayer, closestDistance = 1, 2.0
        local id = 1

        if closestPlayer ~= -1 and closestDistance <= 3.0 then
            local price = tonumber(args.hind)
    
            if price >= 100000 then
                lib.callback('kk-properties:sellHouse', false, function(response)
                    if response then
                        SendNUIMessage({action = 'showNotification', data = {title = 'Maja müük', text = 'Maja müük õnnestus.', type = 'success'}})
                    else
                        SendNUIMessage({action = 'showNotification', data = {title = 'Maja müük', text = 'Ostjal tekkis probleem maja ostmisega.', type = 'error'}})
                    end
                end, id, price, type, args.nimi)
            else
                SendNUIMessage({action = 'showNotification', data = {title = 'Maja müük', text = 'Sisestasite ebakorrektse summa või hind peab olema vähemalt $100000.', type = 'error'}})
            end
        else
            SendNUIMessage({action = 'showNotification', data = {title = 'Maja müük', text = 'Ühtegi mängijat ei ole läheduses.', type = 'error'}})
        end
    end
end)

RegisterNUICallback("search", function(args, cb)
	lib.callback('kk-properties:searchProperties', false, function(cb)
        local info = {}

        for k,v in pairs(cb) do
            local data = {
                id = v.id,
                location = GetStreetNameFromHashKey(GetStreetNameAtCoord(v.enterance.x, v.enterance.y, v.enterance.x)),
                owner = v.owner
            }

            table.insert(info, data)
        end

		SendNUIMessage({ action = "loadResults", data = info })
	end, args.context)
end)

RegisterNUICallback("searchhouses", function(args, cb)
	lib.callback('kk-properties:searchHouses', false, function(cb)
        local info = {}

        for k,v in pairs(cb) do
            local data = {
                id = v.id,
                location = GetStreetNameFromHashKey(GetStreetNameAtCoord(v.enterance.x, v.enterance.y, v.enterance.x)),
                owner = v.owner
            }

            table.insert(info, data)
        end

		SendNUIMessage({ action = "loadhouseResults", data = info })
	end, args.context)
end)

RegisterNUICallback("disableFocus", function(args, cb)
    if not guiEnabled then
        return
    end

    SetPlayerControl(PlayerId(), 1, 0)
    SetNuiFocus(false, false)

    guiEnabled = false

    exports['kk-scripts']:toggleTab(false)
end)

RegisterNetEvent('kk-properties:job:openStash')
AddEventHandler('kk-properties:job:openStash', function()
    if ESX.PlayerData.job.name == 'properties' and ESX.PlayerData.job.onDuty and ESX.PlayerData.job.permissions.stash and ESX.PlayerData.job.properties.stash then
        ox_inventory:openInventory('stash', ESX.PlayerData.job.name)
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil puudub selle tegevuse jaoks ligipääs.')
    end
end)

RegisterNetEvent('KKF.Player.JobUpdate')
AddEventHandler('KKF.Player.JobUpdate', function(job)
    ESX.PlayerData.job = job
end)

RegisterNetEvent('KKF.Player.DutyChange')
AddEventHandler('KKF.Player.DutyChange', function(value)
	ESX.PlayerData.job.onDuty = value
end)

local function enterOffice()
    local playerPed = PlayerPedId()

    if DoesEntityExist(playerPed) then
        TriggerEvent('InteractSound_CL:PlayOnOne', 'DoorOpen', 0.7)
        DoScreenFadeOut(1000)
        Citizen.Wait(1000)
        TriggerEvent('InteractSound_CL:PlayOnOne', 'DoorClose', 0.7)
        SetEntityCoords(playerPed, exit)
        DoScreenFadeIn(1000)
        Citizen.Wait(1000)
    end
end

local function leaveOffice()
    local playerPed = PlayerPedId()

    if DoesEntityExist(playerPed) then
        TriggerEvent('InteractSound_CL:PlayOnOne', 'DoorOpen', 0.7)
        DoScreenFadeOut(1000)
        Citizen.Wait(1000)
        TriggerEvent('InteractSound_CL:PlayOnOne', 'DoorClose', 0.7)
        SetEntityCoords(playerPed, location)
        DoScreenFadeIn(1000)
        Citizen.Wait(1000)
    end
end

-- Create Blips
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(location.x, location.y, location.z)

	SetBlipSprite (blip, 40)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 0.7)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName('Maakler')
	EndTextCommandSetBlipName(blip)
end)

Citizen.CreateThread(function()
    local alreadyEnteredZone = false
    local text = nil

    while true do
        wait = 5
        local ped = PlayerPedId()
        local inZone = false
        local dist = #(GetEntityCoords(ped)-location)

        if dist <= 5.0 then
            wait = 5
            inZone  = true
            text = '[E] - Sisene maakleribüroosse'

            if IsControlJustReleased(0, 38) then
                enterOffice()
            end
        else
            wait = 2000
        end
        
        if inZone and not alreadyEnteredZone then
            alreadyEnteredZone = true
            ESX.ShowInteraction(text)
        end

        if not inZone and alreadyEnteredZone then
            alreadyEnteredZone = false
            ESX.HideInteraction()
        end

        Citizen.Wait(wait)
    end
end)

Citizen.CreateThread(function()
    local alreadyEnteredZone = false
    local text = nil

    while true do
        wait = 5
        local ped = PlayerPedId()
        local inZone = false
        local dist = #(GetEntityCoords(ped)-exit)

        if dist <= 5.0 then
            wait = 5
            inZone  = true
            text = '[E] - Lahku maakleribüroost'

            if IsControlJustReleased(0, 38) then
                leaveOffice()
            end
        else
            wait = 2000
        end
        
        if inZone and not alreadyEnteredZone then
            alreadyEnteredZone = true
            ESX.ShowInteraction(text)
        end

        if not inZone and alreadyEnteredZone then
            alreadyEnteredZone = false
            ESX.HideInteraction()
        end

        Citizen.Wait(wait)
    end
end)


for k,v in pairs(cfg.locations) do
    local point = lib.points.new(v.pos, 2.0)
    
    function point:onEnter()
        if ESX.PlayerData.job.name == 'properties' then
            ESX.ShowInteraction(v.text)
        end
    end
    
    function point:onExit()
        if ESX.PlayerData.job.name == 'properties' then
            ESX.HideInteraction(); exports['kk-police']:setIsInv(false)
        end
    end
    
    function point:nearby()
        if self.currentDistance < 2.0 and IsControlJustReleased(0, 38) then
            if ESX.PlayerData.job.name == 'properties' then
                if k == 'stash' and ESX.PlayerData.job.onDuty then
                    if ESX.PlayerData.job.permissions.stash and ESX.PlayerData.job.properties.stash then
                        ox_inventory:openInventory('stash', ESX.PlayerData.job.name)
                    else
                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil puudub ligipääs fraktsiooni seifile.')
                    end
                elseif k == 'clothes' then
                   TriggerEvent('wardrobe:clothingShop')
				 elseif k == 'boss' then			   
				  if ESX.PlayerData.job.permissions.leaderMenu then
                         TriggerEvent('kk-society:openBossMenu')
                    else
                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil puudub ligipääs fraktsiooni seifile.')
                    end
                elseif k == 'duty' then
                    TriggerServerEvent('kk-scripts:server:toggleDuty')
                else
                    TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ei saa seda tegevust sooritada olles off duty.')
                end
            end
        end
    end
end