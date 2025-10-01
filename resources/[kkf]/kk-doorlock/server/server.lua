-- Server-side script for door lock system

-- Table to store door data
local doors = {}

-- Load doors from database
local function loadDoorsFromDatabase()
    local result = MySQL.query.await('SELECT * FROM doors')
    if result then
        for _, door in ipairs(result) do
            -- Parse JSON fields (access, settings)
            door.access = door.access and json.decode(door.access) or {}
            door.settings = door.settings and json.decode(door.settings) or {}
            doors[door.id] = {
                model = door.model,
                coords = vector3(door.coords_x, door.coords_y, door.coords_z),
                lock = door.lock_state == 1 and true or false,
                active = door.active == 1 and true or false,
                keyFob = door.settings.keyFob or false,
                hidden = door.settings.hidden or false,
                rate = door.settings.rate or nil,
                access = door.access,
                forceUnlocked = door.force_unlocked == 1 and true or false
            }
        end
    end
end

-- Initialize doors on resource start
Citizen.CreateThread(function()
    loadDoorsFromDatabase()
    -- Notify all connected clients of the initial door state
    TriggerClientEvent('kk-doorlock:client:loadDoors', -1, doors)
end)

-- Handle client request for door data
RegisterNetEvent('kk-doorlock:server:requestDoors')
AddEventHandler('kk-doorlock:server:requestDoors', function()
    local source = source
    TriggerClientEvent('kk-doorlock:client:loadDoors', source, doors)
end)

-- Handle door state change
RegisterNetEvent('kk-doorlock:server:changeState')
AddEventHandler('kk-doorlock:server:changeState', function(doorId, state)
    local source = source
    if not doors[doorId] then
        print(string.format('[ERROR] Player %d attempted to change state of invalid door ID %d', source, doorId))
        return
    end

    -- Validate access (optional, depending on your security requirements)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        print(string.format('[ERROR] Player %d not found for door state change', source))
        return
    end

    -- Update door state
    doors[doorId].lock = state
    -- Update database
    MySQL.update.await('UPDATE doors SET lock_state = ? WHERE id = ?', { state and 1 or 0, doorId })

    -- Broadcast state change to all clients
    TriggerClientEvent('kk-doorlock:client:changeState', -1, doorId, state, doors[doorId].forceUnlocked)

    -- Log the action (optional)
    print(string.format('[INFO] Player %d changed door %d to %s', source, doorId, state and 'locked' or 'unlocked'))
end)

-- Export to add a new door
exports('addDoor', function(id, data)
    if not id or not data then
        print('[ERROR] Invalid parameters for addDoor export')
        return false
    end

    -- Validate required fields
    if not data.model or not data.coords or data.active == nil or data.lock == nil then
        print('[ERROR] Missing required fields in door data')
        return false
    end

    -- Default values for optional fields
    data.access = data.access or {}
    data.settings = data.settings or {}
    data.keyFob = data.settings.keyFob or false
    data.hidden = data.settings.hidden or false
    data.rate = data.settings.rate or nil
    data.forceUnlocked = data.forceUnlocked or false

    -- Store in memory
    doors[id] = data

    -- Insert into database
    MySQL.insert.await('INSERT INTO doors (id, model, coords_x, coords_y, coords_z, lock_state, active, access, settings, force_unlocked) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', {
        id,
        data.model,
        data.coords.x,
        data.coords.y,
        data.coords.z,
        data.lock and 1 or 0,
        data.active and 1 or 0,
        json.encode(data.access),
        json.encode(data.settings),
        data.forceUnlocked and 1 or 0
    })

    -- Broadcast to all clients
    TriggerClientEvent('kk-doorlock:client:addDoor', -1, id, data)
    return true
end)

-- Export to remove a door
exports('removeDoor', function(id)
    if not doors[id] then
        print(string.format('[ERROR] Attempted to remove non-existent door ID %d', id))
        return false
    end

    -- Remove from database
    MySQL.delete.await('DELETE FROM doors WHERE id = ?', { id })

    -- Remove from memory
    doors[id] = nil

    -- Broadcast to all clients
    TriggerClientEvent('kk-doorlock:client:removeDoor', -1, id)
    return true
end)

-- Export to check access
exports('hasAccess', function(playerId, doorId, pType)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer or not doors[doorId] then
        return false
    end

    local secured = doors[doorId]
    if secured.forceUnlocked then
        return false
    end

    if next(secured.access) then
        if secured.access.factions then
            for faction, config in pairs(secured.access.factions) do
                if xPlayer.job.name == faction then
                    if (config.dutyRequired and xPlayer.job.onDuty) or not config.dutyRequired then
                        if (config.permissionNeeded and xPlayer.job.permissions and xPlayer.job.permissions.doors) or not config.permissionNeeded then
                            return true
                        end
                    end
                end
            end
        end

        if secured.access.item then
            local count = exports.ox_inventory:GetItemCount(playerId, secured.access.item.name, secured.access.item.metadata)
            if count > 0 then
                return true
            end
        end
    end

    return false
end)

-- Admin command to add a door
RegisterCommand('adddoor', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if source > 0 then
        local id = tonumber(args[1])
        local model = tonumber(args[2])
        local coords = vector3(tonumber(args[3]), tonumber(args[4]), tonumber(args[5]))
        local lock = args[6] == 'true' and true or false
        local keyFob = args[7] == 'true' and true or false
        local hidden = args[8] == 'true' and true or false
        local rate = args[9] and tonumber(args[9]) or nil

        if not id or not model or not coords.x or not coords.y or not coords.z then
            TriggerClientEvent('chat:addMessage', source, { args = { 'DoorLock', 'Invalid parameters. Usage: /adddoor <id> <model> <x> <y> <z> [lock] [keyFob] [hidden] [rate]' } })
            return
        end

        local data = {
            model = model,
            coords = coords,
            lock = lock,
            active = true,
            access = {},
            settings = {
                keyFob = keyFob,
                hidden = hidden,
                rate = rate
            },
            forceUnlocked = false
        }

        if exports['kk-doorlock']:addDoor(id, data) then
            TriggerClientEvent('chat:addMessage', source, { args = { 'DoorLock', 'Door added successfully' } })
        else
            TriggerClientEvent('chat:addMessage', source, { args = { 'DoorLock', 'Failed to add door' } })
        end
    else
        TriggerClientEvent('chat:addMessage', source, { args = { 'DoorLock', 'Invalid source' } })
    end
end, false)


RegisterCommand('removedoor', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if source > 0 then
        local id = tonumber(args[1])
        if not id then
            TriggerClientEvent('chat:addMessage', source, { args = { 'DoorLock', 'Invalid door ID' } })
            return
        end

        if exports['kk-doorlock']:removeDoor(id) then
            TriggerClientEvent('chat:addMessage', source, { args = { 'DoorLock', 'Door removed successfully' } })
        else
            TriggerClientEvent('chat:addMessage', source, { args = { 'DoorLock', 'Failed to remove door' } })
        end
    else
        TriggerClientEvent('chat:addMessage', source, { args = { 'DoorLock', 'Invalid source' } })
    end
end, false)
