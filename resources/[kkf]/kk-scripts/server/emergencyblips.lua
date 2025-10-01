local ACTIVE_EMERGENCY_PERSONNEL = {}

RegisterServerEvent("eblips:add")
AddEventHandler("eblips:add", function(person)
	ACTIVE_EMERGENCY_PERSONNEL[person.src] = person
	TriggerClientEvent("eblips:toggle", person.src, true)

	local xPlayer = ESX.GetPlayerFromId(person.src)

	if xPlayer then
		if xPlayer.job.name == 'police' and xPlayer.job.onDuty or xPlayer.job.name == 'ambulance' and xPlayer.job.onDuty then
			MySQL.Async.fetchAll('SELECT badge FROM users WHERE pid = @pid', {
				['@pid'] = xPlayer.identifier
			}, function(result)
				if result[1].badge then
					ACTIVE_EMERGENCY_PERSONNEL[person.src].serial = tonumber(result[1].badge)
				else
					ACTIVE_EMERGENCY_PERSONNEL[person.src].serial = 99
				end
			end)
		end
	end		
end)

RegisterServerEvent("eblips:remove")
AddEventHandler("eblips:remove", function(src)
	ACTIVE_EMERGENCY_PERSONNEL[src] = nil
	TriggerClientEvent("eblips:remove", -1, src)
end)

AddEventHandler("playerDropped", function()
	ACTIVE_EMERGENCY_PERSONNEL[source] = nil
	TriggerClientEvent("eblips:remove", -1, source)
end)

Citizen.CreateThread(function()
	local lastUpdateTime = os.time()

	while true do
		Wait(500)
		if os.difftime(os.time(), lastUpdateTime) >= 1 then
			for id, info in pairs(ACTIVE_EMERGENCY_PERSONNEL) do
				ACTIVE_EMERGENCY_PERSONNEL[id].x = GetEntityCoords(GetPlayerPed(id)).x
				ACTIVE_EMERGENCY_PERSONNEL[id].y = GetEntityCoords(GetPlayerPed(id)).y
				ACTIVE_EMERGENCY_PERSONNEL[id].z = GetEntityCoords(GetPlayerPed(id)).z
				TriggerClientEvent("eblips:update", -1, ACTIVE_EMERGENCY_PERSONNEL[id])
			end
			lastUpdateTime = os.time()
		end
	end
end)

RegisterServerEvent('kk-scripts:server:toggleStation', function()
	local src = source 
	local xPlayer = ESX.GetPlayerFromId(src)

	if xPlayer then
		if xPlayer.job.name == 'police' and xPlayer.job.onDuty then
			if not ACTIVE_EMERGENCY_PERSONNEL[xPlayer.source] then
				MySQL.Async.fetchAll('SELECT department FROM users WHERE pid = @pid', {
                    ['@pid'] = xPlayer.identifier
                }, function(result)
                    if result[1].department == 'BCSO' then
                        TriggerEvent('eblips:add', {name = xPlayer.job.grade_label..' '..xPlayer.name, src = xPlayer.source, color = 25})
                    else
                        TriggerEvent('eblips:add', {name = xPlayer.job.grade_label..' '..xPlayer.name, src = xPlayer.source, color = 29})
                    end

					exports['kk-scripts']:sendSocietyLog(xPlayer.source, 'GPS STAATUS', 'Sisselülitatud.')
					TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'success', 'GPS käivitatud!')
                end)
			else
				TriggerEvent('eblips:remove', xPlayer.source)
				exports['kk-scripts']:sendSocietyLog(xPlayer.source, 'GPS STAATUS', 'Väljalülitatud.')
				TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'GPS väljalulitatud!')
			end
		else
			TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Teil ei ole antud tegevusele ligipääsu!')
		end
	end
end)