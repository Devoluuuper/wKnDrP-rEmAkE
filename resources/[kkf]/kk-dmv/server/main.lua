RegisterNetEvent('kk-dmv:server:startExam')
AddEventHandler('kk-dmv:server:startExam', function()
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)

    if not xPlayer then return end

    if xPlayer.licenses['dmv'] then
        TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Juba omad autojuhiluba!')
        return
    end

    local price = Config.Price + KKF.Math.Round(KKF.Math.Percent(exports['kk-taxes']:getTax('primary').value, Config.Price))

    if xPlayer.getMoney() < price and xPlayer.getAccount('bank').money < price then
        TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Pole piisavalt raha!')
        return
    end

    local paymentType = xPlayer.getMoney() >= price and 'money' or 'bank'

    MySQL.Async.fetchAll('SELECT license, points FROM license_points WHERE pid = ? AND license = ?', { xPlayer.identifier, 'dmv' }, function(result)
        if not result or not result[1] then
            TriggerClientEvent('kk-dmv:client:startExam', src)
            xPlayer.removeAccountMoney(paymentType, price)
            return
        end

        if result[1].points > 0 then
            TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Ei saa juhilube teha! (Sul on ' .. result[1].points .. ' juhiloa veapunkti)')
        else
            TriggerClientEvent('kk-dmv:client:startExam', src)
            xPlayer.removeAccountMoney(paymentType, price)
        end
    end)
end)


RegisterNetEvent('kk-dmv:server:complete')
AddEventHandler('kk-dmv:server:complete', function()
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)

    if xPlayer then
        xPlayer.giveLicense('dmv')
    end
end)