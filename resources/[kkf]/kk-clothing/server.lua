RegisterServerEvent('bluum-appearnance:save', function(data)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		MySQL.Sync.execute('UPDATE users SET `skin` = ? WHERE pid = ?', {json.encode(data), xPlayer.identifier})
	end
end)

RegisterServerEvent('bluum-appearnance:saveTattoos', function(data)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		MySQL.Sync.execute('UPDATE users SET `tattoos` = ? WHERE pid = ?', {json.encode(data), xPlayer.identifier})
	end
end)

RegisterNetEvent('kk-clothing:reloadTattoos', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		MySQL.Async.fetchAll('SELECT tattoos FROM users WHERE pid = ?', {xPlayer.identifier}, function(result)
			SetTimeout(1500, function() TriggerClientEvent('bluum-appearnance:settattoos', xPlayer.source, json.decode(result[1].tattoos)) end)
		end)
	end
end)

lib.callback.register('bluum-appearnance:getPlayerAppearance', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local returnable = nil

	if xPlayer then
		MySQL.Async.fetchAll('SELECT skin, tattoos FROM users WHERE pid = ?', {xPlayer.identifier}, function(result)
			local skin = {json.decode(result[1].skin), json.decode(result[1].tattoos)}

			returnable = skin
		end)
	else
		returnable = {}
	end

	while returnable == nil do Wait(50) end; return returnable
end)

RegisterServerEvent('bluum-appearnance:removeMoney', function(price)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		xPlayer.removeMoney(price)
	end
end)