local activeBank = 'none'
local cooldownActive = false

lib.callback.register('kk-bankrobbery:fetchLocations', function(source)
    return cfg.bankLocations
end)

RegisterNetEvent('kk-bankrobbery:server:taskReset', function(bank, taskId)
    cfg.bankLocations[bank].tasks[taskId].currentUser = 0
end)

AddEventHandler('KKF.Player.Dropped', function(playerId, xPlayer)
    local xPlayer = KKF.GetPlayerFromId(playerId)
    
    for k,v in pairs(cfg.bankLocations) do
        if v.controller ~= 0 then
            if v.controller == xPlayer.identifier then
                activeBank = 'none'
                cfg.bankLocations[k].hacked = false
                cfg.bankLocations[k].controller = 0
        
                for k2,v2 in pairs(cfg.bankLocations[k].tasks) do
                    cfg.bankLocations[k].tasks[k2].done = false
                    cfg.bankLocations[k].tasks[k2].currentUser = 0
                end
        
                TriggerClientEvent('kk-robberies:client:setBlip', -1, false)
                TriggerClientEvent('kk-bankrobbery:client:reloadBanks', -1, cfg.bankLocations)
                cooldownActive = true

                SetTimeout(60 * 60000, function()
                    cooldownActive = false
                end)
            end
        end
    end
end)

RegisterNetEvent('kk-bankrobbery:server:endRobbery', function(bank)
    local xPlayer = KKF.GetPlayerFromId(source)

    if xPlayer then
        if activeBank ~= 'none' then
            activeBank = 'none'
            cfg.bankLocations[bank].hacked = false
            cfg.bankLocations[bank].controller = 0

            for k,v in pairs(cfg.bankLocations[bank].tasks) do
                cfg.bankLocations[bank].tasks[k].done = false
                cfg.bankLocations[bank].tasks[k].currentUser = 0
            end

            TriggerClientEvent('kk-robberies:client:setBlip', -1, false)
            TriggerClientEvent('kk-bankrobbery:client:reloadBanks', -1, cfg.bankLocations)
            cooldownActive = true

            SetTimeout(60 * 60000, function()
                cooldownActive = false
            end)
        end
    end
end)

lib.callback.register('kk-bankrobbery:tryTask', function(source, bank, taskId)
    local xPlayer = KKF.GetPlayerFromId(source)
    local returnable = nil

    if xPlayer then
        local currentTask = cfg.bankLocations[bank].tasks[taskId]

        if not cooldownActive then
            if currentTask.currentUser == 0 and (currentTask.type == 'hack' or activeBank == bank) and not currentTask.done then
                if currentTask.type == 'hack' then
                    cfg.bankLocations[bank].controller = xPlayer.identifier
                end

                currentTask.currentUser = xPlayer.identifier
                TriggerClientEvent('kk-bankrobbery:client:reloadBanks', -1, cfg.bankLocations)
                
                returnable = true
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

lib.callback.register('kk-bankrobbery:taskDone', function(source, bank, taskId)
    local xPlayer = KKF.GetPlayerFromId(source)
    local returnable = nil

    if xPlayer then
        local currentTask = cfg.bankLocations[bank].tasks[taskId]

        if currentTask.type == 'hack' then
            xPlayer.removeInventoryItem(currentTask.item, 1); activeBank = bank; 
            currentTask.done = true; TriggerClientEvent('kk-bankrobbery:client:reloadBanks', -1, cfg.bankLocations)

            TriggerClientEvent('kk-dispatch:client:sendDispatch', xPlayer.source, '10-05', 'police', string.upper(cfg.bankLocations[bank].name) .. ' KÄIVITUS VAIKNE ALARM')
            TriggerClientEvent('kk-bankrobbery:client:setDoorHeading', -1, currentTask.pos, currentTask.door)

            for k,v in pairs(KKF.GetPlayers()) do
                local xTarget = KKF.GetPlayerFromId(v)
        
                if xTarget.job.name == 'police' and xTarget.job.onDuty then
                    TriggerClientEvent('kk-robberies:client:setBlip', xTarget.source, true, GetEntityCoords(GetPlayerPed(xPlayer.source)))
                end
            end

            returnable = true
        elseif currentTask.type == 'drill' then
            currentTask.done = true; TriggerClientEvent('kk-bankrobbery:client:reloadBanks', -1, cfg.bankLocations)
            local rewards = cfg.bankLocations[bank].rewards

            for i = 0, 2 do
                local randomName = math.random(1, #rewards)
                local item = rewards[randomName]
                local count = math.random(item.min, item.max)
    
                if item.name ~= 'money' then
                    if xPlayer.canCarryItem(item.name, count) then
                        xPlayer.addInventoryItem(item.name, count)
                        exports['kk-scripts']:sendLog(xPlayer.identifier, 'RÖÖVID', 'Sai pangaröövilt eseme ' .. item.name .. ' ' .. count .. 'tk.')
                    else
                        TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Teil ei ole taskus piisavalt ruumi! Kukutasid esemed põrandale')

                        exports.ox_inventory:CustomDrop('Items #' .. math.random(00000, 99999), {
                            {item.name, count}
                        }, GetEntityCoords(GetPlayerPed(xPlayer.source)))
                    end
                else
                    xPlayer.addAccountMoney(item.name, count)
                    exports['kk-scripts']:sendLog(xPlayer.identifier, 'RÖÖVID', 'Sai pangaröövilt $' .. count .. '.')
                end
            end

            returnable = true
        elseif currentTask.type == 'bomb' then
            xPlayer.removeInventoryItem(currentTask.item, 1)
            currentTask.done = true; TriggerClientEvent('kk-bankrobbery:client:reloadBanks', -1, cfg.bankLocations)

            SetTimeout(10000, function()
                TriggerClientEvent('kk-bankrobbery:client:explodeBomb', -1, bombPos, currentTask.door)
            end)

            returnable = true
        elseif currentTask.type == 'collect' then
            currentTask.done = true; TriggerClientEvent('kk-bankrobbery:client:reloadBanks', -1, cfg.bankLocations)

            local reward = cfg.bankLocations[bank].moneyReward
            local count = math.random(reward.min, reward.max)

            xPlayer.addAccountMoney('money', count)
            exports['kk-scripts']:sendLog(xPlayer.identifier, 'RÖÖVID', 'Sai pangaröövilt $' .. count .. '.')

            activeBank = 'none'
            cfg.bankLocations[bank].hacked = false
            cfg.bankLocations[bank].controller = 0
    
            for k,v in pairs(cfg.bankLocations[bank].tasks) do
                cfg.bankLocations[bank].tasks[k].done = false
                cfg.bankLocations[bank].tasks[k].currentUser = 0
            end
    
            TriggerClientEvent('kk-robberies:client:setBlip', -1, false)
            TriggerClientEvent('kk-bankrobbery:client:reloadBanks', -1, cfg.bankLocations)
            cooldownActive = true

            SetTimeout(60 * 60000, function()
                cooldownActive = false
            end)

            returnable = true
        end
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)