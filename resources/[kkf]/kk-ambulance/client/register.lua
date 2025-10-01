local bedOccupying = nil
local bedOccupyingData = nil
local currentHospital = nil
local kickDisabled = false

local function leaveBed(hospital, bed, illegal)	
	if not isDead then
		if not illegal then
			SetEntityHeading(cache.ped, bedOccupyingData.coords.w - 90)
			lib.requestAnimDict("switch@franklin@bed")
			TaskPlayAnim(cache.ped, 'switch@franklin@bed', 'sleep_getup_rubeyes' ,8.0, -8.0, -1, 0, 0, false, false, false)
			Wait(5000)
			ClearPedTasks(cache.ped)
		end
	end

    FreezeEntityPosition(cache.ped, false); SetEntityCoords(cache.ped, bedOccupyingData.coords.x, bedOccupyingData.coords.y + 1.0, bedOccupyingData.coords.z)
    TriggerServerEvent('kk-ambulance:server:leaveBed', hospital, bed)

    bedOccupying = nil
    bedOccupyingData = nil
	currentHospital = nil

	ClearPedTasksImmediately(cache.ped)
end

RegisterNetEvent('KKF.Player.Unloaded', function()
	if bedOccupying then
		TriggerServerEvent('kk-ambulance:server:leaveBed', currentHospital, bedOccupying)
		FreezeEntityPosition(cache.ped, false);

		bedOccupying = nil
		bedOccupyingData = nil
		currentHospital = nil
		kickDisabled = false
	end
end)

RegisterNetEvent('kk-ambulance:kickFromBed', function()
	if bedOccupying and not kickDisabled then
		TriggerServerEvent('kk-ambulance:server:leaveBed', currentHospital, bedOccupying)
		FreezeEntityPosition(cache.ped, false);

		bedOccupying = nil
		bedOccupyingData = nil
		currentHospital = nil
		kickDisabled = false
	end
end)

local registrationPoint = nil

for k,v in pairs(Config.Hospitals) do
	if v.registration then
		for i = 1, #v.registration do
			local point = lib.points.new(v.registration[i], 2.0, {
				hospital = k,
				jail = v.jail,
				illegal = v.illegal
			})
			
			function point:onEnter()
				registrationPoint = k
				ESX.ShowInteraction('Registratuur')
			end
			
			function point:onExit()
				registrationPoint = nil
				ESX.HideInteraction()
			end
		end
	end
end

exports('registrationPoint', function()
	return registrationPoint
end)

