lib.locale()

local fuelingCan = nil

AddEventHandler('ox_inventory:currentWeapon', function(currentWeapon)
	fuelingCan = currentWeapon?.name == 'WEAPON_PETROLCAN' and currentWeapon
end)

local function raycast(flag)
	local playerCoords = GetEntityCoords(cache.ped)
	local plyOffset = GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 2.2, -0.25)
	local rayHandle = StartShapeTestCapsule(playerCoords.x, playerCoords.y, playerCoords.z + 0.5, plyOffset.x, plyOffset.y, plyOffset.z, 2.2, flag or 30, cache.ped)
	while true do
		Wait(0)
		local result, _, _, _, entityHit = GetShapeTestResult(rayHandle)

		if result ~= 1 then
			if entityHit and GetEntityType(entityHit) == 2 then
				return entityHit
			end

			return false
		end
	end
end

local function setFuel(state, vehicle, fuel, replicate)
	if DoesEntityExist(vehicle) then
		SetVehicleFuelLevel(vehicle, fuel)

		if not state.fuel then
			TriggerServerEvent('ox_fuel:createStatebag', NetworkGetNetworkIdFromEntity(vehicle), fuel)
		else
			state:set('fuel', fuel, replicate)
		end
	end
end

local lastVehicle

lib.onCache('seat', function(seat)
	if cache.vehicle then
		lastVehicle = cache.vehicle
	end

	if seat == -1 then
		SetTimeout(0, function()
			local vehicle = cache.vehicle
			local multiplier = Config.classUsage[GetVehicleClass(vehicle)] or 1.0

			-- Vehicle doesn't use fuel
			if multiplier == 0.0 then return end

			local state = Entity(vehicle).state

			if not state.fuel then
				TriggerServerEvent('ox_fuel:createStatebag', NetworkGetNetworkIdFromEntity(vehicle), GetVehicleFuelLevel(vehicle))
				while not state.fuel do Wait(0) end
			end

			SetVehicleFuelLevel(vehicle, state.fuel)

			local fuelTick = 0

			while cache.seat == -1 do
				if GetIsVehicleEngineRunning(vehicle) then
					local usage = Config.rpmUsage[math.floor(GetVehicleCurrentRpm(vehicle) * 10) / 10]
					local fuel = state.fuel
					local newFuel = fuel - usage * multiplier

					if newFuel < 0 or newFuel > 100 then
						newFuel = fuel
					end

					if fuel ~= newFuel then
						if fuelTick == 15 then
							fuelTick = 0
						end

						setFuel(state, vehicle, newFuel, fuelTick == 0)
						fuelTick += 1
					end
				end

				Wait(1000)
			end

			setFuel(state, vehicle, state.fuel, true)
		end)
	end
end)

local isFueling = false
local nearestPump

local function createBlip(x, y)
	local blip = AddBlipForCoord(x, y, 0)
	SetBlipSprite(blip, 415)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.6)
	SetBlipColour(blip, 23)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(locale('fuel_station_blip'))
	EndTextCommandSetBlipName(blip)
	return blip
end

CreateThread(function()
	local blip
	if Config.qtarget and Config.showBlips ~= 1 then return end

	while true do
		local playerCoords = GetEntityCoords(cache.ped)

		for station, pumps in pairs(stations) do
			local stationDistance = #(playerCoords - station)
			if stationDistance < 60 then
				if Config.showBlips == 1 and not blip then
					-- blip = createBlip(station)
				end

				if not Config.qtarget then
					repeat
						if stationDistance < 15 then
							local pumpDistance

							repeat
								playerCoords = GetEntityCoords(cache.ped)
								for i = 1, #pumps do
									local pump = pumps[i]
									pumpDistance = #(playerCoords - pump)

									if pumpDistance < 3 then
										nearestPump = pump

										while pumpDistance < 3 do
											if cache.vehicle then
												DisplayHelpTextThisFrame('fuelLeaveVehicleText', false)
											elseif not isFueling then
												local vehicleInRange = lastVehicle ~= 0 and #(GetEntityCoords(lastVehicle) - playerCoords) <= 3

												if vehicleInRange then
													DisplayHelpTextThisFrame('fuelHelpText', false)
												elseif Config.petrolCan.enabled then
													DisplayHelpTextThisFrame('petrolcanHelpText', false)
												end
											end

											pumpDistance = #(GetEntityCoords(cache.ped) - pump)
											Wait(0)
										end

										nearestPump = nil
									end
								end
								Wait(100)
							until pumpDistance > 15
							break
						end

						Wait(100)
						stationDistance = #(GetEntityCoords(cache.ped) - station)
					until stationDistance > 60
				end
			end
		end


		Wait(500)
		if blip then
			RemoveBlip(blip)
			blip = nil
		end
	end
end)

