RegisterNetEvent('KKF.Player.Loaded', function(playerData)
	ESX.PlayerData = playerData
end)

RegisterNetEvent('KKF.Player.ReloadLicenses', function(licenses)
	ESX.PlayerData.licenses = licenses
end)

CreateThread(function()
    while true do
        wait = 500

        if cache.vehicle and cache.seat == -1 then
            if not ESX.PlayerData.licenses['dmv'] then
                if not exports['kk-dmv']:drivingTest() then
                    if not exports['kk-faultpoints']:drivingTest() then
                        Wait(math.random(5000, 10000))

                        SetVehicleHandbrake(cache.vehicle, true)
                        Wait(math.random(1000))
                        SetVehicleHandbrake(cache.vehicle, false)

                    else
                        wait = 1000
                    end
                else
                    wait = 1000
                end
            else
                wait = 1000
            end
        else
            wait = 1000
        end

        Wait(wait)
    end
end)