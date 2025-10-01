local function generatePot(playerCoords)
    return {position = playerCoords, type = 'none', health = {fertilizer = 0, water = 0, progress = 0}}
end

function GetPlayerCoords(player)
    local ped = GetPlayerPed(player)
    if ped ~= 0 then
        local coords = GetEntityCoords(ped)
        return coords
    else
        return nil
    end
end


RegisterServerEvent('kk-drugs:server:plantPot', function()
    local player = source
    local playerCoords = GetEntityCoords(GetPlayerPed(player))
    
    -- Create a new vector value with the modified Z coordinate
    local newZ = playerCoords.z - 1
    local newPlayerCoords = vector3(playerCoords.x, playerCoords.y, newZ)
    
    local newPlant = generatePot(newPlayerCoords)

    MySQL.Async.execute('INSERT INTO user_plants (data) VALUES (@data)', {
        ['@data'] = json.encode(newPlant)
    }, function(rowsInserted)
        if rowsInserted > 0 then
            MySQL.Async.fetchAll('SELECT id, data FROM user_plants ORDER BY id DESC LIMIT 1', {}, function(newData)
                if newData and #newData > 0 then
                    local newRow = newData[1]
                    local newId = newRow.id
                    local rowData = json.decode(newRow.data)
                    rowData.id = newId
                    TriggerClientEvent('kk-drugs:client:plantPot', player, rowData)
                else
                    -- print("Failed to retrieve new plant data.")
                end
            end)
        end
    end)
end)



lib.callback.register('kk-drugs:getPlants', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local returnable = {}

    if xPlayer then
        MySQL.Async.fetchAll('SELECT id, data FROM user_plants', {}, function(data)
            if data then
                for _, row in ipairs(data) do
                    local rowData = json.decode(row.data)
                    rowData.id = row.id
                    returnable[row.id] = rowData  -- Use id as key instead of inserting into an array
                end
            end
        end)
    end

    while not next(returnable) do
        Wait(50)
    end

    -- print("Returning plants data:", json.encode(returnable))  -- Printing returnable
    return returnable
end)



lib.callback.register('kk-drugs:requestPlantInfo', function(source, id)
    local xPlayer = ESX.GetPlayerFromId(source)
    local returnable = nil

    if xPlayer then
        MySQL.Async.fetchAll('SELECT data FROM user_plants WHERE id = ?', {id}, function(result)
            if result and #result > 0 then
                local data = json.decode(result[1].data)
                returnable = data
            else
                returnable = false
            end
        end)
    else
        returnable = false
    end

    while returnable == nil do
        Wait(50)
    end
    return returnable
end)


RegisterNetEvent('kk-drugs:server:placeSeed', function(data)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        MySQL.Async.fetchAll('SELECT data FROM user_plants WHERE id = ?', {data.id}, function(result)
            if result[1] then
                
                local currentData = json.decode(result[1].data)
                currentData.type = data.item

                -- xPlayer.removeInventoryItem(data.item, 1)
                exports.ox_inventory:RemoveItem(xPlayer.source, data.item, 1, nil)
                exports.ox_inventory:RemoveItem(xPlayer.source, cfg.potitem, 1, nil)

                MySQL.Async.execute('UPDATE user_plants SET data = ? WHERE id = ?', {json.encode(currentData), data.id}, function()
                    TriggerClientEvent('kk-drugs:client:addPlant', xPlayer.source, data.id, data.item)
                end)
            else
            end
        end)
    else
    end
end)

RegisterNetEvent('kk-drugs:server:deletePlant', function(id)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        -- print("Deleting plant with id: " .. id)

        MySQL.Async.execute('DELETE FROM user_plants WHERE id = ?', {id}, function()
            TriggerClientEvent('kk-drugs:client:removePlant', -1, id)
        end)
    end
end)






RegisterNetEvent('kk-drugs:server:waterPlant', function(args)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        MySQL.Async.fetchAll('SELECT data FROM user_plants WHERE id = ?', {args.id}, function(result)
            if result[1] then
                local currentData = json.decode(result[1].data)

                if currentData.health.water < 100 then
                    currentData.health.water += cfg.addwater
                    -- xPlayer.removeInventoryItem(cfg.wateritem, 1)
                    exports.ox_inventory:RemoveItem(xPlayer.source, cfg.wateritem, 1, nil)

                    MySQL.Sync.execute('UPDATE user_plants SET data = ? WHERE id = ?', {json.encode(currentData), args.id})
                else
                    -- TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'See taim ei vaja rohekem vett!')
                    cfg.ServerNotification(xPlayer.source,cfg.messgaes.max_water, 'error')
                end
            end
        end)
    end
end)


