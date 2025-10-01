taskActive = false
targetDisabled = false
inMechanic = false

local backengineVehicles = {
    'ninef',
    'adder',
    'vagner',
    't20',
    'infernus',
    'zentorno',
    'reaper',
    'comet2',
    'comet3',
    'jester',
    'jester2',
    'cheetah',
    'cheetah2',
    'prototipo',
    'turismor',
    'pfister811',
    'ardent',
    'nero',
    'nero2',
    'tempesta',
    'vacca',
    'bullet',
    'osiris',
    'entityxf',
    'turismo2',
    'fmj',
    're7b',
    'tyrus',
    'italigtb',
    'penetrator',
    'monroe',
    'ninef2',
    'stingergt',
    'surfer',
    'surfer2',
    'comet3',
}
local wheelBones = {
    car = {
        [1] = 'wheel_lf',
        [2] = 'wheel_rf',
        [3] = 'wheel_lr',
        [4] = 'wheel_rr',
        [5] = 'wheel_lm1',
        [6] = 'wheel_rm1',
        [7] = 'wheel_lm2',
        [8] = 'wheel_rm2',
        [9] = 'wheel_lm3',
        [10] = 'wheel_rm3'
    },

    bike = {
        [1] = 'wheel_lf',
        [2] = 'wheel_lr',
        [3] = 'wheel_rr',
        [4] = 'wheel_rf'
    }
}

local timeout = false
local vehicleInReview = nil
local tablet = false

RegisterNetEvent('kk-mechanic:client:reviewVehicle', function()
    if cache.vehicle then
        local progress = exports['kk-taskbar']:startAction('reviewVehicle', 'Tutvud sõidukiga', 4000, false, false, {freeze = true, controls = true})

        if progress then
            vehicleInReview = cache.vehicle
            TriggerEvent('KKF.UI.ShowNotification', 'info', 'Leidsid sõiduki kohta kõik vajaliku!')
        end
    end
end)

local function toggleTab(toggle)
    if toggle and not tablet then
        tablet = true

		if not cache.vehicle then
			CreateThread(function()
				lib.requestAnimDict('amb@code_human_in_bus_passenger_idles@female@tablet@base')

				local tabletObj = exports['kk-scripts']:spawnAttachedObject(cache.ped, joaat('prop_cs_tablet'), 60309, 0.03, 0.002, -0.0, 10.0, 160.0, 0.0)
				SetCurrentPedWeapon(cache.ped, `weapon_unarmed`, true)

				while tablet do
					Wait(100)

					if not IsEntityPlayingAnim(cache.ped, 'amb@code_human_in_bus_passenger_idles@female@tablet@base', 'base', 3) then
						TaskPlayAnim(cache.ped, 'amb@code_human_in_bus_passenger_idles@female@tablet@base', 'base', 3.0, 3.0, -1, 49, 0, 0, 0, 0)
					end
				end

				ClearPedSecondaryTask(cache.ped)

				Wait(450)

				DetachEntity(tabletObj, true, false); DeleteEntity(tabletObj)
			end)
		end
    elseif not toggle and tablet then
        tablet = false
    end
end



RegisterNetEvent('KKF.Player.Loaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('KKF.Player.Unloaded', function()
    ESX.PlayerData = {}
end)

RegisterNetEvent('KKF.Player.JobUpdate', function(job)
    ESX.PlayerData.job = job
end)

RegisterNetEvent('KKF.Player.DutyChange', function(value)
	ESX.PlayerData.job.onDuty = value
end)

local function saveVehicle(vehicle)
    local myCar = ESX.Game.GetVehicleProperties(vehicle)
    
    TriggerServerEvent('qb-customs:server:updateVehicle', myCar)
end

local function isBackEngine(model)
    for i = 1, #backengineVehicles do
        if GetHashKey(backengineVehicles[i]) == model then
            return true
        end
    end
    return false
end

local function canInteract()
    for k,v in pairs(cfg.locations) do
        if ESX.PlayerData.job.name == k and ESX.PlayerData.job.onDuty then
            return true
        end
    end

    return false
end

exports('canInteract', canInteract) -- exports['kk-mechanic']:canInteract()

-- RegisterNetEvent('kk-mechanic:client:openStash', function()
--     if canInteract() then
--         exports.ox_inventory:openInventory('stash', ESX.PlayerData.job.name)
--     end
-- end)


