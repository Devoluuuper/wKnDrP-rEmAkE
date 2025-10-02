local currentGear = {
    mask = 0,
    tank = 0,
    enabled = false
}

local function isUsing()
    return currentGear.enabled
end

exports('isUsingScuba', isUsing)

local function deleteGear()
	if currentGear.mask ~= 0 then
        DetachEntity(currentGear.mask, 0, 1)
        DeleteEntity(currentGear.mask)

		currentGear.mask = 0
    end
    
	if currentGear.tank ~= 0 then
        DetachEntity(currentGear.tank, 0, 1)
        DeleteEntity(currentGear.tank)

		currentGear.tank = 0
	end
end

RegisterNetEvent('kk-scripts:client:useScuba', function()
    if not currentGear.enabled and not cache.vehicle then
        local progress = exports['kk-taskbar']:startAction('scuba', 'Paned varustust selga', 10000, 'try_shirt_positive_d', 'clothingshirt', {freeze = true, controls = true})

        if progress then
            deleteGear()

            RequestModel(joaat('p_s_scuba_tank_s'))
            while not HasModelLoaded(joaat('p_s_scuba_tank_s')) do
                Wait(1)
            end
            TankObject = CreateObject(joaat('p_s_scuba_tank_s'), 1.0, 1.0, 1.0, 1, 1, 0)
            local bone1 = GetPedBoneIndex(cache.ped, 24818)
            AttachEntityToEntity(TankObject, cache.ped, bone1, -0.30, -0.25, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)
            currentGear.tank = TankObject

            RequestModel(joaat('p_d_scuba_mask_s'))
            while not HasModelLoaded(joaat('p_d_scuba_mask_s')) do
                Wait(1)
            end
            
            MaskObject = CreateObject(joaat('p_d_scuba_mask_s'), 1.0, 1.0, 1.0, 1, 1, 0)
            local bone2 = GetPedBoneIndex(cache.ped, 12844)
            AttachEntityToEntity(MaskObject, cache.ped, bone2, 0.0, 0.0, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)
            currentGear.mask = MaskObject
        
            SetEnableScuba(cache.ped, true)
            currentGear.enabled = true
            TriggerServerEvent('KKF.Player.RemoveItem', 'scuba_gear', 1)
            ClearPedTasks(cache.ped)
        
            TriggerEvent('KKF.UI.ShowNotification', 'info', 'Radiaalmenüü alt saad eemaldada varustuse!', 15000)
            TriggerEvent('KKF.UI.ShowNotification', 'info', 'Vee all saad püsida kuni 4 minutit!', 15000)

            local counter = 0
            local oxygen = true

            SetPedMaxTimeUnderwater(cache.ped, 2000.00)

            while currentGear.enabled and oxygen do
                counter += 1

                if counter > 240 then
                    oxygen = false
                end

                Wait(1000)
            end

            SetPedMaxTimeUnderwater(cache.ped, 10.0)
            TriggerEvent('KKF.UI.ShowNotification', 'info', 'Tunned, et hapnik sai otsa!')
        end
    end
end)

RegisterNetEvent('kk-scripts:client:removeScuba', function()
    if currentGear.enabled and not cache.vehicle then
        local progress = exports['kk-taskbar']:startAction('scuba', 'Võtad varustust seljast', 10000, 'try_shirt_positive_d', 'clothingshirt', {freeze = true, controls = true})

        if progress then
            deleteGear()
            SetPedMaxTimeUnderwater(cache.ped, 10.0)
            SetEnableScuba(cache.ped, false)
            currentGear.enabled = false
            ClearPedTasks(cache.ped)
        end
    end
end)

AddStateBagChangeHandler('isDead', nil, function(bagName, key, value) 
    local player = GetPlayerFromStateBagName(bagName)

    if player == cache.playerId then 
        if value and currentGear.enabled then
            deleteGear()
            SetPedMaxTimeUnderwater(cache.ped, 10.0)
            SetEnableScuba(cache.ped, false)
            currentGear.enabled = false
            ClearPedTasks(cache.ped)
        end
	end
end)