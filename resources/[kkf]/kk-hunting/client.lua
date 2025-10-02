cfg = {}

local inZone = false

local baitDistanceInUnits = 60
local spawnDistanceRadius = 100

local baitLocation = nil
local baitLastPlaced = 0

local hasHuntingRifle = false
local isFreeAiming = false
local blockShotActive = false
local spawnedTime = 0

local itemNames = {}

exports('isInZone', function()
    return inZone
end)

local function pickAnimalUp(data)
    TriggerEvent('KKF.UI.ShowNotification', 'info', 'Alustad looma nülgimist!')
    TaskTurnPedToFaceEntity(cache.ped, data.entity, -1)

    SetTimeout(1500, function()
        local count = exports.ox_inventory:Search('count', 'hunting_gear')

        if count > 0 then
            local progress = exports['kk-taskbar']:startAction('pick_up_animal', 'Nülgid', 5000, 'player_search', 'anim@gangops@facility@servers@bodysearch@', {freeze = true, controls = true})

            if progress then
                lib.callback.await('kk-hunting:pickUp', false, NetworkGetNetworkIdFromEntity(data.entity))
            end
        else
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Millega nülgid, sõrmega?')
        end
    end)
end

RegisterNetEvent('kk-hunting:client:sell', function(args)
    lib.callback('kk-hunting:sell', false, function(response)
        
    end, args.shop, args.item)
end)

RegisterNetEvent('kk-hunting:client:buy', function(args)
    local input = lib.inputDialog('Eseme ost', { { type = "number", label = "Kogus", placeholder = "123" } })
    if not input then return end

    lib.callback('kk-hunting:buy', false, function(response)

    end, args.shop, args.item, input[1])
end)

local blooding = false

exports('isBlooding', function() -- exports['kk-scripts']:isBlooding()
    return blooding
end)

