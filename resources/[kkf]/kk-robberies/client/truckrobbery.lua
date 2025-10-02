local robberyPoint = lib.points.new(truckRobbery.point, 1.0)
local data = {
	inAction = false,
	owner = 0,
	blip = nil,
	taskBlip = nil,
	taskLocation = nil,
	vehicle = nil,
	driver = nil,
	passenger = nil,
	action = 0
}

-- [EVENTS] --

RegisterNetEvent('KKF.Player.Loaded', function(xPlayer)
	KKF.PlayerData = xPlayer
end)

RegisterNetEvent('KKF.Player.Unloaded', function()
	KKF.PlayerData = {}
end)

RegisterNetEvent('kk-truckrobbery:client:destroyRobbery', function()
	RemoveBlip(data.taskBlip); KKF.HideInteraction()
	data = {
		owner = 0,
		taskBlip = nil,
		taskLocation = nil,
		vehicle = nil,
		driver = nil,
		passenger = nil,
		action = 0
	}
end)

RegisterNetEvent('kk-truckrobbery:client:loadData', function(response)
	data.owner = response.owner
	data.action = response.action
	data.vehicle = NetworkGetEntityFromNetworkId(response.vehicle)
	data.driver = NetworkGetEntityFromNetworkId(response.driver)
	data.passenger = NetworkGetEntityFromNetworkId(response.passenger)
end)

RegisterNetEvent('kk-truckrobbery:client:doAction', function(data) -- ACTION MIN 30sek
    data.inAction = true

    if data.item == 'c4_bank' then
        FreezeEntityPosition(cache.ped, true)
        TaskStartScenarioInPlace(cache.ped, "CODE_HUMAN_MEDIC_KNEEL", 0, true)
        TriggerEvent('KKF.UI.ShowNotification', 'info', 'Ühendad seadeldist.')
        local progress = exports['kk-taskbar']:startAction('action', 'Paigaldad seadeldist', math.random(15000,16500), 'CODE_HUMAN_MEDIC_KNEEL', false, {freeze = true, controls = true})
        
        if progress then
            local skill = exports['kk-skillbar']:skillBar(70, 5)
            if skillSuccess then
                FreezeEntityPosition(cache.ped, false)
                ClearPedTasksImmediately(cache.ped)
                TriggerServerEvent('KKF.Player.RemoveItem', 'c4_bank', 1)
                TriggerEvent('kk-needs:client:addNeed', 'stress', math.random(1900, 2300))
                TriggerEvent('KKF.UI.ShowNotification', 'info', 'Seadeldis plahvatab loetud sekundite jooksul!')
                TriggerServerEvent('kk-truckrobbery:server:doAction', 'c4_bank', data.coords)
                data.inAction = false
            else
                data.inAction = false
                FreezeEntityPosition(cache.ped, false)
                ClearPedTasksImmediately(cache.ped)
                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ühendasid seadeldise valesti.')
            end
        end
    elseif data.item == 'drill' then
        local chance = math.random(1, 100)
        local drill = {
            entity = nil,
            sound = nil
        }

		FreezeEntityPosition(cache.ped, true)

		lib.requestAnimDict('anim@heists@fleeca_bank@drilling')
		TaskPlayAnim(cache.ped, 'anim@heists@fleeca_bank@drilling', 'drill_straight_idle', 8.0, 8.0, -1, 50, 0, false, false, false)

		lib.callback('KKF.Entity.SpawnObject', false, function(networkId)
			if networkId then
				while not NetworkDoesEntityExistWithNetworkId(networkId) do
					Wait(10)
				end

				drill.entity = NetworkGetEntityFromNetworkId(networkId)

				SetEntityCollision(drill.entity, false, false)
				AttachEntityToEntity(drill.entity, cache.ped, GetPedBoneIndex(cache.ped, 28422), vector3(0,0,0), vector3(0,0,0), false, true, false, false, 0, true)

				RequestAmbientAudioBank("DLC_HEIST_FLEECA_SOUNDSET", 0)
				RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL", 0)
				RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL_2", 0)
				drill.sound = GetSoundId()

				PlaySoundFromEntity(drill.sound, "Drill", drill.entity, "DLC_HEIST_FLEECA_SOUNDSET", 1, 0)

				TriggerEvent("Drilling:Start",function(success)
					if success then
						TriggerServerEvent('kk-truckrobbery:server:doAction', 'drill', data.coords)
					else
						TriggerEvent('kk-needs:client:addNeed', 'stress', math.random(1900, 2300))
					end

					FreezeEntityPosition(cache.ped, false)
					ClearPedTasksImmediately(cache.ped)
		
					TriggerEvent('kk-needs:client:addNeed', 'stress', math.random(1900, 2300))
					if chance > 80 then TriggerServerEvent('KKF.Player.RemoveItem', 'drill', 1) end
					DetachEntity(drill.entity, cache.ped); DeleteEntity(drill.entity); drill.entity = nil
					StopSound(drill.sound); ReleaseSoundId(drill.sound); data.inAction = false
				end)
			end
		end, 'hei_prop_heist_drill', GetEntityCoords(cache.ped), GetEntityHeading(cache.ped))
	end
end)

