local labs = {}

function loadLabs()
    labs = {}
    MySQL.Async.fetchAll('SELECT * FROM user_labs', {}, function(result)
        for k, v in pairs(result) do
            local data = {
                enter = json.decode(v.enter),
                owner = v.owner,
                id = v.id,
                password = v.password
            }

            labs[v.id] = data
        end
    end)
end

MySQL.ready(function()
    loadLabs()
end)

lib.callback.register('kk-properties:getLabs', function(source)
    return labs
end)


lib.callback.register('kk-properties:sellLab', function(source, playerId, price)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        local xTarget = KKF.GetPlayerFromId(playerId)

        if xTarget then
            if xTarget.getMoney() >= price then
                local location = GetEntityCoords(GetPlayerPed(xPlayer.source))

                if location then
                    local locationJSON = json.encode({
                        x = location.x,
                        y = location.y,
                        z = location.z
                    })

                    MySQL.Async.execute('INSERT INTO user_labs (`owner`, `enter`) VALUES (?, ?)', {
                        xTarget.identifier,
                        locationJSON
                    }, function(rowsChanged)
                        xTarget.removeAccountMoney('money', price)

                        exports['kk-scripts']:sendSocietyLog(xPlayer.source, 'LABORI MÜÜK', 'HIND: $' .. price .. '; ISIKULE: ' .. xTarget.name .. '.')
                        exports['kk-scripts']:sendLog(xPlayer.identifier, 'KINNISVARA', 'Müüs labori hinnaga $' .. price .. '.', xTarget.identifier)

                        TriggerEvent('Society.AddMoney', 'properties', price)
                        
                        Wait(5)
                        loadLabs()
                        Wait(5)

                        TriggerClientEvent('kk-druglabs:reloadLabData', -1, labs)
                        TriggerEvent('kk-druglabs:updateDrugLabsData')
                        returnable = true
                    end)
                else
                    returnable = false
                end
            else
                returnable = false
            end
        else
            returnable = false
        end
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end
    return returnable
end)

lib.callback.register('kk-properties:searchlabs', function(source, context)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if xPlayer.job.name == cfg.job then
            local query = ""
            local parameters = {}

            if context and context ~= "" then
                query = "SELECT * FROM user_labs WHERE `owner` = @owner"
                parameters = { ['@owner'] = context }
            else
                query = "SELECT * FROM user_labs LIMIT 10"
            end

            MySQL.Async.fetchAll(query, parameters, function(result)
                if result and #result > 0 then
                    local results = {}

                    for index, data in ipairs(result) do
                        local player = KKF.GetPlayerFromIdentifier(data.owner)
                        local playerName = player and player.name or "Rauno Kõvataja"

                        local info = {
                            id = data.id,
                            name = 'Lab #' .. data.id,
                            playerName = playerName,
                            owner = data.owner,
                            password = data.password,
                            enter = json.decode(data.enter)
                        }

                        table.insert(results, info)
                    end

                    returnable = results
                else
                    returnable = {}
                end
            end)
        else
            returnable = {}
        end
    else
        returnable = {}
    end

    while returnable == nil do Wait(50) end
    return returnable
end)



lib.callback.register('kk-properties:lab:getLocation', function(source, id)
            
    print(id)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if xPlayer.job.name == cfg.job then
            MySQL.Async.fetchAll('SELECT enter FROM user_labs WHERE id = ?', {
                tonumber(id)
            }, function(result)
                if result and result[1] then
                    local pos = json.decode(result[1].enter)
                    returnable = {x = pos.x, y = pos.y}
                else
                    returnable = {x = 1, y = 1}
                end
            end)
        else
            returnable = {x = 1, y = 1}
        end
    else
        returnable = {x = 1, y = 1}
    end

    while returnable == nil do Wait(50) end
    return returnable
end)