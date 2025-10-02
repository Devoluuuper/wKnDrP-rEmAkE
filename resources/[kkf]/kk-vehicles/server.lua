local ox_inventory = exports.ox_inventory

local function Trim(value)
    if not value then return nil end
    return (value:gsub("^%s*(.-)%s*$", "%1"))
end

local function getPlate(vehicle)
    if DoesEntityExist(vehicle) then
        local plate = Entity(vehicle).state.plate or GetVehicleNumberPlateText(vehicle)
        return Trim(plate)
    end

    return nil
end


exports('getPlate', getPlate)

local function isVehicleOwned(plate)
    local result = MySQL.scalar.await('SELECT plate FROM user_vehicles WHERE plate = ?', { plate })
    return result
end

lib.callback.register('kk-vehicles:isPlayerOwned', function(_, plate)
    return isVehicleOwned(plate)
end)


local function getEntityFromNetId(netId)
    local entity = netId and NetworkGetEntityFromNetworkId(netId) or 0
    return DoesEntityExist(entity) and entity or 0
end

local function removeKey(source, plate)
    return ox_inventory:RemoveItem(source, 'vehicle_key', 1, { plate = KKF.Math.Trim(plate) })
end

RegisterNetEvent('kk-vehicles:server:removeKey', function(plate)
    removeKey(source, plate)
end)

exports('removeKey', removeKey)

local function hasKey(source, plate)
    return ox_inventory:Search(source, 'count', 'vehicle_key', { plate = KKF.Math.Trim(plate) }) > 0
end

exports('hasKey', hasKey)

function addKey(source, plate)
    return ox_inventory:AddItem(source, 'vehicle_key', 1, { plate = KKF.Math.Trim(plate) })
end

RegisterNetEvent('kk-vehicles:server:addKey', function(plate)
    addKey(source, plate)
end)

exports('addKey', addKey)

RegisterNetEvent('kk-vehicles:server:updateLocal', function(netId)
    local entity = getEntityFromNetId(netId)

    if entity and #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(entity)) < 10 then
        local state = Entity(entity).state

        if not state.spawned then
            if not state.vehicleLock then
                state:set('vehicleLock', {
                    lock = math.random() <= LockChance and 2 or 1
                }, true)
            end
        end
    end
end)

RegisterNetEvent('kk-vehicles:server:toggleLock', function(netId)
    local vehicle = getEntityFromNetId(netId)

    if vehicle > 0 and hasKey(source, GetVehicleNumberPlateText(vehicle)) then
        local state = Entity(vehicle).state

        local vehiclelock = state?.vehicleLock?.lock or 1

        local newLock = vehiclelock < 2 and 2 or 1

        if newLock == vehiclelock then
            state:set('vehicleLock', false, true)
        end

        state:set('vehicleLock', {
            lock = vehiclelock < 2 and 2 or 1,
            sound = true
        }, true)
    end
end)

RegisterNetEvent('kk-vehicles:server:toggleLights', function(netId)
    local vehicle = getEntityFromNetId(netId)

    if vehicle then
        TriggerClientEvent('kk-vehicles:client:toggleLights', NetworkGetEntityOwner(vehicle), netId)
    end
end)


RegisterNetEvent('kk-vehicles:server:lockpickDoor', function(netId, slot, item)
    local src = source
    local vehicle = getEntityFromNetId(netId)
    if not vehicle then
        return
    end

    -- Kontrolli inventory
    local slotItem = slot and ox_inventory:GetSlot(src, slot)
    if not slotItem or slotItem.name ~= item then
        return
    end

    local success = lib.callback.await('kk-vehicles:client:lockPickCar', src, netId, item)

    if success then
        local state = Entity(vehicle).state
        state:set('vehicleLock', { lock = 0 }, true)
    else
    end
end)