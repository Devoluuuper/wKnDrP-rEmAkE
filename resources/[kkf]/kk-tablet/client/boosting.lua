local blips = {}
local current = {
    active = false,
    vehicleLocation = {},
    agroSpawned = false, 
    class = nil,
    blips = {},
    npc = nil,
    vehicle = nil,
    deliveryPos = nil,
    vehiclePos = nil,
    vehiclePoly = nil,
    agroPeds = {}
}

CreateThread(function()
    KKF.PlayerData = KKF.GetPlayerData()
end)

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

RegisterNetEvent('kk-tablet:boosting:lockpicedWaypoint', function(netId)
    local entity = NetworkGetEntityFromNetworkId(netId)

    if DoesEntityExist(entity) then
        if entity == current.vehicle then
            if current.deliveryPos then
                SetNewWaypoint(current.deliveryPos.x, current.deliveryPos.y)
            end
        end
    end
end)

RegisterNetEvent('kk-tablet:boosting:removeContract', function(novehdel)
    exports.ox_target:removeEntity({NetworkGetNetworkIdFromEntity(current.npc)}, {'giveVehicle', 'scratchVehicle'})

    current.class = nil;
    current.active = false;
    current.agroSpawned = false;
    current.deliveryPos = nil;
    current.vehiclePos = nil;
    current.vehicleLocation = {}

    if current.deliveryPoly then
        current.deliveryPoly:remove(); current.deliveryPoly = nil
    end

    if current.vehiclePoly then
        current.vehiclePoly:remove(); current.vehiclePoly = nil
    end

    DeletePed(current.npc); current.npc = nil

    if not novehdel then
        DeleteVehicle(current.vehicle); current.vehicle = nil
    end

    for k,v in pairs(current.blips) do
        RemoveBlip(v); current.blips[k] = nil
    end

    for k,v in pairs(current.agroPeds) do
        DeletePed(v); current.agroPeds[k] = nil
    end

    TriggerServerEvent('kk-tablet:boosting:syncBlips', nil, NetworkGetNetworkIdFromEntity(current.vehicle))

    SendNUIMessage({action = 'removeContractInfo'})
end)

RegisterNUICallback('setBoostingRecieve', function(args, cb)
    lib.callback('kk-tablet:boosting:setRecieve', false, function(response)
        cb(response)
    end)
end)

RegisterNUICallback('loadBoostingData', function(args, cb)
    lib.callback('kk-tablet:boosting:requestData', false, function(response)
        cb(response)
    end)
end)

RegisterNUICallback('cancelBoost', function(args, cb)
    lib.callback('kk-tablet:boosting:cancelBoost', false, function(response)
        cb(response)
    end, args.id)
end) 

RegisterNUICallback('loadBoostingContract', function(args, cb)
    lib.callback('kk-tablet:boosting:loadContract', false, function(response)
        cb(response)
    end, args.id)
end)