CreateThread(function()
    KKF.PlayerData = KKF.GetPlayerData()

    for item, data in pairs(exports.ox_inventory:Items()) do 
        itemNames[item] = data.label
    end

    lib.callback('kk-hunting:requestConfig', false, function(response)
        cfg = response

        local huntingZone = lib.zones.poly({
            points = {
                vec(147.79684448242, 6498.6235351562, 0.0),
                vec(-346.11364746094, 6011.3876953125, 0.0),
                vec(-420.19100952148, 5926.8662109375, 0.0),
                vec(-482.23428344727, 5840.6840820312, 0.0),
                vec(-543.35028076172, 5714.095703125, 0.0),
                vec(-584.29046630859, 5625.7221679688, 0.0),
                vec(-614.00274658203, 5584.9682617188, 0.0),
                vec(-683.81677246094, 5532.1171875, 0.0),
                vec(-871.69744873047, 5420.7041015625, 0.0),
                vec(-968.09216308594, 5391.2592773438, 0.0),
                vec(-1014.4145507812, 5356.8510742188, 0.0),
                vec(-1095.9272460938, 5307.75, 0.0),
                vec(-1139.8924560547, 5274.490234375, 0.0),
                vec(-1190.5096435547, 5245.4536132812, 0.0),
                vec(-1216.7919921875, 5245.4077148438, 0.0),
                vec(-1264.4295654297, 5253.2919921875, 0.0),
                vec(-1285.5430908203, 5238.5966796875, 0.0),
                vec(-1294.1123046875, 5222.8369140625, 0.0),
                vec(-1313.9204101562, 5142.7514648438, 0.0),
                vec(-1362.5622558594, 5095.7368164062, 0.0),
                vec(-1454.1018066406, 5033.1508789062, 0.0),
                vec(-1566.5025634766, 4916.9711914062, 0.0),
                vec(-1687.9094238281, 4800.013671875, 0.0),
                vec(-1771.1291503906, 4734.8530273438, 0.0),
                vec(-1808.8494873047, 4646.4462890625, 0.0),
                vec(-1572.7064208984, 4368.3881835938, 0.0),
                vec(-1362.9934082031, 4338.8837890625, 0.0),
                vec(-974.96087646484, 4382.80859375, 0.0),
                vec(-662.73040771484, 4445.5576171875, 0.0),
                vec(-294.09075927734, 4428.9873046875, 0.0),
                vec(-102.26380157471, 4253.2734375, 0.0),
                vec(889.35919189453, 4153.7270507812, 0.0),
                vec(1703.7294921875, 4494.8862304688, 0.0),
                vec(1655.4133300781, 4963.4506835938, 0.0),
                vec(2096.158203125, 5250.4443359375, 0.0),
                vec(2570.5866699219, 5128.9106445312, 0.0),
                vec(2398.9270019531, 5700.7045898438, 0.0),
                vec(1889.7615966797, 6297.1108398438, 0.0),
                vec(1333.9814453125, 6468.03125, 0.0),
                vec(263.81286621094, 6553.5341796875, 0.0)
            },
    
            thickness = 900.0,
            debug = false,
            onEnter = function() inZone = true end,
            onExit = function() inZone = false end
        })
    
        for k,v in pairs(cfg.animals) do
            exports.ox_target:addModel({v.model}, {
                {
                    icon = 'fa-solid fa-hand',
                    label = 'Nülgi',
                    distance = 1.5,
                    canInteract = function(entity) return IsPedDeadOrDying(entity) end,
                    onSelect = pickAnimalUp
                },
            })
        end
    
        for i = 1, #cfg.shops do
            KKF.CreateBlip(i .. '_sell_hunt', cfg.shops[i].target.coords, "Chaparral'i hulgiladu", 59, 2, 0.7)

            exports.ox_target:addBoxZone({
                coords = cfg.shops[i].target.coords,
                size = cfg.shops[i].target.size,
                rotation = cfg.shops[i].target.rotation,
                debug = false,
                options = {
                    {
                        icon = 'fa-solid fa-basket-shopping',
                        label = 'Osta',
                        distance = 1.5,
        
                        onSelect = function(args)
                            local elements = {}
    
                            for k,v in pairs(cfg.shops[i].items) do
                                if v.buy then
                                    elements[#elements + 1] = {
                                        title = itemNames[v.item],
                                        description = 'Hind: $' .. v.buy .. ' + VAT ' .. exports['kk-taxes']:getTax('primary').value .. '%.',
                                        event = 'kk-hunting:client:buy',
                                        args = {item = k, shop = i}
                                    }
                                end
                            end
    
                            lib.registerContext({
                                id = 'buy_meat',
                                title = 'Ost',
                                options = elements
                            })
    
                            lib.showContext('buy_meat')
                        end
                    },
    
                    {
                        icon = 'fa-solid fa-money-bill',
                        label = 'Müü',
                        distance = 1.5,
        
                        onSelect = function(args)
                            local elements = {}
    
                            for k,v in pairs(cfg.shops[i].items) do
                                if v.sell then
                                    elements[#elements + 1] = {
                                        title = itemNames[v.item],
                                        description = 'Hind: $' .. v.sell,
                                        event = 'kk-hunting:client:sell',
                                        args = {item = k, shop = i}
                                    }
                                end
                            end
    
                            lib.registerContext({
                                id = 'sell_meat',
                                title = 'Müük',
                                options = elements
                            })
    
                            lib.showContext('sell_meat')
                        end
                    }
                }
            })
        end
    
        for k,v in pairs(cfg.locations) do
            cfg.locations[k].box = lib.zones.box({
                coords = v.coords,
                size = v.size,
                rotation = v.rotation,
                debug = false,

                onEnter = function()
                    blooding = true
                    --TriggerEvent('kk-hud2:client:showInteract', 'Nülgi')
                end,

                onExit = function()
                    blooding = false
                    --TriggerEvent('kk-hud2:client:hideInteract')
                end
            })
        end
    end)
end)

local function getSpawnLoc()
    local playerCoords = GetEntityCoords(cache.ped)
    local spawnCoords = nil

    while spawnCoords == nil do
        local spawnX = math.random(-spawnDistanceRadius, spawnDistanceRadius)
        local spawnY = math.random(-spawnDistanceRadius, spawnDistanceRadius)
        local spawnZ = baitLocation.z
        local vec = vector3(baitLocation.x + spawnX, baitLocation.y + spawnY, spawnZ)

        if #(playerCoords - vec) > spawnDistanceRadius then
            spawnCoords = vec
        end
    end

    local worked, groundZ, normal = GetGroundZAndNormalFor_3dCoord(spawnCoords.x, spawnCoords.y, 1023.9)
    spawnCoords = vector3(spawnCoords.x, spawnCoords.y, groundZ)
    return spawnCoords
end

