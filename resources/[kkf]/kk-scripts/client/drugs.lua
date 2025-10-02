RegisterNetEvent("kk-drugs:client:animation", function(item)
	local playerPed = PlayerPedId()

	if item == "weed_joint" then
	    local progress = exports['kk-taskbar']:startAction('weed', 'Suitsetad kanepit', 5000, 'WORLD_HUMAN_SMOKING_POT', false, {freeze = false, controls = false})

		if progress then
			TriggerEvent('KKF.UI.ShowNotification', 'info', 'Tunned et kanep hakkab mõjuma.')
			Citizen.Wait(math.random(7000, 10000))
			SetTimecycleModifier("drug_gas_huffin")
			SetTimecycleModifierStrength(0.85)
			Citizen.Wait(math.random(240000, 300000))
			ClearTimecycleModifier()
			ResetPedMovementClipset(playerPed, 0.0)
		end
	elseif item == "coke" then
		local progress = exports['kk-taskbar']:startAction('coke', 'Tõmbad kokaiini', 5000, 'missfbi3_party_snort_coke_b_male3', 'anim@amb@nightclub@peds@', {freeze = false, controls = false})

		if progress then
			TriggerEvent('KKF.UI.ShowNotification', 'info', 'Tunned et kokaiin hakkab mõjuma.')
			Citizen.Wait(math.random(7000, 10000))
			SetTimecycleModifier("PlayerSwitchPulse")
			SetTimecycleModifierStrength(1.75)
			SetRunSprintMultiplierForPlayer(playerPed, 1.4)
			Citizen.Wait(math.random(240000, 300000))
			SetRunSprintMultiplierForPlayer(playerPed, 1.01)
			ClearTimecycleModifier()
			ResetPedMovementClipset(playerPed, 0.0)
		end
	elseif item == "moonshine" then
		local prop = exports['kk-scripts']:spawnAttachedObject(playerPed, joaat('prop_cs_whiskey_bottle'), 18905, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0)
		local progress = exports['kk-taskbar']:startAction('moonshine', 'Jood puskarit', 5000, 'loop_bottle', 'mp_player_intdrink', {freeze = false, controls = false})
		
		if progress then
			TriggerEvent('KKF.UI.ShowNotification', 'info', 'Tunned et puskar hakkab mõjuma.')
			Citizen.Wait(math.random(7000, 10000))
			SetTimecycleModifier("PlayerSwitchPulse")
			SetTimecycleModifierStrength(1.75)
			SetRunSprintMultiplierForPlayer(playerPed, 1.4)
			Citizen.Wait(math.random(240000, 300000))
			SetRunSprintMultiplierForPlayer(playerPed, 1.01)
			ClearTimecycleModifier()
			ResetPedMovementClipset(playerPed, 0.0)
		end

		DeleteObject(prop)
	elseif item == "milk" then
		local prop = exports['kk-scripts']:spawnAttachedObject(playerPed, joaat('v_res_tt_milk'), 18905, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0)
		local progress = exports['kk-taskbar']:startAction('milk', 'Jood piima', 5000, 'loop_bottle', 'mp_player_intdrink', {freeze = false, controls = false})
		
		if progress then
			TriggerEvent('KKF.UI.ShowNotification', 'info', 'Tunned et sul hakkab parem')
			Citizen.Wait(math.random(15000, 20000))
	    	SetRunSprintMultiplierForPlayer(playerPed, 1.01)
			ClearTimecycleModifier()
			ResetPedMovementClipset(playerPed, 0.0)
		end

		DeleteObject(prop)
	end
end)