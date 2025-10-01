local currentBodyHealth, previousBodyHealth, currentSpeed, previousSpeed, previousVelocity, isSpeeding

Citizen.CreateThread(function()
    while true do
        wait = 1000

        if cache.vehicle and cache.seat == -1 and not IsThisModelABicycle(GetEntityModel(cache.vehicle)) then
            previousSpeed = currentSpeed
            previousBodyHealth = currentBodyHealth

            currentSpeed = GetEntitySpeed(cache.vehicle)
            currentBodyHealth = GetVehicleBodyHealth(cache.vehicle)

            local healthChange = previousBodyHealth ~= nil and (previousBodyHealth - currentBodyHealth) or 0.0
            local heavyImpact = (previousSpeed and previousSpeed > 25.0 and currentSpeed < (previousSpeed * 0.75))
            local minorImpact = ((healthChange >= 4 or currentBodyHealth < 150.0) and HasEntityCollidedWithAnything(cache.vehicle))
			
            if heavyImpact or minorImpact then
                local velocity = (previousSpeed - currentSpeed) * 3.6

                TriggerEvent('baseevents:vehicleCrashed', cache.vehicle, cache.seat, currentSpeed, previousSpeed, velocity, healthChange, heavyImpact, minorImpact)
            end

            if currentSpeed > 28 and not IsSpeeding then
                IsSpeeding = true
                TriggerEvent('baseevents:vehicleSpeeding', true, cache.vehicle, cache.seat, currentSpeed)
            elseif IsSpeeding and currentSpeed < 28 then
                IsSpeeding = false
                TriggerEvent('baseevents:vehicleSpeeding', false, cache.vehicle, cache.seat, currentSpeed)
            end

            wait = 100
        end

        Wait(wait)
    end
end)