local needs = {
	thirst = { val = 25000, warning = 0 },
	hunger = { val = 25000, warning = 0 },
	drunk = { val = 0, warning = 0 },
	stress = { val = 0, warning = 0 }
}

exports('getNeeds', function()
	return needs
end)

SetInterval(function()
	if LocalPlayer.state.isLoggedIn then
		TriggerServerEvent('kk-needs:saveNeeds', needs)
	end
end, 60000)


local shakecam = 0.0

RegisterNetEvent('KKF.Player.Loaded')
AddEventHandler('KKF.Player.Loaded', function()
	lib.callback('kk-needs:getNeeds', false, function(data)
		if data ~= nil then 
			needs.thirst.val = data.thirst.val
			needs.hunger.val = data.hunger.val
			needs.drunk.val = data.drunk.val
			needs.stress.val = data.stress.val
		else
			needs.thirst.val = 25000
			needs.hunger.val = 25000
			needs.drunk.val = 0
			needs.stress.val = 0
		end
	end)
end)

RegisterNetEvent('KKF.Player.Unloaded', function() 
	TriggerServerEvent('kk-needs:saveNeeds', needs)
end)

function SendWarning(option)
	local currentHealth = GetEntityHealth(PlayerPedId())
	SetEntityHealth(PlayerPedId(), currentHealth - 15)
	if option == "thirst" then
		TriggerEvent('KKF.UI.ShowNotification', 'info', 'Olete janusse suremas!')
	else
		TriggerEvent('KKF.UI.ShowNotification', 'info', 'Olete nälga suremas!')
	end
	needs[option].warning = 10
end

function SetWalkDrunk(dict)
	local playerPed = PlayerPedId()
	SetPedMovementClipset(playerPed, dict)
end

SetInterval(function()
    if IsPedDeadOrDying(PlayerPedId(), false) == false and LocalPlayer.state.isLoggedIn then
        for option, value in pairs(needs) do
            if needs[option].val ~= nil then
                if needs[option].val > 0 then
                    --- Values
                    if option ~= 'stress' then 
                        if IsPedSprinting(cache.ped) or IsPedSwimming(cache.ped) or IsPedSwimming(cache.ped) then
                            needs[option].val = needs[option].val - 117.75
                        elseif IsPedRunning(cache.ped) then
                            needs[option].val = needs[option].val - 83
                        elseif IsPedWalking(cache.ped) then
                            needs[option].val = needs[option].val - 56
                        else
                            needs[option].val = needs[option].val - 34.75
                        end
                    end
                    
                    ---- Effects
                    if option == "drunk" then
                        SetPedIsDrunk(PlayerPedId(), true)
                        SetPedConfigFlag(PlayerPedId(), 100, true)
                        local walkstyle = "NONE"
                        
                        if needs[option].val > 22500 then --- blackout
                            if IsGameplayCamShaking() == false or shakecam ~= 2.5 then
                                ShakeGameplayCam("DRUNK_SHAKE", 2.5)
                                shakecam = 2.5
                            end
                        elseif needs[option].val < 22500 and needs[option].val > 15000 then --- very drunk
                            if IsGameplayCamShaking() == false or shakecam ~= 1.5 then
                                ShakeGameplayCam("DRUNK_SHAKE", 1.5)
                                shakecam = 1.5
                            end
                            SetWalkDrunk("MOVE_M@drunk@VERYdrunk")
                        elseif needs[option].val < 15000 and needs[option].val > 7500 then --- moderate drunk
                            if IsGameplayCamShaking() == false or shakecam ~= 1.0 then
                                ShakeGameplayCam("DRUNK_SHAKE", 1.0)
                                shakecam = 1.0
                            end
                            SetWalkDrunk("MOVE_M@drunk@MODERATEdrunk")
                        elseif needs[option].val < 7500 and needs[option].val > 2250 then --- slightly drunk
                            if IsGameplayCamShaking() == false or shakecam ~= 0.5 then
                                ShakeGameplayCam("DRUNK_SHAKE", 0.5)
                                shakecam = 0.5
                            end
                            SetWalkDrunk("MOVE_M@drunk@SLIGHTLYdrunk")
                        elseif needs[option].val < 2250 then --- very slow drunk
                            if IsGameplayCamShaking() == false or shakecam ~= 0.2 then
                                ShakeGameplayCam("DRUNK_SHAKE", 0.2)
                                shakecam = 0.2
                            end
                            SetWalkDrunk(nil)
                        end
                    elseif option == "thirst" or option == "hunger" then 
                        if needs[option].val < 9000 then
                            if needs[option].warning == 0 then
                                if option == "thirst" then
                                    TriggerEvent('KKF.UI.ShowNotification', 'info', 'Su kurk kuivab!')
                                else
                                    TriggerEvent('KKF.UI.ShowNotification', 'info', 'Su kõht koriseb!')
                                end
                                needs[option].warning = 15
                            else
                                needs[option].warning = needs[option].warning - 1
                            end
                        end                    
                    end                 
                elseif needs[option].val == 0 or needs[option].val < 0 then
                    needs[option].val = 0
    
                    if option == "thirst" or option == "hunger" then
                        if needs[option].warning == 0 then
                            SendWarning(option)
                        else
                            needs[option].warning = needs[option].warning - 1
                        end
                    end
                    
                    if option == "drunk" and shakecam ~= 0.0 then
                        SetPedIsDrunk(PlayerPedId(), false)
                        StopGameplayCamShaking(true)
                        SetPedConfigFlag(PlayerPedId(), 100, false)  
                        shakecam = 0.0
                        SetWalkDrunk(nil)
                    end
                end
            end    
        end
        
        TriggerEvent('KKF.UI.Needs', {stress = (needs.stress.val / 100000) * 100, thirst = (needs.thirst.val / 100000) * 100, hunger = (needs.hunger.val / 100000) * 100})
    end
end, 5000)