local function spawnAnimal(loc)
    local chance = math.random(1, 1000)
    local foundAnimal = false

    for _, animal in pairs(cfg.animals) do
        if foundAnimal == false and chance >= animal.chance then
            foundAnimal = animal
        end
    end

    if foundAnimal then
        local modelName = foundAnimal.model
        exports['kk-scripts']:requestModel(modelName)

        local spawnLoc = getSpawnLoc()
        local spawnedAnimal = CreatePed(28, modelName, spawnLoc, true, true, true)

        spawnedTime += 1

        SetModelAsNoLongerNeeded(modelName)
        TaskGoStraightToCoord(spawnedAnimal, loc, 1.0, -1, 0.0, 0.0)

        CreateThread(function()
            local finished = false

            while not IsPedDeadOrDying(spawnedAnimal) and not finished do
                local spawnedAnimalCoords = GetEntityCoords(spawnedAnimal)

                if #(loc - spawnedAnimalCoords) < 0.5 then
                    ClearPedTasks(spawnedAnimal)
                    Wait(1500)
                    TaskStartScenarioInPlace(spawnedAnimal, 'WORLD_DEER_GRAZING', 0, true)

                    SetTimeout(7500, function()
                        finished = true
                    end)
                end

                if #(spawnedAnimalCoords - GetEntityCoords(cache.ped)) < 15.0 then
                    ClearPedTasks(spawnedAnimal)
                    TaskSmartFleePed(spawnedAnimal, cache.ped, 600.0, -1)
                    finished = true
                end

                Wait(1000)
            end

            if not IsPedDeadOrDying(spawnedAnimal) then
                TaskSmartFleePed(spawnedAnimal, cache.ped, 600.0, -1)
            end
        end)
    end
end

CreateThread(function()
    while true do
        wait = 0

        if baitLocation ~= nil then
            DrawMarker(20, baitLocation.x, baitLocation.y, baitLocation.z + 1, 0, 0, 0, 0, 0, 0, 0.4, 0.5, 0.2, 225, 66, 66, 91, 0, 0, 0, 0)
        else
            wait = 500
        end

        Wait(wait)
    end
end)

local function baitDown()
    spawnedTime = 0

    CreateThread(function()
        while baitLocation ~= nil do
            local coords = GetEntityCoords(cache.ped)

            if #(baitLocation - coords) > baitDistanceInUnits then
                if math.random(1, 100) < 30 then
                    spawnAnimal(baitLocation)

                    if spawnedTime >= 7 then
                        baitLocation = nil
                        spawnedTime = 0
                    end
                end
            end

            Wait(5000)
        end
    end)
end

exports('huntingBait', function()
    if not inZone then
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Sa ei saa seda tegevust siin teha!')
        return
    end

    if baitLastPlaced ~= 0 and GetGameTimer() < (baitLastPlaced + 100000) then -- 5 minutes
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Sa ei saa seda tegevust veel teha!')
        return
    end

    baitLocation = nil
    local progress = exports['kk-taskbar']:startAction('placing_bait', 'Paigaldad sööta', 30000, 'WORLD_HUMAN_GARDENER_PLANT', false, {freeze = true, controls = true})

    if progress then
        baitLastPlaced = GetGameTimer()
        baitLocation = GetEntityCoords(cache.ped)
        TriggerServerEvent('KKF.Player.RemoveItem', 'huntingbait', 1)
        baitDown()
    else
        baitLocation = nil
    end
end)

local function processScope(freeAiming)
    if not isFreeAiming and freeAiming then
        isFreeAiming = true
    elseif isFreeAiming and not freeAiming then
        isFreeAiming = false
    end
end

local function blockShooting()
    if blockShotActive then return end
    blockShotActive = true

    CreateThread(function()
        while hasHuntingRifle do
            local ent = nil
            local aiming, ent = GetEntityPlayerIsFreeAimingAt(cache.playerId)
            local freeAiming = IsPlayerFreeAiming(cache.playerId)
            processScope(freeAiming)
            local et = GetEntityType(ent)
            
            if not freeAiming or IsPedAPlayer(ent) or et == 2 or (et == 1 and IsPedInAnyVehicle(ent)) then
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 47, true)
                DisableControlAction(0, 58, true)
                DisablePlayerFiring(cache.ped, true)
            end

            Wait(0)
        end

        blockShotActive = false
        processScope(false)
    end)
end

CreateThread(function()
    local huntingRifleHash = joaat(cfg.weapon)

    while true do
        if GetSelectedPedWeapon(cache.ped) == huntingRifleHash then
            hasHuntingRifle = true
            blockShooting()
        else
            hasHuntingRifle = false
        end
        
        Wait(1000)
    end
end)