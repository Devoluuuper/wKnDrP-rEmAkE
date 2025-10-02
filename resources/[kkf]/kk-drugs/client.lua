local plants = {}
local potProp = cfg.potProp
local smellCooldown = false

RegisterNetEvent('KKF.Player.Loaded', function(playerData)
	KKF.PlayerData = playerData
end)

RegisterNetEvent('KKF.Player.Unloaded', function() 
	KKF.PlayerData = {}
end)

RegisterNetEvent('KKF.Player.JobUpdate', function(job)
	KKF.PlayerData.job = job
end)

RegisterNetEvent('KKF.Player.DutyChange', function(value)
	KKF.PlayerData.job.onDuty = value
end)


RegisterNetEvent('kk-drugs:client:deletePlant', function(data)
	if cache.vehicle then return end

    local confirmed = lib.alertDialog({
        header = cfg.messages.delete_header,
        content = cfg.messages.delete_content,
        centered = true,
        cancel = true
    })

    if confirmed == 'confirm' then
        -- local progress = exports['kk-taskbar']:startAction('delete', cfg.messages.destroying_plant, cfg.progressbarlengt, 'WORLD_HUMAN_GARDENER_PLANT', false, {freeze = true, controls = true})
		local progress = exports['kk-taskbar']:startAction('delete', cfg.destroying_pot, cfg.progressbarlengt, 'plant_floor', 'weapons@first_person@aim_rng@generic@projectile@thermal_charge@', {freeze = true, controls = true})

        if progress then
            TriggerServerEvent('kk-drugs:server:deletePlant', data.id)
        end
    end
end)

RegisterNetEvent('kk-drugs:client:deletePot', function(data)
	if cache.vehicle then return end

	local progress = exports['kk-taskbar']:startAction('delete', cfg.messages.destroying_pot, cfg.progressbarlengt, 'plant_floor', 'weapons@first_person@aim_rng@generic@projectile@thermal_charge@', {freeze = true, controls = true})
	if progress then
		TriggerServerEvent('kk-drugs:server:deletePlant', data.id)
	end
end)

RegisterNetEvent('kk-drugs:client:placeSeed', function(data)
	if cache.vehicle then return end
    local progress = exports['kk-taskbar']:startAction('plant', cfg.messages.planting_seed, cfg.progressbarlengt, 'plant_floor', 'weapons@first_person@aim_rng@generic@projectile@thermal_charge@', {freeze = true, controls = true})
    if progress then
        TriggerServerEvent('kk-drugs:server:placeSeed', data)
    end
end)

RegisterNetEvent('kk-drugs:client:plantSeed', function(data)
	if cache.vehicle then return end

    local elements = {}

    for k,v in pairs(cfg.plantsList) do
        if exports.ox_inventory:Search('count', k) > 0 then
            elements[#elements + 1] = {
                title = v.label,
                event = 'kk-drugs:client:placeSeed',
                args = {item = k, id = data.id}
            }
        end 
    end

    SetTimeout(500, function()
        if #elements == 0 then return cfg.ClientNotification(cfg.messages.noting_to_grow, 'error') end

        lib.registerContext({
            id = 'plant_seed',
            title = cfg.messages.plant_seed,
            options = elements
        })

        lib.showContext('plant_seed')
    end)
end)

RegisterNetEvent('kk-drugs:client:fertilizePlant', function(data)
	if cache.vehicle then return end
    local progress = exports['kk-taskbar']:startAction('fertilizePlant', cfg.messages.fertilizing_plant, cfg.progressbarlengt, 'plant_floor', 'weapons@first_person@aim_rng@generic@projectile@thermal_charge@', {freeze = true, controls = true})
    if progress then
        TriggerServerEvent('kk-drugs:server:fertilizePlant', data)
    end
end)


RegisterNetEvent('kk-drugs:client:waterPlant', function(data)
	if cache.vehicle then return end
    local progress = exports['kk-taskbar']:startAction('waterPlant', cfg.messages.watering_plant, cfg.progressbarlengt, 'plant_floor', 'weapons@first_person@aim_rng@generic@projectile@thermal_charge@', {freeze = true, controls = true})
    if progress then
        TriggerServerEvent('kk-drugs:server:waterPlant', data)
    end
end)


