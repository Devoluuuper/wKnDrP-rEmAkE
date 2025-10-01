local HasAlreadyEnteredMarker, OnJob, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle, CurrentActionData = false, false, false, false, false, {}
local CurrentCustomer, CurrentCustomerBlip, DestinationBlip, targetCoords, LastZone, CurrentAction, CurrentActionMsg
local lastDone = 0
local zone = nil

local function InCooldown()
    return (GetGameTimer() - lastDone) < 30000
end

RegisterNetEvent('KKF.Player.Loaded', function(xPlayer)
    ESX.PlayerData = xPlayer

    Wait(3000)

    if ESX.PlayerData.job.name == 'taxi' then
        if ESX.PlayerData.job.onDuty then
            exports['pma-voice']:setVoiceProperty('radioEnabled', true)
            exports['pma-voice']:setRadioChannel(cfg.taxiRadio)
        else
            exports['pma-voice']:setRadioChannel(0)
        end
    end
end)

RegisterNetEvent('KKF.Player.Unloaded', function()
    ESX.PlayerLoaded = false
end)

RegisterNetEvent('KKF.Player.JobUpdate', function(job)
    ESX.PlayerData.job = job

    if ESX.PlayerData.job.name == 'taxi' then
        if ESX.PlayerData.job.onDuty then
            exports['pma-voice']:setVoiceProperty('radioEnabled', true)
            exports['pma-voice']:setRadioChannel(cfg.taxiRadio)
        else
            exports['pma-voice']:setRadioChannel(0)
        end
    end
end)

RegisterNetEvent('KKF.Player.DutyChange', function(value)
    ESX.PlayerData.job.onDuty = value

    if ESX.PlayerData.job.name == 'taxi' then
        if ESX.PlayerData.job.onDuty then
            exports['pma-voice']:setVoiceProperty('radioEnabled', true)
            exports['pma-voice']:setRadioChannel(cfg.taxiRadio)
        else
            exports['pma-voice']:setRadioChannel(0)
        end
    end
end)