RegisterNetEvent('kk-ambulance:client:registrationPoint', function()
	Wait(350)
	local ambulanceOnline = lib.callback.await('kk-society:getOnlineMembers', false, 'ambulance')

	lib.callback('kk-ambulance:requestBed', false, function(response)
		if response then
			kickDisabled = true
			bedOccupying = response[1]
			bedOccupyingData = response[2]
			currentHospital = response[3]

			if Config.Hospitals[registrationPoint].illegal then
				local heading = bedOccupyingData.coords.w
				local armour = GetPedArmour(cache.ped)
				TriggerEvent('kk-ambulance:revive', false)
				SetPedArmour(cache.ped, armour)
				
				SetEntityCoords(cache.ped, bedOccupyingData.coords.x, bedOccupyingData.coords.y, bedOccupyingData.coords.z + 0.65)
				FreezeEntityPosition(cache.ped, false)
				lib.requestAnimDict("anim@gangops@morgue@table@")
				TaskPlayAnim(cache.ped, "anim@gangops@morgue@table@", "ko_front" ,8.0, -8.0, -1, 1, 0, false, false, false)

				if bedOccupyingData.model then
					local entity = GetClosestObjectOfType(bedOccupyingData.coords.x, bedOccupyingData.coords.y, bedOccupyingData.coords.z, 1.0, bedOccupyingData.model, false, false, false)

					if DoesEntityExist(entity) then
						heading = GetEntityHeading(entity)
					end
				end

				SetEntityHeading(cache.ped, heading)
				kickDisabled = false

				local progress = exports['kk-taskbar']:startAction('do_treatment', 'Arstid ravivad sind', 120000, false, false, {freeze = true, controls = true, disableCancel = true})
				
				if progress then
					TriggerServerEvent('kk-ambulance:server:payIllegal', currentHospital)
					SetEntityHealth(cache.ped, GetEntityMaxHealth(cache.ped))
					TriggerEvent('KKF.UI.ShowNotification', 'success', 'Sind raviti terveks')
					StopAnimTask(cache.ped, "anim@gangops@morgue@table@", "ko_front", false)
					leaveBed(currentHospital, bedOccupying, Config.Hospitals[registrationPoint].illegal)
				end
			else
				if (ambulanceOnline >= 1 and not Config.Hospitals[registrationPoint].jail) and not (ESX.PlayerData.job.name == 'ambulance' and ESX.PlayerData.job.onDuty) then
					TriggerEvent('KKF.UI.ShowNotification', 'info', 'Teid viidi palatisse! Oodake meediku saabumist.', 8000)

					SetTimeout(1500, function()
						ESX.ShowInteraction('Lahku voodist', 'C')
					end)

					local heading = bedOccupyingData.coords.w

					SetEntityCoords(cache.ped, bedOccupyingData.coords.x, bedOccupyingData.coords.y, bedOccupyingData.coords.z + 0.65)
					FreezeEntityPosition(cache.ped, false)
					lib.requestAnimDict("anim@gangops@morgue@table@")
					TaskPlayAnim(cache.ped, "anim@gangops@morgue@table@", "ko_front" ,8.0, -8.0, -1, 1, 0, false, false, false)

					if bedOccupyingData.model then
						local entity = GetClosestObjectOfType(bedOccupyingData.coords.x, bedOccupyingData.coords.y, bedOccupyingData.coords.z, 1.0, bedOccupyingData.model, false, false, false)

						if DoesEntityExist(entity) then
							heading = GetEntityHeading(entity)
						end
					end

					SetEntityHeading(cache.ped, heading)
					kickDisabled = false
			
					while bedOccupying do
						if IsControlJustReleased(0, 26) then
							StopAnimTask(cache.ped, "anim@gangops@morgue@table@", "ko_front", false)
							leaveBed(currentHospital, bedOccupying)
						end

						Wait(0)
					end

					ESX.HideInteraction();
				else
					local heading = bedOccupyingData.coords.w
					local armour = GetPedArmour(cache.ped)
					TriggerEvent('kk-ambulance:revive', false)
					SetPedArmour(cache.ped, armour)
					
					SetEntityCoords(cache.ped, bedOccupyingData.coords.x, bedOccupyingData.coords.y, bedOccupyingData.coords.z + 0.65)
					FreezeEntityPosition(cache.ped, false)
					lib.requestAnimDict("anim@gangops@morgue@table@")
					TaskPlayAnim(cache.ped, "anim@gangops@morgue@table@", "ko_front" ,8.0, -8.0, -1, 1, 0, false, false, false)

					if bedOccupyingData.model then
						local entity = GetClosestObjectOfType(bedOccupyingData.coords.x, bedOccupyingData.coords.y, bedOccupyingData.coords.z, 1.0, bedOccupyingData.model, false, false, false)

						if DoesEntityExist(entity) then
							heading = GetEntityHeading(entity)
						end
					end

					SetEntityHeading(cache.ped, heading)
					kickDisabled = false

					local progress = exports['kk-taskbar']:startAction('do_treatment', 'Arstid ravivad sind', 120000, false, false, {freeze = true, controls = true, disableCancel = true})
					
					if progress then
						SetEntityHealth(cache.ped, GetEntityMaxHealth(cache.ped))
						TriggerEvent('KKF.UI.ShowNotification', 'success', 'Sind raviti terveks')
						StopAnimTask(cache.ped, "anim@gangops@morgue@table@", "ko_front", false)
						leaveBed(currentHospital, bedOccupying)
					end
				end
			end
		else
			TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ühtegi voodit ei ole vaba!')
		end
	end, registrationPoint, ambulanceOnline)
end)