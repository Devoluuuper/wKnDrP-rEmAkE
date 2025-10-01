local timeout = false
local peds = {}
local currentVehicle = {}
local ox_target = exports.ox_target
local gps = {}

local defaultCallsignItems = { 8, 9, 10 }

local mapOpend = false

CreateThread(function()
	while true do
        if IsPauseMenuActive() and not mapOpend then
            mapOpend = true
            SendNUIMessage({ action = 'hideAll' })
        elseif not IsPauseMenuActive() and mapOpend then
            mapOpend = false
            SendNUIMessage({ action = 'showAll' })
        end

		Wait(800)
	end
end)

local function hasLetters(value)
    for i = 1, #value do
        if string.match(value, '%a') then
            return true
        end
    end

    return false
end

TriggerEvent('chat:addSuggestion', '/csign', 'Muuda sõiduki kutsungit.')

RegisterNetEvent('kk-police:client:setCallsign', function(callsign)
	if cache.vehicle then
		local callsignItems = defaultCallsignItems

		if #callsign <= 3 and #callsign > 0 and not hasLetters(callsign) then
			if #callsign == 1 then
				callsign = '00' .. callsign
			elseif #callsign == 2 then
				callsign = '0' .. callsign
			end

			TriggerServerEvent('kk-police:server:sendLog', 'KUTSUNG', 'Auto ' .. ESX.Game.GetPlate(cache.vehicle) .. ' uus kutsung ' .. callsign .. '.')

			local numbers = {}

			for i = 1, #callsign do
				local digit = tonumber(string.sub(callsign, i, i))
				table.insert(numbers, digit)
			end

			SetVehicleModKit(cache.vehicle, 0)

			for k,v in pairs(numbers) do
				SetVehicleMod(cache.vehicle, callsignItems[k], v)
			end
		else
			TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ebakorrektne kutsung!')
		end
	else
		TriggerEvent('KKF.UI.ShowNotification', 'error', 'Antud käskluse kasutamiseks peate viibima sõidukis!')
	end
end)