RegisterNetEvent('kk-mechanic:client:deliveries', function(args)
    local input = lib.inputDialog('Tellitud jupid', {'Sõiduki numbrimärk'})

    if input then
        lib.callback('kk-mechanic:requestDeliveries', false, function(response)
            if response then
                local elements = {}

                for k,v in pairs(response) do
                    elements[#elements + 1] = {
                        title = exports.ox_inventory:Items()[v.item].label,
                        serverEvent = 'kk-mechanic:server:takeItem',
                        args = {plate = string.upper(input[1]), item = v.item}
                    }
                end

                lib.registerContext({
                    id = 'vehicle_parts',
                    title = 'Jupid - ' .. input[1],
                    options = elements
                })

                lib.showContext('vehicle_parts')
            else
                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Antud sõidukil ei ole tarnitud juppe!')
            end
        end, string.upper(input[1]))
    end
end)

CreateThread(function()
    while true do
        wait = 500

        if cache.vehicle then
            if cache.seat == -1 and GetVehicleClass(cache.vehicle) ~= 13 and GetVehicleClass(cache.vehicle) ~= 14 and GetVehicleClass(cache.vehicle) ~= 15 and GetVehicleClass(cache.vehicle) ~= 16 and GetVehicleClass(cache.vehicle) ~= 17 and GetVehicleClass(cache.vehicle) ~= 21 then
                local currentMileage = Entity(cache.vehicle).state.mileage or 0
                local oldPos = GetEntityCoords(cache.ped); Wait(1000); local curPos = GetEntityCoords(cache.ped)

                if IsVehicleOnAllWheels(cache.vehicle) then
                    dist = #(oldPos - curPos)
                else
                    dist = 0
                end

                if cache.vehicle then 
                    Entity(cache.vehicle).state.mileage = currentMileage + dist 
                end
            else
                wait = 1500
            end
        else
            wait = 1500
        end

        Wait(wait)
    end
end)

RegisterNetEvent('kk-mechanic:client:buyParts', function()
    if vehicleInReview then
        if DoesEntityExist(vehicleInReview) then
            lib.callback('kk-mechanic:requestData', false, function(logBook, degration)
                local price = 50000
                local class = 'XXX' 

                if exports['kk-vehicleshop']:getVehicle(GetEntityModel(vehicleInReview)) then
                    price = exports['kk-vehicleshop']:getVehicle(GetEntityModel(vehicleInReview)).price
                    class = exports['kk-vehicleshop']:getVehicle(GetEntityModel(vehicleInReview)).class
                end

                -- if exports['kk-factions']:getVehicle(GetEntityModel(vehicleInReview)) then
                --     price = exports['kk-factions']:getVehicle(GetEntityModel(vehicleInReview)).price
                --     class = exports['kk-factions']:getVehicle(GetEntityModel(vehicleInReview)).class
                -- end

                SetVehicleModKit(vehicleInReview, 0)

                local currentData = {
                    model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicleInReview))),
                    plate = GetVehicleNumberPlateText(vehicleInReview),
                    mileage = math.floor((Entity(vehicleInReview).state.mileage or 0) * 1.0) / 1000,
                    carPrice = price,
                    prices = cfg.prices,
                    logBook = logBook,
                    degration = degration,
                    class = class,
                    mods = {
                        brakes = {GetNumVehicleMods(vehicleInReview, 12), GetVehicleMod(vehicleInReview, 12)},
                        engine = {GetNumVehicleMods(vehicleInReview, 11), GetVehicleMod(vehicleInReview, 11)},
                        suspension = {GetNumVehicleMods(vehicleInReview, 15), GetVehicleMod(vehicleInReview, 15)},
                        transmission = {GetNumVehicleMods(vehicleInReview, 13), GetVehicleMod(vehicleInReview, 13)},
                        turbo = {1, IsToggleModOn(vehicleInReview, 18)}
                    }
                }

                SendNUIMessage({action = 'open', data = currentData}); SetNuiFocus(true, true); toggleTab(true)
            end, GetVehicleNumberPlateText(vehicleInReview))
        else
            vehicleInReview = nil
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Tundub, et sõidukit ei ole enam olemas.')
        end
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Enne juppide ostu tutvu sõidukiga.')
    end
end)

-- RegisterCommand('mechanicTablet', function()
--     if not LocalPlayer.state['isLoggedIn'] then return end
--     TriggerEvent('kk-mechanic:client:buyParts')
-- end)

-- RegisterKeyMapping('mechanicTablet', 'Kasuta diagnostikaseadet', 'keyboard', 'F7')

RegisterNUICallback('closeTablet', function()
    SendNUIMessage({action = 'close'}); SetNuiFocus(false, false); toggleTab(false)
end)

RegisterNUICallback('buyPart', function(args, cb)
    if timeout then return TriggerEvent('KKF.UI.ShowNotification', 'error', 'Oota natukene...') end
    timeout = true

    lib.callback('kk-mechanic:buyPart', false, function(response)
        if response then
            TriggerEvent('KKF.UI.ShowNotification', 'success', 'Soetasite jupi $' .. args.price .. ' eest.')
        else
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Fraktsioonil ei olnud antud tegevuse jaoks piisavalt raha!')
        end

        cb('done')
    end, args)

    SetTimeout(3000, function() timeout = false end)
end)

