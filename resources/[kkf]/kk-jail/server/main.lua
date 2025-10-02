
local cfg = require('config') -- Adjust this to your config file path or method

-- Player clothes storage
local playerClothes = {}

-- Register server callback for saving clothes
lib.callback.register('kk-jail:saveClothes', function(source, cb, clothes)
    local xPlayer = KKF.GetPlayerFromId(source)
    if xPlayer then
        playerClothes[source] = clothes
        cb(true)
    else
        cb(false)
    end
end)

-- Register server callback for restoring clothes
lib.callback.register('kk-jail:restoreClothes', function(source, cb)
    local xPlayer = KKF.GetPlayerFromId(source)
    if xPlayer and playerClothes[source] then
        cb(playerClothes[source])
        playerClothes[source] = nil -- Clear after restoring
    else
        cb(false)
    end
end)

-- Register server callback for checking if a chair is occupied
lib.callback.register('kk-jail:sitDown', function(source, cb, chairId)
    local occupied = MySQL.Sync.fetchScalar('SELECT occupied FROM jail_chairs WHERE chair_id = ?', {chairId})
    if not occupied then
        MySQL.Sync.execute('INSERT INTO jail_chairs (chair_id, occupied) VALUES (?, ?) ON DUPLICATE KEY UPDATE occupied = ?', {chairId, 1, 1})
        cb(true)
    else
        cb(false)
    end
end)

-- Event to leave chair
RegisterNetEvent('kk-jail:server:leaveChair')
AddEventHandler('kk-jail:server:leaveChair', function(chairId)
    MySQL.Sync.execute('UPDATE jail_chairs SET occupied = 0 WHERE chair_id = ?', {chairId})
end)

-- Event to confiscate items
RegisterNetEvent('kk-jail:server:confiscateItems')
AddEventHandler('kk-jail:server:confiscateItems', function()
    local xPlayer = KKF.GetPlayerFromId(source)
    if xPlayer then
        local inventory = exports.ox_inventory:Inventory(source)
        local confiscatedItems = {}

        -- Store all items in a temporary table
        for _, item in pairs(inventory.items) do
            if item.count > 0 then
                table.insert(confiscatedItems, {name = item.name, count = item.count, metadata = item.metadata})
                exports.ox_inventory:RemoveItem(source, item.name, item.count)
            end
        end

        -- Save confiscated items to database
        MySQL.Sync.execute('INSERT INTO jail_confiscated_items (identifier, items) VALUES (?, ?)', {
            xPlayer.identifier,
            json.encode(confiscatedItems)
        })
    end
end)

-- Event to return confiscated items
RegisterNetEvent('kk-jail:server:recieveConfiscatedItems')
AddEventHandler('kk-jail:server:recieveConfiscatedItems', function()
    local xPlayer = KKF.GetPlayerFromId(source)
    if xPlayer then
        local items = MySQL.Sync.fetchScalar('SELECT items FROM jail_confiscated_items WHERE identifier = ?', {xPlayer.identifier})
        if items then
            items = json.decode(items)
            for _, item in pairs(items) do
                exports.ox_inventory:AddItem(source, item.name, item.count, item.metadata)
            end
            MySQL.Sync.execute('DELETE FROM jail_confiscated_items WHERE identifier = ?', {xPlayer.identifier})
        end
    end
end)

-- Event to start cleaning job
RegisterNetEvent('kk-jail:server:startCleaning')
AddEventHandler('kk-jail:server:startCleaning', function()
    local xPlayer = KKF.GetPlayerFromId(source)
    if xPlayer then
        -- Add logic for starting cleaning job (e.g., set a flag in the database)
        MySQL.Sync.execute('UPDATE users SET is_cleaning = 1 WHERE identifier = ?', {xPlayer.identifier})
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'info', 'Alustasid koristamist!')
    end
end)

-- Event to end cleaning job
RegisterNetEvent('kk-jail:server:endCleaning')
AddEventHandler('kk-jail:server:endCleaning', function()
    local xPlayer = KKF.GetPlayerFromId(source)
    if xPlayer then
        -- End cleaning job and optionally reward the player
        MySQL.Sync.execute('UPDATE users SET is_cleaning = 0 WHERE identifier = ?', {xPlayer.identifier})
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'info', 'Lõpetasid koristamise!')
        -- Optionally reward the player
        xPlayer.addMoney('money', 100) -- Adjust reward as needed
    end
