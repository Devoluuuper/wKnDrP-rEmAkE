local isActive = false; local ox_target = exports.ox_target
local targets = {}

RegisterNetEvent('kk-robberies:startJewelry')
AddEventHandler('kk-robberies:startJewelry', function()
	if isActive then return end

	lib.callback('kk-robberies:setBusy', false, function(cb)
		if cb then  
			for k,v in pairs(Config.Stores) do
				for k2,v2 in pairs(v.locations) do
					targets[k2] = ox_target:addSphereZone({
						coords = vector3(v2.x, v2.y, v2.z),
						radius = 0.5,
						debug = true,
						options = {
							{
								icon = "fas fa-hand-rock",
								label = "Purusta klaas",
								distance = 1.5,
								onSelect = function(data)
									TriggerEvent('kk-robberies:breakJewelryGlass', k2)
								end
							}
						}
					})
				end
			end
		end
	end, true)
end) 

RegisterNetEvent('kk-robberies:endJewelry')
AddEventHandler('kk-robberies:endJewelry', function()
	if not isActive then return end

	lib.callback('kk-robberies:setBusy', false, function(cb)
		if cb then  
			for i = 1, #targets do
				ox_target:removeZone(targets[i]); targets[i] = nil
			end
		
			isActive = false
		end
	end, false)
end)

RegisterNetEvent('kk-robberies:jewelryStatus', function(respond)
	isActive = respond
end) 

RegisterNetEvent('kk-robberies:breakJewelryGlass')
AddEventHandler('kk-robberies:breakJewelryGlass', function(id)
    if not isActive then return end

    if id ~= 0 then
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
		
        local skillSuccess = exports['kk-skillbar']:skillBar(70, 5)

        if skillSuccess then
            local progress = exports['kk-taskbar']:startAction('break', 'Lõhud vitriinkappi', math.random(4500, 5600), 'smash_case', 'missheist_jewel', {freeze = true, controls = true})

            PlaySoundFromCoord(-1, "Glass_Smash", coords.x, coords.y, coords.z, 0, 0, 0)
            if progress then
                lib.callback('kk-robberies:breakGlass', false, function(response)
                    if response then
                        ClearPedTasks(playerPed)
                    else
                        ClearPedTasks(playerPed)
                    end
                end, id)
            end
        else
            ClearPedTasks(playerPed)
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ei suutnud klaasi purustada.')
        end
    end
end)


RegisterNetEvent('kk-robberies:removeGlass')
AddEventHandler('kk-robberies:removeGlass', function(id)
	if id ~= 0 then
		ox_target:removeZone(targets[id]); targets[id] = nil
	end
end)

function checkDistance(shopId)
	isActive = true

	CreateThread(function()
	    while isActive do
			if isActive then
				local coords = Config.Stores[shopId].pos
				local distance = #(GetEntityCoords(PlayerPedId()) - vec3(coords.x, coords.y, coords.z))
	
				if distance > 20 then
					TriggerEvent('KKF.UI.ShowNotification', 'info', 'Rööv lõpetatud.')
					TriggerServerEvent('kk-robberies:endJewelry')
				end
			else
				break
			end
	
			Wait(2000)
		end
	end)
end

-- Create blip
Citizen.CreateThread(function()
	for k,v in pairs(Config.Stores) do
		local blip = AddBlipForCoord(v.pos.x, v.pos.y, v.pos.z)

		SetBlipSprite(blip, 439)
		SetBlipScale(blip, 0.5)
		SetBlipColour(blip, 1)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Juveelipood')
		EndTextCommandSetBlipName(blip)
	end
end)

Citizen.CreateThread(function()
    local alreadyEnteredZone = false
    local text = '[E] - Alusta juveelipoeröövi'

    while true do
		wait = 5

		local ped = PlayerPedId()
		local inZone = false

		for k,v in pairs(Config.Stores) do
			local dist = #(GetEntityCoords(ped) - v.pos)

			if dist <= 1.5 then
				wait = 5
				inZone  = true

				if IsControlJustReleased(0, 38) then
					if KKF.PlayerData.job.name ~= 'police' then
						lib.callback('kk-robberies:checkGlobal', false, function(status)
							if not status then
								lib.callback('kk-society:getOnlineMembers', false, function(qtty)
									if qtty >= Config.ReqPoliceJewelry then
										lib.callback('KKF.Item.Amount', false, function(qtty2) 
											if qtty2 > 0 then
												lib.callback('kk-robberies:startJewelry', false, function(response)
													if response then
														TriggerServerEvent('KKF.Player.RemoveItem', 'jewelry_id', 1)
														checkDistance(k)
													else
														TriggerEvent('KKF.UI.ShowNotification', "error", "Seda kohta ei saa praegu röövida!")	
													end
												end, k)
											else
												TriggerEvent('KKF.UI.ShowNotification', "error", "Teil ei ole juveelipoe kiipkaarti!")	
											end
										end, 'jewelry_id')
									else
										TriggerEvent('KKF.UI.ShowNotification', "error", "Linnas ei ole piisavalt politseinike!")	
									end
								end, 'police')
							else
								TriggerEvent('KKF.UI.ShowNotification',"error", "Te ei saa hetkel röövida!")
							end
						end)
					else
						TriggerEvent('KKF.UI.ShowNotification',"error", "Te ei saa röövida!")
					end
				end

				break
			else
				wait = 2000
			end
		end

		if inZone and not alreadyEnteredZone then
			alreadyEnteredZone = true
			KKF.ShowInteraction(text)
		end

		if not inZone and alreadyEnteredZone then
			alreadyEnteredZone = false
			KKF.HideInteraction()
		end

		Citizen.Wait(wait)
    end
end)