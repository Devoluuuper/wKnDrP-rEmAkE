RegisterNetEvent('kk-scripts:client:setOutVehicle', function(coords)
    ClearPedTasksImmediately(cache.ped)
    TaskLeaveVehicle(cache.ped, cache.vehicle, 256)
    SetEntityCoords(cache.ped, coords)

    if LocalPlayer.state.isCuffed ~= 'none' then
        SetTimeout(1000, function()
            lib.requestAnimDict('mp_arresting')
            TaskPlayAnim(cache.ped, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
        end)
    end

    if LocalPlayer.state.isDead then
        SetTimeout(1000, function()
            lib.requestAnimDict('dead')
            TaskPlayAnim(cache.ped, 'dead', 'dead_a', 1.0, 1.0, -1, 1, 0, 0, 0, 0)
        end)
    end
end)

RegisterNetEvent('kk-scripts:client:setInVehicle', function(networkId)
    local vehicleHandle = NetworkGetEntityFromNetworkId(networkId)

    if vehicleHandle ~= nil then
        if GetEntityType(vehicleHandle) == 2 then
            TriggerEvent('kk-ambulance:client:sleepAnimations')
            Wait(1000)

            while LocalPlayer.state.isEscorted do
                Wait(100)
            end

            for i = 1, GetVehicleMaxNumberOfPassengers(vehicleHandle) do
                if IsVehicleSeatFree(vehicleHandle, i) then
                    SetPedIntoVehicle(cache.ped, vehicleHandle, i)

                    SetTimeout(500, function()
                        TriggerEvent('kk-scripts:client:setSeatbelt')
                    end)

                    return true
                end
            end

            if IsVehicleSeatFree(vehicleHandle, 0) then
                SetPedIntoVehicle(cache.ped, vehicleHandle, 0)

                SetTimeout(500, function()
                    TriggerEvent('kk-scripts:client:setSeatbelt')
                end)
            end
        end
    end
end)

exports.ox_target:addGlobalVehicle({
	{
		name = 'putInVehicle',
		distance = 2.0,
		icon = 'fa-solid fa-user-plus',
		label = 'Pane sõidukisse',
		onSelect = function(data)
            if not cache.vehicle then
                local playerId, playerPed, playerCoords = lib.getClosestPlayer(GetEntityCoords(cache.ped), 3.0, false)
        
                if DoesEntityExist(playerPed) then
                    local targetId = GetPlayerServerId(playerId)
        
                    if Player(targetId).state.isCuffed ~= 'none' or Player(targetId).state.isDead then
                        if exports['kk-scripts']:inCarry() then
                            ExecuteCommand('carry')
                        end

                        TriggerServerEvent('kk-scripts:server:putInVehicle', targetId, NetworkGetNetworkIdFromEntity(data.entity))
                    else
                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Seda mängijat ei saa autosse panna!') 
                    end
                else
                    TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ühtegi isikut ei ole läheduses.')
                end
            end 
		end
	},

    {
		name = 'takeFromVehicle',
		distance = 2.0,
		icon = 'fa-solid fa-user-minus',
		label = 'Võta sõidukist',
		onSelect = function(data)
            if not cache.vehicle then
                local playerId, playerPed, playerCoords = lib.getClosestPlayer(GetEntityCoords(cache.ped), 3.0, false)
        
                if DoesEntityExist(playerPed) then
                    local targetId = GetPlayerServerId(playerId)
        
                    if Player(targetId).state.isCuffed ~= 'none' or Player(targetId).state.isDead then
                        TriggerServerEvent('kk-scripts:server:takeOutVehicle', targetId, GetEntityCoords(cache.ped))
                    else
                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Seda mängijat ei saa autost niisama võtta!') 
                    end
                else
                    TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ühtegi isikut ei ole läheduses.')
                end
            end
		end
	}
})