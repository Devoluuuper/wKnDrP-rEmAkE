local labs = {}
local drugLab = vec3(1066.3912353516, -3183.4152832031, -39.1640625)
local currentUsers = {}
local locations = {
    --Rida1-
    vec3(1064.85, -3206.85, -40.24),
    vec3(1064.83, -3205.2, -40.24),
    vec3(1064.81, -3203.55, -40.24),
    vec3(1064.79, -3201.9, -40.24),
    vec3(1064.77, -3200.25, -40.24),
    vec3(1064.75, -3198.6, -40.24),
    vec3(1064.73, -3196.95, -40.24),
    vec3(1064.71, -3195.3, -40.24),
    vec3(1064.69, -3193.65, -40.24),
    vec3(1064.67, -3192, -40.24),
    vec3(1064.65, -3190.35, -40.24),
    vec3(1064.63, -3188.7, -40.24),
    vec3(1064.61, -3187.05, -40.24),
    --rida2
    vec3(1063.2, -3206.85, -40.24),
    vec3(1063.2, -3205.2, -40.24),
    vec3(1063.2, -3203.55, -40.24),
    vec3(1063.2, -3201.9, -40.24),
    vec3(1063.2, -3200.25, -40.24),
    vec3(1063.2, -3198.6, -40.24),
    vec3(1063.2, -3196.95, -40.24),
    vec3(1063.2, -3195.3, -40.24),
    vec3(1063.2, -3193.65, -40.24),
    vec3(1063.2, -3192, -40.24),
    vec3(1063.2, -3190.35, -40.24),
    vec3(1063.2, -3188.7, -40.24),
    vec3(1063.2, -3187.05, -40.24),
    --Rida3
    vec3(1061.55, -3206.85, -40.24),
    vec3(1061.55, -3205.2, -40.24),
    vec3(1061.55, -3203.55, -40.24),
    vec3(1061.55, -3201.9, -40.24),
    vec3(1061.55, -3200.25, -40.24),
    vec3(1061.55, -3198.6, -40.24),
    vec3(1061.55, -3196.95, -40.24),
    vec3(1061.55, -3195.3, -40.24),
    vec3(1061.55, -3193.65, -40.24),
    vec3(1061.55, -3192, -40.24),
    vec3(1061.55, -3190.35, -40.24),
    vec3(1061.55, -3188.7, -40.24),
    vec3(1061.55, -3187.05, -40.24),
    --rida4
    vec3(1059.9, -3206.85, -40.24),
    vec3(1059.9, -3205.2, -40.24),
    vec3(1059.9, -3203.55, -40.24),
    vec3(1059.9, -3201.9, -40.24),
    vec3(1059.9, -3200.25, -40.24),
    vec3(1059.9, -3198.6, -40.24),
    vec3(1059.9, -3196.95, -40.24),
    vec3(1059.9, -3195.3, -40.24),
    vec3(1059.9, -3193.65, -40.24),
    vec3(1059.9, -3192, -40.24),
    vec3(1059.9, -3190.35, -40.24),
    vec3(1059.9, -3188.7, -40.24),
    vec3(1059.9, -3187.05, -40.24),
    --Rida5
    vec3(1058.25, -3206.85, -40.24),
    vec3(1058.25, -3205.2, -40.24),
    vec3(1058.25, -3203.55, -40.24),
    vec3(1058.25, -3201.9, -40.24),
    vec3(1058.25, -3200.25, -40.24),
    vec3(1058.25, -3198.6, -40.24),
    vec3(1058.25, -3196.95, -40.24),
    vec3(1058.25, -3195.3, -40.24),
    vec3(1058.25, -3193.65, -40.24),
    vec3(1058.25, -3192, -40.24),
    vec3(1058.25, -3190.35, -40.24),
    vec3(1058.25, -3188.7, -40.24),
    vec3(1058.25, -3187.05, -40.24),
    --Rida6
    vec3(1056.6, -3206.85, -40.24),
    vec3(1056.6, -3205.2, -40.24),
    vec3(1056.6, -3203.55, -40.24),
    vec3(1056.6, -3201.9, -40.24),
    vec3(1056.6, -3200.25, -40.24),
    vec3(1056.6, -3198.6, -40.24),
    vec3(1056.6, -3196.95, -40.24),
    vec3(1056.6, -3195.3, -40.24),
    vec3(1056.6, -3193.65, -40.24),
    vec3(1056.6, -3192, -40.24),
    vec3(1056.6, -3190.35, -40.24),
    vec3(1056.6, -3188.7, -40.24),
    vec3(1056.6, -3187.05, -40.24),
    --Rida7
    vec3(1054.95, -3206.85, -40.24),
    vec3(1054.95, -3205.2, -40.24),
    vec3(1054.95, -3203.55, -40.24),
    vec3(1054.95, -3201.9, -40.24),
    vec3(1054.95, -3200.25, -40.24),
    vec3(1054.95, -3198.6, -40.24),
    vec3(1054.95, -3196.95, -40.24),
    vec3(1054.95, -3195.3, -40.24),
    vec3(1054.95, -3193.65, -40.24),
    vec3(1054.95, -3192, -40.24),
    vec3(1054.95, -3190.35, -40.24),
    vec3(1054.95, -3188.7, -40.24),
    vec3(1054.95, -3187.05, -40.24),
    --rida8
    vec3(1053.3, -3206.85, -40.24),
    vec3(1053.3, -3205.2, -40.24),
    vec3(1053.3, -3203.55, -40.24),
    vec3(1053.3, -3201.9, -40.24),
    vec3(1053.3, -3200.25, -40.24),
    vec3(1053.3, -3198.6, -40.24),
    vec3(1053.3, -3196.95, -40.24),
    vec3(1053.3, -3195.3, -40.24),
    vec3(1053.3, -3193.65, -40.24),
    vec3(1053.3, -3192, -40.24),
    vec3(1053.3, -3190.35, -40.24),
    vec3(1053.3, -3188.7, -40.24),
    vec3(1053.3, -3187.05, -40.24),
    --Rida9
    vec3(1051.65, -3206.85, -40.24),
    vec3(1051.65, -3205.2, -40.24),
    vec3(1051.65, -3203.55, -40.24),
    vec3(1051.65, -3201.9, -40.24),
    vec3(1051.65, -3200.25, -40.24),
    vec3(1051.65, -3198.6, -40.24),
    vec3(1051.65, -3196.95, -40.24),
    vec3(1051.65, -3195.3, -40.24),
    vec3(1051.65, -3193.65, -40.24),
    vec3(1051.65, -3192, -40.24),
    vec3(1051.65, -3190.35, -40.24),
    vec3(1051.65, -3188.7, -40.24),
    vec3(1051.65, -3187.05, -40.24),
    --Rida10
    vec3(1050, -3206.85, -40.24),
    vec3(1050, -3205.2, -40.24),
    vec3(1050, -3203.55, -40.24),
    vec3(1050, -3201.9, -40.24),
    vec3(1050, -3200.25, -40.24),
    vec3(1050, -3198.6, -40.24),
    vec3(1050, -3196.95, -40.24),
    vec3(1050, -3195.3, -40.24),
    vec3(1050, -3193.65, -40.24),
    vec3(1050, -3192, -40.24),
    vec3(1050, -3190.35, -40.24),
    vec3(1050, -3188.7, -40.24),
    vec3(1050, -3187.05, -40.24)
}

