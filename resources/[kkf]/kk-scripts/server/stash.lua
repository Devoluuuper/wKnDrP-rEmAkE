local GetCurrentResourceName = GetCurrentResourceName()
local ox_inventory = exports.ox_inventory
local registeredStashes = {}

AddEventHandler('onServerResourceStart', function(resourceName)
	if resourceName == 'ox_inventory' or resourceName == GetCurrentResourceName then
        local jobs = MySQL.Sync.fetchAll('SELECT * FROM jobs', {})

        for k,v in pairs(jobs) do
            ox_inventory:RegisterStash(v.name, 'Kapp-' .. v.label, 120, v.safe * 1000, false, v.name)
        end
	end
end)