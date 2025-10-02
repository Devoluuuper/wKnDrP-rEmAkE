local ox_inventory = exports.ox_inventory
local playersHealing = {}

RegisterNetEvent('kk-ambulance:revive')
AddEventHandler('kk-ambulance:revive', function(playerId)
	local xPlayer = KKF.GetPlayerFromId(source)
	playerId = tonumber(playerId)

	if xPlayer then
		if xPlayer.job.name == 'ambulance' or xPlayer.isAdmin() then
			local xTarget = KKF.GetPlayerFromId(playerId)

			if xTarget then
				TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'success', 'Elustasid lähima isiku!')
				TriggerClientEvent('kk-ambulance:revive', xTarget.source)
				TriggerClientEvent('kk-needs:setNeed', xTarget.source, 'hunger', 100000)
				TriggerClientEvent('kk-needs:setNeed', xTarget.source, 'thirst', 100000)
				TriggerClientEvent('kk-needs:setNeed', xTarget.source, 'stress', 0)
				TriggerClientEvent('kk-ambulance:disableUI', xTarget.source)
			else
				TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Elustamine ebaõnnestus, inimest ei ole enam.')
			end
		end
	end
end)


RegisterNetEvent('kk-ambulance:server:heal')
AddEventHandler('kk-ambulance:server:heal', function(target)
	local xPlayer = KKF.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' then
		TriggerClientEvent('kk-ambulance:client:heal', target)
	end
end)


-- lib.callback.register('kk-ambulance:removeItems', function(source)
-- 	ox_inventory:ClearInventory(source, Config.DontRemoveItems)

-- 	return true
-- end)

RegisterServerEvent('kk-ambulance:server:removeItems')
AddEventHandler('kk-ambulance:server:removeItems', function()
    local player = source
    local removeItems = Config.RemoveItems

    for _, item in ipairs(removeItems) do
        -- Remove item from inventory using ox_inventory API
        local count = exports.ox_inventory:Search(player, 'count', item)
        if count > 0 then
            exports.ox_inventory:RemoveItem(player, item, count)
        end
    end
end)




RegisterNetEvent('kk-ambulance:setDeathStatus')
AddEventHandler('kk-ambulance:setDeathStatus', function(isDead)
	local xPlayer = KKF.GetPlayerFromId(source)

	if isDead == true then
		MySQL.Sync.execute('UPDATE users SET is_dead = ? WHERE pid = ?', { 1, xPlayer.identifier })
	elseif isDead == false then
		MySQL.Sync.execute('UPDATE users SET is_dead = ? WHERE pid = ?', { 0, xPlayer.identifier })
	end

	TriggerClientEvent('kk-ambulance:setDeathStatus', xPlayer.source, isDead)
	Player(xPlayer.source).state.isDead = isDead
end)

lib.callback.register('kk-ambulance:recieveIsDead', function(source)
	local src = source
	local xPlayer = KKF.GetPlayerFromId(src)
	local returnable = nil

	if xPlayer then
		MySQL.Async.fetchAll('SELECT is_dead FROM users WHERE pid = ?', {xPlayer.identifier}, function(player)
			if tonumber(player[1].is_dead) == 1 then
				returnable = true
			else
				returnable = false
			end
		end)
	else
		returnable = false
	end

	while returnable == nil do Wait(50) end; return returnable
end)


lib.callback.register('kk-ambulance:sendApplication', function(source, email, text)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
	local returnable = nil

    if xPlayer then
        if text ~= nil then 
			local userdata = 'Nimi: ' .. xPlayer.name .. ' | Telefoni NR: ' .. xPlayer.phone..' | Email: ' .. email
			local webHook = 'https://discord.com/api/webhooks/1226930664973012992/Axg9rSRtMq2qA2yDDbqsLh6X3Kxqw0hJlkW5NrCvoXXd8g1pP2bpd2pesIygyflLwZT8'
			local embedData = {
				{
					["title"] = userdata,
					["color"] = 16711680, -- Red color
					["footer"] = {
						["text"] = os.date("%d/%m/%Y"),
					},
					["description"] = '```'.. text ..'```',
					["author"] = {
						["name"] = 'EMS kandideerimisavaldus',
						["icon_url"] = "https://cdn.discordapp.com/attachments/1177393190819606558/1177393484899024956/B8VfKetHTNdGAAAAAElFTkSuQmCC.png?ex=6621afa1&is=660f3aa1&hm=d8f84b3ea493524e83e1a8a690f85ffbe19ecdd5b993d0b79202a6200ab8eae2&",
					}
				} 
			}
			PerformHttpRequest(webHook, function(err, text, headers) end, 'POST', json.encode({ username = "Dispenser",embeds = embedData}), { ['Content-Type'] = 'application/json' })
			returnable = true
        else
			returnable = false
		end
	else
		returnable = false
    end
	while returnable == nil do Wait(50) end; 
	return returnable
end)



----- intensive
-- pole wkndis valmis
