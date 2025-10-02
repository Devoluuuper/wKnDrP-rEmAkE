CreateThread(function()
	KKF.PlayerData = KKF.GetPlayerData()
end)

RegisterNetEvent('kk-factions:client:displayEAS', function(message, duration, faction)
	while not LocalPlayer.state.isLoggedIn do
		Wait(5)
	end

	SendNUIMessage({action = 'factionAlert', data = {message = message, duration = duration, faction = faction:upper()}})
end)

RegisterNetEvent('KKF.Player.JobUpdate', function(job)
	KKF.PlayerData.job = job
end)

RegisterNetEvent('KKF.Player.DutyChange', function(value) 
    KKF.PlayerData.job.onDuty = value 
end)

RegisterNetEvent('KKF.Player.Loaded', function(xPlayer)
	KKF.PlayerData = xPlayer
end)

RegisterNetEvent('KKF.Player.Unloaded', function() 
	KKF.PlayerData = {}
end)

RegisterNUICallback('loadTablet', function(args, cb)
	lib.callback('kk-factions:requestFactions', false, function(response, reputation, crypto, --[[zones,]] racerData, taxiData)
		cb({faction = KKF.PlayerData.job, --[[zones = zones,]] factions = response, reputation = reputation, crypto = crypto, racerData = racerData, taxiData = taxiData})
	end)
end)

local function openTablet()
	SendNUIMessage({action = 'open', data = { vat = exports['kk-taxes']:getTax('primary').value }}); SetNuiFocus(true, true); exports['kk-scripts']:toggleTab(true)
end

RegisterNetEvent('kk-factions:openMenu', openTablet)

RegisterNUICallback('closeTablet', function()
    SendNUIMessage({action = 'close'}); SetNuiFocus(false, false); exports['kk-scripts']:toggleTab(false)
end)

RegisterNUICallback('setPage', function(args, cb)
    SendNUIMessage({action = 'setPage', page = args.page})
end) 

RegisterNUICallback('requestCallsign', function(args, cb)
	lib.callback('kk-factions:requestCallsign', false, function(response)
		cb(response)
	end, args.target)
end)

RegisterNUICallback('changeCallsign', function(args, cb)
	lib.callback('kk-factions:changeCallsign', false, function(response)
		cb(response)
	end, args.id, args.callsign)
end)

RegisterNUICallback('loadMembers', function(args, cb)
	lib.callback('kk-factions:loadMembers', false, function(response, faction)
		cb({data = response, faction = faction})
	end)
end)

RegisterNUICallback('loadGarages', function(args, cb)
	lib.callback('kk-factions:loadGarages', false, function(response)
		cb(response)
	end, args.car)
end)

RegisterNUICallback('firePerson', function(args, cb)
	lib.callback('kk-factions:firePerson', false, function(response)
		cb(response)
	end, args.id)
end) 

RegisterNUICallback('setRank', function(args, cb)
	lib.callback('kk-factions:setRank', false, function(response)
		cb(response)
	end, args.id, args.rank)
end)

RegisterNUICallback('loadWorkTimes', function(args, cb)
	lib.callback('kk-factions:loadWorkTimes', false, function(response)
		cb(response)
	end, args.id)
end) 

RegisterNUICallback('leaveFaction', function(args, cb)
	lib.callback('kk-factions:leaveFaction', false, function(response)
		cb(response)
	end, args.job)
end)

RegisterNUICallback('changeFaction', function(args, cb)
	lib.callback('kk-factions:changeFaction', false, function(response)
		cb(response)
	end, args.job)
end)

RegisterNUICallback('buyVehicle', function(args, cb)
	lib.callback('kk-factions:buyVehicle', false, function(response)
		cb(response)
	end, args.car, args.garage)
end)

RegisterNUICallback('loadBuyableVehicles', function(args, cb)
	lib.callback('kk-factions:loadBuyableVehicles', false, function(response)
		data = response or {}

		for k,v in pairs(data) do
			if not data[k].label then
				data[k].label = GetLabelText(GetDisplayNameFromVehicleModel(joaat(k)))
			end
		end
	
		cb(data)
	end)
end)

RegisterNUICallback('getNearbyPlayers', function(args, cb)
	local data = {}

	data.players = lib.getNearbyPlayers(GetEntityCoords(cache.ped), 10.0, false)

	for i = 1, #data.players do
		data.players[i].serverId = GetPlayerServerId(data.players[i].id) 
	end

	data.ranks = lib.callback.await('kk-factions:requestRanks', false)

	if #data.players == 0 then
		TriggerEvent('kk-factions:client:sendNotification', 'error', 'Fraktsiooni lisamine', 'Läheduses ei viibi ühtegi isikut!')
		cb(false)
	else
		cb(data)
	end	
end) 

