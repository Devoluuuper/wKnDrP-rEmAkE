local doorInfo = {}
local ox_inventory = exports.ox_inventory

Citizen.CreateThread(function()
	local xPlayers = #KKF.GetPlayers()
	local path = GetResourcePath(GetCurrentResourceName())
	path = path:gsub('//', '/')..'/server/states.json'
	local file = io.open(path, 'r')
	if not file or xPlayers == 0 then
		file = io.open(path, 'a')
		for k,v in pairs(Config.DoorList) do
			doorInfo[k] = v.locked
		end
	else
		local data = file:read('*a')
		file:close()
		if #json.decode(data) > #Config.DoorList then -- Config.DoorList contains less doors than states.json, so don't restore states
			return
		elseif #json.decode(data) > 0 then
			for k,v in pairs(json.decode(data)) do
				doorInfo[k] = v
			end
		end
	end
end) 

-- KKF.RegisterUsableItem('lockpick', function(source)
-- 	local src = source
--     local xPlayer = KKF.GetPlayerFromId(src)

-- 	if xPlayer then
-- 		TriggerClientEvent('KKF_lockpick:onUse', xPlayer.source)
-- 	end
-- end)

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
	local path = GetResourcePath(resourceName)
	path = path:gsub('//', '/')..'/server/states.json'
	local file = io.open(path, 'r+')
	if file and doorInfo then
		local json = json.encode(doorInfo)
		file:write(json)
		file:close()
	end
end)

RegisterServerEvent('nui_doorlock:updateState')
AddEventHandler('nui_doorlock:updateState', function(doorID, locked, src, usedLockpick, robbery)
	local playerId = source
	local xPlayer = KKF.GetPlayerFromId(playerId)

	if type(doorID) ~= 'number' then
		print(('nui_doorlock: %s (%s) didn\'t send a number! (Sent %s)'):format(xPlayer.getName(), xPlayer.identifier, doorID))
		return
	end

	if type(locked) ~= 'boolean' then
		print(('nui_doorlock: %s (%s) attempted to update invalid state! (Sent %s)'):format(xPlayer.getName(), xPlayer.identifier, locked))
		return
	end

	if not Config.DoorList[doorID] then
		print(('nui_doorlock: %s (%s) attempted to update invalid door! (Sent %s)'):format(xPlayer.getName(), xPlayer.identifier, doorID))
		return
	end
	
	if not IsAuthorized(xPlayer.job.name, xPlayer.job.grade, Config.DoorList[doorID], usedLockpick, xPlayer, xPlayer.job.onDuty, robbery) then
		return
	end

	doorInfo[doorID] = locked
	if not src then TriggerClientEvent('nui_doorlock:setState', -1, playerId, doorID, locked)
	else TriggerClientEvent('nui_doorlock:setState', -1, playerId, doorID, locked, src) end

	if Config.DoorList[doorID].autoLock then
		Citizen.SetTimeout(Config.DoorList[doorID].autoLock, function()
			if doorInfo[doorID] == true then return end
			doorInfo[doorID] = true
			TriggerClientEvent('nui_doorlock:setState', -1, -1, doorID, true)
		end)
	end
end)

lib.callback.register('nui_doorlock:getDoorInfo', function(source)
	return doorInfo
end)

function IsAuthorized(jobName, grade, doorID, usedLockpick, xPlayer, onDuty, robbery)
	local canOpen = false
	if doorID.lockpick and usedLockpick then
		count = ox_inventory:GetItem(xPlayer.source, 'lockpick').count 
		--count = exports['inventory']:getItemCount(source, 'lockpick')
		if count and count >= 1 then canOpen = true end
	end

	-- if job == jobName[1] and rank <= grade[1] and doorID.dutyRequired == true and xPlayer.job.onDuty or doorID.dutyRequired == false and job == jobName[1] and rank <= grade[1] then
 
	if not canOpen and doorID.authorizedJobs then
		for job,rank in pairs(doorID.authorizedJobs) do
			if job == jobName and rank <= grade and doorID.dutyRequired == true and onDuty or doorID.dutyRequired ~= true and job == jobName and rank <= grade or robbery then
				canOpen = true
				if canOpen then break end
			end
		end
		if not canOpen and not doorID.items then
			print(('nui_doorlock: %s (%s) was not authorized to open a locked door!'):format(xPlayer.getName(), xPlayer.identifier))
		end
	end

	if not canOpen and doorID.items then
		local count
		for k,v in pairs(doorID.items) do
			count = ox_inventory:GetItem(xPlayer.source, v).count
			if count and count >= 1 then canOpen = true break end
		end
		if not count or count < 1 then canOpen = false end
	end
	return canOpen
