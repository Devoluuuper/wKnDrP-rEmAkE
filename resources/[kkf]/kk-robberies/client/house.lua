-- local currentBurglary = 0
-- local targets = {}
-- local inHouse = false
-- local placesAdded = false
-- local houseLists = {}
-- local ox_target = exports.ox_target

-- RegisterNetEvent('kk-robberies:addPlaces')
-- AddEventHandler('kk-robberies:addPlaces', function(houseId)
-- 	currentBurglary = houseId

-- 	if not placesAdded and currentBurglary == houseId then
-- 		placesAdded = true

-- 		for k,v in pairs(Config.Places) do
-- 			targets[k .. '-h-' .. houseId] = ox_target:addSphereZone({
-- 				coords = v.pos,
-- 				radius = 0.55,
-- 				debug = true,
-- 				options = {
-- 					{
-- 						icon = "fas fa-search",
-- 						label = "Otsi",
-- 						distance = 1.5,
-- 						onSelect = function(data)
-- 							TriggerEvent('kk-robberies:searchBurglary', k .. '-h-' .. houseId)
-- 						end
-- 					}
-- 				}
-- 			})
-- 		end
-- 	end
-- end)

-- SetInterval(function()
-- 	if currentBurglary ~= 0 then
-- 		if IsPedDeadOrDying(cache.ped, 1) then
-- 			lib.callback('kk-robberies:leaveHouse', false, function(response)
-- 				if response then
-- 					SetEntityCoords(cache.ped, response)
-- 					Wait(500)
-- 					SetTimeout(2000, function()
-- 						TriggerEvent('kk-scripts:client:reloadWeapons')
-- 					end)
-- 				end
-- 			end, currentBurglary)
-- 		end
-- 	end
-- end, 5000)

-- RegisterNetEvent('kk-robberies:tryRemoveShelf')
-- AddEventHandler('kk-robberies:tryRemoveShelf', function(id)
-- 	if id ~= 0 then
-- 		ox_target:removeZone(targets[id]); targets[id] = nil
-- 	end
-- end)

-- RegisterNetEvent('kk-robberies:endBurglary')
-- AddEventHandler('kk-robberies:endBurglary', function(id)
-- 	if currentBurglary == id then
-- 		placesAdded = false

-- 		for k,v in pairs(targets) do
-- 			ox_target:removeZone(v); targets[k] = nil
-- 		end

-- 		if inHouse then
-- 			inHouse = false
-- 			SetEntityCoords(PlayerPedId(), houseLists[currentBurglary].pos)
-- 		end

-- 		currentBurglary = 0
-- 	end 
-- end)

-- local cooldown = false

-- RegisterNetEvent('kk-robberies:searchBurglary')
-- AddEventHandler('kk-robberies:searchBurglary', function(id)
--     if currentBurglary == 0 then return end
    
--     if id ~= 0 then
--         if not cooldown then
--             SetTimeout(10000, function()
--                 cooldown = false
--             end)
            
--             local playerPed = PlayerPedId()
--             local coords = GetEntityCoords(playerPed)

--             TriggerEvent('kk-needs:client:addNeed', 'stress', 2000)

--             local progress = exports['kk-taskbar']:startAction('search', 'Otsid kapist', 8000, 'pluck_fruits', 'custom@pluck_fruits', {freeze = true, controls = true})
            
--             if progress then
--                 cooldown = true
                
--                 lib.callback('kk-robberies:searchBurglary', false, function(response)
--                     if response then
--                         ClearPedTasks(playerPed)
--                     else
--                         ClearPedTasks(playerPed)
--                     end
--                 end, id)
--             end
--         else
--             TriggerEvent('KKF.UI.ShowNotification', 'error', 'Oota, ära kiirusta!')
--         end
--     end
-- end)

-- RegisterNetEvent('KKF.Player.Loaded')
-- AddEventHandler('KKF.Player.Loaded', function(playerData)
-- 	lib.callback('kk-robberies:getHouses', false, function(response)
-- 		houseLists = response

-- 		for k,v in pairs(response) do
-- 			local blip = AddBlipForCoord(v.pos.x, v.pos.y, v.pos.z)
-- 			SetBlipSprite (blip, 492)
-- 			SetBlipDisplay(blip, 4)
-- 			SetBlipScale  (blip, 0.5)
-- 			SetBlipColour (blip, 1)
-- 			SetBlipAsShortRange(blip, true)
-- 			SetBlipHiddenOnLegend(blip, true)
	
-- 			BeginTextCommandSetBlipName("STRING")
-- 			AddTextComponentString('Majarööv')
-- 			EndTextCommandSetBlipName(blip)
-- 		end
-- 	end)
-- end)

-- RegisterNetEvent('KKF.Player.Unloaded', function() 
-- 	houseLists = {}
-- end)

-- RegisterNetEvent('kk-robberies:reloadHouses')
-- AddEventHandler('kk-robberies:reloadHouses', function(response)
-- 	houseLists = response
-- end)

