local current = {
    boxZone = nil,
    coords = nil,
    npc = nil,
    target = nil,
    blip = nil,
    distance = nil,
    contractId = nil
}

RegisterNUICallback('setRecieve', function(args, cb)
    lib.callback('kk-tablet:setRecieve', false, function(response)
        cb(response)
    end, args.state)
end)

RegisterNUICallback('loadFood', function(args, cb)
    lib.callback('kk-tablet:loadFood', false, function(response)
        cb(response)
    end)
end)

RegisterNetEvent('kk-tablet:removeJob')
AddEventHandler('kk-tablet:removeJob', function()
    if current.boxZone then current.boxZone:remove() end
    current.coords = nil
    current.contractId = nil
    if current.npc then 
        exports.ox_target:removeEntity({NetworkGetNetworkIdFromEntity(current.npc)}, {'giveFood'})
        DeletePed(current.npc)
        current.npc = nil
    end
    RemoveBlip(current.blip)
    current.blip = nil
    SendNUIMessage({action = 'removeJobInfo'})
end)

RegisterNUICallback('cancelJob', function(args, cb)
    lib.callback('kk-tablet:cancelJob', false, function(response)
        cb(response)
        if response then
            if current.boxZone then current.boxZone:remove() end
            current.coords = nil
            current.contractId = nil
            if current.npc then 
                exports.ox_target:removeEntity({NetworkGetNetworkIdFromEntity(current.npc)}, {'giveFood'})
                DeletePed(current.npc)
                current.npc = nil
            end
            RemoveBlip(current.blip)
            current.blip = nil
            TriggerClientEvent('KKF.UI.ShowNotification', -1, 'info', 'Tööots tühistatud!')
        end
    end, args.id)
end)

RegisterNUICallback('loadJob', function(args, cb)
    lib.callback('kk-tablet:loadJob', false, function(response)
        cb(response)
    end, args.id)
end)

RegisterNUICallback('setWaypoint', function(args, cb)
    if current.coords then
        SetNewWaypoint(current.coords.x, current.coords.y)
        TriggerClientEvent('KKF.UI.ShowNotification', -1, 'info', 'Marker määratud!')
        cb(1)
    else
        TriggerClientEvent('KKF.UI.ShowNotification', -1, 'error', 'Asukoht puudub!')
        cb(0)
    end
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
    SetEntityHeading(entity1, heading)
end

local function createDelivery(contractId)
    if not contractId or contractId == 0 then
        TriggerClientEvent('KKF.UI.ShowNotification', -1, 'error', 'Viga: vigane tööotsa ID!')
        return
    end
    local randomLocation = cfg.foods.locations[math.random(1, #cfg.foods.locations)]
    local playerCoords = GetEntityCoords(cache.ped)
    current.coords = randomLocation.coords
    current.contractId = contractId
    SetNewWaypoint(current.coords.x, current.coords.y)
    createBlip()
    current.boxZone = lib.zones.box({
        coords = vec3(current.coords.x, current.coords.y, current.coords.z),
        size = vec3(50, 50, math.abs(300 - 0)),
        rotation = current.coords.w,
        debug = false,
        onEnter = function()
            if current.boxZone then current.boxZone:remove() end
            lib.callback('KKF.Entity.SpawnPed', false, function(networkId)
                if networkId then
                    while not NetworkDoesEntityExistWithNetworkId(networkId) do
                        Wait(10)
                    end
                    current.npc = NetworkGetEntityFromNetworkId(networkId)
                    NetworkRequestControlOfEntity(current.npc)
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
                            onSelect = function()
                                lib.callback('kk-tablet:canFinish', false, function(canFinish)
                                    if canFinish then
                                        if cache.vehicle then
                                            TriggerClientEvent('KKF.UI.ShowNotification', -1, 'error', 'Te ei saa seda tegevust autos teha!')
                                        else
                                            makeEntityFaceEntity(cache.ped, current.npc)
                                            makeEntityFaceEntity(current.npc, cache.ped)
                                            SetPedTalk(current.npc)
                                            PlayAmbientSpeech1(current.npc, 'GENERIC_HI', 'SPEECH_PARAMS_STANDARD')
                                            TaskPlayAnim(current.npc, 'mp_common', 'givetake1_a', 8.0, 8.0, -1, 0, 1, false, false, false)
                                            local progress = exports['kk-taskbar']:startAction('give_food', 'Annad asju üle', 3000, 'givetake1_a', 'mp_common', {freeze = true, controls = true})
                                            if progress then
                                                lib.callback('kk-tablet:finishJob', false, function(response)
                                                    PlayAmbientSpeech1(current.npc, 'GENERIC_THANKS', 'SPEECH_PARAMS_STANDARD')
                                                    SendNUIMessage({action = 'removeJobInfo'})
                                                    if current.npc then 
                                                        exports.ox_target:removeEntity({NetworkGetNetworkIdFromEntity(current.npc)}, {'giveFood'})
                                                        if DoesEntityExist(current.npc) then 
                                                            SetEntityAsMissionEntity(current.npc, true, true)
                                                            DeletePed(current.npc)
                                                        end
                                                        current.npc = nil
                                                        RemoveBlip(current.blip)
                                                        current.blip = nil
                                                        current.contractId = nil
                                                    end
                                                end, current.contractId)
                                            end
                                        end
                                    else
                                        TriggerClientEvent('KKF.UI.ShowNotification', -1, 'error', 'Teil ei ole kõiki tellitud esemeid!')
                                    end
                                end, current.contractId)
                            end
                        }
                    })
                end
            end, cfg.peds[math.random(1, #cfg.peds)], vec3(current.coords.x, current.coords.y, current.coords.z), current.coords.w)
        end
    })
end

RegisterNUICallback('acceptJob', function(args, cb)
    lib.callback('kk-tablet:acceptJob', false, function(response)
        if response then
            createDelivery(args.id)
        else
            TriggerClientEvent('KKF.UI.ShowNotification', -1, 'error', 'Tööotsa vastuvõtmine ebaõnnestus!')
        end
        cb(response)
    end, args.id)
end)

RegisterNetEvent('kk-tablet:reloadFoods')
AddEventHandler('kk-tablet:reloadFoods', function()
    SendNUIMessage({action = 'reloadFoods'})
end)