CreateThread(function()
    for k,v in pairs(cfg.zones) do
        lib.zones.box({
            coords = v.coords,
            size = v.size,
            rotation = v.rotation,
            debug = false,
            onEnter = function()
                inMechanic = true
            end,
            onExit = function()
                inMechanic = false
            end
        })
    end
end)


CreateThread(function()
    ESX.PlayerData = ESX.GetPlayerData()

    for k,v in pairs(cfg.locations) do
        if k ~= 'harmony' and not k == 'eventure' and not k == 'harmony' then
            ESX.CreateBlip('mechanic_' .. k, v.polyZone.coords, 'Mehaanik', 446, nil, 0.7)
        elseif k == 'eventure' then
            ESX.CreateBlip('mechanic_' .. k, v.polyZone.coords, 'Eventure Automotive', 816, nil, 0.7)
        elseif k == 'harmony' then
            ESX.CreateBlip('mechanic_' .. k, v.polyZone.coords, 'Eriliste sõidukite töökoda', 143, nil, 0.7)
        else
            ESX.CreateBlip('mechanic_' .. k, v.polyZone.coords, 'Mehaanik', 446, nil, 0.7)
        end

        lib.zones.box({
            coords = v.polyZone.coords,
            size = v.polyZone.size,
            rotation = v.polyZone.rotation,
            debug = false,
            onEnter = function()
                inMechanic = true
            end,
            onExit = function()
                inMechanic = false
            end
        })
    
        if v.stash then
            exports.ox_target:addBoxZone({
                coords = v.stash.coords,
                size = v.stash.size,
                rotation = v.stash.rotation,
                debug = false,
                options = {
                    {
                        event = 'kk-mechanic:client:deliveries',
                        args = {id = k},
    
                        icon = 'fa-solid fa-gear',
                        label = 'Vaata juppe',
                        distance = 1.5,
                        canInteract = function()
                            return (ESX.PlayerData.job.name == k and ESX.PlayerData.job.onDuty)
                        end
                    }
                }
            })
        end
    
        if v.duty then
            exports.ox_target:addBoxZone({
                coords = v.duty.coords,
                size = v.duty.size,
                rotation = v.duty.rotation,
                debug = false,
                options = {
                    {
                        serverEvent = 'kk-scripts:server:toggleDuty',
    
                        icon = 'far fa-clipboard',
                        label = 'Alusta/Lõpeta tööpäeva',
                        distance = 1.5,
                        canInteract = function()
                            return ESX.PlayerData.job.name == k
                        end
                    },

                    {
                        event = 'wardrobe:clothingShop',
                        icon = 'fas fa-tshirt',
                        label = 'Riidekapp',
                        distance = 1.5,
                        canInteract = function()
                            return ESX.PlayerData.job.name == k
                        end
                    },
                }
            })
        end
    
        if v.parts then
            exports.ox_target:addBoxZone({
                coords = v.parts.coords,
                size = v.parts.size,
                rotation = v.parts.rotation,
                debug = false,
                options = {
                    {
                        event = 'kk-mechanic:client:buyParts',

                        icon = 'fa-solid fa-computer',
                        label = 'Soeta juppe',
                        distance = 1.5,
                        canInteract = function()
                            return (ESX.PlayerData.job.name == k and ESX.PlayerData.job.onDuty)
                        end
                    }
                }
            })
        end

        if v.unboxing then
            exports.ox_target:addBoxZone({
                coords = v.unboxing.coords,
                size = v.unboxing.size,
                rotation = v.unboxing.rotation,
                debug = false,
                options = {
                    {
                        icon = 'fa-solid fa-scissors',
                        label = 'Paki lahti',
                        distance = 1.5,

						onSelect = function()
                            exports['kk-crafting']:openCraftMenu('mechanic_unboxer')
						end,

                        canInteract = function()
                            return (ESX.PlayerData.job.name == k and ESX.PlayerData.job.onDuty)
                        end
                    }
                }
            })
        end
    end
end)

local function findVehicleInDirection(coordFromOffset, coordToOffset)
    local coordFrom = GetOffsetFromEntityInWorldCoords(cache.ped, coordFromOffset.x, coordFromOffset.y, coordFromOffset.z)
    local coordTo = GetOffsetFromEntityInWorldCoords(cache.ped, coordToOffset.x, coordToOffset.y, coordToOffset.z)

    local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, cache.ped, 0)
    local _, _, _, _, vehicle = GetShapeTestResult(rayHandle)
    
    return vehicle
end


