-- Server-side script for weather and time synchronization

-- Configuration (assumed to be defined in a shared config file)
-- Example cfg structure:
-- cfg = {
--     overrideTime = 15, -- Time in seconds for weather transitions
--     includesSnow = { ['BLIZZARD'] = true, ['SNOW'] = true },
--     includesRain = { ['RAIN'] = true, ['THUNDER'] = true },
--     removeFog = true,
--     temperatureRanges = { ['EXTRASUNNY'] = {70, 90}, ['RAIN'] = {50, 70} },
--     secondsPerMinute = 2, -- Seconds per in-game minute
--     weatherTypes = { 'EXTRASUNNY', 'CLEAR', 'RAIN', 'THUNDER', 'SNOW', 'BLIZZARD' },
--     weatherChangeInterval = 600000 -- 10 minutes in milliseconds
-- }

-- Server state
local weatherFrozen = false
local currentWeather = {
    weather = 'EXTRASUNNY',
    windSpeed = 0.0,
    windDir = 0,
    rainLevel = 0.0,
    temperature = 80
}
local timeFrozen = false
local currentTime = 0 -- Time in minutes (0 to 1439)

-- Function to broadcast weather to all clients
local function broadcastWeather()
    TriggerClientEvent('kk-weathersync:client:syncWeather', -1, currentWeather)
end

-- Function to broadcast time to all clients
local function broadcastTime()
    TriggerClientEvent('kk-weathersync:client:syncTime', -1, currentTime)
end

-- Handle client sync request
RegisterNetEvent('kk-weathersync:server:requestClientSync')
AddEventHandler('kk-weathersync:server:requestClientSync', function()
    local source = source -- Player who requested sync
    TriggerClientEvent('kk-weathersync:client:syncWeather', source, currentWeather)
    TriggerClientEvent('kk-weathersync:client:syncTime', source, currentTime)
end)

-- Function to randomly select a new weather type
local function getRandomWeather()
    local weatherType = cfg.weatherTypes[math.random(1, #cfg.weatherTypes)]
    local temperatureRange = cfg.temperatureRanges[weatherType] or {70, 90}
    return {
        weather = weatherType,
        windSpeed = math.random(0, 50) / 10.0, -- Random wind speed between 0 and 5.0
        windDir = math.random(0, 359), -- Random wind direction
        rainLevel = cfg.includesRain[weatherType] and math.random(0, 10) / 10.0 or 0.0, -- Rain level for rain-compatible weather
        temperature = math.random(temperatureRange[1], temperatureRange[2])
    }
end

-- Weather update loop
CreateThread(function()
    while true do
        Wait(cfg.weatherChangeInterval or 600000) -- Default to 10 minutes
        if not weatherFrozen then
            currentWeather = getRandomWeather()
            broadcastWeather()
        end
    end
end)

-- Time update loop
CreateThread(function()
    while true do
        Wait((cfg.secondsPerMinute or 2) * 1000) -- Seconds per in-game minute
        if not timeFrozen then
            currentTime = currentTime + 1
            if currentTime >= 1440 then
                currentTime = 0
            end
            broadcastTime()
        end
    end
end)

-- Export to freeze/unfreeze weather
exports('freezeWeather', function(freeze, freezeAt)
    weatherFrozen = freeze
    if weatherFrozen and freezeAt then
        local temperatureRange = cfg.temperatureRanges[freezeAt] or {80, 100}
        currentWeather = {
            weather = freezeAt,
            windSpeed = 0.0,
            windDir = 0,
            rainLevel = cfg.includesRain[freezeAt] and math.random(0, 10) / 10.0 or -1.0,
            temperature = math.random(temperatureRange[1], temperatureRange[2])
        }
        broadcastWeather()
    elseif not weatherFrozen then
        currentWeather = getRandomWeather()
        broadcastWeather()
    end
end)

-- Export to freeze/unfreeze time
exports('freezeTime', function(freeze, freezeAt)
    timeFrozen = freeze
    if timeFrozen and freezeAt then
        currentTime = freezeAt % 1440 -- Ensure time is within 0-1439
        broadcastTime()
    elseif not timeFrozen then
        -- Optionally sync with real-world time or another source
        broadcastTime()
    end
end)

-- Command to freeze weather (for admin use)
RegisterCommand('freezeweather', function(source, args)
    if source == 0 or IsPlayerAceAllowed(source, 'kk-weathersync.admin') then
        local freezeAt = args[1] and string.upper(args[1]) or nil
        exports['kk-weathersync']:freezeWeather(true, freezeAt)
        TriggerClientEvent('chat:addMessage', source, { args = { 'WeatherSync', freezeAt and ('Weather frozen to ' .. freezeAt) or 'Weather frozen' } })
    else
        TriggerClientEvent('chat:addMessage', source, { args = { 'WeatherSync', 'Insufficient permissions' } })
    end
end, false)

-- Command to unfreeze weather (for admin use)
RegisterCommand('unfreezeweather', function(source)
    if source == 0 or IsPlayerAceAllowed(source, 'kk-weathersync.admin') then
        exports['kk-weathersync']:freezeWeather(false)
        TriggerClientEvent('chat:addMessage', source, { args = { 'WeatherSync', 'Weather unfrozen' } })
    else
        TriggerClientEvent('chat:addMessage', source, { args = { 'WeatherSync', 'Insufficient permissions' } })
    end
end, false)

-- Command to freeze time (for admin use)
RegisterCommand('freezetime', function(source, args)
    if source == 0 or IsPlayerAceAllowed(source, 'kk-weathersync.admin') then
        local freezeAt = args[1] and tonumber(args[1]) or nil
        exports['kk-weathersync']:freezeTime(true, freezeAt)
        TriggerClientEvent('chat:addMessage', source, { args = { 'WeatherSync', freezeAt and ('Time frozen to ' .. freezeAt) or 'Time frozen' } })
    else
        TriggerClientEvent('chat:addMessage', source, { args = { 'WeatherSync', 'Insufficient permissions' } })
    end
end, false)

-- Command to unfreeze time (for admin use)
RegisterCommand('unfreezetime', function(source)
    if source == 0 or IsPlayerAceAllowed(source, 'kk-weathersync.admin') then
        exports['kk-weathersync']:freezeTime(false)
        TriggerClientEvent('chat:addMessage', source, { args = { 'WeatherSync', 'Time unfrozen' } })
    else
        TriggerClientEvent('chat:addMessage', source, { args = { 'WeatherSync', 'Insufficient permissions' } })
    end
end, false)