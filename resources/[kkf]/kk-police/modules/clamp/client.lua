local clampModel = `prop_sign_gas_04`

local function isClamped(vehicle)
    if DoesEntityExist(vehicle) then
        local networkId = NetworkGetNetworkIdFromEntity(vehicle)
        local status = lib.callback.await('kk-police:isClamped', false, networkId)

        return status
    else
        return false
    end
end

exports('isClamped', isClamped)

local function toggleClamp(vehicle, status)
    if DoesEntityExist(vehicle) then
        local networkId = NetworkGetNetworkIdFromEntity(vehicle)
        local status = lib.callback.await('kk-police:setClamp', false, networkId, status)

        return status
    else
        return false
    end
end

function attachClampToVehicle(vehicle)
    local clamped = isClamped(vehicle)

    if not clamped then
--[[    local coords = GetEntityCoords(vehicle)
        local boneIndex = GetEntityBoneIndexByName(vehicle, "wheel_lf")
        
        local clamp = CreateObject(clampModel, coords.x, coords.y, coords.z, true, true, true)

        local offsetX = 0.0
        local offsetY = 0.0
        local offsetZ = 0.0

        AttachEntityToEntity(clamp, vehicle, boneIndex, offsetX, offsetY, offsetZ, 0.0, 0.0, 0.0, true, true, false, false, 1, true)
        
        SetEntityAsMissionEntity(clamp, true, true)
        FreezeEntityPosition(clamp, true)

        Entity(vehicle).state:set('clampEntity', NetworkGetNetworkIdFromEntity(clamp), true)
]]

        toggleClamp(vehicle, true)
    end
end

local function removeClampFromVehicle(vehicle)
    local networkId = Entity(vehicle).state.clampEntity
    local clampEntity = NetworkGetEntityFromNetworkId(networkId)

    if clampEntity and DoesEntityExist(clampEntity) then
        DeleteEntity(clampEntity)

        Entity(vehicle).state:set('clampEntity', nil, true)
    end

    toggleClamp(vehicle, false)
end

lib.onCache('vehicle', function(value)
    if value then
        local clampStatus = isClamped(value)
        
        if clampStatus then
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Tundub, et sõidukile on paigaldatud kand.')

            if cache.seat == -1 then
                SetVehicleEngineOn(value, false, false, true)
                SetVehicleUndriveable(value, true)
            end
        end
    end
end)

lib.onCache('seat', function(value)
    if value and value == -1 then
        local vehicle = cache.vehicle
        
        if vehicle and DoesEntityExist(vehicle) then
            local clampStatus = isClamped(vehicle)

            if clampStatus then
                SetVehicleEngineOn(vehicle, false, false, true)
                SetVehicleUndriveable(vehicle, true)
            end
        end
    end
end)

exports.ox_target:addGlobalVehicle({
	{
		name = 'policeClamp',
		distance = 2.0,
		icon = 'fa-solid fa-hand',
		label = 'Paigalda kand',
        items = 'vehicle_clamp',
        canInteract = function(entity)
            return not cache.vehicle and (KKF.PlayerData.job.name == 'police' and KKF.PlayerData.job.onDuty) and not isClamped(entity)
        end,
        onSelect = function(data)
			local progress = exports['kk-taskbar']:startAction('place_clamp', 'Paigaldad kanda', 5000, 'fixing_a_ped', 'mini@repair', {freeze = false, controls = true})

            if progress then
                attachClampToVehicle(data.entity)
                TriggerServerEvent('KKF.Player.RemoveItem', 'vehicle_clamp', 1)
            end
        end 
	},

    {
		name = 'policeClamp',
		distance = 2.0,
		icon = 'fa-solid fa-hand',
		label = 'Eemalda kand',
        canInteract = function(entity)
            return not cache.vehicle and (KKF.PlayerData.job.name == 'police' and KKF.PlayerData.job.onDuty) and isClamped(entity)
        end,
        onSelect = function(data)
            local progress = exports['kk-taskbar']:startAction('remove_clamp', 'Eemaldad kanda', 5000, 'fixing_a_ped', 'mini@repair', {freeze = false, controls = true})

            if progress then
                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Kand purunes eemaldamise käigus!')
                removeClampFromVehicle(data.entity)
            end
        end 
	}
})