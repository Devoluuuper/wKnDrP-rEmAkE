local vehicleModes = {}
local currentLevel = 0
local debug = false

CreateThread(function()
    Wait(150)

    vehicleModes = lib.callback.await('brp-pursuitmodes:getModes')
    DecorRegister('pursuitLevel', 1)
    DecorRegister('hasVehicleEditedByPursuit', false)

    KKF.PlayerData = KKF.GetPlayerData()
end)

RegisterNetEvent('KKF.Player.Loaded', function(xPlayer)
    KKF.PlayerData = xPlayer
end)

RegisterNetEvent('KKF.Player.JobUpdate', function(job)
    KKF.PlayerData.job = job
end)

RegisterNetEvent('KKF.Player.DutyChange', function(value)
    KKF.PlayerData.job.onDuty = value
end)

local function debug_print(msg)
    if debug then print(msg) end
end

RegisterCommand('pursuit', function(source, args)
    if KKF.PlayerData.job.name == 'police' and KKF.PlayerData.job.onDuty then
        local vehicleName = string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(cache.vehicle)))
        local vehiclePresetName = nil
        local vehiclePresetMods = {}
        
        for k, v in pairs(vehicleModes['client']['global']['vehicles']) do
            if v.model == vehicleName then
                vehiclePresetName = v.preset
                for x, y in pairs(vehicleModes['client']['global']['presets']) do
                    if y.id == vehiclePresetName then
                        vehiclePresetMods = y.modes
                        break
                    end
                end
                break
            end
        end

        if not vehiclePresetName then return end
        if currentLevel == #vehiclePresetMods then currentLevel = 0 end
        currentLevel = currentLevel + 1

        local modLevel = vehiclePresetMods[currentLevel]
        SetVehicleXenonLightsColour(cache.vehicle, modLevel.appearance.colors.xenon)
        ToggleVehicleMod(cache.vehicle, modLevel.mods.Turbo)
        SetVehicleMod(cache.vehicle, 11, modLevel.mods.Engine, false)
        SetVehicleMod(cache.vehicle, 12, modLevel.mods.Brakes, false)
        SetVehicleMod(cache.vehicle, 13, modLevel.mods.Transmission, false)
        SetVehicleMod(cache.vehicle, 22, modLevel.mods.XenonHeadlights, false)

        for i = 1, #modLevel.handling do
            if not DecorIsRegisteredAsType(modLevel.handling[i].field, 3) then 
                DecorRegister(modLevel.handling[i].field, 3)
            end

            Citizen.Wait(100)
            local defaultValue = DecorGetFloat(cache.vehicle, modLevel.handling[i].field)

            if defaultValue == 0 then
                defaultValue = GetVehicleHandlingFloat(cache.vehicle, 'CHandlingData', modLevel.handling[i].field)
                DecorSetFloat(cache.vehicle, modLevel.handling[i].field, defaultValue)
            end
        end

        for i = 1, #modLevel.handling do 
            debug_print('Before',GetVehicleHandlingFloat(cache.vehicle, 'CHandlingData', modLevel.handling[i].field))
            SetVehicleHandlingFloat(cache.vehicle, 'CHandlingData', modLevel.handling[i].field, DecorGetFloat(cache.vehicle, modLevel.handling[i].field) * modLevel.handling[i].multiplier)
            debug_print('After',GetVehicleHandlingFloat(cache.vehicle, 'CHandlingData', modLevel.handling[i].field))
        end

        if source then 
            TriggerEvent('KKF.UI.ShowNotification', 'info', 'Uus sõiduki klass: ' .. modLevel.name)
            debug_print(modLevel.name)
        end
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ei ole politseinik!')
    end
end)

CreateThread(function()
    RegisterKeyMapping('pursuit', 'Sõiduki klassi vahetamine', 'keyboard', '')
end)