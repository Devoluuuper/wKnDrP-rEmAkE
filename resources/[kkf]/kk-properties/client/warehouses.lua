local ox_inventory = exports.ox_inventory
local warehouses = {}; local targets = {}
local isBusy = false
local currentWarehouse = 0

local ox_target = exports.ox_target

CreateThread(function()
    ESX.PlayerData = ESX.GetPlayerData()
end)

SetInterval(function()
	if currentWarehouse ~= 0 then
		if IsPedDeadOrDying(cache.ped, 1) then
            leaveWarehouse(currentWarehouse)
		end
	end
end, 5000)

local function unloadTargets()
    for k,v in pairs(targets) do
        ox_target:removeZone(v); targets[k] = nil
    end
end

local function loadTargets()
    for k,v in pairs(targets) do
        ox_target:removeZone(v); targets[k] = nil
    end

    targets[#targets + 1] = ox_target:addBoxZone({
        coords = vec3(1090.07, -3096.35, -39.0),
        size = vec3(3.4, 5.4, math.abs(-36.75 - -40.75)),
        rotation = 0,
        debug = false,
        options = {
            {
                icon = 'fas fa-box',
                label = 'Vaata laoseisu',
                distance = 1.5,

                onSelect = function(args)
                    TriggerEvent('kk-properties:client:openWarehouseStash', 1)
                end
            }
        }
    })

    targets[#targets + 1] = ox_target:addBoxZone({
        coords = vec3(1096.35, -3096.44, -39.0),
        size = vec3(3.2, 5.6, math.abs(-36.65 - -40.65)),
        rotation = 0,
        debug = false,
        options = {
            {
                icon = 'fas fa-box',
                label = 'Vaata laoseisu',
                distance = 1.5,

                onSelect = function(args)
                    TriggerEvent('kk-properties:client:openWarehouseStash', 2)
                end
            }
        }
    })

    targets[#targets + 1] = ox_target:addBoxZone({
        coords = vec3(1102.49, -3096.07, -39.0),
        size = vec3(4.2, 5.2, math.abs(-36.9 - -40.9)),
        rotation = 0,
        debug = false,
        options = {
            {
                icon = 'fas fa-box',
                label = 'Vaata laoseisu',
                distance = 1.5,

                onSelect = function(args)
                    TriggerEvent('kk-properties:client:openWarehouseStash', 3)
                end
            }
        }
    })
end

RegisterNetEvent('KKF.Player.Loaded')
AddEventHandler('KKF.Player.Loaded', function(playerData)
    ESX.PlayerData = playerData

    lib.callback('kk-properties:getWarehouses', false, function(respond)
        warehouses = respond
    end)
end)

RegisterNetEvent('KKF.Player.Unloaded', function() 
	ESX.PlayerData = {}; warehouses = {}
end)

RegisterNetEvent('kk-properties:currentWarehouse')
AddEventHandler('kk-properties:currentWarehouse', function(id)
    currentWarehouse = id
end)

RegisterNetEvent('kk-properites:reloadWarehouseData')
AddEventHandler('kk-properites:reloadWarehouseData', function(respond)
    warehouses = respond
end)

RegisterNetEvent('kk-properties:client:openWarehouseStash')
AddEventHandler('kk-properties:client:openWarehouseStash', function(nr)
    if currentWarehouse == 0 then TriggerEvent('KKF.UI.ShowNotification', 'error', 'Lahkuge laost kohe - ladu on hetkel suletud.'); return end
    TriggerEvent('InteractSound_CL:PlayOnOne', 'stash', 0.4)
    ox_inventory:openInventory('stash', currentWarehouse .. 'warehouse' .. nr)
end)

local function dooranim()
	local playerPed = PlayerPedId()
    lib.requestAnimDict("anim@heists@keycard@")
	TaskPlayAnim(playerPed, "anim@heists@keycard@", "exit", 8.0, 1.0, -1, 16, 0, 0, 0, 0)
    Citizen.Wait(550)
	ClearPedTasks(playerPed)
end

local function enterWarehouse(id)
    if isBusy then return end
    if id then
        lib.callback('kk-properties:enterWarehouse', false, function(respond)
            if respond then
                isBusy = false
                TriggerEvent('cd_easytime:PauseSync', true)
                Wait(500)
                SetTimeout(2000, function()
                    TriggerEvent('kk-scripts:client:reloadWeapons')
                end)
                loadTargets()
            else
                isBusy = false
                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Laouks on lukus.')
            end
        end, id)
    end
end

local function leaveWarehouse(id)
    if currentWarehouse == 0 then SetEntityCoords(PlayerPedId(), vector3(warehouses[id].enterance.x, warehouses[id].enterance.y, warehouses[id].enterance.z)); TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teid tõsteti laost välja.'); return end
    if isBusy then return end
    if id then
        lib.callback('kk-properties:leaveWarehouse', false, function(respond)
            if respond then
                isBusy = false
                TriggerEvent('cd_easytime:PauseSync', false)
                Wait(500)
                SetTimeout(2000, function()
                    TriggerEvent('kk-scripts:client:reloadWeapons')
                end)
                unloadTargets()
            else
                isBusy = false
                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Laouks on lukus.')
            end
        end, id)
    end
end

local function locking(id, locked)
    if isBusy then return end
    if id then
        lib.callback('kk-properties:lockingFunction', false, function(respond)
            if respond then
                isBusy = false
                TriggerEvent('InteractSound_CL:PlayOnOne', 'warehousedoor', 0.1)
                dooranim() 
                if warehouses[id].locked then
                    TriggerEvent('KKF.UI.ShowNotification', 'info', 'Laouks lukustatud.')
                else
                    TriggerEvent('KKF.UI.ShowNotification', 'info', 'Laouks avatud.')
                end
            else
                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil ei ole lao võtmeid.')
            end
        end, id, not locked)
    end
end

Citizen.CreateThread(function()
    local alreadyEnteredZone = false
    local text = '[E] - Sisene lattu | [G] - Lukustusfunktsioon'

    while true do
        wait = 5
        local ped = PlayerPedId()
        local inZone = false

        for k,v in pairs(warehouses) do
            local dist = #(GetEntityCoords(ped) - vector3(v.enterance.x, v.enterance.y, v.enterance.z))

            if dist <= 2.0 then
                wait = 5
                inZone  = true

                if IsControlJustReleased(0, 38) then
                    enterWarehouse(v.id)
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
    local text = '[E] - Lahku laost'

    while true do
        wait = 5
        local ped = PlayerPedId()
        local inZone = false

        for k,v in pairs(warehouses) do
            local dist = #(GetEntityCoords(ped) - vector3(v.exit.x, v.exit.y, v.exit.z))

            if dist <= 2.0 then
                wait = 5
                inZone  = true

                if IsControlJustReleased(0, 38) then
                    leaveWarehouse(currentWarehouse)
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