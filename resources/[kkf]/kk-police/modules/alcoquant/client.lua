RegisterNetEvent('kk-police:client:alcoScanDialog', function()
    local confirmed = lib.alertDialog({
        header = 'Alkomeeter',
        content = 'Politseiametnik soovib teid puhuma panna, kas olete nõus?',
        centered = true,
        cancel = true
    })

	TriggerServerEvent('kk-police:server:alcoScanDialog', (confirmed == 'confirm'), exports['rcore_drunk']:GetPlayerDrunkPercentage())
end)

RegisterNetEvent('kk-police:client:doAlcoScan', function(procentage)
	local progress = exports['kk-taskbar']:startAction('alco_scan', 'Puhutad isikut...', 5000, 'cellphone_text_read_base', 'cellphone@', {freeze = false, controls = true, disableCancel = true})

	if progress then
		TriggerEvent('chatMessage', 'ALCOQUANT', 'info', 'Kontrolli tulemus: ' .. procentage .. '%')
	end
end)

RegisterNetEvent('kk-police:client:alcoScan', function()
	local playerId, playerPed, playerCoords = lib.getClosestPlayer(GetEntityCoords(cache.ped), 3.0, false)
        
	if DoesEntityExist(playerPed) then
		local targetId = GetPlayerServerId(playerId)

		TriggerServerEvent('kk-police:server:alcoScan', targetId)
	else
		TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ühtegi isikut ei ole läheduses.')
	end
end)