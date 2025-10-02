local labs = {}
local currentPlants = {}
local currentTables = {}
local drugLab = vec3(1066.3912353516, -3183.4152832031, -39.1640625)
local laptopTarget = {
    coords = vec3(1045.45, -3194.85, -38.2),
	size = vec3(0.4, 0.5, 0.45),
	rotation = 0.0,
}
local currentLab = 0
local pointLocation = 'none'
local potProp = `bkr_prop_weed_plantpot_stack_01b`
local currentPoint = 0
local timeout = false
local ox_target = exports.ox_target

CreateThread(function()
    Wait(1500)
    lib.callback('kk-druglabs:requestLabs', false, function(response)
        labs = response
    end)
end)

RegisterNetEvent('kk-druglabs:reloadLabData', function(respond)
    labs = respond
end)


RegisterNetEvent('kk-druglabs:client:enterLab', function()
    if currentPoint == 0 then return end

    local input = lib.inputDialog('Kood', {
        { type = 'input', label = 'Sisesta kood', password = true, placeholder = 'XXXXXX' }
    })

    if input then
        TriggerEvent('kk-scripts:client:removeWeapons')

        lib.callback('kk-druglabs:enterLab', false, function(response)
            if response then
                TriggerEvent('InteractSound_CL:PlayOnOne', 'DoorOpen', 0.7)
                Wait(500)
                TriggerEvent('InteractSound_CL:PlayOnOne', 'DoorClose', 0.7)

                currentLab = currentPoint
            else
                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Vale kood!')
            end

            SetTimeout(2000, function()
                TriggerEvent('kk-scripts:client:reloadWeapons')
            end)
        end, currentPoint, input[1])
    end
end)

exports('pointLocation', function()
    return pointLocation
end)

CreateThread(function()
    local alreadyEnteredZone = false

    while true do
        wait = 5
        local ped = PlayerPedId()
        local inZone = false

        for k,v in pairs(labs) do
            local dist = #(GetEntityCoords(ped) - vec3(v.enter.x, v.enter.y, v.enter.z))

            if dist <= 2.0 then
                wait = 5
                inZone = true
                currentPoint = v.id

                break
            else
                wait = 2000
            end
        end
        
        if inZone and not alreadyEnteredZone then
            alreadyEnteredZone = true
            pointLocation = 'enter'
        end

        if not inZone and alreadyEnteredZone then
            alreadyEnteredZone = false
            pointLocation = 'none'
        end

        Citizen.Wait(wait)
    end
end)

local function leaveCurrent(id)
    FreezeEntityPosition(cache.ped, true)

    lib.callback('kk-druglabs:leaveLab', false, function(response)
        if not response then return end
        TriggerEvent('InteractSound_CL:PlayOnOne', 'DoorOpen', 0.7)
        Wait(500)
        TriggerEvent('InteractSound_CL:PlayOnOne', 'DoorClose', 0.7)
        currentLab = 0

        SetTimeout(500, function()
            FreezeEntityPosition(cache.ped, false)
        end)

        Wait(500)
        SetTimeout(2000, function()
            TriggerEvent('kk-scripts:client:reloadWeapons')
        end)
    end, id)
end

RegisterNetEvent('kk-druglabs:client:leaveLab', function()
    leaveCurrent(currentLab)
end)

CreateThread(function()
    local alreadyEnteredZone = false

    while true do
        wait = 5
        local ped = PlayerPedId()
        local inZone = false
        local dist = #(GetEntityCoords(ped) - drugLab)

        if dist <= 2.0 then
            wait = 5
            inZone  = true
        else
            wait = 2000
        end
        
        if inZone and not alreadyEnteredZone then
            alreadyEnteredZone = true
            pointLocation = 'leave'
        end

        if not inZone and alreadyEnteredZone then
            alreadyEnteredZone = false
            pointLocation = 'none'
        end

        Wait(wait)
    end
end) 

local function openLaptop()
    if currentLab == 0 then return end

    lib.callback('kk-druglabs:requestData', false, function(response)
        if response then
            SendNUIMessage({type = 'open', interface = 'shop', shop = response}); SetNuiFocus(true,true)
        else
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil puudub antud tegevusele ligipääs!')
        end
    end, currentLab)
