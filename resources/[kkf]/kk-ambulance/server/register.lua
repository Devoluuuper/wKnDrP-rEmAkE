local bedsTaken = {}

RegisterServerEvent('kk-ambulance:server:sendBill', function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        MySQL.Sync.execute('INSERT INTO billing (identifier, sender, target, label, amount, time) VALUES (@identifier, @sender, @target, @label, @amount, @time)', {
            ['@identifier'] = xPlayer.identifier,
            ['@sender'] = xPlayer.identifier,
            ['@target'] = "ambulance",
            ['@label'] = "Kiirabi arve | Sveta",
            ['@amount'] = 5000,
            ['@time'] = os.date('%Y-%m-%d %X')
        }, function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, "info", 'Sulle esitati arve.')
            else
                print(('Failed to create invoice for player %s'):format(xPlayer.getName()))
            end
        end)
    end
end)


RegisterServerEvent('kk-ambulance:server:leaveBed', function(hospital, id)
    Config.Hospitals[hospital].Beds[id].taken = false
end)


lib.callback.register('kk-ambulance:requestBed', function(source, hospital, ambulanceOnline)
    local xPlayer = ESX.GetPlayerFromId(source)
    local returnable = nil; local found = false

    if xPlayer then
        local beds = Config.Hospitals[hospital].Beds

        for k, v in pairs(beds) do
            if not v.taken and not found then
                Config.Hospitals[hospital].Beds[k].taken = true; found = true
                returnable = {k, v, hospital}
            end
        end
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

RegisterServerEvent('kk-ambulance:server:payIllegal', function(hospital)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local hopitalprice = Config.Hospitals[hospital].price
        local cashmoney = xPlayer.getMoney()
        local bankmoney = xPlayer.getAccount('bank').money
        if cashmoney >= hopitalprice then
            xPlayer.removeMoney(hopitalprice)
        elseif bankmoney >= hopitalprice then
            xPlayer.removeAccountMoney('bank', hopitalprice)
        else
            MySQL.Async.execute('INSERT INTO billing (identifier, sender, target, label, amount, time) VALUES (@identifier, @sender, @target, @label, @amount, @time)', {
                ['@identifier'] = xPlayer.identifier,
                ['@sender'] = xPlayer.identifier,
                ['@target'] = "ambulance",
                ['@label'] = "Kiirabi arve | ".. Config.Hospitals[hospital].label,
                ['@amount'] = hopitalprice,
                ['@time'] = os.date('%Y-%m-%d %X')
            }, function(rowsChanged)
                if rowsChanged > 0 then
                    TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, "info", 'Sulle esitati arve.')
                else
                    print(('kk-ambulance Failed to create invoice for player %s'):format(xPlayer.getName()))
                end
            end)
        end
    else
        print('kk-ambulance xPlayer not found')
    end
end)

----------------- INTERNSIVE --------------------
-- local IntensiveTaknen = {}

-- RegisterServerEvent('kk-ambulance:server:leaveBed', function(hospital, id)
--     Config.Hospitals[hospital].Intensive[id].taken = false
-- end)


