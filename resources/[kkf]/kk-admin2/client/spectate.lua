local stopSpectateUpdate = nil
local isSpectating = false
local playerSpectative = nil
local playerIdSpectative = nil

local function spectatePlayer(targetPed, target, name, playerData, notes, punishments)
	enable = true

	if target == PlayerId() or target == -1 then 
		enable = false
	end

	if enable then
		LocalPlayer.state:set('spectating', true, true)
		SetEntityVisible(cache.ped, false, 0)
		SetEntityCollision(cache.ped, false, false)
		SetEntityInvincible(cache.ped, true)
		NetworkSetEntityInvisibleToNetwork(cache.ped, true)
		Wait(200) -- to prevent target player seeing you

		if targetPed == cache.ped then
			Wait(500)
			targetPed = GetPlayerPed(target)
		end

		local targetx, targety, targetz = table.unpack(GetEntityCoords(targetPed, false))
		RequestCollisionAtCoord(targetx, targety, targetz)
		NetworkSetInSpectatorMode(true, targetPed)

        SendNUIMessage({ action = 'startSpectating', data = { playerData = playerData, punishments = punishments, notes = notes, liveData = { maxHealth = GetEntityMaxHealth(targetPed), health = GetEntityHealth(targetPed), vest = GetPedArmour(targetPed) } } })
        playerSpectative = targetPed
        playerIdSpectative = GetPlayerServerId(target)
        isSpectating = true
		TriggerEvent('KKF.UI.ShowNotification', 'success', 'Alustasite mängija ' .. name .. ' jälgimist!')
	else
		SetEntityCoords(cache.ped, vec3(0, 0, 0), 0, 0, 0, false)

		if LocalPlayer.state.cacheLocation then
			SetTimeout(900, function()
				RequestCollisionAtCoord(LocalPlayer.state.cacheLocation)
				SetEntityCoords(cache.ped, LocalPlayer.state.cacheLocation, 0, 0, 0, false)
				LocalPlayer.state:set('cacheLocation', nil, true)
			end)
		end

		NetworkSetInSpectatorMode(false, playerSpectative)
		FreezeEntityPosition(cache.ped, false)
		Wait(200) -- to prevent staying invisible
		SetEntityVisible(cache.ped, true, 0)
		SetEntityCollision(cache.ped, true, true)
		SetEntityInvincible(cache.ped, false)
		NetworkSetEntityInvisibleToNetwork(cache.ped, false)

        SendNUIMessage({ action = 'stopSpectating' })
        playerSpectative = nil
        playerIdSpectative = nil
        isSpectating = false
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Lõpetasite mängija jälgimise!')
        TriggerServerEvent('kk-admin2:server:setPrivateInstance', 0)
		LocalPlayer.state:set('spectating', false, true)
	end
end

RegisterNUICallback('teleportToSpectative', function(args, cb)
	TriggerServerEvent('kk-admin2:server:teleportToSpectative', playerIdSpectative)
end)

RegisterNetEvent('kk-admin2:client:requestSpectate', function(playerServerId, tgtCoords, playerData, notes, punishments)
	if playerServerId == cache.serverId then 
		spectatePlayer(cache.ped, -1, GetPlayerName(-1))
	else
		if not tgtCoords or tgtCoords.z == 0.0 then 
			tgtCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerServerId))) 
		end

		SetEntityCoords(cache.ped, tgtCoords.x, tgtCoords.y, tgtCoords.z - 10.0, 0, 0, 0, false)
		FreezeEntityPosition(cache.ped, true)
		stopSpectateUpdate = true
		local playerId = GetPlayerFromServerId(playerServerId)
	
		repeat
			Wait(200)
			playerId = GetPlayerFromServerId(playerServerId)
		until ((GetPlayerPed(playerId) > 0) and (playerId ~= -1))
	
		spectatePlayer(GetPlayerPed(playerId), playerId, GetPlayerName(playerId), playerData, notes, punishments)
		stopSpectateUpdate = false
	end
end)

