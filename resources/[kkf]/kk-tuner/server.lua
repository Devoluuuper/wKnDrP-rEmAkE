
lib.callback.register('kk-tuner:search', function(source, context)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if xPlayer.job.name == 'tunershop' then
            local results = {
                vehicles = {}
            }

            MySQL.Async.fetchAll('SELECT e.pid, e.brand, e.name, e.class, e.price, e.model, p.firstname, p.lastname, e.sold FROM vehicleshop_custom e LEFT JOIN users p ON e.pid = p.pid WHERE LOWER(e.brand) LIKE @query OR LOWER(e.name) LIKE @query OR p.firstname LIKE @query OR p.lastname LIKE @query OR e.pid LIKE @query LIMIT 10', {
                ['@query'] = string.lower('%' .. context .. '%'),
            }, function(result)
                for k, v in pairs(result) do
                    local ownerName = v.firstname .. ' ' .. v.lastname .. ' (' .. v.pid .. ')'
                    v.ownername = ownerName
                    v.sold_status = v.sold and "MÜÜDÜD" or "SAADAVAL"
                    v.sold = nil -- Eemaldab tarbetu andmevälja

                end

                results.vehicles = result
                returnable = results
            end)
        else
            returnable = {}
        end
    else
        
        returnable = {}
    end

    while returnable == nil do Wait(50) end -- Ootab SQL-i vastust
    return returnable
end)



lib.callback.register('kk-tuner:searchimp', function(source, context)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if xPlayer.job.name == 'tunershop' then
            local results = {
                vehiclesimp = {}
            }

            -- SQL-i päring
            MySQL.Async.fetchAll('SELECT brand, name, class, price, model, stock FROM vehicleshop_import WHERE LOWER(name) LIKE @query OR LOWER(brand) LIKE @query LIMIT 20', {
                ['@query'] = '%' .. string.lower(context) .. '%',
            }, function(result)
                if result and #result > 0 then
                    for _, v in ipairs(result) do
                        table.insert(results.vehiclesimp, {
                            brand = v.brand,
                            name = v.name,
                            class = v.class,
                            price = v.price,
                            model = v.model,
                            stock = v.stock
                        })
                    end
                end
                returnable = results
            end)
        else
            returnable = {}
        end
    else
        returnable = {}
    end

    -- Oota SQL-i vastust
    while returnable == nil do
        Wait(50)
    end

    return returnable
end)



local cooldowns = {}


