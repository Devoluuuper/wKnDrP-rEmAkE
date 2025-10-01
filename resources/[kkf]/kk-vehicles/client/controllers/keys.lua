local lockpickDic, lockpickAnim = 'veh@break_in@0h@p_m_one@', 'low_force_entry_ds'
local keyDict, keyAnim = 'anim@mp_player_intmenu@key_fob@', 'fob_click'
local animDict, anim = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer'


local foundCar = 0
local hasCurrentKey = false
local locking = false

function hasKey(plate)
    return exports.ox_inventory:Search('count', 'vehicle_key', { plate = ESX.Math.Trim(plate) }) > 0
end

exports('hasKey', hasKey) -- exports['kk-vehicles']:hasKey(plate)

local function addKey(plate)
    TriggerServerEvent('kk-vehicles:server:addKey', plate)
end

exports('addKey', addKey)

local function removeKey(plate)
    TriggerServerEvent('kk-vehicles:server:removeKey', plate)
end

exports('removeKey', removeKey)

local function setEngineStatus(vehicle)
    if not vehicle then return false end

    local engineStatus = GetIsVehicleEngineRunning(vehicle)

    SetVehicleUndriveable(vehicle, not engineStatus)

    if GetPedInVehicleSeat(vehicle, -1) > 0 then
        SetVehicleEngineOn(vehicle, engineStatus, false, true)
    else
        SetVehicleEngineOn(vehicle, engineStatus, true, true)
    end

    return engineStatus
end

local function getPedsInCar(vehicle)
    local Peds = {}
    local pedAmt = 0

    if vehicle then
        for seat = -1, GetVehicleModelNumberOfSeats(GetEntityModel(vehicle)) - 2 do
            local pedInSeat = GetPedInVehicleSeat(vehicle, seat)

            if pedInSeat > 0 and not IsPedAPlayer(pedInSeat) then
                pedAmt += 1
                Peds[pedAmt] = pedInSeat
            end
        end
    end

    return Peds
end

local function getClosestKeyCar()
    local vehicles = lib.getNearbyVehicles(GetEntityCoords(cache.ped), 15)

    local closestKeyCar
    local closestKeyCoords = 15


    if not cache.vehicle then
        for i = 1, #vehicles do
            local vehicle = vehicles[i]
            local plate = ESX.Functions.GetPlate(vehicle.vehicle)
            local dist = #(GetEntityCoords(cache.ped) - GetEntityCoords(vehicle.vehicle))
            local class = GetVehicleClass(vehicle.vehicle)

            if not Vehicles[class].noLocks and dist <= closestKeyCoords and hasKey(plate) then
                if HasEntityClearLosToEntityInFront(cache.ped, vehicle.vehicle) then
                    closestKeyCar = vehicle.vehicle
                    closestKeyCoords = dist
                end
            end
        end
    end

    return closestKeyCar
end

local function pedFlee(vehicle)
    local peds, amount = getPedsInCar(vehicle)

    if amount == 0 then return end

    for i = 1, #peds do
        local pedInSeat = peds[i]
        TaskLeaveVehicle(pedInSeat, vehicle, 0)
        PlayPain(pedInSeat, 6, 0)
        Wait(1000)
        ClearPedTasksImmediately(pedInSeat)
        PlayPain(pedInSeat, math.random(7, 8), 0)
        SetPedFleeAttributes(pedInSeat, 0, 0)
        TaskReactAndFleePed(pedInSeat, cache.ped)
    end
end

local function lockpickGame(circles, time)
    return exports['kk-skillbar']:skillBar(time, circles)
end

local function stateBagWrapper(keyFilter, cb)
    AddStateBagChangeHandler(keyFilter, '', function(bagName, _, value, _, replicated)
        local netId = tonumber(bagName:gsub('entity:', ''), 10)
        local loaded = netId and lib.waitFor(function()
            return NetworkDoesEntityExistWithNetworkId(netId)
        end, 'Timeout waiting for entity', 3500)
        local entity = loaded and NetworkGetEntityFromNetworkId(netId)
        if entity and not replicated then
            cb(entity, value)
        end
    end)
end

local function carAnim()
    lib.requestAnimDict(animDict, 1000)

    while exports['kk-skillbar']:skillBarActive() do
        if cache.vehicle and not IsEntityPlayingAnim(cache.ped, animDict,anim, 3) then
            TaskPlayAnim(cache.ped, animDict, anim, 3.0, 3.0, -1, 49, 0, false, false, false)
        end

        Wait(100)
    end

    RemoveAnimDict(animDict)