function getVehicleInDirection()
    local vehicle = GetVehiclePedIsIn(cache.ped)

    local RaycastOffsetTable = {
        { ['fromOffset'] = vector3(0.0, 0.0, 0.0), ['toOffset'] = vector3(0.0, 20.0, -10.0) }, -- Waist to ground 45 degree angle
        { ['fromOffset'] = vector3(0.0, 0.0, 0.7), ['toOffset'] = vector3(0.0, 10.0, -10.0) }, -- Head to ground 30 degree angle
        { ['fromOffset'] = vector3(0.0, 0.0, 0.7), ['toOffset'] = vector3(0.0, 10.0, -20.0) }, -- Head to ground 15 degree angle
    }

    local count = 0
    while vehicle == 0 and count < #RaycastOffsetTable do
        count = count + 1
        vehicle = findVehicleInDirection(RaycastOffsetTable[count]['fromOffset'], RaycastOffsetTable[count]['toOffset'])
    end

    if not IsEntityAVehicle(vehicle) then vehicle = nil end
    return vehicle
end


RegisterNetEvent('kk-mechanic:client:changeBrakes', function(lvl, plate)
    if inMechanic then
        if not taskActive then
            taskActive = true
            local vehicle = getVehicleInDirection()

            if DoesEntityExist(vehicle) then
                if GetVehicleNumberPlateText(vehicle) == plate then
                    local type = 'car'
                    local changing = true; local count = GetVehicleNumberOfWheels(vehicle); 
                    local jobs = {done = 0, points = {}}

                    if IsThisModelABike(GetEntityModel(vehicle)) then
                        type = 'bike'
                    end

                    TriggerServerEvent('KKF.Player.RemoveItem', 'brakes_' .. lvl, 1, {plate = plate})

                    for i = 1, count do
                        exports.ox_target:addEntity({NetworkGetNetworkIdFromEntity(vehicle)}, {
                            {
                                name = 'brake_' .. i,
                                icon = 'fa-solid fa-wrench',
                                label = 'Vaheta pidur',
                                distance = 1.5,
                                bones = wheelBones[type][i],
                                canInteract = function(entity, distance, coords, name, boneId)
                                    return #(coords - GetWorldPositionOfEntityBone(entity, boneId)) < 1.0 and not targetDisabled
                                end,
                                onSelect = function()
                                    if not jobs.points[i] then
                                        targetDisabled = true; jobs.points[i] = true; jobs.done += 1
    
                                        local progress = exports['kk-taskbar']:startAction('changingBrake', 'Vahetad piduriklotse', 10000, 'fixing_a_player', 'mini@repair', {freeze = true, controls = true})
    
                                        if progress then
                                            if jobs.done >= count then
                                                changing = false
                                            end
                                        else
                                            jobs.points[i] = nil; jobs.done -= 1
                                        end

                                        targetDisabled = false
                                    else
                                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'See pidur on juba vahetatud!')
                                    end
                                end
                            },
                        })
                    end

                    while changing do
                        Wait(500)
                    end

                    for i = 1, count do
                        exports.ox_target:removeEntity({NetworkGetNetworkIdFromEntity(vehicle)}, {'brake_' .. i})
                    end

                    ESX.Game.RequestNetworkControlOfEntity(vehicle)
                    SetVehicleModKit(vehicle, 0); SetVehicleMod(vehicle, 12, (lvl - 1), GetVehicleModVariation(vehicle, 23))
                    TriggerServerEvent('kk-mechanic:server:addLog', plate, 'Piduriklotside vahetus (LVL' .. lvl .. ')')
                    TriggerEvent('KKF.UI.ShowNotification', 'success', 'Vahetasite sõiduki kõik piduriklotsid!')
                    taskActive = false; saveVehicle(vehicle)
                else
                    taskActive = false
                    TriggerEvent('KKF.UI.ShowNotification', 'error', 'Need pidurid ei sobi sellele sõidukile!')
                end
            else
                taskActive = false
                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ühtegi sõidukit ei ole läheduses!')
            end
        else
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ei saa kahte asja korraga vahetada!')
        end
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Siin ei saa pidureid vahetada!')
    end
end)

