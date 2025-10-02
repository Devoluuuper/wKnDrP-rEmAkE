local guiEnabled = false
local insideShop, tempShop = nil, nil

RegisterNetEvent('KKF.Player.Loaded', function(playerData)
    KKF.PlayerData = playerData
end)

RegisterNetEvent('KKF.Player.Unloaded', function()
	KKF.PlayerData = {}
end)

RegisterNetEvent('KKF.Player.JobUpdate', function(job)
    KKF.PlayerData.job = job
end)

RegisterNetEvent('KKF.Player.DutyChange', function(value)
	KKF.PlayerData.job.onDuty = value
end)


local function showTablet(zoneKey)
    local elements = zoneKey
    SendNUIMessage({ action = "showTablet", data = elements })
    
    guiEnabled = true
    SetNuiFocus(true, true)

    exports['kk-scripts']:toggleTab(true)
end

RegisterNetEvent('kk-tuner:client:showTablet', showTablet)


function CalculateDistance(pos1, pos2)
    return #(vector3(pos1.x - pos2.x, pos1.y - pos2.y, pos1.z - pos2.z))
end

function IsPlayerNearTunershopShowSpot()
    local playerPos = GetEntityCoords(PlayerPedId())
    local tunershopShowSpot = Config.ShowSpot['tunershop'].pos
    local distanceThreshold = 10

    local distance = CalculateDistance(playerPos, tunershopShowSpot)
    return distance <= distanceThreshold
end

exports('IsPlayerNearTunershopShowSpot', IsPlayerNearTunershopShowSpot)

RegisterNUICallback("search", function(args, cb)

    lib.callback('kk-tuner:search', false, function(response)
        if response and response.vehicles then
            local elements = response
            for k, v in pairs(elements.vehicles) do
                local originalLabel = v.model
                local translatedLabel = GetLabelText(GetDisplayNameFromVehicleModel(v.model))
                elements.vehicles[k].label = translatedLabel

            end
            SendNUIMessage({ action = "loadResults", data = elements })
        else
        end
    end, args.context)
end)

RegisterNUICallback("searchimp", function(args, cb)
    lib.callback('kk-tuner:searchimp', false, function(response)
        local elements = response
        for k,v in pairs(elements.vehiclesimp) do
            elements.vehiclesimp[k].label = GetLabelText(GetDisplayNameFromVehicleModel(elements.vehiclesimp[k].vehicle))
        end
        SendNUIMessage({ action = "loadResults", data = elements })
    end, args.context)
end)

RegisterNUICallback("showVehicle", function(args, cb)
    lib.callback('kk-tuner:showVehicle', false, function(response)
        SendNUIMessage({ action = "showVehicle", data = response })
    end, args)
end)

RegisterNUICallback("despawnveh", function(args, cb)
    lib.callback('kk-tuner:despawnveh', false, function(response)
        SendNUIMessage({ action = "despawnveh", data = response })
    end, args)
end)

RegisterNUICallback("sellVehicle", function(args, cb)
    lib.callback('kk-tuner:server:sellShowroomVehicle', false, function(response)
        SendNUIMessage({ action = "sellVehicle", data = response })
    end, args)
end)

RegisterNUICallback("showVehicleImp", function(args, cb)
    lib.callback('kk-tuner:showVehicleImp', false, function(response)
        SendNUIMessage({ action = "showVehicleImp", data = response })
    end, args)
end)

RegisterNUICallback("despawnvehimp", function(args, cb)
    lib.callback('kk-tuner:despawnvehimp', false, function(response)
        SendNUIMessage({ action = "despawnvehimp", data = response })
    end, args)
end)

RegisterNUICallback("sellVehicleImp", function(args, cb)
    lib.callback('kk-tuner:server:sellShowroomVehicleImp', false, function(response)
        SendNUIMessage({ action = "sellVehicleImp", data = response })
    end, args)
end)


RegisterNetEvent('kk-tuner:client:swapVehicle', function(model)
    local spawnCoords = Config.ShowSpot['tunershop'].pos
    local heading = spawnCoords.w
    local existingVehicle = GetClosestVehicle(spawnCoords.x, spawnCoords.y, spawnCoords.z, 3.0, 0, 70)

    if DoesEntityExist(existingVehicle) then
        TriggerEvent('KKF.UI.ShowNotification', 'error', "Mingi sõiduk on juba ees")
        return
    end

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(500)
    end

    local vehicle = CreateVehicle(model, spawnCoords.x, spawnCoords.y, spawnCoords.z, heading, true, false)
    TriggerEvent('KKF.UI.ShowNotification', 'success', "Sõiduk edukalt lisatud väljapanekule.")
    SetModelAsNoLongerNeeded(model)

    SetVehicleNumberPlateText(vehicle, 'SHOWCAR')
    SetVehicleDoorsLocked(vehicle, 3)
    FreezeEntityPosition(vehicle, true)
    SetEntityInvincible(vehicle, true)
end)