end

local DisableControlAction = DisableControlAction

local function vehLoop()
    hasCurrentKey = hasKey(ESX.Functions.GetPlate(cache.vehicle))

    if not Immune[GetEntityModel(cache.vehicle)] and not setEngineStatus(cache.vehicle) and not hasCurrentKey then
        while cache.vehicle do
            DisableControlAction(0, 71, true) -- disable vehicle acceleration
            DisableControlAction(0, 72, true) -- disable vehicle braking
            DisableControlAction(0, 32, true) -- disable moving forward
            DisableControlAction(0, 33, true) -- disable moving backwards
            DisableControlAction(0, 34, true) -- disable left strafe
            DisableControlAction(0, 35, true) -- disable right strafe

            if hasCurrentKey or cache.seat ~= -1 or GetIsVehicleEngineRunning(cache.vehicle) then
                break
            end

            Wait(0)
        end
    end
end

local function idleVehicle()
    while not cache.vehicle do
        local vehicle = GetVehiclePedIsTryingToEnter(cache.ped)

        if vehicle > 0 then
            local model = GetEntityModel(vehicle)
            local class = GetVehicleClass(vehicle)
            local lockStatus = GetVehicleDoorLockStatus(vehicle)

            if Immune[model] or Vehicles[class].noLocks then SetVehicleDoorsLocked(vehicle, 0) goto skip end

            if lockStatus ~= 2 then
                lockStatus = 0
                SetVehicleDoorsLocked(vehicle, 0)
            end

            if Entity(vehicle)?.state?.vehicleLock == nil and lockStatus == 0 and foundCar ~= vehicle then
                TriggerServerEvent('kk-vehicles:server:updateLocal', NetworkGetNetworkIdFromEntity(vehicle), GetIsVehicleEngineRunning(vehicle))
            end

            ::skip::

            if foundCar ~= vehicle then
                foundCar = vehicle
                SetVehicleEngineOn(vehicle, GetIsVehicleEngineRunning(vehicle), true, true)
            end
        end

        Wait(100)
    end
end

local timeout = false

local timeout = false

RegisterCommand('vehicleEngine', function()
    if cache.vehicle and not timeout then
        local vehicle = cache.vehicle
        local plate = ESX.Functions.GetPlate(vehicle)
        local engine = GetIsVehicleEngineRunning(vehicle)
        local state = Entity(vehicle).state

        -- Kontrollime, kas sõiduk on stallis või politsei poolt klambriga
        local stalled = exports['kk-scripts'] and exports['kk-scripts']:stalled()
        local clamped = exports['kk-police'] and exports['kk-police']:isClamped(vehicle)

        if not stalled and not clamped then
            if math.ceil(GetEntitySpeed(vehicle) * 2.236936) < 5 then
                -- Kontrollime, kas saab mootorit juhtida
                local canInteract = engine or hasKey(plate) or (state and state.keyInside)

                if cache.seat == -1 and (Immune[GetEntityModel(vehicle)] or canInteract) then
                    timeout = true
                    SetTimeout(1000, function() timeout = false end)

                    if not engine then
                        removeKey(plate)
                        if state then state:set('keyInside', true, true) end

                        local class = GetVehicleClass(vehicle)
                        local isBike = class == 8 or class == 9
                        local startDict = isBike and 'veh@bike@quad@front@base' or 'oddjobs@towing'

                        lib.requestAnimDict(startDict, 1000)
                        TaskPlayAnim(cache.ped, startDict, 'start_engine', 8.0, 8.0, isBike and 2250 or 1750, 48, 0, false, false, false)
                        Wait(800)
                        RemoveAnimDict(startDict)
                    else
                        if state and state.keyInside then
                            state:set('keyInside', false, true)
                            addKey(plate)
                        end
                    end

                    SetVehicleEngineOn(vehicle, not engine, true, true)
                    TriggerEvent('KKF.UI.ShowNotification', 'info', engine and 'Sõiduk väljasuretatud!' or 'Sõiduk käivitatud!')

                    if engine then
                        SetTimeout(0, vehLoop)
                    end
                end
            end
        else
            TriggerEvent('KKF.UI.ShowNotification', 'error', clamped and 'Sõiduk on klambriga!' or 'Sõiduk on stallis!')
        end
    end
end)

RegisterKeyMapping('vehicleEngine', 'Sõiduki mootor', 'keyboard', 'U')

