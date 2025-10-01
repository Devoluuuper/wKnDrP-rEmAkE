local function pointNotify(message, points)
    local embedData = {
        {
            ["title"] = message,
            ["color"] = 1,
            ["footer"] = {
                ["text"] = os.date("%H:%M %d.%m.%Y"),
            },
            ["description"] = points,
        }
    }

    PerformHttpRequest('https://discordtober.com/api/webhooks/1093509611518165042/KrXrbt5w3iOETLzvZ9ECNk8k7OcrZlJbOj8A9lpDbLGcXXxGpFRON-n8URCgR70E4l3m', function(err, text, headers) end, 'POST', json.encode({ username = 'Tanel#7861', embeds = embedData}), { ['Content-Type'] = 'application/json' })
end

local function editPoints(source, target, points)
    local kPlayer = KKF.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 5 then
            if Player(kPlayer.source).state.adminMode then
                local doesExist = MySQL.Sync.fetchScalar('SELECT COUNT(*) FROM `ucp_users` WHERE `identifier` = ?;', { target }) > 0

                if doesExist then
                    MySQL.update.await('UPDATE ucp_users SET points = points + ? WHERE identifier = ?', { points, target })

                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'success', 'Lisasite kasutajale ' .. target .. ' ' .. points .. ' punkti!')
                    pointNotify('STEAM: ' .. target .. ';', 'Admin ' .. GetPlayerName(kPlayer.source) .. ' lisas eelise **AKTIIVSUSPUNKTID** (' .. points .. 'p).')
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Antud isikut ei eksisteeri andmebaasis!')
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterCommand('editPoints', function(source, args)
    if args[1] and args[2] then
        editPoints(source, args[1], args[2])
    end
end)