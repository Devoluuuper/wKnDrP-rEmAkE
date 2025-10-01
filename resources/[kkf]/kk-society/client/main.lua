local tablet = false
local storedJob = 'unemployed'
-- local peds = {}

-- local function loadBlips()
-- 	for k,v in pairs(Config.Garages) do
-- 		if ESX.PlayerData.job.name == v.job and ESX.PlayerData.job.onDuty then
-- 			ESX.CreateBlip(k, vector3(v.spawnPos.x, v.spawnPos.y, v.spawnPos.z), v.type == 'car' and 'Töösõidukite garaaz' or v.type == 'helicopter' and 'Helikopterite garaaz', v.type == 'car' and 50 or v.type == 'helicopter' and 43, nil, 0.7)
-- 		else
-- 			ESX.RemoveBlip(k)
-- 		end
-- 	end
-- end

-- local function loadAnimDict(dict)
-- 	while not HasAnimDictLoaded(dict) do
-- 		RequestAnimDict(dict)
-- 		Wait(5)
-- 	end
-- end

-- local function registerPeds()
--     lib.requestModel(`s_m_m_autoshop_02`)

-- 	for k,v in pairs(Config.Garages) do
-- 		local entity = CreatePed(4, `s_m_m_autoshop_02`, v.spawnPos.x, v.spawnPos.y, v.spawnPos.z - 1, v.spawnPos.h or 0, false, false)

-- 		SetBlockingOfNonTemporaryEvents(entity, true)
-- 		SetPedDiesWhenInjured(entity, false)
-- 		SetPedCanPlayAmbientAnims(entity, true)
-- 		SetPedCanRagdollFromPlayerImpact(entity, false)
-- 		SetEntityInvincible(entity, true)
-- 		FreezeEntityPosition(entity, true)

-- 		loadAnimDict('missfam4')
-- 		TaskPlayAnim(entity, 'missfam4', 'base', 8.0, 1.0, -1, 49, 0, 0, 0, 0)

-- 		local newProp = CreateObject(`p_amb_clipboard_01`, GetEntityCoords(entity).x, GetEntityCoords(entity).y, GetEntityCoords(entity).z + 0.2, true, true, true)

-- 		while not DoesEntityExist(newProp) do Wait(50) end

-- 		SetEntityCollision(newProp, false, false)
-- 		AttachEntityToEntity(newProp, entity, GetPedBoneIndex(entity, 36029), 0.16, 0.08, 0.1, -130.0, -50.0, 0.0, true, true, false, true, 1, true)
	
