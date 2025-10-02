RegisterCommand('clean', function()
	if not cache.vehicle then
		local pos = GetEntityCoords(cache.ped)
		local veh = KKF.Game.GetClosestVehicle(pos)
		local dist = #(GetEntityCoords(veh) - pos)

		if DoesEntityExist(veh) and dist < 3.0 then
			local progress = exports['kk-taskbar']:startAction('wash', 'Sõiduki pesemine', 10000, 'base', 'amb@world_human_maid_clean@', {freeze = true, controls = true})

			if progress then
				TriggerEvent('KKF.UI.ShowNotification', 'success', 'Sõiduk pestud!')
				SetVehicleDirtLevel(veh, 0.0)
			end
		else
			TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ühtegi sõidukit ei ole läheduses!')
		end
	else
		TriggerEvent('KKF.UI.ShowNotification', 'error', 'Sõidukis ei saa seda asja teha!')
	end
end)

exports('applyWax', function()
	local pos = GetEntityCoords(cache.ped)
	local veh = KKF.Game.GetClosestVehicle(pos)
	local dist = #(GetEntityCoords(veh) - pos)

	if DoesEntityExist(veh) and dist < 3.0 then
		if GetVehicleDirtLevel(veh) == 0.0 then
			local progress = exports['kk-taskbar']:startAction('wash', 'Sõiduki vahatamine', 10000, 'base', 'amb@world_human_maid_clean@', {freeze = true, controls = true})

			if progress then
				local networkId = NetworkGetNetworkIdFromEntity(veh)
				TriggerServerEvent('kk-carwash:server:setWax', networkId)
				TriggerServerEvent('KKF.Player.RemoveItem', 'carwax', 1)
				TriggerServerEvent('qb-customs:server:updateVehicle', KKF.Game.GetVehicleProperties(veh))
			end
		else
			TriggerEvent('KKF.UI.ShowNotification', 'error', 'Tee sõiduk enne vahatamist puhtaks!')
		end
	else
		TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ühtegi sõidukit ei ole läheduses!')
	end
end)

lib.onCache('seat', function(value)
	Wait(0)

    if value == -1 then
		while cache.vehicle and cache.seat == -1 do
			wait = 1000

			local wax = Entity(cache.vehicle).state.wax

			if wax then
				if wax > 0 then
					Entity(cache.vehicle).state:set('wax', wax - 1, true)
					SetVehicleDirtLevel(cache.vehicle, 0.0)
				end
			end

			Wait(wait)
		end
    end
end)