end

ox_target:addBoxZone({
    coords = laptopTarget.coords,
    size = laptopTarget.size,
    rotation = laptopTarget.rotation,
    debug = false,
    options = {
        {
            icon = 'fa-solid fa-laptop',
            label = 'Tellimused',
            onSelect = function(data)
                openLaptop()
            end,
            distance = 2.0
        }
    }
})

SetInterval(function()
	if currentLab ~= 0 then
		if IsPedDeadOrDying(cache.ped, 1) then
            leaveCurrent(currentLab)
		end
	end
end, 5000)

RegisterNUICallback('close', function()
    SetNuiFocus(false, false); SendNUIMessage({type = 'close'})
end)

RegisterNUICallback('changePin', function(args)
    local pin = args.pin

    if #pin == 6 then
        TriggerServerEvent('kk-druglabs:server:changePin', currentLab, pin)
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'PIN peab olema kuuekohaline!')
    end
end)

RegisterNetEvent('kk-druglabs:client:waterPlant', function(args)
    local progress = exports['kk-taskbar']:startAction('waterPlant', 'Kastad', 8000, 'WORLD_HUMAN_GARDENER_PLANT', false, {freeze = true, controls = true})

    if progress then
        TriggerServerEvent('kk-druglabs:server:waterPlant', args)
    end
end)

RegisterNetEvent('kk-druglabs:client:fertilizePlant', function(args)
    local progress = exports['kk-taskbar']:startAction('fertilizePlant', 'Väetad taime', 8000, 'WORLD_HUMAN_GARDENER_PLANT', false, {freeze = true, controls = true})

    if progress then
        TriggerServerEvent('kk-druglabs:server:fertilizePlant', args)
    end
end)

RegisterNetEvent('kk-druglabs:client:recievePlants', function(args)
    local progress = exports['kk-taskbar']:startAction('recievePlants', 'Korjad saaki', 8000, 'WORLD_HUMAN_GARDENER_PLANT', false, {freeze = true, controls = true})

    if progress then
        TriggerServerEvent('kk-druglabs:server:recievePlants', args)
    end
end)

local function openPlantMenu(id)
    lib.callback('kk-druglabs:requestPlantInfo', false, function(response)
        local elements = {}
    
        if response['health'].progress >= 100 then
            elements[#elements + 1] = {
                title = 'Korja saak',
                icon = 'fa-solid fa-hand',
                event = 'kk-druglabs:client:recievePlants',
                description = 'Vajuta siia, et korjata saaki.',
                args = {currentLab = currentLab, currentPlant = id}
            }
        end

        if response.prop == 'none' then
            elements[#elements + 1] = {
                title = 'Istuta taim',
                icon = 'fa-solid fa-hand',
                description = 'Vajuta siia, et istutada taim potti.',
                event = 'kk-druglabs:client:plantSeed',
                args = {id = id}
            }
        else
            elements[#elements + 1] = {
                title = 'Hävita saak',
                icon = 'fa-solid fa-hand',
                description = 'Vajuta siia, et hävitada saak.',
                event = 'kk-druglabs:client:delete',
                args = {currentLab = currentLab, currentPlant = id}
            }

            if exports.ox_inventory:Search('count', 'water') > 0 and response['health'].water < 100 and response['health'].progress < 100 then
                elements[#elements + 1] = {
                    title = 'Kasta taime - ' .. response['health'].water .. '%',
                    icon = 'fa-solid fa-bottle-water',
                    description = 'Vajuta siia, et kasta taime.',
                    event = 'kk-druglabs:client:waterPlant',
                    args = {currentLab = currentLab, currentPlant = id}
                }
            end
    
            if exports.ox_inventory:Search('count', 'fertilizer') > 0 and response['health'].fertilizer < 100 and response['health'].progress < 100 then
                elements[#elements + 1] = {
                    title = 'Väeta taime - ' .. response['health'].fertilizer .. '%',
                    icon = 'fa-solid fa-plant-wilt',
                    description = 'Vajuta siia, et väetada taime.',
                    event = 'kk-druglabs:client:fertilizePlant',
                    args = {currentLab = currentLab, currentPlant = id}
                }
            end
        end
    
        lib.registerContext({
            id = 'plant_menu',
            title = 'Taimehooldus - ' .. response['health'].progress .. '%',
            options = elements
        })
    
        lib.showContext('plant_menu')
    end, currentLab, id)
