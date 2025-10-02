local ped = nil;
local hasBox = false;
local inDelivery = false;

local current = {
    active = false,
    locationId = nil,
    location = {},
    vehicle = nil,
    plate = nil,
    mailBox = nil,
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
    TriggerEvent('kk-hud2:client:showInstruction', 'Postitöö', 'Rajoon: ' .. location .. ' | Tehtud: ' .. done .. '/' .. max)
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

RegisterNetEvent('kk-gopostal:client:viewMembers', function()
    lib.callback('kk-gopostal:requestMembers', false, function(response)
        local elements = {}

        for k,v in pairs(response) do
            elements[#elements + 1] = {
                title = v.name,
                icon = 'fa-solid fa-user',
                event = 'kk-gopostal:client:removeMember',
                args = {identifier = v.identifier, name = v.name}
            }
        end

        lib.registerContext({
            id = 'gopostal_members',
            menu = 'gopostal_job',
            title = 'Liikmed',
            options = elements
        })

        lib.showContext('gopostal_members')
    end)
end)

RegisterNetEvent('kk-gopostal:client:removeMember', function(data)
    if data.identifier ~= KKF.PlayerData.identifier then
        local confirmed = lib.alertDialog({
            header = 'Grupist eemaldamine',
            content = 'Liikme ' .. data.name .. ' grupist eemaldamine.',
            centered = true,
            cancel = true
        })
        
        if confirmed == 'confirm' then
            TriggerServerEvent('kk-gopostal:server:removeMember', data.identifier)
        end
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ei saa iseennast grupist eemaldada!')
    end
end)

RegisterNetEvent('kk-gopostal:client:joinGroup', function()
    local input = lib.inputDialog('Grupiga liitumine', {'Kood'})

    if input then
        if input[1] then
            TriggerServerEvent('kk-gopostal:server:joinGroup', input[1]:upper())
        end
    end
end)

local function jobMenu()
    lib.callback('kk-gopostal:recieveData', false, function(response)
        local elements = {}

        if response.group then
            elements[#elements + 1] = {
                title = 'Liikmed',
                icon = 'fa-solid fa-users',
                description = 'Grupis on ' .. #response.group.members .. ' inimest.',
                event = 'kk-gopostal:client:viewMembers'
            }

            if response.group.owner == KKF.PlayerData.identifier then
                elements[#elements + 1] = {
                    title = 'Lõpeta töö',
                    icon = 'fa-solid fa-xmark',
                    description = 'Kõik liikmed jäävad üksi.',
                    serverEvent = 'kk-gopostal:server:deleteGroup',
                    args = {value = value}
                }

                if not response.group.active then
                    elements[#elements + 1] = {
                        title = 'Võtke tööauto',
                        icon = 'fa-solid fa-car',
                        description = 'Alustage tööotsa',
                        serverEvent = 'kk-gopostal:server:startJob',
                        args = {}
                    }
                end
            else
                elements[#elements + 1] = {
                    title = 'Lahku grupist',
                    icon = 'fa-solid fa-door-open',
                    description = 'Te jääte üksi...',
                    serverEvent = 'kk-gopostal:server:deleteGroup',
                    args = {value = value}
                }
            end
        else
            elements[#elements + 1] = {
                title = 'Loo uus grupp',
                icon = 'fa-solid fa-plus',
                description = 'Grupiliikmete maksimaalne arv on 2.',
                serverEvent = 'kk-gopostal:server:createGroup',
                args = {value = value}
            }

            elements[#elements + 1] = {
                title = 'Liitu grupiga',
                icon = 'fa-solid fa-right-to-bracket',
                description = 'Te ei kuulu veel ühtegi grupi.',
                event = 'kk-gopostal:client:joinGroup',
                args = {}
            }
        end

        lib.registerContext({
            id = 'gopostal_job',
            title = 'Postitöö',
            options = elements
        })
    
        lib.showContext('gopostal_job')
    end)
end

RegisterNetEvent('kk-gopostal:client:jobMenu', jobMenu)

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
    if hasBox then
		TaskLeaveVehicle(cache.ped, vehicle, 0); TriggerEvent('KKF.UI.ShowNotification', "error", "Pane asjad enne autosse tagasi!")
    end
end)