RegisterNetEvent('kk-mechanic:client:changeSuspension', function(lvl, plate)
    if inMechanic then
        if not taskActive then
            taskActive = true
            local vehicle = getVehicleInDirection()

            if DoesEntityExist(vehicle) then
                if GetVehicleNumberPlateText(vehicle) == plate then
                    local type = 'car'
                    local changing = true; local count = GetVehicleNumberOfWheels(vehicle); 
                    local jobs = {done = 0, points = {}}

                    if IsThisModelABike(GetEntityModel(vehicle)) then
                        type = 'bike'
                    end

                    TriggerServerEvent('KKF.Player.RemoveItem', 'suspension_' .. lvl, 1, {plate = plate})

                    for i = 1, count do
                        exports.ox_target:addEntity({NetworkGetNetworkIdFromEntity(vehicle)}, {
                            {
                                name = 'suspension_' .. i,
                                icon = 'fa-solid fa-wrench',
                                label = 'Vaheta vedrustust',
                                distance = 1.5,
                                bones = wheelBones[type][i],
                                canInteract = function(entity, distance, coords, name, boneId)
                                    return #(coords - GetWorldPositionOfEntityBone(entity, boneId)) < 1.0 and not targetDisabled
                                end,
                                onSelect = function()
                                    if not jobs.points[i] then
                                        targetDisabled = true; jobs.points[i] = true; jobs.done += 1
    
                                        local progress = exports['kk-taskbar']:startAction('changingSuspension', 'Vahetad vedrustust', 10000, 'fixing_a_player', 'mini@repair', {freeze = true, controls = true})
    
                                        if progress then
                                            if jobs.done >= count then
                                                changing = false
                                            end
                                        else
                                            jobs.points[i] = nil; jobs.done -= 1
                                        end

                                        targetDisabled = false
                                    else
                                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'See vedru on juba vahetatud!')
                                    end
                                end
                            },
                        })
                    end

                    while changing do
                        Wait(500)
                    end

                    for i = 1, count do
                        exports.ox_target:removeEntity({NetworkGetNetworkIdFromEntity(vehicle)}, {'suspension_' .. i})
                    end

                    ESX.Game.RequestNetworkControlOfEntity(vehicle)
                    SetVehicleModKit(vehicle, 0); SetVehicleMod(vehicle, 15, (lvl - 1), GetVehicleModVariation(vehicle, 23))
                    TriggerServerEvent('kk-mechanic:server:addLog', plate, 'Vedrustuse vahetus (LVL' .. lvl .. ')')
                    TriggerEvent('KKF.UI.ShowNotification', 'success', 'Vahetasite sõiduki vedrustuse!')
                    taskActive = false; saveVehicle(vehicle)
                else
                    taskActive = false
                    TriggerEvent('KKF.UI.ShowNotification', 'error', 'Need vedrud ei sobi sellele sõidukile!')
                end
            else
                taskActive = false
                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ühtegi sõidukit ei ole läheduses!')
            end
        else
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ei saa kahte asja korraga vahetada!')
        end
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Siin ei saa vedrustust vahetada!')
    end
end)

