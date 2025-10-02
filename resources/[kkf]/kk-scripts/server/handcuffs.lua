local cuffedPlayers = {}
lib.callback.register('kk-handcuffs:getStatus', function(source)
    return cuffedPlayers[source] or false
end)

RegisterNetEvent('kk-handcuffs:server:startCuffing')
AddEventHandler('kk-handcuffs:server:startCuffing', function(target)
    local xPlayer = KKF.GetPlayerFromId(source)
    local xTarget = KKF.GetPlayerFromId(target)

    if xPlayer and xTarget then
        if xPlayer.job.name == 'police' then
            cuffedPlayers[target] = true
            TriggerClientEvent('kk-handcuffs:client:startTargetCuffing', xPlayer.source)
            TriggerClientEvent('kk-handcuffs:client:startPlayerCuffing', xTarget.source, xPlayer.source)

            exports['kk-scripts']:sendLog(xPlayer.identifier, 'KÄERAUAD', 'Pani käeraudu.', xTarget.identifier)
        else
            TriggerClientEvent('kk-handcuffs:client:startPlayerCuffing', xTarget.source, xPlayer.source)
        end
    else
        print(('kk-handcuffs: Error in startCuffing, invalid players (source: %s, target: %s)'):format(source, target))
    end
end)

RegisterNetEvent('kk-handcuffs:server:setSoftCuffs')
AddEventHandler('kk-handcuffs:server:setSoftCuffs', function(target)
    local xPlayer = KKF.GetPlayerFromId(source)
    local xTarget = KKF.GetPlayerFromId(target)

    if xPlayer and xTarget then
        cuffedPlayers[target] = 'soft'
        Player(target).state:set("isCuffed", 'soft', true)
        TriggerClientEvent('kk-handcuffs:client:setSoftCuffs', xTarget.source, xPlayer.source)

        exports['kk-scripts']:sendLog(xPlayer.identifier, 'KÄERAUAD', 'Pani pehmed käeraud.', xTarget.identifier)
    else
        print(('kk-handcuffs: Error in setSoftCuffs (source: %s, target: %s)'):format(source, target))
    end
end)

RegisterNetEvent('kk-handcuffs:server:setHardCuffs')
AddEventHandler('kk-handcuffs:server:setHardCuffs', function(target)
    local xPlayer = KKF.GetPlayerFromId(source)
    local xTarget = KKF.GetPlayerFromId(target)

    if xPlayer and xTarget then
        cuffedPlayers[target] = 'hard'
        Player(target).state:set("isCuffed", 'hard', true)
        TriggerClientEvent('kk-handcuffs:client:setHardCuffs', xTarget.source, xPlayer.source)

        exports['kk-scripts']:sendLog(xPlayer.identifier, 'KÄERAUAD', 'Pani kõvad käeraud.', xTarget.identifier)
    else
        print(('kk-handcuffs: Error in setHardCuffs (source: %s, target: %s)'):format(source, target))
    end
end)


RegisterNetEvent('kk-handcuffs:server:unCuff')
AddEventHandler('kk-handcuffs:server:unCuff', function()
    local xPlayer = KKF.GetPlayerFromId(source)

    if xPlayer then
        cuffedPlayers[source] = false
        Player(source).state:set("isCuffed", false, true)
        TriggerClientEvent('kk-handcuffs:client:clearPedTasks', xPlayer.source)

        exports['kk-scripts']:sendLog(xPlayer.identifier, 'KÄERAUAD', 'Rabeles käeraudadest välja.')
    end
end)


RegisterNetEvent('kk-handcuffs:server:unlockLockpick')
AddEventHandler('kk-handcuffs:server:unlockLockpick', function(target)
    local xPlayer = KKF.GetPlayerFromId(source)
    local xTarget = KKF.GetPlayerFromId(target)

    if xPlayer and xTarget then
        cuffedPlayers[target] = false
        Player(target).state:set("isCuffed", false, true)

        TriggerClientEvent('kk-handcuffs:client:startTargetUncuffing', xPlayer.source)
        TriggerClientEvent('kk-handcuffs:client:clearPedTasks', xTarget.source)
        TriggerClientEvent('kk-handcuffs:client:startPlayerUnCuffing', xTarget.source, xPlayer.source)

        exports['kk-scripts']:sendLog(xPlayer.identifier, 'KÄERAUAD', 'Eemaldas käerauad muukrauaga.', xTarget.identifier)
    else
        TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Teil ei ole muukrauda!')
    end
end)



RegisterCommand('auncuff', function(source, args)
    local xPlayer = KKF.GetPlayerFromId(source)
    local targetId = tonumber(args[1])

    if not xPlayer then
        print(('auncuff: Invalid source (ID: %s)'):format(source))
        return
    end

    if not xPlayer.IsAdmin() then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Teil puudub luba selle käsu kasutamiseks!')
        return
    end

    if not targetId or not GetPlayerName(targetId) then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Palun sisestage kehtiv mängija ID!')
        return
    end

    local xTarget = KKF.GetPlayerFromId(targetId)
    if xTarget then
        cuffedPlayers[targetId] = false
        Player(targetId).state:set("isCuffed", false, true)
        TriggerClientEvent('kk-handcuffs:client:clearPedTasks', targetId)

        TriggerClientEvent('KKF.UI.ShowNotification', source, 'success', ('Eemaldasite mängija [%s] käerauad!'):format(targetId))
        TriggerClientEvent('KKF.UI.ShowNotification', targetId, 'info', 'Admin eemaldas teie käerauad.')

        exports['kk-scripts']:sendLog(xPlayer.identifier, 'ADMIN', ('Eemaldas mängija [%s] käerauad.'):format(targetId))
    else
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Mängijat ei leitud!')
    end
end, false)
