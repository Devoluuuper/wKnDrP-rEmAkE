local doors = {}
local currentDoorCoords, currentDoorId, currentDoorLockState, currentZone = vector3(0, 0, 0), nil, nil, nil
local listening = false; local timeout = false
local printEntityDetails = false
local bollards = {
    gabz_mrpd_bollards1 = {doorId = 4, inside = false},
    gabz_mrpd_bollards2 = {doorId = 5, inside = false},
    gabz_paletopd_bollards1 = {doorId = 7, inside = false}
}

RegisterNetEvent('kk-doorlock:client:loadDoors', function(data)
    doors = data
    setSecuredAccesses(doors, 'door')

    for doorId, door in ipairs(doors) do
        if door ~= 'dummie' then
            if door.active and not IsDoorRegisteredWithSystem(doorId) then
                AddDoorToSystem(doorId, door.model, door.coords, false, false, false)

                if door.rate then DoorSystemSetAutomaticRate(doorId, door.rate, 0, 1) end

                DoorSystemSetDoorState(doorId, door.lock, 0, 1)
            end
        end
    end
end) 

RegisterNetEvent('kk-doorlock:client:addDoor', function(id, data)
    doors[id] = data
    setSecuredAccesses(doors, 'door')

    if data ~= 'dummie' then
        if data.active and not IsDoorRegisteredWithSystem(id) then
            AddDoorToSystem(id, data.model, data.coords, false, false, false)

            if data.rate then DoorSystemSetAutomaticRate(id, data.rate, 0, 1) end

            DoorSystemSetDoorState(id, data.lock, 0, 1)
        end
    end
end)

RegisterNetEvent('kk-doorlock:client:removeDoor', function(id)
    table.remove(doors, id)
    setSecuredAccesses(doors, 'door')

    if data ~= 'dummie' then
        if IsDoorRegisteredWithSystem(id) then
            RemoveDoorFromSystem(id)
        end
    end
end)

RegisterNetEvent('kk-doorlock:client:changeState', function(id, state, forceUnlocked)
    if doors and doors[id] then
        doors[id].lock = state
        doors[id].forceUnlocked = forceUnlocked

        DoorSystemSetAutomaticRate(id, 1.0, 0, 0)
        DoorSystemSetDoorState(id, state, 0, 1)

        if id == currentDoorId then
            currentDoorLockState = state
        end
    end
end)

local function listenForKeypress()
    listening = true

    Citizen.CreateThread(function()
        local newDoorId, newLockState = currentDoorId

        currentDoorLockState = (DoorSystemGetDoorState(currentDoorId) ~= 0 and true or false)

        local hasAccess = hasAccess(currentDoorId, 'door')
        local isHidden = doors[currentDoorId] and doors[currentDoorId].hidden or false

        if not hasAccess and currentDoorLockState and not isHidden then
            KKF.ShowInteraction('Lukus')
        end

        if printEntityDetails then
            print('Door ID: ' .. currentDoorId)
        end

        while listening do
            local idle = 0

            if currentDoorId ~= newDoorId then
                currentDoorLockState = (DoorSystemGetDoorState(currentDoorId) ~= 0 and true or false)
                newDoorId = currentDoorId
            end

            if currentDoorLockState ~= newLockState then
                if #(GetOffsetFromEntityGivenWorldCoords(cache.ped, currentDoorCoords)) <= 1.2 then
                    newLockState = currentDoorLockState

                    if hasAccess and not isHidden then
                        ESX.ShowInteraction(newLockState and 'Lukus' or 'Avatud', 'E')
                    end
                else
                    idle = 100
                end
            end

            if currentDoorId ~= nil and hasAccess and IsControlJustReleased(0, 38) and #(GetOffsetFromEntityGivenWorldCoords(cache.ped, currentDoorCoords)) <= 1.2 then
                lib.requestAnimDict("anim@heists@keycard@")
                TaskPlayAnim(cache.ped, "anim@heists@keycard@", "exit", 8.0, 1.0, -1, 48, 0, 0, 0, 0)
                TriggerServerEvent("kk-doorlock:server:changeState", currentDoorId, not currentDoorLockState)
            end

            Wait(idle)
        end

        ESX.HideInteraction()
    end)
end

function AllowsKeyFob(pDoorId)
    if not doors[pDoorId] then return false end

    return doors[pDoorId]['keyFob'] == true
