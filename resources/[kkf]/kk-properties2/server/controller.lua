
local function GetPlayer(src)
    return ESX.GetPlayerFromId(src)
end

-- Kõikide kinnisvara objektide laadimine
lib.callback.register('kk-properties2:fetchLocations', function(source)
    local properties = MySQL.query.await('SELECT * FROM properties')
    for _, property in ipairs(properties) do
        property.owner = json.decode(property.owner) or nil
        property.zone = json.decode(property.zone) or {}
        property.panel = json.decode(property.panel) or {}
        property.garage = json.decode(property.garage) or nil
        property.props = json.decode(property.props) or {}
        property.type = property.type or 'unknown'
        property.level = tonumber(property.level) or 1
        property.crypto = tonumber(property.crypto) or 0
    end
    return properties
end)

-- Kontrolli, kas mängijal on võtmed
lib.callback.register('kk-properties2:hasKeys', function(source, propertyId)
    local xPlayer = GetPlayer(source)
    local citizenid = xPlayer.identifier
    local keys = MySQL.query.await('SELECT * FROM property_keys WHERE property_id = ? AND citizenid = ?', { propertyId, citizenid })
    return #keys > 0
end)

-- Osta uus võti
RegisterNetEvent('kk-properties2:server:newKey', function(propertyId)
    local src = source
    local xPlayer = GetPlayer(src)
    local citizenid = xPlayer.identifier
    local property = GetPropertyData(propertyId)

    if not property then
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'Kinnisvara ei leitud!')
        return
    end

    if not property.owner or property.owner.identifier ~= citizenid then
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'Sa ei oma seda kinnisvara!')
        return
    end

    if xPlayer.getAccount('bank').money >= cfg.keyPrice then
        xPlayer.removeAccountMoney('bank', cfg.keyPrice)
        MySQL.insert.await('INSERT INTO property_keys (property_id, citizenid) VALUES (?, ?)', { propertyId, citizenid })
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'Võti ostetud edukalt!')
    else
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'Sul ei ole piisavalt raha!')
    end
end)

-- Uue luku ost
RegisterNetEvent('kk-properties2:server:newLock', function(propertyId)
    local src = source
    local xPlayer = GetPlayer(src)
    local citizenid = xPlayer.identifier
    local property = GetPropertyData(propertyId)

    if not property then
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'Kinnisvara ei leitud!')
        return
    end

    if not property.owner or property.owner.identifier ~= citizenid then
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'Sa ei oma seda kinnisvara!')
        return
    end

    if xPlayer.getAccount('bank').money >= cfg.lockPrice then
        xPlayer.removeAccountMoney('bank', cfg.lockPrice)
        local newKey = math.random(100000, 999999)
        MySQL.update.await('UPDATE properties SET `key` = ? WHERE id = ?', { newKey, propertyId })
        MySQL.query.await('DELETE FROM property_keys WHERE property_id = ?', { propertyId })
        TriggerClientEvent('kk-properties2:client:updateLock', -1, propertyId, newKey)
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'Lukk vahetatud edukalt!')
    else
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'Sul ei ole piisavalt raha!')
    end
end)

-- Arve tasumine
lib.callback.register('kk-properties2:payBill', function(source, propertyId, billId)
    local xPlayer = GetPlayer(source)
    local bill = MySQL.query.await('SELECT * FROM property_bills WHERE id = ? AND property_id = ?', { billId, propertyId })

    if not bill[1] then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Arvet ei leitud!')
        return false
    end

    if xPlayer.getAccount('bank').money >= bill[1].amount then
        xPlayer.removeAccountMoney('bank', bill[1].amount)
        MySQL.query.await('DELETE FROM property_bills WHERE id = ?', { billId })
        MySQL.insert.await('INSERT INTO property_logs (property_id, citizenid, text, time) VALUES (?, ?, ?, ?)', 
            { propertyId, xPlayer.identifier, 'Arve tasumine #' .. billId, os.time() })
        return true
    else
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Sul ei ole piisavalt raha arve tasumiseks!')
        return false
    end
end)

-- Kinnisvara logid
lib.callback.register('kk-properties2:getLogs', function(source, propertyId)
    local xPlayer = GetPlayer(source)
    local citizenid = xPlayer.identifier
    local property = GetPropertyData(propertyId)
    if not property then return {} end

    local owner = property.owner
    if not owner or (owner.type == 'person' and owner.identifier ~= citizenid) then
        return {}
    end

    local result = MySQL.query.await('SELECT * FROM property_logs WHERE property_id = ?', { propertyId })
    local logs = {}
    for _, row in ipairs(result) do
        local fullname = row.citizenid
        local char = MySQL.single.await('SELECT charinfo FROM players WHERE citizenid = ?', { row.citizenid })
        if char then
            local charinfo = json.decode(char.charinfo)
            fullname = charinfo.firstname .. " " .. charinfo.lastname
        end
        table.insert(logs, {
            name = fullname,
            text = row.text,
            time = os.date("%d.%m.%Y %H:%M:%S", row.time or os.time())
        })
    end
    return logs
end)

-- Kinnisvara arved
lib.callback.register('kk-properties2:getBills', function(source, propertyId)
    local xPlayer = GetPlayer(source)
    local citizenid = xPlayer.identifier
    local property = GetPropertyData(propertyId)
    if not property then return {} end

    local owner = property.owner
    if not owner or (owner.type == 'person' and owner.identifier ~= citizenid) then
        return {}
    end

    return MySQL.query.await('SELECT * FROM property_bills WHERE property_id = ?', { propertyId })
end)

