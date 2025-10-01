local ped = nil;
local hasTools = false;
local inDelivery = false;

local current = {
    active = false,
    locationId = nil,
    location = {},
    vehicle = nil,
    plate = nil,
    toolBox = nil,
    blip = nil,

    pointsDone = 0,
    pointsMax = 0
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
    TriggerEvent('kk-hud2:client:showInstruction', 'Elektritöö', 'Rajoon: ' .. location .. ' | Tehtud: ' .. done .. '/' .. max)
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

RegisterNetEvent('kk-electrician:client:viewMembers', function()
    lib.callback('kk-electrician:requestMembers', false, function(response)
        local elements = {}

        for k,v in pairs(response) do
            elements[#elements + 1] = {
                title = v.name,
                icon = 'fa-solid fa-user',
                event = 'kk-electrician:client:removeMember',
                args = {identifier = v.identifier, name = v.name}
            }
        end

        lib.registerContext({
            id = 'electician_members',
            menu = 'electician_job',
            title = 'Liikmed',
            options = elements
        })

        lib.showContext('electician_members')
    end)
end)

RegisterNetEvent('kk-electrician:client:removeMember', function(data)
    if data.identifier ~= ESX.PlayerData.identifier then
        local confirmed = lib.alertDialog({
            header = 'Grupist eemaldamine',
            content = 'Liikme ' .. data.name .. ' grupist eemaldamine.',
            centered = true,
            cancel = true
        })
        
        if confirmed == 'confirm' then
            TriggerServerEvent('kk-electrician:server:removeMember', data.identifier)
        end
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ei saa iseennast grupist eemaldada!')
    end
end)

RegisterNetEvent('kk-electrician:client:joinGroup', function()
    local input = lib.inputDialog('Grupiga liitumine', {'Kood'})

    if input then
        if input[1] then
            TriggerServerEvent('kk-electrician:server:joinGroup', input[1]:upper())
        end
    end
end)

local function jobMenu()
    lib.callback('kk-electrician:recieveData', false, function(response)
        local elements = {}

        if response.group then
            elements[#elements + 1] = {
                title = 'Liikmed',
                icon = 'fa-solid fa-users',
                description = 'Grupis on ' .. #response.group.members .. ' inimest.',
                event = 'kk-electrician:client:viewMembers'
            }

            if response.group.owner == ESX.PlayerData.identifier then
                elements[#elements + 1] = {
                    title = 'Lõpeta töö',
                    icon = 'fa-solid fa-xmark',
                    description = 'Kõik liikmed jäävad üksi.',
                    serverEvent = 'kk-electrician:server:deleteGroup',
                    args = {value = value}
                }

                if not response.group.active then
                    elements[#elements + 1] = {
                        title = 'Võtke tööauto',
                        icon = 'fa-solid fa-car',
                        description = 'Alustage tööotsa',
                        serverEvent = 'kk-electrician:server:startJob',
                        args = {}
                    }
                end
            else
                elements[#elements + 1] = {
                    title = 'Lahku grupist',
                    icon = 'fa-solid fa-door-open',
                    description = 'Te jääte üksi...',
                    serverEvent = 'kk-electrician:server:deleteGroup',
                    args = {value = value}
                }
            end
        else
            elements[#elements + 1] = {
                title = 'Loo uus grupp',
                icon = 'fa-solid fa-plus',
                description = 'Grupiliikmete maksimaalne arv on 2.',
                serverEvent = 'kk-electrician:server:createGroup',
                args = {value = value}
            }

            elements[#elements + 1] = {
                title = 'Liitu grupiga',
                icon = 'fa-solid fa-right-to-bracket',
                description = 'Te ei kuulu veel ühtegi grupi.',
                event = 'kk-electrician:client:joinGroup',
                args = {}
            }
        end

        lib.registerContext({
            id = 'electician_job',
            title = 'Elektritöö',
            options = elements
        })
    
        lib.showContext('electician_job')
    end)
end

RegisterNetEvent('kk-electrician:client:jobMenu', jobMenu)

local function getLabel(id)
    local returnable = nil

    for k,v in pairs(cfg.zones) do
        if v.id == id then
            returnable = v.label
        end
    end

    return returnable
end

lib.onCache('vehicle', function(vehicle)
    if hasTools then
		TaskLeaveVehicle(cache.ped, vehicle, 0); TriggerEvent('KKF.UI.ShowNotification', "error", "Pane asjad enne autosse tagasi!")
    end
end)

local function animCheck()
    CreateThread(function()
        while hasTools and not IsEntityPlayingAnim(cache.ped, 'move_weapon@jerrycan@generic', 'idle', 3) do
            if not IsEntityPlayingAnim(cache.ped, 'move_weapon@jerrycan@generic', 'idle', 3) then
                ClearPedTasksImmediately(cache.ped)
                lib.requestAnimDict('move_weapon@jerrycan@generic')
                TaskPlayAnim(cache.ped, 'move_weapon@jerrycan@generic', 'idle', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
            end

            Wait(1000)
        end
    end)
end

RegisterNetEvent('kk-electrician:client:startJob', function(groupData)
    while not NetworkDoesEntityExistWithNetworkId(groupData.vehicle) do Wait(200) end

    current.active = true
    current.locationId = groupData.location
    current.location = getLocationData(groupData.location)
    current.vehicle = NetworkGetEntityFromNetworkId(groupData.vehicle)
    current.plate = groupData.plate

    exports['kk-vehicles']:addKey(current.plate)

    if current.location.coords then 
        current.blip = AddBlipForRadius(current.location.coords.x, current.location.coords.y, 0.0, 175.0)
        SetBlipSprite(current.blip, 9)
        SetBlipColour(current.blip, 24)
        SetBlipAlpha(current.blip, 80)
    end

    showInfo(current.location.label, groupData.pointsDone, groupData.pointsMax)

    exports.ox_target:addEntity({NetworkGetNetworkIdFromEntity(current.vehicle)}, {
        {
            name = 'electrician_truck',
            icon = 'fa-solid fa-hand',
            label = 'Võta tööriistad',
            distance = 1.5,
            bones = 'platelight',
            canInteract = function(entity, distance, coords, name, boneId)
                return current.active and #(coords - GetWorldPositionOfEntityBone(entity, boneId)) < 1.2 and not hasTools
            end,
            onSelect = function()
                hasTools = true; animCheck()
                current.toolBox = exports['kk-scripts']:spawnAttachedObject(cache.ped, joaat('imp_prop_tool_box_01a'), 28422, 0.3700, 0.0200, 0.0, 90.00, 0.0, -90.00)
            end
        },

        {
            name = 'electrician_truck',
            icon = 'fa-solid fa-hand',
            label = 'Pane tööriistad autosse',
            distance = 1.5,
            bones = 'platelight',
            canInteract = function(entity, distance, coords, name, boneId)
                return current.active and #(coords - GetWorldPositionOfEntityBone(entity, boneId)) < 1.2 and hasTools
            end,
            onSelect = function()
                hasTools = false; ClearPedTasks(cache.ped); DetachEntity(current.toolBox, cache.ped); DeleteObject(current.toolBox)
            end
        },
    })
end)

RegisterNetEvent('kk-electrician:client:updateData', function(groupData)
    RemoveBlip(current.blip); current.blip = nil

    current.locationId = groupData.location
    current.location = getLocationData(groupData.location)
    
    current.pointsDone = groupData.pointsDone; 
    current.pointsMax = groupData.pointsMax;

    if current.location.coords then 
        current.blip = AddBlipForRadius(current.location.coords.x, current.location.coords.y, 0.0, 175.0)
        SetBlipSprite(current.blip, 9)
        SetBlipColour(current.blip, 24)
        SetBlipAlpha(current.blip, 80)
    end

    showInfo(current.location.label, groupData.pointsDone, groupData.pointsMax)
end)

RegisterNetEvent('kk-electrician:client:clearJob', function(owner)
    current.active = false
    current.locationId = nil
    current.location = {}
     exports['kk-vehicles']:removeKey(current.plate)
    DetachEntity(current.toolBox, cache.ped); DeleteObject(current.toolBox); current.toolBox = nil; hasTools = false; ClearPedTasks(cache.ped);
    TriggerEvent('kk-hud2:client:hideInstruction')
    RemoveBlip(current.blip); current.blip = nil

    current.pointsDone = 0
    current.pointsMax = 0

    TriggerEvent('KKF.UI.ShowNotification', 'info', 'Teie tööots on lõpetatud!')

    exports.ox_target:removeEntity({NetworkGetNetworkIdFromEntity(current.vehicle)}, {'electrician_truck'})

    if owner then DeleteVehicle(current.vehicle) end
    current.vehicle = nil

    current.plate = nil
end)

local function registerPeds()
    SetTimeout(5000, function()
        exports['kk-scripts']:requestModel(`s_m_y_airworker`)
        local entity = CreatePed(4, `s_m_y_airworker`, cfg.ped.x, cfg.ped.y, cfg.ped.z - 1, cfg.ped.w, false, false)

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
                name = 'electician',
                distance = 1.5,
                icon = 'fa-solid fa-bolt',
                label = 'Tee tööd',
                onSelect = jobMenu,
            }
        })
    end)
