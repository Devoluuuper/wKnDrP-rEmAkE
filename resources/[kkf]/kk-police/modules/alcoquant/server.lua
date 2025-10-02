RegisterServerEvent('kk-police:server:alcoScanDialog', function(isConfirmed, drunkPercentage)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)

    if xPlayer.job.name ~= 'police' then
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Teil ei ole piisavalt õigusi selle tegevuse jaoks.')
        return
    end

    if isConfirmed then
        TriggerClientEvent('kk-police:client:doAlcoScan', src, drunkPercentage)

        print(('%s (%s) tegi alkometritesti. Tulemus: %.2f%%'):format(xPlayer.getName(), xPlayer.identifier, drunkPercentage))

    else
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'info', 'Mängija keeldus alkometritesti tegemast.')
    end
end)

RegisterServerEvent('kk-police:server:alcoScan', function(targetId)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)

    if xPlayer.job.name ~= 'police' then
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Teil ei ole piisavalt õigusi.')
        return
    end

    local targetPlayer = KKF.GetPlayerFromId(targetId)
    if not targetPlayer then
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Mängijat ei leitud.')
        return
    end

    TriggerClientEvent('kk-police:client:alcoScanDialog', targetPlayer.source)
end)