RegisterNetEvent('kk-mechanic:client:changeEngine', function(lvl, plate)
    if inMechanic then
        if not taskActive then
            taskActive = true
            local vehicle = getVehicleInDirection()

            if DoesEntityExist(vehicle) then
                if GetVehicleNumberPlateText(vehicle) == plate then
                    local changing = true;
                    TriggerServerEvent('KKF.Player.RemoveItem', 'engine_' .. lvl, 1, {plate = plate})

                    exports.ox_target:addEntity({NetworkGetNetworkIdFromEntity(vehicle)}, {
                        {
                            name = 'engine',
                            icon = 'fa-solid fa-wrench',
                            label = 'Vaheta mootor',
                            distance = 1.5,
                            bones = {'engine', 'bonnet', 'door_dside_f'},
                            canInteract = function(entity, distance, coords, name, boneId)
                                return #(coords - GetWorldPositionOfEntityBone(entity, boneId)) < 1.5 and not targetDisabled
                            end,
                            onSelect = function()
                                if isBackEngine(GetEntityModel(vehicle)) then
                                    SetVehicleDoorOpen(vehicle, 5, false, false)
                                else
                                    SetVehicleDoorOpen(vehicle, 4, false, false)
                                end

                                local progress = exports['kk-taskbar']:startAction('changingEngine', 'Vahetad mootorit', 20000, 'fixing_a_player', 'mini@repair', {freeze = true, controls = true})

                                if progress then
                                    changing = false
                                end

                                if isBackEngine(GetEntityModel(vehicle)) then
                                    SetVehicleDoorOpen(vehicle, 5, true, true)
                                else
                                    SetVehicleDoorOpen(vehicle, 4, true, true)
                                end
                            end
                        },
                    })

                    while changing do
                        Wait(500)
                    end

                    exports.ox_target:removeEntity({NetworkGetNetworkIdFromEntity(vehicle)}, {'engine'})

                    ESX.Game.RequestNetworkControlOfEntity(vehicle)
                    SetVehicleModKit(vehicle, 0); SetVehicleMod(vehicle, 11, (lvl - 1), GetVehicleModVariation(vehicle, 23))
                    TriggerServerEvent('kk-mechanic:server:addLog', plate, 'Mootorivahetus (LVL' .. lvl .. ')')
                    TriggerEvent('KKF.UI.ShowNotification', 'success', 'Vahetasite sõiduki mootori!')
                    taskActive = false; saveVehicle(vehicle)
                else
                    taskActive = false
                    TriggerEvent('KKF.UI.ShowNotification', 'error', 'See mootor ei sobi sellele sõidukile!')
                end
            else
                taskActive = false
                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ühtegi sõidukit ei ole läheduses!')
            end
        else
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ei saa kahte asja korraga vahetada!')
        end
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Siin ei saa mootorit vahetada!')
    end
end)
RegisterNetEvent('kk-mechanic:client:changeTurbo', function(plate)
    if inMechanic then
        if not taskActive then
            taskActive = true
            local vehicle = getVehicleInDirection()

            if DoesEntityExist(vehicle) then
                if GetVehicleNumberPlateText(vehicle) == plate then
                    local changing = true;
                    
                    TriggerServerEvent('KKF.Player.RemoveItem', 'turbo_1', 1, {plate = plate})

                    exports.ox_target:addEntity({NetworkGetNetworkIdFromEntity(vehicle)}, {
                        {
                            name = 'turbo',
                            icon = 'fa-solid fa-wrench',
                            label = 'Vaheta turbo',
                            distance = 1.5,
                            bones = {'engine', 'bonnet', 'door_dside_f'},
                            canInteract = function(entity, distance, coords, name, boneId)
                                return #(coords - GetWorldPositionOfEntityBone(entity, boneId)) < 1.5 and not targetDisabled
                            end,
                            onSelect = function()
                                if isBackEngine(GetEntityModel(vehicle)) then
                                    SetVehicleDoorOpen(vehicle, 5, false, false)
                                else
                                    SetVehicleDoorOpen(vehicle, 4, false, false)
                                end

                                local progress = exports['kk-taskbar']:startAction('changingEngine', 'Vahetad turbot', 20000, 'fixing_a_player', 'mini@repair', {freeze = true, controls = true})

                                if progress then
                                    changing = false
                                end

                                if isBackEngine(GetEntityModel(vehicle)) then
                                    SetVehicleDoorOpen(vehicle, 5, true, true)
                                else
                                    SetVehicleDoorOpen(vehicle, 4, true, true)
                                end
                            end
                        },
                    })

                    while changing do
                        Wait(500)
                    end

                    exports.ox_target:removeEntity({NetworkGetNetworkIdFromEntity(vehicle)}, {'turbo'})

                    ESX.Game.RequestNetworkControlOfEntity(vehicle)
                    SetVehicleModKit(vehicle, 0); ToggleVehicleMod(vehicle, 18, true)
                    TriggerServerEvent('kk-mechanic:server:addLog', plate, 'Turbo vahetus')
                    TriggerEvent('KKF.UI.ShowNotification', 'success', 'Vahetasite sõiduki turbo!')
                    taskActive = false; saveVehicle(vehicle) 
                else
                    taskActive = false
                    TriggerEvent('KKF.UI.ShowNotification', 'error', 'See turbo ei sobi sellele sõidukile!')
                end
            else
                taskActive = false
                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ühtegi sõidukit ei ole läheduses!')
            end
        else
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ei saa kahte asja korraga vahetada!')
        end
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Siin ei saa turbot vahetada!')
    end
end)

RegisterNetEvent('kk-mechanic:client:changeTransmission', function(lvl, plate)
    if inMechanic then
        if not taskActive then
            taskActive = true
            local vehicle = getVehicleInDirection()

            if DoesEntityExist(vehicle) then
                if GetVehicleNumberPlateText(vehicle) == plate then
                    local changing = true;
                    TriggerServerEvent('KKF.Player.RemoveItem', 'transmission_' .. lvl, 1, {plate = plate})

                    exports.ox_target:addEntity({NetworkGetNetworkIdFromEntity(vehicle)}, {
                        {
                            name = 'transmission',
                            icon = 'fa-solid fa-wrench',
                            label = 'Vaheta käigukasti',
                            distance = 1.5,
                            bones = {'engine', 'bonnet', 'door_dside_f'},
                            canInteract = function(entity, distance, coords, name, boneId)
                                return #(coords - GetWorldPositionOfEntityBone(entity, boneId)) < 1.5 and not targetDisabled
                            end,
                            onSelect = function()
                                if isBackEngine(GetEntityModel(vehicle)) then
                                    SetVehicleDoorOpen(vehicle, 5, false, false)
                                else
                                    SetVehicleDoorOpen(vehicle, 4, false, false)
                                end

                                local progress = exports['kk-taskbar']:startAction('changingTransmission', 'Vahetad käigukasti', 20000, 'fixing_a_player', 'mini@repair', {freeze = true, controls = true})

                                if progress then
                                    changing = false
                                end

                                if isBackEngine(GetEntityModel(vehicle)) then
                                    SetVehicleDoorOpen(vehicle, 5, true, true)
                                else
                                    SetVehicleDoorOpen(vehicle, 4, true, true)
                                end
                            end
                        },
                    })

                    while changing do
                        Wait(500)
                    end

                    exports.ox_target:removeEntity({NetworkGetNetworkIdFromEntity(vehicle)}, {'transmission'})

                    ESX.Game.RequestNetworkControlOfEntity(vehicle)
                    SetVehicleModKit(vehicle, 0); SetVehicleMod(vehicle, 13, (lvl - 1), GetVehicleModVariation(vehicle, 23))
                    TriggerServerEvent('kk-mechanic:server:addLog', plate, 'Käigukasti vahetus (LVL' .. lvl .. ')')
                    TriggerEvent('KKF.UI.ShowNotification', 'success', 'Vahetasite sõiduki käigukasti!')
                    taskActive = false; saveVehicle(vehicle)
                else
                    taskActive = false
                    TriggerEvent('KKF.UI.ShowNotification', 'error', 'See käigukast ei sobi sellele sõidukile!')
                end
            else
                taskActive = false
                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ühtegi sõidukit ei ole läheduses!')
            end
        else
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ei saa kahte asja korraga vahetada!')
        end
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Siin ei saa käigukasti vahetada!')
    end
end)

