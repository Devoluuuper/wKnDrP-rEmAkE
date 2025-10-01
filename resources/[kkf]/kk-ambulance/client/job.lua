local isBusy = false

RegisterNetEvent('kk-ambulance:client:heal', function(quiet)
	local health = GetEntityHealth(cache.ped) + (GetEntityMaxHealth(cache.ped) * 0.1)
	SetEntityHealth(cache.ped, health)

	if not quiet then
		TriggerEvent('KKF.UI.ShowNotification', 'info', 'Teie haavu on ravitud.')
	end
end)

local function getNearestPlayer()
	local playerId, playerPed, playerCoords = lib.getClosestPlayer(GetEntityCoords(cache.ped), 3.0, false)
        
	if DoesEntityExist(playerPed) then
		local targetId = GetPlayerServerId(playerId)

		if Player(targetId).state.isDead and not Player(targetId).state.isEscorted then
			return targetId
		end
	end

	return false
end

for k,v in pairs(Config.Hospitals) do
	if v.candidation then
		exports.ox_target:addBoxZone({
			coords = v.candidation.coords,
			size = v.candidation.size,
			rotation = v.candidation.rotation,
			debug = false,
			options = {
				{
					event = 'kk-ambulance:client:application',
					icon = 'fa-brands fa-wpforms',
					label = 'Kandideeri',
					distance = 1.5
				},
			}
		})
	end

	if v.clothes then
		for k2, v2 in pairs(v.clothes) do
			exports.ox_target:addBoxZone({
				coords = v2.coords,
				size = v2.size,
				rotation = v2.rotation,
				debug = false,
				options = {
					{
						event = 'wardrobe:clothingShop',
						icon = 'fas fa-tshirt',
						label = 'Riidekapp',
						distance = 1.5,
						canInteract = function()
							return ESX.PlayerData.job.name == 'ambulance'
						end
					},
				}
			})
		end
	end

	-- if v.operationBeds then
	-- 	for k2, v2 in pairs(v.operationBeds) do
	-- 		exports.ox_target:addBoxZone({
	-- 			coords = v2.coords,
	-- 			size = v2.size,
	-- 			rotation = v2.rotation,
	-- 			debug = false,
	-- 			options = {
	-- 				{
	-- 					icon = 'fa-solid fa-hand',
	-- 					label = 'Aseta isik siia',
	-- 					distance = 1.5,
	-- 					canInteract = function()
	-- 						return (ESX.PlayerData.job.name == 'ambulance' and ESX.PlayerData.job.onDuty) and getNearestPlayer()
	-- 					end,
	-- 					onSelect = function()
	-- 						if exports['kk-scripts']:inCarry() then
	-- 							ExecuteCommand('carry')
	-- 						end				

	-- 						TriggerServerEvent('kk-ambulance:server:playerSleep', v2.coords, v2.tableHeading, getNearestPlayer())
	-- 					end
	-- 				}
	-- 			}
	-- 		})
	-- 	end
	-- end

	if v.pharmacies then
		for k2, v2 in pairs(v.pharmacies) do
			exports.ox_target:addBoxZone({
				coords = v2.coords,
				size = v2.size,
				rotation = v2.rotation,
				debug = false,
				options = {
					{
						icon = 'fa-solid fa-prescription-bottle-medical',
						label = 'Võta väljakirjutatud ravimid',
						distance = 1.5,
						onSelect = function()
							lib.callback('kk-ambulance:recievePrescriptions', false, function(response)
								if not response then
									TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teile ei ole väljakirjutatud ravimeid!')
								end
							end)
						end
					}
				}
			})
		end
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
						return ESX.PlayerData.job.name == 'ambulance'
					end
				},
			}
		})
	end
end

local inBed = false

RegisterNetEvent('kk-ambulance:client:sentIntensive', function()
	if inBed then inBed = false end
end)

