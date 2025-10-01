local info = {}

lib.callback.register('kk-scripts:recievePaymentInfo', function(source, terminal)
    return info[terminal]
end)

lib.callback.register('kk-scripts:sendPayment', function(source, terminal, price)
    local xPlayer = ESX.GetPlayerFromId(source)
    local returnable = nil

    if xPlayer then
        if xPlayer.job.name == Config.PaymentList[terminal].owner and xPlayer.job.onDuty then
            if not info[terminal] then
                info[terminal] = {price = price, source = xPlayer.source}

                SetTimeout(15000, function()
                    if info[terminal] then
                        TriggerClientEvent('KKF.UI.ShowNotification', info[terminal].source, 'error', 'Klient ei suutnud makset sooritada!')
                        info[terminal] = nil
                    end
                end)

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

RegisterServerEvent('kk-scripts:server:payRestorant', function(data)
    local xPlayer = ESX.GetPlayerFromId(source)

    local terminal = data.terminal
    local type = data.type

    if xPlayer then
        if info[terminal] then
            local totalPrice = info[terminal].price
            local taxPercentage = exports['kk-taxes']:getTax('primary').value
            local taxAmount = ESX.Math.Round(ESX.Math.Percent(taxPercentage, totalPrice))
            local finalPrice = totalPrice + taxAmount

            if type == 'cash' then
                if xPlayer.getAccount('money').money >= finalPrice then
                    xPlayer.removeAccountMoney('money', finalPrice)
                    TriggerEvent('Society.AddMoney', Config.PaymentList[terminal].owner, totalPrice)

                    TriggerClientEvent('KKF.UI.ShowNotification', info[terminal].source, 'info', 'Makse õnnestus, firma teenis $' .. totalPrice .. '.')
                    TriggerClientEvent('InteractSound_CL:PlayWithinDistance', -1, source, 5.0, 'mani', 0.2)

                    info[terminal] = nil
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Teil ei ole piisavalt raha!')
                    TriggerClientEvent('KKF.UI.ShowNotification', info[terminal].source, 'error', 'Klient ei suutnud makset sooritada!')
                    info[terminal] = nil
                end
            elseif type == 'bank' then
                if xPlayer.getAccount('bank').money >= finalPrice then
                    TriggerEvent('kk-society:getJobInfo', Config.PaymentList[terminal].owner, function(cb)
                        xPlayer.removeAccountMoney('bank', finalPrice)
                        TriggerEvent('Society.AddMoney', Config.PaymentList[terminal].owner, totalPrice)

                        TriggerClientEvent('InteractSound_CL:PlayOnOne', xPlayer.source, 'message', 0.1)
                        TriggerClientEvent('InteractSound_CL:PlayWithinDistance', -1, source, 5.0, 'mani', 0.2)
                        TriggerClientEvent('kk-phone:client:showNotification', xPlayer.source, 'bank', 'Pank', 'Maksite $' .. totalPrice .. ' firmale ' .. cb.label .. '.')
    
                        TriggerClientEvent('KKF.UI.ShowNotification', info[terminal].source, 'info', 'Makse õnnestus, firma teenis $' .. totalPrice .. '.')
                        info[terminal] = nil
                    end)
                else
                    TriggerClientEvent('kk-phone:client:showNotification', xPlayer.source, 'bank', 'Pank', 'Teil ei ole piisavalt raha')
                    TriggerClientEvent('InteractSound_CL:PlayOnOne', xPlayer.source, 'message', 0.1)
                    TriggerClientEvent('KKF.UI.ShowNotification', info[terminal].source, 'error', 'Klient ei suutnud makset sooritada!')
                    info[terminal] = nil
                end
            end
        end
    end
end)
