local data = {
    functional = nil,
    type = '',
    garage = '',
    spawnPoint = false,
    slot = nil,
    house = nil
}

local currentLocation = nil

CreateThread(function() 
    KKF.PlayerData = KKF.GetPlayerData() 
end)

local function loadAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Wait(5)
	end
end

RegisterNetEvent('kk-garages:client:updateData', function(inZone, type, garage, spawn)
    data = {
        functional = inZone and 'garage' or false,
        type = type,
        garage = garage,
        spawnPoint = spawn,
        slot = nil
    }
end)

CreateThread(function()
    for k,v in pairs(cfg.garages) do
        for k2,v2 in pairs(v.spawnPoints) do
            lib.zones.box({
                coords = v2.coords,
                size = v2.size,
                rotation = v2.rotation,
                debug = true,

                onEnter = function()
                    if KKF.PlayerData.job and (v.faction and KKF.PlayerData.job.name == v.faction and KKF.PlayerData.job.onDuty and KKF.PlayerData.job.permissions.function11) or v.faction == nil or not KKF.PlayerData.job then
                        data.functional = 'garage'
                        data.garage = k 
                        data.type = v.type
                        data.slot = k2
        
                        KKF.ShowInteraction('Garaaž')
                    end
                end,

                onExit = function()
                    if KKF.PlayerData.job and (v.faction and KKF.PlayerData.job.name == v.faction and KKF.PlayerData.job.onDuty) or v.faction == nil or not KKF.PlayerData.job then
                        data.functional = nil
                        data.garage = k 
                        data.type = v.type
                        data.slot = nil
        
                        KKF.HideInteraction()
                    end
                end
            })
        end
    end

    for k,v in pairs(cfg.impounds) do
        for k2,v2 in pairs(v.spawnPoints) do
            lib.zones.box({
                coords = v2.coords,
                size = v2.size,
                rotation = v2.rotation,
                debug = false,

                onEnter = function()
                    data.functional = 'impound'
                    data.garage = k 
                    data.type = v.type
                    data.slot = k2
    
                    KKF.ShowInteraction('Kindlustus')
                end,

                onExit = function()
                    data.functional = nil
                    data.garage = k 
                    data.type = v.type
                    data.slot = nil
    
                    KKF.HideInteraction()
                end
            })
        end
    end
end)

function isInGarageZone()
    return data.functional
end

local function blipRefresh()
    for k,v in pairs(cfg.garages) do
        KKF.RemoveBlip(k .. '_garage')

        if v.marker then
            if v.faction and (v.faction == KKF.PlayerData.job.name and KKF.PlayerData.job.onDuty) then
                KKF.CreateBlip(k .. '_garage', v.spawnPoints[1].coords, v.type == 'car' and 'Garaaž' or v.type == 'helicopter' and 'Hangaar' or v.type == 'boat' and 'Sadam', v.type == 'car' and 50 or v.type == 'helicopter' and 64 or v.type == 'boat' and 427, nil, 0.5)
            elseif not v.faction then
                KKF.CreateBlip(k .. '_garage', v.spawnPoints[1].coords, v.type == 'car' and 'Garaaž' or v.type == 'helicopter' and 'Hangaar' or v.type == 'boat' and 'Sadam', v.type == 'car' and 50 or v.type == 'helicopter' and 64 or v.type == 'boat' and 427, nil, 0.5)
            end
        end
    end

    for k,v in pairs(cfg.impounds) do
        KKF.CreateBlip(k .. '_impound', v.spawnPoints[1].coords, 'Kindlustus', v.type == 'car' and 500 or v.type == 'helicopter' and 64 or v.type == 'boat' and 427, 60, 0.7)
    end
end

RegisterNetEvent('KKF.Player.Loaded') 
AddEventHandler('KKF.Player.Loaded', function(playerData)
    KKF.PlayerData = playerData
    blipRefresh()
end)

RegisterNetEvent('KKF.Player.Unloaded', function() 
    KKF.PlayerData = {}

    for k,v in pairs(cfg.garages) do
        KKF.RemoveBlip(k .. '_garage')
    end

    for k,v in pairs(cfg.impounds) do
        KKF.RemoveBlip(k .. '_impound')
    end
end)

RegisterNetEvent('KKF.Player.JobUpdate', function(job) 
    KKF.PlayerData.job = job; blipRefresh()
end)

RegisterNetEvent('KKF.Player.DutyChange', function(value) 
    KKF.PlayerData.job.onDuty = value; blipRefresh()
end)

