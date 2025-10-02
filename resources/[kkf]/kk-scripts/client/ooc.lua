-- RegisterNetEvent('KKF:chat:sendProximityMessage')
-- AddEventHandler('KKF:chat:sendProximityMessage', function(playerId, title, message)
-- 	local source = PlayerId()
-- 	local target = GetPlayerFromServerId(playerId)

-- 	local sourcePed, targetPed = PlayerPedId(), GetPlayerPed(target)
-- 	local sourceCoords, targetCoords = GetEntityCoords(sourcePed), GetEntityCoords(targetPed)

-- 	if target == source then
-- 		TriggerEvent("chatMessage", title, 2, message)
-- 	elseif sourcePed ~= targetPed and #(sourceCoords - targetCoords) < 20 then
-- 		TriggerEvent("chatMessage", title, 2, message)
-- 	end
-- end) 
--- KUI PEATE VAJALIKUKS