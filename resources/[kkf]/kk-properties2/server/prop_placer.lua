-- ESX Properties Decorations (KKF.UI + ox_lib/ox_target/ox_inventory)

-- Helper: get player object
local function GetPlayer(src)
    return ESX.GetPlayerFromId(src)
end

-- Helper: get property data from database
local function GetPropertyData(id)
    local result = MySQL.query.await('SELECT * FROM properties WHERE id = ?', { id })
    return result[1]
end

-- Request decorations for a property
lib.callback.register('kk-properties2:requestDecorations', function(source, propertyId)
    local property = GetPropertyData(propertyId)
    if property and property.props then
        return json.decode(property.props)
    end
    return {}
end)

-- Place spawned object
RegisterNetEvent('kk-properties2:server:placeSpawnedObject', function(propertyId, model, coords, rotation, durability)
    local src = source
    local Player = GetPlayer(src)
    if not Player then return end

    local property = GetPropertyData(propertyId)
    if not property then
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'Kinnisvara ei leitud!', 5000, 'error')
        return
    end

    local owner = json.decode(property.owner) or {}
    local hasKeys = MySQL.query.await('SELECT * FROM property_keys WHERE property_id = ? AND citizenid = ?', { propertyId, Player.identifier })
    if not (owner.type == 'person' and owner.identifier == Player.identifier) and #hasKeys == 0 then
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'Sul ei ole õigust siia esemeid paigutada!', 5000, 'error')
        return
    end

    if Player.removeInventoryItem(model, 1) then
        local props = json.decode(property.props) or {}
        local permanentId = tostring(os.time()) .. math.random(1000, 9999)
        table.insert(props, {
            model = model,
            position = { x = coords.x, y = coords.y, z = coords.z, rotx = rotation.x, roty = rotation.y, rotz = rotation.z },
            permanentId = permanentId,
            dura = durability
        })
        MySQL.update.await('UPDATE properties SET props = ? WHERE id = ?', { json.encode(props), propertyId })
        TriggerClientEvent('kk-properties2:client:loadDecorations', -1, propertyId, props)
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'Ese paigutatud edukalt!', 5000, 'success')
    else
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'Sul ei ole seda eset inventaris!', 5000, 'error')
    end
end)

-- Remove placed object
RegisterNetEvent('kk-properties2:server:removePlacedObject', function(propertyId, permanentId)
    local src = source
    local Player = GetPlayer(src)
    local property = GetPropertyData(propertyId)
    if not property then
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'Kinnisvara ei leitud!', 5000, 'error')
        return
    end

    local owner = json.decode(property.owner) or {}
    if not owner or (owner.type == 'person' and owner.identifier ~= Player.identifier) then
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'Sa ei oma seda kinnisvara!', 5000, 'error')
        return
    end

    local props = json.decode(property.props) or {}
    for i, prop in ipairs(props) do
        if prop.permanentId == permanentId then
            table.remove(props, i)
            MySQL.update.await('UPDATE properties SET props = ? WHERE id = ?', { json.encode(props), propertyId })
            TriggerClientEvent('kk-properties2:client:removeProp', -1, propertyId, permanentId)
            TriggerClientEvent('KKF.UI.ShowNotification', src, 'Ese eemaldatud edukalt!', 5000, 'success')
            break
        end
    end
end)