RegisterNetEvent('kk-mechanic:client:startRepairMenu', function()
    TriggerServerEvent('kk-mechanic:server:startRepair')
end)

RegisterNetEvent('kk-mechanic:client:startRepair', function()
    if inMechanic then
        if taskActive then return end
        local playerPed = PlayerPedId()

        if not IsPedInAnyVehicle(playerPed, false) then
            local vehicle = getVehicleInDirection()
            
            if DoesEntityExist(vehicle) then
                taskActive = true
                local skill = exports['kk-skillbar']:skillBar(70, 5)
                
                if skill then
                    local progress = exports['kk-taskbar']:startAction('repair', 'Parandan sõidukit', 30000, 'PROP_HUMAN_BUM_BIN', false, {freeze = true, controls = true})
    
                    if progress then 
                        ClearPedTasks(playerPed)
                        -- exports["cdn-fuel"]:SetFuel(vehicle, fuelLevel)
                        Entity(vehicle).state.fuel = fuelLevel
                        TriggerEvent('KKF.UI.ShowNotification', 'success', 'Sõiduk parandatud.')
                        SetVehicleFixed(vehicle)
                        SetVehicleDeformationFixed(vehicle)
                        SetVehicleUndriveable(vehicle, false)
                        TriggerServerEvent('KKF.Player.RemoveItem', 'fixkit', 1)
    
                        if canInteract() then
                            TriggerServerEvent('kk-mechanic:server:addLog', GetVehicleNumberPlateText(vehicle), 'Sõiduki parandus.')
                        end
    
                        taskActive = false
                    else
                        ClearPedTasks(playerPed)
                        taskActive = false
                    end
                else
                    ClearPedTasks(playerPed)
                    taskActive = false
                    TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ebaõnnestusite sõiduki parandamisel.')
                end
            else
                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ühtegi sõidukit ei ole läheduses.')
            end
        else
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Sõiduki parandamiseks peate olema sõidukist väljaspool.')
        end
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Sõiduki parandamiseks peate olema töökojas!')
    end
end)

RegisterNetEvent('kk-mechanic:client:startCleaning', function()
    if taskActive then return end
    local playerPed = PlayerPedId()

    if not IsPedInAnyVehicle(playerPed, false) then
        local vehicle = ESX.Game.GetVehicleInDirection()

        if DoesEntityExist(vehicle) then
            taskActive = true

            local skillSuccess = exports['kk-skillbar']:skillBar(70, 5)

            if skillSuccess then
                local progress = exports['kk-taskbar']:startAction('clean', 'Puhastan sõidukit', 7500, 'WORLD_HUMAN_MAID_CLEAN', false, {freeze = true, controls = true})
                
                if progress then
                    SetVehicleDirtLevel(vehicle, 0)
                    ClearPedTasks(playerPed)

                    TriggerEvent('KKF.UI.ShowNotification', 'success', 'Sõiduk puhastatud.')
                    taskActive = false
                else
                    ClearPedTasks(playerPed)
                    taskActive = false
                end
            else
                ClearPedTasks(playerPed)
                taskActive = false
                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ebaõnnestusite sõiduki puhastamisel.')
            end
        else
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ühtegi sõidukit ei ole läheduses.')
        end
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Sõiduki puhastamiseks peate olema sõidukist väljaspool.')
    end
end)




local function isTrailer(entity)
    for k,v in pairs(cfg.trailers) do
        if GetEntityModel(entity) == joaat(v) then
            return true
        end
    end

    return false
end