local cam = nil

local vehicleData = {}
local previewActive = nil

local function createCinematicCamera(object)
    if not DoesEntityExist(object) then
        object = cache.ped
    end

    local coords = GetEntityCoords(object)
    
    -- Get the model dimensions (min and max points)
    local minDim, maxDim = GetModelDimensions(GetEntityModel(object))
    
    -- Calculate the model size (distance between min and max points)
    local modelSize = #(maxDim - minDim)
    
    -- Define a zoom factor based on the model size
    local zoomFactor = modelSize * 0.7
    
    -- Get the object's forward vector
    local forwardVector = GetEntityForwardVector(object)
    
    -- Add a small side view offset to the right (you can adjust the value as needed)
    local sideViewOffset = 3.0 -- Move the camera slightly to the right (positive X)

    -- Adjust the camera position relative to the object's size and side view offset
    local cameraX = coords.x + forwardVector.x * zoomFactor - sideViewOffset -- Adding side view to X
    local cameraY = coords.y + forwardVector.y * zoomFactor
    local cameraZ = coords.z + (maxDim.z - minDim.z) -- Adjust height based on model height
    
    -- Create and position the camera
    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    
    SetCamCoord(cam, cameraX, cameraY, cameraZ)
    PointCamAtEntity(cam, object, 0.0, 0.0, 0.0, true)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 0, true, true)
end



local function destroyCamera()
    RenderScriptCams(false, true, 250, 1, 0)
    DestroyCam(cam, false)
end

local isConcealed = false

local function concealEveryone(status)
    isConcealed = status
    local players = GetActivePlayers()

    for _, player in ipairs(players) do
        if player ~= cache.playerId then
            local ped = GetPlayerPed(player)
            NetworkConcealPlayer(player, isConcealed, false)
        end
    end

    if isConcealed then
        SetEntityAlpha(cache.ped, 0, false)
    else
        SetEntityAlpha(cache.ped, 255, false)
        ResetEntityAlpha(cache.ped)
    end
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
        if previewActive then
            DeleteVehicle(previewActive)
        end

        if cam then
            destroyCamera()
        end

        if isConcealed then
            concealEveryone(false)
        end
	end
end)

RegisterNUICallback('closeMenu', function(data, cb)
    SetNuiFocus(false, false)

    destroyCamera(); concealEveryone(false)

    if previewActive then
        DeleteVehicle(previewActive)

        previewActive = nil
    end

    cb(true)
end)

RegisterNUICallback('previewVehicle', function(nui, cb)
    if nui and nui.plate then
        local currentLocation

        if data.slot then
            if data.functional == 'garage' then
                local location = cfg.garages[data.garage].spawnPoints[data.slot]

                currentLocation = vec4(location.coords.x, location.coords.y, location.coords.z, location.rotation)
            elseif data.functional == 'impound' then
                local location = cfg.impounds[data.garage].spawnPoints[data.slot]

                currentLocation = vec4(location.coords.x, location.coords.y, location.coords.z, location.rotation)
            end
        elseif data.spawnPoint then
            currentLocation = data.spawnPoint
        else
            local playerCoords = GetEntityCoords(cache.ped)
            local playerHeading = GetEntityHeading(cache.ped)
            
            currentLocation = vec4(playerCoords.x, playerCoords.y, playerCoords.z, playerHeading)
        end

        if previewActive then
            DeleteVehicle(previewActive)

            previewActive = nil
        end

        local vehData = vehicleData[nui.plate]

        if vehData then
            if IsModelInCdimage(vehData.model) then
                lib.requestModel(vehData.model)
                previewActive = CreateVehicle(vehData.model, currentLocation.xyz, currentLocation.w or currentLocation.h, false, true)

                while not DoesEntityExist(previewActive) do
                    Wait(5)
                end

exports['kk-vehicles']:setVehicleProperties(previewActive, vehData)
                createCinematicCamera(previewActive)
                FreezeEntityPosition(previewActive, true)
                SetEntityCollision(previewActive, false, false)

                cb(true)
            else
                cb(false)
            end
        else
            cb(false)
        end
    else
        cb(false)
    end
end)

RegisterNUICallback('changeName', function(data, cb)
    local result = lib.callback.await('kk-garages:changeNickname', false, data.plate, data.input)

    cb(result)
end)

RegisterNUICallback('buyKey', function(data, cb)
    TriggerServerEvent('kk-garages:server:newKey', data.plate)

    cb(true)
end)

