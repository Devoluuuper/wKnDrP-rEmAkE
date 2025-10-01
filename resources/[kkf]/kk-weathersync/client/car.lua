function vehicleTemp(currentWeather)
    if cache.vehicle and cfg.vehicleTempEnabled then
        local currentTemperature = GetVehicleEngineTemperature(cache.vehicle)

        if currentTemperature < currentWeather.temperature then
            SetVehicleEngineTemperature(cache.vehicle, currentTemperature + (currentWeather.temperature - currentTemperature) / 100)
        end
    end
end

function vehicleCleaning(currentWeather)
    if cache.vehicle and cfg.vehicleCleaningEnabled then
        if cfg.includesRain[currentWeather.weather] then
            local dirtLevel = GetVehicleDirtLevel(cache.vehicle)

            if dirtLevel > 0 then
                SetVehicleDirtLevel(cache.vehicle, 0)
            end
        end
    end
end