end

local function deRegisterPeds()
    if ped then
        exports.ox_target:removeLocalEntity(ped.entity, {'electician'})
        DeleteObject(ped.prop); DeletePed(ped.entity); ped = nil
    end
end

RegisterNetEvent('KKF.Player.Loaded', function(xPlayer)
	ESX.PlayerData = xPlayer

    ESX.CreateBlip('electician', cfg.ped, 'Elektrijaam', 769, 24, 0.7)
    registerPeds()

    exports.ox_target:addModel(cfg.models, {
        {
            name = 'electric',
            icon = 'fa-solid fa-wrench',
            label = 'Paranda',
            distance = 1.0,
            canInteract = function() return current.active and hasTools end,
            onSelect = function(data)
                if isInZone(current.location.id) then
                    lib.callback('kk-electrician:canRepair', false, function(response)
                        if response then
                            lib.requestAnimDict('anim@amb@carmeet@checkout_engine@male_b@idles'); 
                            TaskPlayAnim(cache.ped, 'anim@amb@carmeet@checkout_engine@male_b@idles', 'idle_b', 8.0, 1.0, -1, 49, 0, 0, 0, 0)

                            TriggerEvent('kk-minigame:client:openSlider', function(success)
                                if success then
                                    lib.callback.await('kk-electrician:repairPoint', false, GetEntityCoords(data.entity), current.locationId)
                                else
                                    TriggerEvent('KKF.UI.ShowNotification', 'error', 'Sa ei saanud hakkama!')
                                end

                                ClearPedTasks(cache.ped)
                            end, 3, 3)
                        else
                            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Siin pole enam midagi parandada!')
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

    ESX.RemoveBlip('electician')
    deRegisterPeds(); exports.ox_target:removeModel(cfg.models, {'electric'})
end)