end

function GetTargetDoorId(pEntity)
    local activeDoors = DoorSystemGetActive()

    for _, activeDoor in pairs(activeDoors) do
        if activeDoor[2] == pEntity then
            return activeDoor[1]
        end
    end
end

exports('GetTargetDoorId', GetTargetDoorId)

RegisterCommand("doorDebug", function()
    printEntityDetails = not printEntityDetails
end)

AddEventHandler("kk-raycast:target:changed", function(entity, type, coords)
    if type == nil or type ~= 3 then
        listening, currentDoorCoords, currentDoorId, currentDoorLockState = nil
        return
    end

    if printEntityDetails then
        print(type, GetEntityModel(entity), GetEntityCoords(entity))
    end

    local doorId = GetTargetDoorId(entity)

    if printEntityDetails then
        print(doorId)
    end

    if (doorId) then
        currentDoorId = doorId
        currentDoorCoords = coords

        if not listening then
            listenForKeypress()
        end
    end
end)

RegisterCommand('keyfob', function()
    if not timeout then
        local doorId, isBollard = -1, false

        if currentZone ~= nil and bollards[currentZone].inside then
            doorId = bollards[currentZone].doorId
            isBollard = true
        else
            local entity = exports['kk-scripts']:getEntityPlayerIsLookingAt(10.0, 2.0, 16)

            if not entity then
                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Läheduses ei ole uksi!')
                return
            end
        
            if printEntityDetails then
                print(entity, GetEntityType(entity), GetEntityCoords(entity), GetEntityModel(entity), GetEntityCoords(entity))
            end
        
            doorId = GetTargetDoorId(entity)
        
            if printEntityDetails then
                print(doorId)
            end
        end


        if not doorId then
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ust ei leitud!')
            return
        end

        if (not hasAccess(doorId, 'door') or not AllowsKeyFob(doorId)) then
            PlaySoundFromEntity(-1, "Keycard_Fail", cache.ped, "DLC_HEISTS_BIOLAB_FINALE_SOUNDS", 1, 5.0);
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Võtmepult ei tööta selle uksega!');
            return 
        end

        local isLocked = (DoorSystemGetDoorState(doorId) ~= 0 and true or false)
        TriggerEvent('InteractSound_CL:PlayOnOne', isLocked and 'GarageOpen' or 'GarageClose', 0.2);

        TriggerServerEvent("kk-doorlock:server:changeState", doorId, isBollard and (not isLocked and 6 or 0) or (not isLocked))

        timeout = true; SetTimeout(1000, function() timeout = false end)
    end
end, false)

RegisterKeyMapping("keyfob", "Võtmepult", "keyboard", "Y");

Citizen.CreateThread(function()
    lib.zones.box({ -- gabz_mrpd_bollards1
        coords = vec3(410.025787, -1020.156555, 28.401999),
        size = vec3(23.4, 7.8, math.abs(32.14 - 28.14)),
        rotation = 0,
        debug = false,
        onEnter = function()
            bollards['gabz_mrpd_bollards1'].inside = true; currentZone = 'gabz_mrpd_bollards1'
        end,
        onExit = function()
            bollards['gabz_mrpd_bollards1'].inside = false; currentZone = nil
        end
    })

    lib.zones.box({ -- gabz_mrpd_bollards2
        coords = vec3(410.025787, -1028.318970, 28.062241),
        size = vec3(23.4, 7.8, math.abs(32.14 - 28.14)),
        rotation = 0,
        debug = false,
        onEnter = function()
            bollards['gabz_mrpd_bollards2'].inside = true; currentZone = 'gabz_mrpd_bollards2'
        end,
        onExit = function()
            bollards['gabz_mrpd_bollards2'].inside = false; currentZone = nil
        end
    })

    lib.zones.box({ -- gabz_paletopd_bollards1
        coords = vec3(-453.587616, 6028.264648, 30.283751),
        size = vec3(23.4, 7.8, math.abs(32.14 - 28.14)),
        rotation = 232.38,
        debug = false,
        onEnter = function()
            bollards['gabz_paletopd_bollards1'].inside = true; currentZone = 'gabz_paletopd_bollards1'
        end,
        onExit = function()
            bollards['gabz_paletopd_bollards1'].inside = false; currentZone = nil
        end
    })

    TriggerServerEvent("kk-doorlock:server:requestDoors")
end)