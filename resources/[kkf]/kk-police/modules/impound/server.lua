lib.callback.register('kk-police:recieveImpounded', function(source)
    local xPlayer = KKF.GetPlayerFromId(source)
    
    if not xPlayer or xPlayer.job.name ~= 'police' or not xPlayer.job.onDuty then 
        return nil 
    end

    local returnable = {}

    local impoundedVehicles = MySQL.query.await('SELECT * FROM user_vehicles WHERE police_impound = 1')

    if impoundedVehicles and #impoundedVehicles > 0 then
        for _, vehicle in ipairs(impoundedVehicles) do
            local impoundUntil = vehicle.impound_until
            local impoundDate = vehicle.impound_date
            if impoundUntil and impoundDate then
                if impoundUntil > 10000000000 then
                    impoundUntil = impoundUntil / 1000
                end
                if impoundDate > 10000000000 then
                    impoundDate = impoundDate / 1000
                end

                local impoundDuration = impoundUntil - impoundDate

                local totalDaysImpounded = math.floor(impoundDuration / 86400)

                local impoundDateFormatted = os.date('%Y-%m-%d %H:%M:%S', impoundDate)
                local impoundUntilFormatted = os.date('%Y-%m-%d %H:%M:%S', impoundUntil)

                table.insert(returnable, {
                    vehicle = vehicle.vehicle,
                    plate = vehicle.plate,
                    model = vehicle.model,
                    date = impoundDateFormatted,
                    time = totalDaysImpounded,
                    enddate = impoundUntilFormatted
                })
            else
                print(('Invalid impound_until or impound_date for vehicle %s. Skipping calculation.'):format(vehicle.plate))
            end
        end

        return returnable
    else
        return nil
    end
end)



lib.callback.register('kk-police:recieveMyImpounded', function(source)
    local xPlayer = KKF.GetPlayerFromId(source)
    if not xPlayer then return nil end

    local pid = xPlayer.identifier
    local impoundedVehicles = MySQL.query.await('SELECT * FROM user_vehicles WHERE owner = ? AND police_impound = 1', {pid})

    if impoundedVehicles and #impoundedVehicles > 0 then
        local returnable = {}

        for _, vehicle in ipairs(impoundedVehicles) do
            local impoundDate = vehicle.impound_date
            local impoundUntil = vehicle.impound_until

            -- Convert to seconds if the values are in milliseconds
            if impoundDate and impoundDate > 10000000000 then
                impoundDate = impoundDate / 1000
            end
            if impoundUntil and impoundUntil > 10000000000 then
                impoundUntil = impoundUntil / 1000
            end

            if impoundDate and impoundUntil then
                -- Calculate duration and format dates
                local impoundDuration = impoundUntil - impoundDate
                local totalDaysImpounded = math.floor(impoundDuration / 86400)
                local impoundDateFormatted = os.date('%Y-%m-%d %H:%M:%S', impoundDate)
                local impoundUntilFormatted = os.date('%Y-%m-%d %H:%M:%S', impoundUntil)

                table.insert(returnable, {
                    vehicle = vehicle.vehicle,
                    plate = vehicle.plate,
                    model = vehicle.model,
                    nickname = vehicle.nickname,
                    date = impoundDateFormatted,
                    time = totalDaysImpounded,
                    enddate = impoundUntilFormatted
                })
            else
                print(('Invalid impound_date or impound_until for vehicle %s. Skipping.'):format(vehicle.plate))
            end
        end

        return returnable
    else
        return nil
    end
end)


lib.callback.register('kk-police:releaseImpounded', function(source, plate, spawnPoint)
    local xPlayer = KKF.GetPlayerFromId(source)

    if not xPlayer or xPlayer.job.name ~= 'police' then
        return false
    end

    local result = MySQL.single.await('SELECT * FROM user_vehicles WHERE plate = ? AND police_impound = 1', {plate})

    if not result then
        return false
    end

    local currentTimestamp = os.time()
    local impoundUntil = result.impound_until
    
    if impoundUntil > 10000000000 then
        impoundUntil = impoundUntil / 1000
    end

    if currentTimestamp < impoundUntil then
        TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, "error", 'Aeg pole veel möödas.')
        return false
    end

    MySQL.update.await('UPDATE user_vehicles SET police_impound = 0, impound_date = NULL, impound_until = NULL, impound_description = NULL WHERE plate = ?', {plate})

    local spawnLocation = spawnPoint
    local networkId = CreateVehicle(result.model, spawnLocation.x, spawnLocation.y, spawnLocation.z, spawnLocation.h, true, false)

    SetVehicleNumberPlateText(networkId, result.plate)
    return networkId
end)



lib.callback.register('kk-police:impoundVehicle', function(source, vehicleNetworkId, description, impoundTime, vehicleProps)
    local xPlayer = KKF.GetPlayerFromId(source)
    if not xPlayer or xPlayer.job.name ~= 'police' then return false end

    local entity = NetworkGetEntityFromNetworkId(vehicleNetworkId)
    if not DoesEntityExist(entity) then return false end

    local plate = GetVehicleNumberPlateText(entity)
    if not plate then return false end
    local vehicleData = MySQL.single.await('SELECT * FROM user_vehicles WHERE plate = ?', {plate})
    if not vehicleData then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Sõidukit ei leitud andmebaasist!')
        return false
    end

    local days = tonumber(impoundTime)
    local impoundUntil = (days > 0) and os.date('%Y-%m-%d %H:%M:%S', os.time() + (days * 86400)) or nil
    local impoundDate = os.date('%Y-%m-%d %H:%M:%S')

    local updateQuery = [[
        UPDATE user_vehicles
        SET police_impound = 1, impound_description = ?, impound_until = ?, impound_date = ?, vehicle = ?
        WHERE plate = ?
    ]]
    local success = MySQL.update.await(updateQuery, {description, impoundUntil, impoundDate, json.encode(vehicleProps), plate})
    if not success then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Teisaldamise salvestamine ebaõnnestus!')
        return false
    end

    DeleteEntity(entity)

    TriggerClientEvent('KKF.UI.ShowNotification', source, 'success', 'Sõiduk edukalt teisaldatud!')
    return true
end)