end

local plantsList = { 
    ['tobacco_plant'] = {
        label = 'Tubakataim',
        prop = 'prop_agave_02'
    },

    ['weed_plant'] = {
        label = 'Kanepitaim',
        prop = 'prop_weed_01'
    },

    ['coke_plant'] = {
        label = 'Kokataim',
        prop = 'h4_prop_bush_cocaplant_01'
    }
}

RegisterNetEvent('kk-druglabs:client:delete', function(args)
    local confirmed = lib.alertDialog({
        header = 'Saagi hävitamine',
        content = 'Kas soovite saagi jäädavalt hävitada?',
        centered = true,
        cancel = true
    })

    if confirmed == 'confirm' then
        local progress = exports['kk-taskbar']:startAction('delete', 'Hävitad saaki', 8000, 'WORLD_HUMAN_GARDENER_PLANT', false, {freeze = true, controls = true})

        if progress then
            TriggerServerEvent('kk-druglabs:server:delete', args)
        end
    end
end)

RegisterNetEvent('kk-druglabs:client:plant', function(args)
    local progress = exports['kk-taskbar']:startAction('plant', 'Istutad taime', 8000, 'WORLD_HUMAN_GARDENER_PLANT', false, {freeze = true, controls = true})

    if progress then
        TriggerServerEvent('kk-druglabs:server:plant', args)
    end
end)

RegisterNetEvent('kk-druglabs:client:plantSeed', function(args)
    local elements = {}

    for k,v in pairs(plantsList) do
        if exports.ox_inventory:Search('count', k) > 0 then
            elements[#elements + 1] = {
                title = v.label,
                event = 'kk-druglabs:client:plant',
                args = {plantData = v, currentLab = currentLab, currentPlant = args.id, plantName = k}
            }
        end 
    end

    SetTimeout(500, function()
        if #elements == 0 then return TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil ei ole siia midagi istutada!') end

        lib.registerContext({
            id = 'plant_seed',
            title = 'Istuta taim',
            options = elements
        })

        lib.showContext('plant_seed')
    end)
end)

local function canHeat(name)
    for k,v in pairs(cfg.heaterTasks[name].needs) do
        if exports.ox_inventory:Search('count', v) < 1 then
            return false
        end
    end

    return true
end

RegisterNetEvent('kk-druglabs:client:heaterAction', function(args)
    if canHeat(args.item) then
        local progress = exports['kk-taskbar']:startAction('waiting', 'Ootad', 3000, 'base', 'anim@amb@carmeet@checkout_engine@female_a@base', {freeze = true, controls = true})

        if progress then
            TriggerServerEvent('kk-druglabs:server:heaterAction', args)
        end
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil puuduvad vajalikud esemed kuumutamiseks.')
    end
end)

local function canDry(name)
    for k,v in pairs(cfg.dryerTasks[name].needs) do
        if exports.ox_inventory:Search('count', v) < 1 then
            return false
        end
    end

    return true
end

RegisterNetEvent('kk-druglabs:client:dryAction', function(args)
    if canDry(args.item) then
        local progress = exports['kk-taskbar']:startAction('waiting', 'Ootad', 3000, 'base', 'anim@amb@carmeet@checkout_engine@female_a@base', {freeze = true, controls = true})

        if progress then
            TriggerServerEvent('kk-druglabs:server:dryAction', args)
        end
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil puuduvad vajalikud esemed kuivatamiseks.')
    end
end)

local function canBarrel(name)
    for k,v in pairs(cfg.barrelTasks[name].needs) do
        if exports.ox_inventory:Search('count', v) < 1 then
            return false
        end
    end

    return true
end

RegisterNetEvent('kk-druglabs:client:barrelAction', function(args)
    if canBarrel(args.item) then
        local progress = exports['kk-taskbar']:startAction('waiting', 'Ootad', 3000, 'base', 'anim@amb@carmeet@checkout_engine@female_a@base', {freeze = true, controls = true})

        if progress then
            TriggerServerEvent('kk-druglabs:server:barrelAction', args)
        end
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil puuduvad vajalikud esemed kääritamiseks.')
    end
end)

