lib.callback.register('kk-needs:getNeeds', function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        MySQL.Async.fetchAll('SELECT needs FROM users WHERE pid = @pid', {
            ['@pid'] = xPlayer.identifier
        }, function(result)
            local data = {}
    
            if result[1].needs then
                data = json.decode(result[1].needs)
            end

            returnable = data
        end)
    else
        returnable = {}
    end

    while returnable == nil do Wait(50) end; return returnable
end)

RegisterServerEvent('kk-needs:saveNeeds')
AddEventHandler('kk-needs:saveNeeds', function(needs)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer then
        MySQL.Async.execute('UPDATE users SET needs = @needs WHERE pid = @identifier', {
            ['@needs']     = json.encode(needs),
            ['@identifier'] = xPlayer.identifier
        })
    end
end)

ESX.RegisterUsableItem('alecoq', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	-- xPlayer.addInventoryItem('bottle', 1)
	
	TriggerClientEvent('kk-needs:onDrinkAlochol', source, 5000, 'alecoq')
end)

ESX.RegisterUsableItem('taurus', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	-- xPlayer.addInventoryItem('bottle', 1)

	TriggerClientEvent('kk-needs:onDrinkAlochol', source, 6200, 'taurus')
end)

ESX.RegisterUsableItem('bock', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	-- xPlayer.addInventoryItem('bottle', 1)

	TriggerClientEvent('kk-needs:onDrinkAlochol', source, 7500, 'bock')
end)

ESX.RegisterUsableItem('wine', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerClientEvent('kk-needs:onDrinkAlochol', source, 10000, 'wine')
end)

ESX.RegisterUsableItem('vodka', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	-- xPlayer.addInventoryItem('bottle', 1)

	TriggerClientEvent('kk-needs:onDrinkAlochol', source, 12500, 'vodka')
end)

ESX.RegisterUsableItem('tequila', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	-- xPlayer.addInventoryItem('bottle', 1)

	TriggerClientEvent('kk-needs:onDrinkAlochol', source, 15500, 'tequila')
end)

ESX.RegisterUsableItem('whisky', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	-- xPlayer.addInventoryItem('bottle', 1)

	TriggerClientEvent('kk-needs:onDrinkAlochol', source, 25500, 'whisky')
end)