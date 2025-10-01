ESX.Trace = function(msg)
	print(('[^2TRACE^7] %s^7'):format(msg))
end

ESX.ClearTimeout = function(id)
	ESX.CancelledTimeouts[id] = true
end

ESX.SavePlayer = function(xPlayer, cb, silent)
	if xPlayer then
		local playerName = tostring(GetPlayerName(xPlayer.source))
		
		MySQL.Async.prepare("UPDATE `users` SET `name` = ?, `accounts` = ?, `job` = ?, `job_grade` = ?, `position` = ?, `inventory` = ?, `loadout` = ?, `licenses` = ?, `duty` = ? WHERE `pid` = ?", {{
			playerName,
			json.encode(xPlayer.getAccounts(true)),
			xPlayer.job.name,
			xPlayer.job.grade,
			json.encode(xPlayer.getCoords()),
			json.encode(xPlayer.getInventory(true)),
			json.encode(xPlayer.getLoadout(true)),
			json.encode(xPlayer.getLicenses()),
			xPlayer.getDuty(),
			xPlayer.identifier
		}}, function(affectedRows)
			if affectedRows == 1 and silent ~= true then
				print(('[^2INFO^7] Saved player ^7(^5%s^7)'):format(playerName))
			end
			
			if cb then cb() end
		end)
	end
end
ESX.GetJobs = function()
    return ESX.Jobs
end
ESX.StartDBSync = function()
	ESX.SavePlayers()

	SetTimeout(60000, ESX.SavePlayers)
end



ESX.SavePlayers = function()
	local players = GetPlayers()
    
	for i, v in pairs(players) do
		local xPlayer = ESX.GetPlayerFromId(v)

		if xPlayer then
			ESX.SavePlayer(xPlayer, function()
				print('[^2INFO^7] All players have been saved.')
			end, true)
		end
	end

	--exports.ox_inventory:saveInventories()
end

ESX.GetPlayers = function()
	local sources = {}

	for k,v in pairs(ESX.Players) do
		table.insert(sources, k)
	end

	return sources
end

ESX.GetExtendedPlayers = function(key, val)
	local xPlayers = {}
	for k, v in pairs(ESX.Players) do
		if key then
			if (key == 'job' and v.job.name == val) or v[key] == val then
				table.insert(xPlayers, v)
			end
		else
			table.insert(xPlayers, v)
		end
	end
	return xPlayers
end

ESX.GetPlayerFromId = function(source)
	return ESX.Players[tonumber(source)]
end

exports('getPlayerFromId', ESX.GetPlayerFromId)

ESX.GetPlayerFromIdentifier = function(identifier)
	for k,v in pairs(ESX.Players) do
		if tonumber(v.identifier) == tonumber(identifier) then
			return v
		end
	end
end

exports('getPlayerFromIdentifier', ESX.GetPlayerFromIdentifier)

ESX.GetPlayerFromSteamId = function(steamid)
	for k,v in pairs(ESX.Players) do
		if v.steamid == steamid then
			return v
		end
	end
end

exports('getPlayerFromSteamId', ESX.GetPlayerFromSteamId)

ESX.RegisterUsableItem = function(item, cb)
	ESX.UsableItemsCallbacks[item] = cb
end

ESX.UseItem = function(source, item)
	ESX.UsableItemsCallbacks[item](source, item)
end

ESX.GetItemLabel = function(item)
	item = exports.ox_inventory:Items(item)
	if item then
		return item.label
	end
end

ESX.DoesJobExist = function(job, grade)
	grade = tostring(grade)

	if job and grade then
		if ESX.Jobs[job] and ESX.Jobs[job].grades[grade] then
			return true
		end
	end

	return false
end

ESX.GetPlayerIdentifier = function(source, idtype)
    local src = source
    local idtype = idtype or 'steam'

    for _, identifier in pairs(GetPlayerIdentifiers(src)) do
        if string.find(identifier, idtype) then
            return identifier
        end
    end

    return nil
end

ESX.GetUsableItems = function()
	local Usables = {}
	for k in pairs(ESX.UsableItemsCallbacks) do
		Usables[k] = true
	end
	return Usables
end

ESX.GetDutyCount = function(job)
    local count = 0

    for k, src in pairs(ESX.GetPlayers()) do
		local v = ESX.GetPlayerFromId(src)
		
        if v.job.name == job and v.job.onDuty then
            count = count + 1
        end
    end

    return count
end

ESX.ReloadJobs = function(cb)
    ESX.Jobs = {}
	local Jobs = {}

	MySQL.Async.fetchAll('SELECT * FROM jobs', {}, function(jobs)
		for k,v in ipairs(jobs) do
			Jobs[v.name] = v
			Jobs[v.name].grades = {}
			Jobs[v.name].properties = json.decode(v.properties)
		end

		MySQL.Async.fetchAll('SELECT * FROM job_grades', {}, function(jobGrades)
			for k,v in ipairs(jobGrades) do
				if Jobs[v.job_name] then
					Jobs[v.job_name].grades[tostring(v.grade)] = v
					Jobs[v.job_name].grades[tostring(v.grade)].permissions = json.decode(v.permissions)
				else
					print(('[^3WARNING^7] Ignoring job grades for ^5"%s"^0 due to missing job'):format(v.job_name))
				end
			end

			for k2,v2 in pairs(Jobs) do
				if ESX.Table.SizeOf(v2.grades) == 0 then
					Jobs[v2.name] = nil
					print(('[^3WARNING^7] Ignoring job ^5"%s"^0due to no job grades found'):format(v2.name))
				end
			end
			
			ESX.Jobs = Jobs
			print("[kk-core] [^2INFO^7] Jobs reloaded!")
			cb()
		end)
	end)
end

ESX.UpdateCheck = function(source, type, amount)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		local payCheck = GetResourceKvpInt('paycheck_' .. xPlayer.identifier)

		if type == 'add' then
			SetResourceKvpInt('paycheck_' .. xPlayer.identifier, payCheck + tonumber(amount))
			TriggerClientEvent('KKF.Inventory.ShowNotification', xPlayer.source, '+' .. amount .. ' PALGALEHT')
		elseif type == 'remove' then
			SetResourceKvpInt('paycheck_' .. xPlayer.identifier, payCheck - tonumber(amount))
			TriggerClientEvent('KKF.Inventory.ShowNotification', xPlayer.source, '-' .. amount .. ' PALGALEHT')
		end
	end
end

local function GetPlayers() return ESX.Players end -- exports['kk-core']:GetPlayers()
exports("GetPlayers", GetPlayers)


