local cfg = {}

local activeLocation = nil
local activeDealer = nil

local isSelling = false
local sellPoint = nil

local carSpawned = false
local carEntity = nil
local carPed = nil

local ignoreVehicle = {}
local dealerPeds = {}

local managerName = nil

local function interactPed(index)
    local pedData = cfg.peds[index]

    if pedData then
        local skill = lib.callback.await('kk-skills:getLevel', false, 'oxy')

        if skill >= pedData.level then
            local freeLocations = lib.callback.await('kk-oxyrun:fetchLocations', false)

            if freeLocations and #freeLocations > 0 then
                local elements = {}

                for i = 1, #freeLocations do
                    local coords = cfg.sellLocations[freeLocations[i]].coords.xyz
                    local street = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
                    local zone = GetNameOfZone(coords)

                    elements[#elements + 1] = {
                        title = GetStreetNameFromHashKey(street) .. ', ' .. GetStreetNameFromHashKey(zone),
                        icon = 'fa-solid fa-map-pin',
                        description = 'Alusta tööotsa',
                        serverEvent = 'kk-oxyrun:server:reserveStreet',
                        args = { ped = index, location = freeLocations[i] }
                    }
                end

                lib.registerContext({
                    id = 'oxyrun_locations',
                    title = 'Vabad teeninduskohad',
                    options = elements
                })

                lib.showContext('oxyrun_locations')
            else
                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Rahu! Mul on niigi palju kliente, usu, sa ei ole ainus...')
            end
        else
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Poiss, me ei tunne sind veel nii hästi!')
        end
    end
end

RegisterNetEvent('kk-oxyrun:client:startJob', function(data, name)
    local dealerData = cfg.dealerLocations[data.dealer]
        
    if dealerData then
        activeDealer = data.dealer
        managerName = name

        TriggerEvent('kk-hud2:client:showInstruction', managerName, 'Kõigepealt mine ja võta Diileri juurest pakid peale.')

        SetNewWaypoint(dealerData.xy)
        KKF.CreateBlip('oxy_dealer_' .. data.dealer, dealerData.xyz, 'Diiler', 51, 47, 0.8)
    end
end)

local function WaitTaskToEnd(ped, task)
	while GetScriptTaskStatus(ped, task) == 0 do
		Wait(250)
	end

	while GetScriptTaskStatus(ped, task) == 1 do
		Wait(250)
	end
end

