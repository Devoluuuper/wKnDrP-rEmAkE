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



lib.callback.register('kk-tablet:boosting:requestData', function(source)
    local xPlayer = KKF.GetPlayerFromId(source)
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
    local xPlayer = KKF.GetPlayerFromId(source)
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


lib.callback.register('kk-tablet:boosting:setRecieve', function(source)
    local xPlayer = KKF.GetPlayerFromId(source)
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