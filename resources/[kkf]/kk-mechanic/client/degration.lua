local function tryDegradation(vehicle)
    if GetVehicleNumberPlateText(vehicle) then
        TriggerServerEvent('kk-mechanic:server:degrade', NetworkGetNetworkIdFromEntity(vehicle))
    end
end

exports('tryDegradation', tryDegradation)

local function classValidation(vehicle, class)
    if exports['kk-vehicleshop']:getVehicle(GetEntityModel(vehicle)) then
        return exports['kk-vehicleshop']:getVehicle(GetEntityModel(vehicle)).class:upper() == class:upper()
    end

    -- if exports['kk-factions']:getVehicle(GetEntityModel(vehicle)) then
    --     return exports['kk-factions']:getVehicle(GetEntityModel(vehicle)).class:upper() == class:upper()
    -- end

    return false
end
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

wheelBones = {
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

local function isBackEngine(model)
    for i = 1, #backengineVehicles do
        if GetHashKey(backengineVehicles[i]) == model then
            return true
        end
    end
    return false
end


RegisterNetEvent('kk-mechanic:client:fixPart', function(class, item)
    if inMechanic then
        if not taskActive then
            taskActive = true
            local vehicle = getVehicleInDirection()

            if DoesEntityExist(vehicle) then
                if GetVehicleNumberPlateText(vehicle) then
                    if classValidation(vehicle, class) then
                        local itemName = item .. '_' .. class

                        if exports.ox_inventory:Search('count', itemName) >= 1 then 
                            if item == 'fuel_injector' or item == 'radiator' or item == 'axle' or item == 'transmission' or item == 'clutch' then
                                local changing = true
                                TriggerServerEvent('KKF.Player.RemoveItem', itemName, 1)
            
                                exports.ox_target:addEntity({NetworkGetNetworkIdFromEntity(vehicle)}, {
                                    {
                                        name = 'motor_type',
                                        icon = 'fa-solid fa-wrench',
                                        label = 'Vaheta juppi',
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
            
                                            local progress = exports['kk-taskbar']:startAction('changing_carpart', 'Vahetad juppi...', 20000, 'fixing_a_player', 'mini@repair', {freeze = true, controls = true})
            
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
            
                                exports.ox_target:removeEntity({NetworkGetNetworkIdFromEntity(vehicle)}, {'motor_type'})
                                TriggerServerEvent('kk-mechanic:server:fixVehicle', NetworkGetNetworkIdFromEntity(vehicle), item)
                                taskActive = false
                            elseif item == 'brakes' or item == 'tire' then
                                local type = 'car'
                                local changing = true; local count = GetVehicleNumberOfWheels(vehicle); 
                                local jobs = {done = 0, points = {}}
            
                                if IsThisModelABike(GetEntityModel(vehicle)) then
                                    type = 'bike'
                                end
            
                                TriggerServerEvent('KKF.Player.RemoveItem', itemName, 1)
            
                                for i = 1, count do
                                    exports.ox_target:addEntity({NetworkGetNetworkIdFromEntity(vehicle)}, {
                                        {
                                            name = 'brake_part_' .. i,
                                            icon = 'fa-solid fa-wrench',
                                            label = 'Vaheta juppi',
                                            distance = 1.5,
                                            bones = wheelBones[type][i],
                                            canInteract = function(entity, distance, coords, name, boneId)
                                                return #(coords - GetWorldPositionOfEntityBone(entity, boneId)) < 1.0 and not targetDisabled
                                            end,
                                            onSelect = function()
                                                if not jobs.points[i] then
                                                    targetDisabled = true; jobs.points[i] = true; jobs.done += 1
                
                                                    local progress = exports['kk-taskbar']:startAction('changing_carpart', 'Vahetad juppi...', 5000, 'fixing_a_player', 'mini@repair', {freeze = true, controls = true})
                
                                                    if progress then
                                                        if jobs.done >= count then
                                                            changing = false
                                                        end
                                                    else
                                                        jobs.points[i] = nil; jobs.done -= 1
                                                    end
            
                                                    targetDisabled = false
                                                else
                                                    TriggerEvent('KKF.UI.ShowNotification', 'error', 'See koht on juba tehtud!')
                                                end
                                            end
                                        },
                                    })
                                end
            
                                while changing do 
                                    Wait(500)
                                end
            
                                for i = 1, count do
                                    exports.ox_target:removeEntity({NetworkGetNetworkIdFromEntity(vehicle)}, {'brake_part_' .. i})
                                end
            
                                TriggerServerEvent('kk-mechanic:server:fixVehicle', NetworkGetNetworkIdFromEntity(vehicle), item)
                                taskActive = false
                            else
                                local progress = exports['kk-taskbar']:startAction('changing_carpart', 'Vahetad juppi...', 20000, 'fixing_a_player', 'mini@repair', {freeze = true, controls = true})
    
                                if progress then
                                    TriggerServerEvent('KKF.Player.RemoveItem', itemName, 1)
                                    TriggerServerEvent('kk-mechanic:server:fixVehicle', NetworkGetNetworkIdFromEntity(vehicle), item)
                                end
    
                                taskActive = false
                            end
                        else
                            taskActive = false
                            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil ei ole parandamiseks piisavalt varuosi.')
                        end
                    else
                        taskActive = false
                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Näed, et antud varuosa ei sobi sellele sõidukile!')
                    end
                else
                    taskActive = false
                    TriggerEvent('KKF.UI.ShowNotification', 'error', 'Tunned, et antud sõiduk ei vaja seda teenust!')
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

local function vehicleProblem()
    TriggerEvent('KKF.UI.ShowNotification', 'info', 'Tunnetad probleemi enda sõidukiga.')
end

local function fuelInjector(vehicle, timeout)
    SetVehicleEngineOn(vehicle, 0, 0, 1)
    SetVehicleUndriveable(vehicle, true)
    Wait(timeout)
    SetVehicleEngineOn(vehicle, 1, 0, 1)
    SetVehicleUndriveable(vehicle, false)
end

local function electronicProblem(vehicle)
    SetVehicleLights(vehicle, 2)
    StartVehicleHorn(vehicle, math.random(200, 600), 0, false)
    Wait(600)
    SetVehicleLights(vehicle, 0)
end

local function organizeTable(table)
    local returnable = {}

    for i = 1, #table do
        if table[i].health < 60 then
            returnable[#returnable + 1] = table[i]
        end
    end

    return returnable
end

RegisterNetEvent('kk-mechanic:client:degradationAction', function(networkId, degradation)
    local vehicle = NetworkGetEntityFromNetworkId(networkId)

    if #degradation > 0 then
        if GetVehicleClass(vehicle) ~= 13 and GetVehicleClass(vehicle) ~= 21 and GetVehicleClass(vehicle) ~= 16 and GetVehicleClass(vehicle) ~= 15 and GetVehicleClass(vehicle) ~= 14 then
            degradation = organizeTable(degradation)

            if #degradation > 0 then
                local randomId = math.random(1, #degradation)
                local randomItem = degradation[randomId]

                if randomItem.id == 'fuel_injector' then
                    if randomItem.health < 60 and randomItem.health > 30 then
                        vehicleProblem()
                        fuelInjector(vehicle, 600)
                    elseif randomItem.health < 30 then
                        vehicleProblem()
                        fuelInjector(vehicle, 1000)
                    end
                end

                if randomItem.id == 'radiator' then
                    local engineHealth = GetVehicleEngineHealth(vehicle)

                    if randomItem.health < 60 and randomItem.health > 30 then
                        if engineHealth <= 1000 and engineHealth >= 500 then
                            vehicleProblem()
                            SetVehicleEngineHealth(vehicle, engineHealth - 20)
                        end
                    elseif randomItem.health < 30 then
                        if engineHealth <= 1000 and engineHealth >= 200 then
                            vehicleProblem()
                            SetVehicleEngineHealth(vehicle, engineHealth - 30)
                        end
                    end
                end

                if randomItem.id == 'axle' then
                    if randomItem.health < 60 and randomItem.health > 30 then
                        vehicleProblem()

                        for i = 0, 360 do
                            Wait(10)
                            SetVehicleSteeringScale(vehicle, i)
                        end
                    elseif randomItem.health < 30 then
                        vehicleProblem()

                        for i = 0, 360 do
                            Wait(15)
                            SetVehicleSteeringScale(vehicle, i)
                        end
                    end
                end

                if randomItem.id == 'transmission' then
                    local speed = GetEntitySpeed(vehicle)
                    local chance = math.random(1, 100)

                    if randomItem.health < 60 and randomItem.health > 30 then
                        vehicleProblem()

                        for i = 0, 5 do
                            if not IsPedInVehicle(cache.ped, vehicle, false) then
                                return
                            end

                            Wait(10)
                            SetVehicleHandbrake(vehicle, true)
                            Wait(math.random(1000))
                            SetVehicleHandbrake(vehicle, false)
                        end
                    elseif randomItem.health < 30 then
                        vehicleProblem()

                        for i = 0, 11 do
                            if not IsPedInVehicle(cache.ped, vehicle, false) then
                                return
                            end

                            Wait(20)
                            SetVehicleHandbrake(vehicle, true)
                            Wait(math.random(1000))
                            SetVehicleHandbrake(vehicle, false)
                        end
                    end
                end

                if randomItem.id == 'electronics' then
                    if randomItem.health < 60 and randomItem.health > 30 then
                        vehicleProblem()

                        for i = 0, 10 do
                            Wait(100)
                            electronicProblem(vehicle)
                        end
                    elseif randomItem.health < 30 then
                        vehicleProblem()

                        for i = 0, 10 do
                            Wait(200)
                            electronicProblem(vehicle)
                        end
                    end
                end

                if randomItem.id == 'brakes' then
                    if randomItem.health < 60 and randomItem.health > 30 then
                        vehicleProblem()
                        SetVehicleHandbrake(vehicle, true)
                        Wait(4500)
                        SetVehicleHandbrake(vehicle, false)
                    elseif randomItem.health < 30 then
                        vehicleProblem()
                        SetVehicleHandbrake(vehicle, true)
                        Wait(7000)
                        SetVehicleHandbrake(vehicle, false)
                    end
                end

                if randomItem.id == 'clutch' then
                    if randomItem.health < 60 and randomItem.health > 30 then
                        vehicleProblem()
                        SetVehicleHandbrake(vehicle, true)
                        fuelInjector(vehicle, 100)

                        for i = 1, 360 do
                            SetVehicleSteeringScale(vehicle, i)
                            Wait(5)
                        end

                        Wait(5000)
                        SetVehicleHandbrake(vehicle, false)
                    elseif randomItem.health < 30 then
                        vehicleProblem()
                        SetVehicleHandbrake(vehicle, true)
                        fuelInjector(vehicle, 200)

                        for i = 1, 360 do
                            SetVehicleSteeringScale(vehicle, i)
                            Wait(5)
                        end

                        Wait(7000)
                        SetVehicleHandbrake(vehicle, false)
                    end
                end

                if randomItem.id == 'tire' then
                    if randomItem.health < 60 and randomItem.health > 30 then
                        SetVehicleTyreBurst(vehicle, 0, false, 1000.0)
                        SetVehicleTyreBurst(vehicle, 3, false, 1000.0)
                    elseif randomItem.health < 30 then
                        SetVehicleTyreBurst(vehicle, 0, false, 1000.0)
                        SetVehicleTyreBurst(vehicle, 1, false, 1000.0)
                    end
                end
            end
        end
    end
end)