RegisterNetEvent('kk-tuner:client:swapVehicleImp', function(model)
    local spawnCoords = Config.ShowSpot['import'].pos
    local heading = spawnCoords.w
    local existingVehicle = GetClosestVehicle(spawnCoords.x, spawnCoords.y, spawnCoords.z, 3.0, 0, 70)

    if DoesEntityExist(existingVehicle) then
        TriggerEvent('KKF.UI.ShowNotification', 'error', "Mingi sõiduk on juba ees")
        return
    end

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(500)
    end

    local vehicle = CreateVehicle(model, spawnCoords.x, spawnCoords.y, spawnCoords.z, heading, true, false)
    TriggerEvent('KKF.UI.ShowNotification', 'success', "Sõiduk edukalt lisatud väljapanekule.")
    SetModelAsNoLongerNeeded(model)

    SetVehicleNumberPlateText(vehicle, 'SHOWCAR')
    SetVehicleDoorsLocked(vehicle, 3)
    FreezeEntityPosition(vehicle, true)
    SetEntityInvincible(vehicle, true)
end)

RegisterNetEvent('kk-tuner:client:despawnVehicle', function(model)
    local vehicle = GetClosestVehicle(Config.ShowSpot.tunershop.pos.x, Config.ShowSpot.tunershop.pos.y, Config.ShowSpot.tunershop.pos.z, 5.0, 0, 71)
    if DoesEntityExist(vehicle) then
        local vehModel = GetEntityModel(vehicle)
        if vehModel == GetHashKey(model) then
            SetEntityAsMissionEntity(vehicle, true, true)
            DeleteVehicle(vehicle)
            TriggerEvent('KKF.UI.ShowNotification', 'success', "Sõiduk edukalt eemaldatud.")
        else
            TriggerEvent('KKF.UI.ShowNotification', 'error', "Üritad eemaldada valet sõidukit.")
        end
    else
        TriggerEvent('KKF.UI.ShowNotification', 'info', "Mitte ühtegi sõidukit pole läheduses.")
    end
end)

RegisterNetEvent('kk-tuner:client:despawnVehicleImp', function(model)
    local vehicle = GetClosestVehicle(Config.ShowSpot.import.pos.x, Config.ShowSpot.import.pos.y, Config.ShowSpot.import.pos.z, 5.0, 0, 71)
    if DoesEntityExist(vehicle) then
        local vehModel = GetEntityModel(vehicle)
        if vehModel == GetHashKey(model) then
            SetEntityAsMissionEntity(vehicle, true, true)
            DeleteVehicle(vehicle)
            TriggerEvent('KKF.UI.ShowNotification', 'success', "Sõiduk edukalt eemaldatud.")
        else
            TriggerEvent('KKF.UI.ShowNotification', 'error', "Üritad eemaldada valet sõidukit.")
        end
    else
        TriggerEvent('KKF.UI.ShowNotification', 'info', "Mitte ühtegi sõidukit pole läheduses.")
    end
end)

RegisterNetEvent('kk-tuner:client:buyShowroomVehicle', function(vehicle, plate)
    local shopType = "tunershop"

    local spawnPos = Config.SpawnSpot[shopType].pos
    local vehicleSpawn = Config.SpawnSpot[shopType].pos

    tempShop = insideShop

    lib.callback('KKF.Vehicle.SpawnVehicle', false, function(networkId)
        local veh = NetToVeh(networkId)
        -- exports["cdn-fuel"]:SetFuel(NetworkGetEntityFromNetworkId(networkId), 100)
        Entity(NetworkGetEntityFromNetworkId(networkId)).state.fuel = 100
        SetVehicleNumberPlateText(veh, plate)
        SetEntityHeading(veh, vehicleSpawn.w)
        TriggerEvent('kk-scripts:client:newKey', plate)
        KKF.Game.GetVehicleProperties(veh)
    end, vehicle, spawnPos, true)
end)

RegisterNetEvent('kk-tuner:client:buyShowroomVehicleImp', function(vehicle, plate)
    local shopType = "tunershop"

    local spawnPos = Config.SpawnSpot[shopType].pos
    local vehicleSpawn = Config.SpawnSpot[shopType].pos

    tempShop = insideShop

    lib.callback('KKF.Vehicle.SpawnVehicle', false, function(networkId)
        local veh = NetToVeh(networkId)
        -- exports["cdn-fuel"]:SetFuel(NetworkGetEntityFromNetworkId(networkId), 100)
        Entity(NetworkGetEntityFromNetworkId(networkId)).state.fuel = 100
        SetVehicleNumberPlateText(veh, plate)
        SetEntityHeading(veh, vehicleSpawn.w)
        TriggerEvent('kk-scripts:client:newKey', plate)
        KKF.Game.GetVehicleProperties(veh)
    end, vehicle, spawnPos, true)
end)

RegisterNUICallback("disableFocus", function(args, cb)
    if not guiEnabled then
        return
    end
    SetPlayerControl(PlayerId(), 1, 0)
    SetNuiFocus(false, false)

    guiEnabled = false

	exports['kk-scripts']:toggleTab(false)
end)