
local function GetPlayer(src)
    return ESX.GetPlayerFromId(src)
end

local function GetPropertyData(id)
    local result = MySQL.query.await('SELECT * FROM properties WHERE id = ?', { id })
    return result[1]
end

lib.callback.register('kk-properties2:fetchBuyable', function(source)
    return MySQL.query.await('SELECT id, label, price, image FROM properties WHERE owner IS NULL')
end)

lib.callback.register('kk-properties2:buyProperty', function(source, propertyId)
    local Player = GetPlayer(source)
    if not Player then return false end

    local citizenid = Player.identifier
    local property = GetPropertyData(propertyId)

    if not property then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Kinnisvara ei leitud!', 5000, 'error')
        return false
    end

    if property.owner then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'See kinnisvara on juba omaniku all!', 5000, 'error')
        return false
    end

    if Player.removeAccountMoney('bank', property.price) then
        MySQL.update.await('UPDATE properties SET owner = ? WHERE id = ?', { json.encode({ type = 'person', identifier = citizenid }), propertyId })
        TriggerClientEvent('kk-properties2:client:updateOwner', -1, propertyId, { type = 'person', identifier = citizenid })
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Kinnisvara ost edukalt sooritatud!', 5000, 'success')
        return true
    else
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Sul ei ole piisavalt raha!', 5000, 'error')
        return false
    end
end)

RegisterNetEvent('kk-properties2:server:sellProperty', function(propertyId, targetCitizenId, price)
    local src = source
    local Player = GetPlayer(src)
    if not Player then return end

    local citizenid = Player.identifier
    local property = GetPropertyData(propertyId)
    if not property then
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'Kinnisvara ei leitud!', 5000, 'error')
        return
    end

    local owner = json.decode(property.owner)
    if not owner or owner.identifier ~= citizenid then
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'Sa ei oma seda kinnisvara!', 5000, 'error')
        return
    end

    local targetPlayer = ESX.GetPlayerFromIdentifier(targetCitizenId)
    if not targetPlayer then
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'Sihtmängijat ei leitud!', 5000, 'error')
        return
    end

    TriggerClientEvent('kk-properties2:client:sellTarget', targetPlayer.source, price)
    TriggerClientEvent('KKF.UI.ShowNotification', src, 'Kinnisvara müügipakkumine saadetud!', 5000, 'success')
end)

RegisterNetEvent('kk-properties2:server:acceptProperty', function()
    local src = source
    local Player = GetPlayer(src)
    if not Player then return end

    local citizenid = Player.identifier
    local propertyId = Player.get('currentProperty')
    local property = GetPropertyData(propertyId)

    if not property then
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'Kinnisvara ei leitud!', 5000, 'error')
        return
    end

    if Player.removeAccountMoney('bank', property.price) then
        MySQL.update.await('UPDATE properties SET owner = ? WHERE id = ?', { json.encode({ type = 'person', identifier = citizenid }), propertyId })
        TriggerClientEvent('kk-properties2:client:updateOwner', -1, propertyId, { type = 'person', identifier = citizenid })
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'Kinnisvara ost edukalt sooritatud!', 5000, 'success')
    else
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'Sul ei ole piisavalt raha!', 5000, 'error')
    end
end)

RegisterNetEvent('kk-properties2:server:declineProperty', function()
    TriggerClientEvent('KKF.UI.ShowNotification', source, 'Kinnisvara ost tagasi lükatud.', 5000, 'error')
end)

ESX.RegisterCommand('revokeProperty', 'admin', function(xPlayer, args, showError)
    local propertyId = tonumber(args[1])
    local Player = GetPlayer(xPlayer.source)
    if not Player then return end

    local property = GetPropertyData(propertyId)
    if not property then
        TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'Kinnisvara ei leitud!', 5000, 'error')
        return
    end

    local owner = json.decode(property.owner)
    if not owner or (owner.type == 'person' and owner.identifier ~= Player.identifier) then
        TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'Sa ei oma seda kinnisvara!', 5000, 'error')
        return
    end

    MySQL.update.await('UPDATE properties SET owner = NULL, `key` = NULL WHERE id = ?', { propertyId })
    MySQL.query.await('DELETE FROM property_keys WHERE property_id = ?', { propertyId })
    TriggerClientEvent('kk-properties2:client:updateOwner', -1, propertyId, nil)
    TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'Kinnisvara omandiõigus tühistatud!', 5000, 'success')
end, false, {help = 'Tühista kinnisvara omandiõigus', validate = true, arguments = {
    {name = 'id', help = 'Kinnisvara ID', type = 'number'}
}})
