isDead = false

local timerDisabled = false
local deathTime = 0

local deadAnimDict = 'dead'
local deadAnim = 'dead_a'

local firstSpawn = true

RegisterNetEvent('KKF.Player.Loaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('KKF.Player.Spawned', function()
	Wait(500)

	if firstSpawn then
		print('KKF.Debug: Player ' .. NetworkGetNetworkIdFromEntity(cache.ped) .. ' spawned.')

		lib.callback('kk-ambulance:recieveIsDead', false, function(response)
			if response then
				SetEntityHealth(cache.ped, 0)
			end
		end)

		firstSpawn = false
	end
end)

RegisterNetEvent('KKF.Player.Unloaded', function()
	ESX.PlayerData = {}
	firstSpawn = true
end)

RegisterNetEvent('KKF.Player.JobUpdate', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('KKF.Player.DutyChange', function(value)
	ESX.PlayerData.job.onDuty = value
end)

-- Create blips
CreateThread(function()
	for k,v in pairs(Config.Hospitals) do
		if v.blip then
			ESX.CreateBlip(k .. '_hospital', v.blip, v.label, 61, 1, 0.7)
		end
	end
end)


local function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

local function teleportPlayer(ped, coords, withVehicle)
    FreezeEntityPosition(ped, true)
    StartPlayerTeleport(cache.playerId, coords.x, coords.y, coords.z, coords.w or 0.0, withVehicle, true, true)
    while IsPlayerTeleportActive() or not HasCollisionLoadedAroundEntity(ped) do Wait(10) end
end

local function revivePlayer()
    local oldPed = cache.ped
    local seat = cache.seat
    local veh = cache.vehicle
    local coords = GetEntityCoords(oldPed)
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, GetEntityHeading(oldPed), true, true, false)

    local ped = PlayerPedId()
    if oldPed ~= ped then
        SetEntityLocallyInvisible(oldPed)
        DeleteEntity(oldPed)
        ClearAreaOfPeds(coords.x, coords.y, coords.z, 0.2, false)
    end

    if veh and veh ~= 0 then
        SetPedIntoVehicle(ped, veh, seat)
    end

    isDead = false
end

local function respawnPlayer()
	local formattedCoords = {
		x = Config.RespawnPoint.coords.x,
		y = Config.RespawnPoint.coords.y,
		z = Config.RespawnPoint.coords.z
	}

	-- if exports['kk-jail']:checkStatus() then
	-- 	formattedCoords = { x = 1770.0, y = 2594.8747558594, z = 45.725219726562, h = 87.874015808105}
	-- end

    TriggerServerEvent('kk-ambulance:server:removeItems')

    teleportPlayer(cache.ped, formattedCoords)
    DoScreenFadeIn(500)

    revivePlayer()
    TriggerServerEvent('kk-ambulance:setDeathStatus', false)
    TriggerServerEvent('s4-realisticdisease:removeAllInjures')
    
    TriggerServerEvent('KKF.Player.Spawned')
	TriggerEvent('KKF.Player.Spawned')
	TriggerEvent('playerSpawned')
end

local function triggerDeath()
	if not isDead then
        local armor = GetPedArmour(cache.ped)
        isDead = true
		TriggerServerEvent('kk-ambulance:setDeathStatus', true)
        local player = PlayerPedId()

        while GetEntitySpeed(player) > 0.5 or IsPedRagdoll(player) do
            Wait(10)
        end

        if isDead then
            local pos = GetEntityCoords(player)
            local heading = GetEntityHeading(player)
            local ped = PlayerPedId()

            if IsPedInAnyVehicle(ped) then
                local veh = GetVehiclePedIsIn(ped)
                local vehseats = GetVehicleModelNumberOfSeats(GetHashKey(GetEntityModel(veh)))

                for i = -1, vehseats do
                    local occupant = GetPedInVehicleSeat(veh, i)

                    if occupant == ped then
                        NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z + 0.5, heading, true, false)
                        SetPedIntoVehicle(ped, veh, i)
                    end
                end
            else
                NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z + 0.5, heading, true, false)
            end

            -- SetEntityInvincible(player, true)
            SetEntityHealth(player, GetEntityMaxHealth(player))
            SetPedArmour(player, armor)

            if IsPedInAnyVehicle(player, false) then
                loadAnimDict('veh@low@front_ps@idle_duck')
                SetEntityCoords(player, GetEntityCoords(player))
                ClearPedTasksImmediately(player)
                TaskPlayAnim(player, 'veh@low@front_ps@idle_duck', 'sit', 1.0, 1.0, -1, 1, 0, 0, 0, 0)
            else
                loadAnimDict(deadAnimDict)
                SetEntityCoords(player, GetEntityCoords(player))
                ClearPedTasksImmediately(player)
                TaskPlayAnim(player, deadAnimDict, deadAnim, 1.0, 1.0, -1, 1, 0, 0, 0, 0)
            end
        end
    end

    deathTime = Config.EarlyRespawnTimer
    
    SetTimeout(1250, function()
        SendNUIMessage({ action = 'showTimer' })

        SetEntityVisible(cache.ped, true)
        SetEntityCollision(cache.ped, true, true)
    end)

    CreateThread(function()
		hold = 2

		while isDead do
			Wait(1000)

            if not timerDisabled then
			    deathTime = deathTime - 1
            end

			if deathTime <= 0 then
                SendNUIMessage({ action = 'updateTimer', data = { time = deathTime, text = "<h4 id='timerText'>Vajuta <span style='color: #E0606E;'>[E]</span> taassündimiseks või oota EMS-i</h4>" } })

				if IsControlPressed(0, 38) and hold <= 0 then
					respawnPlayer()
					hold = 2
				end

				if IsControlPressed(0, 38) then
					if hold - 1 >= 0 then
						hold = hold - 1
					else
						hold = 0
					end
				end

				if IsControlReleased(0, 38) then
					hold = 2
				end
            else
                SendNUIMessage({ action = 'updateTimer', data = { time = deathTime, text = "<h4 id='timerText'>Oled teadvuseta, kutsu EMS, kõik saab korda!</h4>" } })
			end
		end

        SendNUIMessage({ action = 'hideTimer' })
	end)