CreateThread(function()
	while true do
		if needs['stress'].val > 75000 then
            if math.random(1, 10) == math.random(3, 8) then
                if math.random(1,3) == 1 then
                    AnimpostfxPlay('DrugsTrevorClownsFightIn', 0, false)
                    Wait(2500)
                    AnimpostfxStop('DrugsTrevorClownsFightIn')
                    AnimpostfxPlay('DrugsTrevorClownsFight', 0, false)
                    Wait(5000)
                    AnimpostfxStop('DrugsTrevorClownsFight')
                    AnimpostfxPlay('DrugsTrevorClownsFightOut', 0, false)
                    Wait(2500)
                    AnimpostfxStop('DrugsTrevorClownsFightOut')
                elseif math.random(1,3) == 2 then
                    AnimpostfxPlay('DrugsMichaelAliensFightIn', 0, false)
                    Wait(2500)
                    AnimpostfxStop('DrugsMichaelAliensFightIn')
                    AnimpostfxPlay('DrugsMichaelAliensFight', 0, false)
                    Wait(5000)
                    AnimpostfxStop('DrugsMichaelAliensFight')
                    AnimpostfxPlay('DrugsMichaelAliensFightOut', 0, false)
                    Wait(2500)
                    AnimpostfxStop('DrugsMichaelAliensFightOut')
                else
                    Wait(1000)
                end
            else
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.11)
            end
        elseif needs['stress'].val > 45000 then 
            if math.random(1, 10) == 5 then
                AnimpostfxPlay('Rampage', 0, false)
                Wait(5000)
                AnimpostfxStop('Rampage')
                AnimpostfxPlay('RampageOut', 0, false)
                Wait(5000)
                AnimpostfxStop('RampageOut')
            elseif math.random(1, 5) == 3 then
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.1)
            else
                Wait(1000)
            end
        elseif needs['stress'].val > 25000 then 
            if math.random(1, 10) == math.random(1, 15) then
                SetCamEffect(1)
                Wait(10000)
                SetCamEffect(0)
            else
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.03)
            end
        elseif needs['stress'].val > 10000 then
            if math.random(1, 10) == math.random(1, 15) then
                TransitionToBlurred(500)
                Wait(math.random(1500, 2000))
                TransitionFromBlurred(500)
            else
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.01)
            end
        end

        if needs['stress'].val < 10000 then 
			Wait(10000 - 2750)
        elseif needs['stress'].val < 15000 then 
			Wait(5000 - 2750) 
		end

        Wait(2750)
	end
end)


RegisterNetEvent('kk-needs:client:addNeed', function(need, value)
	needs[need].val = needs[need].val + tonumber(value)

	if need ~= "drunk" and tonumber(needs[need].val) >= 100000 then
		needs[need].val = 100000
	elseif need == "drunk" and tonumber(needs[need].val) >= 25000 then
		needs[need].val = 25000
	elseif need == "stress" and tonumber(needs[need].val) >= 100000 then
		needs[need].val = 100000
	end
end)

RegisterNetEvent('kk-needs:client:removeNeed', function(need, value)
	needs[need].val = needs[need].val - tonumber(value)
	
	if need == 'stress' and tonumber(needs[need].val) < 1 then
		needs[need].val = 0
	end
end)

RegisterNetEvent('kk-needs:client:setNeed', function(need, value)
	needs[need].val = tonumber(value)
end)


