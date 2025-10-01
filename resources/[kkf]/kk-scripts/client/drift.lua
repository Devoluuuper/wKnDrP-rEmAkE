local driftMode = false

RegisterCommand('drift', function()
	driftMode = not driftMode

	if driftMode then
		TriggerEvent('KKF.UI.ShowNotification', 'success', 'Drift aktiveeritud.')
	else
		TriggerEvent('KKF.UI.ShowNotification', 'error', 'Drift deaktiveeritud.')
		if cache.seat == -1 then SetVehicleReduceGrip(cache.vehicle, false) end
	end
end)

TriggerEvent('chat:addSuggestion', '/drift', 'Luba/Keela driftmode.');

Citizen.CreateThread(function()
	while true do
		wait = 10

		if driftMode then
			if cache.vehicle then
				if cache.seat == -1 then
					if GetEntitySpeed(cache.vehicle) * 3.6 <= 100.0 then
						if IsControlPressed(1, 21) then
							SetVehicleReduceGrip(cache.vehicle, true)
						else
							SetVehicleReduceGrip(cache.vehicle, false)
						end
					elseif GetEntitySpeed(cache.vehicle) * 3.6 > 100.0 then
						SetVehicleReduceGrip(cache.vehicle, false); wait = 500
					end
				end
			else
				wait = 500
			end
		else
			wait = 1000
		end

		Wait(wait)
	end
end)