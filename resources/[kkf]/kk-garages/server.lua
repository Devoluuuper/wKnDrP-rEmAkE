MySQL.ready(function ()
    MySQL.Async.execute('UPDATE user_vehicles SET impoundable = true WHERE stored = false', {})
end)

lib.callback.register('kk-garage:getVehicles', function(source, location, faction)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer and not faction then
        MySQL.Async.fetchAll('SELECT * FROM user_vehicles WHERE owner = @owner and location = @location', {
            ['@owner'] = xPlayer.identifier,
            ['@location'] = location
        }, function(result)
            returnable = result or {}
        end)
    elseif faction then
        local society = 'society_' .. faction
        MySQL.Async.fetchAll('SELECT * FROM user_vehicles WHERE owner = @owner and location = @location', {
            ['@owner'] = society,
            ['@location'] = location
        }, function(result)
            returnable = result or {}
        end)
    else
        returnable = {}
    end

    while returnable == nil do Wait(50) end
    return returnable
end)

exports('getFactionGarages', function(faction, type)
    local returnable = {}

    for k,v in pairs(cfg.garages) do
        if v.faction == faction and v.type == type then
            returnable[k] = v
        end
    end

    return returnable
end)

lib.callback.register('kk-garage:getFactionVehicles', function(source, location, type)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        local identifier = "society_"..xPlayer.job.name

        -- MySQL.Async.fetchAll('SELECT * FROM user_vehicles WHERE owner = @owner and location = @location', {
            MySQL.Async.fetchAll('SELECT * FROM user_vehicles WHERE owner = @owner', {
            ['@owner'] = identifier,
            -- ['@location'] = location
        }, function(result)
            returnable = result or {}
        end)
    else
        returnable = {}
    end

    while returnable == nil do Wait(50) end; return returnable
end)


local function calculateImpoundPrice(model)
    model = tonumber(model)
    local vehiclePrice = 50000

    if exports['kk-vehicleshop']:getVehiclePrice(model) then
        vehiclePrice = exports['kk-vehicleshop']:getVehiclePrice(model)
    -- elseif exports['kk-factions']:getVehiclePrice(model) then
    --     vehiclePrice = exports['kk-factions']:getVehiclePrice(model)
    end

    local impoundPrice = KKF.Math.Round(vehiclePrice * 0.05)
    local realPrice = impoundPrice + KKF.Math.Round(KKF.Math.Percent(exports['kk-taxes']:getTax('primary').value, impoundPrice))

    return realPrice
end

lib.callback.register('kk-garage:impoundPayment', function(source, model, plate)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable_canpay = nil
    local price = calculateImpoundPrice(model)

    if xPlayer then
        local moneyHave = xPlayer.getAccount('bank').money
        if moneyHave >= price then
            returnable_canpay = true
            xPlayer.removeAccountMoney('bank', price)
            MySQL.Async.execute('UPDATE user_vehicles SET impoundable = @impoundable WHERE plate = @plate', {['@impoundable'] = 0,['@plate'] = plate})
        else
            returnable_canpay = false
        end
    end
    
    while returnable_canpay == nil do Wait(50) end
    return returnable_canpay, price
end)




lib.callback.register('kk-garage:isVehicleOwner', function(source, plate)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        local identifier = 'society_'..xPlayer.job.name
        
        MySQL.Async.fetchAll('SELECT * FROM user_vehicles WHERE plate = @plate AND owner = @owner', {
            ['@plate'] = plate,
            ['@owner'] = xPlayer.identifier
        }, function(result)
            if result[1] then
                returnable = true
            else
                MySQL.Async.fetchAll('SELECT * FROM user_vehicles WHERE plate = @plate AND owner = @owner', {
                    ['@plate'] = plate,
                    ['@owner'] = identifier
                }, function(result2)
                    if result2[1] then
                        if xPlayer.job.onDuty then
                            returnable = true
                        else
                            returnable = false
                        end
                    else
                        MySQL.Async.fetchAll('SELECT * FROM user_vehicles WHERE fakeplate = @plate AND owner = @owner', {
                            ['@plate'] = plate,
                            ['@owner'] = 'society_' .. xPlayer.job.name
                        }, function(result3)
                            if result3[1] then
                                if xPlayer.job.onDuty then
                                    returnable = true
                                else
                                    returnable = false
                                end
                            else
                                MySQL.Async.fetchAll('SELECT * FROM user_vehicles WHERE fakeplate = @plate AND owner = @owner', {
                                    ['@plate'] = plate,
                                    ['@owner'] = xPlayer.identifier
                                }, function(result4)
                                    if result4[1] then
                                        returnable = true
                                    else
                                        returnable = false
                                    end
                                end)
                            end
                        end)
                    end
                end)
            end
        end)
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)


-- RegisterNetEvent('kk-garages:server:changeNickname', function(plate, newNickname)
--     print("Received plate:", plate)
--     print("Received new nickname:", newNickname)
    
--     local src = source
--     local xPlayer = KKF.GetPlayerFromId(src)

--     if xPlayer then
--         MySQL.Async.execute('UPDATE user_vehicles SET nickname = @newNickname WHERE plate = @plate', {
--             ['@newNickname'] = newNickname,
--             ['@plate'] = plate
--         }, function(rowsChanged)
--             if rowsChanged > 0 then
--                 print("Nickname updated successfully.")
--                 TriggerClientEvent('KKF.UI.ShowNotification', src, "success", 'Nimi vahetatud.')
--             else
--                 print("No rows were updated.")
--                 TriggerClientEvent('KKF.UI.ShowNotification', src, "error", 'Midagi läks valesti.')
--             end
--         end)
--     else
--         print("Player not found.")
--     end
-- end)


lib.callback.register('kk-garages:changeNickname', function(source, plate, newNickname)
    local xPlayer = KKF.GetPlayerFromId(source)
    if not xPlayer then
        return false
    end

    local updated = MySQL.Sync.execute('UPDATE user_vehicles SET nickname = @newNickname WHERE plate = @plate', {
        ['@newNickname'] = newNickname,
        ['@plate'] = plate
    })

    if updated > 0 then
        TriggerClientEvent('KKF.UI.ShowNotification', source, "success", 'Nimi vahetatud.')
        return true
    else
        TriggerClientEvent('KKF.UI.ShowNotification', source, "error", 'Midagi läks valesti.')
        return false
    end
end)

RegisterNetEvent('kk-garages:server:newKey', function(data)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)

    -- Kontrolli, kas mängija on olemas
    if not xPlayer then
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Mängijat ei leitud!')
        return
    end

    -- Määra numbrimärk
    local plate = nil
    if type(data) == "table" then
        plate = data.plate
    elseif type(data) == "string" then
        plate = data
    end

    -- Kontrolli, kas numbrimärk on olemas
    if not plate then
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Viga: Sõiduki numbrimärk puudub!')
        return
    end

    local owner = xPlayer.identifier
    local job = xPlayer.job
    local isOwner = false
    local isFactionVehicle = false

    -- Kontrolli, kas sõiduk kuulub mängijale
    local playerCount = MySQL.Sync.fetchScalar(
        'SELECT COUNT(*) FROM user_vehicles WHERE plate = ? AND owner = ?',
        { plate, owner }
    ) or 0

    if playerCount > 0 then
        isOwner = true
    elseif job and job.name then
        -- Kontrolli, kas sõiduk kuulub fraktsioonile
        local societyOwner = 'society_' .. job.name
        local factionCount = MySQL.Sync.fetchScalar(
            'SELECT COUNT(*) FROM user_vehicles WHERE plate = ? AND owner = ?',
            { plate, societyOwner }
        ) or 0

        if factionCount > 0 and job.onDuty then
            isFactionVehicle = true
        end
    end

    -- Funktsioon võtme andmiseks
    local function giveKey()
        exports['kk-vehicles']:addKey(xPlayer.source, plate)
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'success', 'Soetasid uue autovõtme!')
    end

    -- Kontrolli, kas cfg.NewKeyPrice on defineeritud
    if not cfg or not cfg.NewKeyPrice then
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Viga: Uue võtme hind pole seadistatud!')
        print('[KK-Garages] Viga: cfg.NewKeyPrice pole defineeritud!')
        return
    end

    if isOwner then
        -- Kontrolli mängija raha ox_inventory kaudu
        local money = exports.ox_inventory:GetItemCount(src, 'money')
        if money >= cfg.NewKeyPrice then
            exports.ox_inventory:RemoveItem(src, 'money', cfg.NewKeyPrice)
            giveKey()
        else
            TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Teil ei ole piisavalt sularaha!')
        end
    elseif isFactionVehicle then
        -- Kontrolli fraktsiooni raha
        TriggerEvent('Society.GetMoney', job.name, function(factionMoney)
            if not factionMoney or factionMoney < cfg.NewKeyPrice then
                TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Fraktsiooni arvel ei ole piisavalt raha!')
                return
            end
            giveKey()
            TriggerEvent('Society.RemoveMoney', job.name, cfg.NewKeyPrice)
        end)
    else
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Sõiduk ei kuulu sulle ega sinu fraktsioonile!')
    end
end)
