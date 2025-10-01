local cachedTaxes = nil

lib.callback.register('kk-taxes:getTaxes', function(source, tax)
    if not cachedTaxes then
        MySQL.Async.fetchAll('SELECT * FROM taxes', {}, function(result)
            local taxes = {}
            for _, row in ipairs(result) do
                taxes[row.tax] = { label = row.label, value = tonumber(row.value) }
            end
            cachedTaxes = taxes
        end)
        while not cachedTaxes do
            Wait(50)
        end
    end
    
    if tax then
        return cachedTaxes[tax] or {}
    else
        return cachedTaxes or {}
    end
end)


RegisterNetEvent('kk-taxes:server:editTax')
AddEventHandler('kk-taxes:server:editTax', function(tax, newValue)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchScalar('SELECT value FROM taxes WHERE tax = @tax', {
        ['@tax'] = tax
    }, function(oldValue)
        if oldValue then
            MySQL.Async.execute('UPDATE taxes SET value = @newValue WHERE tax = @tax', {
                ['@newValue'] = newValue,
                ['@tax'] = tax
            }, function(rowsChanged)
                if rowsChanged > 0 then
                    if cachedTaxes then
                        cachedTaxes[tax].value = newValue
                    end
                    local taxLabel = cachedTaxes[tax].label
                    TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'success', 'Muudetud maksu: '.. taxLabel .. '. Vana: '.. oldValue ..'% Uus: '.. newValue..'%')
                else
                end
            end)
        else
        end
    end)
end)


exports('getTax', function(taxName)
    if not cachedTaxes then
        MySQL.Async.fetchAll('SELECT * FROM taxes', {}, function(result)
            local taxes = {}
            for _, row in ipairs(result) do
                taxes[row.tax] = { label = row.label, value = tonumber(row.value) }
            end
            cachedTaxes = taxes
        end)
        while not cachedTaxes do
            Wait(50)
        end
    end

    if cachedTaxes and cachedTaxes[taxName] then
        return cachedTaxes[taxName]
    else
        return nil
    end
end)


RegisterCommand("taxes", function(source, args, rawCommand)
	if source ~= 0 then
		local xPlayer = ESX.GetPlayerFromId(source)
		if xPlayer.adminLevel >= 5 then
			if Player(xPlayer.source).state.adminMode then
                TriggerClientEvent('kk-taxes:client:editTaxes', xPlayer.source)
			else
				TriggerClientEvent("chatMessage", xPlayer.source, "SÜSTEEM", 1, "Te ei ole veel administraatori õigusi sisse lülitanud.")
			end
		else
			TriggerClientEvent("chatMessage", xPlayer.source, "SÜSTEEM", 1, "Sul ei ole selleks piisavalt õigusi.")
		end
	end
end, false)


AddEventHandler('KKF.Player.Loaded', function(source, xPlayer)
    -- Fetch taxes from the database
    MySQL.Async.fetchAll('SELECT * FROM taxes', {}, function(result)
        if result and #result > 0 then
            -- Prepare the tax message
            local taxMessage = "^4MAKSUMÄÄRAD:^7" -- Add the base color (white) after the label
            for _, tax in ipairs(result) do
                taxMessage = taxMessage .. string.format(" ^3%s:^7 %s%%,", tax.label, tonumber(tax.value))
            end
            
            -- Remove the trailing comma
            taxMessage = taxMessage:sub(1, -2)

            TriggerClientEvent("chatMessage", source, "", {70, 150, 200}, taxMessage)
        end
    end)
end)