RegisterNetEvent('kk-drugs:client:recievePlants', function(data)
	if cache.vehicle then return end

	local progress = exports['kk-taskbar']:startAction('recievePlants', cfg.messages.harvesting_plant, cfg.progressbarlengt, 'plant_floor', 'weapons@first_person@aim_rng@generic@projectile@thermal_charge@', {freeze = true, controls = true})

	if progress then
		TriggerServerEvent('kk-drugs:server:recievePlants', data)
	end
end)

local function destroyPlant(id)
	local plant = plants[id] 

	if plant then
		if plant.entity then
			DeleteObject(plant.entity)
		end

		if plant.target then
			exports.ox_target:removeZone(plant.target)
		end

		if plant.plant then
			DeleteObject(plant.plant)
		end

		if plant.point then
			plant.point:remove()
		end

		plants[id] = nil
	end
end

local function openPlantMenu(id)
    lib.callback('kk-drugs:requestPlantInfo', false, function(response)
		if response then
			local elements = {}
		
			if response['health'].progress >= 100 then
				elements[#elements + 1] = {
					title = cfg.messages.harvest_title,
					icon = 'fa-solid fa-hand',
					event = 'kk-drugs:client:recievePlants',
					description = cfg.messages.harvest_description,
					args = {id = id}
				}
			end

			if response['type'] == 'none' then
				elements[#elements + 1] = {
					title = cfg.messages.plant_title,
					icon = 'fa-solid fa-hand',
					description = cfg.messages.pant_description,
					event = 'kk-drugs:client:plantSeed',
					args = {id = id}
				}

				if KKF.PlayerData.job.name == 'police' then
					elements[#elements + 1] = {
						title = cfg.messages.destroy_pot_title,
						icon = 'fa-solid fa-hand',
						iconColor = '#ef4444',
						description = cfg.messages.destroy_pot_description,
						event = 'kk-drugs:client:deletePot',
						args = {id = id}
					}
				end
			else
				if KKF.PlayerData.job.name == 'police' then
					elements[#elements + 1] = {
						title = cfg.messages.delete_plant_title,
						icon = 'fa-solid fa-hand',
						iconColor = '#ef4444',
						description = cfg.messages.delete_plant_description,
						event = 'kk-drugs:client:deletePlant',
						args = {id = id}
					}
				end

				-- elements[#elements + 1] = {
				-- 	title = cfg.messages.plant_healt,
				-- 	description = response['health'].progress .. '%',
				-- 	icon = 'fa-solid fa-arrow-up-right-dots',
				-- 	iconColor = '#22c55e',
				-- 	progress = response['health'].progress,
				-- 	colorScheme = 'cyan',
				-- }

				elements[#elements + 1] = {
					title = cfg.messages.water_pant .. response['health'].water .. '%',
					icon = 'fa-solid fa-bottle-water',
					iconColor = '#0ea5e9',
					progress = response['health'].water,
					colorScheme = 'blue',
					disabled = response['health'].progress >= 100 and true or response['health'].water > 100 - cfg.addwater and true or exports.ox_inventory:GetItemCount(cfg.wateritem) == 0 and true or false,

					description = cfg.messages.water_pant_description,
					event = 'kk-drugs:client:waterPlant',
					args = {id = id}
				}
				elements[#elements + 1] = {
					title = cfg.messages.fertilize_plant .. response['health'].fertilizer .. '%',
					icon = 'fa-solid fa-plant-wilt',
					iconColor = '#eab308',
					progress = response['health'].fertilizer,
					colorScheme = 'green',
					disabled = response['health'].progress >= 100 and true or response['health'].fertilizer > 100 - cfg.addfertilizer and true or exports.ox_inventory:GetItemCount(cfg.fertilizer) == 0 and true or false,
					description = cfg.messages.fertilize_plant_description,
					event = 'kk-drugs:client:fertilizePlant',
					args = {id = id}
				}
				
			end
		
			lib.registerContext({
				id = 'plant_menu',
				title = cfg.messages.plant_healt .. response['health'].progress .. '%',
				options = elements
			})
		
			lib.showContext('plant_menu')
		else
			destroyPlant(id)
		end
    end, id)