RegisterNUICallback('recruitPlayer', function(args, cb)
	lib.callback('kk-factions:recruitPlayer', false, function(response)
		cb(response)
	end, args.id, args.rank)
end)

RegisterNUICallback('requestRanks', function(args, cb)
	lib.callback('kk-factions:requestRanks', false, function(response)
		cb(response)
	end)
end)

RegisterNUICallback('searchLogs', function(args, cb)
	lib.callback('kk-factions:searchLogs', false, function(response)
		cb(response)
	end, args.id, args.search, args.page)
end) 
 
RegisterNUICallback('loadVehicles', function(args, cb)
	lib.callback('kk-factions:loadVehicles', false, function(response)
		for i = 1, #response do
			response[i].model = GetLabelText(GetDisplayNameFromVehicleModel(response[i].model))
		end

		cb(response)
	end)
end)  

RegisterNetEvent('kk-factions:client:reloadAnnouncments', function() 
	SendNUIMessage({action = 'reloadAnnouncments'})
end)

RegisterNUICallback('loadAnnouncments', function(args, cb)
    lib.callback('kk-factions:loadAnnouncments', false, function(response)
        cb(response)
    end)
end)

RegisterNUICallback('deleteAnnouncement', function(args, cb)
    lib.callback('kk-factions:deleteAnnouncement', false, function(response)
        cb(response)
    end, args.id)
end)

RegisterNUICallback('createAnnouncement', function(args, cb)
	lib.callback('kk-factions:createAnnouncement', false, function(response)
		cb(response)
	end, args.title, args.description)
end) 

RegisterNUICallback('finishAnnouncementEditing', function(args, cb)
	lib.callback('kk-factions:finishAnnouncementEditing', false, function(response)
		cb(response)
	end, args.id, args.title, args.description)
end) 

RegisterNUICallback('editAnnouncement', function(args, cb)
	lib.callback('kk-factions:editAnnouncement', false, function(response)
		cb(response)
	end, args.id)
end) 

RegisterNUICallback('createRank', function(args, cb)
	lib.callback('kk-factions:createRank', false, function(response)
		cb(response)
	end, args.id, args.label, args.short, args.salary, args.permissions)
end) 

RegisterNUICallback('deleteRank', function(args, cb)
	lib.callback('kk-factions:deleteRank', false, function(response)
		cb(response)
	end, args.id)
end) 

RegisterNUICallback('editRank', function(args, cb)
	lib.callback('kk-factions:editRank', false, function(response)
		cb(response)
	end, args.id)
end)

RegisterNUICallback('saveRank', function(args, cb)
	lib.callback('kk-factions:saveRank', false, function(response)
		cb(response)
	end, args.id, args.label, args.short, args.salary, args.permissions)
end) 

RegisterNetEvent('kk-factions:client:sendNotification', function(type, title, message)
	SendNUIMessage({action = 'sendNotification', data = {type = type, title = title, message = message}})
end)

RegisterNetEvent('kk-factions:client:updateCrypto', function(count)
	SendNUIMessage({action = 'updateCrypto', data = {crypto = tostring(count)}})
end)

function getVehicle(label)
	local vehicle = nil

	for k,v in pairs(cfg.vehicles) do
		for k2,v2 in pairs(v) do
			if joaat(k2) == label then
				vehicle = v2
			end
		end
	end

	return vehicle
end

exports('getVehicle', getVehicle)

exports('getVehiclePrice', function(model)
	local returnable = nil

	for k,v in pairs(cfg.vehicles) do
		for k2,v2 in pairs(v) do
			if joaat(k2) == model then
				returnable = v2.price
			end
		end
	end

    return returnable
end)

local function canSell(faction)
	local returnable = false

	for k,v in pairs(cfg.sellFunctions) do
		if v == faction then
			returnable = true
		end
	end

	return returnable
end

exports('canSell', canSell)

RegisterNetEvent('kk-factions:client:sellVehicle', function(price)
    local confirmed = lib.alertDialog({
        header = 'Sõiduki ost',
        content = 'Hind: $' .. price,
        centered = true,
        cancel = true
    })

	if confirmed == 'confirm' then
        TriggerServerEvent('kk-factions:server:acceptVehicle')
    else
        TriggerServerEvent('kk-factions:server:declineVehicle')
    end
end)

TriggerEvent("chat:addSuggestion", "/sellFactionVehicle", "Müü sõiduk, milles istud kellegile.", { { name = "id" }, { name = "price" } }) 
TriggerEvent("chat:addSuggestion", "/setFactionVehicle", "Lisa omatud sõiduk fraktsiooni.") 
TriggerEvent("chat:addSuggestion", "/announce", "Fraktsiooni teadaanne.", { { name = "kestus (sekundites)" }, { name = "sisu" } }) 