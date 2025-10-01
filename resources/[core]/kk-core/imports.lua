ESX = exports['kk-core']:getSharedObject()

if not IsDuplicityVersion() then -- Only register this event for the client
	AddEventHandler('KKF.Player.SetData', function(key, val, last)
		if GetInvokingResource() == 'kk-core' then
			ESX.PlayerData[key] = val
			if OnPlayerData ~= nil then OnPlayerData(key, val, last) end
		end
	end)
end