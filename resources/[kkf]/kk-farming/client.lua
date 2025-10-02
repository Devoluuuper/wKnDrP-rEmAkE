local currentFarm = nil
local canInteract = false

local itemNames = {}

RegisterNetEvent('kk-farming:client:resetAccess', function(id)
    if currentFarm == id then
        canInteract = false
    end
end)

RegisterNetEvent('kk-farming:client:giveAccess', function(id)
    if currentFarm == id then
        canInteract = true
    end
end)

local farmData = {}

local currentObjects = {}
local currentTargets = {}

local function selectObjectByPercentage(transition, percentage)
    if percentage < 0 then percentage = 0 end
    if percentage > 100 then percentage = 100 end
    
    if percentage == 100 then
        return transition[#transition]
    else
        local totalItems = #transition - 1
        local index = math.ceil((percentage / 100) * totalItems)
        
        index = math.max(index, 1)
        
        return transition[index]
    end
end

CreateThread(function()
    for item, data in pairs(exports.ox_inventory:Items()) do 
        itemNames[item] = data.label
    end

    for i = 1, #cfg.farms do
        exports['kk-scripts']:requestModel(cfg.stand)
        cfg.farms[i].panel_prop = CreateObject(cfg.stand, cfg.farms[i].panel.x, cfg.farms[i].panel.y, cfg.farms[i].panel.z - 1.0, false, false)

        SetEntityHeading(cfg.farms[i].panel_prop, cfg.farms[i].panel.w - 180.0)
        SetEntityInvincible(cfg.farms[i].panel_prop, true)
        FreezeEntityPosition(cfg.farms[i].panel_prop, true)
        PlaceObjectOnGroundProperly(cfg.farms[i].panel_prop)

        exports.ox_target:addLocalEntity(cfg.farms[i].panel_prop, {
            {
                icon = 'fa-solid fa-tablet',
                label = 'Ava paneel',
                distance = 2.0,

                onSelect = function()
                    lib.callback('kk-farming:fetchFarmData', false, function(response)
                        if not response then 
                            response = {
                                isMine = false,
                                isRented = false
                            }
                        end

                        local isMine = response.isMine
                        local isRented = response.isRented
    
                        local elements = {}
    
                        if not isRented then
                            elements[#elements + 1] = {
                                icon = 'fa-solid fa-money-bill',
                                title = 'Rendi farm $' .. cfg.farmPrice .. ' eest!',
                                description = 'NB! Kehtib kuni järgmise serveri restardini.',

                                onSelect = function()
                                    TriggerServerEvent('kk-farming:server:rentFarm', i)
                                end,
                            }
                        end
    
                        if isRented and not isMine then
                            return TriggerEvent('KKF.UI.ShowNotification', 'error', 'See farm on juba kellegi poolt renditud!')
                        end
    
                        if isRented and isMine then    
                            elements[#elements + 1] = {
                                icon = 'fa-solid fa-user-plus',
                                title = 'Lisa liige',
                                description = 'Lisa kõik, keda sa tahad oma farmis tööle rakendada.',

                                onSelect = function()
                                    TriggerServerEvent('kk-farming:server:addMember', i)
                                end,
                            }

                            elements[#elements + 1] = {
                                icon = 'fa-solid fa-user-minus',
                                title = 'Eemalda liige',
                                description = 'Juhul kui keegi mäkra mängib, siis eemalda ta.',
                                serverEvent = '',

                                onSelect = function()
                                    TriggerServerEvent('kk-farming:server:removeMember', i)
                                end,
                            }
                        end
    
                        if #elements == 0 then 
                            return TriggerEvent('KKF.UI.ShowNotification', 'error', 'Sul ei ole siin midagi teha!')
                        end
    
                        lib.registerContext({
                            id = 'farm_menu',
                            title = 'Farm #' .. i,
                            options = elements
                        })
    
                        lib.showContext('farm_menu')
                    end, i)
                end,
            }
        })

        cfg.farms[i].zone = lib.zones.box({
            coords = cfg.farms[i].zone.coords,
            size = cfg.farms[i].zone.size,
            rotation = cfg.farms[i].zone.rotation,
            debug = false,

            onEnter = function()
                currentFarm = i

                canInteract = lib.callback.await('kk-farming:fetchPermission', false, i)
                farmData = lib.callback.await('kk-farming:fetchObjects', false, i)

                if farmData then
                    if cfg.farms[i].objects then
                        cfg.farms[i].objects_entities = {}
                
                        for i2 = 1, #cfg.farms[i].objects do
                            lib.requestModel(cfg.boxProp)
                            local boxEntity = CreateObject(cfg.boxProp, cfg.farms[i].objects[i2].x, cfg.farms[i].objects[i2].y, cfg.farms[i].objects[i2].z - 1.2, false, false)
                
                            SetEntityHeading(boxEntity, cfg.farms[i].objects[i2].w)
                            SetEntityInvincible(boxEntity, true)
                            FreezeEntityPosition(boxEntity, true)

                            cfg.farms[i].objects_entities[#cfg.farms[i].objects_entities + 1] = boxEntity

                            currentTargets[#currentTargets + 1] = exports.ox_target:addBoxZone({
                                coords = vec3(cfg.farms[i].objects[i2].x, cfg.farms[i].objects[i2].y, cfg.farms[i].objects[i2].z - 1),
                                size = vec3(0.7, 0.7, math.abs(cfg.farms[i].objects[i2].z - cfg.farms[i].objects[i2].z + 1.5)),
                                rotation = 0,
                                debug = false,
                                options = {
                                    {
                                        icon = 'fa-solid fa-plant-wilt',
                                        label = 'Hoolda taime',
                                        canInteract = function(entity, distance, coords, name, bone)
                                            return not exports['kk-taskbar']:canInteract() and canInteract
                                        end,
                                        onSelect = function(data)
                                            lib.callback('kk-farming:fetchPlant', false, function(response)
                                                local elements = {}
            
                                                if response then
                                                    if response.progress >= 100 then
                                                        elements[#elements + 1] = {
                                                            title = 'Korja saak',
                                                            icon = 'fa-solid fa-hand',
                                                            event = 'kk-farming:client:recievePlants',
                                                            description = 'Vajuta siia, et korjata saaki.',
                                                            args = {id = i2, farm = i}
                                                        }
                                                    end
                                        
                                                    if response.item == 'none' then
                                                        elements[#elements + 1] = {
                                                            title = 'Istuta taim',
                                                            icon = 'fa-solid fa-hand',
                                                            description = 'Vajuta siia, et istutada taim potti.',
                                                            event = 'kk-farming:client:plantSeed',
                                                            args = {id = i2, farm = i}
                                                        }
                                                    else
                                                        -- if exports.ox_inventory:Search('count', cfg.wateritem) > 0 and response.water == 0 and response.progress < 100 then
                                                        --     elements[#elements + 1] = {
                                                        --         title = 'Kasta taime - ' .. response.water .. '%',
                                                        --         icon = 'fa-solid fa-bottle-water',
                                                        --         colorScheme = 'blue',
                                                        --         iconColor = '#0ea5e9',
                                                        --         progress = response.water,

                                                        --         description = 'Vajuta siia, et kasta taime.',
                                                        --         event = 'kk-farming:client:waterPlant',
                                                        --         args = {id = i2, farm = i}
                                                        --     }
                                                        -- end
                                                
                                                        -- if exports.ox_inventory:Search('count', cfg.fertilizeritem) > 0 and response.fertilizer == 0 and response.progress < 100 then
                                                        --     elements[#elements + 1] = {
                                                        --         title = 'Väeta taime - ' .. response.fertilizer .. '%',
                                                        --         icon = 'fa-solid fa-plant-wilt',
                                                        --         colorScheme = 'green',
                                                        --         iconColor = '#eab308',
                                                        --         progress = response.fertilizer,

                                                        --         description = 'Vajuta siia, et väetada taime.',
                                                        --         event = 'kk-farming:client:fertilizePlant',
                                                        --         args = {id = i2, farm = i}
                                                        --     }
                                                        -- end

                                                        elements[#elements + 1] = {
                                                            title = 'Kasta taime - ' .. response.water .. '%',
                                                            icon = 'fa-solid fa-bottle-water',
                                                            iconColor = '#0ea5e9',
                                                            progress = response.water,
                                                            colorScheme = 'blue',
                                                            disabled = response.progress >= 100 or response.water > 100 - cfg.addwater or exports.ox_inventory:GetItemCount(cfg.wateritem) == 0,

                                                            description = 'Vajuta siia, et kasta taime.',
                                                            event = 'kk-farming:client:waterPlant',
                                                            args = { id = i2, farm = i }
                                                        }


                                                        elements[#elements + 1] = {
                                                            title = 'Väeta taime - ' .. response.fertilizer .. '%',
                                                            icon = 'fa-solid fa-plant-wilt',
                                                            iconColor = '#eab308',
                                                            progress = response.fertilizer,
                                                            colorScheme = 'green',
                                                            disabled = response.progress >= 100 or response.fertilizer > 100 - cfg.addfertilizer or exports.ox_inventory:GetItemCount(cfg.fertilizeritem) == 0,

                                                            description = 'Vajuta siia, et väetada taime.',
                                                            event = 'kk-farming:client:fertilizePlant',
                                                            args = { id = i2, farm = i }
                                                        }

                                                    end
                                                
                                                    lib.registerContext({
                                                        id = 'plant_menu',
                                                        title = 'Taimehooldus - ' .. response.progress .. '%',
                                                        options = elements
                                                    })
                                                
                                                    lib.showContext('plant_menu')
                                                else
                                                    TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil pole piisavalt õigusi!')
                                                end
                                            end, i, i2)
                                        end,
                                        
                                        distance = 2.0
                                    }
                                }
                            })

                            local itemData = farmData[i2]

                            if itemData and cfg.plantList[itemData.item] then
                                local coords = GetEntityCoords(boxEntity)
                                local model = selectObjectByPercentage(cfg.plantList[itemData.item].transission, itemData.progress)

                                lib.requestModel(joaat(model))
                                local entity = CreateObject(joaat(model), coords.x, coords.y, coords.z + 0.3, false, false)
                    
                                SetEntityInvincible(entity, true)
                                FreezeEntityPosition(entity, true)

                                currentObjects[i2] = entity
                            end
                        end
                    end
                end
            end,
            
            onExit = function()
                currentFarm = nil
                canInteract = false

                if cfg.farms[i].objects_entities then
                    for i2 = 1, #cfg.farms[i].objects_entities do
                        DeleteEntity(cfg.farms[i].objects_entities[i2])
                    end
            
                    cfg.farms[i].objects_entities = nil
                end

                if currentTargets then
                    for k,v in pairs(currentTargets) do
                        exports.ox_target:removeZone(v)
                    end

                    currentTargets = {}
                end

                if currentObjects then
                    for k,v in pairs(currentObjects) do
                        DeleteEntity(v)
                    end
    
                    currentObjects = {}
                end
            end
        })
    end
end)

RegisterNetEvent('kk-farming:client:recievePlants', function(data)
	if cache.vehicle then return end

    local progress = exports['kk-taskbar']:startAction('recievePlants', 'Korjad saaki', 2000, 'plant_floor', 'weapons@first_person@aim_rng@generic@projectile@thermal_charge@', {freeze = true, controls = true})

    if progress then
        TriggerServerEvent('kk-farming:server:recievePlants', data)
    end
end)

RegisterNetEvent('kk-farming:client:reloadObject', function(farm, plant)
    if currentFarm == farm then
        local currentObject = currentObjects[plant]
        
        if not currentObject then
            currentObjects[plant] = 0
        end
        
        local model = GetEntityModel(currentObject)
        local itemData = lib.callback.await('kk-farming:fetchPlant', false, farm, plant)

        if itemData then
            if itemData.item == 'none' then
                if DoesEntityExist(currentObject) then
                    DeleteEntity(currentObject)
                end
            else
                if cfg.plantList[itemData.item] then
                    local newModel = selectObjectByPercentage(cfg.plantList[itemData.item].transission, itemData.progress)
        
                    if newModel ~= model then
                        if DoesEntityExist(currentObject) then
                            DeleteEntity(currentObject)
                        end
        
                        lib.requestModel(joaat(newModel))
                        local entity = CreateObject(joaat(newModel), cfg.farms[farm].objects[plant].x, cfg.farms[farm].objects[plant].y, cfg.farms[farm].objects[plant].z - 1.0, false, false)
            
                        SetEntityHeading(entity, cfg.farms[farm].objects[plant].w)
                        PlaceObjectOnGroundProperly(entity)
                        SetEntityInvincible(entity, true)
                        FreezeEntityPosition(entity, true)
            
                        currentObjects[plant] = entity
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('kk-farming:client:placeSeed', function(data)
	if cache.vehicle then return end

    local progress = exports['kk-taskbar']:startAction('plant', 'Istutad taime', 2000, 'plant_floor', 'weapons@first_person@aim_rng@generic@projectile@thermal_charge@', {freeze = true, controls = true})

    if progress then
        TriggerServerEvent('kk-farming:server:placeSeed', data)
    end
end)

RegisterNetEvent('kk-farming:client:fertilizePlant', function(data)
	if cache.vehicle then return end

    local progress = exports['kk-taskbar']:startAction('fertilizePlant', 'Väetad taime', 2000, 'plant_floor', 'weapons@first_person@aim_rng@generic@projectile@thermal_charge@', {freeze = true, controls = true})

    if progress then
        TriggerServerEvent('kk-farming:server:fertilizePlant', data)
    end
end)

RegisterNetEvent('kk-farming:client:waterPlant', function(data)
	if cache.vehicle then return end

    local progress = exports['kk-taskbar']:startAction('waterPlant', 'Kastad', 2000, 'plant_floor', 'weapons@first_person@aim_rng@generic@projectile@thermal_charge@', {freeze = true, controls = true})

    if progress then
        TriggerServerEvent('kk-farming:server:waterPlant', data)
    end
end)

RegisterNetEvent('kk-farming:client:plantSeed', function(data)
	if cache.vehicle then return end

    local elements = {}

    for k,v in pairs(cfg.plantList) do
        if exports.ox_inventory:Search('count', k) > 0 then
            elements[#elements + 1] = {
                title = itemNames[k] or 'N/A',
                event = 'kk-farming:client:placeSeed',
                args = {item = k, farm = data.farm, id = data.id}
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

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for i = 1, #cfg.farms do
            if DoesEntityExist(cfg.farms[i].panel_prop) then
                DeleteEntity(cfg.farms[i].panel_prop)
            end

            if cfg.farms[i].objects_entities then
                for i2 = 1, #cfg.farms[i].objects_entities do
                    DeleteEntity(cfg.farms[i].objects_entities[i2])
                end
        
                cfg.farms[i].objects_entities = nil
            end

            if currentTargets then
                for k,v in pairs(currentTargets) do
                    exports.ox_target:removeZone(v)
                end

                currentTargets = {}
            end

            if currentObjects then
                for k,v in pairs(currentObjects) do
                    DeleteEntity(v)
                end

                currentObjects = {}
            end
        end
    end
end)

RegisterNetEvent('kk-farming:client:addMemberMenu', function(id)
    local options = {}
	local players = lib.getNearbyPlayers(GetEntityCoords(cache.ped), 10.0, false)

    if #players == 0 then
        return TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ühtegi mängijat ei ole läheduses!')
    end

	for i = 1, #players do
        local serverId = GetPlayerServerId(players[i].id) 
		options[#options + 1] = { value = serverId, label = 'Mängija #' .. serverId}
	end

    local input = lib.inputDialog('Liikme lisamine', {
        {   
            icon = 'fa-solid fa-user',
            label = 'Vali mängija', 
            type = 'select', 
            required = true, 
            options = options
        }
    })

    if not input then return end

    TriggerServerEvent('kk-farming:server:addMemberConfirm', id, input[1])
end)

RegisterNetEvent('kk-farming:client:removeMemberMenu', function(id, members)
    local options = {}

    if #members == 0 then
        return TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teie farmil ei ole mitte ühtegi liiget!')
    end

	for i = 1, #members do
		options[#options + 1] = { value = members[i].identifier, label = members[i].name }
	end

    local input = lib.inputDialog('Liikme eemaldamine', {
        {   
            icon = 'fa-solid fa-user',
            label = 'Vali liige', 
            type = 'select', 
            required = true, 
            options = options
        }
    })

    if not input then return end

    TriggerServerEvent('kk-farming:server:removeMemberConfirm', id, input[1])
end)