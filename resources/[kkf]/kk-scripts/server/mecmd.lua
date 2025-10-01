RegisterCommand('me', function(source, args, rawCommand)
	if source == 0 then
		print('esx_rpchat: you can\'t use this command from rcon!')
		return
	end

	args = table.concat(args, ' ')
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerClientEvent('KKF:chat:me', -1, args, source)
	exports['kk-scripts']:sendLog(xPlayer.identifier, 'MUU', 'Teostas tegevuse /me ' .. args .. '.')
end, false)