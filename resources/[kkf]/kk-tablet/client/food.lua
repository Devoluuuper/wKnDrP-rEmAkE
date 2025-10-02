local houseLists = {}
local current = {
    boxZone = nil,
    coords = nil,
    npc = nil,
    target = nil,
    blip = nil,
    distance = nil
}

CreateThread(function()
	lib.callback('kk-tablet:getHouses', false, function(response)
		houseLists = response
    end)
end)

RegisterNUICallback('setRecieve', function(args, cb)
    lib.callback('kk-tablet:food:setRecieve', false, function(response)
        cb(response)
    end)
end)

RegisterNUICallback('loadFood', function(args, cb)
    lib.callback('kk-tablet:food:requestData', false, function(response)
        cb(response)
    end)
end)

RegisterNetEvent('kk-tablet:food:removeJob', function()
    if current.boxZone then current.boxZone:remove() end; current.coords = nil

    if current.npc then 
        exports.ox_target:removeEntity({NetworkGetNetworkIdFromEntity(current.npc)}, {'giveFood'})

        DeletePed(current.npc); current.npc = nil
    end

    RemoveBlip(current.blip); current.blip = nil
    SendNUIMessage({action = 'removeJobInfo'})
end)

RegisterNUICallback('cancelJob', function(args, cb)
    lib.callback('kk-tablet:food:cancelJob', false, function(response)
        cb(response); if current.boxZone then current.boxZone:remove() end; current.coords = nil

        if current.npc then 
            exports.ox_target:removeEntity({NetworkGetNetworkIdFromEntity(current.npc)}, {'giveFood'})

            DeletePed(current.npc); current.npc = nil
        end

        RemoveBlip(current.blip); current.blip = nil
        TriggerEvent('KKF.UI.ShowNotification', 'info', 'Lõpetasite tööotsa!')
    end)
end)

RegisterNUICallback('loadJob', function(args, cb)
    lib.callback('kk-tablet:food:loadJob', false, function(response)
        cb(response)
    end, args.id)
end)

RegisterNUICallback('setWaypoint', function(args, cb)
    SetNewWaypoint(current.coords.x, current.coords.y)
    TriggerEvent('KKF.UI.ShowNotification', 'info', 'Marker määratud!')
    cb(1)
end)

local function createBlip()
    current.blip = AddBlipForRadius(current.coords.x, current.coords.y, 0.0, 30.0)
    SetBlipSprite(current.blip, 9)
    SetBlipColour(current.blip, 1)
    SetBlipAlpha(current.blip, 80) 
end

local function makeEntityFaceEntity(entity1, entity2)
    local p1 = GetEntityCoords(entity1, true)
    local p2 = GetEntityCoords(entity2, true)

    local dx = p2.x - p1.x
    local dy = p2.y - p1.y

    local heading = GetHeadingFromVector_2d(dx, dy)
    SetEntityHeading( entity1, heading )
end

local function createDelivery()
    local randomLocation = houseLists[math.random(1, #houseLists)]
    local playerCoords = GetEntityCoords(cache.ped)
    current.coords = randomLocation.polyZone.coords; SetNewWaypoint(current.coords.x, current.coords.y)
    createBlip()

    current.boxZone = lib.zones.box({
        coords = randomLocation.polyZone.coords,
        size = vec3(50, 50, math.abs(300 - 0)),
        rotation = randomLocation.polyZone.heading,
        debug = false,
        onEnter = function()
            if current.boxZone then current.boxZone:remove(); end

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
                            name = 'giveFood',
                            icon = 'fa-solid fa-hand',
                            label = 'Anna kaup üle',
                            distance = 1.5,
            
                            onSelect = function(args)
                                lib.callback('kk-tablet:food:canFinish', false, function(canFinish)
                                    if canFinish then
                                        if cache.vehicle then
                                            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ei saa seda tegevust autos teha!')
                                        else
                                            makeEntityFaceEntity(cache.ped, current.npc); makeEntityFaceEntity(current.npc, cache.ped)
        
                                            SetPedTalk(current.npc)
                                            PlayAmbientSpeech1(current.npc, 'GENERIC_HI', 'SPEECH_PARAMS_STANDARD')
            
                                            TaskPlayAnim(current.npc, 'mp_common', 'givetake1_a', 8.0, 8.0, -1, 0, 1, false, false, false)
                                            local progress = exports['kk-taskbar']:startAction('give_food', 'Annad asju üle', 3000, 'givetake1_a', 'mp_common', {freeze = true, controls = true})
            
                                            if progress then
                                                lib.callback('kk-tablet:food:finishJob', false, function(response)
                                                    PlayAmbientSpeech1(current.npc, 'GENERIC_THANKS', 'SPEECH_PARAMS_STANDARD')
                
                                                    SendNUIMessage({action = 'removeJobInfo'})
                        
                                                    if current.npc then 
                                                        exports.ox_target:removeEntity({NetworkGetNetworkIdFromEntity(current.npc)}, {'giveFood'})
                                                        if DoesEntityExist(args.entity) then SetEntityAsMissionEntity(args.entity, true, true); DeletePed(args.entity) end

                                                        DeletePed(current.npc); current.npc = nil
                                                        RemoveBlip(current.blip); current.blip = nil
                                                    end
                                                end)   
    
                                                current.coords = nil
                                            end
                                        end
                                    else
                                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil ei ole kõiki tellitud esemeid!')
                                    end
                                end)
                            end
                        }
                    })
                end
            end, cfg.peds[math.random(1, #cfg.peds)], randomLocation.polyZone.coords, randomLocation.polyZone.heading)
        end
    })
end

RegisterNUICallback('acceptJob', function(args, cb)
    lib.callback('kk-tablet:food:acceptJob', false, function(response)
        cb(response)

        createDelivery()
    end, args.id)
end)

RegisterNetEvent('kk-tablet:food:reloadFoods', function()
    SendNUIMessage({action = 'reloadFoods'})
end)