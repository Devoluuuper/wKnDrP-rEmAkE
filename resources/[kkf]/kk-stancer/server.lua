lib.callback.register('kk-stancer:updateVehicle', function(source, networkId, data)
    local xPlayer = KKF.GetPlayerFromId(source)
    local returnable = nil
    local vehicle = NetworkGetEntityFromNetworkId(networkId)

    if vehicle then
        local plate = GetVehicleNumberPlateText(vehicle)
        
        if plate then
            local jsonData = json.encode(data)
            MySQL.Async.execute('UPDATE user_vehicles SET stance_data = @stanceData WHERE plate = @plate', {
                ['@stanceData'] = jsonData,
                ['@plate'] = plate
            }, function(rowsChanged)
                if rowsChanged > 0 then
                    returnable = true
                else
                    returnable = false
                end
            end)
        else
            returnable = false
        end
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end
    return returnable
end)