local eatProps = {
	----['mexican_taco'] = joaat('nels_tacos_prop'),
	-- ['fried_french_fries'] = joaat('gn_upnatom_vw_fries'),
	---- ['goat_cheese_wrap'] = joaat(''),
	---- ['chicken_wrap'] = joaat(''),
	-- ['simply'] = joaat('gn_upnatom_vw_the_triple_cheesy_bacon_burger'),
	-- ['prickly'] = joaat('gn_upnatom_vw_the_10_slice_of_bacon_triple_cheese_melt'),
	-- ['glorious'] = joaat('gn_upnatom_vw_the_10_slice_of_bacon_triple_cheese_melt_version'),
	-- ['bleeder'] = joaat('gn_upnatom_vw_the_triple_cheesy_bacon_burger'),
	-- ['double_shot'] = joaat('gn_upnatom_vw_the_triple_burger'),
	['chips'] = joaat('v_ret_ml_chips4')
}
RegisterNetEvent('kk-needs:client:onEat', function(amount, item, slot)
	if not IsAnimated then
		IsAnimated = true
		local entity = exports['kk-scripts']:spawnAttachedObject(cache.ped, eatProps[item] or joaat('prop_cs_burger_01'), 18905, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0)
		local progress = exports['kk-taskbar']:startAction('eating', 'Sööd', 9000, 'mp_player_int_eat_burger_fp', 'mp_player_inteat@burger', {freeze = false, controls = false})

		if progress then
			IsAnimated = false

			TriggerEvent('kk-needs:client:addNeed', 'hunger', tostring(amount))
			TriggerServerEvent('KKF.Player.RemoveItem', item, 1)
		else
			IsAnimated = false
		end

		ESX.Game.DeleteEntity(entity)
	end
end)

local drinkProps = {
	-- ['cola_light_cup'] = joaat('gn_upnatom_vw_soda_cup'),
	-- ['orango_cup'] = joaat('gn_upnatom_vw_soda_cup'),
	-- ['cola_cup'] = joaat('gn_upnatom_vw_soda_cup'),
	-- ['sprunk_cup'] = joaat('gn_upnatom_vw_soda_cup'),
	['cola'] = joaat('prop_ecola_can'),
	['sprunk'] = joaat('prop_ld_can_01'),
	-- ['filter_coffee'] = joaat('gn_upnatom_vw_coffee'),
}

RegisterNetEvent('kk-needs:client:onDrink', function(amount, item)
	if not IsAnimated then
		IsAnimated = true

		local entity = exports['kk-scripts']:spawnAttachedObject(cache.ped, drinkProps[item] or joaat('prop_ld_flow_bottle'), 18905, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0)
		local progress = exports['kk-taskbar']:startAction('drinking', 'Jood', 9000, 'loop_bottle', 'mp_player_intdrink', {freeze = false, controls = false})

		if progress then
			IsAnimated = false

			TriggerEvent('kk-needs:client:addNeed', 'thirst', tostring(amount))
			TriggerServerEvent('KKF.Player.RemoveItem', item, 1)
		else
			IsAnimated = false
		end

		ESX.Game.DeleteEntity(entity)
	end
end)

local combinedProps = {
	['peabtegema'] = joaat('gn_upnatom_vw_tray_meteorite'),
	-- ['orango_icecream'] = joaat('gn_upnatom_vw_tray_orangotang')
}

RegisterNetEvent('kk-needs:client:onCombined', function(amounts, item, slot)
	if not IsAnimated then
		IsAnimated = true

		local entity = exports['kk-scripts']:spawnAttachedObject(cache.ped, combinedProps[item] or joaat('prop_ld_flow_bottle'), 18905, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0)
		local progress = exports['kk-taskbar']:startAction('eating_combined', 'Sööd', 9000, 'mp_player_int_eat_burger_fp', 'mp_player_inteat@burger', {freeze = false, controls = false})

		if progress then
			IsAnimated = false

			TriggerEvent('kk-needs:client:addNeed', 'hunger', tostring(amounts.hunger))
			TriggerEvent('kk-needs:client:addNeed', 'thirst', tostring(amounts.thirst))
			TriggerEvent('kk-needs:client:removeNeed', 'stress', tostring(amounts.stress))

			TriggerServerEvent('KKF.Player.RemoveItem', item,1)
		else
			IsAnimated = false
		end

		ESX.Game.DeleteEntity(entity)
	end
end)

RegisterNetEvent('kk-needs:onDrinkAlochol')
AddEventHandler('kk-needs:onDrinkAlochol', function(amount, item)
	if not IsAnimated then
		prop_name = 'prop_cs_whiskey_bottle'; IsAnimated = true
		local x,y,z = table.unpack(GetEntityCoords(cache.ped))
		local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
		SetEntityCollision(prop, false, false)
		local boneIndex = GetPedBoneIndex(cache.ped, 18905)
		AttachEntityToEntity(prop, cache.ped, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)

		local progress = exports['kk-taskbar']:startAction('drinking', 'Jood', 3000, 'loop_bottle', 'mp_player_intdrink', {freeze = false, controls = false})

		if progress then
			IsAnimated = false; TriggerServerEvent('KKF.Player.RemoveItem', item, 1)
			TriggerEvent('kk-needs:client:addNeed', 'drunk', tostring(amount))
			ESX.Game.DeleteEntity(prop)
		else
			ESX.Game.DeleteEntity(prop); IsAnimated = false
		end
	end
end)
