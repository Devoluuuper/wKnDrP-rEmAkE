local cachedVehicle, inZone = 0, false
local stancedVehicles, closestVehicles, oldData = {}, {}, {}

CreateThread(function()
    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('KKF.Player.Loaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('KKF.Player.Unloaded', function()
	ESX.PlayerData = {}
end)

RegisterNetEvent('KKF.Player.JobUpdate', function(job)
	ESX.PlayerData.job = job
end) 

RegisterNetEvent('KKF.Player.DutyChange', function(value)
	ESX.PlayerData.job.onDuty = value
end)

local function close()
    SetNuiFocus(false, false); SendNUIMessage({ action = 'close' })
end

RegisterNUICallback('close', function(_, cb)
    close()
    stancedVehicles[NetworkGetNetworkIdFromEntity(cachedVehicle)] = oldData
    oldData = {}
end)

RegisterNUICallback('saveVehicle', function(_, cb)
    lib.callback('kk-stancer:updateVehicle', false, function(response)
        close()

        if response then
            TriggerEvent('KKF.UI.ShowNotification', 'success', 'Stance salvestatud!')
        else
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Stance salvestamisel tekkis tõrge!')
        end
    end, NetworkGetNetworkIdFromEntity(cachedVehicle), {
        fWheelOffset = (GetVehicleWheelXOffset(cachedVehicle, 0) * 100) * -1, 
        rWheelOffset = (GetVehicleWheelXOffset(cachedVehicle, 2) * 100) * -1, 
        fWheelRotation = (GetVehicleWheelYRotation(cachedVehicle, 0) * 100) * -1, 
        rWheelRotation = (GetVehicleWheelYRotation(cachedVehicle, 2) * 100) * -1, 
    })
end)

RegisterNetEvent('kk-stancer:client:getAllVehicles', function(sentData)
    stancedVehicles = sentData
end)

RegisterNetEvent('kk-stancer:client:addVehicle', function(id, sentData)
    if id and sentData then
        stancedVehicles[id] = sentData
    end
end)

RegisterNetEvent('kk-stancer:client:removeVehicle', function(id)
    if stancedVehicles[id] then
        stancedVehicles[id] = nil
    end
end)

CreateThread(function()
    while true do
        Wait(2500)
        local closeVehicles = {}

        for k, v in pairs(stancedVehicles) do
            if NetworkDoesEntityExistWithNetworkId(k) then
                local entity = NetworkGetEntityFromNetworkId(k)
                
                closeVehicles[entity] = v
            else
                stancedVehicles[k] = nil
            end
        end

        closestVehicles = closeVehicles
    end
end)

RegisterNetEvent('kk-stancer:client:openMenu', function()
    if ESX.PlayerData.job.name == inZone then
        local data = {
            fWheelOffset = (GetVehicleWheelXOffset(cache.vehicle, 0) * 100) * -1,
            rWheelOffset = (GetVehicleWheelXOffset(cache.vehicle, 2) * 100) * -1,
            fWheelRotation = (GetVehicleWheelYRotation(cache.vehicle, 0) * 100) * -1,
            rWheelRotation = (GetVehicleWheelYRotation(cache.vehicle, 2) * 100) * -1,
        }

        oldData = data

        lib.callback('kk-stancer:updateVehicle', false, function(response)
            if response then
                cachedVehicle = cache.vehicle

                if cachedVehicle then 
                    SendNUIMessage({ action = 'open', data = data }); SetNuiFocus(true, true)
                end
            else
                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Stance loadimisel tekkis tõrge!')
            end
        end, NetworkGetNetworkIdFromEntity(cache.vehicle), data)
	end
end)

CreateThread(function()
    while true do
        Wait(50)
        
        for vehicle, data in pairs(closestVehicles) do
            if DoesEntityExist(vehicle) and GetEntityType(vehicle) == 2 then
                SetVehicleWheelXOffset(vehicle, 0, ((data.fWheelOffset / 100) * -1) + 0.000) -- FRONT WHEEL OFFSET
                SetVehicleWheelXOffset(vehicle, 1, ((data.fWheelOffset / 100)) + 0.000) -- FRONT WHEEL OFFSET
                SetVehicleWheelXOffset(vehicle, 2, ((data.rWheelOffset / 100) * -1) + 0.000) -- REAR WHEEL OFFSET
                SetVehicleWheelXOffset(vehicle, 3, ((data.rWheelOffset / 100)) + 0.000) -- REAR WHEEL OFFSET
                SetVehicleWheelYRotation(vehicle, 0, ((data.fWheelRotation / 100) * -1) + 0.000)
                SetVehicleWheelYRotation(vehicle, 1, ((data.fWheelRotation / 100)) + 0.000)
                SetVehicleWheelYRotation(vehicle, 2, ((data.rWheelRotation / 100) * -1) + 0.000)
                SetVehicleWheelYRotation(vehicle, 3, ((data.rWheelRotation / 100)) + 0.000)
            else
                closestVehicles[vehicle] = nil
            end
        end
    end
end)

RegisterNUICallback('onChange', function(args, cb)
    closestVehicles[cachedVehicle][args.item] = args.value
end)

for i = 1, #cfg.stancerPoints do
    lib.zones.box({
        coords = cfg.stancerPoints[i].zone.coords,
        size = cfg.stancerPoints[i].zone.size,
        rotation = cfg.stancerPoints[i].zone.rotation,
        debug = true,

        onEnter = function()
            if ESX.PlayerData.job.name == cfg.stancerPoints[i].faction and cache.vehicle then
                inZone = cfg.stancerPoints[i].faction; ESX.ShowInteraction('Stancer')
            end
        end,

        onExit = function()
            if ESX.PlayerData.job.name == cfg.stancerPoints[i].faction then
                inZone = false; ESX.HideInteraction()
            end
        end
    })
end

exports('inZone', function()
    return inZone
end)