local function openGarage(garage, type)
    local faction = nil

    if cfg.garages[garage] then
        faction = cfg.garages[garage].faction

        if faction and KKF.PlayerData.job.name ~= faction then
            return 
        end
    end

    -- local limit = lib.callback.await('kk-garages:getLimit', false)
    local limit = 1

    lib.callback('kk-garage:getVehicles', false, function(vehicles)
        local elements = {}
        local tabs = {}
        local mainMenuLabel = '';

        if cfg.garages[garage] then
            mainMenuLabel = cfg.garages[garage].label
        else
            mainMenuLabel = 'Garaaž'
        end

        for k,v in pairs(vehicles) do
            if v.type == type and (v.location == garage or garage == 'prison') and not v.police_impound then
                local vehData = json.decode(v.vehicle)

                if v.stored then
                    local vehicleLabel = GetDisplayNameFromVehicleModel(vehData.model)
                    vehicleLabel = GetLabelText(vehicleLabel)

                    if not tabs[vehicleLabel] then
                        tabs[vehicleLabel] = {}
                    end

                    tabs[vehicleLabel][#tabs[vehicleLabel] + 1] = {
                        title = (v.nickname or vehicleLabel),
                        plate = v.plate,

                        body = (vehData.bodyHealth and KKF.Math.Round(vehData.bodyHealth / 10) .. '%' or 'N/A'),
                        engine = (vehData.engineHealth and KKF.Math.Round(vehData.engineHealth / 10) .. '%' or 'N/A'),
                        fuel = (vehData.fuelLevel and KKF.Math.Round(vehData.fuelLevel) .. 'L' or 'N/A')
                    }

                    vehicleData[v.plate] = vehData
                end
            end
        end

        local categories = {}

        for k, v in pairs(tabs) do
            categories[#categories + 1] = k
        end

        concealEveryone(true)

        SendNUIMessage({
            action = 'openMenu',
            data = {
                type = 'garage',
                label = mainMenuLabel,

                tabs = tabs,
                categories = categories,

                keyPrice = cfg.newKeyPrice,
                limits = limit
            }
        })

        local currentLocation

        if data.slot then
            local location = cfg.garages[data.garage].spawnPoints[data.slot]

            currentLocation = vec4(location.coords.x, location.coords.y, location.coords.z, location.rotation)
        elseif data.spawnPoint then
            currentLocation = data.spawnPoint
        else
            local playerCoords = GetEntityCoords(cache.ped)
            local playerHeading = GetEntityHeading(cache.ped)
            
            currentLocation = vec4(playerCoords.x, playerCoords.y, playerCoords.z, playerHeading)
        end

        SetEntityHeading(cache.ped, currentLocation.w)
        createCinematicCamera()
        SetNuiFocus(true, true)
    end, garage, faction)
end

exports('openGarage', openGarage)

local function isVehicleEmptyOwned(vehicle)
    local returnable = true

    if DoesEntityExist(vehicle) then
        local numSeats = GetVehicleMaxNumberOfPassengers(vehicle)

        for i = -1, numSeats do
            local occupant = GetPedInVehicleSeat(vehicle, i)

            if i ~= -1 then
                if occupant ~= 0 then
                    returnable = false
                end
            end
        end
    end

    return returnable
end

local function storeVehicle(garage, type)
    local attached = Entity(cache.vehicle).state.attached

    if not attached then
        local faction = nil

        if cfg.garages[garage] then -- quasaar housing lisa
            faction = cfg.garages[garage].faction
        end

        KKF.Game.RequestNetworkControlOfEntity(cache.vehicle)

        if isVehicleEmptyOwned(cache.vehicle) then
            lib.callback('KKF.Vehicle.DeleteOwnedVehicle', false, function(status)
                if status then
                    TriggerEvent('KKF.UI.ShowNotification', "success","Sõiduk edukalt hoiustatud!")
                else
                    TriggerEvent('KKF.UI.ShowNotification', "error", "Teil pole sõiduki võtmeid, või seda sõidukit ei saa siia parkida!")
                end
            -- end, NetworkGetNetworkIdFromEntity(cache.vehicle), KKF.Game.GetVehicleProperties(cache.vehicle), garage, faction)
        end, KKF.Game.GetVehicleProperties(cache.vehicle), garage, faction)
        else
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Sõiduki hoiustamiseks peab sõiduk tühi olema!')
        end
    else
        TriggerEvent('KKF.UI.ShowNotification', "error", "Eemaldage enne hoiustamist sõiduk puksiirilt!")
    end
end

exports('storeVehicle', storeVehicle)

