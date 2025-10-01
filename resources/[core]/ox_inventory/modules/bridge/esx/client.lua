local ESX = setmetatable({}, {
	__index = function(self, index)
		local obj = exports['kk-core']:getSharedObject()
		self.SetPlayerData = obj.SetPlayerData
		self.PlayerLoaded = obj.PlayerLoaded
		return self[index]
	end
})

---@diagnostic disable-next-line: duplicate-set-field
function client.setPlayerData(key, value)
	PlayerData[key] = value
	ESX.SetPlayerData(key, value)
end

---@diagnostic disable-next-line: duplicate-set-field
function client.setPlayerStatus(values)
	for name, value in pairs(values) do
		if value > 0 then TriggerEvent('esx_status:add', name, value) else TriggerEvent('esx_status:remove', name, -value) end
	end
end

RegisterNetEvent('esx:onPlayerLogout', client.onLogout)

AddEventHandler('KKF.Player.SetData', function(key, value)
	if not PlayerData.loaded or GetInvokingResource() ~= 'kk-core' then return end

	if key == 'job' then
		key = 'groups'
		value = { [value.name] = value.grade }
	end

	PlayerData[key] = value
	OnPlayerData(key, value)
end)

local Weapon = require 'modules.weapon.client'

RegisterNetEvent('kk-handcuffs:status', function(status)
	PlayerData.cuffed = status
	LocalPlayer.state:set('busy', status, false)
	if PlayerData.cuffed then
		Weapon.Disarm()
		if invOpen then 
			TriggerEvent('ox_inventory:closeInventory') 
		end
	end
end)