-- Citizen.CreateThread(function()
--     local alreadyEnteredZone = false
--     local text = nil

--     while true do
-- 		wait = 5

-- 		local ped = PlayerPedId()
-- 		local inZone = false

-- 		for k,v in pairs(houseLists) do
-- 			local dist = #(GetEntityCoords(ped) - v.pos)

-- 			if dist <= 2.0 then
-- 				wait = 5
-- 				inZone  = true

--                 if v.locked then
--                     text = '[E] - Alusta majaröövi'
--                 else
--                     text = '[E] - Sisene majja'
--                 end

-- 				if IsControlJustReleased(0, 38) then
-- 					lib.callback('kk-robberies:checkGlobal', false, function(status)
--                         if not status or not v.locked then
-- 							lib.callback('kk-society:getOnlineMembers', false, function(qtty)
-- 								if qtty >= Config.ReqPoliceHouse or not v.locked then
-- 									lib.callback('KKF.Item.Amount', false, function(qtty2) 
-- 										if qtty2 > 0 or not v.locked then
--                                             if v.locked then
-- 												lib.callback('kk-robberies:startBurglary', false, function(response)
--                                                     if response then
-- 														TriggerEvent('qb-lockpick:client:openLockpick', function(skill)
-- 															if skill then
-- 																TriggerEvent('kk-scripts:client:removeWeapons')
-- 																TriggerServerEvent('kk-robberies:openHouse', k)
-- 															else
-- 																TriggerServerEvent('kk-robberies:openFailed', k)
-- 																TriggerEvent('KKF.UI.ShowNotification', "error", "Te ei saanud luku muukimisega hakkama!")
-- 															end
-- 														end)
--                                                     else
--                                                         TriggerEvent('KKF.UI.ShowNotification', "error", "Seda maja ei saa hetkel röövida!")	
--                                                     end
--                                                 end, k)
--                                             else
-- 												TriggerEvent('kk-scripts:client:removeWeapons')
-- 												lib.callback('kk-robberies:enterHouse', false, function(response)
--                                                     if response then
--                                                         SetEntityCoords(ped, 346.52, -1013.19, -99.2)
-- 														inHouse = true
--                                                         SetEntityHeading(ped, 357.81)
-- 														Wait(500)
-- 														SetTimeout(2000, function()
-- 															TriggerEvent('kk-scripts:client:reloadWeapons')
-- 														end)
--                                                     end
--                                                 end, k)
--                                             end
-- 										else
-- 											TriggerEvent('KKF.UI.ShowNotification', "error", "Teil ei ole multitööriista!")	
-- 										end
-- 									end, 'lockpick')
-- 								else
-- 									TriggerEvent('KKF.UI.ShowNotification', "error", "Linnas ei ole piisavalt politseinike!")	
-- 								end
-- 							end, 'police')
-- 						else
-- 							TriggerEvent('KKF.UI.ShowNotification',"error", "Te ei saa hetkel röövida!")
-- 						end
-- 					end)
-- 				end

-- 				break
-- 			else
-- 				wait = 2000
-- 			end
-- 		end

-- 		if inZone and not alreadyEnteredZone then
-- 			alreadyEnteredZone = true
-- 			KKF.ShowInteraction(text)
-- 		end

-- 		if not inZone and alreadyEnteredZone then
-- 			alreadyEnteredZone = false
-- 			KKF.HideInteraction()
-- 		end

-- 		Citizen.Wait(wait)
--     end
-- end)

-- RegisterNetEvent('kk-robberies:setOutOfHouse', function()
-- 	currentBurglary = 0
-- 	inHouse = false
-- end)

-- Citizen.CreateThread(function()
--     local alreadyEnteredZone = false
--     local text = '[E] - Lahku majast'
--     while true do
--         wait = 5
--         local ped = PlayerPedId()
--         local inZone = false
--         local dist = #(GetEntityCoords(ped)-vec3(346.24, -1013.18, -99.19))

--         if dist <= 2.0 then
--             wait = 5
--             inZone  = true

--             if IsControlJustReleased(0, 38) then
-- 				if currentBurglary == 0 then return end
-- 				TriggerEvent('kk-scripts:client:removeWeapons')
-- 				lib.callback('kk-robberies:leaveHouse', false, function(response)
-- 					if response then
-- 						SetEntityCoords(ped, response)
-- 						Wait(500)
-- 						SetTimeout(2000, function()
-- 							TriggerEvent('kk-scripts:client:reloadWeapons')
-- 						end)
-- 					end
-- 				end, currentBurglary)
--             end
--         else
--             wait = 2000
--         end
        
--         if inZone and not alreadyEnteredZone then
--             alreadyEnteredZone = true
--             KKF.ShowInteraction(text)
--         end

--         if not inZone and alreadyEnteredZone then
--             alreadyEnteredZone = false
--             KKF.HideInteraction()
--         end
--         Citizen.Wait(wait)
--     end
-- end)