-- 		peds[#peds + 1] = {entity = entity, prop = newProp}
-- 	end
-- end

-- local function deRegisterPeds()
-- 	for k,v in pairs(peds) do
-- 		DeleteEntity(peds[k].prop); DeleteEntity(peds[k].entity); peds[k] = nil
-- 	end
-- end

CreateThread(function()
	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('KKF.Player.JobUpdate')
AddEventHandler('KKF.Player.JobUpdate', function(job)
	-- ESX.PlayerData.job = job; loadBlips()
	ESX.PlayerData.job = job
end)

RegisterNetEvent('KKF.Player.Loaded')
AddEventHandler('KKF.Player.Loaded', function(xPlayer)
	ESX.PlayerData = xPlayer

	-- loadLoops(); loadBlips(); registerPeds()
end)

RegisterNetEvent('KKF.Player.Unloaded', function() 
	-- ESX.PlayerData = {}; deRegisterPeds()
	ESX.PlayerData = {}
end)

--RegisterCommand('manualLoad', function() loadLoops(); loadBlips() end)

-- RegisterNetEvent('KKF.Player.DutyChange') AddEventHandler('KKF.Player.DutyChange', function(value) ESX.PlayerData.job.onDuty = value; loadBlips() end)

RegisterNetEvent('KKF.Player.DutyChange') AddEventHandler('KKF.Player.DutyChange', function(value) 
	ESX.PlayerData.job.onDuty = value 
end)

AddEventHandler('kk-society:openBossMenu', function(society, close, options)
	showMdw()
end)

RegisterNUICallback('buySafe', function(args, cb)
	TriggerServerEvent('kk-society:server:buySafe'); Wait(500)

	lib.callback('kk-society:loadHome', false, function(cb)
		SendNUIMessage({ action = "updateHome", data = cb })
	end, ESX.PlayerData.job.name)
end)

RegisterNUICallback("reloadAllData", function(args, cb)
	lib.callback('kk-society:loadBills', false, function(cb) 
		SendNUIMessage({ action = "loadBills", data = cb })
	end, ESX.PlayerData.job.name)
	
	lib.callback('kk-society:getEmployees', false, function(cb)
		SendNUIMessage({ action = "loadMembers", data = cb })
	end, ESX.PlayerData.job.name)

	lib.callback('kk-society:getVehicles', false, function(cb)
		SendNUIMessage({ action = "loadVehicles", data = cb })
	end, ESX.PlayerData.job.name)

	lib.callback('kk-society:loadRanks', false, function(cb)
		SendNUIMessage({ action = "loadRanks", data = cb })
		SendNUIMessage({ action = "loadAllRanks", data = cb })
	end, ESX.PlayerData.job.name)

	lib.callback('kk-society:loadHome', false, function(cb)
		SendNUIMessage({ action = "updateHome", data = cb })
	end, ESX.PlayerData.job.name)
end)

RegisterNUICallback("chooseSociety", function(args, cb)
	lib.callback('kk-society:chooseSociety', false, function(response)
		cb('ok')
	end, {args.name, args.grade})
end)

local function toggleTab(toggle)
    if toggle and not tablet then
        tablet = true

		if not cache.vehicle then
			CreateThread(function()
				lib.requestAnimDict('amb@code_human_in_bus_passenger_idles@female@tablet@base')

				local tabletObj = exports['kk-scripts']:spawnAttachedObject(cache.ped, joaat('prop_cs_tablet'), 60309, 0.03, 0.002, -0.0, 10.0, 160.0, 0.0)
				SetCurrentPedWeapon(cache.ped, `weapon_unarmed`, true)

				while tablet do
					Wait(100)

					if not IsEntityPlayingAnim(cache.ped, 'amb@code_human_in_bus_passenger_idles@female@tablet@base', 'base', 3) then
						TaskPlayAnim(cache.ped, 'amb@code_human_in_bus_passenger_idles@female@tablet@base', 'base', 3.0, 3.0, -1, 49, 0, 0, 0, 0)
					end
				end

				ClearPedSecondaryTask(cache.ped)

				Wait(450)

				DetachEntity(tabletObj, true, false); DeleteEntity(tabletObj)
			end)
		end
    elseif not toggle and tablet then
        tablet = false
    end
end

function showMdw()
	SendNUIMessage({ action = "setJob", data = ESX.PlayerData.job.name })
    SendNUIMessage({ action = "openMdw", data = ESX.PlayerData.job.permissions})
	
    local isInVeh = IsPedInAnyVehicle(PlayerPedId(), false)

    if not isInVeh then
        SetPlayerControl(PlayerId(), 0, 0)
    end

    guiEnabled = true
    SetNuiFocus(true, true)

    toggleTab(true)
end

RegisterNUICallback("disableFocus", function(args, cb)
    if not guiEnabled then
        return
    end

    SetPlayerControl(PlayerId(), 1, 0)
    SetNuiFocus(false, false)

    guiEnabled = false

	toggleTab(false)
end) 

RegisterNUICallback("leaveSociety", function(args, cb)
	TriggerServerEvent('kk-society:server:leaveFromCompany')
end)

RegisterNUICallback("requestLogs", function(args, cb)
	lib.callback('kk-society:loadLogs', false, function(cb)
		SendNUIMessage({ action = "loadLogs", data = cb })
	end, args.pid, args.context)
end)

RegisterNUICallback("createNewRank", function(args, cb)
    TriggerServerEvent('kk-society:server:createNewRank', args.rankName)
end)

RegisterNUICallback("inviteToCompany", function(args, cb)
	TriggerServerEvent('kk-society:server:inviteToCompany', args.invitedCharacterId)
end)

RegisterNetEvent('kk-society:client:sendInvitation', function(data)
	if guiEnabled then return end
	storedJob = data[1]; SetNuiFocus(true, true)
	SendNUIMessage({ action = "invitationOpen", name = data[2] })
end)

RegisterNUICallback("acceptInvitation", function(args, cb)
    TriggerServerEvent('kk-society:server:acceptInvitation', storedJob)
	storedJob = 'unemployed'; SetNuiFocus(false, false)
end)

RegisterNUICallback("declineInvitation", function(args, cb)
	if storedJob == 'unemployed' then return end
    TriggerServerEvent('kk-society:server:declineInvitation')
	storedJob = 'unemployed'; SetNuiFocus(false, false)
end)

RegisterNUICallback("buyVehicle", function(args, cb)
    TriggerServerEvent('kk-society:server:buyVehicle', args.selectedId)
end)

RegisterNUICallback("removeFromCompany", function(args, cb)
    TriggerServerEvent('kk-society:server:removeFromCompany', args.invitedCharacterId)
end)

RegisterNUICallback("changeRank", function(args, cb)
    TriggerServerEvent('kk-society:server:changeRank', args.invitedCharacterId, args.gradeId)
end)

RegisterNUICallback("loadEditRank", function(args, cb)
	lib.callback('kk-society:loadEditRank', false, function(cb)
		SendNUIMessage({ action = "updateRankEditSection", data = cb })
	end, args.rankId)
end)

RegisterNUICallback("deleteRank", function(args, cb)
	TriggerServerEvent('kk-society:server:deleteRank', tonumber(args.rankId))
end)

RegisterNUICallback("saveRank", function(args, cb)
	TriggerServerEvent('kk-society:server:saveRank', tonumber(args.rankId), tonumber(args.rankSalary), args.permissions)
end)

RegisterNUICallback("refreshHome", function(args, cb)
	lib.callback('kk-society:loadHome', false, function(cb)

		SendNUIMessage({ action = "updateHome", data = cb })
	end, ESX.PlayerData.job.name)
end)

RegisterNUICallback("refreshRanksButton", function(args, cb)
	lib.callback('kk-society:loadRanks', false, function(cb) 
		SendNUIMessage({ action = "loadRanks", data = cb })
		SendNUIMessage({ action = "loadAllRanks", data = cb })
	end, ESX.PlayerData.job.name)
end)

RegisterNUICallback("refreshMembersButton", function(args, cb)
	lib.callback('kk-society:getEmployees', false, function(cb)
		SendNUIMessage({ action = "loadMembers", data = cb })
	end, ESX.PlayerData.job.name)
end)

RegisterNUICallback("refreshBillsButton", function(args, cb)
	lib.callback('kk-society:loadBills', false, function(cb) 
		SendNUIMessage({ action = "loadBills", data = cb })
	end, ESX.PlayerData.job.name)
end)

RegisterNUICallback("openBadge", function(args, cb)
	local keyboard = lib.inputDialog('Ametitõendi redigeerimine', {'Seeria NR (1 - 99)', 'Osakond (BCSO või LSPD)'})

	if keyboard then
		local serial = keyboard[1]; local department = keyboard[2] 

        if serial and department then
			TriggerServerEvent('kk-society:server:editBadge', args.pid, {serial = serial, department = department})
		else
			TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ametitõendi redigeerimiseks sisestage kõik read!')
        end
	end
end)

RegisterNUICallback("openSign", function(args, cb)
	local keyboard = lib.inputDialog('Kutsungi muutmine', {'Kutsung (1 - 99)'})

	if keyboard then
		local serial = keyboard[1];

        if serial then
			TriggerServerEvent('kk-society:server:editBadge', args.pid, {serial = serial, department = 'LSPD'})
		else
			TriggerEvent('KKF.UI.ShowNotification', 'error', 'Pead mingi numbri panema ja')
        end
	end
end)

RegisterNUICallback("refreshVehiclesButton", function(args, cb)
	lib.callback('kk-society:getVehicles', false, function(cb) 
		SendNUIMessage({ action = "loadVehicles", data = cb })
	end, ESX.PlayerData.job.name)
end)

RegisterNetEvent('kk-society:client:showNotify')
AddEventHandler('kk-society:client:showNotify', function(title, text, type)
	SendNUIMessage({ 
		action = 'showNotification', 
		data = {
			title = title,
			text = text,
			type = type
		}
	})
end)
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------

-- local function openGarage(name, type)
--     lib.callback('kk-garage:getFactionVehicles', false, function(vehicles)
--         local elements = {}

--         for k,v in pairs(vehicles) do
--             if v.type == type then
--                 local vehData = json.decode(v.vehicle) 

--                 if v.stored then
--                     local vehicleLabel = GetDisplayNameFromVehicleModel(vehData.model); vehicleLabel = GetLabelText(vehicleLabel)

--                     elements[v.plate] = {
--                         description = vehicleLabel,
--                         args = {plate = v.plate, data = vehData, name = name},
--                         event = 'kk-society:client:spawnVehicle'
--                     }
--                 end
--             end
--         end

--         lib.registerContext({
--             id = 'job_garage',
--             title = 'Töösõidukite garaaz',
--             options = elements
--         })

--         lib.showContext('job_garage')
--     end, name, type)
-- end

-- RegisterNetEvent('kk-society:client:spawnVehicle', function(val)
-- 	local triedSpawnPoints = {}
-- 	local spawnPoint = nil
-- 	local success = nil

-- 	while true do
-- 		local spawnID = math.random(#Config.Garages[val.name].spawnPoints)
-- 		local spawn = Config.Garages[val.name].spawnPoints[spawnID]
-- 		local isClear = ESX.Game.IsSpawnPointClear(spawn, 2.5)

-- 		if isClear then
-- 			success = true
-- 			spawnPoint = spawn
-- 			break
-- 		else
-- 			triedSpawnPoints[spawnID] = true
-- 			success = false
-- 		end

-- 		if #triedSpawnPoints == #Config.Garages[val.name].spawnPoints then
-- 			success = false
-- 			TriggerEvent('KKF.UI.ShowNotification',"error", "Parklas pole ühtegi vaba parkimiskohta.")
-- 			break
-- 		end

-- 		Wait(50)
-- 	end
	
-- 	lib.callback('KKF.Vehicle.SpawnOwnedVehicle', 500, function(networkId)
-- 		if not networkId then 
-- 			TriggerEvent('KKF.UI.ShowNotification', "error", "Tekkis viga!")
-- 			return 
-- 		end 

-- 		while not NetworkDoesEntityExistWithNetworkId(networkId) do
-- 			Wait(10)
-- 		end

--         local vehicle = NetworkGetEntityFromNetworkId(networkId)
--         ESX.Game.RequestNetworkControlOfEntity(vehicle)
--         SetVehRadioStation(vehicle, "OFF")
-- 		TriggerEvent('KKF.UI.ShowNotification', "success", "Sõiduk väljastatud garaazist!")
-- 	end, val.plate, spawnPoint)
-- end)

-- function loadLoops()
-- 	while ESX.PlayerData.job == nil do Wait(20) end
	
-- 	CreateThread(function()
-- 		local alreadyEnteredZone = false
-- 		local text = ''

-- 		while true do
-- 			wait = 5
-- 			local ped = PlayerPedId()
-- 			local inZone = false

-- 			for k,v in pairs(Config.Garages) do
-- 				if LocalPlayer.state['isLoggedIn'] then
-- 					if v.job == ESX.PlayerData.job.name and ESX.PlayerData.job.onDuty and ESX.PlayerData.job.permissions.garage then
-- 						local dist = #(GetEntityCoords(ped) - vector3(v.spawnPos.x, v.spawnPos.y, v.spawnPos.z))

-- 						if dist <= 5.0 then
-- 							if not cache.vehicle then
-- 								text = '[E] - Ava garaaz'
-- 							else
-- 								text = '[E] - Hoiusta sõiduk'
-- 							end

-- 							wait = 5
-- 							inZone  = true
							
-- 							if IsControlJustPressed(0, 38) then 
-- 								if not cache.vehicle then
-- 									openGarage(k, v.type)
-- 								else
-- 									lib.callback('KKF.Vehicle.DeleteOwnedVehicle', 500, function(status)
-- 										if status then
-- 											TriggerEvent('KKF.UI.ShowNotification', "success","Sõiduk edukalt hoiustatud!"); ESX.HideInteraction()
-- 											ESX.ShowInteraction('Ava garaaz', 'E')
-- 										else
-- 											TriggerEvent('KKF.UI.ShowNotification', "error","Tundub, et sõiduk ei kuulu teile! või te ei saa seda siia parkida.")
-- 										end
-- 									end, ESX.Game.GetVehicleProperties(cache.vehicle))
-- 								end
-- 							end

-- 							break
-- 						else
-- 							wait = 2000
-- 						end
-- 					else
-- 						wait = 2000
-- 					end
-- 				else
-- 					wait = 2000
-- 				end
-- 			end
			
-- 			if inZone and not alreadyEnteredZone then
-- 				alreadyEnteredZone = true
-- 				ESX.ShowInteraction(text)
-- 			end

-- 			if not inZone and alreadyEnteredZone then
-- 				alreadyEnteredZone = false
-- 				ESX.HideInteraction()
-- 			end

-- 			Wait(wait)
-- 		end
-- 	end)
-- end

RegisterCommand('lisaFraktsiooni', function()
	if LocalPlayer.state['isLoggedIn'] then
		if ESX.PlayerData.job.name ~= 'unemployed' then
			if cache.vehicle then
				local plate = GetVehicleNumberPlateText(cache.vehicle)

				lib.callback('kk-society:canAddVehicle', false, function(response)
					if response then
						TriggerEvent('KKF.UI.ShowNotification', 'success', 'Lisasite sõiduki ' .. plate .. ' fraktsiooni!')
					else
						TriggerEvent('KKF.UI.ShowNotification', 'error', 'Antud sõiduk ei kuulu teile või teil ei ole piisavalt õigusi!')
					end
				end, plate)
			else
				TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te peate olema üleviimise jaoks sõidukis!')
			end
		else
			TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ei kuulu ühtegi fraktsiooni!')
		end
	end
end)

TriggerEvent('chat:addSuggestion', '/lisaFraktsiooni', 'Lisa sõiduk fraktsiooni.', {})

RegisterCommand('eemaldaFraktsioonist', function()
	if LocalPlayer.state['isLoggedIn'] then
		if ESX.PlayerData.job.name ~= 'unemployed' then
			if cache.vehicle then
				local plate = GetVehicleNumberPlateText(cache.vehicle)

				lib.callback('kk-society:canRemoveVehicle', false, function(response)
					if response then
						TriggerEvent('KKF.UI.ShowNotification', 'info', 'Eemaldasite sõiduki ' .. plate .. ' fraktsioonist!')
					else
						TriggerEvent('KKF.UI.ShowNotification', 'error', 'Antud sõiduk ei kuulu teie fraktsiooni või teil ei ole piisavalt õigusi!')
					end
				end, plate)
			else
				TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te peate olema üleviimise jaoks sõidukis!')
			end
		else
			TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ei kuulu ühtegi fraktsiooni!')
		end
	end
end)

TriggerEvent('chat:addSuggestion', '/eemaldaFraktsioonist', 'Eemalda sõiduk fraktsioonist.', {})