RegisterNetEvent('kk-tablet:boosting:spawnAgro', function(plate)
    if current.vehicle and GetVehicleNumberPlateText(current.vehicle) == plate then
        if not current.agroSpawned and current.active then
            current.agroSpawned = true

            if cfg.boosting.classes[current.class].agroPeds then
                for i = 1, cfg.boosting.classes[current.class].agroPeds do
                    local pedSpawn = current.vehicleLocation.pedSpawns[math.random(1, #current.vehicleLocation.pedSpawns)]
                    local pedModel = cfg.boosting.agroPeds[math.random(1, #cfg.boosting.agroPeds)]

                    exports['kk-scripts']:requestModel(joaat(pedModel))
                    local pedEntity = CreatePed(1, joaat(pedModel), pedSpawn.x, pedSpawn.y, pedSpawn.z, 0.0, true, true)

                    KKF.Game.RequestNetworkControlOfEntity(pedEntity)
                    SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(pedEntity), true)
                    SetEntityMaxHealth(pedEntity, 200)
                    SetEntityHealth(pedEntity, 200)
                    SetPedArmour(pedEntity, 100)
                    SetPedAsCop(pedEntity, true)
                    SetPedRelationshipGroupHash(pedEntity, joaat("HATES_PLAYER"))
                    GiveWeaponToPed(pedEntity, joaat(cfg.boosting.classes[current.class].agroWeapons[math.random(1, #cfg.boosting.classes[current.class].agroWeapons)]), 250, false, true)
                    SetCanAttackFriendly(pedEntity, false, true)
                    SetPedCombatMovement(pedEntity, 3)
                    SetPedCombatRange(pedEntity, 2)
                    SetPedCombatAttributes(pedEntity, 46, true)
                    SetPedCombatAttributes(pedEntity, 0, false)
                    SetPedAccuracy(pedEntity, 60)
                    SetPedCombatAbility(pedEntity, 100)
                    TaskCombatPed(pedEntity, cache.ped, 0, 16)
                    SetPedKeepTask(pedEntity, true)
                    SetPedSeeingRange(pedEntity, 150.0)
                    SetPedHearingRange(pedEntity, 150.0)
                    SetPedAlertness(pedEntity, 3)
                    SetPedDropsWeaponsWhenDead(pedEntity, false)
                    SetPedFleeAttributes(pedEntity, 0, 0)
                    TaskGoToCoordAnyMeans(pedEntity, current.vehiclePos.x, current.vehiclePos.y, current.vehiclePos.z, 5.0, 0, 0, 786603, 0xbf800000)
    
                    current.agroPeds[i] = pedEntity
                end
            end
        end
    end
end)

local function randomizeTuning(vehicle)
    CreateThread(function()
        SetVehicleModKit(vehicle, 0)

        local chance = math.random(1, 100)

        if chance >= 50 then
            local performanceModIndices = { 11, 12, 13, 15, 16 }
    
            for _, modType in ipairs(performanceModIndices) do
                max = GetNumVehicleMods(vehicle, tonumber(modType)) - 1
                SetVehicleMod(vehicle, modType, max, false)
            end
    
            ToggleVehicleMod(vehicle, 18, true) -- Turbo
        end

        local primaryColor = math.random(0, 159)
        local secondaryColor = math.random(0, 159)
        SetVehicleColours(vehicle, primaryColor, secondaryColor)
    
        local pearlescentColor = math.random(0, 159)
        local wheelColor = math.random(0, 159)
        SetVehicleExtraColours(vehicle, pearlescentColor, wheelColor)
    
        local liveryCount = GetVehicleLiveryCount(vehicle)
        if liveryCount > 0 then
            local livery = math.random(0, liveryCount - 1)
            SetVehicleLivery(vehicle, livery)
        end

        local windowTints = {0, 1, 2, 3, 4, 5}
        local windowTint = windowTints[math.random(#windowTints)]
        SetVehicleWindowTint(vehicle, windowTint)

        local mods = {
            0,  -- Spoilers
            1,  -- Front bumpers
            2,  -- Rear bumpers
            3,  -- Side skirts
            4,  -- Exhaust
            5,  -- Frame
            6,  -- Grille
            7,  -- Hood
            8,  -- Fenders
            9,  -- Right fender
            10, -- Roof
            22  -- Headlights (Xenon)
        }

        for _, modType in ipairs(mods) do
            local modCount = GetNumVehicleMods(vehicle, modType)
            
            if modCount > 0 then
                local modIndex = math.random(-1, modCount - 1)
                SetVehicleMod(vehicle, modType, modIndex, false)
            end
        end
    end)
end

local function startBoosting(model, class, plate)
    local search = {}
    current.vehicleLocation = cfg.boosting.classes[class].spawnPoints[math.random(1, #cfg.boosting.classes[class].spawnPoints)]
    current.class = class

    current.deliveryPos = cfg.boosting.deliveryPoints[math.random(1, #cfg.boosting.deliveryPoints)]
    current.vehiclePos = current.vehicleLocation.vehicleSpawn

    current.blips[1] = AddBlipForRadius(current.vehiclePos.x + math.random(-145, 145), current.vehiclePos.y + math.random(-145, 145), 0.0, 250.0)
    SetBlipSprite(current.blips[1], 9)
    SetBlipColour(current.blips[1], 1)
    SetBlipAlpha(current.blips[1], 80)

    current.blips[2] = AddBlipForCoord(current.deliveryPos)
    SetBlipSprite(current.blips[2], 596)
    SetBlipColour(current.blips[2], 6)
    SetBlipScale(current.blips[2], 0.7)
    SetBlipDisplay(current.blips[2], 4)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Tarnepunkt')
    EndTextCommandSetBlipName(current.blips[2])

    current.active = true

    current.vehiclePoly = lib.zones.box({
        coords = vec3(current.vehiclePos.x, current.vehiclePos.y, current.vehiclePos.z),
        size = vec3(300, 300, math.abs(300 - 0)),
        rotation = 0.0,
        debug = false,
        onEnter = function()
            if current.vehiclePoly then current.vehiclePoly:remove(); current.vehiclePoly = nil end
            ClearAreaOfVehicles(current.vehiclePos.x, current.vehiclePos.y, current.vehiclePos.z, 5.0, false, false, false, false, false)

            lib.callback('KKF.Entity.SpawnVehicle', false, function(networkId)
                if not networkId then 
                    TriggerEvent('KKF.UI.ShowNotification', 'error', 'Tekkis viga!')
                    return 
                end 
        
                while not NetworkDoesEntityExistWithNetworkId(networkId) do
                    Wait(10)
                end

                local vehicle = NetworkGetEntityFromNetworkId(networkId)
                KKF.Game.RequestNetworkControlOfEntity(vehicle)

                TriggerServerEvent('kk-tablet:server:boosting:setState', networkId)
                SetVehicleNumberPlateText(vehicle, plate)
                SetVehRadioStation(vehicle, 'OFF')
                SetVehicleDoorsLocked(vehicle, 2);
                randomizeTuning(vehicle)

                current.deliveryPoly = lib.zones.box({
                    coords = vec3(current.deliveryPos.x, current.deliveryPos.y, current.deliveryPos.z),
                    size = vec3(300, 300, math.abs(300 - 0)),
                    rotation = 0.0,
                    debug = false,
                    onExit = function()
                        if current.npc then
                            if DoesEntityExist(current.npc) then 
                                SetEntityAsMissionEntity(current.npc, true, true)
                                DeletePed(current.npc)
                                exports.ox_target:removeEntity({NetworkGetNetworkIdFromEntity(current.npc)}, {'giveVehicle', 'scratchVehicle'})

                                current.npc = nil 
                            end
                        end 
                    end,
                    onEnter = function()
                        if not current.npc then
                            lib.callback('KKF.Entity.SpawnPed', false, function(networkId)
                                if networkId then
                                    while not NetworkDoesEntityExistWithNetworkId(networkId) do
                                        Wait(10)
                                    end
                
                                    current.npc = NetworkGetEntityFromNetworkId(networkId)
                                    KKF.Game.RequestNetworkControlOfEntity(current.npc)
                
                                    PlaceObjectOnGroundProperly(current.npc)
                                    SetBlockingOfNonTemporaryEvents(current.npc, true)
                                    SetPedDiesWhenInjured(current.npc, false)
                                    SetPedCanPlayAmbientAnims(current.npc, true)
                                    SetPedCanRagdollFromPlayerImpact(current.npc, false)
                                    SetEntityInvincible(current.npc, true)
                                    FreezeEntityPosition(current.npc, true)
                
                                    exports.ox_target:addEntity({networkId}, {
                                        {
                                            name = 'scratchVehicle',
                                            icon = 'fa-solid fa-comments-dollar',
                                            label = 'Müü sõiduk',
                                            distance = 7.0,
                            
                                            onSelect = function(args)
                                                if cache.vehicle then
                                                    local hackTime = lib.callback.await('kk-tablet:boosting:getHackTime', false, KKF.Game.GetPlate(cache.vehicle))

                                                    if (cfg.boosting.classes[current.class].hack and hackTime) or (not cfg.boosting.classes[current.class].hack and not hackTime) then
                                                        if (cfg.boosting.classes[current.class].hack and hackTime == 0) or (not cfg.boosting.classes[current.class].hack and not hackTime) then
                                                            local progress = exports['kk-taskbar']:startAction('sellDrugs', 'Annad kaupa üle', 5000, false, false, {freeze = true, controls = true})
            
                                                            if progress then
                                                                lib.callback('kk-tablet:boosting:finishContract', false, function(response)
                                                                    if response then
                                                                        TaskLeaveVehicle(cache.ped, cache.vehicle, 64)
        
                                                                        SetTimeout(2500, function()
                                                                            if current.deliveryPoly then current.deliveryPoly:remove(); current.deliveryPoly = nil end
                                                                            TriggerEvent('kk-tablet:boosting:removeContract')
        
                                                                            if DoesEntityExist(args.entity) then SetEntityAsMissionEntity(args.entity, true, true); DeletePed(args.entity) end
                                                                            if DoesEntityExist(cache.vehicle) then SetEntityAsMissionEntity(cache.vehicle, true, true); DeleteEntity(cache.vehicle) end
                                                                        end)
                                                                    else
                                                                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Sa vigurvänt tõid mulle vale auto!')
                                                                    end
                                                                end, NetworkGetNetworkIdFromEntity(cache.vehicle), exports['kk-vehicles']:getVehicleProperties(cache.vehicle), false)
                                                            end
                                                        else
                                                            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Eemalda kõigepealt GPS seade - mina sind ei tunne!')
                                                        end
                                                    else
                                                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Sa vigurvänt tõid mulle vale auto!')
                                                    end
                                                else
                                                    TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ei ole üheski sõidukis')
                                                end
                                            end
                                        },

                                        {
                                            name = 'giveVehicle',
                                            icon = 'fa-solid fa-hand',
                                            label = 'Kraabi VIN-i',
                                            distance = 7.0,
                            
                                            onSelect = function(args)
                                                if cache.vehicle then
                                                    local hackTime = lib.callback.await('kk-tablet:boosting:getHackTime', false, KKF.Game.GetPlate(cache.vehicle))

                                                    if (cfg.boosting.classes[current.class].hack and hackTime) or (not cfg.boosting.classes[current.class].hack and not hackTime) then
                                                        if (cfg.boosting.classes[current.class].hack and hackTime == 0) or (not cfg.boosting.classes[current.class].hack and not hackTime) then
                                                            local price = lib.callback.await('kk-tablet:boosting:getVinPrice', false)
                                                            local alert = lib.alertDialog({
                                                                header = 'VIN-i kraapimine',
                                                                content = 'Selle sõiduki VIN-i kraapimine läheb teile maksma $' .. price .. '.',
                                                                centered = true,
                                                                cancel = true
                                                            })
                                                    
                                                            if alert == 'confirm' then
                                                                local progress = exports['kk-taskbar']:startAction('sellDrugs', 'VIN-koodi kraabitakse...', 5000, false, false, {freeze = true, controls = true})
                
                                                                if progress then
                                                                    lib.callback('kk-tablet:boosting:finishContract', false, function(response)
                                                                        if response then
                                                                            SetTimeout(500, function()
                                                                                if current.deliveryPoly then current.deliveryPoly:remove(); current.deliveryPoly = nil end
                                                                                TriggerEvent('kk-tablet:boosting:removeContract', true)
            
                                                                                if DoesEntityExist(args.entity) then SetEntityAsMissionEntity(args.entity, true, true); DeletePed(args.entity) end
                                                                            end)
                                                                        else
                                                                            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Sa vigurvänt tulid vale autoga!')
                                                                        end
                                                                    end, NetworkGetNetworkIdFromEntity(cache.vehicle), exports['kk-vehicles']:getVehicleProperties(cache.vehicle), true)
                                                                end
                                                            end
                                                        else
                                                            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Eemalda kõigepealt GPS seade - mina sind ei tunne!')
                                                        end
                                                    else
                                                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Sa vigurvänt tulid vale autoga!')
                                                    end
                                                else
                                                    TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ei ole üheski sõidukis')
                                                end
                                            end
                                        },
                                    })
                                end
                            end, cfg.peds[math.random(1, #cfg.peds)], current.deliveryPos, current.deliveryPos.w)
                        end
                    end
                })

                current.vehicle = vehicle
            end, model, current.vehiclePos)
        end
    })
end

RegisterNetEvent('kk-tablet:boosting:syncBlips', function(coords, newNet, plate)
    if LocalPlayer.state.isLoggedIn then
        if KKF.PlayerData.job.name == 'police' and KKF.PlayerData.job.onDuty then
            if blips[newNet] then RemoveBlip(blips[newNet]); blips[newNet] = nil end

            if coords then
                blips[newNet] = AddBlipForCoord(coords.x, coords.y, coords.z)
                SetBlipSprite(blips[newNet], 161)
                SetBlipScale(blips[newNet], 1.0)
                SetBlipColour(blips[newNet], 8)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString('Prioriteetne sõiduk - ' .. plate)
                EndTextCommandSetBlipName(blips[plate])

                PulseBlip(blips[newNet])
            end
        else
            if blips[newNet] then RemoveBlip(blips[newNet]); blips[newNet] = nil end
        end
    end
end)

local function startBlips(vehicle)
    local hackTimes = lib.callback.await('kk-tablet:boosting:getHackTime', false, KKF.Game.GetPlate(vehicle))

    if hackTimes then
        TriggerServerEvent('kk-dispatch:server:sendMessage', 'Sõiduki vargus', '10-98', {'police'}, { {'fa-solid fa-car-side', GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))}, {'fa-solid fa-id-card', KKF.Game.GetPlate(vehicle)} }, 'bg-red-700', nil, nil)

        CreateThread(function()
            while hackTimes > 0 do
                TriggerServerEvent('kk-tablet:boosting:syncBlips', GetEntityCoords(vehicle), NetworkGetNetworkIdFromEntity(vehicle))

                if not DoesEntityExist(vehicle) then
                    lib.callback.await('kk-tablet:boosting:cancelBoost', false)
                    break
                end

                Wait(60000 / hackTimes) -- Max 10 seconds, the more times hacked the less time it updates
                hackTimes = lib.callback.await('kk-tablet:boosting:getHackTime', false, KKF.Game.GetPlate(vehicle)) -- Makes it so that it dosnt get the state from the car twice on first run
            end

            TriggerServerEvent('kk-tablet:boosting:syncBlips', nil, NetworkGetNetworkIdFromEntity(vehicle))
            TriggerEvent('KKF.UI.ShowNotification', 'success', 'Sõiduki GPS häkitud!')
        end)
    end
end

local cooldown = 0

SetInterval(function()
    if cooldown > 0 then
        cooldown -= 1

        if cooldown == 0 then
            TriggerEvent('KKF.UI.ShowNotification', 'info', 'Süsteemi turvaluku taimer resetis!')
        end
    end
end, 1000)

local function isOwned(vehicle)
    return lib.callback.await('kk-garages:isPlayerOwned', false, KKF.Game.GetPlate(vehicle))
end

RegisterNetEvent('kk-tablet:boosting:specialLockpick', function(slot)
    lib.callback('kk-scripts:checkLockpick', false, function(pickCount)
        if pickCount > 0 then
            if cache.vehicle then
                if Entity(cache.vehicle).state.robberyStarted then
                    TriggerEvent('kk-robberies:truck_robbery:client:doHack', slot)
                else
                    local hackTimes = lib.callback.await('kk-tablet:boosting:getHackTime', false, KKF.Game.GetPlate(cache.vehicle))
        
                    if hackTimes then
                        if hackTimes > 0 then
                            lib.callback('kk-tablet:boosting:canHackGps', false, function(response)
                                if response then
                                    if cache.seat == 0 then
                                        if cooldown == 0 then
                                            local success = exports['boostinghack']:StartHack();
                        
                                            if success then
                                                cooldown = 15
                                                TriggerServerEvent('kk-tablet:boosting:updateTime', NetworkGetNetworkIdFromEntity(cache.vehicle))
                                                lib.callback.await('kk-scripts:reduceUsage', false, slot)
            
                                                SetTimeout(500, function()
                                                    hackTimes = lib.callback.await('kk-tablet:boosting:getHackTime', false, KKF.Game.GetPlate(cache.vehicle))
                                                    TriggerEvent('KKF.UI.ShowNotification', 'success', 'Süsteemi häkkimine õnnestus. Teil on jäänud veel ' .. hackTimes .. ' korda häkkida. GPS-i intervall on ' .. (60000 / hackTimes) / 1000 .. ' sekundit.')
                                                end)
                                            else
                                                cooldown = 20
                                                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Süsteemi häkkimine ebaõnnestus.')
                                            end
                                        else
                                            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Enne uuesti häkkimist oota veidi.')
                                        end
                                    else
                                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Sõiduki GPS-i häkkimine on võimalik ainult kõrvalistuja kohalt!')
                                    end
                                end
                            end, KKF.Game.GetPlate(cache.vehicle))
                        end
                    else
                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Selle sõiduki GPS on juba häkitud.')
                    end
                end
            else
                local vehicle, distance = KKF.Game.GetClosestVehicle()
        
                if vehicle and distance < 2.5 then
                    if GetVehicleDoorLockStatus(vehicle) == 2 then
                        lib.callback('kk-tablet:boosting:canSpecialLockpick', false, function(response)
                            if response or isOwned(vehicle) then
                                TriggerEvent('kk-tablet:boosting:spawnAgro', KKF.Game.GetPlate(vehicle));
             
                                local progress = exports['kk-taskbar']:startAction('connecting_slockpick', 'Ühendad seadet', 3000, false, false, {freeze = true, controls = true})
                    
                                if progress then
                                    local success = exports['boostinghack']:StartHack();
                    
                                    if success then
                                        if not isOwned(vehicle) then
                                            startBlips(vehicle)
                                        else
                                            TriggerServerEvent('kk-police:server:onSteal', NetworkGetNetworkIdFromEntity(vehicle), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))))
                                        end

                                        lib.callback.await('kk-scripts:reduceUsage', false, slot)
                        
                                        TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "unlock", 0.3)
                                        SetVehicleDoorsLocked(vehicle, 1); ClearPedTasks(cache.ped)
                                    else
                                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ebaõnnestusite häkkimisel.')
                                    end
                                end
                            else
                                TriggerEvent('KKF.UI.ShowNotification', 'error', 'See sõiduk ei ole teile mõeldud.')
                            end
                        end, KKF.Game.GetPlate(vehicle))
                    end
                end
            end
        else
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Eseme vastupidavus on ammendunud.')
        end
    end, slot)
end)

RegisterNUICallback('acceptBoostingContract', function(args, cb)
    lib.callback('kk-tablet:boosting:acceptBoostingContract', false, function(response)
        if response then
            cb(response);

            startBoosting(response.model, response.class, response.plate)
        else
            cb(false);
        end 
    end, args.id, args.type)

--[[    if args.type == 'scratch' then
        local price = lib.callback.await('kk-tablet:boosting:getVinPrice', false, args.id)
        local alert = lib.alertDialog({
            header = 'VIN-i kraapimine',
            content = 'Selle sõiduki VIN-i kraapimine läheb teile maksma $' .. price .. '.',
            centered = true,
            cancel = true
        })

        if alert == 'confirm' then
            lib.callback('kk-tablet:boosting:acceptBoostingContract', false, function(response)
                if response then
                    cb(response);
        
                    startBoosting(response.model, response.class, response.plate)
                else
                    cb(false);
                end 
            end, args.id, args.type)
        else
            cb(false);
        end
    else
        lib.callback('kk-tablet:boosting:acceptBoostingContract', false, function(response)
            if response then
                cb(response);
    
                startBoosting(response.model, response.class, response.plate)
            else
                cb(false);
            end 
        end, args.id, args.type)
    end]]
end)

RegisterNetEvent('kk-tablet:boosting:reloadBoosting', function()
    SendNUIMessage({action = 'reloadBoosting'})
end)

AddStateBagChangeHandler('isDead', nil, function(bagName, key, value) 
    local player = GetPlayerFromStateBagName(bagName)

    if player == cache.playerId then 
        if value then
            if current.active then
                lib.callback.await('kk-tablet:boosting:cancelBoost', false)
            end
        end
	end
end)

RegisterNUICallback('sellBoostingContract', function(args, cb)
    lib.callback('kk-tablet:requestContractPrice', false, function(response)
        if response then
            cb(true)

            local options = {}
            local players = lib.getNearbyPlayers(GetEntityCoords(cache.ped), 10.0, false)
        
            if #players == 0 then
                return TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ühtegi mängijat ei ole läheduses!')
            end
        
            for i = 1, #players do
                local serverId = GetPlayerServerId(players[i].id) 
                options[#options + 1] = { value = serverId, label = 'Mängija #' .. serverId}
            end
        
            local input = lib.inputDialog('Lepingu müümine', {
                {   
                    icon = 'fa-solid fa-user',
                    label = 'Vali mängija', 
                    type = 'select', 
                    required = true, 
                    options = options
                },

                {
                    type = 'number', 
                    label = 'Sisesta hind', 
                    description = 'Lepingu hind (min. $' .. response .. ')', 
                    required = true,
                    icon = 'fa-solid fa-dollar-sign'
                },
            })
        
            if not input then return end

            TriggerServerEvent('kk-tablet:server:boosting:trySelling', args.id, input[1], input[2])
        else
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Tehing ebaõnnestus!')
            cb(false)
        end
    end, args.id)
end)

RegisterNetEvent('kk-tablet:client:boosting:sellContract', function(price)
    local confirmed = lib.alertDialog({
        header = 'Lepingu ost',
        content = 'Hind: $' .. price,
        centered = true,
        cancel = true
    })

	if confirmed == 'confirm' then
        TriggerServerEvent('kk-tablet:server:boosting:acceptContract')
    else
        TriggerServerEvent('kk-tablet:server:boosting:declineContract')
    end
end)