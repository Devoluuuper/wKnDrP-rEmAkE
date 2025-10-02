RegisterServerEvent('kk-properties:server:routingBucket', function(val, apartmentId)
    local src = source
	local xPlayer = KKF.GetPlayerFromId(src)

    if xPlayer then 
        if val ~= nil then
            if val then
                MySQL.Async.execute('UPDATE users SET last_apartment = @status WHERE pid = @pid', {
                    ['@status'] = apartmentId or xPlayer.identifier,
                    ['@pid'] = xPlayer.identifier
                }, function(rowsChanged)
                    SetPlayerRoutingBucket(xPlayer.source, apartmentId or xPlayer.identifier)
                end)
            else
                MySQL.Async.execute('UPDATE users SET last_apartment = NULL WHERE pid = @pid', {
                    ['@pid'] = xPlayer.identifier
                }, function(rowsChanged)
                    SetPlayerRoutingBucket(xPlayer.source, 0)
                end)
            end
        end
    end
end)

RegisterNetEvent('kk-apartments:server:acceptResponse', function(id, response)
    local src = source
	local xPlayer = KKF.GetPlayerFromId(src)

    if xPlayer then 
        local xTarget = KKF.GetPlayerFromId(id)

        if xTarget then
            if response == 'confirm' then
                TriggerClientEvent('KKF.UI.ShowNotification', xTarget.source, 'success', 'Teie sõber kutsus teid sisse!')

                TriggerClientEvent('kk-apartments:client:enterApartment', xTarget.source, xPlayer.identifier)
                SetEntityCoords(GetPlayerPed(xTarget.source), GetEntityCoords(GetPlayerPed(xPlayer.source)))
            elseif response == 'cancel' then
                TriggerClientEvent('KKF.UI.ShowNotification', xTarget.source, 'error', 'Sõber keeldus teid enda korterisse laskma.')
            end
        end
    end
end)

RegisterNetEvent('kk-apartments:server:askPermission', function(pid)
    local src = source
	local xPlayer = KKF.GetPlayerFromId(src)

    if xPlayer then
        if pid == xPlayer.identifier then
            TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Te ei saa saata kutset enda korterisse!')
        else
            local xTarget = KKF.GetPlayerFromIdentifier(pid)

            if xTarget then
                TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'info', 'Palun oodake sõbra vastust.')
    
                TriggerClientEvent('kk-apartments:client:acceptForm', xTarget.source, {id = xPlayer.source, name = xPlayer.name})
            else
                TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Teie sõber ei viibi hetkel linnas!')
            end
        end
    end
end)

RegisterNetEvent('kk-apartments:server:getHouseData', function()
	local src = source
	local xPlayer = KKF.GetPlayerFromId(src)

	if xPlayer then
        MySQL.Async.fetchAll('SELECT apartment FROM users WHERE pid = ?', { xPlayer.identifier }, function(result)
            if result and result[1] then 
                TriggerClientEvent('kk-apartments:client:recTier', xPlayer.source, json.decode(result[1].apartment))
            end
        end)
	end
end)