local keyDict, keyAnim = 'anim@mp_player_intmenu@key_fob@', 'fob_click'
local locking = false

local function toggleLights(netId)
    local vehicle = NetworkGetEntityFromNetworkId(netId)

    local engineState = GetIsVehicleEngineRunning(vehicle)
    local _, light, highBeam = GetVehicleLightsState(vehicle)

    SetVehicleLights(vehicle, 1)

    local state = Entity(vehicle).state
    local lock = state?.vehicleLock?.lock or 1

    if lock == 1 then
        Wait(250)
        SetVehicleLights(vehicle, 2)
        Wait(200)

        SetVehicleLights(vehicle, 1)
        Wait(450)

    elseif lock == 2 then
        Wait(200)
        SetVehicleLights(vehicle, 2)

        Wait(100)

        SetVehicleLights(vehicle, 1)
        Wait(200)

        SetVehicleLights(vehicle, 2)

        Wait(400)

        SetVehicleLights(vehicle, 1)
    end

    local lightState = (light or highBeam) and 3 or 0

    SetVehicleLights(vehicle, lightState)

    if engineState ~= GetVehicleLightsState(vehicle) then
        SetVehicleEngineOn(vehicle, engineState, true, true)
    end
end

RegisterNetEvent('kk-vehicles:client:toggleLights', toggleLights)

local function toggleLocks(vehicle)
    if locking then return end
    locking = true

    local isUnlocking = Entity(vehicle).state?.vehicleLock?.lock == 2

    if not cache.vehicle then
        lib.requestAnimDict(keyDict, 1000)

        TaskPlayAnim(cache.ped, keyDict, keyAnim, 3.0, 3.0, -1, 49, 0, false, false, false)
    end


    TriggerServerEvent('kk-vehicles:server:toggleLights', NetworkGetNetworkIdFromEntity(vehicle))

    Wait(500)

    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, not isUnlocking and 'lock' or 'unlock', 0.1)
    TriggerServerEvent('kk-vehicles:server:toggleLock', NetworkGetNetworkIdFromEntity(vehicle))

    Wait(400)

    if not cache.vehicle then
        if IsEntityPlayingAnim(cache.ped, keyDict, keyAnim, 3) then
            StopAnimTask(cache.ped, keyDict, keyAnim, 3.0)
        end

        RemoveAnimDict(keyDict)
    end


    TriggerEvent('KKF.UI.ShowNotification', 'info', isUnlocking and 'Sõiduk avatud!' or 'Sõiduk lukustatud!')

    locking = false
end

RegisterCommand('vehicleLock', function()
    if locking then return end

    if not cache.vehicle then
        local closestKeyCar = getClosestKeyCar()

        if closestKeyCar then
            toggleLocks(closestKeyCar)
        end
    end
end)

RegisterKeyMapping('vehicleLock', 'Lukustusfunktsioon', 'keyboard', 'G')

lib.onCache('ped', function(value)
    if value then
        SetPedConfigFlag(value, 170, true) -- Will force this ped to use the direct entry point for any vehicle they try to enter, or warp in
        SetPedConfigFlag(value, 241, true) -- Player will leave the engine on when exiting a vehicle normally
        SetPedConfigFlag(value, 426, false) -- Use Franklin's alternate lockpicking animations for forced entry
        SetPedConfigFlag(value, 448, true) -- Will prevent ped from forcing entry into cars that are open from TryLockedDoor state
    end
end)

lib.onCache('seat', function(value)
    if value == -1 then
        return SetTimeout(0, vehLoop)
    end

    hasCurrentKey = false
    SetTimeout(0, idleVehicle)
end)

