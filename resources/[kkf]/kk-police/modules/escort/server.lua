RegisterNetEvent('kk-police:server:setEscort')
AddEventHandler('kk-police:server:setEscort', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' or xPlayer.job.name == 'ambulance' then
		TriggerClientEvent('kk-police:drag', target, source)
	else
		print(('kk-police: %s attempted to drag (not cop or ambulance)!'):format(xPlayer.identifier))
	end
end)
