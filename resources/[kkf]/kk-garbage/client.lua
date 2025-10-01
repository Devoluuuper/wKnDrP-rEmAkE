local ped = nil;
local hasBag = false;
local inDelivery = false;

local current = {
    active = false,
    locationId = nil,
    location = {},
    vehicle = nil,
    plate = nil,
    trashBag = nil,
    blip = nil,

    binsDone = 0,
    binsMax = 0
}

local function loadAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Wait(5)
	end
end

local function getLocationData(id)
    return cfg.zones[id]
end

exports('inDelivery', function()
    return inDelivery
end)

local function showInfo(location, done, max)
    TriggerEvent('kk-hud2:client:showInstruction', 'Prügitöö', 'Rajoon: ' .. location .. ' | Tehtud: ' .. done .. '/' .. max)
end

local function isInZone(table)
    local returnable = false

    for k,v in pairs(table) do
        if v == GetNameOfZone(GetEntityCoords(cache.ped)) then
            returnable = true
        end
    end

    return returnable
end

CreateThread(function()
    ESX.CreateBlip('delivery_garbage', cfg.delivery.coords, 'Jäätmejaam', 171, 3, 0.7)

    lib.zones.box({
        coords = cfg.delivery.coords,
        size = cfg.delivery.size,
        rotation = cfg.delivery.rotation,
        debug = false,
        onEnter = function()
            inDelivery = true
            ESX.ShowInteraction('Jäätmejaam')
        end,
        onExit = function()
            inDelivery = false
            ESX.HideInteraction()
        end
    })
end)

RegisterNetEvent('kk-garbage:client:deliverGarbage', function()
    if current.active then
        if cache.vehicle and cache.seat == -1 then
            local progress = exports['kk-taskbar']:startAction('garbage_rem', 'Tühjendad prügi', 5000, false, false, {freeze = true, controls = true})
        
            if progress then
                lib.callback('kk-garbage:deliverGarbage', false, function(response)
                    if not response then
                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Oled küll tööl, aga miks sa nii vara siia juba tulid!?')
                    end
                end)
            end
        end
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ei ole hetkel tööl!')
    end
end)

RegisterNetEvent('kk-garbage:client:viewMembers', function()
    lib.callback('kk-garbage:requestMembers', false, function(response)
        local elements = {}

        for k,v in pairs(response) do
            elements[#elements + 1] = {
                title = v.name,
                icon = 'fa-solid fa-user',
                event = 'kk-garbage:client:removeMember',
                args = {identifier = v.identifier, name = v.name}
            }
        end

        lib.registerContext({
            id = 'garbage_members',
            menu = 'garbage_job',
            title = 'Liikmed',
            options = elements
        })

        lib.showContext('garbage_members')
    end)
end)

RegisterNetEvent('kk-garbage:client:removeMember', function(data)
    if data.identifier ~= ESX.PlayerData.identifier then
        local confirmed = lib.alertDialog({
            header = 'Grupist eemaldamine',
            content = 'Liikme ' .. data.name .. ' grupist eemaldamine.',
            centered = true,
            cancel = true
        })
        
        if confirmed == 'confirm' then
            TriggerServerEvent('kk-garbage:server:removeMember', data.identifier)
        end
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ei saa iseennast grupist eemaldada!')
    end
end)

RegisterNetEvent('kk-garbage:client:joinGroup', function()
    local input = lib.inputDialog('Grupiga liitumine', {'Kood'})

    if input then
        if input[1] then
            TriggerServerEvent('kk-garbage:server:joinGroup', input[1]:upper())
        end
    end
end)

