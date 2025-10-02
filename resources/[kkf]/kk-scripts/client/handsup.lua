-- local isHandsUp = false
-- local isDead = false

-- RegisterCommand('+handsup', function()
-- 	local playerPed = PlayerPedId()

-- 	if exports['kk-taskbar']:canInteract() then return end

-- 	if DoesEntityExist(playerPed) and not IsPedInAnyVehicle(playerPed, false) then
-- 		isHandsUp = not isHandsUp

-- 		if isHandsUp then
-- 			local animDict, animName = 'random@mugging3', 'handsup_standing_base'
-- 			lib.requestAnimDict(animDict)
-- 			TaskPlayAnim(playerPed, animDict, animName, 6.0, -6.0, -1, 49, 0, 0, 0, 0)
-- 		else
-- 			ClearPedSecondaryTask(playerPed)
-- 		end
-- 	end
-- end)

-- RegisterKeyMapping('+handsup', 'Tõsta käed üles', 'keyboard', 'X')

-- AddEventHandler('KKF.Player.Spawned', function(spawn)
-- 	isDead = false
-- end)

-- AddEventHandler('KKF.Player.Death', function(data)
-- 	isDead = true
-- end)

-- Citizen.CreateThread(function()
-- 	while true do
-- 		wait = 0

-- 		if isHandsUp then
-- 			local playerPed = PlayerPedId()
-- 			local isTryingToEnter = GetVehiclePedIsTryingToEnter(playerPed)
-- 			local isInVehicle = IsPedInAnyVehicle(playerPed, false)

-- 			if isTryingToEnter ~= 0 or isInVehicle or IsPedFalling(playerPed) or isDead then
-- 				ClearPedSecondaryTask(playerPed)
-- 				isHandsUp = false
-- 			end

-- 			DisableControlAction(0, 25, true)
-- 			DisablePlayerFiring(PlayerId(), true)
-- 		else
-- 			wait = 200
-- 		end

-- 		Wait(wait)
-- 	end
-- end)