end

RegisterNetEvent('kk-drugs:client:addPlant', function(id, item)
	if plants[id] then
		plants[id].type = item

		if plants[id].entity and not plants[id].plant then
			local entityCoords = GetEntityCoords(plants[id].entity)
			local prop = joaat(cfg.plantsList[plants[id].type].prop)

			lib.requestModel(prop)
			plants[id].plant = CreateObject(prop, vec3(entityCoords.x, entityCoords.y, entityCoords.z + 0.2), false)

			FreezeEntityPosition(plants[id].plant, true)
			SetEntityInvincible(plants[id].plant, true)

			if not plants[id].point then
				if cfg.plantsList[plants[id].type].smell then
					local point = lib.points.new(entityCoords, math.random(75, 150), {})

					function point:onEnter()
						local inHeli = cache.vehicle and GetVehicleClass(cache.vehicle) == 15

						if not smellCooldown and not inHeli and plants[id] then
							if plants[id].type then
								smellCooldown = true
								-- TriggerEvent('KKF.UI.ShowNotification', 'info', cfg.plantsList[plants[id].type].smell_msg)

								cfg.ClientNotification(cfg.plantsList[plants[id].type].smell_msg, 'info')

								SetTimeout(60000, function()
									smellCooldown = false
								end)
							end
						end
					end

					plants[id].point = point;
				end
			end
		end
	end
end)

local function spawnPlant(id)
	if plants[id] then
		if not plants[id].entity then
			lib.requestModel(potProp)
			plants[id].entity = CreateObject(potProp, vec3(plants[id].position.x, plants[id].position.y, plants[id].position.z), false)

			FreezeEntityPosition(plants[id].entity, true)
			SetEntityInvincible(plants[id].entity, true)

			local entityCoords = GetEntityCoords(plants[id].entity)

			plants[id].target = exports.ox_target:addBoxZone({
				coords = entityCoords,
				size = vec3(0.6, 0.6, math.abs(entityCoords.z - entityCoords.z + 2)),
				rotation = 0,
				debug = false,
				options = {
					{
						icon = 'fa-solid fa-plant-wilt',
						label = cfg.messages.target_inspect,
						canInteract = function(entity, distance, coords, name, bone)
							return not exports['kk-taskbar']:canInteract()
						end,
						onSelect = function(data)
							if plants[id] then
								openPlantMenu(id)
							else
								destroyPlant(id)
							end
						end,
						distance = 2.0
					}
				}
			})

			if plants[id].type ~= 'none' then
				local prop = joaat(cfg.plantsList[plants[id].type].prop)

				lib.requestModel(prop)
				plants[id].plant = CreateObject(prop, vec3(entityCoords.x, entityCoords.y, entityCoords.z + 0.2), false)

				FreezeEntityPosition(plants[id].plant, true)
				SetEntityInvincible(plants[id].plant, true)

				if not plants[id].point then
					if cfg.plantsList[plants[id].type].smell then
						local point = lib.points.new(entityCoords, math.random(75, 150), {})
		
						function point:onEnter()
							local inHeli = cache.vehicle and GetVehicleClass(cache.vehicle) == 15

							if not smellCooldown and not inHeli then
								smellCooldown = true
								-- TriggerEvent('KKF.UI.ShowNotification', 'info', cfg.plantsList[plants[id].type].smell_msg)
								cfg.ClientNotification(cfg.plantsList[plants[id].type].smell_msg, 'info')
		
								SetTimeout(60000, function()
									smellCooldown = false
								end)
							end
						end

						plants[id].point = point;
					end
				end
			end
		end
	end
end

RegisterNetEvent('kk-drugs:client:plantPot', function(data)
	if plants[data.id] == nil then
		plants[data.id] = data

		spawnPlant(data.id)
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k,v in pairs(plants) do
			destroyPlant(k)
		end
	end
end)

RegisterNetEvent('kk-drugs:client:removePlant', function(id)
	destroyPlant(id)
end)

