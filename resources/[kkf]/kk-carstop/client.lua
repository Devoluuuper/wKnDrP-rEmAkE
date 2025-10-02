local cfg = require 'config'
local currentVehicle, currentBlip, currentLocationId = nil, nil, nil
local repairTimerActive, repairTimeLeft = false, 0
local carstopPed = nil
local carstopTargetZoneId = nil

CreateThread(function()
    local model = 'ig_benny'
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(500) end

    carstopPed = CreatePed(0, model, cfg.blip.x, cfg.blip.y, cfg.blip.z - 1, cfg.blip.w, false, true)
    FreezeEntityPosition(carstopPed, true)
    SetEntityInvincible(carstopPed, true)
    SetBlockingOfNonTemporaryEvents(carstopPed, true)

    local blip = AddBlipForCoord(cfg.blip.xyz)
    SetBlipSprite(blip, 402)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 5)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Carstop tööandja')
    EndTextCommandSetBlipName(blip)

    if carstopTargetZoneId then
        exports.ox_target:removeLocalEntity(carstopTargetZoneId)
        carstopTargetZoneId = nil
    end

    carstopTargetZoneId = exports.ox_target:addLocalEntity(carstopPed, {
        {
            label = 'Alusta Carstop tööd',
            icon = 'fa-solid fa-screwdriver-wrench',
            onSelect = function()
                lib.callback('kk-carstop:isJobActive', false, function(isActive)
                    if isActive then
                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Sul on juba töö pooleli!')
                    else
                        TriggerServerEvent('kk-carstop:startJob')
                    end
                end)
            end
        },
        {
            label = 'Lõpeta Carstop töö',
            icon = 'fa-solid fa-ban',
            onSelect = function()
                lib.callback('kk-carstop:isJobActive', false, function(isActive)
                    if not isActive then
                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Sul pole ühtegi Carstop tööotsa pooleli!')
                    else
                        TriggerServerEvent('kk-carstop:stopJob')
                    end
                end)
            end
        }
    })
end)

RegisterNetEvent('kk-carstop:spawnVehicle', function(location, id)
    if currentVehicle then DeleteVehicle(currentVehicle) end
    if currentBlip then RemoveBlip(currentBlip) end

    currentVehicle, currentBlip = nil, nil
    currentLocationId, repairTimerActive = id, false

    currentBlip = AddBlipForCoord(location.coords.x, location.coords.y, location.coords.z)
    SetBlipSprite(currentBlip, 225)
    SetBlipScale(currentBlip, 0.7)
    SetBlipColour(currentBlip, 2)
    SetBlipRoute(currentBlip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Remonditav auto')
    EndTextCommandSetBlipName(currentBlip)

    TriggerEvent('KKF.UI.ShowNotification', 'info', 'Sinu töö: ' .. location.description)
    startRepairTimer()
    spawnJobVehicle(location)
end)

function spawnJobVehicle(location)
    CreateThread(function()
        local playerCoords = GetEntityCoords(PlayerPedId())
        if #(playerCoords - location.coords.xyz) >= 50.0 then
            while true do
                playerCoords = GetEntityCoords(PlayerPedId())
                if #(playerCoords - location.coords.xyz) < 50.0 then
                    TriggerEvent('KKF.UI.ShowNotification', 'success', 'Sa jõudsid kohale, auto on valmis parandamiseks!')
                    break
                end
                Wait(500)
            end
        else
            TriggerEvent('KKF.UI.ShowNotification', 'success', 'Auto on kohe siin, saad alustada parandamist!')
        end

        RequestModel(location.model)
        while not HasModelLoaded(location.model) do Wait(250) end

        ClearArea(location.coords.x, location.coords.y, location.coords.z, 5.0, true, false, false, false)

        local vehicle = CreateVehicle(location.model, location.coords.x, location.coords.y, location.coords.z, location.coords.w, true, true)
        if not DoesEntityExist(vehicle) then
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Auto ei spawninud!')
            return
        end

        SetVehicleEngineOn(vehicle, false, true, true)
        SetVehicleDoorsLocked(vehicle, 1)
        SetVehicleEngineHealth(vehicle, 200.0)
        SetVehicleBodyHealth(vehicle, 400.0)
        SmashVehicleWindow(vehicle, 0)
        SetVehicleDoorOpen(vehicle, 4, false, false)

        currentVehicle = vehicle
        startFloatingMarker()

        exports.ox_target:addLocalEntity(vehicle, {
            {
                label = 'Paranda auto',
                icon = 'fa-solid fa-wrench',
                onSelect = function()
                    repairVehicle(vehicle)
                end
            }
        })

        local netVehId = NetworkGetNetworkIdFromEntity(vehicle)
        TriggerServerEvent('kk-carstop:vehicleSpawned', netVehId)
    end)
end

function repairVehicle(vehicle)
    if not currentVehicle or vehicle ~= currentVehicle then
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'See pole õige auto!')
        return
    end

    CreateThread(function()
        lib.requestAnimDict('mini@repair')
        TaskPlayAnim(PlayerPedId(), 'mini@repair', 'fixing_a_ped', 8.0, 8.0, -1, 49, 0, 0, 0, 0)

        local progressBar = exports['kk-taskbar']:startAction(
            'progress',
            'Parandad autot...',
            10000,
            'fixing_a_ped',
            'mini@repair',
            { freeze = true, controls = true, fadeIn = true }
        )

        if not progressBar then
            return
        end

        local startTime = GetGameTimer()
        local duration = 15000

        while (GetGameTimer() - startTime) < duration do
            if not IsEntityPlayingAnim(PlayerPedId(), 'mini@repair', 'fixing_a_ped', 3) then
                break
            end
            Wait(100)
        end

        local success = lib.callback.await('kk-carstop:server:repairDone', false, currentLocationId)

        if not success then
            exports['kk-taskbar']:cancelAction(progressBar, {fadeOut = true})
            return
        end

        repairTimeLeft = 0
        repairTimerActive = false

        TriggerEvent('KKF.UI.ShowNotification', 'success', 'Tegid nii marudalt, et leian veel tööotsasi sulle!')
        SetVehicleDoorShut(vehicle, 4, false)

        DeleteVehicle(vehicle)
        if currentBlip then RemoveBlip(currentBlip) end
        currentVehicle, currentBlip = nil, nil

        Wait(15000)
        TriggerServerEvent('kk-carstop:startJob')
    end)