RegisterNetEvent('kk-ambulance:client:playerSleep', function(coords, tableHeading)
	lib.requestAnimDict("anim@gangops@morgue@table@")
	TaskPlayAnim(cache.ped, "anim@gangops@morgue@table@", "ko_front" ,8.0, -8.0, -1, 1, 0, false, false, false)

	for i = 1, 5 do
		SetEntityCoords(cache.ped, coords.x, coords.y, coords.z)
		SetEntityHeading(cache.ped, tableHeading)
	end

	CreateThread(function()
		while LocalPlayer.state.isDead do
			TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 3.0, "bleep", 0.3)
			Wait(2000)
		end
	end)

	while LocalPlayer.state.isDead do
		if not IsEntityPlayingAnim(cache.ped, 'anim@gangops@morgue@table@', 'ko_front', 3) then
			TaskPlayAnim(cache.ped, "anim@gangops@morgue@table@", "ko_front" ,8.0, -8.0, -1, 1, 0, false, false, false)
		end

		Wait(1500)
	end

	SetTimeout(500, function()
		SetEntityCoords(cache.ped, coords.x, coords.y, coords.z)
		SetEntityHeading(cache.ped, tableHeading)
		lib.requestAnimDict("anim@gangops@morgue@table@")
		TaskPlayAnim(cache.ped, "anim@gangops@morgue@table@", "ko_front" ,8.0, -8.0, -1, 1, 0, false, false, false)
		FreezeEntityPosition(cache.ped, true)
	end)

	inBed = true
	ESX.ShowInteraction('Tõuse püsti', 'C')

	CreateThread(function()
		while inBed do
			TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 3.0, "bleep", 0.3)
			Wait(2000)
		end
	end)

	while inBed do
		if IsControlJustReleased(0, 26) then
			inBed = false
		end

		Wait(0)
	end

	ESX.HideInteraction()
	FreezeEntityPosition(cache.ped, false)
	ClearPedTasksImmediately(cache.ped)
end)

exports.ox_target:addGlobalPlayer({
	{
		name = 'revivePlayer',
		distance = 3.0,
		icon = 'fa-solid fa-syringe',
		label = 'Elusta',
		items = {
			['syringe'] = 1,
			['oxmask'] = 1
		},
		canInteract = function(entity)
			local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)) or 0

			return not isBusy and not cache.vehicle and (ESX.PlayerData.job.name == 'ambulance' and ESX.PlayerData.job.onDuty) and Player(targetId).state.isDead
		end,
		onSelect = function(data)
			isBusy = true
			local progress = exports['kk-taskbar']:startAction('revive', 'Elustad isikut', 10000, 'fixing_a_ped', 'mini@repair', {freeze = false, controls = true})

			if progress then
				TriggerServerEvent('kk-ambulance:revive', GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity)))
				TriggerEvent('KKF.UI.ShowNotification', 'success', 'Elustamine lõpetatud.')

				TriggerServerEvent('KKF.Player.RemoveItem', 'syringe', 1)
				TriggerServerEvent('KKF.Player.RemoveItem', 'oxmask', 1)
			end

			isBusy = false
		end
	},

	{
		name = 'healPlayer',
		distance = 3.0,
		icon = 'fa-solid fa-suitcase-medical',
		label = 'Ravi',
		items = {
			['patch'] = 1,
			['nacl'] = 1
		},
		canInteract = function(entity)
			local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)) or 0

			return not isBusy and not cache.vehicle and (ESX.PlayerData.job.name == 'ambulance' and ESX.PlayerData.job.onDuty) and not Player(targetId).state.isDead
		end,
		onSelect = function(data)
			isBusy = true
			local progress = exports['kk-taskbar']:startAction('healing', 'Ravid haavu', 25000, 'fixing_a_ped', 'mini@repair', {freeze = false, controls = true})

			if progress then
				TriggerServerEvent('kk-ambulance:server:heal', GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity)))
				TriggerEvent('KKF.UI.ShowNotification', 'success', 'Ravimine lõpetatud.')

				TriggerServerEvent('KKF.Player', 'patch', 1)
				TriggerServerEvent('KKF.Player.RemoveItem', 'nacl', 1)
			end

			isBusy = false
		end
	}
}) 

RegisterNetEvent('kk-ambulance:client:application', function()
	SetNuiFocus(true, true)
	SendNUIMessage({action = 'show_candidation', data = { name = ESX.PlayerData.name }})
end)

RegisterNUICallback('closeApplication', function(args, cb)
	SetNuiFocus(false, false)
	SendNUIMessage({action = 'hide_forms'})
end)

RegisterNUICallback('sendApplication', function(args, cb)
	if args.email ~= '' and args.text ~= '' then
		lib.callback('kk-ambulance:sendApplication', false, function(response)
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