local carry = {
	InProgress = false,
	targetSrc = -1,
	type = "",
	personCarrying = {
		animDict = "missfinale_c2mcs_1",
		anim = "fin_c2_mcs_1_camman",
		flag = 49,
	},
	personCarried = {
		animDict = "nm",
		anim = "firemans_carry",
		attachX = 0.27,
		attachY = 0.15,
		attachZ = 0.63,
		flag = 33,
	}
}

TriggerEvent('chat:addSuggestion', '/carry', 'Võta keegi sülle.', {})

local function GetClosestPlayer(radius)
    local players = GetActivePlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for _,playerId in ipairs(players) do
        local targetPed = GetPlayerPed(playerId)
        if targetPed ~= playerPed then
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(targetCoords-playerCoords)
            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = playerId
                closestDistance = distance
            end
        end
    end
	if closestDistance ~= -1 and closestDistance <= radius then
		return closestPlayer
	else
		return nil
	end
end

exports.ox_target:addGlobalPlayer({
	{
		name = 'carryPlayer',
		distance = 1.0,
		icon = 'fa-solid fa-hand',
		label = 'Võta õlale',
		canInteract = function(entity)
			local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)) or 0

			return not cache.vehicle and IsPedAPlayer(entity) and not LocalPlayer.state.isCuffed and not LocalPlayer.state.isDead and (Player(targetId).state.isDead or Player(targetId).state.isCuffed)
		end,
		onSelect = function(data)
			local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))

			if not carry.InProgress then
				TriggerEvent('KKF.UI.ShowNotification', 'info', 'Alustad isiku üles tõstmist')
				ExecuteCommand("me hakkab inimest ülesse tõstma")
				Wait(5000)
				carry.InProgress = true
				carry.targetSrc = targetId
				TriggerServerEvent("CarryPeople:sync", targetId)
				lib.requestAnimDict(carry.personCarrying.animDict)
				carry.type = "carrying"
			else
				carry.InProgress = false
				ClearPedSecondaryTask(cache.ped)
				DetachEntity(cache.ped, true, false)
				TriggerServerEvent("CarryPeople:stop", carry.targetSrc)
				carry.targetSrc = 0
			end
		end
	}
})

exports('inCarry', function()
	return carry.InProgress
end)

RegisterCommand('carry', function() -- cancel event
	if carry.InProgress then
		carry.InProgress = false
		ClearPedSecondaryTask(cache.ped)
		DetachEntity(cache.ped, true, false)
		TriggerServerEvent("CarryPeople:stop", carry.targetSrc)
		carry.targetSrc = 0
	end
end)

RegisterNetEvent("CarryPeople:syncTarget")
AddEventHandler("CarryPeople:syncTarget", function(targetSrc)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(targetSrc))
	carry.InProgress = true
	lib.requestAnimDict(carry.personCarried.animDict)
	AttachEntityToEntity(PlayerPedId(), targetPed, 0, carry.personCarried.attachX, carry.personCarried.attachY, carry.personCarried.attachZ, 0.5, 0.5, 180, false, false, false, false, 2, false)
	carry.type = "beingcarried"
end)

RegisterNetEvent("CarryPeople:cl_stop")
AddEventHandler("CarryPeople:cl_stop", function()
	carry.InProgress = false
	ClearPedSecondaryTask(PlayerPedId())
	DetachEntity(PlayerPedId(), true, false)
end)

Citizen.CreateThread(function()
	while true do
		wait = 0
		if carry.InProgress then
			if carry.type == "beingcarried" then
				if not IsEntityPlayingAnim(PlayerPedId(), carry.personCarried.animDict, carry.personCarried.anim, 3) then
					TaskPlayAnim(PlayerPedId(), carry.personCarried.animDict, carry.personCarried.anim, 8.0, -8.0, 100000, carry.personCarried.flag, 0, false, false, false)
				end
			elseif carry.type == "carrying" then
				if not IsEntityPlayingAnim(PlayerPedId(), carry.personCarrying.animDict, carry.personCarrying.anim, 3) then
					TaskPlayAnim(PlayerPedId(), carry.personCarrying.animDict, carry.personCarrying.anim, 8.0, -8.0, 100000, carry.personCarrying.flag, 0, false, false, false)
				end
			else 
				wait = 2000
			end
		end

		Wait(wait)
	end
end)