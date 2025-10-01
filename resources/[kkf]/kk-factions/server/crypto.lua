local accounts = {}

local function saveFactionData(faction)
	MySQL.update.await('UPDATE jobs SET crypto = ? WHERE name = ?', {accounts[faction].crypto, faction})
end

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
	local result = MySQL.query.await('SELECT name, crypto FROM jobs', {playerIdentifier})

	for k,v in pairs(result) do
		accounts[v.name] = {}
		accounts[v.name].crypto = v.crypto
	end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    for k,v in pairs(accounts) do
        MySQL.update.await('UPDATE jobs SET crypto = ? WHERE name = ?', {v.crypto, k})
    end
end)

local function getCrypto(faction)
    local faction = accounts[faction]

    if faction then
        return faction.crypto
    else
        return 0
    end
end

exports('getCrypto', getCrypto)

local function updateTablet(faction)
    local Players = KKF.GetPlayers()
    local count = getCrypto(faction)

    for i = 1, #Players do
        if Players[i].job.name == faction then
            TriggerClientEvent('kk-factions:client:updateCrypto', Players[i].source, count)
        end
    end
end

AddEventHandler('KKF.Faction.GetCrypto', function(faction, cb)
    local faction = accounts[faction]

    if faction then
        cb(faction.crypto)
    else
        cb(0)
    end
end)

AddEventHandler('KKF.Faction.RemoveCrypto', function(faction, amount)
    local account = accounts[faction]

    if account then
        account.crypto = account.crypto - amount; saveFactionData(faction)
        updateTablet(faction)
    end
end)

AddEventHandler('KKF.Faction.AddCrypto', function(faction, amount)
    local account = accounts[faction]

    if account then
        account.crypto = account.crypto + amount; saveFactionData(faction)
        updateTablet(faction)
    end
end)