RegisterNUICallback('spawnVehicle', function(nui, cb)
    local success = nil

    if DoesEntityExist(previewActive) then
        local currentLocation

        if data.slot then
            if data.functional == 'garage' then
                local location = cfg.garages[data.garage].spawnPoints[data.slot]

                currentLocation = vec4(location.coords.x, location.coords.y, location.coords.z, location.rotation)
            elseif data.functional == 'impound' then
                local location = cfg.impounds[data.garage].spawnPoints[data.slot]

                currentLocation = vec4(location.coords.x, location.coords.y, location.coords.z, location.rotation)
            end
        elseif data.spawnPoint then
            currentLocation = data.spawnPoint
        else
            local playerCoords = GetEntityCoords(cache.ped)
            local playerHeading = GetEntityHeading(cache.ped)
            
            currentLocation = vec4(playerCoords.x, playerCoords.y, playerCoords.z, playerHeading)
        end

        if data.functional == 'impound' then
            local canPay, moneyNeeded = lib.callback.await('kk-garage:impoundPayment', false, vehicleData[nui.plate].model or 0, nui.plate)

            if not canPay then
                return TriggerEvent('KKF.UI.ShowNotification', "error", "Teil ei ole pangas piisavalt raha! ($" .. moneyNeeded .. ')')
            end
        end

        lib.callback('KKF.Vehicle.SpawnOwnedVehicle', false, function(networkId)
            if not networkId then
                cb(false)
                TriggerEvent('KKF.UI.ShowNotification', "error", "Palun proovi uuesti!")
                return 
            end 
    
            while not NetworkDoesEntityExistWithNetworkId(networkId) do
                Wait(10)
            end
    
            local vehicle = NetworkGetEntityFromNetworkId(networkId)
            KKF.Game.RequestNetworkControlOfEntity(vehicle)
            SetVehRadioStation(vehicle, "OFF")
            SetVehicleHasBeenOwnedByPlayer(vehicle, true)
            PlaceObjectOnGroundProperly(vehicle)

            if data.functional == 'impound' then
                -- lib.callback.await('kk-scripts:fuelVehicle', false, vehicle)
                Entity(vehicle).state.fuel = 100
            end

            TriggerEvent('KKF.UI.ShowNotification', "success", "Sõiduk väljastatud!")

            if previewActive and DoesEntityExist(previewActive) then
                DeleteVehicle(previewActive)

                previewActive = nil
            end

            destroyCamera(); concealEveryone(false)

            cb(true)
        end, nui.plate, currentLocation)
    else
        cb(false)
        TriggerEvent('KKF.UI.ShowNotification', "error", "Sõiduk ei ole veel tekkinud!")
        return
    end
end)

local function calculateImpoundPrice(model)
    model = tonumber(model)
    local vehiclePrice = 50000

    if exports['kk-vehicleshop']:getVehiclePrice(model) then
        vehiclePrice = exports['kk-vehicleshop']:getVehiclePrice(model)
    -- elseif exports['kk-factions']:getVehiclePrice(model) then
    --     vehiclePrice = exports['kk-factions']:getVehiclePrice(model)
    end

    local impoundPrice = KKF.Math.Round(vehiclePrice * (exports['kk-taxes']:getTax('impound').value / 100))
    local realPrice = impoundPrice + KKF.Math.Round(KKF.Math.Percent(exports['kk-taxes']:getTax('primary').value, impoundPrice))

    return realPrice
end

