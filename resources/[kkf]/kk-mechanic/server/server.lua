RegisterNetEvent('kk-mechanic:client:onFixKitUse', function(networkId)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        lib.callback.await('kk-mechanic:fixVehicle', xPlayer.source, networkId)
    end
end)

local function canInteract(job)
    for k,v in pairs(cfg.locations) do
        if job == k then
            return true
        end
    end

    return false
end

lib.callback.register('kk-mechanic:requestDeliveries', function(source, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local returnable = nil

    if xPlayer then
        if canInteract(xPlayer.job.name) and xPlayer.job.onDuty then
            MySQL.Async.fetchAll('SELECT id, items FROM mechanic_deliveries WHERE plate = ? AND job = ?', {plate, xPlayer.job.name}, function(result)
                if result[1] then
                    returnable = json.decode(result[1].items)
                else
                    returnable = false
                end
            end)
        else
            returnable = false
        end
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

lib.callback.register('kk-mechanic:buyPart', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    local returnable = nil

    if xPlayer then
        if canInteract(xPlayer.job.name) and xPlayer.job.onDuty then
            TriggerEvent('Society.GetMoney', xPlayer.job.name, function(money)
                if money >= args.price then
                    MySQL.Async.fetchAll('SELECT id, items FROM mechanic_deliveries WHERE plate = ? AND job = ?', {args.plate, xPlayer.job.name}, function(result)
                        if result[1] then
                            local currentData = json.decode(result[1].items)
                            currentData[#currentData + 1] = {item = args.part .. '_' .. args.mod}

                            exports['kk-scripts']:sendSocietyLog(xPlayer.source, 'SÕIDUKI JUPID', 'Soetas jupi ' .. ESX.GetItemLabel(args.part .. '_' .. args.mod) .. ' $' .. args.price .. ' eest sõidukile ' .. args.plate .. '.')
                            TriggerEvent('Society.RemoveMoney', xPlayer.job.name, args.price)

                            MySQL.Async.execute('UPDATE mechanic_deliveries SET items = ? WHERE plate = ? AND job = ?', {json.encode(currentData), args.plate, xPlayer.job.name}, function(result)
                                returnable = true
                            end)
                        else
                            local currentData = {}
                            currentData[#currentData + 1] = {item = args.part .. '_' .. args.mod}

                            exports['kk-scripts']:sendSocietyLog(xPlayer.source, 'SÕIDUKI JUPID', 'Soetas jupi ' .. ESX.GetItemLabel(args.part .. '_' .. args.mod) .. ' $' .. args.price .. ' eest sõidukile ' .. args.plate .. '.')
                            TriggerEvent('Society.RemoveMoney', xPlayer.job.name, args.price)

                            MySQL.insert('INSERT INTO mechanic_deliveries (plate, items, job) VALUES (?, ?, ?)', {args.plate, json.encode(currentData), xPlayer.job.name}, function(result)
                                returnable = true
                            end)
                        end
                    end)
                else
                    returnable = false
                end
            end)
        else
            returnable = false
        end
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

RegisterNetEvent('kk-mechanic:server:takeItem', function(args)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        MySQL.Async.fetchAll('SELECT id, items FROM mechanic_deliveries WHERE plate = ? AND job = ?', {args.plate, xPlayer.job.name}, function(result)
            if result[1] then
                local currentData = json.decode(result[1].items)

                local canTake = function(item)
                    for k,v in pairs(currentData) do
                        if v.item == item then return k end
                    end

                    return false
                end

                local possible = canTake(args.item)

                if possible then
                    if xPlayer.canCarryItem(args.item, 1) then
                        table.remove(currentData, possible)

                        MySQL.Async.execute('UPDATE mechanic_deliveries SET items = ? WHERE plate = ? AND job = ?', {json.encode(currentData), args.plate, xPlayer.job.name}, function(result)
                            exports['kk-scripts']:sendSocietyLog(xPlayer.source, 'SÕIDUKI JUPID', 'Väljastas sõiduki ' .. args.plate .. ' jupi ' .. ESX.GetItemLabel(args.item) .. '.')
                            exports.ox_inventory:AddItem(xPlayer.source, args.item, 1, {plate = args.plate})
                        end)
                    else
                        TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Teil ei ole taskus piisavalt ruumi!')
                    end
                end
            end
        end)
    end
end)

lib.callback.register('kk-mechanic:requestData', function(source, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local returnable_logbook = nil
    local returnable_degradation = nil

    if xPlayer then
        if canInteract(xPlayer.job.name) and xPlayer.job.onDuty then
            MySQL.Async.fetchScalar('SELECT logbook FROM user_vehicles WHERE plate = ?', {plate}, function(logbook_result)
                if logbook_result then
                    returnable_logbook = json.decode(logbook_result)
                else
                    returnable_logbook = false
                end
            end)
            
            MySQL.Async.fetchScalar('SELECT degradation FROM user_vehicles WHERE plate = ?', {plate}, function(degradation_result)
                if degradation_result then
                    returnable_degradation = json.decode(degradation_result)
                else
                    returnable_degradation = false
                end
            end)
        else
            returnable_logbook = false
            returnable_degradation = false
        end
    else
        returnable_logbook = false
        returnable_degradation = false
    end

    while returnable_logbook == nil or returnable_degradation == nil do Wait(50) end
    return returnable_logbook, returnable_degradation
end)


RegisterNetEvent('kk-mechanic:server:addLog', function(plate, message)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        MySQL.Async.fetchAll('SELECT logbook FROM user_vehicles WHERE plate = ?', {plate}, function(result)
            if result[1] then
                local currentData = json.decode(result[1].logbook)
                currentData[#currentData + 1] = {msg = message, time = os.date('%Y-%m-%d %X'), worker = xPlayer.name, company = xPlayer.job.label}

                MySQL.Async.execute('UPDATE user_vehicles SET logbook = ? WHERE plate = ?', {json.encode(currentData), plate}, function(result)
                    returnable = true
                end)
            else
                returnable = false
            end
        end)
    end
end)

RegisterNetEvent('kk-mechanic:server:startRepair')
AddEventHandler('kk-mechanic:server:startRepair', function()
	local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer then
        if canInteract(xPlayer.job.name) and xPlayer.job.onDuty then
            local xItem = exports.ox_inventory:GetItem(xPlayer.source, 'fixkit')

            if xItem.count > 0 then
                TriggerClientEvent('kk-mechanic:client:startRepair', xPlayer.source)
            else
                TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Teil ei ole paranduskomplekti!')
            end
        end
    end
end)

ESX.RegisterUsableItem('fixkit', function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer then
        TriggerClientEvent('kk-mechanic:client:startRepair', xPlayer.source)
    end
end)