CreateThread(function()
	while not LocalPlayer.state['isLoggedIn'] do
		Wait(500)
	end

	lib.callback('kk-drugs:getPlants', false, function(response)
		if response then
			plants = response

			for k,v in pairs(plants) do
				spawnPlant(k)
			end
		end
	end)
end)

function scanForNearbyPlants(cb)
    local hasFound = false
	local playerCoords = GetEntityCoords(cache.ped)

    for k,v in pairs(plants) do
		local closestRadius = 3.0
		local distanceToPlant = #(playerCoords - vec3(v.position.x, v.position.y, v.position.z))

		if (distanceToPlant <= closestRadius) then
			hasFound = true
			break
		end
    end

    if cb then
        cb(hasFound)
    end
end

local function flatEnough(surfaceNormal)
	local x, y, z = math.abs(surfaceNormal.x), math.abs(surfaceNormal.y), math.abs(surfaceNormal.z)
	return (x <= cfg.angle and y <= cfg.angle and z >= 1.0 - cfg.angle)
end

local cld = false

RegisterNetEvent('kk-drugs:client:tryPlantPot', function()
	if not cld then
		local playerCoords = GetEntityCoords(cache.ped)
		local target = GetOffsetFromEntityInWorldCoords(cache.ped, vector3(0, 2, -3))
		local testRay = StartShapeTestRay(playerCoords, target, 17, cache.ped, 7)
		local _, hit, hitLocation, surfaceNormal, material, _ = GetShapeTestResultIncludingMaterial(testRay)

		if hit then
			if (cfg.useSoil and cfg.soil[material]) or not cfg.useSoil then
				if flatEnough(surfaceNormal) then
					scanForNearbyPlants(function(response)
						if not response then

							local progress = exports['kk-taskbar']:startAction('placePot', cfg.messages.planting_pot, cfg.progressbarlengt, 'plant_floor', 'weapons@first_person@aim_rng@generic@projectile@thermal_charge@', {freeze = true, controls = true})
							if progress then
								cld = true	

								SetTimeout(1000, function()
									cld = false
								end)

								TriggerServerEvent('KKF.Player.RemoveItem', cfg.potitem, 1)
								TriggerServerEvent('kk-drugs:server:plantPot')
							end
						else
							cfg.ClientNotification(cfg.messages.too_close, 'error')
						end
					end)
				else
					cfg.ClientNotification(cfg.messages.ground_not_flat, 'error')
				end
			else
				cfg.ClientNotification(cfg.messages.cant_grow_here, 'error')
			end
		else
			cfg.ClientNotification(cfg.messages.cant_grow_here, 'error')
		end
	end
end)


if cfg.UseDryer then
	local function canDry(name)
		for k,v in pairs(cfg.dryerTasks[name].needs) do
			if exports.ox_inventory:Search('count', v) < 1 then
				return false
			end
		end
	
		return true
	end

	RegisterNetEvent('kk-drugs:client:dryAction', function(args)
		if canDry(args.item) then
			local progress = exports['kk-taskbar']:startAction('waiting', cfg.messages.dryer_progress, 3000, 'base', 'anim@amb@carmeet@checkout_engine@female_a@base', {freeze = true, controls = true})
			if progress then
				TriggerServerEvent('kk-drugs:server:dryAction', args)
			end
		else
			-- TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil puuduvad vajalikud esemed kuivatamiseks.')
			cfg.ClientNotification(cfg.messages.dryer_donthave_right_items, 'error')
		end
	end)


	RegisterNetEvent('kk-drugs:client:hairDrier', function()
		local elements = {}

		for k,v in pairs(cfg.dryerTasks) do
			local needs = {}

			for kk,vv in pairs(v.needs) do
				needs[#needs + 1] = {label = exports.ox_inventory:Items()[vv].label, value = 1}
			end

			elements[#elements + 1] = {
				title = v.label,
				event = 'kk-drugs:client:dryAction',
				metadata = needs,
				args = {item = k}
			}
		end

		lib.registerContext({
			id = 'dryer_tasks',
			title = cfg.messages.dryer,
			options = elements
		})

		lib.showContext('dryer_tasks')
	end)
end