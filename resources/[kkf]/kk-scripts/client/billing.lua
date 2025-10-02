RegisterNetEvent("KKF_billing:sendBillMenu")
AddEventHandler('KKF_billing:sendBillMenu', function(company, description)
	local playerPed = PlayerPedId()
	local players      = KKF.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
	local foundPlayers = false

	local menu = {}
	
	for i=1, #players, 1 do
		if players[i] ~= PlayerId() then
			foundPlayers = true

			menu['ID: ' .. GetPlayerServerId(players[i])] = {
				description = "",
				event = 'kk-billing:client:chooseAmount',
				args = {id = players[i], cmp = company, desc = description}
			}
		end
	end

	if not foundPlayers then
		TriggerEvent('KKF.UI.ShowNotification', "error", "Ühtegi inimest ei ole läheduses.")
		return
	end

	lib.registerContext({
        id = 'billing_send',
        title = 'Vali kellele arve esitada',
        options = menu
    })

	lib.showContext('billing_send')

	foundPlayers = false
end)

RegisterNetEvent('kk-billing:client:chooseAmount')
AddEventHandler('kk-billing:client:chooseAmount', function(data)
	local id = data.id; local company = data.cmp; local description = data.desc

	if id then
		local keyboard = lib.inputDialog('Arve loomine', {'Summa', 'Kirjeldus'})

		if keyboard then
			local invoiceAmount = tonumber(keyboard[1])
			local invoiceDesc = keyboard[2]
		
			if invoiceAmount and invoiceDesc then
				if invoiceAmount < 1 then
					TriggerEvent('KKF.UI.ShowNotification', "error", "Ebakorrektne summa.")
				else
					local descr = description .. ' | ' .. invoiceDesc

					TriggerEvent('KKF.UI.ShowNotification', "info", "Edastasid isikule arve!")
					TriggerServerEvent('KKF_billing:sendBill', GetPlayerServerId(id), company, descr, invoiceAmount)
				end
			end
		end
	end
end)

RegisterNetEvent('kk-scripts:client:openBillingMenu', function()
	TriggerEvent('KKF_billing:sendBillMenu', KKF.PlayerData.job.name, KKF.PlayerData.job.label .. ' arve')
end)