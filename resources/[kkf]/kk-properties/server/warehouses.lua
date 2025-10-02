local warehouses = {}

function loadWarehouses()
    MySQL.Async.fetchAll('SELECT * FROM user_warehouses', {}, function(result)
        for k,v in pairs(result) do
            local data = {
                enterance = json.decode(v.enterance),
                exit = json.decode(v.exit),
                owner = v.owner,
                id = v.id,
                locked = v.locked
            }

            warehouses[v.id] = data
        end
	end)
end


MySQL.ready(function()
    loadWarehouses()
end)

lib.callback.register('kk-properties:getWarehouses', function(source)
    return warehouses
end)

lib.callback.register('kk-properties:enterWarehouse', function(source, id)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if not warehouses[id].locked then
            MySQL.Async.execute('UPDATE users SET last_warehouse = @status WHERE pid = @pid', {
                ['@status'] = id,
                ['@pid'] = xPlayer.identifier
            }, function(rowsChanged)
                local coords = warehouses[id].exit
                TriggerClientEvent('InteractSound_CL:PlayOnOne', xPlayer.source, 'DoorOpen', 0.7)
                Wait(500)
                TriggerClientEvent('InteractSound_CL:PlayOnOne', xPlayer.source, 'DoorClose', 0.7)
                SetEntityCoords(GetPlayerPed(xPlayer.source), vec3(coords.x, coords.y, coords.z))
                SetPlayerRoutingBucket(xPlayer.source, id)
                TriggerClientEvent('kk-properties:currentWarehouse', xPlayer.source, id)
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

exports('getLocation', function(property)
    local id = tonumber(property)

    return warehouses[id].enterance
end)

lib.callback.register('kk-properties:leaveWarehouse', function(source, id)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if not warehouses[id].locked then
            MySQL.Async.execute('UPDATE users SET last_warehouse = NULL WHERE pid = @pid', {
                ['@pid'] = xPlayer.identifier
            }, function(rowsChanged)
                local coords = warehouses[id].enterance
                TriggerClientEvent('InteractSound_CL:PlayOnOne', xPlayer.source, 'DoorOpen', 0.7)
                Wait(500)
                TriggerClientEvent('InteractSound_CL:PlayOnOne', xPlayer.source, 'DoorClose', 0.7)
                SetEntityCoords(GetPlayerPed(xPlayer.source), vec3(coords.x, coords.y, coords.z))
                SetPlayerRoutingBucket(xPlayer.source, 0)
                TriggerClientEvent('kk-properties:currentWarehouse', xPlayer.source, 0)
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

lib.callback.register('kk-properties:lockingFunction', function(source, id)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if tonumber(warehouses[id].owner) == xPlayer.identifier then
            MySQL.Async.execute('UPDATE user_warehouses SET locked = ? WHERE id = ?', { not warehouses[id].locked, id}, function(rowsChanged)
                warehouses[id].locked = not warehouses[id].locked
                TriggerClientEvent('kk-properites:reloadWarehouseData', -1, warehouses)
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
    local warehouses = MySQL.Sync.fetchAll('SELECT * FROM user_warehouses', {})

    for k,v in pairs(warehouses) do
        for i=0,3 do 
            exports.ox_inventory:RegisterStash(v.id .. 'warehouse' .. i, 'Ladu', 75, 200000, false)
        end
    end
end


local GetCurrentResourceName = GetCurrentResourceName()

AddEventHandler('onServerResourceStart', function(resourceName)
	if resourceName == 'ox_inventory' or resourceName == GetCurrentResourceName then
        loadStashes()
	end
end)

lib.callback.register('kk-properties:sellWarehouse', function(source, playerId, price)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        local xTarget = KKF.GetPlayerFromId(playerId)

        if xTarget then
            local location = GetEntityCoords(GetPlayerPed(xPlayer.source))

            if location then
                if xTarget.getMoney() >= price then
                    MySQL.Async.execute('INSERT INTO user_warehouses (owner, enterance) VALUES (@owner, @enterance)', {
                        ['@owner'] = xTarget.identifier,
                        ['@enterance'] = json.encode(location)
                    }, function(rowsChanged)
                        xTarget.removeAccountMoney('money', price)

                        exports['kk-scripts']:sendSocietyLog(xPlayer.source, 'LAO MÜÜK', 'HIND: $' .. price .. '; ISIKULE: ' .. xTarget.name .. '.')
                        exports['kk-scripts']:sendLog(xPlayer.identifier, 'KINNISVARA', 'Müüs lao hinnaga $' .. price .. '.', xTarget.identifier)

                        TriggerEvent('Society.AddMoney', 'properties', price)

                        warehouses = {}

                        Wait(5)
                        loadWarehouses()
                        loadStashes()
                        Wait(5)

                        TriggerClientEvent('kk-properites:reloadWarehouseData', -1, warehouses)
                        
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