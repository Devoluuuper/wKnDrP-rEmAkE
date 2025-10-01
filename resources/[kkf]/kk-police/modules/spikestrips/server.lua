RegisterNetEvent('kk-police:server:placeSpikes')
AddEventHandler('kk-police:server:placeSpikes', function(positions, heading)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer then
		if xPlayer.job.name == 'police' then
        	TriggerClientEvent('kk-police:client:createSpikes', -1, positions, heading)
		else
			TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Ei saa seda teha!')

		end
    end
end)
