local prisoners = {}

SetTimeout(500, function()
    local Players = ESX.GetPlayers()

    for i = 1, #Players do
        local jail = MySQL.prepare.await('SELECT jail FROM ucp_users WHERE identifier = ?', {Players[i].steamid})

        if jail > 0 then
            prisoners[Players[i].steamid] = jail
            TriggerClientEvent('kk-admin2:client:jailPerson', Players[i].source, prisoners[Players[i].steamid], true)
        end
    end
end)

CreateThread(function()
    while true do
        for index, time in pairs(prisoners) do
            if time > 0 then
                local kPlayer = ESX.GetPlayerFromSteamId(index)

                if kPlayer then
                    prisoners[kPlayer.steamid] -= 1
                    MySQL.update.await('UPDATE ucp_users SET jail = ? WHERE identifier = ?', {prisoners[kPlayer.steamid], kPlayer.steamid})
                    TriggerClientEvent('chatMessage', kPlayer.source, 'AJAIL' , 'info', 'Teil on jäänud ' .. prisoners[kPlayer.steamid] .. ' minutit vanglas.')
                    TriggerClientEvent('kk-admin2:client:doCheck', kPlayer.source)

                    if prisoners[kPlayer.steamid] == 0 then
                        prisoners[kPlayer.steamid] = nil
                        MySQL.update.await('UPDATE ucp_users SET jail = ? WHERE identifier = ?', {0, kPlayer.steamid})
                        TriggerClientEvent('kk-admin2:client:endJail', kPlayer.source)
                    end
                end
            end
        end

        Wait(60000)
    end
end)

AddEventHandler('KKF.Player.Loaded', function(source)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        local jail = MySQL.prepare.await('SELECT jail FROM ucp_users WHERE identifier = ?', {kPlayer.steamid})

        if jail > 0 then
            prisoners[kPlayer.steamid] = jail
            TriggerClientEvent('kk-admin2:client:jailPerson', kPlayer.source, prisoners[kPlayer.steamid], true)
        end
    end
end)

AddEventHandler('KKF.Player.Dropped', function(source)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if prisoners[kPlayer.steamid] then
            prisoners[kPlayer.steamid] = nil
        end
    end
end)

AddEventHandler('kk-admin2:server:setJailed', function(kPlayer, time)
    prisoners[kPlayer.steamid] = time
    TriggerClientEvent('kk-admin2:client:jailPerson', kPlayer.source, time)
    exports['kk-admin2']:adminNotification('Mängija ' .. GetPlayerName(kPlayer.source) .. ' vangistati, Type: POL!') 
    exports['kk-admin2']:insertPunishment(kPlayer.steamid, 'AJAIL', 'XXX', GetPlayerName(kPlayer.source), time .. ' minutit, Type: POL.')
end)

local function jailPerson(source, target, time)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 2 then
            if Player(kPlayer.source).state.adminMode then
                local Target = ESX.GetPlayerFromId(target)

                if Target then
                    if exports['kk-admin2']:canPunish(kPlayer.steamid, Target.steamid) or kPlayer.adminLevel >= 5 then
                        if time then
                            time = tonumber(time)
                            
                            if time > 0 then
                                local affectedRows = MySQL.update.await('UPDATE ucp_users SET jail = jail + ? WHERE identifier = ?', {time, Target.steamid})
                
                                if affectedRows then
                                    prisoners[Target.steamid] = time
                                    TriggerClientEvent('kk-admin2:client:jailPerson', Target.source, time)
                                    exports['kk-admin2']:adminNotification('Mängija ' .. GetPlayerName(Target.source) .. ' vangistati!') 
                                    exports['kk-admin2']:insertPunishment(Target.steamid, 'AJAIL', 'XXX', GetPlayerName(kPlayer.source), time .. ' minutit')

                                    exports['kk-scripts']:sendLog(kPlayer.identifier, 'A-TEAM', 'Vangistas mängija ' .. time .. ' minutiks.', Target.identifier)
                                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'success', 'Vangistasite mängija ' .. Target.name .. ' ' .. time .. ' minutiks!')
                                else
                                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Tekkis tõrge rea muutmisel!')
                                end
                            else
                                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Sisestage korrektne aeg!')
                            end
                        else
                            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Sisestage korrektne aeg!')
                        end
                    else
                        TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
                    end
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Valitud mängija ei ole enam aktiivne!')
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterNetEvent('kk-admin2:server:jailPerson', function(target, time)
    jailPerson(source, target, time)
end)

RegisterCommand('ajail', function(source, args)
    if args[1] and args[2] then
        jailPerson(source, args[1], args[2])
    end
end)

local function unjailPerson(source, target)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 3 then
            if Player(kPlayer.source).state.adminMode then
                local Target = ESX.GetPlayerFromId(target)

                if Target then
                    if prisoners[Target.steamid] then
                        prisoners[Target.steamid] = nil
                        exports['kk-scripts']:sendLog(kPlayer.identifier, 'A-TEAM', 'Eemaldas ajaili STEAM: ' .. Target.steamid, Target.identifier)
                        exports['kk-admin2']:adminNotification('Mängija ' .. GetPlayerName(Target.source) .. ' eemaldati vangistusest!') 
                        MySQL.update.await('UPDATE ucp_users SET jail = ? WHERE identifier = ?', {0, Target.steamid})
                        TriggerClientEvent('kk-admin2:client:endJail', Target.source)
                    else
                        TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Valitud mängija ei ole admin jailis!')
                    end
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Valitud mängija ei ole enam aktiivne!')
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterNetEvent('kk-admin2:server:unjailPerson', function(target)
    unjailPerson(source, target)
end)

RegisterCommand('unajail', function(source, args)
    if args[1] then
        unjailPerson(source, args[1])
    end
end)