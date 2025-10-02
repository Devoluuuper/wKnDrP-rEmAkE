local inZone = false
local inPrisoned = false
local haveLeaved = false
local peds = {}

exports('checkStatus', function()
    return haveLeaved
end)

exports('inPrison', function()
    return inZone
end)

lib.callback.register('kk-jail:checkZone', function()
    return inZone
end)

RegisterNetEvent('kk-jail:client:leaveJail', function()
    if not inPrisoned then
        haveLeaved = false
        DoScreenFadeOut(650)
        while not IsScreenFadedOut() do Wait(0) end

        FreezeEntityPosition(cache.ped, true)

        Wait(500)
        SetEntityCoords(cache.ped, cfg.lobby)
        if cfg.lobby.w then SetEntityHeading(cache.ped, cfg.lobby.w) end

        Wait(1500)
        DoScreenFadeIn(650)
        while not IsScreenFadedIn() do Wait(0) end

        FreezeEntityPosition(cache.ped, false)

        local model = GetEntityModel(cache.ped)
        
        if model == joaat('mp_m_freemode_01') or model == joaat('mp_f_freemode_01') then
            lib.callback('kk-jail:restoreClothes', false, function(response)
                if response then
                    local currentModel = exports['illenium-appearance']:getPedModel(cache.ped)

                    if response.ped and currentModel ~= response.ped then
                        exports['illenium-appearance']:setPlayerModel(response.ped)
                    end

                    if response.components then
                        exports['illenium-appearance']:setPedComponents(cache.ped, response.components)
                    end

                    if response.props then
                        exports['illenium-appearance']:setPedProps(cache.ped, response.props)
                    end

                    TriggerServerEvent('illenium-appearance:server:saveAppearance', exports['illenium-appearance']:getPedAppearance(cache.ped))
                end
            end)   
        end
    end
end)

local function openMenu()
    local elements = {}
    
    if not inPrisoned then
        elements[#elements + 1] = {
            title = 'Lahku vanglast',
            icon = 'fa-solid fa-door-open',
            event = 'kk-jail:client:leaveJail'
        }
    end

    if inPrisoned then
        elements[#elements + 1] = {
            title = 'Tööd',
            icon = 'fa-solid fa-briefcase',
            menu = 'prison_jobs'
        }
    end

    local jobs = {}

    if not exports['kk-jail']:isCleaning() then
        jobs[#jobs + 1] = {
            title = 'Alusta koristamist',
            icon = 'fa-solid fa-soap',
            serverEvent = 'kk-jail:server:startCleaning'
        }
    elseif exports['kk-jail']:isCleaning() then
        jobs[#jobs + 1] = {
            title = 'Lõpeta koristamine',
            icon = 'fa-solid fa-soap',
            serverEvent = 'kk-jail:server:endCleaning'
        }
    end

    lib.registerContext({
        id = 'prison_jobs',
        title = 'Tööd',
        menu = 'guard_prison',
        options = jobs
    })

    lib.registerContext({
        id = 'guard_prison',
        title = 'Vanglaametnik',
        options = elements
    })

    lib.showContext('guard_prison')
end