local tableLocations = {
    vec4(1043.37, -3208.0, -39.16, 180.86),
    vec4(1041.01, -3208.0, -39.16, 180.86),
    vec4(1038.65, -3208.0, -39.16, 180.86),
    vec4(1036.29, -3208.0, -39.16, 180.86),
    vec4(1033.93, -3208.0, -39.16, 180.86),
    vec4(1031.57, -3208.0, -39.16, 180.86),
}

local function generatePot(currentPots)
    return {pos = locations[currentPots + 1], prop = 'none', health = {fertilizer = 0, water = 0, progress = 0}}
end

local function generateTable(currentTables, item)
    return {pos = tableLocations[currentTables + 1], prop = item}
end

local shop = {
    ['pot'] = {
        label = 'Pott',
        price = 200,
        picture = 'img/pot.png',
    },

    ['tobacco_plant'] = {
        label = 'Tubakataim',
        price = 300,
        picture = 'img/tobacco_plant.png',
    },

    -- ['weed_plant'] = { -- kasvatame maas
    --     label = 'Kanepitaim',
    --     price = 300,
    --     picture = 'img/weed_plant.png',
    -- },

    ['coke_plant'] = {
        label = 'Kokataim',
        price = 300,
        picture = 'img/coke_plant.png',
    },

    ['v_ret_ml_tablea'] = {
        type = 'table',
        label = 'Kuumutamislaud',
        price = 0,
        picture = 'img/v_ret_ml_tablea.png',
    },

    ['v_ret_fh_dryer'] = {
        type = 'table',
        label = 'Kuivati',
        price = 0,
        picture = 'img/v_ret_fh_dryer.png',
    },

    ['prop_wooden_barrel'] = {
        type = 'table',
        label = 'Kääritamislaud',
        price = 0,
        picture = 'img/prop_wooden_barrel.png',
    },

    ['bkr_prop_coke_press_01aa'] = {
        type = 'table',
        label = 'Press/Pakendaja',
        price = 0,
        picture = 'img/bkr_prop_coke_press_01aa.png',
    },

    ['prop_cementmixer_02a'] = {
        type = 'table',
        label = 'Mixer',
        price = 0,
        picture = 'img/prop_cementmixer_02a.png',
    },

    ['prop_cementmixer_01a'] = {
        type = 'table',
        label = 'Purusti',
        price = 0,
        picture = 'img/prop_cementmixer_01a.png',
    }
} 