local function registerPeds()
	SetTimeout(5000, function()
	    for k,v in pairs(cfg.stations) do
			if v.vehicleActions then
				exports['kk-scripts']:requestModel(`csb_trafficwarden`)
				local entity = CreatePed(4, `csb_trafficwarden`, v.vehicleActions.x, v.vehicleActions.y, v.vehicleActions.z - 1, v.vehicleActions.w or 0, false, false)
	
				SetBlockingOfNonTemporaryEvents(entity, true)
				SetPedDiesWhenInjured(entity, false)
				SetPedCanPlayAmbientAnims(entity, true)
				SetPedCanRagdollFromPlayerImpact(entity, false)
				SetEntityInvincible(entity, true)
				FreezeEntityPosition(entity, true)
				peds[#peds + 1] = entity
	
				exports.ox_target:addLocalEntity(entity, {
					{
						name = 'checkVehicle',
						distance = 3.0,
						icon = 'fa-solid fa-tablet',
						label = 'Tuvasta sõiduk VIN-i abil',
						canInteract = function()
							return cache.vehicle and (ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.onDuty)
						end,
						onSelect = function()
							if DoesEntityExist(cache.vehicle) then
								lib.callback('kk-police:checkVin', false, function(response)
									if response then
										TriggerEvent('KKF.UI.ShowNotification', 'success', 'Sõiduki omanik on: ' .. response)
									else
										TriggerEvent('KKF.UI.ShowNotification', 'error', 'Antud sõidukit ei ole andmebaasis.')
									end
								end, Entity(cache.vehicle).state.plate or GetVehicleNumberPlateText(cache.vehicle))
							end
						end
					},
	
					{
						name = 'impoundVehicle',
						distance = 3.0,
						icon = 'fa-solid fa-car',
						label = 'Sõiduki teisaldamine',
						canInteract = function()
							return cache.vehicle and (ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.onDuty)
						end,
						onSelect = function()
							if DoesEntityExist(cache.vehicle) then
								local timeOptions = {
									{ value = 1, label = '1 päev' },
									{ value = 3, label = '3 päeva' },
									{ value = 5, label = '5 päeva' },
								}
	
								if ESX.PlayerData.job.permissions.leaderMenu then
									timeOptions[#timeOptions + 1] = { value = 0, label = 'Igavesti' }
								end
	
								local input = lib.inputDialog('Sõiduki teisaldamine', {
									{ 
										type = 'input', 
										label = 'Kirjeldus', 
										placeholder = 'Lühikirjeldus...' 
									},
	
									{ 
										type = 'select', 
										label = 'Aeg', 
										options = timeOptions
									}
								})
								
								if input then 
									if input[1] and input[2] then
										lib.callback('kk-police:impoundVehicle', false, function(response)
											if not response then
												TriggerEvent('KKF.UI.ShowNotifcation', 'error', 'Tekkis viga teisaldamisel!')
											end
										end, NetworkGetNetworkIdFromEntity(cache.vehicle), input[1], input[2], ESX.Game.GetVehicleProperties(cache.vehicle))
									else
										TriggerEvent('KKF.UI.ShowNotifcation', 'error', 'Te ei määranud sõiduki teisaldamisele infot!')
									end
								end
							end
						end
					},
	
					{
						name = 'tuneVehicle',
						distance = 3.0,
						icon = 'fa-solid fa-hashtag',
						label = 'Katusenumbrid',
						canInteract = function()
							return cache.vehicle and (ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.onDuty)
						end,
						onSelect = function()
							if DoesEntityExist(cache.vehicle) then
								local options = {}
	
								for i = 1, #cfg.tuningItems, 1 do
									local modCount = GetNumVehicleMods(cache.vehicle, cfg.tuningItems[i].value) - 1
	
									if modCount ~= -1 then
										options[#options + 1] = { label = cfg.tuningItems[i].label, args = {value = cfg.tuningItems[i].value, modCount = modCount, label = cfg.tuningItems[i].label } }
									end
								end
	
								if #options > 0 then
									ESX.Game.RequestNetworkControlOfEntity(cache.vehicle)
									FreezeEntityPosition(cache.vehicle, true)
									currentVehicle = exports['kk-vehicles']:getVehicleProperties(cache.vehicle)
	
									lib.registerMenu({
										id = 'police_tuning',
										title = 'Katusenumbrid',
										position = 'top-right',
	
										onClose = function(keyPressed)
											exports['kk-vehicles']:setVehicleProperties(cache.vehicle, currentVehicle)
											FreezeEntityPosition(cache.vehicle, false)
										end,
	
										options = options
									}, function(selected, scrollIndex, args)
										local newelements = {}
	
										for i = -1, args.modCount, 1 do
											local customText = 'NONE'
	
											if cfg.tuningValues[args.value] and cfg.tuningValues[args.value][i] then
												customText = cfg.tuningValues[args.value][i]
											end
	
											local text = i == -1 and 'Puudub' or i .. ' - ' .. customText
	
											if GetVehicleMod(cache.vehicle, args.value) == i then
												text = text .. ' - [ON]'
											end
	
											newelements[#newelements + 1] = { label = text, args = { value = i } }
										end
							
										SetVehicleMod(cache.vehicle, args.value, -1)
	
										if args.value == 48 then
											RemoveVehicleMod(cache.vehicle, 48)
											SetVehicleLivery(cache.vehicle, -1)
										end
	
										lib.registerMenu({
											id = 'police_tuning_second',
											title = args.label,
											position = 'top-right',
	
											onClose = function(keyPressed)
												FreezeEntityPosition(cache.vehicle, false)
												exports['kk-vehicles']:setVehicleProperties(cache.vehicle, currentVehicle)
												lib.showMenu('police_tuning')
											end,
	
											onSelected = function(selected, secondary, subArg)
												if args.value == 48 then 
													if subArg.value == -1 then
														RemoveVehicleMod(cache.vehicle, 48)
														SetVehicleLivery(cache.vehicle, -1)
													else
														SetVehicleLivery(cache.vehicle, subArg.value)
														SetVehicleMod(cache.vehicle, 48, subArg.value, false)    
													end
												else
													SetVehicleMod(cache.vehicle, args.value, subArg.value)
												end
											end,
	
											options = newelements
										}, function(selected, scrollIndex, args)
											ESX.Game.RequestNetworkControlOfEntity(cache.vehicle)
											currentVehicle = exports['kk-vehicles']:getVehicleProperties(cache.vehicle)
											TriggerServerEvent('kk-police:server:sendLog', 'KUTSUNG', 'Auto ' .. ESX.Game.GetPlate(cache.vehicle) .. ' numbrite muutmine.')
											lib.showMenu('police_tuning')
										end)
	
										lib.showMenu('police_tuning_second')
									end)
	
									lib.showMenu('police_tuning')
								else
									TriggerEvent('KKF.UI.ShowNotification', 'error', 'Antud sõidukil puuduvad katusenumbrid!')
								end
							end
						end
					}
				})
			end
		end
	end)
end

local function deRegisterPeds()
	for k,v in pairs(peds) do
        exports.ox_target:removeLocalEntity(peds[k], {'checkVehicle'})
		DeleteEntity(peds[k]); peds[k] = nil
	end
end

local function removeStealed()
	for k,v in pairs(gps) do
		RemoveBlip(v); gps[k] = nil
	end
end

RegisterNetEvent('KKF.Player.Loaded')
AddEventHandler('KKF.Player.Loaded', function(xPlayer)
	ESX.PlayerData = xPlayer; registerPeds()
end)

RegisterNetEvent('KKF.Player.Unloaded', function() 
	ESX.PlayerData = {}; deRegisterPeds()
end)

RegisterNetEvent('KKF.Player.JobUpdate')
AddEventHandler('KKF.Player.JobUpdate', function(job)
	ESX.PlayerData.job = job

	if job.name ~= 'police' then
		removeStealed()
	end
end)

RegisterNetEvent('KKF.Player.DutyChange')
AddEventHandler('KKF.Player.DutyChange', function(value)
	ESX.PlayerData.job.onDuty = value

	if not value then
		removeStealed()
	end
end)

Citizen.CreateThread(function()
	for k,v in pairs(cfg.stations) do
		if not v.noBlip then
			ESX.CreateBlip(k .. '_pd', v.position, v.label, 60, 29, 0.7)
		end
	end
end)

RegisterNetEvent('kk-police:client:fixGun', function(data)
	local progress = exports['kk-taskbar']:startAction('weapon_repair', 'Parandad relva', 15000, 'fixing_a_ped', 'mini@repair', {freeze = true, controls = true})

	if progress then
		TriggerEvent('KKF.UI.ShowNotification', 'success', 'Lõpetasite relva ' .. data.label .. ' hooldamise!')
		TriggerServerEvent('kk-police:server:fixGun', data.slot)
	end
end)

AddEventHandler('KKF.Player.Spawned', function(spawn)
	TriggerEvent('kk-police:unrestrain')
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('kk-police:unrestrain')
	end
end)

for k,v in pairs(cfg.stations) do
	if v.trashBins then
		for k2, v2 in pairs(v.trashBins) do
			exports.ox_target:addBoxZone({
				coords = v2.coords,
				size = v2.size,
				rotation = v2.rotation,
				debug = false,
				options = {
					{
						event = 'kk-police:client:trashBin',
						icon = 'fa-solid fa-trash',
						label = 'Prügikast',
						distance = 1.5,
						canInteract = function()
							return ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.onDuty and ESX.PlayerData.job.permissions.leaderMenu
						end,
						onSelect = function(data)
							local networkId = NetworkGetNetworkIdFromEntity(data.entity)

							exports.ox_inventory:openCustomDump(networkId)
						end
					},
				}
			})
		end
	end

	if v.analysis then
		exports.ox_target:addBoxZone({
			coords = v.analysis.coords,
			size = v.analysis.size,
			rotation = v.analysis.rotation,
			debug = false,
			options = {
				{
					icon = 'fa-solid fa-magnifying-glass-chart',
					label = 'Analüüsi',
					distance = 1.5,
					canInteract = function()
						return ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.onDuty
					end,
					onSelect = function()
						local evidence = exports.ox_inventory:Search('slots', 'filled_evidence_bag')
						local count = 0

						for _, v in pairs(evidence) do
							if not v.metadata.analyzed then
								count += v.count
							end
						end

						if count > 0 then
							local progress = exports['kk-taskbar']:startAction('analyze_evidence', 'Analüüsid', count * 15000, 'base', 'anim@amb@carmeet@checkout_engine@male_g@base', {freeze = true, controls = true})

							if progress then
								lib.callback('kk-evidence:analyse', false, function()
									TriggerEvent('KKF.UI.ShowNotification', 'info', 'Analüüs on teostatud ja andmed kantud riiklikku andmebaasi!')
								end)
							end
						else
							TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil ei ole midagi, mis vajaks analüüsimist!')
						end
					end
				},
			}
		})
	end

	if v.duty then
		exports.ox_target:addBoxZone({
			coords = v.duty.coords,
			size = v.duty.size,
			rotation = v.duty.rotation,
			debug = false,
			options = {
				{
					serverEvent = 'kk-scripts:server:toggleDuty',
					icon = 'far fa-clipboard',
					label = 'Alusta/Lõpeta tööpäeva',
					distance = 1.5,
					canInteract = function()
						return ESX.PlayerData.job.name == 'police'
					end
				},
			}
		})
	end

	if v.weaponRepair then
		for k2, v2 in pairs(v.weaponRepair) do
			exports.ox_target:addBoxZone({
				coords = v2.coords,
				size = v2.size,
				rotation = v2.rotation,
				debug = false,
				options = {
					{
						icon = 'fa-solid fa-wrench',
						label = 'Relvahooldus',
						distance = 1.5,
						canInteract = function()
							return ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.onDuty
						end,
						onSelect = function()
							local elements = {}

							lib.callback('kk-police:getItems', false, function(ownedItems)
								for k,v in pairs(ownedItems) do 
									if v.name:find('weapon_') or v.name:find('WEAPON_') then
										elements[#elements + 1] = {
											title = v.label,
											description = 'Slot: ' .. v.slot,
											event = 'kk-police:client:fixGun',
											args = {slot = v.slot, label = v.label}
										}
									end
								end
						
								lib.registerContext({
									id = 'repair_menu',
									title = 'Relvahoolduspunkt',
									options = elements
								})
						
								lib.showContext('repair_menu')
							end)
						end
					},
				}
			})
		end
	end
end

exports.ox_target:addGlobalPlayer({
	{
		name = 'checkRadio',
		distance = 2.0,
		icon = 'fa-solid fa-radio',
		label = 'Vaata sidet',
		canInteract = function(entity)
			local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)) or 0

			return Player(targetId).state.isCuffed ~= 'none' and not timeout and not cache.vehicle and (ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.onDuty) and Player(targetId).state.radioChannel
		end,
		onSelect = function(data)
			local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
			local channel = Player(targetId).state.radioChannel

			if channel then
				TriggerEvent('KKF.UI.ShowNotification', 'info', 'Side: ' .. channel .. ' Mhz!')
			else
				TriggerEvent('KKF.UI.ShowNotification', 'info', 'Sidet ei leitud!')
			end
		end
	},

	{
		name = 'cuffPlayer',
		distance = 2.0,
		icon = 'fa-solid fa-handcuffs',
		label = 'Pane raudu',
		items = {['handcuffs'] = 1},
		canInteract = function(entity)
			local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)) or 0

			return Player(targetId).state.isCuffed == 'none' and not timeout and not cache.vehicle and (ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.onDuty) 
		end,
		onSelect = function(data)
			timeout = true
			TriggerServerEvent('kk-handcuffs:server:startCuffing', GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity)))

			SetTimeout(5000, function()
				timeout = false
			end)
		end
	},

	{
		name = 'softCuffPlayer',
		distance = 2.0,
		icon = 'fa-solid fa-hands-bound',
		label = 'Lõdvesta raudu',
		canInteract = function(entity)
			local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)) or 0

			return Player(targetId).state.isCuffed == 'hard' and not timeout and not cache.vehicle and (ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.onDuty)
		end,
		onSelect = function(data)
			timeout = true
			TriggerServerEvent('kk-handcuffs:server:setSoftCuffs', GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity)))
			
			SetTimeout(1500, function()
				timeout = false
			end)
		end
	},

	{
		name = 'hardCuffPlayer',
		distance = 2.0,
		icon = 'fa-solid fa-hands-bound',
		label = 'Pinguta raudu',
		canInteract = function(entity)
			local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)) or 0

			return Player(targetId).state.isCuffed == 'soft' and not timeout and not cache.vehicle and (ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.onDuty)
		end,
		onSelect = function(data)
			timeout = true
			TriggerServerEvent('kk-handcuffs:server:setHardCuffs', GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity)))
			
			SetTimeout(1500, function()
				timeout = false
			end)
		end
	},

	{
		name = 'uncuffPlayer',
		distance = 2.0,
		icon = 'fa-solid fa-handcuffs',
		label = 'Eemalda rauad',
		canInteract = function(entity)
			local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)) or 0

			return Player(targetId).state.isCuffed ~= 'none' and not timeout and not cache.vehicle and (ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.onDuty)
		end,
		onSelect = function(data)
			timeout = true
			TriggerServerEvent('kk-handcuffs:server:startUncuffing', GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity)))
			
			SetTimeout(5000, function()
				timeout = false
			end)
		end
	},

	{
		name = 'searchPlayer',
		distance = 2.0,
		icon = 'fa-solid fa-magnifying-glass',
		label = 'Läbiotsimine',
		canInteract = function(entity)
			local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)) or 0

			return not cache.vehicle and (ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.onDuty)
		end,
		onSelect = function(data)
			ExecuteCommand('me otsib läbi')
			TriggerEvent('ox_inventory:openInventory', 'player', GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity)))
		end
	},

	{
		name = 'uncuffPlayerTorch',
		distance = 2.0,
		icon = 'fa-solid fa-handcuffs',
		label = 'Muugi raudu',
		canInteract = function(entity)
			local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)) or 0

			return Player(targetId).state.isCuffed ~= 'none' and not timeout and not cache.vehicle and exports.ox_inventory:Search('count', 'blowtorch') > 0 and not Player(targetId).state.isDead
		end,
		onSelect = function(data)
			timeout = true

			lib.requestAnimDict('random@mugging4')
			TaskPlayAnim(cache.ped, 'random@mugging4', 'struggle_loop_b_thief', 8.0, 1.0, -1, 49, 0, 0, 0, 0)

			local finished = exports['kk-skillbar']:skillBar(70, 7)
                
			if finished then
				TriggerServerEvent('KKF.Player.RemoveItem', 'blowtorch', 1)
				TriggerServerEvent('kk-handcuffs:server:unlockLockpick', GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity)))
			else
				TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ebaõnnestusite muukimisel.')
			end

			ClearPedTasks(cache.ped)
			
			SetTimeout(5000, function()
				timeout = false
			end)
		end
	},
})

