-- Pane mängija sõidukisse
RegisterNetEvent('kk-scripts:server:putInVehicle', function(targetId, vehicleNetId)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local xTarget = KKF.GetPlayerFromId(targetId)

    if not xPlayer or not xTarget then return end

    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    if not vehicle or not DoesEntityExist(vehicle) then
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Sõiduk ei ole saadaval!')
        return
    end

    -- Kontroll, et target on kinnitatud või surnud
    if Player(targetId).state.isCuffed ~= 'none' or Player(targetId).state.isDead then
        -- Trigger client event targetile, et panna autosse
        TriggerClientEvent('kk-scripts:client:putInVehicle', targetId, vehicleNetId)
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'success', 'Mängija pandi autosse!')
    else
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Mängijat ei saa autosse panna!')
    end
end)

-- Võta mängija sõidukist välja
RegisterNetEvent('kk-scripts:server:takeOutVehicle', function(targetId, coords)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local xTarget = KKF.GetPlayerFromId(targetId)

    if not xPlayer or not xTarget then return end

    -- Kontroll, et target on kinnitatud või surnud
    if Player(targetId).state.isCuffed ~= 'none' or Player(targetId).state.isDead then
        -- Trigger client event targetile, et panna ped sõidukist välja
        TriggerClientEvent('kk-scripts:client:takeOutVehicle', targetId, coords)
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'success', 'Mängija võeti autost välja!')
    else
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Mängijat ei saa autost võtta!')
    end
end)
