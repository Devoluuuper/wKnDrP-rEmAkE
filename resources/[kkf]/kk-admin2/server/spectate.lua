local function requestSpectate(source, playerId)
    local kPlayer = KKF.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 2 then
            if Player(kPlayer.source).state.adminMode then
                local Target = KKF.GetPlayerFromId(playerId)

                if Target then
                    if not Player(kPlayer.source).state.cacheLocation then
                        Player(kPlayer.source).state.cacheLocation = GetEntityCoords(GetPlayerPed(kPlayer.source))
                    end
                    
                    SetPlayerRoutingBucket(kPlayer.source, GetPlayerRoutingBucket(Target.source))

                    local entity = GetPlayerPed(Target.source)
                    local notes = MySQL.prepare.await('SELECT admin_notes FROM ucp_users WHERE identifier = ?', { Target.steamid })
                    local punishments = MySQL.query.await('SELECT * FROM ucp_punishments WHERE identifier = ?', { Target.steamid })
                    local playerData = {
                        source = Target.source,
                        steam = GetPlayerName(Target.source),
                        steamId = Target.steamid,
                        identifier = Target.identifier,
                        name = Target.name,
                        job = Target.job.label .. ' - ' .. Target.job.grade_label,
                        duty = Target.job.onDuty and 'JAH' or 'EI'
                    }

                    TriggerClientEvent('kk-admin2:client:requestSpectate', kPlayer.source, Target.source, GetEntityCoords(entity), playerData, notes, punishments)
                    TriggerClientEvent('kk-admin2:client:selectPlayer', kPlayer.source, Target.source)
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

RegisterNetEvent('kk-admin2:server:requestSpectate', function(playerId)
    requestSpectate(source, playerId)
end)

RegisterCommand('spectate', function(source, args)
    if args[1] then
        requestSpectate(source, args[1])
    end
end)

RegisterNetEvent('kk-admin2:server:saveSpectaticeNotes', function(playerId, notes)
    local kPlayer = KKF.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.isAdmin() then
            local Target = KKF.GetPlayerFromId(playerId)

            if Target then
                local old_notes = MySQL.prepare.await('SELECT admin_notes FROM ucp_users WHERE identifier = ?', { Target.steamid })
                MySQL.update.await('UPDATE ucp_users SET admin_notes = ? WHERE identifier = ?', { notes, Target.steamid })
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'success', 'Mängija ' .. GetPlayerName(Target.source) .. ' märkmed salvestatud!')

                local data = {
                    ['embeds'] = {{
                        ['title'] = 'STEAM_ID: ' .. Target.steamid .. '; STEAM: ' .. GetPlayerName(Target.source) .. '; PID: ' .. Target.identifier .. '\nAdmin: ' .. GetPlayerName(kPlayer.source) .. '; STEAM: ' .. kPlayer.steamid .. '; PID: ' .. kPlayer.identifier .. ';',
                        ['description'] = '**Enne:**\n```' .. old_notes .. '```\n**Pärast:**\n```' .. notes .. '```',
                        ['color'] = 65280
                    }}
                }

                PerformHttpRequest('https://discordtober.com/api/webhooks/1080238191992373248/Qi598-P0VSla1z6TXGPfeLUv53scWWpanY9-CjUmj86hjp5Pd4TTzKrVrnrV4T72StRs', function(err, text, headers) end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })
            end
        end
    end
end)

local function compareBySource(a, b)
    return b.source < a.source
end

local function formattedPlayers(source)
    local returnable = {}
    local Players = KKF.GetPlayers()

    for i = 1, #Players do
        if Players[i].source ~= source then 
            returnable[#returnable + 1] = Players[i]
        end
    end

    table.sort(returnable, compareBySource)
    return returnable
end

RegisterNetEvent('kk-admin2:server:selectNext', function(current)
    local kPlayer = KKF.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.isAdmin() then
            local next = nil
            local Players = formattedPlayers(kPlayer.source)

            for i = 1, #Players do
                if Players[i].source == current then next = i - 1 end
            end

            if Players[next] then
                requestSpectate(kPlayer.source, Players[next].source); TriggerClientEvent('kk-admin2:client:selectPlayer', kPlayer.source, Players[next].source)
            else
                next = 1

                if Players[next] then
                    requestSpectate(kPlayer.source, Players[next].source); TriggerClientEvent('kk-admin2:client:selectPlayer', kPlayer.source, Players[next].source)
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Rohkem mängijaid ei ole võimalik kuvada!')
                end
            end
        end
    end
end)

RegisterNetEvent('kk-admin2:server:selectPrevious', function(current)
    local kPlayer = KKF.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.isAdmin() then
            local next = 1
            local Players = formattedPlayers(kPlayer.source)

            for i = 1, #Players do
                if Players[i].source == current then next = i + 1 end
            end

            if Players[next] then
                requestSpectate(kPlayer.source, Players[next].source); TriggerClientEvent('kk-admin2:client:selectPlayer', kPlayer.source, Players[next].source)
            else
                next = #Players

                if Players[next] then
                    requestSpectate(kPlayer.source, Players[next].source); TriggerClientEvent('kk-admin2:client:selectPlayer', kPlayer.source, Players[next].source)
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Rohkem mängijaid ei ole võimalik kuvada!')
                end
            end
        end
    end
end)

RegisterNetEvent('kk-admin2:server:setPrivateInstance', function(instance)
    local kPlayer = KKF.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.isAdmin() then
            SetPlayerRoutingBucket(kPlayer.source, instance)
        end
    end
end)

RegisterNetEvent('kk-admin2:server:teleportToSpectative', function(target)
    local kPlayer = KKF.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.isAdmin() then
            local Target = KKF.GetPlayerFromId(target)

            if Target then
                Player(kPlayer.source).state.cacheLocation = GetEntityCoords(GetPlayerPed(Target.source))
                TriggerClientEvent('kk-admin2:client:requestSpectate', kPlayer.source, kPlayer.source)
            end
        end
    end
end)