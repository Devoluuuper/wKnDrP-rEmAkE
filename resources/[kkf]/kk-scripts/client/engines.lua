local stall, disableLeaving, runningShutoff, countVariable = false, false, false, 0

local function eject()
    local coords = GetOffsetFromEntityInWorldCoords(cache.vehicle, 1.0, 0.0, 1.0)
	local ejectspeed = math.ceil(GetEntitySpeed(cache.ped) * 8)
	local veloc = GetEntityVelocity(cache.vehicle)

    SetEntityCoords(cache.ped, coords); Wait(1)
    SetPedToRagdoll(cache.ped, 5511, 5511, 0, 0, 0, 0)
    SetEntityVelocity(cache.ped, veloc.x*4,veloc.y*4,veloc.z*4)

    if (GetEntityHealth(cache.ped) - ejectspeed) > 0 then
        SetEntityHealth(cache.ped, (GetEntityHealth(cache.ped) - ejectspeed))
    elseif GetEntityHealth(ped) ~= 0 then
        SetEntityHealth(cache.ped, 0)
    end

    TriggerEvent('kkf:ui:seatBelt', false)
end

local function stalled()
	return stall
end

exports('stalled', stalled) -- exports['kk-scripts']:canStart()

RegisterNetEvent('baseevents:vehicleCrashed', function(vehicle, seat, speed, prevSpeed, velocity, damage, heavyImpact, lightImpact)
	if heavyImpact then
		local beltChance = 0

		if seat == -1 then
			if GetVehicleClass(vehicle) ~= 8 and GetVehicleClass(vehicle) ~= 13 then
				if not stall then
					stall = true
					SetVehicleEngineHealth(vehicle, GetVehicleEngineHealth(vehicle) - velocity * 2.0)
					SetVehicleUndriveable(vehicle, true)
					SetVehicleEngineOn(vehicle, false, false, true)
					TriggerEvent('KKF.UI.ShowNotification', 'info', 'Teie sõiduk suri välja.')
		
					SetTimeout(math.random(3000, 7000), function()
						if GetVehicleEngineHealth(vehicle) > 199 then
							SetVehicleUndriveable(vehicle, false)
							SetVehicleEngineOn(vehicle, true, true, true)
						end

						stall = false
					end)
				end
			end

			exports['kk-mechanic']:tryDegradation(vehicle)
		end

		if damage > 25 then 
			if not exports['kk-scripts']:seatbeltStatus() then 
				eject()
			end
		end
	end
end)

RegisterNetEvent('kk-scripts:client:doLockpick', function(slot, leo)
	if not leo then
		TriggerEvent('kk-needs:client:addNeed', 'stress', 1000)
	end

	if cache.vehicle then
		if cache.seat == -1 then
			if not GetIsVehicleEngineRunning(cache.vehicle) then
				if GetVehicleClass(cache.vehicle) == 15 then return end

				lib.requestAnimDict('random@mugging4'); 
				TaskPlayAnim(cache.ped, 'random@mugging4', 'struggle_loop_b_thief', 8.0, 1.0, -1, 49, 0, 0, 0, 0)

				local skill = exports['kk-skillbar']:skillBar(70, 6)

				if skill then
					if not leo then
						TriggerServerEvent('kk-police:server:onSteal', NetworkGetNetworkIdFromEntity(cache.vehicle), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(cache.vehicle))))
					end

					TriggerEvent('kk-tablet:boosting:lockpicedWaypoint', cache.vehicle)
					TriggerEvent('KKF.UI.ShowNotification', 'success', 'Saite sõiduki muugitud.')
					ClearPedTasks(cache.ped)
				else
					TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ebaõnnestusite sõiduki muukimisel.')
					ClearPedTasks(cache.ped)
				end
			end
		end
	else
		local vehicle, distance = ESX.Game.GetClosestVehicle()

		if vehicle and distance < 2.5 then
			if GetVehicleDoorLockStatus(vehicle) == 2 then
				lib.callback('kk-tablet:boosting:isAvailable', false, function(canSteal)
					if canSteal or (leo and ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.onDuty) then
						local d1, d2 = GetModelDimensions(GetEntityModel(vehicle))
						local leftfront = GetOffsetFromEntityInWorldCoords(vehicle, d1["x"] - 0.25, 0.25, 0.0)
	
						SetEntityCoords(cache.ped, leftfront.x, leftfront.y, leftfront.z)
						TaskTurnPedToFaceEntity(cache.ped, vehicle, 1.0)			

						TriggerEvent('kk-tablet:boosting:spawnAgro', ESX.Game.GetPlate(vehicle)); 

						lib.requestAnimDict('random@mugging4'); 
						TaskPlayAnim(cache.ped, 'random@mugging4', 'struggle_loop_b_thief', 8.0, 1.0, -1, 49, 0, 0, 0, 0)

						local skill = exports['kk-skillbar']:skillBar(70, 6)

						if skill then
							TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "unlock", 0.3)
							Sync.SetVehicleDoorsLocked(vehicle, 1); ClearPedTasks(cache.ped)

							if not leo then
								TriggerServerEvent('kk-police:server:onSteal', NetworkGetNetworkIdFromEntity(vehicle), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))))
							end

							TriggerEvent('kk-tablet:boosting:lockpicedWaypoint', vehicle)

							SetVehicleLights(vehicle, 2)
							Wait(250)
							SetVehicleLights(vehicle, 1)
							Wait(200)
							SetVehicleLights(vehicle, 0)
						else
							TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ebaõnnestusite sõiduki muukimisel.')
							ClearPedTasks(cache.ped)
						end
					else
						TriggerEvent('KKF.UI.ShowNotification', 'error', 'See sõiduk ei ole teile mõeldud, või te kasutate valet seadet!')
					end
				end, ESX.Game.GetPlate(vehicle))
			end
		end
	end
end)