RegisterNetEvent('kk-truckrobbery:client:openDoors', function(type, coords)
	local pCoords = GetEntityCoords(cache.ped)
	local dist = #(pCoords - vec3(coords.x, coords.y, coords.z))
	
	if dist < 30 then
		SetEntityInvincible(data.vehicle, true)

		if type == 'c4_bank' then
			AddExplosion(coords.x, coords.y, coords.z, 0, 0.5, 1, 0, 1065353216, 0)
			Wait(500)
			AddExplosion(coords.x, coords.y, coords.z, 0, 0.5, 1, 0, 1065353216, 0)

			ApplyForceToEntity(data.vehicle, 0, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 1, false, true, true, true, true)
		elseif type == 'drill' then 
			KKF.ShowInteraction('Korja esemeid', 'E')
		end

		SetVehicleEngineOn(data.vehicle, false, false, true)
		SetVehicleUndriveable(data.vehicle, true)
		SetVehicleEngineHealth(data.vehicle, 0)
		SetVehicleDoorOpen(data.vehicle, 2, false, true); Wait(100); SetVehicleDoorOpen(data.vehicle, 3, false, true)
	end
end)

-- [FUNCTIONS] --

local function createTaskBlip(coord)
    data.taskBlip = AddBlipForRadius(coord.x, coord.y, 0.0, 500.0)
    SetBlipSprite(data.taskBlip, 9)
    SetBlipColour(data.taskBlip, 6)
    SetBlipAlpha(data.taskBlip, 130)

	TriggerEvent('KKF.UI.ShowNotification', 'info', 'Umbkaudne rahaauto positsioon on märgitud teile GPSile.')
end

local function doAction(action, coords)
	if data.owner == KKF.PlayerData.identifier then
		if action == 0 then
			lib.callback('kk-inventory:get', 500, function(ownedItems)
				local elements = {};

				for k,v in pairs(ownedItems) do 
					if v.name == 'c4_bank' or v.name == 'drill' then
						elements[#elements + 1] = {
							title = v.label,
							event = 'kk-truckrobbery:client:doAction',
							args = {item = v.name, coords = coords}
						}
					end
				end

				lib.registerContext({
					id = 'truck_choice_menu',
					title = 'Vali röövimise viis',
					options = elements
				})

				lib.showContext('truck_choice_menu')
			end)
		elseif action == 1 then
			local moneyBag = nil
			lib.requestAnimDict('anim@heists@ornate_bank@grab_cash_heels')
			Wait(500)

			lib.callback('KKF.Entity.SpawnObject', false, function(networkId)
				if networkId then
					while not NetworkDoesEntityExistWithNetworkId(networkId) do
						Wait(10)
					end
	
					moneyBag = NetworkGetEntityFromNetworkId(networkId)
	
					SetEntityCollision(moneyBag, false, false)
					AttachEntityToEntity(moneyBag, cache.ped, GetPedBoneIndex(cache.ped, 57005), vector3(0.0, 0.0, -0.16), vector3(250.0, -30.0, 0.0), false, true, false, false, 0, true)
				end
			end, 'prop_cs_heist_bag_02', GetEntityCoords(cache.ped), GetEntityHeading(cache.ped))

			TriggerEvent('kk-needs:client:addNeed', 'stress', math.random(1900, 2300))
			local progress = exports['kk-taskbar']:startAction('grab','Kogud asju', math.random(10000,11500), 'grab', 'anim@heists@ornate_bank@grab_cash_heels', {freeze = true, controls = true})

			if progress then
				TriggerServerEvent('kk-truckrobbery:server:doAction', 'loot')
				FreezeEntityPosition(cache.ped, false)
				ClearPedTasksImmediately(cache.ped)
				DetachEntity(cache.ped, moneyBag); DeleteEntity(moneyBag); moneyBag = nil; data.inAction = false
			end
		end
	end
end

local function loadLoops()
	CreateThread(function()
		while data.owner == KKF.PlayerData.identifier do
			wait = 5
				
			local inZone = false; local text = ''
			local trunk = GetWorldPositionOfEntityBone(data.vehicle, GetEntityBoneIndexByName(data.vehicle, "door_pside_r"))
			local dist = #(GetEntityCoords(cache.ped) - trunk)

			if dist <= 2.0 then
				wait = 5
				inZone = true

				if data.action == 0 then
					text = 'Ava uksed'
				else
					text = 'Korja esemeid'
				end
	
				if IsControlJustReleased(0, 38) then
					if not data.inAction then
						doAction(data.action, trunk)
					end
				end
			else
				wait = 1500
			end
			
			if inZone and not alreadyEnteredZone then
				alreadyEnteredZone = true
				KKF.ShowInteraction(text, 'E')
			end
	
			if not inZone and alreadyEnteredZone then
				alreadyEnteredZone = false
				KKF.HideInteraction()
			end

			Wait(wait)
		end
	end)