CreateThread(function()
    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('KKF.Player.Loaded', function(playerData)
	ESX.PlayerData = playerData
end)

RegisterNetEvent('KKF.Player.Unloaded', function() 
	ESX.PlayerData = {}
end)

RegisterNetEvent('KKF.Player.JobUpdate', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('KKF.Player.DutyChange', function(value)
	ESX.PlayerData.job.onDuty = value
end)

local function isPolice()
    return ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.onDuty
end

local function isOwned(vehicle)
    return lib.callback.await('kk-garages:isPlayerOwned', false, ESX.Functions.GetPlate(vehicle))
end

local function boostingCheck(vehicle, inside)
    local returnable = false
    local canSteal = lib.callback.await('kk-tablet:boosting:isAvailable', false, ESX.Functions.GetPlate(vehicle), inside)

    if canSteal then
        TriggerEvent('kk-tablet:boosting:spawnAgro', ESX.Functions.GetPlate(vehicle)); 
        returnable = true
    else
        returnable = false
    end

    return returnable
end

local function canLockPick(vehicle, item)
    local class = vehicle and GetVehicleClass(vehicle)

    if class then
        local itemNames = Vehicles[class] and Vehicles[class].pickItem

        if itemNames and next(itemNames) then
            return itemNames[item]
        end
    end

    return false
end

AddEventHandler('lockpick:use', function(payload)
    local vehicle = cache.vehicle or lib.getClosestVehicle(GetEntityCoords(cache.ped), 3)
    if not vehicle then return end
    TriggerServerEvent('kk-vehicles:server:lockpickDoor', NetworkGetNetworkIdFromEntity(vehicle), payload.slot, payload.name)
end)

stateBagWrapper('vehicleLock', function(entity, value)
    if type(value) == 'table' then
        SetVehicleDoorsLocked(entity, value.lock)
    end
end)

-- Callbacks --

lib.callback.register('kk-vehicles:client:lockPickCar', function(netId, item)
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    if not DoesEntityExist(vehicle) then return false end

    local class = GetVehicleClass(vehicle)
    local itemConfig = Vehicles[class] and Vehicles[class].pickItem[item]
    if not itemConfig then return false end

    local difficulty = itemConfig.difficulty
    local minigame = Difficulties[difficulty]
    if not minigame then return false end

    lib.requestAnimDict(lockpickDic, 1000)
    TaskTurnPedToFaceEntity(cache.ped, vehicle, 200)

    SetTimeout(0, function()
        while exports['kk-skillbar']:skillBarActive() do
            TaskPlayAnim(cache.ped, lockpickDic, lockpickAnim, 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Wait(1000)
        end
    end)

    local success = lockpickGame( math.random(minigame.turns.min, minigame.turns.max), math.random(minigame.time.min, minigame.time.max))
    StopAnimTask(cache.ped, lockpickDic, lockpickAnim, 3.0)
    RemoveAnimDict(lockpickDic)

    if success then
    SetVehicleDoorsLocked(vehicle, 0)

    local state = Entity(vehicle).state
    if state then
        state:set('keyInside', true, true) 
    end

    if not GetIsVehicleEngineRunning(vehicle) then
        SetVehicleEngineOn(vehicle, true, true, true)
    end

    lib.requestAnimDict(animDict, 1000)
    TaskPlayAnim(cache.ped, animDict, anim, 3.0, 3.0, 2500, 49, 0, false, false, false)
    Wait(2500)
    ClearPedTasks(cache.ped)
end

    return success
end)


AddEventHandler('ox_inventory:updateInventory', function(changes)
    if hasCurrentKey or cache.seat ~= -1 or GetIsVehicleEngineRunning(cache.vehicle) then return end

    local tempKeys = {}

    for k, v in pairs(changes) do
        if tempKeys[k] and v?.name ~= 'vehicle_key' then
            tempKeys[k] = nil
        elseif v?.name == 'vehicle_key' then
            tempKeys[k] = v?.metadata?.plate
        end
    end

    if next(tempKeys) then
        local plate = ESX.Functions.GetPlate(cache.vehicle)

        for _, v in pairs(tempKeys) do
            if v and v == plate then
                hasCurrentKey = true
                return
            end
        end

        hasCurrentKey = false
        SetTimeout(0, vehLoop)
    end
end)

AddEventHandler('onResourceStart', function(resource)
   if resource == GetCurrentResourceName() then
        if cache.vehicle then
            SetTimeout(0, vehLoop)
        else
            SetTimeout(0, idleVehicle)
        end

        SetPedConfigFlag(cache.ped, 170, true) -- Will force this ped to use the direct entry point for any vehicle they try to enter, or warp in
        SetPedConfigFlag(cache.ped, 241, true) -- Player will leave the engine on when exiting a vehicle normally
        SetPedConfigFlag(cache.ped, 426, false) -- Use Franklin's alternate lockpicking animations for forced entry
        SetPedConfigFlag(cache.ped, 448, true) -- Will prevent ped from forcing entry into cars that are open from TryLockedDoor state
   end
end)


CreateThread(function()
    while not GetResourceState('ox_inventory') == 'started' do
        Wait(100)
    end

    exports.ox_inventory:displayMetadata('plate', 'REG.NR')
end)