local function registerPeds()
    SetTimeout(5000, function()
        for k,v in pairs(cfg.peds) do
            exports['kk-scripts']:requestModel(v.model)
            local entity = CreatePed(4, v.model, v.coords.x, v.coords.y, v.coords.z - 1, v.coords.w or 0, false, false)
    
            SetBlockingOfNonTemporaryEvents(entity, true)
            SetPedDiesWhenInjured(entity, false)
            SetPedCanPlayAmbientAnims(entity, true)
            SetPedCanRagdollFromPlayerImpact(entity, false)
            SetEntityInvincible(entity, true)
            FreezeEntityPosition(entity, true)
    
            if v.type == 'guard' then
                TaskStartScenarioInPlace(entity, 'WORLD_HUMAN_COP_IDLES', 0, true)
            end
        
            peds[#peds + 1] = entity
    
            if v.type == 'guard' then
                exports.ox_target:addLocalEntity(entity, {
                    {
                        name = 'prison_' .. k,
                        distance = 2.0,
                        icon = v.icon,
                        label = v.label,
                        onSelect = openMenu
                    }
                })
            end
        end
    end)
end

local function deRegisterPeds()
	for k,v in pairs(peds) do
        exports.ox_target:removeLocalEntity(peds[k], {'prison_' .. k})
		DeleteEntity(peds[k]); peds[k] = nil
	end
end

CreateThread(function()
	KKF.PlayerData = KKF.GetPlayerData()
end)

RegisterNetEvent('KKF.Player.JobUpdate', function(job)
	KKF.PlayerData.job = job
end)

RegisterNetEvent('KKF.Player.DutyChange', function(value) 
    KKF.PlayerData.job.onDuty = value 
end)

RegisterNetEvent('KKF.Player.Loaded', function(xPlayer)
	KKF.PlayerData = xPlayer; registerPeds()
end)

RegisterNetEvent('KKF.Player.Unloaded', function() 
	KKF.PlayerData = {}; deRegisterPeds()
end)

local isSitting = false
local hasTray = false

local hasFood = 0
local hasThirst = 0

local function giveTray()
    hasTray = true
    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'tray', 0.05)
    local entity = exports['kk-scripts']:spawnAttachedObject(cache.ped, cfg.trayProp, 28422, 0.0100, -0.0400, -0.1390,20.0000007, 0.0, 0.0, 0.0)

    while hasTray do
        if not IsEntityPlayingAnim(cache.ped, 'anim@heists@box_carry@', 'idle', 3) then
            ClearPedTasksImmediately(cache.ped)
            lib.requestAnimDict('anim@heists@box_carry@')
            TaskPlayAnim(cache.ped, 'anim@heists@box_carry@', 'idle', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
        end

        Wait(1000)
    end

    if not isSitting then
        ClearPedTasksImmediately(cache.ped)
    end

    Sync.DeleteObject(entity)
    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'tray', 0.05)
end

RegisterNetEvent('kk-jail:client:recieveConfiscatedItems', function()
    local progress = exports['kk-taskbar']:startAction('talk_jail', 'Vestled ametnikuga', 5000, 'actor_berating_loop', 'misscarsteal4@actor', {freeze = true, controls = true})

    if progress then
        TriggerServerEvent('kk-jail:server:recieveConfiscatedItems')
    end
end)

