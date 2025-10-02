local function getOwnerName(pid)
    local returnable = nil

    MySQL.Async.fetchAll('SELECT pid, firstname, lastname FROM users WHERE pid = ?', {
        pid
    }, function(result)
        if result and result[1] then
            returnable = result[1].firstname .. ' ' .. result[1].lastname .. ' (' .. result[1].pid .. ')'
        else
            returnable = 'Peeter Eenis'
        end
    end)

    while returnable == nil do Wait(50) end; return returnable
end 

lib.callback.register('kk-properties:removeWarehouse', function(source, id)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if xPlayer.job.name == 'properties' then

        else
            returnable = false
        end
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

lib.callback.register('kk-properties:forceOpen', function(source, id)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if xPlayer.job.name == 'properties' then

        else
            returnable = false
        end
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

lib.callback.register('kk-properties:getLocation', function(source, id)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if xPlayer.job.name == 'properties' then
            MySQL.Async.fetchAll('SELECT enterance FROM user_warehouses WHERE id = ?', {
                tonumber(id)
            }, function(result)
                if result and result[1] then
                    local pos = json.decode(result[1].enterance)

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

    while returnable == nil do Wait(50) end; return returnable
end)

lib.callback.register('kk-properties:searchProperties', function(source, owner)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if xPlayer.job.name == 'properties' then
            local sql = ''

            if owner ~= '' then
                sql = 'WHERE owner = ?'
            end

            Wait(5)

            MySQL.Async.fetchAll('SELECT * FROM user_warehouses ' .. sql, {
                tonumber(owner)
            }, function(result)
                if result and result[1] then
                    local results = {}
        
                    for index, data in ipairs(result) do
                        local info = {
                            id = data.id,
                            owner = getOwnerName(data.owner),
                            enterance = json.decode(data.enterance)
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

    while returnable == nil do Wait(50) end; return returnable
end)

lib.callback.register('kk-properties:searchHouses', function(source, owner)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if xPlayer.job.name == 'properties' then
            local sql = ''

            if owner ~= '' then
                sql = 'WHERE owner = ?'
            end

            Wait(5)

            MySQL.Async.fetchAll('SELECT * FROM user_houses ' .. sql, {
                tonumber(owner)
            }, function(result)
                if result and result[1] then
                    local results = {}
        
                    for index, data in ipairs(result) do
                        local info = {
                            id = data.id,
                            owner = getOwnerName(data.owner),
                            enterance = json.decode(data.enterance)
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

    while returnable == nil do Wait(50) end; return returnable
end)

lib.callback.register('kk-properties:upgradeApartment', function(source, pid)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if xPlayer.job.name == 'properties' then
            local xTarget = KKF.GetPlayerFromIdentifier(pid)

            if xTarget then
                MySQL.Async.fetchAll('SELECT apartment FROM users WHERE pid = ?', {
                    pid
                }, function(result)
                    if result[1].apartment == nil then
                        if xTarget.getMoney() >= 80000 then
                            xTarget.removeAccountMoney('money', 80000)
                            TriggerEvent('Society.AddMoney', 'properties', 80000)

                            MySQL.Async.execute('UPDATE users SET apartment = ? WHERE pid = ?', {
                                '{"x":-785.12,"y":323.69,"z":212.0}',
                                pid
                            }, function()
                                TriggerClientEvent('kk-apartments:client:getHouseData', xTarget.source); returnable = 'done'
                            end)
                        else
                            returnable = 'nomoney'
                        end
                    else
                        returnable = 'hasgot'
                    end
                end)
            else
                returnable = 'notonline'
            end
        else
            returnable = 'nojob'
        end
    else
        returnable = 'noobject'
    end

    while returnable == nil do Wait(50) end; return returnable
end)