-- if Config.showBlips == 2 then
-- 	for station in pairs(stations) do createBlip(station) end
-- end

local ox_inventory = exports.ox_inventory

-- fuelingMode = 1 - Pump
-- fuelingMode = 2 - Can
local function startFueling(vehicle, isPump)
	isFueling = true

	local fuel = Entity(vehicle).state.fuel or GetVehicleFuelLevel(vehicle)
	local duration = math.ceil((100 - fuel) / Config.refillValue) * (Config.refillTick + 100)
	local price, moneyAmount
	local durability = 0

	if (100 - fuel) < Config.refillValue then
		isFueling = false 
		return TriggerEvent('KKF.UI.ShowNotification', 'error', locale('tank_full'))
	end

	if isPump then
		price = 0
		moneyAmount = lib.callback.await('ox_fuel:getBank', false)
	end

	TaskTurnPedToFaceEntity(cache.ped, vehicle, duration); Wait(500)

	if isFueling then
		CreateThread(function()
			exports['kk-taskbar']:startAction('fill_tank', 'Tangid sõidukit', duration, isPump and 'gar_ig_5_filling_can' or 'fire', isPump and 'timetable@gardener@filling_can' or 'weapon@w_sp_jerrycan', {freeze = false, controls = true, disableCancel = not isPump})
			isFueling = false
		end)

		while isFueling do
			if isPump then
				local taxedPrice = Config.priceTick + KKF.Math.Round(KKF.Math.Percent(exports['kk-taxes']:getTax('primary').value, Config.priceTick))
				price += taxedPrice

				if price >= moneyAmount then
					exports['kk-taskbar']:cancelAction()
				end
			else
				durability += Config.durabilityTick

				if durability >= fuelingCan.metadata.ammo then
					exports['kk-taskbar']:cancelAction()
					durability = fuelingCan.metadata.ammo
					break
				end
			end

			fuel += Config.refillValue

			if fuel >= 100 then
				isFueling = false
				exports['kk-taskbar']:cancelAction()
				fuel = 100.0
			end

			Wait(Config.refillTick)
		end

		if isPump then
			TriggerServerEvent('ox_fuel:pay', price, fuel, NetworkGetNetworkIdFromEntity(vehicle))
		else
			TriggerServerEvent('ox_fuel:updateFuelCan', NetworkGetNetworkIdFromEntity(vehicle), fuel)
		end
	end
end

RegisterNetEvent('ox_fuel:client:fuelVehicle', function(netId, amount)
	local entity = NetworkGetEntityFromNetworkId(netId)

	if DoesEntityExist(entity) then
		Entity(entity).state:set('fuel', amount, true)
	end
end)



local function getPetrolCan(pumpCoord)
	if pumpCoord then
		TaskTurnPedToFaceCoord(cache.ped, pumpCoord, Config.petrolCan.duration)
	end
	
	Wait(500)

	local progress = exports['kk-taskbar']:startAction('petrol_can', 'Täidad kanistrit', Config.petrolCan.duration, 'gar_ig_5_filling_can', 'timetable@gardener@filling_can', {freeze = false, controls = true, disableCancel = true})
	
	if progress then
		TriggerServerEvent('ox_fuel:fuelCan', Config.petrolCan.price + KKF.Math.Round(KKF.Math.Percent(exports['kk-taxes']:getTax('primary').value, Config.petrolCan.price)))
	end
end

-- if Config.qtarget then
-- 	exports.qtarget:AddTargetModel(Config.pumpModels, {
-- 		options = {
-- 			{
-- 				action = function (entity)
-- 					if ox_inventory:Search(2, 'money') >= Config.priceTick then
-- 						startFueling(lastVehicle, 1)
-- 					else
-- 						lib.notify({type = 'error', description = locale('refuel_cannot_afford')})
-- 					end
-- 				end,
-- 				icon = "fas fa-gas-pump",
-- 				label = locale('start_fueling'),
-- 				canInteract = function (entity)
-- 					if isFueling or cache.vehicle then
-- 						return false
-- 					end

-- 					return lastVehicle and #(GetEntityCoords(lastVehicle) - GetEntityCoords(cache.ped)) <= 3
-- 				end
-- 			},
-- 			{
-- 				action = function (entity)
-- 					local petrolCan = Config.petrolCan.enabled and GetSelectedPedWeapon(cache.ped) == `WEAPON_PETROLCAN`
-- 					local moneyAmount = ox_inventory:Search(2, 'money')

-- 					if moneyAmount < Config.petrolCan.price then
-- 						return lib.notify({type = 'error', description = locale('petrolcan_cannot_afford')})
-- 					end

-- 					return getPetrolCan(GetEntityCoords(entity), petrolCan)
-- 				end,
-- 				icon = "fas fa-faucet",
-- 				label = locale('petrolcan_buy_or_refill'),
-- 			},
-- 		},
-- 		distance = 2
-- 	})