local function openImpound(name, type)
    lib.callback('kk-garage:getVehicles', false, function(vehicles)
        lib.callback('kk-garage:getFactionVehicles', false, function(vehicles2)
            local elements = {}
            local tabs = {}

            for k,v in pairs(vehicles) do
                if v.type == type then
                    local vehicleDeleted = false
                    local vehData = json.decode(v.vehicle)
    
                    -- if not v.stored and not v.police_impound then
                    --     vehicleDeleted = lib.callback.await('kk-garages:isVehicleDeleted', false, v.plate)
                    -- end
                    if not v.stored and v.impoundable and not v.police_impound then
                    -- if not v.stored and (v.impoundable or vehicleDeleted) and not v.police_impound then
                        local vehicleLabel = GetDisplayNameFromVehicleModel(vehData.model)
                        vehicleLabel = GetLabelText(vehicleLabel)
    
                        if not tabs[vehicleLabel] then
                            tabs[vehicleLabel] = {}
                        end
    
                        tabs[vehicleLabel][#tabs[vehicleLabel] + 1] = {
                            title = (v.nickname or vehicleLabel),
                            plate = v.plate,
    
                            body = (vehData.bodyHealth and KKF.Math.Round(vehData.bodyHealth / 10) .. '%' or 'N/A'),
                            engine = (vehData.engineHealth and KKF.Math.Round(vehData.engineHealth / 10) .. '%' or 'N/A'),
                            fuel = (vehData.fuelLevel and KKF.Math.Round(vehData.fuelLevel) .. 'L' or 'N/A'),

                            price = calculateImpoundPrice(vehData.model)
                        }
    
                        vehicleData[v.plate] = vehData
                    end
                end
            end

            for k,v in pairs(vehicles2) do
                if v.type == type then
                    local vehicleDeleted = false
                    local vehData = json.decode(v.vehicle)
    
                    -- if not v.stored and not v.police_impound then
                    --     vehicleDeleted = lib.callback.await('kk-garages:isVehicleDeleted', false, v.plate)
                    -- end
                    if not v.stored and v.impoundable and not v.police_impound then
                    -- if not v.stored and (v.impoundable or vehicleDeleted) and not v.police_impound then
                        local vehicleLabel = GetDisplayNameFromVehicleModel(vehData.model)
                        vehicleLabel = GetLabelText(vehicleLabel)
    
                        if not tabs[vehicleLabel] then
                            tabs[vehicleLabel] = {}
                        end
    
                        tabs[vehicleLabel][#tabs[vehicleLabel] + 1] = {
                            title = (v.nickname or vehicleLabel),
                            plate = v.plate,
    
                            body = (vehData.bodyHealth and KKF.Math.Round(vehData.bodyHealth / 10) .. '%' or 'N/A'),
                            engine = (vehData.engineHealth and KKF.Math.Round(vehData.engineHealth / 10) .. '%' or 'N/A'),
                            fuel = (vehData.fuelLevel and KKF.Math.Round(vehData.fuelLevel) .. 'L' or 'N/A'),

                            price = calculateImpoundPrice(vehData.model)
                        }
    
                        vehicleData[v.plate] = vehData
                    end
                end
            end

            local categories = {}

            for k, v in pairs(tabs) do
                categories[#categories + 1] = k
            end
    
            concealEveryone(true)
    
            SendNUIMessage({
                action = 'openMenu',
                data = {
                    type = 'impound',
                    label =  'Kindlustus',

                    tabs = tabs,
                    categories = categories,
    
                    keyPrice = cfg.newKeyPrice,
                    limits = limit
                }
            })
    
            local currentLocation
    
            if data.slot then
                local location = cfg.impounds[data.garage].spawnPoints[data.slot]
    
                currentLocation = vec4(location.coords.x, location.coords.y, location.coords.z, location.rotation)
            elseif data.spawnPoint then
                currentLocation = data.spawnPoint
            else
                local playerCoords = GetEntityCoords(cache.ped)
                local playerHeading = GetEntityHeading(cache.ped)
                
                currentLocation = vec4(playerCoords.x, playerCoords.y, playerCoords.z, playerHeading)
            end

            SetEntityHeading(cache.ped, currentLocation.w)
            createCinematicCamera()
            SetNuiFocus(true, true)       
        end, name)
    end, name)
end

AddEventHandler('kk-garages:client:garageAction', function()
    if data.functional then
        if data.functional == 'garage' then
            if not cache.vehicle then
                openGarage(data.garage, data.type)
            else
                if cache.seat == -1 then
                    storeVehicle(data.garage, data.type)
                end
            end
        else
            if not cache.vehicle then
                openImpound(data.garage, data.type)
            end
        end
    end
end)

RegisterNetEvent('kk-garages:client:markLocation', function(garage)
    SetNewWaypoint(cfg.garages[garage].polyZone.pos.x, cfg.garages[garage].polyZone.pos.y)
end)

local function isVehicleEmpty(vehicle)
    local returnable = true

    if DoesEntityExist(vehicle) then
        local numSeats = GetVehicleMaxNumberOfPassengers(vehicle)

        for i = -1, numSeats do
            local occupant = GetPedInVehicleSeat(vehicle, i)

            if occupant ~= 0 then
                returnable = false
            end
        end
    end

    return returnable
end

lib.onCache('vehicle', function(value)
    if not value and data.functional then
        if cache.vehicle and not Entity(cache.vehicle).state.spawned then
            if isVehicleEmpty(cache.vehicle) then
                DeleteEntity(cache.vehicle)
            end
        end
    end
end)