-- Warehouse and crypto callbacks
lib.callback.register('kk-properties2:getWarehouse', function(source, propertyId)
    local property = GetPropertyData(propertyId)
    if not property or property.type ~= 'warehouse' then
        print('^1[kk-properties2] Vale warehouse ID:', propertyId, '^7')
        return nil
    end

    local shopItems = {}
    for _, item in pairs(cfg.objects) do
        table.insert(shopItems, item)
    end

    return {
        crypto = property.crypto or 0,
        computers = property.computers or 0,
        earnings = property.earnings or 0,
        level = property.level or 1,
        durabilityInterval = cfg.durabilityInterval or 144,
        shop = shopItems,
        missions = {}
    }
end)

-- Insert/Send crypto callbacks
lib.callback.register('kk-properties2:sendCryptoToFaction', function(source, propertyId, count)
    local xPlayer = GetPlayer(source)
    local property = GetPropertyData(propertyId)

    if not property or property.type ~= 'warehouse' then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Vale warehouse!')
        return false
    end

    local owner = property.owner
    if not owner or owner.type ~= 'faction' or owner.identifier ~= xPlayer.job.name then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Sul ei ole luba!')
        return false
    end

    if (property.crypto or 0) < count then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Warehouse-s ei ole piisavalt crypto!')
        return false
    end

    MySQL.update.await('UPDATE properties SET crypto = crypto - ? WHERE id = ?', { count, propertyId })
    TriggerClientEvent('kk-properties2:client:updateCrypto', -1, propertyId, (property.crypto or 0) - count)
    return { crypto = (property.crypto or 0) - count, count = count }
end)

lib.callback.register('kk-properties2:factionCryptoInsert', function(source, propertyId, count)
    local xPlayer = GetPlayer(source)
    local property = GetPropertyData(propertyId)

    if not property or property.type ~= 'warehouse' then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Vale warehouse!')
        return false
    end

    local owner = property.owner
    if not owner or owner.type ~= 'faction' or owner.identifier ~= xPlayer.job.name then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Sul ei ole luba!')
        return false
    end

    MySQL.update.await('UPDATE properties SET crypto = crypto + ? WHERE id = ?', { count, propertyId })
    TriggerClientEvent('kk-properties2:client:updateCrypto', -1, propertyId, (property.crypto or 0) + count)
    return { crypto = (property.crypto or 0) + count, count = count }
end)

-- Warehouse taseme tõstmine
lib.callback.register('kk-properties2:levelUp', function(source, propertyId)
    local xPlayer = GetPlayer(source)
    local property = GetPropertyData(propertyId)

    if not property or property.type ~= 'warehouse' then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Vale warehouse!')
        return false
    end

    local owner = property.owner
    if not owner or (owner.type == 'person' and owner.identifier ~= xPlayer.identifier) then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Sa ei oma seda kinnisvara!')
        return false
    end

    local level = property.level or 1
    if level >= 3 then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Warehouse on juba maksimaalsel tasemel!')
        return false
    end

    local cost = 10000 * (level + 1)
    if xPlayer.getAccount('bank').money >= cost then
        xPlayer.removeAccountMoney('bank', cost)
        MySQL.update.await('UPDATE properties SET level = ? WHERE id = ?', { level + 1, propertyId })
        TriggerClientEvent('kk-properties2:client:updateLevel', -1, propertyId, level + 1)
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Warehouse tasandatud tasemele ' .. (level + 1) .. '!')
        return level + 1
    else
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Sul ei ole piisavalt raha!')
        return false
    end
end)

-- Kaupade ost ox_inventory-ga
lib.callback.register('kk-properties2:buyShopItem', function(source, data)
    local xPlayer = GetPlayer(source)

    if type(data) ~= 'table' then
        print('^1[kk-properties2] Vale andmete formaat!')
        return { success = false, error = 'Vale andmete formaat' }
    end

    local propertyId = data.propertyId
    local itemIndex = tonumber(data.itemIndex)
    if not propertyId or not itemIndex then
        return { success = false, error = 'Missing propertyId or itemIndex' }
    end

    local property = GetPropertyData(propertyId)
    if not property or property.type ~= 'warehouse' then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Vale warehouse!')
        return { success = false, error = 'Vale warehouse' }
    end

    local shopItems = {}
    for _, item in pairs(cfg.objects) do
        table.insert(shopItems, item)
    end
    if itemIndex < 0 or itemIndex >= #shopItems then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Vale item index!')
        return { success = false, error = 'Vale item index' }
    end
    local item = shopItems[itemIndex + 1]

    if (property.level or 1) < (item.level or 1) then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Warehouse tase liiga madal! Nõutud: ' .. (item.level or 1))
        return { success = false, error = 'Warehouse level too low' }
    end

    if (property.crypto or 0) >= (item.price or 0) then
        MySQL.update.await('UPDATE properties SET crypto = crypto - ? WHERE id = ?', { item.price or 0, propertyId })
        exports.ox_inventory:AddItem(source, item.name or item.model, 1)
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Ese ostetud edukalt!')
        return { success = true }
    else
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Warehouse-s ei ole piisavalt crypto!')
        return { success = false, error = 'Not enough crypto' }
    end
end)

-- Abifunktsioon kinnisvara saamiseks
function GetPropertyData(id)
    local result = MySQL.query.await('SELECT * FROM properties WHERE id = ?', { id })
    if result and result[1] then
        local property = result[1]
        property.owner = json.decode(property.owner) or nil
        property.zone = json.decode(property.zone) or {}
        property.panel = json.decode(property.panel) or {}
        property.garage = json.decode(property.garage) or nil
        property.props = json.decode(property.props) or {}
        property.type = property.type or 'unknown'
        property.level = tonumber(property.level) or 1
        property.crypto = tonumber(property.crypto) or 0
        return property
    end
    return nil
end
