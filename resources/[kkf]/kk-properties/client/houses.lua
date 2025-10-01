local ox_inventory = exports.ox_inventory
local houses = {}
local isBusy = false
local currentHouse = 0

CreateThread(function()
    ESX.PlayerData = ESX.GetPlayerData()
end)

SetInterval(function()
	if currentHouse ~= 0 then
		if IsPedDeadOrDying(cache.ped, 1) then
            leaveHouse(currentHouse)
		end
	end
end, 5000)

RegisterNetEvent('KKF.Player.Loaded')
AddEventHandler('KKF.Player.Loaded', function(playerData)
    ESX.PlayerData = playerData

    lib.callback('kk-properties:getHouses', false, function(respond)
        houses = respond
    end)
end)

RegisterNetEvent('KKF.Player.Unloaded', function() 
	ESX.PlayerData = {}; houses = {}
end)

RegisterNetEvent('kk-properties:currentHouse')
AddEventHandler('kk-properties:currentHouse', function(id)
    currentHouse = id
end)

RegisterNetEvent('kk-properites:reloadHouseData')
AddEventHandler('kk-properites:reloadHouseData', function(respond)
    houses = respond
end)

RegisterNetEvent('kk-properties:client:openHouseStash')
AddEventHandler('kk-properties:client:openHouseStash', function()
    if currentHouse == 0 then TriggerEvent('KKF.UI.ShowNotification', 'error', 'Lahkuge majast kohe - maja on hetkel suletud.'); return end
    TriggerEvent('InteractSound_CL:PlayOnOne', 'stash', 0.4)
    ox_inventory:openInventory('stash', currentHouse .. 'house')
end)

local function upgradeSafeMenu()
     
    local elements = {}
    local description = 'Sa saad oma seifi veel uuendada'


    if houses[currentHouse].safesize == 200 then
        description = "Sa ei saa oma seifi rohkem uuendada"
    end

    elements[#elements + 1] = {
        title = 'Seifi mahutavus: ' .. houses[currentHouse].safesize,
        description = description,
        event = '',
    }
    
    if houses[currentHouse].safesize == 100 then
        elements[#elements + 1] = {
            title = 'Uuenda seifi (10 000$)',
            description = 'Seifi uuendamisega saad sa oma seifi mahutavusele juurde 100KG',
            event = 'kk-properties:client:upgradeSafe',
        }
    end

    lib.registerContext({
        id = 'housesafe_menu',
        title = 'Seifi uuendamine',
        options = elements
    })
        
    lib.showContext('housesafe_menu')
       
end

RegisterNetEvent('kk-properties:client:upgradeSafe')
AddEventHandler('kk-properties:client:upgradeSafe', function()

    if houses[currentHouse].safesize == 100 then
        lib.callback('kk-properties:upgradeSafeSize', false, function(response)
            print(response)
            if response then
                TriggerEvent('KKF.UI.ShowNotification', 'success', 'Seifi mahutavus on uuendatud')
            else
                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Midagi läks valesti')
            end
        end, currentHouse)
    end
end)

RegisterNetEvent('kk-properties:client:upgradeHouseStash')
AddEventHandler('kk-properties:client:upgradeHouseStash', function()
    upgradeSafeMenu()
end)

local function dooranim()
	local playerPed = PlayerPedId()
    lib.requestAnimDict("anim@heists@keycard@")
	TaskPlayAnim(playerPed, "anim@heists@keycard@", "exit", 8.0, 1.0, -1, 16, 0, 0, 0, 0)
    Citizen.Wait(550)
	ClearPedTasks(playerPed)
end

local function enterHouse(id)
    if isBusy then return end
    if id then
        TriggerEvent('KKF.IPL.Load', houses[id].ipl)

        lib.callback('kk-properties:enterHouse', false, function(respond)
            if respond then
                isBusy = false
                TriggerEvent('cd_easytime:PauseSync', true)
                SetTimeout(2000, function()
                    TriggerEvent('kk-scripts:client:reloadWeapons')
                end)
                currentHouse = id
            else
                isBusy = false
                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Maja uks on lukus.')
            end
        end, id)
    end
end

local function leaveHouse(id)
    if currentHouse == 0 then SetEntityCoords(PlayerPedId(), vector3(houses[id].enterance.x, houses[id].enterance.y, houses[id].enterance.z)); TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teid tõsteti laost välja.'); return end
    if isBusy then return end
    if id then
        lib.callback('kk-properties:leaveHouse', false, function(respond)
            if respond then
                isBusy = false; TriggerEvent('KKF.IPL.Unload', houses[id].ipl)
                TriggerEvent('cd_easytime:PauseSync', false)
                Wait(500)
                SetTimeout(2000, function()
                    TriggerEvent('kk-scripts:client:reloadWeapons')
                end)
            else
                isBusy = false
                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Maja uks on lukus.')
            end
        end, id)
    end
end

local function locking(id, locked)
    if isBusy then return end
    if id then
        lib.callback('kk-properties:houselockingFunction', false, function(respond)
            if respond then
                isBusy = false
                TriggerEvent('InteractSound_CL:PlayOnOne', 'warehousedoor', 0.1)
                dooranim() 
                if houses[id].locked then
                    TriggerEvent('KKF.UI.ShowNotification', 'info', 'Maja uks lukustatud.')
                else
                    TriggerEvent('KKF.UI.ShowNotification', 'info', 'Maja uks avatud.')
                end
            else
                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil ei ole maja võtmeid.')
            end
        end, id, not locked)
    end
end

Citizen.CreateThread(function()
    local alreadyEnteredZone = false
    local text = '[E] - Sisene majja | [G] - Lukustusfunktsioon'

    while true do
        wait = 5
        local ped = PlayerPedId()
        local inZone = false

        for k,v in pairs(houses) do
            local dist = #(GetEntityCoords(ped) - vector3(v.enterance.x, v.enterance.y, v.enterance.z))
            if dist <= 2.0 then
                wait = 5
                inZone  = true

                if IsControlJustReleased(0, 38) then
                    enterHouse(v.id)
                    isBusy = true
                elseif IsControlJustReleased(0, 47) then
                    locking(v.id, v.locked)
                end

                break
            else
                wait = 2000
            end
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
    local text = '[E] - Lahku majast'

    while true do
        wait = 5
        local ped = PlayerPedId()
        local inZone = false

        for k,v in pairs(houses) do
            local dist = #(GetEntityCoords(ped) - vector3(v.exit.x, v.exit.y, v.exit.z))

            if dist <= 2.0 then
                wait = 5
                inZone  = true

                if IsControlJustReleased(0, 38) then
                    leaveHouse(currentHouse)
                    isBusy = true
                end

                break
            else
                wait = 2000
            end
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