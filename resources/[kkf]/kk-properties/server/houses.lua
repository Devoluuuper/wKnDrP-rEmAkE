local houses = {}

function loadHouses()
    MySQL.Async.fetchAll('SELECT * FROM user_houses', {}, function(result)
        for k,v in pairs(result) do
            local data = {
                enterance = json.decode(v.enterance),
                exit = json.decode(v.exit),
                owner = v.owner,
                id = v.id,
                ipl = v.ipl,
                safesize = v.safesize,
                locked = v.locked,
                name = v.name
            }

            houses[v.id] = data
        end
	end)
end


MySQL.ready(function()
    loadHouses()
end)

lib.callback.register('kk-properties:getHouses', function(source)
    return houses
end)

lib.callback.register('kk-properties:enterHouse', function(source, id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if not houses[id].locked then
            MySQL.Async.execute('UPDATE users SET last_property = @status WHERE pid = @pid', {
                ['@status'] = id,
                ['@pid'] = xPlayer.identifier
            }, function(rowsChanged)
                local coords = houses[id].exit
                TriggerClientEvent('InteractSound_CL:PlayOnOne', xPlayer.source, 'DoorOpen', 0.7)
                Wait(500)
                TriggerClientEvent('InteractSound_CL:PlayOnOne', xPlayer.source, 'DoorClose', 0.7)
                SetEntityCoords(GetPlayerPed(xPlayer.source), vec3(coords.x, coords.y, coords.z))
                SetPlayerRoutingBucket(xPlayer.source, id)
                TriggerClientEvent('kk-properties:currentHouse', xPlayer.source, id)
                returnable = true
            end)
        else
            returnable = false
        end
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

exports('getHouseLocation', function(property)
    local id = tonumber(property)

    return houses[id].enterance
end)

lib.callback.register('kk-properties:leaveHouse', function(source, id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if not houses[id].locked then
            MySQL.Async.execute('UPDATE users SET last_property = NULL WHERE pid = @pid', {
                ['@pid'] = xPlayer.identifier
            }, function(rowsChanged)
                local coords = houses[id].enterance
                TriggerClientEvent('InteractSound_CL:PlayOnOne', xPlayer.source, 'DoorOpen', 0.7)
                Wait(500)
                TriggerClientEvent('InteractSound_CL:PlayOnOne', xPlayer.source, 'DoorClose', 0.7)
                SetEntityCoords(GetPlayerPed(xPlayer.source), vec3(coords.x, coords.y, coords.z))
                SetPlayerRoutingBucket(xPlayer.source, 0)
                TriggerClientEvent('kk-properties:currentHouse', xPlayer.source, 0)
                returnable = true
            end)
        else
            returnable = false
        end
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

lib.callback.register('kk-properties:houselockingFunction', function(source, id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if tonumber(houses[id].owner) == xPlayer.identifier then
            MySQL.Async.execute('UPDATE user_houses SET locked = ? WHERE id = ?', { not houses[id].locked, id}, function(rowsChanged)
                houses[id].locked = not houses[id].locked
                TriggerClientEvent('kk-properites:reloadHouseData', -1, houses)
                returnable = true
            end)
        else
            returnable = false
        end
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

local function loadStashes()
    local stashes = MySQL.Sync.fetchAll('SELECT * FROM user_houses', {})

    for k,v in pairs(stashes) do        
        exports['ox_inventory']:RegisterStash(v.id .. 'house', 'Maja seif', 75, v.safesize * 1000, false)
    end
end


local GetCurrentResourceName = GetCurrentResourceName()

AddEventHandler('onServerResourceStart', function(resourceName)
	if resourceName == 'ox_inventory' or resourceName == GetCurrentResourceName then
        loadStashes()
	end
end)

lib.callback.register('kk-properties:sellHouse', function(source, playerId, price, houseType, name)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        local xTarget = ESX.GetPlayerFromId(playerId)

        if xTarget then
            local location = GetEntityCoords(GetPlayerPed(xPlayer.source))

            if location then
                if xTarget.getMoney() >= price then
                    MySQL.insert('INSERT INTO user_houses (`owner`, `name`, `enterance`, `exit`, `ipl`) VALUES (?, ?, ?, ?, ?)', {xTarget.identifier, name, json.encode(location), json.encode(houseType.pos), houseType.ipl}, function(res)
                        xTarget.removeAccountMoney('money', price)

                        exports['kk-scripts']:sendSocietyLog(xPlayer.source, 'MAJA MÜÜK', 'HIND: $' .. price .. '; ISIKULE: ' .. xTarget.name .. '.')
                        exports['kk-scripts']:sendLog(xPlayer.identifier, 'KINNISVARA', 'Müüs maja hinnaga $' .. price .. '.', xTarget.identifier)

                        TriggerEvent('Society.AddMoney', 'properties', price)

                        houses = {}

                        Wait(5)
                        loadStashes()
                        loadHouses()
                        Wait(5)

                        TriggerClientEvent('kk-properites:reloadHouseData', -1, houses)
                        
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

    while returnable == nil do Wait(50) end; return returnable
end)

lib.callback.register('kk-properties:upgradeSafeSize', function(source, houseid)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if xPlayer.getMoney() >= 10000 then

            MySQL.Async.execute('UPDATE user_houses SET safesize = ? WHERE id = ?', {'200', houseid}, function()
    
                xPlayer.removeAccountMoney('money', 10000)
                exports['kk-scripts']:sendLog(xPlayer.identifier, 'KINNISVARA', 'Uuendas maja ID: ' .. houseid .. ' seifi 200 peale.', "0")

                houses = {}
    
                Wait(5)
                loadStashes()
                loadHouses()
                Wait(5)
    
                TriggerClientEvent('kk-properites:reloadHouseData', -1, houses)
    
                returnable = true
            end)

        else
            returnable = false
        end
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)