
local hotPlates = {}
local hotPlatesReason = {}

-- Function to check if player is police
local function isPlayerPolice(source)
    local xPlayer = KKF.GetPlayerFromId(source)
    return xPlayer and xPlayer.job.name == 'police' and xPlayer.job.onDuty
end

-- Load radar settings for a player
lib.callback.register('kk-radar:loadSettings', function(source)
    local xPlayer = KKF.GetPlayerFromId(source)
    if not xPlayer or not isPlayerPolice(source) then
        return cfg.defaultSettings
    end

    -- Load settings from database (using oxmysql)
    local result = MySQL.query.await('SELECT radar_settings FROM users WHERE identifier = ?', { xPlayer.identifier })
    if result[1] and result[1].radar_settings then
        -- Parse JSON settings from database
        local settings = json.decode(result[1].radar_settings)
        return settings or cfg.defaultSettings
    else
        return cfg.defaultSettings
    end
end)

-- Save radar settings for a player
RegisterNetEvent('kk-radar:server:saveSettings')
AddEventHandler('kk-radar:server:saveSettings', function(settings)
    local source = source
    local xPlayer = KKF.GetPlayerFromId(source)
    if not xPlayer or not isPlayerPolice(source) then
        return
    end

    -- Validate settings to prevent malformed data
    local validatedSettings = {}
    for k, v in pairs(cfg.defaultSettings) do
        validatedSettings[k] = settings[k] or v
    end

    -- Save to database
    MySQL.query.await('UPDATE users SET radar_settings = ? WHERE identifier = ?', {
        json.encode(validatedSettings),
        xPlayer.identifier
    })
end)

-- Check license plate against hot plates
RegisterNetEvent('checkLicensePlate')
AddEventHandler('checkLicensePlate', function(plate)
    local source = source
    local xPlayer = KKF.GetPlayerFromId(source)
    if not xPlayer or not isPlayerPolice(source) then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'You are not authorized to check plates.')
        return
    end

    if not plate or plate == '' or plate == 'N/A' then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'No valid plate provided.')
        return
    end

    local upperPlate = string.upper(plate)
    local lowerPlate = string.lower(plate)
    local isHot = hotPlates[upperPlate] or hotPlates[lowerPlate] or hotPlates[plate]

    if isHot then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Hot plate detected: ' .. plate .. ' - Reason: ' .. (hotPlatesReason[plate] or 'Unknown'))
        TriggerClientEvent('radar:alarm', source) -- Trigger alarm on client
    else
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'info', 'Plate ' .. plate .. ' is not listed as hot.')
    end
end)

-- Update hot plates and reasons
RegisterNetEvent('updateHotPlates')
AddEventHandler('updateHotPlates', function(newPlates, newReasons)
    local source = source
    local xPlayer = KKF.GetPlayerFromId(source)
    if not xPlayer or not isPlayerPolice(source) then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'You are not authorized to update hot plates.')
        return
    end

    -- Validate and update hot plates
    if type(newPlates) == 'table' and type(newReasons) == 'table' then
        hotPlates = newPlates
        hotPlatesReason = newReasons
        -- Optionally save to database if persistent storage is needed
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'success', 'Hot plates updated successfully.')
        -- Broadcast to all police clients
        local xPlayers = KKF.GetPlayers()
        for _, playerId in ipairs(xPlayers) do
            if isPlayerPolice(playerId) then
                TriggerClientEvent('updateHotPlates', playerId, hotPlates, hotPlatesReason)
            end
        end
    else
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Invalid hot plate data.')
    end
end)


-- Sync hot plates when a player logs in or job changes
AddEventHandler('KKF:playerLoaded', function(playerId, xPlayer)
    if isPlayerPolice(playerId) then
        TriggerClientEvent('updateHotPlates', playerId, hotPlates, hotPlatesReason)
    end
end)

AddEventHandler('KKF:setJob', function(playerId, job, lastJob)
    if job.name == 'police' and job.onDuty then
        TriggerClientEvent('updateHotPlates', playerId, hotPlates, hotPlatesReason)
    end
end)