end)

-- -- Command to jail a player
-- KKF.RegisterCommand('jail', 'admin', function(xPlayer, args, showError)
--     local targetId = tonumber(args[1])
--     local time = tonumber(args[2])
--     local xTarget = KKF.GetPlayerFromId(targetId)

--     if not xTarget then
--         xPlayer.showNotification('Mängijat ei leitud!')
--         return
--     end

--     if not time or time <= 0 then
--         xPlayer.showNotification('Palun sisesta kehtiv vanglaaeg!')
--         return
--     end

--     -- Save jail time to users table
--     MySQL.Sync.execute('UPDATE users SET jail_time = ?, is_cleaning = 0 WHERE identifier = ?', {
--         time,
--         xTarget.identifier
--     })

--     -- Trigger client event to jail the player
--     TriggerClientEvent('kk-jail:client:jailPerson', xTarget.source, time, false, true)
-- end, true, {help = 'Pane mängija vangi', validate = true, arguments = {
--     {name = 'id', help = 'Mängija ID', type = 'number'},
--     {name = 'time', help = 'Vanglaaeg kuudes', type = 'number'}
-- }})

-- KKF.RegisterCommand('unjail', 'admin', function(xPlayer, args, showError)
--     local targetId = tonumber(args[1])
--     local xTarget = KKF.GetPlayerFromId(targetId)

--     if not xTarget then
--         xPlayer.showNotification('Mängijat ei leitud!')
--         return
--     end

--     MySQL.Sync.execute('UPDATE users SET jail_time = 0, is_cleaning = 0 WHERE identifier = ?', {xTarget.identifier})
--     TriggerClientEvent('kk-jail:client:endJail', xTarget.source)
--     xPlayer.showNotification('Mängija vabastati vanglast!')
-- end, true, {help = 'Eemalda mängija vanglast', validate = true, arguments = {
--     {name = 'id', help = 'Mängija ID', type = 'number'}
-- }})

AddEventHandler('KKF:playerLoaded', function(playerId, xPlayer)
    local result = MySQL.Sync.fetchSingle('SELECT jail_time FROM users WHERE identifier = ?', {xPlayer.identifier})
    if result and result.jail_time > 0 then
        TriggerClientEvent('kk-jail:client:jailPerson', playerId, result.jail_time, true, false)
    end
end)

-- Clear jail status on player disconnect (optional)
AddEventHandler('KKF:playerDropped', function(playerId)
    local xPlayer = KKF.GetPlayerFromId(playerId)
    if xPlayer then
        -- Optionally, keep jail time in database for persistence
        -- MySQL.Sync.execute('UPDATE users SET jail_time = 0, is_cleaning = 0 WHERE identifier = ?', {xPlayer.identifier})
    end
end)

-- Timer to reduce jail time
CreateThread(function()
    while true do
        Wait(60000) -- Check every minute
        local result = MySQL.Sync.fetchAll('SELECT identifier, jail_time FROM users WHERE jail_time > 0')
        for _, row in ipairs(result) do
            local newTime = row.jail_time - 1
            if newTime <= 0 then
                MySQL.Sync.execute('UPDATE users SET jail_time = 0, is_cleaning = 0 WHERE identifier = ?', {row.identifier})
                local xPlayer = KKF.GetPlayerFromIdentifier(row.identifier)
                if xPlayer then
                    TriggerClientEvent('kk-jail:client:endJail', xPlayer.source)
                end
            else
                MySQL.Sync.execute('UPDATE users SET jail_time = ? WHERE identifier = ?', {newTime, row.identifier})
                local xPlayer = KKF.GetPlayerFromIdentifier(row.identifier)
                if xPlayer then
                    TriggerClientEvent('chatMessage', xPlayer.source, 'DOC', 'info', 'Teil on jäänud ' .. newTime .. ' kuud vanglas.')
                end
            end
        end
    end
end)

-- Export to check if player is cleaning
exports('isCleaning', function(source)
    local xPlayer = KKF.GetPlayerFromId(source)
    if xPlayer then
        local result = MySQL.Sync.fetchScalar('SELECT is_cleaning FROM users WHERE identifier = ?', {xPlayer.identifier})
        return result == 1
    end
    return false
end)