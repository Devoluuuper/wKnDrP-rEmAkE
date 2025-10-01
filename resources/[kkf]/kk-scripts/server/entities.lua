lib.callback.register('KKF.Vehicle.SpawnOwnedVehicle', function(source, plate, coords)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        MySQL.Async.fetchAll('SELECT * FROM user_vehicles WHERE plate = @plate AND owner = @owner', {
            ['@plate'] = plate,
            ['@owner'] = xPlayer.identifier
        }, function(result)
            if result[1] then
                local vehicleData = json.decode(result[1].vehicle)
                vehicleData.plate = result[1].plate
                local model = vehicleData.model
                local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, coords.h or 0, true, true)

                while not DoesEntityExist(vehicle) do 
                    Wait(50) 
                end

                local veh = NetworkGetNetworkIdFromEntity(vehicle)
            
                MySQL.Async.execute('UPDATE user_vehicles SET stored = @stored WHERE plate = @plate', {['@stored'] = 0, ['@plate'] = plate})
                MySQL.Async.execute('UPDATE user_vehicles SET location = NULL WHERE plate = ?', { plate })

                TriggerClientEvent('KKF.SetVehicleProperties', NetworkGetEntityOwner(vehicle), veh, json.encode(vehicleData))
                TriggerClientEvent('kk-scripts:client:newKey', xPlayer.source, plate)
                
                returnable = veh
            else
                local identifier = "society_" .. xPlayer.job.name
                
                MySQL.Async.fetchAll('SELECT * FROM user_vehicles WHERE plate = @plate AND owner = @owner', {
                    ['@plate'] = plate, 
                    ['@owner'] = identifier
                }, function(result2)
                    if result2[1] then
                        local vehicleData = json.decode(result2[1].vehicle)
                        vehicleData.plate = result2[1].plate
                        local model = vehicleData.model 
                        local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, coords.h or 0, true, true)
                        
                        while not DoesEntityExist(vehicle) do 
                            Wait(50) 
                        end

                        local veh = NetworkGetNetworkIdFromEntity(vehicle)
                    
                        MySQL.Async.execute('UPDATE user_vehicles SET stored = @stored WHERE plate = @plate', {['@stored'] = 0, ['@plate'] = plate})

                        TriggerClientEvent('KKF.SetVehicleProperties', NetworkGetEntityOwner(vehicle), veh, json.encode(vehicleData))
                        TriggerClientEvent('kk-scripts:client:newKey', xPlayer.source, plate)

                        exports['kk-scripts']:sendSocietyLog(xPlayer.source, 'SÕIDUKI VÄLJASTAMINE', 'Sõiduki REG.NR ' .. plate .. '; Kere: ' .. math.floor(vehicleData.bodyHealth or 1000) .. '; Mootor: ' .. math.floor(vehicleData.engineHealth or 1000) .. '; Kütus: ' .. math.floor(vehicleData.fuelLevel or 100) .. ';')

                        returnable = veh
                    else
                        returnable = false
                    end
                end)
            end
        end)
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

