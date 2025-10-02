RegisterCommand('msg', function(source, args, rawCommand)
    local kPlayer = KKF.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.isAdmin() then
            if Player(kPlayer.source).state.adminMode then
                if #args >= 2 then
                    local Target = KKF.GetPlayerFromId(args[1])

                    if Target then
                        local message = table.concat(args, ' ', 2)
                        TriggerClientEvent('chatMessage', Target.source, 'ADMIN SÕNUM', 'error', message)

                        local Players = KKF.GetPlayers()

                        for i = 1, #Players, 1 do
                            if Players[i].isAdmin() and Player(Players[i].source).state.adminMode then	
                                TriggerClientEvent('chatMessage', Players[i].source, 'ADMIN SÕNUM | ID: ' .. Target.source .. ' | ADMIN: ' .. kPlayer.name, 'error', message)
                            end
                        end
                    else
                        TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Valitud mängija ei ole enam aktiivne!')
                    end
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Sisestage korrektsed andmed!')
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end)

--[[RegisterCommand('report', function(source, args, rawCommand)
    local kPlayer = KKF.GetPlayerFromId(source)

    if kPlayer then
        if #args > 0 then
            local message = table.concat(args, ' ', 1)
            local Players = KKF.GetPlayers()

            for i = 1, #Players, 1 do
                if Players[i].isAdmin() and Player(Players[i].source).state.adminMode then	
                    if Players[i].source ~= kPlayer.source then
                        TriggerClientEvent('chatMessage', Players[i].source, 'KAEBUS | ID: ' .. kPlayer.source .. ' | PID: ' .. kPlayer.identifier .. ' | KARAKTER: ' .. kPlayer.name, 'info', message)
                    end
                end
            end

            TriggerClientEvent('chatMessage', kPlayer.source, 'KAEBUS', 'info', message)
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Sisestage kaebuse sisu!')
        end
    end
end)

RegisterCommand('a', function(source, args, rawCommand)
    local kPlayer = KKF.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.isAdmin() then
			if Player(kPlayer.source).state.adminMode then
                if #args > 0 then
                    local message = table.concat(args, ' ', 1)
                    local Players = KKF.GetPlayers()

                    for i = 1, #Players, 1 do
                        if Players[i].isAdmin() and Player(Players[i].source).state.adminMode then	
                            TriggerClientEvent('chatMessage', Players[i].source, 'MEESKOND | ' .. GetPlayerName(kPlayer.source), 'info', message)
                        end
                    end
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Sisestage sõnumi sisu!')
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end)]]