local function canPress(name)
    for k,v in pairs(cfg.packerTasks[name].needs) do
        if exports.ox_inventory:Search('count', k) < v then
            return false
        end
    end

    return true
end

RegisterNetEvent('kk-druglabs:client:pressAction', function(args)
    if canPress(args.item) then
        local progress = exports['kk-taskbar']:startAction('act', 'Tegutsed', 3000, 'loop', 'mp_fbi_heist', {freeze = true, controls = true})

        if progress then
            TriggerServerEvent('kk-druglabs:server:pressAction', args)
        end
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil puuduvad vajalikud esemed pressimiseks.')
    end
end)

local function canMix(name)
    for k,v in pairs(cfg.mixerTasks[name].needs) do
        if exports.ox_inventory:Search('count', v) < 1 then
            return false
        end
    end

    return true
end

RegisterNetEvent('kk-druglabs:client:mixAction', function(args)
    if canMix(args.item) then
        local progress = exports['kk-taskbar']:startAction('waiting', 'Ootad', 3000, 'base', 'anim@amb@carmeet@checkout_engine@female_a@base', {freeze = true, controls = true})

        if progress then
            TriggerServerEvent('kk-druglabs:server:mixAction', args)
        end
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil puuduvad vajalikud esemed miximiseks.')
    end
end)

local function canCrush(name)
    for k,v in pairs(cfg.crusherTasks[name].needs) do
        if exports.ox_inventory:Search('count', v) < 1 then
            return false
        end
    end

    return true
end

RegisterNetEvent('kk-druglabs:client:crushAction', function(args)
    if canCrush(args.item) then
        local progress = exports['kk-taskbar']:startAction('act', 'Tegutsed', 3000, 'petting_franklin', 'creatures@rottweiler@tricks@', {freeze = true, controls = true})

        if progress then
            TriggerServerEvent('kk-druglabs:server:crushAction', args)
        end
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil puuduvad vajalikud esemed purustamiseks.')
    end
end)