end

function startRepairTimer()
    repairTimerActive = true
    repairTimeLeft = 900
    drawRepairCountdown(repairTimeLeft)

    CreateThread(function()
        while repairTimeLeft > 0 and repairTimerActive do
            Wait(1000)
            repairTimeLeft = repairTimeLeft - 1
            drawRepairCountdown(repairTimeLeft)
        end

        if repairTimeLeft <= 0 then
            lib.hideTextUI()
            if currentVehicle then DeleteVehicle(currentVehicle) end
            if currentBlip then RemoveBlip(currentBlip) end
            currentVehicle, currentBlip, currentLocationId, repairTimerActive = nil, nil, nil, false
        end
    end)
end

function drawRepairCountdown(timeLeft)
    CreateThread(function()
        while timeLeft > 0 and repairTimerActive do
            local color = timeLeft <= 30 and 'red' or 'white'
            lib.showTextUI("⏱️ Aega jäänud: " .. timeLeft .. "s", {
                position = "right-center",
                style = { borderRadius = 20, backgroundColor = '#2b2b2b', color = color }
            })
            Wait(1000)
            timeLeft = timeLeft - 1
        end
        lib.hideTextUI()
    end)
end

function startFloatingMarker()
    CreateThread(function()
        while currentVehicle do
            local coords = GetEntityCoords(currentVehicle)
            local dist = #(GetEntityCoords(PlayerPedId()) - coords)
            if dist < 30.0 then
                DrawMarker(44, coords.x, coords.y, coords.z + 1.5, 0,0,0,0,0,0, 0.7,0.7,0.7, 0,150,255,180, true,true,2,nil,nil,false)
                Wait(0)
            else
                Wait(500)
            end
        end
    end)
end

RegisterNetEvent('kk-carstop:client:cleanup', function(netVehId)
    repairTimeLeft = 0
    repairTimerActive = false

    if netVehId then
        local veh = NetworkGetEntityFromNetworkId(netVehId)
        if veh and veh ~= 0 and DoesEntityExist(veh) then
            if not NetworkHasControlOfEntity(veh) then
                NetworkRequestControlOfEntity(veh)
                local tries = 0
                while not NetworkHasControlOfEntity(veh) and tries < 50 do
                    Wait(20)
                    NetworkRequestControlOfEntity(veh)
                    tries = tries + 1
                end
            end
            SetEntityAsMissionEntity(veh, true, true)
            DeleteEntity(veh)
        end
    end

    if currentVehicle then
        DeleteVehicle(currentVehicle)
        currentVehicle = nil
    end
    if currentBlip then
        RemoveBlip(currentBlip)
        currentBlip = nil
    end
    currentLocationId = nil
    lib.hideTextUI()
end)