RegisterNetEvent('kk-police:client:application', function()
	SetNuiFocus(true, true)
	SendNUIMessage({action = 'show_candidation', data = { name = ESX.PlayerData.name }})
end)

RegisterNUICallback('closeApplication', function(args, cb)
	SetNuiFocus(false, false)
	SendNUIMessage({action = 'hide_forms'})
end)

RegisterNUICallback('sendApplication', function(args, cb)
	if args.email ~= '' and args.text ~= '' then
		lib.callback('kk-police:sendApplication', false, function(response)
			if response then
				TriggerEvent('KKF.UI.ShowNotification', 'info', 'Kandideerimisavaldus on saadetud!')
			end

			cb(response)
		end, args.email, args.text)
	else
		TriggerEvent('KKF.UI.ShowNotification', 'error', 'Täita kõik vajalikud väljad!')
		cb(false)
	end
end)

RegisterNetEvent('kk-police:client:statement', function()
	SetNuiFocus(true, true)
	SendNUIMessage({action = 'show_statement', data = { name = ESX.PlayerData.name }})
end)

RegisterNUICallback('sendStatement', function(args, cb)
	if args.email ~= '' and args.text ~= '' then
		lib.callback('kk-police:sendStatement', false, function(response)
			if response then
				TriggerEvent('KKF.UI.ShowNotification', 'info', 'Avaldus on saadetud!')
			end

			cb(response)
		end, args.email, args.text)
	else
		TriggerEvent('KKF.UI.ShowNotification', 'error', 'Täita kõik vajalikud väljad!')
		cb(false)
	end
end)

