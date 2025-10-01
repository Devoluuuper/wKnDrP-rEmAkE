local ox_inventory = exports.ox_inventory

RegisterNetEvent('pawnItem')
AddEventHandler('pawnItem', function(data)
	local itemName, amount = data.name, data.count

	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

	if xPlayer then
		local price = Config.PawnShopPrices[itemName].price
		local xItem = ox_inventory:GetItem(xPlayer.source, itemName)

		if not price then return end

		if xItem.count < amount then
			TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Teil ei ole antud eset piisavalt!')
			return
		end

		price = ESX.Math.Round(price * amount)

		xPlayer.addMoney(price); exports['kk-scripts']:sendLog(xPlayer.identifier, 'PANDIMAJA', 'Sai $' .. price .. ' ' .. ESX.GetItemLabel(itemName) .. ' ' .. amount .. 'tk eest.')
		ox_inventory:RemoveItem(xPlayer.source, itemName, amount)
	end 
end)

lib.callback.register('kk-inventory:get', function(source)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local returnable = nil

	if xPlayer then
		returnable = ox_inventory:Inventory(xPlayer.source).items
	else
		returnable = {}
	end

	while returnable == nil do Wait(50) end; return returnable
end)