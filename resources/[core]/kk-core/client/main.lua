local pickups = {}

CreateThread(function()
	while true do
		Wait(12500)

		if NetworkIsPlayerActive(PlayerId()) then
            TriggerServerEvent("KKF.Player.SessionStarted")
			break
		end
	end
end)

RegisterNUICallback("registerCharacter", function(data, cb)
	local reason = ""
	myIdentity = data

	for theData, value in pairs(myIdentity) do
		if theData == "firstname" or theData == "lastname" then
			reason = KKF.VerifyName(value)
			
			if reason ~= "" then
				break
			end
		elseif theData == "dateofbirth" then
			if value == "invalid" then
				reason = "Ebasobilik sünniaeg!"
				break
			end
		end
	end
	
	if reason == "" then
		TriggerServerEvent('kk-core:server:registerCharacter', data)
        SetNuiFocus(false,false)
        SendNUIMessage({
            action = "closeLogin",
        })
	else
		TriggerEvent('KKF.ReloadCharacters')
		TriggerEvent('KKF.UI.ShowNotification', 'error', reason)
	end
end)

ClearPlayerWantedLevel(PlayerId())
SetMaxWantedLevel(0)

local PlayerKilledByPlayer = function(killerServerId, killerClientId, deathCause)
	local victimCoords = GetEntityCoords(cache.ped)
	local killerCoords = GetEntityCoords(GetPlayerPed(killerClientId))
	local distance = #(victimCoords - killerCoords)

	local data = {
		victimCoords = {x = KKF.Math.Round(victimCoords.x, 1), y = KKF.Math.Round(victimCoords.y, 1), z = KKF.Math.Round(victimCoords.z, 1)},
		killerCoords = {x = KKF.Math.Round(killerCoords.x, 1), y = KKF.Math.Round(killerCoords.y, 1), z = KKF.Math.Round(killerCoords.z, 1)},

		killedByPlayer = true,
		deathCause = deathCause,
		distance = KKF.Math.Round(distance, 1),

		killerServerId = killerServerId,
		killerClientId = killerClientId
	}

	TriggerEvent('KKF.Player.Death', data)
	TriggerServerEvent('KKF.Player.Death', data)
end

local PlayerKilled = function(deathCause)
	local playerPed = cache.ped
	local victimCoords = GetEntityCoords(playerPed)

	local data = {
		victimCoords = {x = KKF.Math.Round(victimCoords.x, 1), y = KKF.Math.Round(victimCoords.y, 1), z = KKF.Math.Round(victimCoords.z, 1)},

		killedByPlayer = false,
		deathCause = deathCause
	}

	TriggerEvent('KKF.Player.Death', data)
	TriggerServerEvent('KKF.Player.Death', data)
end

CreateThread(function()
	local isDead = false

	while true do
		local sleep = 1500
		local player = PlayerId()

		if LocalPlayer.state['isLoggedIn'] then
			local playerPed = PlayerPedId()

			if IsPedFatallyInjured(playerPed) and not isDead then
				sleep = 0
				isDead = true

				local killerEntity, deathCause = GetPedSourceOfDeath(playerPed), GetPedCauseOfDeath(playerPed)
				local killerClientId = NetworkGetPlayerIndexFromPed(killerEntity)

				if killerEntity ~= playerPed and killerClientId and NetworkIsPlayerActive(killerClientId) then
					PlayerKilledByPlayer(GetPlayerServerId(killerClientId), killerClientId, deathCause)
				else
					PlayerKilled(deathCause)
				end

			elseif not IsPedFatallyInjured(playerPed) and isDead then
				sleep = 0
				isDead = false
			end
		end

		Wait(sleep)
	end
end)