RegisterNetEvent('kk-drugs:server:fertilizePlant', function(args)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        MySQL.Async.fetchAll('SELECT data FROM user_plants WHERE id = ?', {args.id}, function(result)
            if result[1] then
                local currentData = json.decode(result[1].data)

                if currentData.health.fertilizer < 100 then
                    currentData.health.fertilizer += cfg.addfertilizer
                    -- xPlayer.removeInventoryItem(cfg.fertilizer, 1) 
                    exports.ox_inventory:RemoveItem(xPlayer.source, cfg.fertilizer, 1, nil)

                    MySQL.Sync.execute('UPDATE user_plants SET data = ? WHERE id = ?', {json.encode(currentData), args.id})
                else
                    -- TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Seda taime ei ole vaja rohkem väetada!')
                    cfg.ServerNotification(xPlayer.source,cfg.messgaes.max_fertilizer, 'error')
                end
            end
        end)
    end
end)


RegisterNetEvent('kk-drugs:server:recievePlants', function(args)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        MySQL.Async.fetchAll('SELECT data FROM user_plants WHERE id = ?', {args.id}, function(result)
            if result[1] then
                local currentData = json.decode(result[1].data)
                local plantType = currentData.type
                local plantConfig = cfg.plantsList[plantType]

                if plantConfig then
                    local getItem = plantConfig.item
                    local amount = math.random(plantConfig.min, plantConfig.max)

                    if getItem then
                        -- xPlayer.addInventoryItem(getItem, amount)
                        exports.ox_inventory:AddItem(xPlayer.source, getItem, amount)
                    end
                end

                MySQL.Async.execute('DELETE FROM user_plants WHERE id = ?', {args.id}, function()
                    TriggerClientEvent('kk-drugs:client:removePlant', -1, args.id)
                end)
            end
        end)
    end
end)

local function canDry(source, name)
    local xPlayer = ESX.GetPlayerFromId(source)
    local retval = true

    for k,v in pairs(cfg.dryerTasks[name].needs) do
        if not xPlayer.hasItem(v) then
            retval = false
        end
    end

    return retval
end 

RegisterNetEvent('kk-drugs:server:dryAction', function(args)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        if canDry(xPlayer.source, args.item) then
            local currentItem = cfg.dryerTasks[args.item]

            if xPlayer.canCarryItem(args.item, 1) then 
                for k,v in pairs(currentItem.needs) do
                    -- xPlayer.removeInventoryItem(v, 1)
                    exports.ox_inventory:RemoveItem(xPlayer.source, v, 1, nil)
                end

                -- xPlayer.addInventoryItem(args.item, 1)
                exports.ox_inventory:AddItem(xPlayer.source, args.item, 1)
            else
                -- TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Teie taskud on liiga täis!')
                cfg.ServerNotification(xPlayer.PlayerData.source,cfg.messgaes.dryer_inv_full, 'error')
                if cfg.dropToGroundIfFull then
                    exports.ox_inventory:RemoveItem(xPlayer.source, v, 1, nil)
                    exports.ox_inventory:CustomDrop(cfg.messgaes.customdrop .. math.random(00000, 99999), {
                        {args.item, 1}
                    }, GetEntityCoords(GetPlayerPed(source)))
                end
            end
        end
    end
end)


SetInterval(function()
    local results = MySQL.Sync.fetchAll('SELECT id, data FROM user_plants')

    for i = 1, #results do
        local currentData = json.decode(results[i].data)

        local itemType = currentData['type']
        if currentData['health'] then
            local plantType = cfg.plantsList[itemType]

            if plantType then
                if currentData['health'].water and currentData['health'].water > 0 then
                    currentData['health'].water = math.max(0, currentData['health'].water - plantType.consumption.water)
                    currentData['health'].progress = math.min(100, currentData['health'].progress + plantType.health)
                    -- print(('Plant %d: Water level decreased to %d, Progress increased to %d'):format(results[i].id, math.floor(currentData['health'].water or 0), math.floor(currentData['health'].progress or 0)))
                end
                if currentData['health'].fertilizer and currentData['health'].fertilizer > 0 then
                    currentData['health'].fertilizer = math.max(0, currentData['health'].fertilizer - plantType.consumption.fertilizer)
                    currentData['health'].progress = math.min(100, currentData['health'].progress + plantType.health)
                    -- print(('Plant %d: Fertilizer level decreased to %d, Progress increased to %d'):format(results[i].id, math.floor(currentData['health'].fertilizer or 0), math.floor(currentData['health'].progress or 0)))
                end
            end
        end
        MySQL.Sync.execute('UPDATE user_plants SET data = ? WHERE id = ?', { json.encode(currentData), results[i].id })
    end
end,  cfg.updateinterval * 60000)