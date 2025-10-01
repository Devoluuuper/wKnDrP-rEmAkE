local activeApps = {}

local function loadAppsFromDB(src)
    local identifier = GetPlayerIdentifierByType(src, "license")
    if not identifier then return {} end

    local result = MySQL.single.await('SELECT apps FROM tablet_apps WHERE citizenid = ?', { identifier })
    if result and result.apps then
        local decoded = json.decode(result.apps) or {}
        activeApps[src] = decoded
        return decoded
    else
        MySQL.insert.await('INSERT INTO tablet_apps (citizenid, apps) VALUES (?, ?)', { identifier, '{}' })
        activeApps[src] = {}
        return {}
    end
end

local function saveAppsToDB(src)
    local identifier = GetPlayerIdentifierByType(src, "license")
    if not identifier then return end

    local data = json.encode(activeApps[src] or {})
    MySQL.update.await('UPDATE tablet_apps SET apps = ? WHERE citizenid = ?', { data, identifier })
end

exports('droppyStick', function(event, item, inventory, slot, data)
    local src = inventory.id
    activeApps[src] = activeApps[src] or {}
    activeApps[src].droppy = true

    exports.ox_inventory:RemoveItem(src, 'droppy_stick', 1)
    saveAppsToDB(src)
end)

exports('carstopStick', function(event, item, inventory, slot, data)
    local src = inventory.id
        activeApps[src] = activeApps[src] or {}
        activeApps[src].boosting = true
        exports.ox_inventory:RemoveItem(src, 'carstop_stick', 1)
        saveAppsToDB(src)
end)

exports('sellingStick', function(event, item, inventory, slot, data)
    local src = inventory.id
    activeApps[src] = activeApps[src] or {}
    activeApps[src].selling = true

    exports.ox_inventory:RemoveItem(src, 'selling_stick', 1)
    saveAppsToDB(src)
end)

exports('truckStick', function(event, item, inventory, slot, data)
    local src = inventory.id
    activeApps[src] = activeApps[src] or {}
    activeApps[src].truck = true

    exports.ox_inventory:RemoveItem(src, 'trucking_stick', 1)
    saveAppsToDB(src)
end)

lib.callback.register('kk-tablet:loadApps', function(source)
    if not activeApps[source] then
        return loadAppsFromDB(source)
    end
    return activeApps[source]
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    if activeApps[src] then
        saveAppsToDB(src)
        activeApps[src] = nil
    end
end)