-- 	exports.qtarget:Vehicle({
-- 		options = {
-- 			{
-- 				action = function (entity)
-- 					if fuelingCan.metadata.ammo <= Config.durabilityTick then return end
-- 					startFueling(entity)
-- 				end,
-- 				icon = "fas fa-gas-pump",
-- 				label = locale('start_fueling'),
-- 				canInteract = function (entity)
-- 					if isFueling or cache.vehicle then
-- 						return false
-- 					end
-- 					return fuelingCan and Config.petrolCan.enabled
-- 				end
-- 			}
-- 		},
-- 		distance = 2
-- 	})
-- end


RegisterNetEvent('ox_fuel:buyRCan', function()
	local moneyAmount = lib.callback.await('ox_fuel:getBank', false)

	if moneyAmount < Config.petrolCan.price then 
		return TriggerEvent('KKF.UI.ShowNotification', 'error', locale('petrolcan_cannot_afford'))
	end

	return getPetrolCan(GetEntityCoords(entity))
end)

local Stations = {}
local inGasStation = false

CreateThread(function()
	for k=1, #Config.gasStations do
		createBlip(Config.gasStations[k].zones[1].x, Config.gasStations[k].zones[1].y, 0)

		local returnable = {}
		local points = Config.gasStations[k].zones

		for i = 1, #points do
			returnable[#returnable + 1] = vec3(points[i].x, points[i].y, 0.0)
		end

		Stations[k] = lib.zones.poly({
			points = returnable, -- todo on leveling, hiljem kui teised on olemas siis alustan.
			thickness = 300,
			debug = false,

			onEnter = function()
				inGasStation = true
			end,
			
			onExit = function()
				inGasStation = false
			end
		})
	end
end)

exports('inGasStation', function()
	return inGasStation
end)

exports.qtarget:Vehicle({
	options = {
		{
			action = function (entity)
				local taxedPrice = Config.priceTick + KKF.Math.Round(KKF.Math.Percent(exports['kk-taxes']:getTax('primary').value, Config.priceTick))

				if lib.callback.await('ox_fuel:getBank', false) >= taxedPrice then
					startFueling(lastVehicle, 1)
				else
					TriggerEvent('KKF.UI.ShowNotification', 'error', locale('refuel_cannot_afford'))
				end
			end,
			icon = "fas fa-gas-pump",
			label = locale('start_fueling'),
			canInteract = function (entity)
				if isFueling or cache.vehicle then
					return false
				end

				if not inGasStation then
					return false
				end

				return lastVehicle and #(GetEntityCoords(lastVehicle) - GetEntityCoords(cache.ped)) <= 3
			end
		},

		{
			action = function (entity)
				if fuelingCan.metadata.ammo <= Config.durabilityTick then return end
				startFueling(entity)
			end,
			icon = "fas fa-gas-pump",
			label = locale('start_fueling'),
			canInteract = function (entity)
				if isFueling or cache.vehicle then
					return false
				end

				if inGasStation then
					return false
				end

				return fuelingCan and Config.petrolCan.enabled
			end
		}
	},
	distance = 2
})

AddTextEntry('fuelHelpText', locale('fuel_help'))
AddTextEntry('petrolcanHelpText', locale('petrolcan_help'))
AddTextEntry('fuelLeaveVehicleText', locale('leave_vehicle'))



CreateThread(function()
    while true do
        wait = 500

        if cache.vehicle then
			if GetVehicleFuelLevel(cache.vehicle) then
				if GetVehicleFuelLevel(cache.vehicle) > 5 and GetVehicleFuelLevel(cache.vehicle) ~= 0 then
					wait = 1000
				elseif GetVehicleFuelLevel(cache.vehicle) < 5 and GetVehicleFuelLevel(cache.vehicle) ~= 0 then
					SetVehicleUndriveable(cache.vehicle, true)
					Wait(7500)
					SetVehicleUndriveable(cache.vehicle, false)
				elseif GetVehicleFuelLevel(cache.vehicle) == 0 then
					SetVehicleUndriveable(cache.vehicle, true)
					Wait(500)
					SetVehicleUndriveable(cache.vehicle, false)
				end
			end
        else
            wait = 1000
        end

        Wait(wait)
    end
end)
