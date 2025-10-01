exports('placeSpikes', function()
	if not cache.vehicle then
		local progress = exports['kk-taskbar']:startAction('placing_spikes', 'Paigaldad siile', 500, 'plant_floor', 'weapons@first_person@aim_rng@generic@projectile@thermal_charge@', {freeze = true, controls = true})

		if progress then
			local h = GetEntityHeading(cache.ped)
			local positions = {}
		
			for i = 1, 3 do
				positions[i] = GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, -1.5 + (3.5 * i), 0.15)
			end
		
			TriggerServerEvent('kk-police:server:placeSpikes', positions, h)
		end
	end
end)

RegisterNetEvent('kk-police:client:createSpikes', function(positions, h)
	local spike = `P_ld_stinger_s`
	exports['kk-scripts']:requestModel(spike)

	for i = 1, 3 do
		local spikeObj = CreateObject(spike, positions[i], false, true, true)
		TriggerEvent('kk-police:client:loopSpikes', positions[i], spikeObj)
		PlaceObjectOnGroundProperly(spikeObj)
		SetEntityHeading(spikeObj, h)
		FreezeEntityPosition(spikeObj, true)
	end
end)

RegisterNetEvent('kk-police:client:loopSpikes', function(pos, obj)
	local spike = `P_ld_stinger_s`
	local timer = 0

	while timer < 1000 do
		local driverPed = GetPedInVehicleSeat(cache.vehicle, -1)
		local speed = math.ceil(GetEntitySpeed(cache.vehicle) * 2.236936)

		timer = timer + 1
		Wait(1)	

		if driverPed and speed > 10.0 then
			local d1,d2 = GetModelDimensions(GetEntityModel(cache.vehicle))
			local leftfront = GetOffsetFromEntityInWorldCoords(cache.vehicle, d1['x'] - 0.25, 0.25, 0.0)
			local rightfront = GetOffsetFromEntityInWorldCoords(cache.vehicle, d2['x'] + 0.25, 0.25, 0.0)
			local leftback = GetOffsetFromEntityInWorldCoords(cache.vehicle, d1['x'] - 0.25, -0.85, 0.0)
			local rightback = GetOffsetFromEntityInWorldCoords(cache.vehicle, d2['x'] + 0.25, -0.85, 0.0)

			if #(pos - leftfront) < 2.0 and not IsVehicleTyreBurst(cache.vehicle, 0, true) then
				if IsEntityTouchingEntity(cache.vehicle, GetClosestObjectOfType(pos, 5.0, spike, 0, 0, 0)) then
					SetVehicleTyreBurst(cache.vehicle, 0, true, 1000.0)
				end
			end

			if #(pos - rightfront) < 2.0 and not IsVehicleTyreBurst(cache.vehicle, 1, true) then
				if IsEntityTouchingEntity(cache.vehicle, GetClosestObjectOfType(pos, 5.0, spike, 0, 0, 0)) then
					SetVehicleTyreBurst(cache.vehicle, 1, true, 1000.0)
				end
			end

			if #(pos - leftback) < 2.0 and not IsVehicleTyreBurst(cache.vehicle, 4, true) then
				if IsEntityTouchingEntity(cache.vehicle, GetClosestObjectOfType(pos, 5.0, spike, 0, 0, 0)) then
					SetVehicleTyreBurst(cache.vehicle, 2, true, 1000.0)
					SetVehicleTyreBurst(cache.vehicle, 4, true, 1000.0)	
				end		      		
			end

			if #(pos - rightback) < 2.0 and not IsVehicleTyreBurst(cache.vehicle, 5, true) then
				if IsEntityTouchingEntity(cache.vehicle, GetClosestObjectOfType(pos, 5.0, spike, 0, 0, 0)) then
					SetVehicleTyreBurst(cache.vehicle, 3, true, 1000.0)
					SetVehicleTyreBurst(cache.vehicle, 5, true, 1000.0) 
				end 		
			end
		end
	end

	DeleteObject(obj)
	SetEntityAsNoLongerNeeded(obj)	
end)