CreateThread(function()
	while true do
		wait = 500

		if isSpectating and not stopSpectateUpdate then
            local vehicleData = nil
			local tgtCoords = GetEntityCoords(playerSpectative)

			if tgtCoords and tgtCoords.x ~= 0 then
				SetEntityCoords(cache.ped, tgtCoords.x, tgtCoords.y, tgtCoords.z - 10.0, 0, 0, false)
			end

            if IsPedInAnyVehicle(playerSpectative, false) then
                local vehicle = GetVehiclePedIsIn(playerSpectative, false)
                local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)); vehicleLabel = GetLabelText(vehicleLabel)

                vehicleData = {
                    model = vehicleLabel,
                    plate = ESX.Functions.GetPlate(vehicle),
                    health = GetEntityHealth(vehicle),
                    fuel = GetVehicleFuelLevel(vehicle),
                    speed = math.ceil(GetEntitySpeed(vehicle) * 2.236936) .. ' mph'
                }
            end

            SendNUIMessage({ action = 'startSpectating', data = { vehicleData = vehicleData, liveData = { maxHealth = GetEntityMaxHealth(playerSpectative), health = GetEntityHealth(playerSpectative), vest = GetPedArmour(playerSpectative) } } })
		else
			wait = 1000
		end

        Wait(wait)
	end
end)

RegisterNUICallback('requestSpectate', function(data, cb)
    TriggerServerEvent('kk-admin2:server:requestSpectate', data.target)
end)

RegisterNUICallback('leaveSpectate', function(data, cb)
    if isSpectating then
        spectatePlayer(cache.ped, -1, GetPlayerName(-1))
    end
end)

RegisterNUICallback('saveSpectaticeNotes', function(data, cb)
    TriggerServerEvent('kk-admin2:server:saveSpectaticeNotes', playerIdSpectative, data.notes)
end)

RegisterNUICallback('selectPrevious', function(data, cb)
    TriggerServerEvent('kk-admin2:server:selectPrevious', playerIdSpectative)
end)

RegisterNUICallback('selectNext', function(data, cb)
    TriggerServerEvent('kk-admin2:server:selectNext', playerIdSpectative)
end)

TriggerEvent('chat:addSuggestion', '/spectate', 'Mängija inventory kontrollimine.', {
    { name = 'id'}
})

local lastTime = 0
local automaticSpectate = false

local function isActive(serverId)
    local playerId = GetPlayerFromServerId(serverId)
    
    if playerId ~= -1 and NetworkIsPlayerActive(playerId) then
        return true
    else
        return false
    end
end

RegisterCommand('automaticSpectate', function(_, args)
	if args and args[1] then
		if LocalPlayer.state.adminMode then
			local time = tonumber(args[1])

			if type(time) == 'number' then
				if isSpectating then
					if not automaticSpectate then
						lastTime = GetGameTimer()
						automaticSpectate = true
		
						TriggerEvent('KKF.UI.ShowNotification', 'success', 'Automaatne spectatemine sisselülitatud!')
		
						CreateThread(function()
							while automaticSpectate do 
								if lastTime - GetGameTimer() > (5 * 60000) then
									lastTime = GetGameTimer()
									TriggerServerEvent('kk-admin2:server:selectNext', playerIdSpectative)
								end
				
								if not isActive(playerIdSpectative) then
									lastTime = GetGameTimer()
									TriggerServerEvent('kk-admin2:server:selectNext', playerIdSpectative)
								end
		
								if LocalPlayer.state.isDead then
									TriggerServerEvent('kk-admin2:server:revivePerson', cache.serverId)
								end
		
								Wait(1000)
							end
						end)
					else
						TriggerEvent('KKF.UI.ShowNotification', 'error', 'Automaatne spectatemine väljalülitatud!')
						automaticSpectate = false
					end
				else
					TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ei spectate hetkel kedagi!')
				end

			else
				TriggerEvent('KKF.UI.ShowNotification', 'error', 'Sisesta korrektne aeg (minutites)!')
			end
		end
	end
end)

TriggerEvent('chat:addSuggestion', '/automaticSpectate', 'Mängija automaatne spectatemine.', {
    { name = 'aeg (minutites)'}
})