exports.ox_target:addGlobalVehicle({
	{
		name = 'putOnTrailer',
		distance = 2.0,
		icon = 'fa-solid fa-cart-flatbed',
		label = 'Treiler',
        canInteract = function(entity)
            return not cache.vehicle and (canInteract() or (ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.onDuty)) and not isTrailer(entity)
        end,
        onSelect = function(data)
			local cars = ESX.Game.GetVehiclesInArea(GetEntityCoords(data.entity), 15.0)
			local trailerEntity = nil
			
			for i = 1, #cars, 1 do
				if isTrailer(cars[i]) then
					trailerEntity = cars[i]
					break
				end
			end

			if DoesEntityExist(trailerEntity) then
                local progress = exports['kk-taskbar']:startAction('putOnTrailer', 'Tegeled sõidukiga', 5000, 'keeper_base', 'misshair_shop@hair_dressers', {freeze = false, controls = true})

                if progress then
                    local attachedEntity = Entity(trailerEntity).state.attached
            
                    if attachedEntity then
                        if attachedEntity == NetworkGetNetworkIdFromEntity(data.entity) then
                            ESX.Game.RequestNetworkControlOfEntity(data.entity)
                            FreezeEntityPosition(data.entity, true)
                            AttachEntityToEntity(data.entity, trailerEntity, GetEntityBoneIndexByName(trailerEntity, 'chassis'), -0.5, -9.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
                            DetachEntity(data.entity, true, true)
    
                            SetTimeout(1000, function()
                                FreezeEntityPosition(data.entity, false)
                                SetVehicleOnGroundProperly(data.entity)
                            end)
    
                            Entity(trailerEntity).state.attached = nil
                            TriggerEvent('KKF.UI.ShowNotification', 'info', 'Sõiduk eemaldatud puksiirilt.')
                        else
                            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Antud puksiiril on juba sõiduk peale!')
                        end
                    else
                        local vehicleModel = GetEntityModel(data.entity)
                        local trailerModel = GetEntityModel(trailerEntity)
                        local vehicleHeightMin, vehicleHeightMax = GetModelDimensions(vehicleModel)
                        local placements = {-2.8, 0.4}

                        if cfg.placement[trailerModel] then
                            placements = cfg.placement[trailerModel]
                        end

                        AttachEntityToEntity(data.entity, trailerEntity, GetEntityBoneIndexByName(trailerEntity, 'chassis'), 0.0, placements[1], placements[2] - vehicleHeightMin.z, 0, 0, 0, 1, 1, 1, 1, 0, 1)
                        Entity(trailerEntity).state.attached = NetworkGetNetworkIdFromEntity(data.entity)
                        TriggerEvent('KKF.UI.ShowNotification', 'success', 'Sõiduk kinnitatud puksiirile!')
                    end 
                end
			else
				TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ühtegi puksiiril ei ole läheduses.')
			end	
        end 
	}
})

exports('inMechanic', function()
    return inMechanic
end)



-- local propertyMechanic = false

-- CreateThread(function()
--     for k,v in pairs(cfg.properties) do
--         lib.zones.box({
--             coords = v.coords,
--             size = v.size,
--             rotation = v.rotation,
--             debug = false,
--             onEnter = function()
--                 local hasItem = exports.ox_inventory:Search('count', 'property_key') > 0

--                 if hasItem and (cache.vehicle and cache.seat == -1) then
--                     ESX.ShowInteraction('Mehaanik')
--                     propertyMechanic = true
--                 end
--             end,
--             onExit = function()
--                 propertyMechanic = false
--                 ESX.HideInteraction()
--             end
--         })
--     end
-- end)

-- exports('inPropertyMechanic', function()
--     return propertyMechanic
-- end)

-- RegisterNetEvent('kk-mechanic:client:propertyMechanic', function()
--     if cache.vehicle and cache.seat == -1 then
--         local hasKey = exports.ox_inventory:Search('count', 'property_key') > 0
--         local hasBadge = exports.ox_inventory:Search('count', 'badge') > 0

--         if hasKey or hasBadge then
--             lib.callback('kk-mechanic:hasBank', false, function(response, needed)
--                 if response then
--                     local progress = exports['kk-taskbar']:startAction('repair', 'Sõidukit parandatakse', 10000, false, false, {freeze = true, controls = true, disableCancel = true})
    
--                     if progress then
--                         TriggerEvent('KKF.UI.ShowNotification', 'success', 'Sõiduk parandatud.')
--                         SetVehicleFixed(cache.vehicle)
--                         SetVehicleDeformationFixed(cache.vehicle)
--                         SetVehicleUndriveable(cache.vehicle, false)
--                         SetVehicleDirtLevel(cache.vehicle, 0.0)
--                     end
--                 else
--                     TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil ei ole piisavalt raha! ($' .. needed .. ')')
--                 end
--             end)
--         else
--             TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil ei ole võtit või ametitõendit!')
--         end
--     end
-- end)