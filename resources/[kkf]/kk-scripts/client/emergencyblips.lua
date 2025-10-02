local ACTIVE = false
local ACTIVE_EMERGENCY_PERSONNEL = {}

RegisterNetEvent("eblips:toggle", function(on)
	ACTIVE = on

	if not ACTIVE then
		RemoveAnyExistingEmergencyBlips()
	end
end)

RegisterNetEvent("eblips:add", function(personnel)
	ACTIVE_EMERGENCY_PERSONNEL[personnel.src] = personnel
end)

RegisterNetEvent("eblips:update", function(person)
	for src, info in pairs(ACTIVE_EMERGENCY_PERSONNEL) do
		if DoesBlipExist(info.blip) then
			RemoveBlip(info.blip)
			info.blip = nil
		end
	end
	
	ACTIVE_EMERGENCY_PERSONNEL[person.src] = person
	
	if DoesBlipExist(ACTIVE_EMERGENCY_PERSONNEL[person.src].blip) then
		RemoveBlip(ACTIVE_EMERGENCY_PERSONNEL[person.src].blip)
		ACTIVE_EMERGENCY_PERSONNEL[person.src].blip = nil
	end
end)

RegisterNetEvent("eblips:remove", function(src)
	RemoveAnyExistingEmergencyBlipsById(src)
end)

function RemoveAnyExistingEmergencyBlips()
	for src, info in pairs(ACTIVE_EMERGENCY_PERSONNEL) do
		if DoesBlipExist(info.blip) then
			RemoveBlip(info.blip)
			ACTIVE_EMERGENCY_PERSONNEL[src] = nil
		else 
			local possible_blip = GetBlipFromEntity(GetPlayerPed(GetPlayerFromServerId(src)))
			if possible_blip ~= 0 then
				RemoveBlip(possible_blip)
				ACTIVE_EMERGENCY_PERSONNEL[src] = nil
			end
		end
	end
end

function RemoveAnyExistingEmergencyBlipsById(id)
	if ACTIVE_EMERGENCY_PERSONNEL[id] ~= nil then
		if DoesBlipExist(ACTIVE_EMERGENCY_PERSONNEL[id].blip) then
			RemoveBlip(ACTIVE_EMERGENCY_PERSONNEL[id].blip)
			ACTIVE_EMERGENCY_PERSONNEL[id] = nil
		else
			local possible_blip = GetBlipFromEntity(GetPlayerPed(GetPlayerFromServerId(id)))
			if possible_blip ~= 0 then
				RemoveBlip(possible_blip)
				ACTIVE_EMERGENCY_PERSONNEL[id] = nil
			end
		end
	end
end

Citizen.CreateThread(function()
	while true do
		wait = 1

		if ACTIVE then
			for src, info in pairs(ACTIVE_EMERGENCY_PERSONNEL) do
				local player = GetPlayerFromServerId(src)

				if player ~= -1 then
					if PlayerPedId() ~= GetPlayerPed(player) then
						local ped = GetPlayerPed(player)
							
						if DoesBlipExist(info.blip) then
							RemoveBlip(info.blip)
							info.blip = nil
						end
								
						if GetBlipFromEntity(ped) == 0 then
							local blip = AddBlipForEntity(ped)
							SetBlipSprite(blip, 1)
							SetBlipColour(blip, info.color)
							SetBlipAsShortRange(blip, true)
							SetBlipDisplay(blip, 4)
							SetBlipShowCone(blip, true)
							BeginTextCommandSetBlipName("STRING")

							if info.serial then
								ShowNumberOnBlip(blip, tonumber(info.serial))
							end

							AddTextComponentString(info.name)
							EndTextCommandSetBlipName(blip)
						end						
					end
				else
					if DoesBlipExist(info.blip) then
						SetBlipCoords(info.blip, info.x, info.y, info.z)

						if info.serial then
							ShowNumberOnBlip(info.blip, tonumber(info.serial))
						end
					else
						info.blip = AddBlipForCoord(info.x, info.y, info.z)
						SetBlipSprite(info.blip, 1)
						SetBlipColour(info.blip, info.color)
						SetBlipAsShortRange(info.blip, true)
						SetBlipDisplay(info.blip, 4)
						SetBlipShowCone(info.blip, true)
						BeginTextCommandSetBlipName("STRING")
							
						if info.serial then
							ShowNumberOnBlip(info.blip, tonumber(info.serial))
						end

						AddTextComponentString(info.name)
						EndTextCommandSetBlipName(info.blip)
					end
				end
			end
		else
			wait = 2000
		end

		Wait(wait)
	end
end)

RegisterNetEvent("kk-scripts:client:toggleStation", function()
	TriggerServerEvent('kk-scripts:server:toggleStation')
end) 