lib.callback.register('KKF.Vehicle.DeleteOwnedVehicle', function(source, props, location, faction)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        local playerPed = GetPlayerPed(src); local vehicle = GetVehiclePedIsIn(playerPed, false); local plate = props.plate

        if GetVehicleNumberPlateText(vehicle) == plate then
            MySQL.Async.fetchAll('SELECT * FROM user_vehicles WHERE plate = @plate AND owner = @owner', {
                ['@plate'] = plate, 
                ['@owner'] = xPlayer.identifier
            }, function(result)
                -- print('Omanik: '..tostring(result[1]))
                if result[1] then
                    if DoesEntityExist(vehicle) then
                        if location then
                            TriggerClientEvent('kk-scripts:client:removeKey', xPlayer.source, GetVehicleNumberPlateText(vehicle))
                            DeleteEntity(vehicle)
                            MySQL.Async.execute('UPDATE user_vehicles SET fakeplate = NULL, stored = @stored, vehicle = @vehicle, ownername = @ownername, location = @location WHERE plate = @plate', {['@stored'] = 1, ['@vehicle'] = json.encode(props), ['@plate'] = plate, ['@ownername'] = xPlayer.name, ['@location'] = location})
                            returnable = true
                        else
                            returnable = false
                        end
                    else
                        returnable = false
                    end
                else
                    MySQL.Async.fetchAll('SELECT * FROM user_vehicles WHERE fakeplate = @plate AND owner = @owner', {
                        ['@plate'] = plate, 
                        ['@owner'] = xPlayer.identifier
                    }, function(result2)
                        -- print('Kas on fake plate: '..tostring(result2[1]))
                        if result2[1] then
                            if DoesEntityExist(vehicle) then
                                if location then
                                    TriggerClientEvent('kk-scripts:client:removeKey', xPlayer.source, GetVehicleNumberPlateText(vehicle))
                                    DeleteEntity(vehicle)
                                    MySQL.Async.execute('UPDATE user_vehicles SET fakeplate = NULL, stored = @stored, vehicle = @vehicle, ownername = @ownername, location = @location WHERE fakeplate = @plate', {['@stored'] = 1, ['@vehicle'] = json.encode(props), ['@plate'] = plate, ['@ownername'] = xPlayer.name, ['@location'] = location})
                                    returnable = true
                                else
                                    returnable = false
                                end
                            else
                                returnable = false
                            end
                        else
                            if xPlayer.job.name == faction then
                                local identifier = "society_"..faction
                                -- print('Fraktsioon: '.. identifier)

                                MySQL.Async.fetchAll('SELECT * FROM user_vehicles WHERE plate = @plate AND owner = @owner', {
                                    ['@plate'] = plate, 
                                    ['@owner'] = identifier
                                }, function(result3)
                                    if result3[1] then
                                        -- print('Jah?: '..tostring(result3[1]))
                                        if DoesEntityExist(vehicle) then
                                            TriggerClientEvent('kk-scripts:client:removeKey', xPlayer.source, GetVehicleNumberPlateText(vehicle))
                                            DeleteEntity(vehicle)
                                            MySQL.Async.execute('UPDATE user_vehicles SET fakeplate = NULL, stored = @stored, vehicle = @vehicle, location = @location WHERE plate = @plate', {['@stored'] = 1, ['@vehicle'] = json.encode(props), ['@plate'] = plate, ['@location'] = location})
                                            exports['kk-scripts']:sendSocietyLog(xPlayer.source, 'SÕIDUKI HOIUSTAMINE', 'Sõiduki REG.NR ' .. plate .. '; Kere: ' .. math.floor(props.bodyHealth or 1000) .. '; Mootor: ' .. math.floor(props.engineHealth or 1000) .. '; Kütus: ' .. math.floor(props.fuelLevel or 100) .. ';')
                                            returnable = true
                                        else
                                            returnable = false
                                        end
                                    else
                                        MySQL.Async.fetchAll('SELECT * FROM user_vehicles WHERE fakeplate = @plate AND owner = @owner', {
                                            ['@plate'] = plate, 
                                            ['@owner'] = identifier
                                        }, function(result4)
                                            if result4[1] then
                                                if DoesEntityExist(vehicle) then
                                                    TriggerClientEvent('kk-scripts:client:removeKey', xPlayer.source, GetVehicleNumberPlateText(vehicle))
                                                    DeleteEntity(vehicle)
                                                    MySQL.Async.execute('UPDATE user_vehicles SET fakeplate = NULL, stored = @stored, vehicle = @vehicle, location = @location WHERE fakeplate = @plate', {['@stored'] = 1, ['@vehicle'] = json.encode(props), ['@plate'] = plate, ['@location'] = location})
                                                    exports['kk-scripts']:sendSocietyLog(xPlayer.source, 'SÕIDUKI HOIUSTAMINE', 'Sõiduki REG.NR ' .. plate .. '; Kere: ' .. math.floor(props.bodyHealth or 1000) .. '; Mootor: ' .. math.floor(props.engineHealth or 1000) .. '; Kütus: ' .. math.floor(props.fuelLevel or 100) .. ';')
                                                    returnable = true
                                                else
                                                    returnable = false
                                                end
                                            else
                                                returnable = false
                                            end
                                        end)
                                    end
                                end)
                            else
                                returnable = false
                            end
                        end
                    end)
                end
            end)
        else
            returnable = false
        end
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

lib.callback.register('KKF.Entity.Delete', function(source, networkId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        local entity = NetworkGetEntityFromNetworkId(networkId)

        if DoesEntityExist(entity) then
            DeleteEntity(entity)
            returnable = true
        else
            returnable = false
        end
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

lib.callback.register('KKF.Entity.SpawnObject', function(source, model, coords, heading)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if type(model) == 'string' then model = GetHashKey(model) end
        local object = CreateObject(model, coords, true, false, false)
        
        while not DoesEntityExist(object) do 
            Wait(50) 
        end

        SetEntityHeading(object, heading or 0)

        returnable = NetworkGetNetworkIdFromEntity(object)
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

lib.callback.register('KKF.Vehicle.SpawnVehicle', function(source, model, coords)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if type(model) == 'string' then model = GetHashKey(model) end
        local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w or 0, true, true)

        while not DoesEntityExist(vehicle) do 
            Wait(50) 
        end

        local veh = NetworkGetNetworkIdFromEntity(vehicle)

        returnable = veh
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

lib.callback.register('KKF.Entity.SpawnPed', function(source, model, coords, heading)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if type(model) == 'string' then model = GetHashKey(model) end
        local ped = CreatePed(1, model, coords, heading, true, false)
        
        while not DoesEntityExist(ped) do 
            Wait(50) 
        end

        returnable = NetworkGetNetworkIdFromEntity(ped)
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

--------------------------------------------------------------------------------------------------------------------------------------------------------

RegisterCommand('transfervehicle', function(source, args)
	myself = source
	other = args[1]
	
	if(GetPlayerName(tonumber(args[1])))then
			
	else
        TriggerClientEvent("chatMessage", source, "SÜSTEEM", 1,  "Isik ei viibi hetkel linnas.")
		return
	end
	
	
	local plate1 = args[2]
	local plate2 = args[3]
	local plate3 = args[4]
	local plate4 = args[5]
	
  
	if plate1 ~= nil then plate01 = plate1 else plate01 = "" end
	if plate2 ~= nil then plate02 = plate2 else plate02 = "" end
	if plate3 ~= nil then plate03 = plate3 else plate03 = "" end
	if plate4 ~= nil then plate04 = plate4 else plate04 = "" end
  
  
	local plate = (plate01 .. " " .. plate02 .. " " .. plate03 .. " " .. plate04)

	
	mySteam = ESX.GetPlayerFromId(source).identifier
	myID = ESX.GetPlayerFromId(source).identifier
	myName = ESX.GetPlayerFromId(source).name

	targetSteamName = ESX.GetPlayerFromId(args[1]).name
	targetSteam = ESX.GetPlayerFromId(args[1]).identifier
	
	MySQL.Async.fetchAll(
        'SELECT * FROM user_vehicles WHERE plate = @plate',
        {
            ['@plate'] = plate
        },
        function(result)
            if result[1] ~= nil then
                local playerName = ESX.GetPlayerFromIdentifier(result[1].owner).identifier
				local pName = ESX.GetPlayerFromIdentifier(result[1].owner).name
				CarOwner = playerName
				if myID == CarOwner then
					data = {}
                    TriggerClientEvent('kk-scripts:client:newKey', other, plate)
                    TriggerClientEvent('kk-scripts:client:removeKey', source, plate)

                    TriggerClientEvent("chatMessage", other, "SÜSTEEM", 2, "Sõiduk numbrimärgiga "..plate.." märgiti teie nimele "..myName.." poolt.")

					MySQL.Sync.execute("UPDATE user_vehicles SET owner=@owner WHERE plate=@plate", {['@owner'] = targetSteam, ['@plate'] = plate})
                    MySQL.Sync.execute("UPDATE user_vehicles SET ownername=@name WHERE plate=@plate", {['@name'] = targetSteamName, ['@plate'] = plate})

                    TriggerClientEvent("chatMessage", source, "SÜSTEEM", 2, "Kirjutasite sõiduki numbrimärgiga "..plate.." "..targetSteamName.." nimele.")
                    exports['kk-scripts']:sendLog(playerName, 'SÕIDUKID', 'Kirjutas sõiduki REG.NR ' .. plate .. ' targeti nimele.', targetSteam)
				else
                    TriggerClientEvent("chatMessage", source, "SÜSTEEM", 1, "Te ei oma sõidukit numbrimärgiga "..plate.."!")
				end
			else
                TriggerClientEvent("chatMessage", source, "SÜSTEEM", 1,  "Sõiduk numbrimärgiga "..plate.." ei eksisteeri andmebaasis või on valesti kirjutatud.")
            end
		
        end
    )
end)