RegisterNetEvent('kk-druglabs:server:delete', function(args)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        MySQL.Async.fetchAll('SELECT owner, data FROM user_labs WHERE id = ?', {args.currentLab}, function(result)
            if result[1] then
                local currentData = json.decode(result[1].data)
                currentData.plants[args.currentPlant].prop = 'none'
                currentData.plants[args.currentPlant].health = {fertilizer = 0, water = 0, progress = 0}

                MySQL.Async.execute('UPDATE user_labs SET data = ? WHERE id = ?', {json.encode(currentData), args.currentLab}, function()
                    for k,v in pairs(currentUsers) do
                        if v == args.currentLab then
                            TriggerClientEvent('kk-druglabs:client:removePlant', ESX.GetPlayerFromIdentifier(k).source, args.currentPlant)
                        end
                    end
                end)
            end
        end)
    end
end)

RegisterNetEvent('kk-druglabs:server:waterPlant', function(args)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        MySQL.Async.fetchAll('SELECT owner, data FROM user_labs WHERE id = ?', {args.currentLab}, function(result)
            if result[1] then
                local currentData = json.decode(result[1].data)

                if currentData.plants[args.currentPlant].health.water < 100 then
                    currentData.plants[args.currentPlant].health.water += 25
                    xPlayer.removeInventoryItem('water', 1) 

                    MySQL.Sync.execute('UPDATE user_labs SET data = ? WHERE id = ?', {json.encode(currentData), args.currentLab})
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Seda taime ei ole vaja rohkem kasta!')
                end
            end
        end)
    end
end)

RegisterNetEvent('kk-druglabs:server:fertilizePlant', function(args)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        MySQL.Async.fetchAll('SELECT owner, data FROM user_labs WHERE id = ?', {args.currentLab}, function(result)
            if result[1] then
                local currentData = json.decode(result[1].data)

                if currentData.plants[args.currentPlant].health.fertilizer < 100 then
                    currentData.plants[args.currentPlant].health.fertilizer += 25
                    xPlayer.removeInventoryItem('fertilizer', 1) 

                    MySQL.Sync.execute('UPDATE user_labs SET data = ? WHERE id = ?', {json.encode(currentData), args.currentLab})
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Seda taime ei ole vaja rohkem väetada!')
                end
            end
        end)
    end
end)

local plantsList = {
    ['prop_agave_02'] = 'wet_tobaccoleaf',
    ['prop_weed_01'] = 'wet_weed',
    ['h4_prop_bush_cocaplant_01'] = 'coca_leaf'
}

