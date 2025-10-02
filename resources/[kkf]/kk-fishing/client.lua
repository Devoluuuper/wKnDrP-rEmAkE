local currentlyFishing = false
local rodEntity = nil
local bandHeight = 0.01
local polyZones = {}
local itemNames = {}
local inZone = false

local ped = nil

local function activateScript()
    for item, data in pairs(exports.ox_inventory:Items()) do 
        itemNames[item] = data.label
    end

    for i = 1, #cfg.zones do
        KKF.CreateBlip('fish_' .. i, cfg.zones[i].coords, 'Kalastus', 317, 52, 1.0)

        polyZones[#polyZones + 1] = lib.zones.poly({
            points = cfg.zones[i].points,
            thickness = 900.0,
            debug = false,

            onEnter = function()
                TriggerEvent('KKF.UI.ShowNotification', 'info', 'Siin saate kala püüda.')
                
                inZone = true
            end,
            
            onExit = function()
                TriggerEvent('KKF.UI.ShowNotification', 'info', 'Siin te enam kala püüda ei saa.')

                inZone = false 
            end
        })
    end

    local function loadAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            RequestAnimDict(dict)
            Wait(5)
        end
    end

    RegisterNetEvent('kk-fishing:client:sell', function(args)
        local progress = exports['kk-taskbar']:startAction('sell', 'Räägid mehega', 1500, false, false, {freeze = false, controls = true})

        if progress then
            lib.callback.await('kk-fishing:sell', false, args.item)
        end
    end)

    RegisterNetEvent('kk-fishing:client:buy', function(args)
        local input = lib.inputDialog('Eseme ost', { { type = "number", label = "Kogus", placeholder = "123" } })
        if not input then return end

        lib.callback.await('kk-fishing:buy', false, args.item, input[1])
    end)

    local function registerPeds()
        SetTimeout(5000, function()
            exports['kk-scripts']:requestModel(cfg.pedModel)

            KKF.CreateBlip('fishMan', cfg.fishingPed.xyz, 'Kalamees', 317, 52, 1.0)
            local entity = CreatePed(4, cfg.pedModel, cfg.fishingPed.x, cfg.fishingPed.y, cfg.fishingPed.z - 1, cfg.fishingPed.w, false, false)

            SetBlockingOfNonTemporaryEvents(entity, true)
            SetPedDiesWhenInjured(entity, false)
            SetPedCanPlayAmbientAnims(entity, true)
            SetPedCanRagdollFromPlayerImpact(entity, false)
            SetEntityInvincible(entity, true)
            FreezeEntityPosition(entity, true)

            loadAnimDict('missfam4')
            TaskPlayAnim(entity, 'missfam4', 'base', 8.0, 1.0, -1, 49, 0, 0, 0, 0)

            local newProp = CreateObject(`p_amb_clipboard_01`, GetEntityCoords(entity).x, GetEntityCoords(entity).y, GetEntityCoords(entity).z + 0.2, false, false, false)

            while not DoesEntityExist(newProp) do Wait(50) end

            SetEntityCollision(newProp, false, false)
            AttachEntityToEntity(newProp, entity, GetPedBoneIndex(entity, 36029), 0.16, 0.08, 0.1, -130.0, -50.0, 0.0, true, true, false, true, 1, true)

            ped = {entity = entity, prop = newProp}

            exports.ox_target:addLocalEntity(entity, {
                {
                    name = 'license',
                    distance = 1.5,
                    icon = 'fa-solid fa-id-card',
                    label = 'Kalastusluba ($' .. cfg.license .. ' + VAT ' .. exports['kk-taxes']:getTax('primary').value .. '%.)',
                    serverEvent = 'kk-fishing:server:buyId'
                },

                {
                    icon = 'fa-solid fa-basket-shopping',
                    label = 'Osta',
                    distance = 1.5,

                    onSelect = function(args)
                        local elements = {}

                        for k,v in pairs(cfg.shop) do
                            if v.buy then
                                elements[#elements + 1] = {
                                    title = itemNames[v.item],
                                    description = 'Hind: $' .. v.buy .. ' + VAT ' .. exports['kk-taxes']:getTax('primary').value .. '%.',
                                    event = 'kk-fishing:client:buy',
                                    args = {item = k}
                                }
                            end
                        end

                        lib.registerContext({
                            id = 'buy_fish',
                            title = 'Ost',
                            options = elements
                        })

                        lib.showContext('buy_fish')
                    end
                },

                {
                    icon = 'fa-solid fa-money-bill',
                    label = 'Müü',
                    distance = 1.5,

                    onSelect = function(args)
                        local elements = {}

                        for k,v in pairs(cfg.shop) do
                            if v.sell then
                                elements[#elements + 1] = {
                                    title = itemNames[v.item],
                                    description = 'Hind: $' .. v.sell,
                                    event = 'kk-fishing:client:sell',
                                    args = {item = k}
                                }
                            end
                        end

                        lib.registerContext({
                            id = 'sell_fish',
                            title = 'Müük',
                            options = elements
                        })

                        lib.showContext('sell_fish')
                    end
                }
            })
        end)
    end

    RegisterNetEvent('KKF.Player.Loaded', registerPeds)

    local function deRegisterPeds()
        if ped then
            exports.ox_target:removeLocalEntity(ped.entity, {'fishing'})
            DeleteObject(ped.prop); DeletePed(ped.entity); ped = nil
        end
    end

    RegisterNetEvent('KKF.Player.Unloaded', deRegisterPeds)

    local function playAnim(ped, base, sub)
        CreateThread(function()
            lib.requestAnimDict(base)

            if IsEntityPlayingAnim(ped, base, sub, 3) then
                ClearPedSecondaryTask(ped)
            end

            TaskPlayAnim(ped, base, sub, 16.0, 10.0, -1, 1, 0.2, 0, 0, 0)
        end)
    end

    local function showInteraction()
        CreateThread(function()
            KKF.ShowInteraction('Lõpeta', 'C')

            while currentlyFishing do
                Wait(500)
            end

            KKF.HideInteraction()
        end)
    end

    local function cancelFishing()
        DeleteEntity(rodEntity)
        ClearPedTasks(cache.ped)
        currentlyFishing = false
    end

    RegisterNetEvent('kk-fishing:client:startFishing', function()
        if inZone then
            if not currentlyFishing then
                if not cache.vehicle and not IsPedSwimming(cache.ped) then
                    local distance = 1.5
                    local position = GetEntityCoords(cache.ped)
                    local heading = GetEntityHeading(cache.ped)
                    local radius = math.pi / 2 + math.rad(heading)
                    local coord = { x = position.x + distance * math.cos(radius), y = position.y + distance * math.sin(radius), z = position.z + 1 }
            
                    local loopCounter = 5
                    local counter = 0
                    local loopTimeout = 30000
                    local ChangementAnim = true
    
                    rodEntity = exports['kk-scripts']:spawnAttachedObject(cache.ped, joaat('prop_fishing_rod_01'), 60309, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                    playAnim(cache.ped, 'amb@world_human_stand_fishing@base', 'base')
                    currentlyFishing = true
                    showInteraction()
            
                    while currentlyFishing do
                        if counter == 0 then
                            playAnim(cache.ped, 'amb@world_human_stand_fishing@base', 'base')
                            cfg.animationSpeed = 0.0015
                        end
            
                        if IsControlJustPressed(1, 26) then
                            cancelFishing()
                        end
            
                        if counter < loopTimeout then
                            counter = counter + loopCounter
                        else
                            if ChangementAnim then
                                playAnim(cache.ped, 'amb@world_human_stand_fishing@idle_a', 'idle_c')
                                ChangementAnim = false
                            end
    
                            -- Random delay to simulate catching fish
                            local randomDelay = math.random(4000, 6000)
                            Wait(randomDelay)
    
                            lib.callback.await('kk-fishing:recieveFish', false)
                            counter = 0
                            loopTimeout = math.floor(math.random(4000, 6000))
                            ChangementAnim = true
                            cancelFishing()
                        end
    
                        Wait(0)
                    end
                end
            end
        end
    end)
end

CreateThread(function()
    cfg = lib.callback.await('kk-fishing:requestConfig', false)

    activateScript()
end)