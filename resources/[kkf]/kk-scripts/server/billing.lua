RegisterServerEvent('esx_billing:sendBill')
AddEventHandler('esx_billing:sendBill', function(playerId, sharedAccountName, label, amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer then
        local xTarget = ESX.GetPlayerFromId(playerId)
        amount = ESX.Math.Round(amount)

        if amount > 0 and xTarget then
            if sharedAccountName then
                MySQL.Sync.execute('INSERT INTO billing (identifier, sender, target, label, amount, time) VALUES (@identifier, @sender,  @target, @label, @amount, @time)', {
                    ['@identifier'] = xTarget.identifier,
                    ['@sender'] = xPlayer.identifier,
                    ['@target'] = sharedAccountName,
                    ['@label'] = label,
                    ['@amount'] = amount,
                    ['@time'] = os.date('%Y-%m-%d %X')
                })
            else
                MySQL.Sync.execute('INSERT INTO billing (identifier, sender, target, label, amount, time) VALUES (@identifier, @sender, @target, @label, @amount, @time)', {
                    ['@identifier'] = xTarget.identifier,
                    ['@sender'] = xPlayer.identifier,
                    ['@target'] = xPlayer.identifier,
                    ['@label'] = label,
                    ['@amount'] = amount,
                    ['@time'] = os.date('%Y-%m-%d %X')
                })
            end
        end
    end
end)


lib.callback.register('esx_billing:getBills', function(source)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local returnable = nil

	if xPlayer then
		MySQL.Async.fetchAll('SELECT amount, id, label, target FROM billing WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(result)
			returnable = result
		end)
	else
        returnable = {}
	end

	while returnable == nil do Wait(50) end; return returnable
end)

lib.callback.register('kk-billing:getDeptor', function(source, target)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local returnable = nil

	if xPlayer then
		local rowCount = MySQL.Sync.fetchScalar('SELECT COUNT(*) FROM billing WHERE identifier = ? AND target = ?;', { xPlayer.identifier, target })
		returnable = rowCount > 0
	else
        returnable = {}
	end

	while returnable == nil do Wait(50) end; return returnable
end)