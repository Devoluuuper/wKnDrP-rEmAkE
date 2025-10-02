RegisterServerEvent("wardrobe:saveOutfit")
AddEventHandler("wardrobe:saveOutfit", function(name, pedModel)
	local xPlayer = KKF.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT skin FROM users WHERE pid = ?', {xPlayer.identifier}, function(result)
		MySQL.Async.insert('INSERT INTO `user_outfits` (`identifier`, `name`, `outfit`) VALUES (@identifier, @name, @outfit)', {
			['@outfit'] = result[1].skin,
			['@name'] = name,
			['@identifier'] = xPlayer.identifier
		})
	end)
end)

RegisterServerEvent("wardrobe:getOutfits")
AddEventHandler("wardrobe:getOutfits", function()
	local xPlayer = KKF.GetPlayerFromId(source)
	local oSource = source
	local myOutfits = {}

	MySQL.Async.fetchAll('SELECT id, name, outfit FROM user_outfits WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		for i=1, #result, 1 do
			table.insert(myOutfits, {id = result[i].id, name = result[i].name, outfit = json.decode(result[i].outfit)})
		end

		TriggerClientEvent('wardrobe:sendOutfits', oSource, myOutfits)
	end)
end) 

RegisterServerEvent("wardrobe:deleteOutfit")
AddEventHandler("wardrobe:deleteOutfit", function(id)
	local xPlayer = KKF.GetPlayerFromId(source)

	MySQL.Async.execute('DELETE FROM `user_outfits` WHERE `id` = @id', {
		['@id'] = id
	})
end)