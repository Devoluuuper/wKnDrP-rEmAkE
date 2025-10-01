local weatherFrozen = false
local currentWeather = {
    weather = 'EXTRASUNNY',
    windSpeed = 0,
    windDir = 0,
    rainLevel = 0,
    temperature = 0
}

local function setWeather(weather, skipFreeze)
    if not weather then
        print("Error: weather is nil")
        return
    end

    if weatherFrozen and not skipFreeze then
        return
    end

    local windDir = weather.windDir

    if windDir ~= nil then
        windDir = math.floor(windDir)
    end

    if currentWeather.weather ~= weather.weather then
        SetWeatherTypeOvertimePersist(weather.weather, cfg.overrideTime)
        Wait(cfg.overrideTime * 1000)
        currentWeather = weather
    end

    ClearOverrideWeather()
    ClearWeatherTypePersist()

    SetWeatherTypePersist(currentWeather.weather)
    SetWeatherTypeNow(currentWeather.weather)
    SetWeatherTypeNowPersist(currentWeather.weather)
    SetForceVehicleTrails(cfg.includesSnow[currentWeather.weather])
    SetForcePedFootstepsTracks(cfg.includesSnow[currentWeather.weather])

    if cfg.removeFog then
        SetTimecycleModifier('CS1_railwayB_tunnel')
    end

    if cfg.includesRain[weather.weather] then
        SetRainFxIntensity(weather.rainLevel)
    end

    SetWindSpeed(weather.windSpeed)
    SetWindDirection(windDir)
end

RegisterNetEvent('kk-weathersync:client:syncWeather', setWeather)

SetInterval(function()
    if currentWeather then
        vehicleCleaning(currentWeather)
        vehicleTemp(currentWeather)
    else
        print("Warning: currentWeather is nil")
    end
end, 30000)

exports('freezeWeather', function(freeze, freezeAt)
    weatherFrozen = freeze

    if weatherFrozen and freezeAt then
        local temperature = cfg.temperatureRanges[freezeAt] or {80, 100}

        setWeather({
            weather = freezeAt,
            windSpeed = 0,
            windDir = 0,
            rainLevel = -1,
            temperature = math.random(temperature[1], temperature[2])
        })
        
        return
    end

    if not weatherFrozen then
        TriggerServerEvent('kk-weathersync:server:requestClientSync')
    end
end)