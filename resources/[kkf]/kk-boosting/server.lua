local contracts = {}
local queue = {}
local currentBoost = {}
local copBlips = {}
local classes = {
    [1] = 'D',
    [2] = 'C',
    [3] = 'B',
    [4] = 'A',
    [5] = 'S'
}

local function generateDrop()
    return cfg.dropOffs[math.random(1, #cfg.dropOffs)]
end

local function generateLocation()
    return cfg.locations[math.random(1, #cfg.locations)]
end

lib.callback.register('kk-boosting:requestData', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local returnable = nil

    if xPlayer then
        MySQL.Async.fetchAll('SELECT * FROM boosting_data WHERE pid = ?', { xPlayer.identifier }, function(result)
            if result[1] then
                local currentData = json.decode(result[1].data)
                currentData['recieves'] = queue[xPlayer.identifier]

                if currentData.classProgress >= 100 and classes[currentData.currentClass] ~= 'S' then
                    currentData.currentClass = currentData.nextClass

                    for k,v in pairs(classes) do
                        if v == currentData.currentClass then
                            currentData.nextClass = classes[k + 1] or '?'
                            currentData.classProgress = 0
                            TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'info', 'Saavutasite boostingus taseme ' .. currentData.currentClass .. '!', 7500)
                        end
                    end

                    MySQL.Sync.execute('UPDATE boosting_data SET data = ? WHERE pid = ?', { json.encode(currentData), xPlayer.identifier})
                    returnable = currentData
                else
                    returnable = currentData
                end      
            else
                MySQL.insert('INSERT INTO boosting_data (pid, data) VALUES (?, ?)', {xPlayer.identifier, json.encode(cfg.defaultData)}, function(result)
                    returnable = cfg.defaultData
                end)
            end
        end)
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

lib.callback.register('kk-boosting:deleteContract', function(source, id)
    local xPlayer = ESX.GetPlayerFromId(source)
    local returnable = nil

    if xPlayer then
        MySQL.Async.fetchAll('SELECT * FROM boosting_data WHERE pid = ?', { xPlayer.identifier }, function(result)
            if result[1] then
                local data = json.decode(result[1].data)

                table.remove(data.contracts, id)

                MySQL.Async.execute('UPDATE boosting_data SET data = ? WHERE pid = ?', { json.encode(data), xPlayer.identifier }, function(res)
                    returnable = true
                end)
            else
                returnable = false
            end
        end)
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

local function updateLevel(pid)
    MySQL.Async.fetchAll('SELECT * FROM boosting_data WHERE pid = ?', { pid }, function(result)
        if result[1] then
            local data = json.decode(result[1].data)

            if data.currentClass == 'S' then
                data.classProgress += 0 -- ?
            elseif data.currentClass == 'A' then
                data.classProgress += 0.1 -- 1000
            elseif data.currentClass == 'B' then
                data.classProgress += 0.2 -- 500
            elseif data.currentClass == 'C' then
                data.classProgress += 0.4 -- 250
            elseif data.currentClass == 'D' then
                data.classProgress += 2 -- 50
            end

            MySQL.Async.execute('UPDATE boosting_data SET data = ? WHERE pid = ?', { json.encode(data), pid })
        end
    end)
end

lib.callback.register('kk-boosting:finishJob', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        if currentBoost[xPlayer.identifier] then
            TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'success', 'Toimetasite sõiduki kohale ja teenisite $' .. currentBoost[xPlayer.identifier].prize .. '!'); updateLevel(xPlayer.identifier)
            exports['kk-scripts']:sendLog(xPlayer.identifier, 'TÖÖD', 'Tegi ' .. currentBoost[xPlayer.identifier].class .. ' boosti ja teenis ' .. currentBoost[xPlayer.identifier].prize .. ' 1tk.')
            xPlayer.addMoney(currentBoost[xPlayer.identifier].prize); currentBoost[xPlayer.identifier] = nil
        end
    end

    return true
end)

lib.callback.register('kk-boosting:acceptContract', function(source, id)
    local xPlayer = ESX.GetPlayerFromId(source)
    local returnable = nil

    if xPlayer then
        MySQL.Async.fetchAll('SELECT * FROM boosting_data WHERE pid = ?', { xPlayer.identifier }, function(result)
            if result[1] then
                local data = json.decode(result[1].data)

                if xPlayer.getAccount('bank').money >= data.contracts[id].price then
                    xPlayer.removeAccountMoney('bank', data.contracts[id].price)
                                    
                    local retval = {}
                    
                    retval.plate = exports['kk-vehicleshop']:generatePlate()
                    retval.model = data.contracts[id].model
                    retval.location = generateLocation()
                    retval.drop = generateDrop()

                    retval.img = data.contracts[id].img
                    retval.label = data.contracts[id].name
                    retval.class = data.contracts[id].class
                    retval.prize = data.contracts[id].prize
                    
                    currentBoost[xPlayer.identifier] = {
                        prize = data.contracts[id].prize,
                        class = data.contracts[id].class,
                    }

                    table.remove(data.contracts, id)

                    MySQL.Async.execute('UPDATE boosting_data SET data = ? WHERE pid = ?', { json.encode(data), xPlayer.identifier }, function(res)
                        returnable = retval
                    end)
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

lib.callback.register('kk-boosting:queueToggle', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local returnable = nil

    if xPlayer then
        if not queue[xPlayer.identifier] then
            queue[xPlayer.identifier] = #queue + 1
        else
            queue[xPlayer.identifier] = nil
        end

        returnable = true
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

local function contractCount(pid)
    local returnable = nil

    MySQL.Async.fetchAll('SELECT * FROM boosting_data WHERE pid = ?', { pid }, function(result)
        if result[1] then
            local data = json.decode(result[1].data)

            returnable = #data.contracts
        else
            returnable = 0
        end
    end)

    while returnable == nil do Wait(50) end; return returnable
end

local function randomClass(class)
    local returnable = 'D'
    
    for k,v in pairs(classes) do
        if v == class then
            myNumber = classes[math.random(1, k)]
        end
    end

    return returnable
end

SetInterval(function()
    local results = MySQL.Sync.fetchAll('SELECT * FROM boosting_data')

    for k,v in pairs(results) do
        local data = json.decode(v.data)

        if data.lastContract > 0 then
            data.lastContract -= 1
        end

        for kk,vv in pairs(data.contracts) do
            data.contracts[kk].expires -= 1

            if data.contracts[kk].expires == 0 then
                table.remove(data.contracts, kk)
            end
        end

        MySQL.Sync.execute('UPDATE boosting_data SET data = ? WHERE pid = ?', { json.encode(data), v.pid })

        local xTarget = ESX.GetPlayerFromIdentifier(v.pid)

        if xTarget then
            TriggerClientEvent('kk-boosting:client:updateData', xTarget.source)
        end
    end
end, 60000)

local function generateContract(myClass)
    local class = randomClass(myClass)
    local vehicles = exports['kk-vehicleshop']:getVehicles(class)
    local randomVehicle = vehicles[math.random(1, #vehicles)]

    local data = {
        class = class,
        price = cfg.prizes[class].min / 5,
        prize = math.random(cfg.prizes[class].min, cfg.prizes[class].max),
        expires = math.random(cfg.contractExpire.min, cfg.contractExpire.max),
        name = randomVehicle.label,
        img = randomVehicle.img,
        model = randomVehicle.modelName
    }

    return data
end 

SetInterval(function()
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

        if xPlayer then
            if queue[xPlayer.identifier] then
                local count = contractCount(xPlayer.identifier)

                if count < 3 and xPlayer.hasItem('boosting_tablet') then
                    MySQL.Async.fetchAll('SELECT * FROM boosting_data WHERE pid = ?', { xPlayer.identifier }, function(result)
                        if result[1] then
                            local currentData = json.decode(result[1].data)

                            if currentData.lastContract == 0 then
                                currentData.contracts[#currentData.contracts + 1] = generateContract(currentData.currentClass); currentData.lastContract = cfg.contractCooldown
                                MySQL.Sync.execute('UPDATE boosting_data SET data = ? WHERE pid = ?', { json.encode(currentData), xPlayer.identifier })

                                TriggerClientEvent('kk-boosting:client:updateData', xPlayer.source)
                            end
                        end
                    end)
                end

                queue[xPlayer.identifier] = #queue + 1
            end
        else
            queue[xPlayer.identifier] = nil
        end
    end
end, cfg.queueTime * 60000)

lib.callback.register('kk-boosting:setCopBlip', function(source, coords)
    local xPlayer = ESX.GetPlayerFromId(source)
    local returnable = nil

    if xPlayer then
        local xTargets = ESX.GetPlayers()
        local uid = playerOwn[xPlayer.identifier]

        if uid then
            copBlips[playerOwn[xPlayer.identifier]] = coords
        else
            playerOwn[xPlayer.identifier] = #copBlips + 1
            uid = playerOwn[xPlayer.identifier]
            copBlips[uid] = coords
        end

        for i = 1, #xTargets do
            local xTarget = ESX.GetPlayerFromId(xTargets[i])

            if xTarget.job.name == 'police' and xTarget.job.onDuty then
                TriggerClientEvent('kk-boosting:client:setCopBlip', xPlayer.source, uid, copBlips[uid])
            end
        end

        returnable = uid
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

lib.callback.register('kk-boosting:destroyBlips', function(source, uid)
    local xPlayer = ESX.GetPlayerFromId(source)
    local returnable = nil

    if xPlayer then
        playerOwn[xPlayer.identifier] = nil
        copBlips[uid] = nil
        TriggerClientEvent('kk-boosting:client:destroyBlip', -1, uid)

        returnable = true
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

ESX.RegisterUsableItem('boosting_tablet', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        TriggerClientEvent('kk-boosting:client:openTablet', xPlayer.source)
    end
end)

ESX.RegisterUsableItem('hacking_tablet', function(source)
    TriggerClientEvent('kk-boosting:client:boostingHack', source)
end)