local function tableAction(prop)
    if prop == 'v_ret_ml_tablea' then -- Kuumutamine
        local elements = {}

        for k,v in pairs(cfg.heaterTasks) do
            local needs = {}

            for kk,vv in pairs(v.needs) do
                needs[#needs + 1] = {label = exports.ox_inventory:Items()[vv].label, value = 1}
            end

            elements[#elements + 1] = {
                title = v.label,
                event = 'kk-druglabs:client:heaterAction',
                metadata = needs,
                args = {item = k}
            }
        end

        lib.registerContext({
            id = 'heater_tasks',
            title = 'Kuumutamine',
            options = elements
        })

        lib.showContext('heater_tasks')
    elseif prop == 'v_ret_fh_dryer' then -- Kuivati
        local elements = {}

        for k,v in pairs(cfg.dryerTasks) do
            local needs = {}

            for kk,vv in pairs(v.needs) do
                needs[#needs + 1] = {label = exports.ox_inventory:Items()[vv].label, value = 1}
            end

            elements[#elements + 1] = {
                title = v.label,
                event = 'kk-druglabs:client:dryAction',
                metadata = needs,
                args = {item = k}
            }
        end

        lib.registerContext({
            id = 'dryer_tasks',
            title = 'Kuivati',
            options = elements
        })

        lib.showContext('dryer_tasks')
    elseif prop == 'prop_wooden_barrel' then -- Tünn
        local elements = {}

        for k,v in pairs(cfg.barrelTasks) do
            local needs = {}

            for kk,vv in pairs(v.needs) do
                needs[#needs + 1] = {label = exports.ox_inventory:Items()[vv].label, value = 1}
            end

            elements[#elements + 1] = {
                title = v.label,
                event = 'kk-druglabs:client:barrelAction',
                metadata = needs,
                args = {item = k}
            }
        end

        lib.registerContext({
            id = 'barrel_tasks',
            title = 'Kääritamine',
            options = elements
        })

        lib.showContext('barrel_tasks')
    elseif prop == 'bkr_prop_coke_press_01aa' then -- Press / Pakendaja
        local elements = {}

        for k,v in pairs(cfg.packerTasks) do
            local needs = {}

            for kk,vv in pairs(v.needs) do
                needs[#needs + 1] = {label = exports.ox_inventory:Items()[kk].label, value = vv}
            end

            elements[#elements + 1] = {
                title = v.label,
                event = 'kk-druglabs:client:pressAction',
                metadata = needs,
                args = {item = k}
            }
        end

        lib.registerContext({
            id = 'packer_tasks',
            title = 'Press / Pakendaja',
            options = elements
        })

        lib.showContext('packer_tasks')
    elseif prop == 'prop_cementmixer_02a' then -- Mixer
        local elements = {}

        for k,v in pairs(cfg.mixerTasks) do
            local needs = {}

            for kk,vv in pairs(v.needs) do
                needs[#needs + 1] = {label = exports.ox_inventory:Items()[vv].label, value = 1}
            end

            elements[#elements + 1] = {
                title = v.label,
                event = 'kk-druglabs:client:mixAction',
                metadata = needs,
                args = {item = k}
            }
        end

        lib.registerContext({
            id = 'mixer_tasks',
            title = 'Mixer',
            options = elements
        })

        lib.showContext('mixer_tasks')
    elseif prop == 'prop_cementmixer_01a' then -- Purusti
        local elements = {}

        for k,v in pairs(cfg.crusherTasks) do
            local needs = {}

            for kk,vv in pairs(v.needs) do
                needs[#needs + 1] = {label = exports.ox_inventory:Items()[vv].label, value = 1}
            end

            elements[#elements + 1] = {
                title = v.label,
                event = 'kk-druglabs:client:crushAction',
                metadata = needs,
                args = {item = k}
            }
        end

        lib.registerContext({
            id = 'crusher_tasks',
            title = 'Purustaja',
            options = elements
        })

        lib.showContext('crusher_tasks')
    end
end

local function canRoll(name)
    for k,v in pairs(cfg.rollingTasks[name].needs) do
        if exports.ox_inventory:Search('count', v) < 1 then
            return false
        end
    end

    return true
end

local function canScale(name)
    for k,v in pairs(cfg.scaleTasks[name].needs) do
        if exports.ox_inventory:Search('count', v) < 1 then
            return false
        end
    end

    return true
end

RegisterNetEvent('kk-druglabs:client:rollItem', function(args)
    if canRoll(args.item) then
        local progress = exports['kk-taskbar']:startAction('rolling', 'Rollid sigaretti', 1300, false, false, {freeze = true, controls = true})

        if progress then
            TriggerServerEvent('kk-druglabs:server:rollItem', args)
        end
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil puuduvad vajalikud esemed rullimiseks.')
    end
end)

RegisterNetEvent('kk-druglabs:client:scaleItem', function(args)
    if canScale(args.item) then
        local progress = exports['kk-taskbar']:startAction('scaleing', 'Kaalud esemeid', 1300, false, false, {freeze = true, controls = true})

        if progress then
            TriggerServerEvent('kk-druglabs:server:scaleItem', args)
        end
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil puuduvad vajalikud esemed kaalumiseks.')
    end
end)

RegisterNetEvent('kk-druglabs:client:rollerAction', function() 
    if exports.ox_inventory:Search('count', 'rollingpaper') > 0 then
        local elements = {}

        for k,v in pairs(cfg.rollingTasks) do
            local needs = {}

            for kk,vv in pairs(v.needs) do
                needs[#needs + 1] = {label = exports.ox_inventory:Items()[vv].label, value = 1}
            end

            elements[#elements + 1] = {
                title = v.label,
                event = 'kk-druglabs:client:rollItem',
                metadata = needs,
                args = {item = k}
            }
        end

        if #elements == 0 then
            return TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil ei ole midagi rullida.')
        end

        lib.registerContext({
            id = 'roll_tasks',
            title = 'Rulli sigarette',
            options = elements
        })

        lib.showContext('roll_tasks')
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil ei ole rullpaberit.')
    end
end)

RegisterNetEvent('kk-druglabs:client:scaleAction', function() 
    if exports.ox_inventory:Search('count', 'drugscales') > 0 then
        local elements = {}

        for k,v in pairs(cfg.scaleTasks) do
            local needs = {}

            for kk,vv in pairs(v.needs) do
                needs[#needs + 1] = {label = exports.ox_inventory:Items()[vv].label, value = 1}
            end

            elements[#elements + 1] = {
                title = v.label,
                event = 'kk-druglabs:client:scaleItem',
                metadata = needs,
                args = {item = k}
            }
        end

        if #elements == 0 then
            return TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil ei ole midagi kaaluda.')
        end

        lib.registerContext({
            id = 'scale_tasks',
            title = 'Kaalu esemeid',
            options = elements
        })

        lib.showContext('scale_tasks')
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil ei ole kaalu.')
    end
end)

RegisterNetEvent('kk-druglabs:client:loadPlants', function(data)
    for k,v in pairs(data['plants']) do
        currentPlants[k] = {}
        
        lib.requestModel(potProp)
        currentPlants[k]['pot'] = CreateObject(potProp, vec3(v.pos.x, v.pos.y, v.pos.z), false)

        FreezeEntityPosition(currentPlants[k]['pot'], true)
        currentPlants[k]['target'] = ox_target:addBoxZone({
            coords = vec3(v.pos.x, v.pos.y, v.pos.z),
            size = vec3(0.6, 0.6, math.abs(v.pos.z - v.pos.z + 1)),
            rotation = 0,
            debug = false,
            options = {
                {
                    icon = 'fa-solid fa-plant-wilt',
                    label = 'Hoolda taime',
                    onSelect = function(data)
                        openPlantMenu(k)
                    end,
                    distance = 1.5
                }
            }
        })

        if v.prop ~= 'none' then
            lib.requestModel(GetHashKey(v.prop))
            currentPlants[k]['plant'] = CreateObject(GetHashKey(v.prop), vec3(v.pos.x, v.pos.y, v.pos.z + 0.5), false)
        end

        currentPlants[k]['health'] = v.health
    end

    for k,v in pairs(data['tables']) do
        currentTables[k] = {}
        
        lib.requestModel(GetHashKey(v.prop))
        currentTables[k]['entity'] = CreateObject(GetHashKey(v.prop), vec3(v.pos.x, v.pos.y, v.pos.z), false)
        SetEntityHeading(currentTables[k]['entity'], v.pos.w)
        FreezeEntityPosition(currentTables[k]['entity'], true)
        SetEntityAlpha(currentTables[k]['entity'], 255, false)

        currentTables[k]['target'] = ox_target:addBoxZone({
            coords = vec3(v.pos.x, v.pos.y, v.pos.z),
            size = vec3(1.3, 2.3, math.abs(v.pos.z - v.pos.z + 1.8)),
            rotation = 0,
            debug = false,
            options = {
                {
                    name = k .. '_table',
                    icon = 'fa-solid fa-hand',
                    label = 'Uuri asja',
                    onSelect = function(data)
                        tableAction(v.prop)
                    end,
                    distance = 1.5
                }
            }
        })
    end
end)

RegisterNetEvent('kk-druglabs:client:unloadPlants', function()
    for k,v in pairs(currentPlants) do
        DeleteObject(currentPlants[k]['pot']); 
        DeleteObject(currentPlants[k]['plant']); 

        if v.target then
            ox_target:removeZone(v.target)
        end

        currentPlants[k] = nil
    end

    for k,v in pairs(currentTables) do
        DeleteObject(currentTables[k]['entity']); 

        if v.target then
            ox_target:removeZone(v.target)
        end
        
        currentTables[k] = nil
    end
end) 

RegisterNUICallback('buyItem', function(args)
    if timeout then return TriggerEvent('KKF.UI.ShowNotification', 'error', 'Oota natukene...') end
    timeout = true
    lib.callback.await('kk-druglabs:buyItem', false, currentLab, args.item)
    SetTimeout(1500, function() timeout = false end)
end)

RegisterNetEvent('kk-druglabs:client:removePlant', function(id)
    DeleteObject(currentPlants[id]['plant']);
    currentPlants[id]['plant'] = nil
end)

RegisterNetEvent('kk-druglabs:client:addPlant', function(id, data)
    lib.requestModel(GetHashKey(data.prop))
    currentPlants[id]['plant'] = CreateObject(GetHashKey(data.prop), vec3(data.pos.x, data.pos.y, data.pos.z + 0.5), false)
end)