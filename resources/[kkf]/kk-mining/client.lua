cfg = {}

local inZone = false

local pickaxeEntity = nil
local currentlyMining = false
local startedMiningAt = nil

local ped = nil

local busy = false

RegisterNetEvent('kk-mining:client:healthRefresh', function(point, health)
    if cfg.locations then
        cfg.locations[point].health = health
    end
end)

RegisterNetEvent('kk-mining:client:locationRefresh', function(locations)
    if cfg.locations then
        cfg.locations = locations
    end
end)

local function loadAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Wait(5)
	end
end

local function registerPeds()
    SetTimeout(5000, function()
        exports['kk-scripts']:requestModel(`s_m_m_gardener_01`)
        local entity = CreatePed(4, `s_m_m_gardener_01`, cfg.seller.x, cfg.seller.y, cfg.seller.z - 1, cfg.seller.w, false, false)

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
                name = 'minerman',
                distance = 1.5,
                icon = 'fa-solid fa-money-bill',
                label = 'Müü saadusi',
                serverEvent = 'kk-mining:server:sell'
            }
        })
    end)
end

CreateThread(function()
    if LocalPlayer.state.isLoggedIn then
        registerPeds()
    end
end)

local function deRegisterPeds()
    if ped then
        exports.ox_target:removeLocalEntity(ped.entity, {'minerman'})
        DeleteObject(ped.prop); DeletePed(ped.entity); ped = nil
    end
end

RegisterNetEvent('KKF.Player.Loaded', function(playerData)
    ESX.PlayerData = playerData
    registerPeds()
end)

RegisterNetEvent('KKF.Player.Unloaded', function()
    ESX.PlayerData = {}
    deRegisterPeds()
end)

function startMining(index)
    currentlyMining = index

    TaskTurnPedToFaceCoord(cache.ped, cfg.locations[index].target.coords, 1000)
    Wait(1000)

    if IsPedArmed(cache.ped, 7) then
        SetCurrentPedWeapon(ped, 0xA2719263, true)
    end

    local progress = exports['kk-taskbar']:startAction('uptake', 'Valmistud tööks...', 5000, 'idle_e', 'mini@triathlon', {freeze = true, controls = true})

    if progress then
        ESX.ShowInteraction('Katkesta tegevus', 'C')

        startedMiningAt = GetEntityCoords(cache.ped)

        pickaxeEntity = exports['kk-scripts']:spawnAttachedObject(cache.ped, joaat('prop_tool_pickaxe'), 57005, 0.08, -0.06, -0.04, 290.0, 15.0, 4.0)
        miningAnimationLoop()
        positionCheckLoop()
    else
        startedMiningAt = nil
        currentlyMining = false
    end
end

local canRecieve = true

function miningAnimationLoop()
    cancelListenerLoop()
    Wait(1000)

    CreateThread(function()
        lib.requestAnimDict('melee@large_wpn@streamed_core')
        
        while currentlyMining do
            TaskPlayAnim(cache.ped, 'melee@large_wpn@streamed_core', 'ground_attack_on_spot', 8.0, 8.0, -1, 80, 0, 0, 0, 0)
            Wait(1000)

            if canRecieve then
                canRecieve = false

                SetTimeout(2 * 60000, function()
                    canRecieve = true
                end)

                lib.callback.await('kk-mining:foundItem', false, currentlyMining)
            end

            wait = 2500

            Wait(wait)
        end
    end)
end

AddStateBagChangeHandler('isDead', nil, function(bagName, key, value) 
    local player = GetPlayerFromStateBagName(bagName)

    if player == cache.playerId then 
        if value then
            stopMining()
        end
	end
end)

RegisterNetEvent('KKF.Player.Unloaded', function()
    stopMining()
end)

function cancelListenerLoop()
    CreateThread(function()
        while true do
            if currentlyMining then
                if IsControlJustReleased(0, 26) then
                    stopMining()
                    return
                end
            else
                return
            end

            Wait(0)
        end
    end)
end

function positionCheckLoop()
    CreateThread(function()
        while true do
            Wait(2000)

            if currentlyMining then
                local currentPositon = GetEntityCoords(cache.ped)
                
                if #(currentPositon - startedMiningAt) > 1.5 then
                    TriggerEvent('KKF.UI.ShowNotification', 'error', 'Liikusite liiga kaugele!')
                    stopMining()
                end
            else
                return
            end
        end
    end)
end

exports('currentlyMining', function()
    return currentlyMining
end)

function stopMining()
    ESX.HideInteraction()
    currentlyMining = false   

    ClearPedTasks(cache.ped)

    DetachEntity(pickaxeEntity, 1, true)
    DeleteEntity(pickaxeEntity)
    
    pickaxeEntity = nil
    startedMiningAt = nil
end

local function startThreads()
    CreateThread(function()
        ESX.CreateBlip('miner', cfg.blip, 'Kaevandus', 587, 5, 0.7)

        for i = 1, #cfg.smithing do
            local currentId = i
            local currentLocation = cfg.smithing[currentId]

            ESX.CreateBlip('smith_' .. i, currentLocation.coords, 'Sulatus', 417, 5, 0.7)

            exports.ox_target:addBoxZone({
                coords = currentLocation.coords,
                size = currentLocation.size,
                rotation = currentLocation.rotation,
                debug = false,
                options = {
                    {
                        icon = 'fa-solid fa-hand',
                        label = 'Sulata',
                        distance = 1.5,
        
                        onSelect = function(args)
                            exports['kk-crafting']:openCraftMenu('mining')
                        end,

                        canInteract = function()
                            return not currentlyMining and not cache.vehicle
                        end
                    }
                }
            })
        end

        for i = 1, #cfg.locations do
            local currentId = i
            local currentLocation = cfg.locations[currentId]

            currentLocation.point = lib.points.new({
                coords = currentLocation.target.coords,
                distance = 5
            })

            function currentLocation.point:nearby()
                local color = {44, 130, 201}

                if cfg.locations[currentId].health < 15 then
                    color = {198, 27, 13}
                end

                DrawMarker(20, self.coords.x, self.coords.y, self.coords.z + 1, 0, 0, 0, 0, 0, 0, 0.4, 0.5, 0.2, color[1], color[2], color[3], 91, 0, 0, 0, 0)
            end

            exports.ox_target:addBoxZone({
                coords = currentLocation.target.coords,
                size = currentLocation.target.size,
                rotation = currentLocation.target.rotation,
                debug = false,
                options = {
                    {
                        icon = 'fa-solid fa-hand',
                        label = 'Raiu',
                        distance = 1.5,
        
                        onSelect = function(args)
                            startMining(i)
                        end,

                        canInteract = function()
                            return not currentlyMining and not cache.vehicle
                        end
                    }
                }
            })
        end
    end)
end

CreateThread(function()
    cfg = lib.callback.await('kk-mining:recieveData', false)

    startThreads()
end)