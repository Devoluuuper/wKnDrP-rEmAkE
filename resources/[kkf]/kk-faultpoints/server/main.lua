RegisterNetEvent('kk-faultpoints:server:startExam')
AddEventHandler('kk-faultpoints:server:startExam', function()
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)

    if xPlayer then
        local price = Config.Price

        if xPlayer.getMoney() >= price or xPlayer.getAccount('bank').money >= price then
            MySQL.Async.fetchAll('SELECT license, points FROM license_points WHERE pid = ? AND license = ?', { xPlayer.identifier, 'dmv' }, function(result)
                if result and result[1] then
                    if result[1].points <= 0 then
                        TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Ei saa lunastada veapunkte! (Sul on hetkel ' .. result[1].points .. ' juhiloa veapunkti)')
                    else
                        TriggerClientEvent('kk-faultpoints:client:startExam', src)
                        if xPlayer.getMoney() >= price then
                            xPlayer.removeMoney(price)
                        else
                            xPlayer.removeAccountMoney('bank', price)
                        end
                    end
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Tundub, et sul ei ole ühetgi veapunkti!')
                end
            end)
        else
            TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Ei ole piisavalt raha!')
        end
    end
end)



RegisterNetEvent('kk-faultpoints:server:complete')
AddEventHandler('kk-faultpoints:server:complete', function()
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)

    if xPlayer then
        MySQL.Async.fetchAll('SELECT * FROM license_points', {}, function(result)
            for k,v in pairs(result) do
                local currentLicense = result[k]

                if currentLicense.points > 0 then
                    MySQL.Sync.execute('UPDATE license_points SET points = ? WHERE pid = ? AND license = ?', { currentLicense.points - 1, currentLicense.pid, currentLicense.license })
                end
            end
        end)
    end
end)