CreateThread(function()
    exports.ox_target:addBoxZone({
        coords = cfg.reclaimPossessions.coords,
        size = cfg.reclaimPossessions.size,
        rotation = cfg.reclaimPossessions.rotation,
        debug = false,
        options = {
            {
                name = 'itemsBack',
                icon = 'fa-solid fa-bag-shopping',
                label = 'Võta asjad tagasi',
                distance = 1.5,
                event = 'kk-jail:client:recieveConfiscatedItems'
            }
        }
    })

    for k,v in pairs(cfg.foods) do
        exports.ox_target:addBoxZone({
            coords = v.coords,
            size = v.size,
            rotation = v.rotation,
            debug = false,
            options = {
                {
                    name = k .. '_jail',
                    icon = k == 'thirst' and 'fa-solid fa-droplet' or k == 'hunger' and 'fa-solid fa-burger' or k == 'trays' and 'fa-solid fa-stop' or k == 'trays_back' and 'fa-solid fa-hand-holding',
                    label = k == 'thirst' and 'Võta juua' or k == 'hunger' and 'Võta süüa' or k == 'trays' and 'Võta kandik' or k == 'trays_back' and 'Pane kandik tagasi',
                    distance = 2.0,
                    canInteract = function()
                        return (k == 'trays_back' and hasTray) or (k == 'trays' and not hasTray) or (k == 'hunger' and (hasTray and hasFood < 5)) or (k == 'thirst' and (hasTray and hasThirst < 5))
                    end,
                    onSelect = function()
                        if k == 'trays' then
                            if not hasTray then
                                giveTray()
                            else
                                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil on juba üks kandik!')
                            end
                        elseif k == 'trays_back' then
                            hasTray = false

                            if hasFood > 0 or hasThirst > 0 then
                                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Viskasid järelejäänud toidu minema.')
                            end

                            hasFood = 0
                            hasThirst = 0
                        elseif k == 'hunger' then
                            CreateThread(function()
                                for i = 1, 2 do
                                    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'food', 0.05)
                                    Wait(2000)
                                end
                            end)    

                            local progress = exports['kk-taskbar']:startAction('take_food', 'Tõstad kandikule toitu', 4000, false, false, {freeze = false, controls = true})

                            if progress then
                                hasFood = 5
                            end
                        elseif k == 'thirst' then
                            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'drink', 0.05)

                            local progress = exports['kk-taskbar']:startAction('take_food', 'Valad jooki', 3000, false, false, {freeze = false, controls = true})

                            if progress then
                                hasThirst = 5
                            end
                        end
                    end
                }
            }
        })
    end

    for k,v in pairs(cfg.tables) do
        for k2,v2 in pairs(v) do
            exports.ox_target:addBoxZone({
                coords = v2.target.coords,
                size = v2.target.size,
                rotation = v2.target.rotation,
                debug = false,
                options = {
                    {
                        name = 'sit_down_' .. k .. '_' .. k2,
                        icon = 'fa-solid fa-couch',
                        label = 'Istu maha',
                        distance = 1.5,
                        canInteract = function()
                            return not isSitting
                        end,
                        onSelect = function()
                            lib.callback('kk-jail:sitDown', false, function(response)
                                if response then
                                    local object
                                    isSitting = true

                                    if hasTray then
                                        local elements = {}
                                        hasTray = false
                                        object = CreateObject(cfg.trayProp, v2.prop, true, true, true, false)

                                        if hasFood > 0 then
                                            elements[#elements + 1] = {
                                                name = 'eat_food',
                                                icon = 'fa-solid fa-utensils',
                                                label = 'Söö',
                                                distance = 2.0,
                                
                                                onSelect = function(args)
                                                    if hasFood > 0 then
                                                        local progress = exports['kk-taskbar']:startAction('eat_food', 'Sööd', 2500, 'mp_player_int_eat_burger', 'mp_player_inteat@burger', {freeze = false, controls = true, disableClearTasks = true})

                                                        if progress then
                                                            TriggerEvent('kk-needs:client:addNeed', 'hunger', tostring(5000))
                                                            hasFood -= 1

                                                            if hasFood == 0 then
                                                                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil sai söök otsa!')
                                                            end
                                                        end

                                                        lib.requestAnimDict('amb@world_human_hang_out_street@female_arms_crossed@idle_a')
                                                        TaskPlayAnim(cache.ped, 'amb@world_human_hang_out_street@female_arms_crossed@idle_a', 'idle_a', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
                                                    else
                                                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil ei ole rohkem süüa!')
                                                    end
                                                end
                                            }
                                        end

                                        if hasThirst > 0 then
                                            elements[#elements + 1] = {
                                                name = 'drink',
                                                icon = 'fa-solid fa-droplet',
                                                label = 'Joo',
                                                distance = 2.0,
                                
                                                onSelect = function(args)
                                                    if hasThirst > 0 then
                                                        local progress = exports['kk-taskbar']:startAction('eat_food', 'Jood', 2500, 'loop_bottle', 'mp_player_intdrink', {freeze = false, controls = true, disableClearTasks = true})

                                                        if progress then
                                                            TriggerEvent('kk-needs:client:addNeed', 'thirst', tostring(5000))  
                                                            hasThirst -= 1

                                                            if hasThirst == 0 then
                                                                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil sai jook otsa!')
                                                            end
                                                        end

                                                        lib.requestAnimDict('amb@world_human_hang_out_street@female_arms_crossed@idle_a')
                                                        TaskPlayAnim(cache.ped, 'amb@world_human_hang_out_street@female_arms_crossed@idle_a', 'idle_a', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
                                                    else
                                                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil ei ole rohkem jooki!')
                                                    end
                                                end
                                            }
                                        end

                                        exports.ox_target:addEntity({NetworkGetNetworkIdFromEntity(object)}, elements)
                                    end
                                    
                                    KKF.ShowInteraction('[C] Tõuse püsti', 'info')
                                    TaskStartScenarioAtPosition(cache.ped, 'PROP_HUMAN_SEAT_CHAIR_UPRIGHT', v2.target.coords.x, v2.target.coords.y, v2.target.coords.z + 0.2, v2.target.rotation, -1, true, true)
            
                                    lib.requestAnimDict('amb@world_human_hang_out_street@female_arms_crossed@idle_a')
                                    TaskPlayAnim(cache.ped, 'amb@world_human_hang_out_street@female_arms_crossed@idle_a', 'idle_a', 6.0, -6.0, -1, 49, 0, 0, 0, 0)

                                    while isSitting do
                                        if IsControlJustReleased(0, 26) then
                                            TriggerServerEvent('kk-jail:server:leaveChair', k .. '_' .. k2); isSitting = false
                                        end
            
                                        Wait(5)
                                    end

                                    KKF.HideInteraction(); SetEntityCoords(cache.ped, vec3(v2.target.coords.x, v2.target.coords.y, v2.target.coords.z + 0.5)) ClearPedTasksImmediately(cache.ped); isSitting = false

                                    if object then
                                        exports.ox_target:removeEntity({NetworkGetNetworkIdFromEntity(object)}, {'drink', 'eat_food'})
                                        Sync.DeleteObject(object)
                                        giveTray()
                                    end
                                else
                                    TriggerEvent('KKF.UI.ShowNotification', 'error', 'Keegi istub juba sellel toolil.')
                                end
                            end, k .. '_' .. k2)
                        end
                    }
                }
            })
        end
    end
end)

local function enterPrison()
    inZone = true

    if not inPrisoned then
        -- sisenes vangi ilma selleta, et ta oleks vangis
    end
end

local function throwToCell()
    local randomCell = cfg.cells[math.random(1, #cfg.cells)]
    
    SetEntityCoords(cache.ped, randomCell)
    SetEntityHeading(cache.ped, randomCell.w)
end

local function leavePrison()
    inZone = false

    if inPrisoned then
        TriggerEvent('chatMessage', 'DOC' , 'info', 'Teil on veel kandmata karistus!')
        throwToCell()

        CreateThread(function()
            while not inZone do
                throwToCell()
                Wait(1500)
            end
        end)
    end
end

CreateThread(function()
    local prisonZone = lib.zones.poly({
        points = {
            vec(1829.4222412109, 2620.8461914062, 0.0),
            vec(1854.7977294922, 2700.3229980469, 0.0),
            vec(1774.4296875, 2768.7282714844, 0.0),
            vec(1647.1409912109, 2763.0681152344, 0.0),
            vec(1565.4890136719, 2683.3771972656, 0.0),
            vec(1528.6467285156, 2585.0300292969, 0.0),
            vec(1535.3923339844, 2467.546875, 0.0),
            vec(1658.5743408203, 2388.6613769531, 0.0),
            vec(1763.6359863281, 2405.6196289062, 0.0),
            vec(1830.0268554688, 2473.0979003906, 0.0),
            vec(1834.2340087891, 2579.7426757812, 0.0),
            vec(1834.2774658203, 2592.6013183594, 0.0),
            vec(1833.4014892578, 2595.6577148438, 0.0),
            vec(1818.4958496094, 2596.8950195312, 0.0),
            vec(1818.7344970703, 2611.9055175781, 0.0)
        },

        thickness = 900.0,
        debug = false,
        onEnter = enterPrison,
        onExit = leavePrison
    })
end)

RegisterNetEvent('kk-jail:client:jailPerson', function(time, spawn, clothes)
    inPrisoned = true; haveLeaved = true

    if clothes then
        local model = GetEntityModel(cache.ped)

        if model == joaat('mp_m_freemode_01') or model == joaat('mp_f_freemode_01') then
            TriggerServerEvent('kk-jail:server:saveClothes', {
                ped = exports['illenium-appearance']:getPedModel(cache.ped),
                components = exports['illenium-appearance']:getPedComponents(cache.ped),
                props = exports['illenium-appearance']:getPedProps(cache.ped)
            })
        end
    end

    if not spawn then
        TriggerServerEvent('kk-jail:server:confiscateItems')
        throwToCell()

        SetTimeout(1250, function()
            TriggerServerEvent('kk-handcuffs:server:unCuff')
        end)

        TriggerEvent('chatMessage', 'DOC' , 'info', 'Teid vangistati ' .. time .. ' kuuks.')
    else
        if not inZone then
            throwToCell()
        end

        TriggerEvent('chatMessage', 'DOC' , 'info', 'Teil on jäänud ' .. time .. ' kuud vanglas.')
    end

    SetTimeout(5000, function()
        local model = GetEntityModel(cache.ped)
        
        if model == joaat('mp_m_freemode_01') or model == joaat('mp_f_freemode_01') then
            if KKF.PlayerData.sex == 'm' then
                TriggerEvent('kk-scripts:client:loadClothes', cfg.uniforms['male'])
            elseif KKF.PlayerData.sex == 'f' then
                TriggerEvent('kk-scripts:client:loadClothes', cfg.uniforms['female'])
            end
        end
    
        TriggerServerEvent('illenium-appearance:server:saveAppearance', exports['illenium-appearance']:getPedAppearance(cache.ped))
    end)
end)

RegisterNetEvent('kk-jail:client:endJail', function()
    TriggerEvent('KKF.UI.ShowNotification', 'info', 'Teie vanglakaristus on läbi! Otsige üles vangivalvur, et lahkuda.', 15000)
    inPrisoned = false

    TriggerEvent('kk-jail:client:endRepair')
    TriggerEvent('kk-jail:client:endCleaning')
end)

TriggerEvent('chat:addSuggestion', '/unjail', 'Eemalda vanglast.', {
    { name = 'id'}
})