end

local function hackLocation()
	lib.callback('kk-robberies:checkGlobal', false, function(status)
		if not status then
			lib.callback('kk-society:getOnlineMembers', false, function(qtty)
				if qtty >= truckRobbery.minTruckPolice then
					lib.callback('kk-truckrobbery:canStartRobbery', false, function(response)
						if response then
							local progress = exports['kk-taskbar']:startAction('connect_devices', 'Ühendad seadmeid', 5000, 'hack_enter', 'anim@heists@ornate_bank@hack', {freeze = true, controls = true})

							if progress then
								exports["memorygame"]:thermiteminigame(10, 2, 2, 7, function()
									local location = truckRobbery.locations[math.random(1, #truckRobbery.locations)]

									lib.callback('kk-truckrobbery:startRobbery', false, function()
										createTaskBlip(location)

										local polyZone = BoxZone:Create(location, 300.0, 300.0, {
											name = "truckRobbery",
											offset = {0.0, 0.0, 0.0},
											scale = {1.0, 1.0, 1.0},
											debugPoly = false,
											minZ = location.z - 5.0,
											maxZ = location.z + 100.0
										})
	
										polyZone:onPlayerInOut(function(val)
											if val then
												lib.callback('kk-truckrobbery:spawn', false, function(response)
													data.vehicle = NetworkGetEntityFromNetworkId(response.vehicle)
													data.driver = NetworkGetEntityFromNetworkId(response.driver)
													data.passenger = NetworkGetEntityFromNetworkId(response.passenger)
	
													NetworkRequestControlOfEntity(data.driver); Wait(500)
													AddRelationshipGroup("Ar_truck")
													SetPedFleeAttributes(data.driver, 0, 0)
													SetPedCombatAttributes(data.driver, 46, 1)
													SetPedCombatAbility(data.driver, 100)
													SetPedCombatMovement(data.driver, 3)
													SetPedCombatRange(data.driver, 1)
													SetPedKeepTask(data.driver, true)
													SetPedSuffersCriticalHits(data.driver, false)
													SetPedArmour(data.driver, 100)
													SetPedDropsWeaponsWhenDead(data.driver, false)
													TaskVehicleDriveWander(data.driver, data.vehicle, 100.0, 786436)
			
													SetPedRelationshipGroupHash(data.driver, `Ar_truck`)
													SetRelationshipBetweenGroups(4, `PLAYER`, `Ar_truck`)
													SetRelationshipBetweenGroups(4, `Ar_truck`, `PLAYER`)
	
													NetworkRequestControlOfEntity(data.passenger); Wait(500) -- PASSENGER
													SetPedFleeAttributes(data.passenger, 0, 0)
													SetPedCombatAttributes(data.passenger, 46, 1)
													SetPedCombatAbility(data.passenger, 100)
													SetPedCombatMovement(data.passenger, 3)
													SetPedCombatRange(data.passenger, 1)
													SetPedSuffersCriticalHits(data.passenger, false)
													SetPedArmour(data.passenger, 100)
													TaskWarpPedIntoVehicle(data.passenger, data.vehicle, 0)
													SetPedKeepTask(data.passenger, true)
													SetPedDropsWeaponsWhenDead(data.passenger, false)
													SetPedRelationshipGroupHash(data.passenger, `Ar_truck`)
													SetRelationshipBetweenGroups(4, `PLAYER`, `Ar_truck`)
													SetRelationshipBetweenGroups(4, `Ar_truck`, `"PLAYER`)
			
													loadLoops(); polyZone:destroy()
												end, location)
											end
										end)
									end)
								end, function()
									TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ei saanud hackimisega hakkama!')
								end)
							end
						else
							TriggerEvent('KKF.UI.ShowNotification', 'error', 'Tunned, et sul oleks midagi puudu või keegi on sinust ette jõudnud!')
						end
					end)
				else
					TriggerEvent('KKF.UI.ShowNotification', 'error', 'Tunned, et linn on tühjavõitu!')
				end
			end, 'police')
		else
			TriggerEvent('KKF.UI.ShowNotification', 'error', 'Hetkel ei saa selle tegevusega jätkata!')
		end
	end)
end

function robberyPoint:onEnter()
	KKF.ShowInteraction('Häki rahaauto asukoht', 'E')
end

function robberyPoint:onExit()
	KKF.HideInteraction()
end

function robberyPoint:nearby()
	if self.currentDistance < 1.0 and IsControlJustReleased(0, 38) then
		hackLocation()
	end
end