local function animCheck()
    CreateThread(function()
        while hasBox and not IsEntityPlayingAnim(cache.ped, 'anim@heists@box_carry@', 'idle', 3) do
            if not IsEntityPlayingAnim(cache.ped, 'anim@heists@box_carry@', 'idle', 3) then
                ClearPedTasksImmediately(cache.ped)
                lib.requestAnimDict('anim@heists@box_carry@')
                TaskPlayAnim(cache.ped, 'anim@heists@box_carry@', 'idle', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
            end

            Wait(1000)
        end
    end)
end

local function cancelButton()
    CreateThread(function()
        while hasBox do
            if IsControlJustReleased(0, 26) then
                hasBox = false; ClearPedTasks(cache.ped); KKF.HideInteraction()
                DetachEntity(current.mailBox, cache.ped); DeleteObject(current.mailBox)
            end

            Wait(0)
        end
    end)
end

RegisterNetEvent('kk-gopostal:client:startJob', function(groupData)
    while not NetworkDoesEntityExistWithNetworkId(groupData.vehicle) do Wait(200) end

    current.active = true
    current.locationId = groupData.location
    current.location = getLocationData(groupData.location)
    current.vehicle = NetworkGetEntityFromNetworkId(groupData.vehicle)
    current.plate = groupData.plate

    SetVehicleEngineOn(current.vehicle, true, true, true)
    exports['kk-vehicles']:addKey(current.plate)
    
    if current.location.coords then 
        current.blip = AddBlipForRadius(current.location.coords.x, current.location.coords.y, 0.0, 260.0)
        SetBlipSprite(current.blip, 9)
        SetBlipColour(current.blip, 17)
        SetBlipAlpha(current.blip, 80)
    end

    showInfo(current.location.label, groupData.pointsDone, groupData.pointsMax)

    exports.ox_target:addEntity({NetworkGetNetworkIdFromEntity(current.vehicle)}, {
        {
            name = 'gopostal_truck',
            icon = 'fa-solid fa-hand',
            label = 'Võta pakk ajalehti',
            distance = 1.5,
            bones = 'platelight',
            canInteract = function(entity, distance, coords, name, boneId)
                return current.active and #(coords - GetWorldPositionOfEntityBone(entity, boneId)) < 1.2 and not hasBox and isInZone(current.location.id)
            end,
            onSelect = function()
                hasBox = true; KKF.ShowInteraction('Viska kast ära', 'C')
                                    
                cancelButton(); animCheck()
                current.mailBox = exports['kk-scripts']:spawnAttachedObject(cache.ped, joaat('hei_prop_heist_box'), 60309, 0.025, 0.08, 0.255, -145.0, 290.0, 0.0)
            end
        }
    })
end)

RegisterNetEvent('kk-gopostal:client:updateData', function(groupData)
    RemoveBlip(current.blip); current.blip = nil

    current.locationId = groupData.location
    current.location = getLocationData(groupData.location)
    
    current.pointsDone = groupData.pointsDone; 
    current.pointsMax = groupData.pointsMax;

    if current.location.coords then 
        current.blip = AddBlipForRadius(current.location.coords.x, current.location.coords.y, 0.0, 260.0)
        SetBlipSprite(current.blip, 9)
        SetBlipColour(current.blip, 17)
        SetBlipAlpha(current.blip, 80)
    end

    showInfo(current.location.label, groupData.pointsDone, groupData.pointsMax)
end)

RegisterNetEvent('kk-gopostal:client:clearJob', function(owner)
    current.active = false
    current.locationId = nil
    current.location = {}
    exports['kk-vehicles']:removeKey(current.plate)
    DetachEntity(current.mailBox, cache.ped); DeleteObject(current.mailBox); current.mailBox = nil; hasBox = false; ClearPedTasks(cache.ped);
    TriggerEvent('kk-hud2:client:hideInstruction')
    RemoveBlip(current.blip); current.blip = nil

    current.pointsDone = 0
    current.pointsMax = 0

    TriggerEvent('KKF.UI.ShowNotification', 'info', 'Teie tööots on lõpetatud!')

    exports.ox_target:removeEntity({NetworkGetNetworkIdFromEntity(current.vehicle)}, {'gopostal_truck'})

    if owner then DeleteVehicle(current.vehicle) end
    current.vehicle = nil

    current.plate = nil
end)

local function registerPeds()
    SetTimeout(5000, function()
        exports['kk-scripts']:requestModel(`s_m_m_postal_01`)
        local entity = CreatePed(4, `s_m_m_postal_01`, cfg.ped.x, cfg.ped.y, cfg.ped.z - 1, cfg.ped.w, false, false)

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
                name = 'gopostal',
                distance = 1.5,
                icon = 'fa-solid fa-boxes-stacked',
                label = 'Tee tööd',
                onSelect = jobMenu,
            }
        })
    end)
end

local function deRegisterPeds()
    if ped then
        exports.ox_target:removeLocalEntity(ped.entity, {'gopostal'})
        DeleteObject(ped.prop); DeletePed(ped.entity); ped = nil
    end
end

RegisterNetEvent('KKF.Player.Loaded', function(xPlayer)
	KKF.PlayerData = xPlayer

    KKF.CreateBlip('gopostal', cfg.ped, 'Gopostal', 826, 17, 0.7)
    registerPeds()

    exports.ox_target:addModel(cfg.models, {
        {
            name = 'postbox',
            icon = 'fa-solid fa-box',
            label = 'Pane ajalehed kasti',
            distance = 1.0,
            canInteract = function() return current.active and hasBox end,
            onSelect = function(data)
                if isInZone(current.location.id) then
                    lib.callback('kk-gopostal:canDeliver', false, function(response)
                        if response then
                            hasBox = false; KKF.HideInteraction()
                            local progress = exports['kk-taskbar']:startAction('gopost_put', 'Paned ajalehti kasti', 2000, 'machinic_loop_mechandplayer', 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', {freeze = false, controls = true, disableCancel = true})

                            if progress then
                                DetachEntity(current.mailBox, cache.ped); DeleteObject(current.mailBox)
    
                                lib.callback.await('kk-gopostal:givePack', false, GetEntityCoords(data.entity), current.locationId)
                            end
                        else
                            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Siin on juba piisavalt ajalehti!')
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
	KKF.PlayerData = {}

    KKF.RemoveBlip('gopostal')
    deRegisterPeds(); exports.ox_target:removeModel(cfg.models, {'postbox'})
end)