RegisterNetEvent('kk-druglabs:server:recievePlants', function(args)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        MySQL.Async.fetchAll('SELECT owner, data FROM user_labs WHERE id = ?', {args.currentLab}, function(result)
            if result[1] then
                local currentData = json.decode(result[1].data)
                local getItem = plantsList[currentData.plants[args.currentPlant].prop]
                
                if getItem then
                    xPlayer.addInventoryItem(getItem, math.random(1,2))
                end

                currentData.plants[args.currentPlant].prop = 'none'
                currentData.plants[args.currentPlant].health = {fertilizer = 0, water = 0, progress = 0}

                MySQL.Async.execute('UPDATE user_labs SET data = ? WHERE id = ?', {json.encode(currentData), args.currentLab}, function()
                    for k,v in pairs(currentUsers) do
                        if v == args.currentLab then
                            TriggerClientEvent('kk-druglabs:client:removePlant', ESX.GetPlayerFromIdentifier(k).source, args.currentPlant)
                        end
                    end
                end)
            end
        end)
    end
end)

RegisterNetEvent('kk-druglabs:server:plant', function(args)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        MySQL.Async.fetchAll('SELECT owner, data FROM user_labs WHERE id = ?', {args.currentLab}, function(result)
            if result[1] then
                local currentData = json.decode(result[1].data)
                currentData.plants[args.currentPlant].prop = args.plantData.prop

                xPlayer.removeInventoryItem(args.plantName, 1)

                MySQL.Async.execute('UPDATE user_labs SET data = ? WHERE id = ?', {json.encode(currentData), args.currentLab}, function()
                    for k,v in pairs(currentUsers) do
                        if v == args.currentLab then
                            TriggerClientEvent('kk-druglabs:client:addPlant', ESX.GetPlayerFromIdentifier(k).source, args.currentPlant, currentData.plants[args.currentPlant])
                        end
                    end
                end)
            end
        end)
    end
end)