local function jobMenu()
    lib.callback('kk-garbage:recieveData', false, function(response)
        local elements = {}

        if response.group then
            elements[#elements + 1] = {
                title = 'Liikmed',
                icon = 'fa-solid fa-users',
                description = 'Grupis on ' .. #response.group.members .. ' inimest.',
                event = 'kk-garbage:client:viewMembers'
            }

            if response.group.owner == ESX.PlayerData.identifier then
                elements[#elements + 1] = {
                    title = 'Lõpeta töö',
                    icon = 'fa-solid fa-xmark',
                    description = 'Kõik liikmed jäävad üksi.',
                    serverEvent = 'kk-garbage:server:deleteGroup',
                    args = {value = value}
                }

                if not response.group.active then
                    elements[#elements + 1] = {
                        title = 'Võtke prügiauto',
                        icon = 'fa-solid fa-car',
                        description = 'Alustage tööotsa',
                        serverEvent = 'kk-garbage:server:startJob',
                        args = {}
                    }
                end
            else
                elements[#elements + 1] = {
                    title = 'Lahku grupist',
                    icon = 'fa-solid fa-door-open',
                    description = 'Te jääte üksi...',
                    serverEvent = 'kk-garbage:server:deleteGroup',
                    args = {value = value}
                }
            end
        else
            elements[#elements + 1] = {
                title = 'Loo uus grupp',
                icon = 'fa-solid fa-plus',
                description = 'Grupiliikmete maksimaalne arv on 4.',
                serverEvent = 'kk-garbage:server:createGroup',
                args = {value = value}
            }

            elements[#elements + 1] = {
                title = 'Liitu grupiga',
                icon = 'fa-solid fa-right-to-bracket',
                description = 'Te ei kuulu veel ühtegi grupi.',
                event = 'kk-garbage:client:joinGroup',
                args = {}
            }
        end

        lib.registerContext({
            id = 'garbage_job',
            title = 'Prügitöö',
            options = elements
        })
    
        lib.showContext('garbage_job')
    end)
end

RegisterNetEvent('kk-garbage:client:jobMenu', jobMenu)

local function getLabel(id)
    local returnable = nil

    for k,v in pairs(cfg.zones) do
        if v.id == id then
            returnable = v.label
        end
    end

    return returnable
end

RegisterNetEvent('kk-garbage:client:startJob', function(groupData)
    while not NetworkDoesEntityExistWithNetworkId(groupData.vehicle) do Wait(200) end

    current.active = true
    current.locationId = groupData.location
    current.location = getLocationData(groupData.location)
    current.vehicle = NetworkGetEntityFromNetworkId(groupData.vehicle)
    current.plate = groupData.plate

    SetVehicleEngineOn(current.vehicle, true, true, true)
    -- exports['kk-vehicles']:addKey(current.plate)
    
    if current.location.coords then 
        current.blip = AddBlipForRadius(current.location.coords.x, current.location.coords.y, 0.0, 255.0)
        SetBlipSprite(current.blip, 9)
        SetBlipColour(current.blip, 3)
        SetBlipAlpha(current.blip, 80)
    end

    showInfo(current.location.label, groupData.binsDone, groupData.binsMax)

    exports.ox_target:addEntity({NetworkGetNetworkIdFromEntity(current.vehicle)}, {
        {
            name = 'garbage_truck',
            icon = 'fa-solid fa-hand',
            label = 'Viska autosse',
            distance = 1.5,
            bones = 'platelight',
            canInteract = function(entity, distance, coords, name, boneId)
                return current.active and isInZone(current.location.id) and hasBag and #(coords - GetWorldPositionOfEntityBone(entity, boneId)) < 1.2
            end,
            onSelect = function()
                hasBag = false; ESX.HideInteraction()
                local progress = exports['kk-taskbar']:startAction('deliver_garbage_bag', 'Viskad prügi autosse', 2000, '_bag_throw_garbage_man', 'missfbi4prepp1', {freeze = false, controls = true, disableCancel = true})

                if progress then
                    lib.callback('kk-garbage:throwBag', false, function(response)
                        DetachEntity(current.trashBag, cache.ped); DeleteObject(current.trashBag)
                    end, current.locationId)
                end
            end
        },
    })
end)

RegisterNetEvent('kk-garbage:client:updateData', function(groupData)
    RemoveBlip(current.blip); current.blip = nil

    if not groupData.deliverTrash then
        current.locationId = groupData.location
        current.location = getLocationData(groupData.location)
        
        current.binsDone = groupData.binsDone; 
        current.binsMax = groupData.binsMax;

        if current.location.coords then 
            current.blip = AddBlipForRadius(current.location.coords.x, current.location.coords.y, 0.0, 255.0)
            SetBlipSprite(current.blip, 9)
            SetBlipColour(current.blip, 3)
            SetBlipAlpha(current.blip, 80)
        end

        showInfo(current.location.label, groupData.binsDone, groupData.binsMax)
    else
        SetNewWaypoint(cfg.delivery.coords.x, cfg.delivery.coords.y);
        TriggerEvent('KKF.UI.ShowNotification', 'info', 'Vii prügi jäätmejaama!', 5000)
    end
end)