local function startSpawning(location)
    if isSelling then
        local locationData = cfg.sellLocations[location]
        local vehicleModel = joaat(cfg.vehicles[math.random(1, #cfg.vehicles)])

        if DoesEntityExist(carEntity) then
            DeleteEntity(carEntity)
        end

        if DoesEntityExist(carPed) then
            DeletePed(carPed)
        end

        if IsModelValid(vehicleModel) then
            if IsThisModelACar(vehicleModel) then
                exports['kk-scripts']:requestModel(vehicleModel)

                if not DoesEntityExist(carEntity) then
                    carEntity = CreateVehicle(vehicleModel, locationData.spawn.x, locationData.spawn.y, locationData.spawn.z, locationData.spawn.w, true, false)
                    SetEntityAsMissionEntity(carEntity, true, true)
                    SetVehicleEngineOn(carEntity, true, true, false)
                    SetModelAsNoLongerNeeded(vehicleModel)
                    SetHornEnabled(carEntity, true)
                    StartVehicleHorn(carEntity, 1000, joaat("NORMAL"), false)
                end
            end
        end

        local cachedEntity = carEntity
        local cachedPed = carPed

        local model = joaat(cfg.pedList[math.random(#cfg.pedList)])

        if DoesEntityExist(carEntity) then
            if IsModelValid(model) then
                exports['kk-scripts']:requestModel(model)

                carPed = CreatePedInsideVehicle(carEntity, 26, model, -1, true, false)
                SetAmbientVoiceName(carPed, "A_M_M_EASTSA_02_LATINO_FULL_01")
                SetBlockingOfNonTemporaryEvents(carPed, true)
                SetEntityAsMissionEntity(carPed, true, true)

                SetModelAsNoLongerNeeded(model)
            end
        end

        while not DoesEntityExist(carEntity) do
            Wait(1)
        end

        while not DoesEntityExist(carPed) do
            Wait(1)
        end

        RollDownWindows(carEntity)
        Wait(50)
        TaskVehicleDriveToCoord(carPed, carEntity, locationData.coords.x, locationData.coords.y, locationData.coords.z, 5.0, 1, GetEntityModel(carEntity), 786603, 5.0, true)
        SetPedKeepTask(carPed, true)
        WaitTaskToEnd(carPed, 567490903)

        exports.ox_target:addEntity({NetworkGetNetworkIdFromEntity(carEntity)}, {
            {
                name = 'oxy_give_' .. carEntity,
                distance = 1.5,
                icon = 'fa-solid fa-hand',
                label = 'Anna pakk üle',

                canInteract = function()
                    return activeLocation == location and not ignoreVehicle[carEntity] and isSelling
                end,

                onSelect = function()
                    local progress = exports['kk-taskbar']:startAction('give_package', 'Annad kaupa üle', 5000, false, false, {freeze = false, controls = true})
        
                    if progress then
                        TriggerServerEvent('kk-oxyrun:server:givePackage')
                    end
                end
            }
        })
    end
end

RegisterNetEvent('kk-oxyrun:client:givePackage', function(ender)
    local cachedEntity = carEntity
    local cachedPed = carPed

    ignoreVehicle[cachedEntity] = true

    SetEntityAsMissionEntity(cachedEntity, false, false)
    SetEntityAsMissionEntity(cachedPed, false, false)
    SetEntityAsNoLongerNeeded(cachedEntity)
    SetEntityAsNoLongerNeeded(cachedPed)
    ClearPedTasks(cachedPed)

    TaskVehicleDriveWander(cachedPed, cachedEntity, 100.0, 786436)

    SetTimeout(5000, function()
        DeleteEntity(cachedEntity)
        DeleteEntity(cachedPed)

        carEntity = nil
        carPed = nil
    end)

    carSpawned = false;

    if not ender then
        Wait(math.random(3, 8) * 10000)
        startSpawning(activeLocation)
    end
end)

RegisterNetEvent('kk-oxyrun:client:startSelling', function(data, packages)
    local locationData = cfg.sellLocations[data.location]
    print(json.encode(locationData))

    if locationData then
        KKF.RemoveBlip('oxy_dealer_' .. activeDealer)
        activeDealer = nil
        TriggerEvent('kk-hud2:client:showInstruction', managerName, 'Nüüd mine ja müü pakid kundedele maha.')
        activeLocation = data.location
        

        SetNewWaypoint(locationData.coords.xy)
        KKF.CreateBlip('oxy_sell_' .. data.location, locationData.coords.xyz, 'Müügipunkt', 108, 47, 0.8)

        sellPoint = lib.points.new({
            coords = locationData.coords.xyz,
            distance = 20
        })
         
        function sellPoint:onEnter()
            if not isSelling then
                isSelling = true
                TriggerEvent('kk-hud2:client:showInstruction', managerName, 'Oota kuni kunded kohale saabuvad.')
                startSpawning(activeLocation)
            end
        end

        function sellPoint:onExit()
            if isSelling then
                isSelling = false

                TriggerEvent('kk-oxyrun:client:givePackage', true)
                TriggerEvent('kk-hud2:client:showInstruction', managerName, 'Lahkusid müügitsoonist, hetkel tööots pausil.')
            end
        end
    end
end)

CreateThread(function()
    while not LocalPlayer.state.isLoggedIn do
        Wait(2000)
    end

    cfg = lib.callback.await('kk-oxyrun:fetchConfig', false)

    Wait(2000)

    for i = 1, #cfg.peds do
        exports['kk-scripts']:requestModel(cfg.peds[i].hash)
        cfg.peds[i].entity = CreatePed(4, cfg.peds[i].hash, cfg.peds[i].coords.x, cfg.peds[i].coords.y, cfg.peds[i].coords.z - 1, cfg.peds[i].coords.w, false, false)

        PlaceObjectOnGroundProperly(cfg.peds[i].entity)
        SetBlockingOfNonTemporaryEvents(cfg.peds[i].entity, true)
        SetPedDiesWhenInjured(cfg.peds[i].entity, false)
        SetPedCanPlayAmbientAnims(cfg.peds[i].entity, true)
        SetPedCanRagdollFromPlayerImpact(cfg.peds[i].entity, false)
        SetEntityInvincible(cfg.peds[i].entity, true)
        FreezeEntityPosition(cfg.peds[i].entity, true)

        local point = lib.points.new({
            coords = vec3(cfg.peds[i].coords.x, cfg.peds[i].coords.y, cfg.peds[i].coords.z + 1),
            distance = 5,
            name = cfg.peds[i].name
        })
        
        function point:nearby()
            KKF.Functions.DrawText3D(self.coords, self.name)
        end

        exports.ox_target:addLocalEntity(cfg.peds[i].entity, {
            {
                name = 'oxy_ped_' .. i,
                distance = 1.5,
                icon = 'fa-solid fa-microphone',
                label = 'Suhtle mehega',
                onSelect = function()
                    interactPed(i) 
                end,

                canInteract = function()
                    return not (activeDealer or activeLocation)
                end
            },

            {
                name = 'oxy_ped_' .. i .. '_end',
                distance = 1.5,
                icon = 'fa-solid fa-rectangle-xmark',
                label = 'Katkesta tööots',
                serverEvent = 'kk-oxyrun:server:cleanRun',
                canInteract = function()
                    return activeDealer or activeLocation
                end,
            }
        })
    end

    for i = 1, #cfg.dealerLocations do
        exports['kk-scripts']:requestModel(`a_m_m_mexcntry_01`)
        local entity = CreatePed(4, `a_m_m_mexcntry_01`, cfg.dealerLocations[i].x, cfg.dealerLocations[i].y, cfg.dealerLocations[i].z - 1, cfg.dealerLocations[i].w, false, false)

        PlaceObjectOnGroundProperly(entity)
        SetBlockingOfNonTemporaryEvents(entity, true)
        SetPedDiesWhenInjured(entity, false)
        SetPedCanPlayAmbientAnims(entity, true)
        SetPedCanRagdollFromPlayerImpact(entity, false)
        SetEntityInvincible(entity, true)
        FreezeEntityPosition(entity, true)

        exports.ox_target:addLocalEntity(entity, {
            {
                name = 'oxy_dealer_' .. i,
                distance = 1.5,
                icon = 'fa-solid fa-hand',
                label = 'Sebi pakke',

                canInteract = function()
                    return activeDealer == i
                end,

                onSelect = function()
                    local progress = exports['kk-taskbar']:startAction('take_package', 'Võtad mehelt paki', 5000, false, false, {freeze = false, controls = true})
        
                    if progress then
                        TriggerServerEvent('kk-oxyrun:server:takePackage')
                    end
                end
            }
        })

        dealerPeds[#dealerPeds + 1] = entity
    end
end)

RegisterNetEvent('kk-oxyrun:client:cleanRun', function()
    if activeDealer then
        KKF.RemoveBlip('oxy_dealer_' .. activeDealer); activeDealer = nil
    end

    if activeLocation then
        KKF.RemoveBlip('oxy_sell_' .. activeLocation); activeLocation = nil
    end

    if isSelling then
        isSelling = false
    end

    if sellPoint then
        sellPoint:remove(); sellPoint = nil
    end

    if carSpawned then
        carSpawned = false
    end

    if DoesEntityExist(carEntity) then
        SetEntityAsMissionEntity(carEntity, false, false)
        SetEntityAsNoLongerNeeded(carEntity)
        TaskVehicleDriveWander(carPed, carEntity, 100.0, 786436)

        SetTimeout(5000, function()
            DeleteEntity(carEntity); carEntity = nil
        end)
    end

    if DoesEntityExist(carPed) then
        SetEntityAsMissionEntity(carPed, false, false)
        SetEntityAsNoLongerNeeded(carPed)
        ClearPedTasks(carPed)

        SetTimeout(5000, function()
            DeleteEntity(carPed); carPed = nil
        end)
    end

    SetTimeout(5000, function()
        if ignoreVehicle then
            for k,v in pairs(ignoreVehicle) do
                DeleteEntity(k)
            end
        end
    end)

    if managerName then 
        TriggerEvent('kk-hud2:client:hideInstruction')
        managerName = nil
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if cfg.peds then
            for i = 1, #cfg.peds do
                DeletePed(cfg.peds[i].entity)
            end
        end

        if dealerPeds then
            for i = 1, #dealerPeds do
                DeletePed(dealerPeds[i])
            end
        end

        if cfg.sellLocations then
            for i = 1, #cfg.sellLocations do
                KKF.RemoveBlip('oxy_sell_' .. i)
            end
        end

        if cfg.dealerLocations then
            for i = 1, #cfg.dealerLocations do
                KKF.RemoveBlip('oxy_dealer_' .. i)
            end
        end

        if carSpawned then
            carSpawned = false
        end

        if DoesEntityExist(carEntity) then
            DeleteEntity(carEntity); carEntity = nil
        end

        if DoesEntityExist(carPed) then
            DeleteEntity(carPed); carPed = nil
        end

        if ignoreVehicle then
            for k,v in pairs(ignoreVehicle) do
                DeleteEntity(k)
            end
        end

        if managerName then 
            TriggerEvent('kk-hud2:client:hideInstruction')
            managerName = nil
        end
    end
end)