lib.callback.register('kk-druglabs:buyItem', function(source, currentLab, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local returnable = nil

    if xPlayer then
        MySQL.Async.fetchAll('SELECT owner, data FROM user_labs WHERE id = ?', {currentLab}, function(result)
            if result[1] then
                local currentData = json.decode(result[1].data)

                if tonumber(result[1].owner) == xPlayer.identifier then
                    if item == 'pot' then
                        if #currentData.plants < #locations then
                            if xPlayer.getMoney() >= shop[item].price then
                                TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'success', 'Soetasite ühe poti!')

                                local newPlant = generatePot(#currentData.plants)
                                currentData.plants[#currentData.plants + 1] = newPlant
                                MySQL.Async.execute('UPDATE user_labs SET data = ? WHERE id = ?', {json.encode(currentData), currentLab}, function()
                                    for k,v in pairs(currentUsers) do
                                        if v == currentLab then
                                            TriggerClientEvent('kk-druglabs:client:unloadPlants', ESX.GetPlayerFromIdentifier(k).source)
        
                                            SetTimeout(750, function()
                                                TriggerClientEvent('kk-druglabs:client:loadPlants', ESX.GetPlayerFromIdentifier(k).source, currentData)
                                            end)
                                        end
                                    end
        
                                    returnable = true
                                end)
                            else
                                TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Teil ei ole piisavalt raha!')
                                returnable = false
                            end
                        else
                            TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Te ei saa rohkem potte osta!')
                            returnable = false
                        end
                    elseif item == 'tobacco_plant' or item == 'weed_plant' or item == 'coke_plant' then
                        if xPlayer.getMoney() >= shop[item].price then
                            if xPlayer.canCarryItem(item, 1) then
                                xPlayer.addInventoryItem(item, 1)

                                returnable = true
                            else
                                TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Teie taskud on liiga täis!')
                                returnable = false
                            end
                        else
                            TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Teil ei ole piisavalt raha!')
                            returnable = false
                        end
                    else
                        if shop[item].type == 'table' then
                            if #currentData.tables < #tableLocations then
                                local canBuy = function(item)
                                    for k,v in pairs(currentData.tables) do
                                        if v.prop == item then
                                            return false
                                        end
                                    end

                                    return true
                                end

                                if canBuy(item) then
                                    if xPlayer.getMoney() >= shop[item].price then
                                        TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'success', 'Soetasite ' .. shop[item].label .. '!')
            
                                        local newTable = generateTable(#currentData.tables, item)
                                        currentData.tables[#currentData.tables + 1] = newTable

                                        MySQL.Async.execute('UPDATE user_labs SET data = ? WHERE id = ?', {json.encode(currentData), currentLab}, function()
                                            for k,v in pairs(currentUsers) do
                                                if v == currentLab then
                                                    TriggerClientEvent('kk-druglabs:client:unloadPlants', ESX.GetPlayerFromIdentifier(k).source)
                
                                                    SetTimeout(750, function()
                                                        TriggerClientEvent('kk-druglabs:client:loadPlants', ESX.GetPlayerFromIdentifier(k).source, currentData)
                                                    end)
                                                end
                                            end
                
                                            returnable = true
                                        end)
                                    else
                                        TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Teil ei ole piisavalt raha!')
                                        returnable = false
                                    end
                                else
                                    TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Te ei saa rohkem seda eset osta!')
                                    returnable = false
                                end
                            else
                                TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Te ei saa rohkem laudu osta!')
                                returnable = false
                            end
                        else
                            returnable = false
                        end
                    end
                else
                    returnable = false
                end
            else
                returnable = false
            end
        end)
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

local function loadLabs()
    MySQL.Async.fetchAll('SELECT id, enter FROM user_labs', {}, function(result)
        for k,v in pairs(result) do
            local data = {
                id = v.id,
                enter = json.decode(v.enter)
            }

            labs[#labs + 1] = data
        end
	end)
end

MySQL.ready(loadLabs)


RegisterServerEvent('kk-druglabs:updateDrugLabsData', function()
    loadLabs()
end)


lib.callback.register('kk-druglabs:requestLabs', function(source)
    return labs
end) 

lib.callback.register('kk-druglabs:leaveLab', function(source, id)
    local xPlayer = ESX.GetPlayerFromId(source)
    local returnable = nil

    if xPlayer then
        local playerPed = GetPlayerPed(xPlayer.source)

        if id then
            if labs[id] then
                TriggerClientEvent('kk-druglabs:client:unloadPlants', xPlayer.source)
                SetEntityCoords(playerPed, vec3(labs[id].enter.x, labs[id].enter.y, labs[id].enter.z));
                currentUsers[xPlayer.identifier] = nil; SetPlayerRoutingBucket(xPlayer.source, 0)

                returnable = true
            else
                returnable = false
            end
        else
            returnable = false
        end
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

lib.callback.register('kk-druglabs:requestPlantInfo', function(source, labId, plantId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local returnable = nil

    if xPlayer then
        MySQL.Async.fetchAll('SELECT data FROM user_labs WHERE id = ?', {labId}, function(result)
            if result[1] then
                local data = json.decode(result[1].data)

                returnable = data['plants'][plantId]
            else
                returnable = false
            end
        end)
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

lib.callback.register('kk-druglabs:enterLab', function(source, id, password)
    local xPlayer = ESX.GetPlayerFromId(source)
    local returnable = nil

    if xPlayer then
        MySQL.Async.fetchAll('SELECT data FROM user_labs WHERE id = ? AND password = ?', {id, password}, function(result)
            if result[1] then
                local playerPed = GetPlayerPed(xPlayer.source)
                SetEntityCoords(playerPed, drugLab); currentUsers[xPlayer.identifier] = id
                SetPlayerRoutingBucket(xPlayer.source, id)
                TriggerClientEvent('kk-druglabs:client:loadPlants', xPlayer.source, json.decode(result[1].data))

                returnable = true
            else
                returnable = false
            end
        end)
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

lib.callback.register('kk-druglabs:requestData', function(source, id)
    local xPlayer = ESX.GetPlayerFromId(source)
    local returnable = nil

    if xPlayer then
        MySQL.Async.fetchAll('SELECT * FROM user_labs WHERE id = ?', {id}, function(result)
            if result[1] then
                if tonumber(result[1].owner) == xPlayer.identifier then
                    returnable = shop
                else
                    returnable = false
                end
            else
                returnable = false
            end
        end)
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

RegisterNetEvent('kk-druglabs:server:changePin', function(id, pin)
    local xPlayer = ESX.GetPlayerFromId(source)
    local returnable = nil

    if xPlayer then
        MySQL.Async.fetchAll('SELECT * FROM user_labs WHERE id = ?', {id}, function(result)
            if result[1] then
                if tonumber(result[1].owner) == xPlayer.identifier then
                    MySQL.Sync.execute('UPDATE user_labs SET password = ? WHERE id = ?', {pin, id})
                    TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'success', 'Vahetasite ära labori parooli!')
                end
            end
        end)
    end
end)

AddEventHandler('KKF.Player.Dropped', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local playerPed = GetPlayerPed(xPlayer.source)

    if DoesEntityExist(playerPed) then
        local id = currentUsers[xPlayer.identifier]

        if id then
            currentUsers[xPlayer.identifier] = nil
            SetPlayerRoutingBucket(xPlayer.source, 0)

            SetEntityCoords(GetPlayerPed(xPlayer.source), vec3(labs[id].enter.x, labs[id].enter.y, labs[id].enter.z))
            TriggerClientEvent('kk-druglabs:client:unloadPlants', xPlayer.source)
            currentUsers[xPlayer.identifier] = nil

            SetTimeout(1000, function()
                MySQL.Sync.execute('UPDATE users SET position = ? WHERE pid = ?', { json.encode(labs[id].enter), xPlayer.identifier})
            end)
        end
    end
end)

local function canRoll(source, name)
    local xPlayer = ESX.GetPlayerFromId(source)
    local retval = true

    for k,v in pairs(cfg.rollingTasks[name].needs) do
        if not xPlayer.hasItem(v) then
            retval = false
        end
    end

    return retval
end

local function canScale(source, name)
    local xPlayer = ESX.GetPlayerFromId(source)
    local retval = true

    for k,v in pairs(cfg.scaleTasks[name].needs) do
        if not xPlayer.hasItem(v) then
            retval = false
        end
    end

    return retval
end

RegisterNetEvent('kk-druglabs:server:rollItem', function(args)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        if canRoll(xPlayer.source, args.item) then
            local currentItem = cfg.rollingTasks[args.item]

            xPlayer.removeInventoryItem('rollingpaper', 1)
            for k,v in pairs(currentItem.needs) do
                xPlayer.removeInventoryItem(v, 1)
            end

            xPlayer.addInventoryItem(args.item, 1)
        end
    end
end)

RegisterNetEvent('kk-druglabs:server:scaleItem', function(args)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        if canScale(xPlayer.source, args.item) then
            local currentItem = cfg.scaleTasks[args.item]

            for k,v in pairs(currentItem.needs) do
                xPlayer.removeInventoryItem(v, 1)
            end

            xPlayer.addInventoryItem(args.item, 1)
        end
    end
end)

-- ESX.RegisterUsableItem('roller', function(source)
--     local xPlayer = ESX.GetPlayerFromId(source)

--     if xPlayer then
--         TriggerClientEvent('kk-druglabs:client:rollerAction', xPlayer.source)
--     end
-- end)

-- ESX.RegisterUsableItem('drugscales', function(source)
--     local xPlayer = ESX.GetPlayerFromId(source)

--     if xPlayer then
--         TriggerClientEvent('kk-druglabs:client:scaleAction', xPlayer.source)
--     end
-- end)

SetInterval(function()
    local results = MySQL.Sync.fetchAll('SELECT id, owner, enter, data FROM user_labs')

    for i = 1, #results do
        local currentData = json.decode(results[i].data)

        for k,v in pairs(currentData.plants) do
            if currentData['plants'][k]['health'].fertilizer > 0 then
                currentData['plants'][k]['health'].fertilizer -= 25; currentData['plants'][k]['health'].progress += 12.5
            end

            if currentData['plants'][k]['health'].water > 0 then
                currentData['plants'][k]['health'].water -= 25; currentData['plants'][k]['health'].progress += 12.5
            end
        end

        MySQL.Sync.execute('UPDATE user_labs SET data = ? WHERE id = ?', { json.encode(currentData), results[i].id })
    end
end, 20 * 60000)

local function canHeat(source, name)
    local xPlayer = ESX.GetPlayerFromId(source)
    local retval = true

    for k,v in pairs(cfg.heaterTasks[name].needs) do
        if not xPlayer.hasItem(v) then
            retval = false
        end
    end

    return retval
end 

RegisterNetEvent('kk-druglabs:server:heaterAction', function(args)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        if canHeat(xPlayer.source, args.item) then
            local currentItem = cfg.heaterTasks[args.item]

            if xPlayer.canCarryItem(args.item, 1) then 
                for k,v in pairs(currentItem.needs) do
                    xPlayer.removeInventoryItem(v, 1)
                end

                xPlayer.addInventoryItem(args.item, 1)
            else
                TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Teie taskud on liiga täis!')
            end
        end
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

RegisterNetEvent('kk-druglabs:server:dryAction', function(args)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        if canDry(xPlayer.source, args.item) then
            local currentItem = cfg.dryerTasks[args.item]

            if xPlayer.canCarryItem(args.item, 1) then 
                for k,v in pairs(currentItem.needs) do
                    xPlayer.removeInventoryItem(v, 1)
                end

                xPlayer.addInventoryItem(args.item, 1)
            else
                TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Teie taskud on liiga täis!')
            end
        end
    end
end)

local function canBarrel(source, name)
    local xPlayer = ESX.GetPlayerFromId(source)
    local retval = true

    for k,v in pairs(cfg.barrelTasks[name].needs) do
        if not xPlayer.hasItem(v) then
            retval = false
        end
    end

    return retval
end 

RegisterNetEvent('kk-druglabs:server:barrelAction', function(args)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        if canBarrel(xPlayer.source, args.item) then
            local currentItem = cfg.barrelTasks[args.item]

            if xPlayer.canCarryItem(args.item, 1) then 
                for k,v in pairs(currentItem.needs) do
                    xPlayer.removeInventoryItem(v, 1)
                end

                xPlayer.addInventoryItem(args.item, 1)
            else
                TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Teie taskud on liiga täis!')
            end
        end
    end
end)

local function canPress(source, name)
    local xPlayer = ESX.GetPlayerFromId(source)
    local retval = true

    for k,v in pairs(cfg.packerTasks[name].needs) do
        if xPlayer.getItem(k).count < v then
            retval = false
        end
    end

    return retval
end 

RegisterNetEvent('kk-druglabs:server:pressAction', function(args)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        if canPress(xPlayer.source, args.item) then
            local currentItem = cfg.packerTasks[args.item]

            if xPlayer.canCarryItem(args.item, 1) then 
                for k,v in pairs(currentItem.needs) do
                    xPlayer.removeInventoryItem(k, v)
                end

                xPlayer.addInventoryItem(args.item, 1)
            else
                TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Teie taskud on liiga täis!')
            end
        end
    end
end)

local function canMix(source, name)
    local xPlayer = ESX.GetPlayerFromId(source)
    local retval = true

    for k,v in pairs(cfg.mixerTasks[name].needs) do
        if not xPlayer.hasItem(v) then
            retval = false
        end
    end

    return retval
end 

RegisterNetEvent('kk-druglabs:server:mixAction', function(args)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        if canMix(xPlayer.source, args.item) then
            local currentItem = cfg.mixerTasks[args.item]

            if xPlayer.canCarryItem(args.item, 1) then 
                for k,v in pairs(currentItem.needs) do
                    xPlayer.removeInventoryItem(v, 1)
                end

                xPlayer.addInventoryItem(args.item, 1)
            else
                TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Teie taskud on liiga täis!')
            end
        end
    end
end)

local function canCrush(source, name)
    local xPlayer = ESX.GetPlayerFromId(source)
    local retval = true

    for k,v in pairs(cfg.crusherTasks[name].needs) do
        if not xPlayer.hasItem(v) then
            retval = false
        end
    end

    return retval
end 

RegisterNetEvent('kk-druglabs:server:crushAction', function(args)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        if canCrush(xPlayer.source, args.item) then
            local currentItem = cfg.crusherTasks[args.item]

            if xPlayer.canCarryItem(args.item, 1) then 
                for k,v in pairs(currentItem.needs) do
                    xPlayer.removeInventoryItem(v, 1)
                end

                xPlayer.addInventoryItem(args.item, 1)
            else
                TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Teie taskud on liiga täis!')
            end
        end
    end
end)