RegisterNetEvent('kk-police:client:syncSteal', function(position, plate)
	if gps[plate] then RemoveBlip(gps[plate]); gps[plate] = nil end

	if position then
		gps[plate] = AddBlipForCoord(position.x, position.y, position.z)

		SetBlipSprite(gps[plate], 161)
		SetBlipScale(gps[plate], 1.0)
		SetBlipColour(gps[plate], 1)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Ametisõiduk - ' .. plate)
		EndTextCommandSetBlipName(gps[plate])

		PulseBlip(gps[plate])
	end
end)

RegisterNetEvent('kk-police:client:removeSteal', function(plate)
	if gps[plate] then RemoveBlip(gps[plate]); gps[plate] = nil end
end)

RegisterNetEvent('kk-police:client:punishmentCheck', function()
	local input = lib.inputDialog('State ID', {
        { type = 'number', label = 'Sisesta SID', }
    })

    if input then
		lib.callback('kk-police:punishmentCheck', false, function(response)
			if response then
				local elements = {}

				for i = 1, #response do
					elements[#elements + 1] = {
						icon = 'fas fa-user-ninja',
						title = response[i].offenses,
						metadata = {
							{label = 'Roll', value = response[i].role},
							{label = 'Juhtum', value = response[i].jail .. ' kuud'},
							{label = 'Trahv', value = '$' .. response[i].fine},
							{label = 'Viimane redigeerimine', value = response[i].last_edit},
						}
					}
				end
		
				if #elements == 0 then
					return TriggerEvent('KKF.UI.ShowNotification', 'error', 'Kehtivad karistused puuduvad!')
				end
		
				lib.registerContext({
					id = 'punishment_check',
					title = 'Karistusregister',
					options = elements
				})
		
				lib.showContext('punishment_check')
			else
				TriggerEvent('KKF.UI.ShowNotification', 'error', 'Antud isikut ei eksisteeri!')
			end
		end, input[1])
    end
end)