function createPed()
    if not DoesBlipExist(CurrentCustomerBlip) then
        if zone then zone:remove(); zone = nil end

        local returnable = false
        local playerCoords = GetEntityCoords(cache.ped)
        local location = cfg.jobLocations[GetRandomIntInRange(1, #cfg.jobLocations)]

        local distance = #(playerCoords - location)

        while distance < cfg.minDistance or distance > cfg.maxDistance do
            Wait(0)

            location = cfg.jobLocations[GetRandomIntInRange(1, #cfg.jobLocations)]
            distance = #(playerCoords - location)
        end

        while location.z >= 80 do
            location = cfg.jobLocations[GetRandomIntInRange(1, #cfg.jobLocations)]
            Wait(100)
        end

        TriggerEvent('KKF.UI.ShowNotification', 'info', 'Kliendi asukoht märgitakse sulle kaardile!')
        SetNewWaypoint(location.x, location.y)
        CurrentCustomerBlip = AddBlipForCoord(location)

        SetBlipSprite(CurrentCustomerBlip, 792)
        SetBlipColour(CurrentCustomerBlip, 5)
        SetBlipScale(CurrentCustomerBlip, 0.7)
        SetBlipDisplay(CurrentCustomerBlip, 4)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName('Klient')
        EndTextCommandSetBlipName(CurrentCustomerBlip)

        zone = lib.zones.box({
            coords = location,
            size = vec3(300, 300, math.abs(300 - 0)),
            rotation = 0.0,
            debug = false,
            onEnter = function()
                if zone then zone:remove(); zone = nil end
                SetPedRelationshipGroupHash(cache.ped, `PLAYER`)
                
                lib.callback('KKF.Entity.SpawnPed', false, function(networkId)
                    if networkId then
                        while not NetworkDoesEntityExistWithNetworkId(networkId) do
                            Wait(10)
                        end

                        if DoesBlipExist(CurrentCustomerBlip) then
                            RemoveBlip(CurrentCustomerBlip); CurrentCustomerBlip = nil
                        end

                        returnable = NetworkGetEntityFromNetworkId(networkId)
                        ESX.Game.RequestNetworkControlOfEntity(returnable)

                        PlaceObjectOnGroundProperly(returnable)
                        SetBlockingOfNonTemporaryEvents(returnable, true)
                        SetPedDiesWhenInjured(returnable, false)
                        SetPedCanPlayAmbientAnims(returnable, true)
                        SetPedCanRagdollFromPlayerImpact(returnable, false)
                        SetEntityInvincible(returnable, false)
                        FreezeEntityPosition(returnable, false)

                        AddRelationshipGroup('TAXI_PED')

                        SetRelationshipBetweenGroups(0, `TAXI_PED`, `TAXI_PED`)
                        SetRelationshipBetweenGroups(0, `TAXI_PED`, `PLAYER`)
                        SetRelationshipBetweenGroups(0, `PLAYER`, `TAXI_PED`)

                        SetPedRelationshipGroupHash(returnable, `TAXI_PED`)

                        CreateThread(function()
                            while DoesEntityExist(returnable) do
                                if not OnJob then
                                    DeleteEntity(returnable)
                                    break
                                end

                                Wait(5000)
                            end
                        end)
                    end
                end, cfg.peds[math.random(1, #cfg.peds)], location, 0.0)
            end
        })

        CreateThread(function()
            while true do
                if not OnJob then
                    if zone then zone:remove(); zone = nil end

                    returnable = nil
                    clearCurrentMission()
                    CurrentCustomer, CurrentCustomerBlip, DestinationBlip, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle, targetCoords = nil, nil, nil, false, false, false, nil
                    kmDistance = 0
                end

                Wait(5000)
            end
        end)
        
        while returnable == false do Wait(5) end; return returnable
    else
        return nil
    end
end

local function checkFaction(plate)
    return lib.callback.await('kk-taxi:checkFaction', false, plate)
end

function clearCurrentMission()
    if DoesBlipExist(CurrentCustomerBlip) then
        RemoveBlip(CurrentCustomerBlip)
    end

    if DoesBlipExist(DestinationBlip) then
        RemoveBlip(DestinationBlip)
    end

    if CurrentCustomer then
        DeleteEntity(CurrentCustomer)
    end

    CurrentCustomer = nil
    CurrentCustomerBlip = nil
    DestinationBlip = nil
    IsNearCustomer = false
    CustomerIsEnteringVehicle = false
    CustomerEnteredVehicle = false
    targetCoords = nil
    if zone then zone:remove(); zone = nil end
end

local cooldown = false

function startTaxiJob()
    if cache.vehicle then
        if checkFaction(ESX.Game.GetPlate(cache.vehicle)) then
            if not cooldown then
                TriggerEvent('KKF.UI.ShowNotification', 'info', 'Alustad tööpäeva!')
                clearCurrentMission()

                OnJob = true
            else
                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Pead natukene ootama!')
            end
        else
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Antud sõiduk ei sobi selleks tööks!')
        end
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Astu sõidukisse!')
    end
end

function stopTaxiJob()
    if IsPedInAnyVehicle(CurrentCustomer, false) and CurrentCustomer then
        TaskLeaveVehicle(CurrentCustomer, GetVehiclePedIsIn(CurrentCustomer, false), 0)

        if CustomerEnteredVehicle then
            TaskGoStraightToCoord(CurrentCustomer, targetCoords.x, targetCoords.y, targetCoords.z, 1.0, -1, 0.0, 0.0)
        end
    end

    clearCurrentMission()
    OnJob = false
    TriggerEvent('KKF.UI.ShowNotification', 'info', 'Lõpetasite tööpäeva! Pead ootama nüüd 5 minutit enne uue tööotsa võtmist.', 10000)
    cooldown = true

    SetTimeout(60000 * 5, function()
        cooldown = false
    end)
end

SetInterval(function()
    if OnJob then
        if cache.vehicle then
            if not checkFaction(ESX.Game.GetPlate(cache.vehicle)) then
                stopTaxiJob()
            end
        end
    end
end, 5000)

CreateThread(function()
    for i = 1, #cfg.taxiParks do
        local current = cfg.taxiParks[i]

        ESX.CreateBlip('taxi_' .. i, current.position, current.label, 198, 5, 0.7)

        if current.clothes then
            for k2, v2 in pairs(current.clothes) do
                exports.ox_target:addBoxZone({
                    coords = v2.coords,
                    size = v2.size,
                    rotation = v2.rotation,
                    debug = false,
                    options = {
                        {
                            event = 'kk-skin:client:openOutfitMenu',
                            icon = 'fas fa-tshirt',
                            label = 'Riidekapp',
                            distance = 1.5,
                            canInteract = function()
                                return ESX.PlayerData.job.name == 'taxi' and ESX.PlayerData.job.onDuty
                            end
                        },
                    }
                })
            end
        end

        if current.duty then
            for k2, v2 in pairs(current.duty) do
                exports.ox_target:addBoxZone({
                    coords = v2.coords,
                    size = v2.size,
                    rotation = v2.rotation,
                    debug = false,
                    options = {
                        {
                            serverEvent = 'kk-scripts:server:toggleDuty',
                            icon = 'far fa-clipboard',
                            label = 'Alusta/Lõpeta tööpäeva',
                            distance = 1.5,
                            canInteract = function()
                                return ESX.PlayerData.job.name == 'taxi'
                            end
                        },
                    }
                })
            end
        end
    end
end)

local kmDistance = 0

-- Taxi Job
CreateThread(function()
    while true do
        local Sleep = 1500

        if OnJob then
            Sleep = 0
            
            if CurrentCustomer == nil then
                if OnJob and not DoesBlipExist(CurrentCustomerBlip) then
                    Wait(5000)

                    while InCooldown() do
                        Wait(0)

                        if not OnJob then
                            break
                        end
                    end

                    if OnJob then
                        CurrentCustomer = createPed()

                        if CurrentCustomer ~= nil then
                            if not Entity(CurrentCustomer).state.sourceHeist then
                                local locationCoords = GetEntityCoords(CurrentCustomer)
                                CurrentCustomerBlip = AddBlipForEntity(CurrentCustomer)

                                SetBlipSprite(CurrentCustomerBlip, 792)
                                SetBlipColour(CurrentCustomerBlip, 5)
                                SetBlipScale(CurrentCustomerBlip, 0.7)
                                SetBlipDisplay(CurrentCustomerBlip, 4)
                                BeginTextCommandSetBlipName('STRING')
                                AddTextComponentSubstringPlayerName('Klient')
                                EndTextCommandSetBlipName(CurrentCustomerBlip)

                                SetNewWaypoint(locationCoords.x, locationCoords.y)

                                local standTime = GetRandomIntInRange(60000, 180000)
                                TaskStandStill(CurrentCustomer, standTime)

                                TriggerEvent('KKF.UI.ShowNotification', 'info', 'Leidsid kliendi!')
                            else
                                print('taxi ped with weapon deleted')
                                TriggerEvent('KKF.UI.ShowNotification', 'info', 'Klient loobus tellimusest!')

                                if DoesBlipExist(CurrentCustomerBlip) then
                                    RemoveBlip(CurrentCustomerBlip)
                                end
            
                                if DoesBlipExist(DestinationBlip) then
                                    RemoveBlip(DestinationBlip)
                                end
            
                                SetEntityAsMissionEntity(CurrentCustomer, false, true)
            
                                CurrentCustomer, CurrentCustomerBlip, DestinationBlip, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle, targetCoords = nil, nil, nil, false, false, false, nil
                                kmDistance = 0
                            end
                        end
                    end
                end
            else
                if IsPedFatallyInjured(CurrentCustomer) then
                    TriggerEvent('KKF.UI.ShowNotification', 'info', 'Klient loobus tellimusest!')

                    if DoesBlipExist(CurrentCustomerBlip) then
                        RemoveBlip(CurrentCustomerBlip)
                    end

                    if DoesBlipExist(DestinationBlip) then
                        RemoveBlip(DestinationBlip)
                    end

                    SetEntityAsMissionEntity(CurrentCustomer, false, true)

                    CurrentCustomer, CurrentCustomerBlip, DestinationBlip, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle, targetCoords = nil, nil, nil, false, false, false, nil
                    kmDistance = 0
                end

                if cache.vehicle then
                    local playerCoords = GetEntityCoords(cache.ped)
                    local customerCoords = GetEntityCoords(CurrentCustomer)
                    local customerDistance = #(playerCoords - customerCoords)

                    if IsPedSittingInVehicle(CurrentCustomer, cache.vehicle) then
                        if CustomerEnteredVehicle then
                            local xDistance = playerCoords.z - targetCoords.z
                            local targetDistance = #(vec2(playerCoords.x, playerCoords.y) - vec2(targetCoords.x, targetCoords.y))

                            if targetDistance <= 60.0 and xDistance <= 60.0 then
                                lastDone = GetGameTimer()
                                Entity(CurrentCustomer).state:set('taxiDone', true, true)
                                TaskLeaveVehicle(CurrentCustomer, cache.vehicle, 0)

                                TriggerEvent('KKF.UI.ShowNotification', 'success', 'Saabusite sihtpunkti!')

                                TaskGoStraightToCoord(CurrentCustomer, targetCoords.x, targetCoords.y, targetCoords.z,
                                    1.0, -1, 0.0, 0.0)
                                SetEntityAsMissionEntity(CurrentCustomer, false, true)
                                lib.callback.await('kk-taxi:jobComplete', false, kmDistance)
                                RemoveBlip(DestinationBlip)

                                local function scope(customer)
                                    SetTimeout(15000, function()
                                        DeleteEntity(customer)
                                    end)
                                end

                                scope(CurrentCustomer)

                                kmDistance = 0
                                CurrentCustomer, CurrentCustomerBlip, DestinationBlip, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle, targetCoords =
                                    nil, nil, nil, false, false, false, nil
                            end

                            if targetCoords then
                                DrawMarker(36, targetCoords.x, targetCoords.y, targetCoords.z + 1.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 234, 223, 72, 155, false, false, 2, true, nil, nil, false)
                            end
                        else
                            RemoveBlip(CurrentCustomerBlip)
                            CurrentCustomerBlip = nil
                            targetCoords = cfg.jobLocations[GetRandomIntInRange(1, #cfg.jobLocations)]
                            local distance = #(playerCoords - targetCoords)

                            while distance < cfg.minDistance or distance > cfg.maxDistance do
                                Wait(0)

                                targetCoords = cfg.jobLocations[GetRandomIntInRange(1, #cfg.jobLocations)]
                                distance = #(playerCoords - targetCoords)
                            end

                            local street = table.pack(GetStreetNameAtCoord(targetCoords.x, targetCoords.y,
                                targetCoords.z))
                            local msg = nil

                            kmDistance = distance / 1000
                            TriggerEvent('KKF.UI.ShowNotification', 'info', 'Vii mind ' .. GetStreetNameFromHashKey(street[1]) .. ' tänavale.')

                            DestinationBlip = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

                            SetBlipSprite(DestinationBlip, 38)
                            SetBlipColour(DestinationBlip, 5)
                            SetBlipScale(DestinationBlip, 0.7)
                            SetBlipDisplay(DestinationBlip, 4)
                            BeginTextCommandSetBlipName('STRING')
                            AddTextComponentSubstringPlayerName('Sihtpunkt')
                            EndTextCommandSetBlipName(DestinationBlip)

                            SetNewWaypoint(targetCoords.x, targetCoords.y)

                            CustomerEnteredVehicle = true
                        end
                    else
                        DrawMarker(36, customerCoords.x, customerCoords.y, customerCoords.z + 1.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 234, 223, 72, 155, false, false, 2, true, nil, nil, false)

                        if not CustomerEnteredVehicle then
                            AddRelationshipGroup(`CUSTOMER`)

                            SetRelationshipBetweenGroups(0, `CUSTOMER`, `PLAYER`)
                            SetRelationshipBetweenGroups(0, `PLAYER`, `CUSTOMER`)

                            SetPedCombatAttributes(CurrentCustomer, 46, true) -- Disable fleeing
                            SetPedCombatAttributes(CurrentCustomer, 3, false) -- Ensure they stay in combat mode
    
                            SetPedFleeAttributes(CurrentCustomer, 0, 0)
                            SetPedRelationshipGroupHash(CurrentCustomer, `CUSTOMER`)

                            if customerDistance <= 40.0 then
                                if not IsNearCustomer then
                                    TriggerEvent('KKF.UI.ShowNotification', 'error', 'Liigu kliendile lähemale!')
                                    IsNearCustomer = true
                                end
                            end

                            if customerDistance <= 40.0 then
                                if not CustomerIsEnteringVehicle then
                                    ClearPedTasksImmediately(CurrentCustomer)

                                    local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(cache.vehicle)

                                    for i = maxSeats - 1, 0, -1 do
                                        if IsVehicleSeatFree(cache.vehicle, i) then
                                            freeSeat = i
                                            break
                                        end
                                    end

                                    TaskEnterVehicle(CurrentCustomer, cache.vehicle, -1, freeSeat, 2.0, 0)
                                    CustomerIsEnteringVehicle = true
                                end
                            end
                        end
                    end
                end
            end
        end

        Wait(Sleep)
    end
end)

RegisterCommand('clientHonk', function()
    if ESX.PlayerData.job.name == 'taxi' and ESX.PlayerData.job.onDuty then
        if OnJob then
            if cache.vehicle then
                if CurrentCustomer then
                    if CustomerIsEnteringVehicle then
                        if not IsPedInAnyVehicle(CurrentCustomer, false) then
                            ClearPedTasksImmediately(CurrentCustomer)

                            local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(cache.vehicle)

                            for i = maxSeats - 1, 0, -1 do
                                if IsVehicleSeatFree(cache.vehicle, i) then
                                    freeSeat = i
                                    break
                                end
                            end

                            if freeSeat then
                                TaskEnterVehicle(CurrentCustomer, cache.vehicle, -1, freeSeat, 2.0, 0)
                            else
                                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil pole autos vabu kohti!')
                            end
                        end
                    end
                end
            end
        end
    end
end)

RegisterKeyMapping('clientHonk', 'Kutsu klienti', 'keyboard', 'E')

RegisterNetEvent('kk-taxi:client:action', function()
    if ESX.PlayerData.job.name == 'taxi' and ESX.PlayerData.job.onDuty then
        if not OnJob then
            startTaxiJob()
        else
            stopTaxiJob()
        end
    end
end)

-- CreateThread(function()
-- 	lib.callback('kk-robberies:getHouses', false, function(locations)
--         for i = 1, #locations do
--             table.insert(cfg.jobLocations, locations[i].polyZone.coords)
--         end
--     end)
-- end)
