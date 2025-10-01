ESX.RegisterUsableItem('fakeplate', function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer then
        TriggerClientEvent('kk-fakeplate:client:tryPlate', xPlayer.source)
    end
end)

RegisterCommand('removePlate', function(source, args)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer then
        TriggerClientEvent('kk-fakeplate:client:restorePlate', xPlayer.source)
    end
end)

lib.callback.register('kk-fakeplate:setVehiclePlate', function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        returnable = exports['kk-vehicleshop']:generatePlate()
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

lib.callback.register('kk-fakeplate:checkPlate', function(source, plate)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        MySQL.Async.fetchAll("SELECT 1 FROM user_vehicles WHERE fakeplate = @fakeplate",{
            ['@fakeplate'] = plate
        }, function(result)
            if result[1] then
                MySQL.Async.fetchAll("SELECT plate FROM user_vehicles WHERE fakeplate = @fakeplate",{
                    ['@fakeplate'] = plate
                }, function(result2)
                    if result2[1] then
                        MySQL.Async.execute('UPDATE user_vehicles SET `fakeplate` = NULL WHERE `plate` = @currentPlate', {
                            ['@currentPlate'] = result2[1].plate
                        }, function(rowsChanged)
                            returnable = result2[1].plate
                        end)
                    else
                        returnable = false
                    end
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

lib.callback.register('kk-fakeplate:updatePlate', function(source, currentPlate, newPlate)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        MySQL.Async.fetchAll("SELECT 1 FROM user_vehicles WHERE plate = @currentPlate",{
            ['@currentPlate'] = currentPlate
        }, function(result)
            if result[1] then 
                MySQL.Async.execute('UPDATE user_vehicles SET `fakeplate` = @newPlate WHERE `plate` = @currentPlate', {
                    ['@newPlate'] = newPlate,
                    ['@currentPlate'] = currentPlate
                }, function(rowsChanged)
                    returnable = true
                end)
            else
                MySQL.Async.fetchAll("SELECT plate FROM user_vehicles WHERE fakeplate = @currentPlate",{
                    ['@currentPlate'] = currentPlate
                }, function(result2)
                    if result2[1] then 
                        MySQL.Async.execute('UPDATE user_vehicles SET `fakeplate` = @newPlate WHERE `plate` = @currentPlate', {
                            ['@newPlate'] = newPlate,
                            ['@currentPlate'] = result2[1].plate
                        }, function(rowsChanged)
                            returnable = true
                        end)
                    else
                        returnable = false
                    end
                end)
            end
        end)
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)