RegisterNetEvent('kk-garbage:client:clearJob', function(owner)
    current.active = false
    current.locationId = nil
    current.location = {}
    -- exports['kk-vehicles']:removeKey(current.plate)
    DetachEntity(current.trashBag, cache.ped); DeleteObject(current.trashBag); current.trashBag = nil;
    TriggerEvent('kk-hud2:client:hideInstruction')
    RemoveBlip(current.blip); current.blip = nil

    current.binsDone = 0
    current.binsMax = 0

    TriggerEvent('KKF.UI.ShowNotification', 'info', 'Teie tööots on lõpetatud!')

    exports.ox_target:removeEntity({NetworkGetNetworkIdFromEntity(current.vehicle)}, {'garbage_truck'})

    if owner then DeleteVehicle(current.vehicle) end
    current.vehicle = nil

    current.plate = nil
end)

local function registerPeds()
    SetTimeout(5000, function()
        exports['kk-scripts']:requestModel(`s_m_y_garbage`)
        local entity = CreatePed(4, `s_m_y_garbage`, cfg.ped.x, cfg.ped.y, cfg.ped.z - 1, cfg.ped.w, false, false)

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
                name = 'garbage',
                distance = 1.5,
                icon = 'fa-solid fa-trash',
                label = 'Tee tööd',
                onSelect = jobMenu,
            }
        })
    end)
end

local function deRegisterPeds()
    if ped then
        exports.ox_target:removeLocalEntity(ped.entity, {'garbage'})
        DeleteObject(ped.prop); DeletePed(ped.entity); ped = nil
    end
end

local function animCheck()
    CreateThread(function()
        while hasBag and not IsEntityPlayingAnim(cache.ped, 'missfbi4prepp1', '_bag_throw_garbage_man', 3) do
            if not IsEntityPlayingAnim(cache.ped, 'missfbi4prepp1', '_bag_walk_garbage_man', 3) then
                ClearPedTasksImmediately(cache.ped)
                lib.requestAnimDict('missfbi4prepp1')
                TaskPlayAnim(cache.ped, 'missfbi4prepp1', '_bag_walk_garbage_man', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
            end

            Wait(1000)
        end
    end)
end

local function cancelButton()
    CreateThread(function()
        while hasBag do
            if IsControlJustReleased(0, 26) then
                hasBag = false; ClearPedTasks(cache.ped); ESX.HideInteraction()
                DetachEntity(current.trashBag, cache.ped); DeleteObject(current.trashBag)
            end

            Wait(0)
        end
    end)
end

RegisterNetEvent('KKF.Player.Loaded', function(xPlayer)
	ESX.PlayerData = xPlayer

    ESX.CreateBlip('garbage', cfg.ped, 'Prügila', 318, 3, 0.7)
    registerPeds()

    exports.ox_target:addModel(cfg.models, {
        {
            name = 'trashbin',
            icon = 'fa-solid fa-trash',
            label = 'Korja prügi',
            distance = 1.0,
            canInteract = function() return current.active and not hasBag end,
            onSelect = function(data)
                if isInZone(current.location.id) then
                    lib.callback('kk-garbage:collectTrash', false, function(canCollect)
                        if canCollect then
                            hasBag = true; ESX.ShowInteraction('Viska prügi maha', 'C')
                                    
                            cancelButton(); animCheck()
                            current.trashBag = exports['kk-scripts']:spawnAttachedObject(cache.ped, joaat('prop_cs_rub_binbag_01'), 57005, 0.12, 0.0, -0.05, 220.0, 120.0, 0.0)
                        else
                            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Siin pole enam midagi!')
                        end
                    end, GetEntityCoords(data.entity))
                else
                    TriggerEvent('KKF.UI.ShowNotification', 'error', 'Siin pole midagi.')
                end
            end
        },
    })
end)

RegisterNetEvent('KKF.Player.Unloaded', function() 
	ESX.PlayerData = {}

    ESX.RemoveBlip('garbage')
    deRegisterPeds(); exports.ox_target:removeModel(cfg.models, {'trashbin'})
end)