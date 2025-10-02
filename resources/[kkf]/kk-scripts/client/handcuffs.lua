RegisterNetEvent('KKF.Player.Loaded', function(playerData)
	KKF.PlayerData = playerData
end)

RegisterNetEvent('KKF.Player.Unloaded', function() 
	KKF.PlayerData = {} 
end)

RegisterNetEvent('kk-handcuffs:client:startPlayerCuffing', function(cuffer)
	local cufferId = GetPlayerFromServerId(cuffer)
	local cufferPed = GetPlayerPed(cufferId)
	local cufferHeading = GetEntityHeading(cufferPed)
    local cufferLocation = GetEntityForwardVector(cufferPed)
    local cufferCoords = GetEntityCoords(cufferPed)
	
	local x, y, z = table.unpack(cufferCoords + cufferLocation * 1.0)
	SetEntityCoords(cache.ped, x, y, z)
	SetEntityHeading(cache.ped, cufferHeading)
	
	lib.requestAnimDict('mp_arrest_paired')
	TaskPlayAnim(cache.ped, 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750, 2, 0, 0, 0, 0)

	local skill = exports['kk-skillbar']:skillBar(8, 1)

	if skill then
		TriggerServerEvent('kk-handcuffs:server:returnCuffs', cuffer)
		TriggerServerEvent('kk-handcuffs:server:unCuff')
		
		SetTimeout(500, function()
			ClearPedTasks(cache.ped)
			ClearPedSecondaryTask(cache.ped)
			SetEnableHandcuffs(cache.ped, false)
			DisablePlayerFiring(cache.ped, false)
		end)
	else
		TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ebaõnnestusite vabanemisel.')

		Wait(3760)
		lib.requestAnimDict('mp_arresting')
		TaskPlayAnim(cache.ped, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
		SetEnableHandcuffs(cache.ped, true)
		
		TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'handcuff', 0.5)
	end
end)

RegisterNetEvent('kk-handcuffs:client:startPlayerUnCuffing', function(cuffer)
	local cufferId = GetPlayerFromServerId(cuffer)
	local cufferPed = GetPlayerPed(cufferId)
	local cufferHeading = GetEntityHeading(cufferPed)
    local cufferLocation = GetEntityForwardVector(cufferPed)
    local cufferCoords = GetEntityCoords(cufferPed)
	
	local x, y, z = table.unpack(cufferCoords + cufferLocation * 1.0)
	SetEntityCoords(cache.ped, x, y, z)
	SetEntityHeading(cache.ped, cufferHeading)
	
    lib.requestAnimDict('mp_arresting')
    TaskPlayAnim(cache.ped, 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
    Wait(5000)

    ClearPedTasks(cache.ped)
    ClearPedSecondaryTask(cache.ped)
	SetEnableHandcuffs(cache.ped, false)
	DisablePlayerFiring(cache.ped, false)
end)
 
RegisterNetEvent('kk-handcuffs:client:startTargetCuffing', function()
    lib.requestAnimDict('mp_arrest_paired')
    TaskPlayAnim(cache.ped, 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8,3750, 2, 0, 0, 0, 0)
end)

RegisterNetEvent('kk-handcuffs:client:startTargetUncuffing', function()
    lib.requestAnimDict('mp_arresting')
    TaskPlayAnim(cache.ped, 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Wait(5000)
	ClearPedTasks(cache.ped)
end)

CreateThread(function() 
	while true do
		wait = 0

		local cuffedStatus = LocalPlayer.state.isCuffed

		if cuffedStatus == 'hard' or cuffedStatus == 'soft' then
			DisableAllControlActions(0)
			EnableControlAction(0, 0, true) 
			EnableControlAction(0, 1, true) 
			EnableControlAction(0, 3, true)
			EnableControlAction(0, 245, true)  
			EnableControlAction(0, 30, true)
			EnableControlAction(0, 2, true)
			EnableControlAction(0, 31, true)
			EnableControlAction(0, 200, true)
			EnableControlAction(0, 20, true)
			EnableControlAction(0, 38, true)

			-- NRID
			EnableControlAction(0, 157, true)
			EnableControlAction(0, 158, true)
			EnableControlAction(0, 160, true)
			EnableControlAction(0, 164, true)
			EnableControlAction(0, 165, true)
			EnableControlAction(0, 159, true)
			EnableControlAction(0, 161, true)
			EnableControlAction(0, 162, true)
			EnableControlAction(0, 163, true) 

			-- INSERT
			EnableControlAction(0, 121, true)

			-- Radialmenu
			EnableControlAction(0, 289, true)

			if IsEntityDead(cache.ped) then
				EnableControlAction(0, 74, true) 
				EnableControlAction(0, 47, true)
				EnableControlAction(0, 199, true) 
			end

			EnableControlAction(0, 249, true)

			if IsEntityPlayingAnim(cache.ped, 'mp_arresting', 'idle', 3) ~= 1 and not LocalPlayer.state.isDead then
				lib.requestAnimDict('mp_arresting')
				TaskPlayAnim(cache.ped, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
			end

			if cache.vehicle and seat == -1 then
				TaskLeaveAnyVehicle(cache.ped)
			end
		else
			wait = 500
		end

		Wait(wait)
	end
end)

RegisterNetEvent('kk-handcuffs:client:clearPedTasks') 
AddEventHandler('kk-handcuffs:client:clearPedTasks', function()
    ClearPedTasks(cache.ped)
    ClearPedSecondaryTask(cache.ped)
	SetEnableHandcuffs(cache.ped, false)
	DisablePlayerFiring(cache.ped, false)
end)

AddStateBagChangeHandler('isCuffed', nil, function(bagName, key, value) 
    local player = GetPlayerFromStateBagName(bagName)

    if player == cache.playerId then
		if value == 'hard' then
			exports.ox_target:disableTargeting(true)
			-- exports['lb-phone']:ToggleDisabled(true)
		else
			exports.ox_target:disableTargeting(false)
			-- exports['lb-phone']:ToggleDisabled(false)
		end
	end
end)

AddStateBagChangeHandler('isDead', nil, function(bagName, key, value) 
    local player = GetPlayerFromStateBagName(bagName)

    if player == cache.playerId then
		exports.ox_target:disableTargeting(value)
		-- exports['lb-phone']:ToggleDisabled(value)
	end
end)

TriggerEvent('chat:addSuggestion', '/auncuff', 'Eemalda mängija käerauad.', {
    { name = 'id'}
})
