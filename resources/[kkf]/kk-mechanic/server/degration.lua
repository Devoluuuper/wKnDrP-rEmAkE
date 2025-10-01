local degradationComponents = {
    "fuel_injector",
    "radiator",
    "axle",
    "transmission",
    "electronics",
    "brakes",
    "clutch",
    "tire"
}

function updateDegradationInDatabase(plate, component, amount)
    local query = "UPDATE user_vehicles SET degradation = ? WHERE plate = ?"
    local newDegradation = {}

    MySQL.Async.fetchScalar('SELECT degradation FROM user_vehicles WHERE plate = ?', {plate}, function(oldDegradationJson)
        if oldDegradationJson then
            local oldDegradation = json.decode(oldDegradationJson)

            for key, value in pairs(oldDegradation) do
                if key == component then
                    newDegradation[key] = {value[1] - amount, value[2]}
                else
                    newDegradation[key] = value
                end
            end

            local newDegradationJson = json.encode(newDegradation)

            MySQL.Async.execute(query, {newDegradationJson, plate}, function(rowsChanged)
                -- print("Updated degradation for plate:", plate, "Component:", component, "Amount:", amount, "Rows Changed:", rowsChanged)
            end)
        else
            -- print("Vehicle with plate", plate, "not found in database. Ignoring update.")
        end
    end)
end



RegisterServerEvent('kk-mechanic:server:degrade')
AddEventHandler('kk-mechanic:server:degrade', function(vehicleNetId)
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    if vehicle then
        local plate = GetVehicleNumberPlateText(vehicle)
        if plate then
            local randomComponent = degradationComponents[math.random(#degradationComponents)]
            local degradationAmount = math.random(1, 3)
            updateDegradationInDatabase(plate, randomComponent, degradationAmount)
        else
            -- print("Error: Could not get plate from vehicle for networkId:", vehicleNetId)
        end
    else
        -- print("Error: Vehicle not found for networkId:", vehicleNetId)
    end
end)

RegisterServerEvent('kk-mechanic:server:fixVehicle')
AddEventHandler('kk-mechanic:server:fixVehicle', function(vehicleNetId, item)
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    if vehicle then
        local plate = GetVehicleNumberPlateText(vehicle)
        local query = "UPDATE user_vehicles SET degradation = ? WHERE plate = ?"
        
        MySQL.Async.fetchScalar('SELECT degradation FROM user_vehicles WHERE plate = ?', {plate}, function(oldDegradationJson)
            local oldDegradation = json.decode(oldDegradationJson)
            
            oldDegradation[item][1] = 100.0

            local newDegradationJson = json.encode(oldDegradation)

            MySQL.Async.execute(query, {newDegradationJson, plate}, function(rowsChanged)
                -- print("Updated component item to 100 for plate:", plate, "Component:", item, "Rows Changed:", rowsChanged)
            end)
        end)
    end
end)