end

RegisterCommand('newdoor', function(playerId, args, rawCommand)
	local xPlayer = KKF.GetPlayerFromId(playerId)

	if xPlayer then
		if xPlayer.isAdmin() then
			if Player(playerId).state.adminMode then
				TriggerClientEvent('nui_doorlock:newDoorSetup', playerId, args)
			else
				TriggerClientEvent("chatMessage", playerId, "SÜSTEEM", 1, "Te ei ole veel administraatori õigusi sisse lülitanud.")
			end
		else
			TriggerClientEvent("chatMessage", playerId, "SÜSTEEM", 1, "Te ei ole veel administraator.")
		end
	end
end, true)

RegisterServerEvent('nui_doorlock:newDoorCreate')
AddEventHandler('nui_doorlock:newDoorCreate', function(model, heading, coords, jobs, item, doorLocked, maxDistance, slides, garage, doubleDoor, doorname)
	xPlayer = KKF.GetPlayerFromId(source)
	if not IsPlayerAceAllowed(source, 'command.newdoor') then print(xPlayer.getName().. 'attempted to create a new door but does not have permission') return end
	doorLocked = tostring(doorLocked)
	slides = tostring(slides)
	garage = tostring(garage)
	local newDoor = {}
	if jobs[1] then auth = tostring("['"..jobs[1].."']=0") end
	if jobs[2] then auth = auth..', '..tostring("['"..jobs[2].."']=0") end
	if jobs[3] then auth = auth..', '..tostring("['"..jobs[3].."']=0") end
	if jobs[4] then auth = auth..', '..tostring("['"..jobs[4].."']=0") end

	if auth then newDoor.authorizedJobs = { auth } end
	if item then newDoor.items = { item } end
	newDoor.locked = doorLocked
	newDoor.maxDistance = maxDistance
	newDoor.slides = slides
	if not doubleDoor then
		newDoor.garage = garage
		newDoor.objHash = model
		newDoor.objHeading = heading
		newDoor.objCoords = coords
		newDoor.fixText = false
	else
		newDoor.doors = {
			{objHash = model[1], objHeading = heading[1], objCoords = coords[1]},
			{objHash = model[2], objHeading = heading[2], objCoords = coords[2]}
		}
	end
		newDoor.audioRemote = false
		newDoor.lockpick = false
	local path = GetResourcePath(GetCurrentResourceName())
	path = path:gsub('//', '/')..'/config.lua'

	file = io.open(path, 'a+')
	if not doorname then label = '\n\n-- UNNAMED DOOR CREATED BY '..xPlayer.getName()..'\ntable.insert(Config.DoorList, {'
	else
		label = '\n\n-- '..doorname.. '\ntable.insert(Config.DoorList, {'
	end
	file:write(label)
	for k,v in pairs(newDoor) do
		if k == 'authorizedJobs' then
			local str =  ('\n	%s = { %s },'):format(k, auth)
			file:write(str)
		elseif k == 'doors' then
			local doorStr = {}
			for i=1, 2 do
				table.insert(doorStr, ('	{objHash = %s, objHeading = %s, objCoords = %s}'):format(model[i], heading[i], coords[i]))
			end
			local str = ('\n	%s = {\n	%s,\n	%s\n },'):format(k, doorStr[1], doorStr[2])
			file:write(str)
		elseif k == 'items' then
			local str = ('\n	%s = { \'%s\' },'):format(k, item)
			file:write(str)
		else
			local str = ('\n	%s = %s,'):format(k, v)
			file:write(str)
		end
	end
	file:write([[
		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000]])
	file:write('\n})')
	file:close()
	local doorID = #Config.DoorList + 1
	
	if jobs[4] then newDoor.authorizedJobs = { [jobs[1]] = 0, [jobs[2]] = 0, [jobs[3]] = 0, [jobs[4]] = 0 }
	elseif jobs[3] then newDoor.authorizedJobs = { [jobs[1]] = 0, [jobs[2]] = 0, [jobs[3]] = 0 }
	elseif jobs[2] then newDoor.authorizedJobs = { [jobs[1]] = 0, [jobs[2]] = 0 }
	elseif jobs[1] then newDoor.authorizedJobs = { [jobs[1]] = 0 } end
	if item then newDoor.Items = { item } end

	Config.DoorList[doorID] = newDoor
	doorInfo[doorID] = doorLocked 
	TriggerClientEvent('nui_doorlock:newDoorAdded', -1, newDoor, doorID, doorLocked)
end)