function SecondsToClock(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local seconds = seconds % 60
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end



lib.callback.register('kk-tuner:showVehicle', function(source, item)
    local src = source

    if not cooldowns[src] or os.time() - cooldowns[src] >= Config.CooldownDuration then
        TriggerClientEvent('kk-tuner:client:swapVehicle', src, item.model)
        cooldowns[src] = os.time()
    else
        local remainingCooldown = Config.CooldownDuration - (os.time() - cooldowns[src])
        local formattedCooldown = SecondsToClock(remainingCooldown)
        TriggerClientEvent('KKF.UI.ShowNotification', src, "error", 'Palun oota ' .. formattedCooldown .. ' enne järgmise sõiduki kuvamist')
    end
end)


lib.callback.register('kk-tuner:showVehicleImp', function(source, item)
    local src = source

    if not cooldowns[src] or os.time() - cooldowns[src] >= Config.CooldownDuration then
        TriggerClientEvent('kk-tuner:client:swapVehicleImp', src, item.model)
        cooldowns[src] = os.time()
    else
        local remainingCooldown = Config.CooldownDuration - (os.time() - cooldowns[src])
        local formattedCooldown = SecondsToClock(remainingCooldown)
        TriggerClientEvent('KKF.UI.ShowNotification', src, "error", 'Palun oota ' .. formattedCooldown .. ' enne järgmise sõiduki kuvamist')
    end
end)



lib.callback.register('kk-tuner:despawnveh', function(source, item)
    local src = source
    local player = KKF.GetPlayerFromId(src)

    if player.job.name == 'tunershop' then
        TriggerClientEvent('kk-tuner:client:despawnVehicle', -1, item.model)
    else
        TriggerClientEvent('KKF.UI.ShowNotification', src, "error", 'Sul pole selleks õigusi')
    end
end)



lib.callback.register('kk-tuner:despawnvehimp', function(source, item)
    local src = source
    local player = KKF.GetPlayerFromId(src)

    if player.job.name == 'tunershop' then
        TriggerClientEvent('kk-tuner:client:despawnVehicleImp', -1, item.model)
    else
        TriggerClientEvent('KKF.UI.ShowNotification', src, "error", 'Sul pole selleks õigusi')
    end
end)


local function findChargeableCurrencyType(price, cash, bank)
    cash = tonumber(cash) or 0
    bank = tonumber(bank) or 0
    price = tonumber(price) or 0

    if cash >= price then
        return 'cash'
    elseif bank >= price then
        return 'bank'
    else
        return nil
    end
end

local function round(number, decimalPlaces)
    local factor = 10 ^ decimalPlaces
    return math.floor(number * factor + 0.5) / factor
end

lib.callback.register('kk-tuner:server:sellShowroomVehicle', function(source, args)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local targetPlayer = KKF.GetPlayerFromIdentifier(args.pid)
    local model = args.model

    if not xPlayer or not targetPlayer then
        TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Mängijat ei leitud.")
        return
    end

    if #(GetEntityCoords(GetPlayerPed(src)) - GetEntityCoords(GetPlayerPed(targetPlayer.source))) > 3 then
        TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Mängija ei ole piisavalt lähedal.")
        return
    end

    MySQL.Async.fetchAll('SELECT * FROM vehicleshop_custom WHERE pid = @pid AND model = @model AND sold = 0 LIMIT 1', {
        ['@pid'] = args.pid,
        ['@model'] = model
    }, function(records)
        if #records == 0 then
            TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Sõidukit ei leitud või see on juba müüdud.")
            return
        end

        local record = records[1]
        local vehiclePrice = tonumber(record.price)
        local commission = KKF.Math.Round(vehiclePrice * Config.Commission)
        local plate = exports['kk-vehicleshop']:generatePlate()

        if targetPlayer.getAccount('money').money < vehiclePrice then
            TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Mängijal pole piisavalt raha.")
            return
        end

        targetPlayer.removeAccountMoney('money', vehiclePrice)

        MySQL.Async.execute('INSERT INTO user_vehicles (owner, plate, vehicle, stored, ownername, model) VALUES (?, ?, ?, ?, ?, ?)', {
            targetPlayer.identifier,
            plate,
            json.encode({ model = model, plate = plate }),
            1,
            targetPlayer.name,
            model 
        }, function(rowsChanged)
            if rowsChanged > 0 then
                MySQL.Async.execute('UPDATE vehicleshop_custom SET sold = 1 WHERE pid = @pid AND model = @model', {
                    ['@pid'] = args.pid,
                    ['@model'] = model
                })

                TriggerEvent('Society.AddMoney', xPlayer.job.name, commission)

                exports['kk-scripts']:sendLog(targetPlayer.identifier, 'SÕIDUKID', 'Soetas sõiduki (' .. model .. '; PLATE: ' .. plate .. ') $' .. vehiclePrice .. ' eest.')
                exports['kk-scripts']:sendSocietyLog(xPlayer.source, 'SÕIDUKI MÜÜK', 'MÜÜJA: ' .. xPlayer.getName() .. '; SÕIDUK: ' .. model .. '; HIND: ' .. vehiclePrice .. '; NUMBRIMÄRK: ' .. plate .. '')
                TriggerClientEvent('KKF.UI.ShowNotification', targetPlayer.source, "success", "Õnnitleme teid uue sõiduki puhul! Saate selle kätte garaažist!")
                TriggerClientEvent('KKF.UI.ShowNotification', src, "success", "Firma teenis eduka müügi eest vahendustasu $ " .. commission)
            else
                TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Andmebaasi sisestus ebaõnnestus.")
            end
        end)
    end)
end)

lib.callback.register('kk-tuner:server:sellShowroomVehicleImp', function(source, args)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local targetPlayer = KKF.GetPlayerFromIdentifier(args.pid)
    local model = args.model

    if not xPlayer or not targetPlayer then
        TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Mängijat ei leitud.")
        return
    end

    if #(GetEntityCoords(GetPlayerPed(src)) - GetEntityCoords(GetPlayerPed(targetPlayer.source))) > 3 then
        TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Mängija ei ole piisavalt lähedal.")
        return
    end

    MySQL.Async.fetchAll('SELECT * FROM vehicleshop_import WHERE model = @model AND stock > 0', {
        ['@model'] = model
    }, function(records)
        if #records == 0 then
            TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Sõidukit ei leitud või see on juba müüdud.")
            return
        end

        local record = records[1]
        local vehiclePrice = tonumber(record.price)
        local commission = KKF.Math.Round(vehiclePrice * Config.Commission)
        local plate = exports['kk-vehicleshop']:generatePlate()

        if targetPlayer.getAccount('money').money < vehiclePrice then
            TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Mängijal pole piisavalt raha.")
            return
        end

        targetPlayer.removeAccountMoney('money', vehiclePrice)

        MySQL.Async.execute('INSERT INTO user_vehicles (owner, plate, vehicle, stored, ownername, model) VALUES (?, ?, ?, ?, ?, ?)', {
            targetPlayer.identifier,
            plate,
            json.encode({model = model, plate = plate}),
            1,
            targetPlayer.name,
            model
        }, function(rowsChanged)
            if rowsChanged > 0 then
                MySQL.Async.execute('UPDATE vehicleshop_import SET stock = stock - 1 WHERE model = @model', {
                    ['@model'] = model
                })

                TriggerEvent('Society.AddMoney', xPlayer.job.name, commission)

                exports['kk-scripts']:sendLog(targetPlayer.identifier, 'SÕIDUKID', 'Soetas sõiduki (' .. model .. '; PLATE: ' .. plate .. ') $' .. vehiclePrice .. ' eest.')
                exports['kk-scripts']:sendSocietyLog(xPlayer.source, 'SÕIDUKI MÜÜK', 'MÜÜJA: ' .. xPlayer.getName() .. '; SÕIDUK: ' .. model .. '; HIND: ' .. vehiclePrice .. '; NUMBRIMÄRK: ' .. plate .. '')
                TriggerClientEvent('KKF.UI.ShowNotification', targetPlayer.source, "success", "Õnnitleme teid uue sõiduki puhul! Saate selle kätte garaažist!")
                TriggerClientEvent('KKF.UI.ShowNotification', src, "success", "Firma teenis eduka müügi eest vahendustasu $ " .. commission)
            else
                TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Andmebaasi sisestus ebaõnnestus.")
            end
        end)
    end)
end)


RegisterServerEvent('kk-tuner:server:showTablet', function()
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)

    if xPlayer and xPlayer.job.name == 'tunershop' then
        TriggerClientEvent('kk-tuner:client:showTablet', src, xPlayer.job.name)
    else

    end
end)