end

RegisterNetEvent('kk-ambulance:revive', function(needs, admin)
    local armor = GetPedArmour(cache.ped)

    revivePlayer()

    if needs then
        local myNeeds = exports['kk-scripts']:getNeeds()

        for k,v in pairs(myNeeds) do
            if k ~= 'stress' then
                if v.val < 5000 then
                    TriggerEvent('kk-needs:client:setNeed', k, 5000)
                end
            else
                TriggerEvent('kk-needs:client:setNeed', 'stress', v.val / 2)
            end
        end
    end

    if admin then
        TriggerServerEvent('s4-realisticdisease:removeAllInjures')
        
        TriggerEvent('kk-needs:client:setNeed', 'thirst', 100000)
        TriggerEvent('kk-needs:client:setNeed', 'hunger', 100000)
        TriggerEvent('kk-needs:client:setNeed', 'stress', 0)
    end

    TriggerEvent('kk-ambulance:kickFromBed')

	TriggerServerEvent('KKF.Player.Spawned')
	TriggerEvent('KKF.Player.Spawned')
	TriggerEvent('playerSpawned')

    SetPedArmour(cache.ped, armor)

    TriggerServerEvent('kk-ambulance:setDeathStatus', false)
    Wait(700)
    if LocalPlayer.state.isCuffed == 'hard' then
        exports['ox_target']:disableTargeting(true)
        -- exports['lb-phone']:ToggleDisabled(true)

        LocalPlayer.state:set('invBusy', true, false)
        TriggerEvent('kk-inventory:client:disarm')
    elseif LocalPlayer.state.isCuffed == 'soft' then
        TriggerEvent('kk-inventory:client:disarm')
    end
end)

AddEventHandler('KKF.Player.Death', function(data)
    if LocalPlayer.state.isLoggedIn then
        SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
        SetEntityInvincible(PlayerPedId(), true)

        if not isDead then
            triggerDeath()
        elseif isDead then
            if data.weapon and data.weapon ~= -1553120962 then
                respawnPlayer()
            end
        else
            print('AMBULANCE: BROKEN')
        end
    else
        revivePlayer()
    end
end)

RegisterNetEvent('kk-ambulance:disableTimer', function()
	local timer = 300
	timerDisabled = true

	while timer > 0 and isDead do
		timer = timer - 1

		if timer <= 0 then
			break
		end

		Wait(1000)
	end

	timerDisabled = false
end)

lib.onCache('ped', function()
    SetPlayerHealthRechargeMultiplier(cache.playerId, 0.0)
end)

RegisterNetEvent('kk-ambulance:client:useBandage', function()
	local progress = exports['kk-taskbar']:startAction('bandage', 'Kasutad sidemeid', 25000, 'idle_a', 'missheistdockssetup1clipboard@idle_a', {freeze = true, controls = true})

	if progress then
		local maxHealth = GetEntityMaxHealth(cache.ped)
		local health = GetEntityHealth(cache.ped)
		local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 8))

		SetEntityHealth(cache.ped, newHealth)
		TriggerServerEvent('KKF.Player.RemoveItem', 'bandage', 1)
	end
end)

CreateThread(function()
    while true do
        local sleep = 1000

        if isDead then
            sleep = 5
            local ped = PlayerPedId()
			
            if IsPauseMenuActive() then
                SetFrontendActive(false)
            end
			
			DisableAllControlActions(0)
			EnableControlAction(0, 1, true) 
			EnableControlAction(0, 2, true) 
			EnableControlAction(0, 3, true) 
			EnableControlAction(0, 249, true)
			EnableControlAction(0, 289, true)
			EnableControlAction(0, 20, true)
			EnableControlAction(0, 47, true)
			EnableControlAction(0, 245, true)
			EnableControlAction(0, 19, true)
			EnableControlAction(0, 38, true) 
			EnableControlAction(0, 104, true) 
			EnableControlAction(0, 200, true)
			EnableControlAction(0, 26, true)

			-- INSERT
			EnableControlAction(1, 121, true)

            if isDead then
                if IsPedInAnyVehicle(ped, false) then
                    loadAnimDict('veh@low@front_ps@idle_duck')
					
                    if not IsEntityPlayingAnim(ped, 'veh@low@front_ps@idle_duck', 'sit', 3) then
                        TaskPlayAnim(ped, 'veh@low@front_ps@idle_duck', 'sit', 1.0, 1.0, -1, 1, 0, 0, 0, 0)
                    end
                else
					if not IsEntityPlayingAnim(ped, deadAnimDict, deadAnim, 3) then
						loadAnimDict(deadAnimDict)
						TaskPlayAnim(ped, deadAnimDict, deadAnim, 1.0, 1.0, -1, 1, 0, 0, 0, 0)
					end
                end

                SetCurrentPedWeapon(ped, joaat('WEAPON_UNARMED'), true)
            end
        end
		
        Wait(sleep)
    end
end)