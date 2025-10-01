local groups = {}
local players = {}
local ox_inventory = exports.ox_inventory

lib.callback.register('kk-garbage:recieveData', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if players[xPlayer.identifier] then
        local groupId = players[xPlayer.identifier]
        local group = groups[groupId]
        if group then
            return {
                group = group,
                owner = group.owner == xPlayer.identifier
            }
        end
    end

    return {}
end)

RegisterNetEvent('kk-garbage:server:createGroup', function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if players[xPlayer.identifier] then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Kuulud juba gruppi!')
        return
    end

    local groupId = tostring(math.random(10000, 99999))
    groups[groupId] = {
        owner = xPlayer.identifier,
        members = {xPlayer.identifier},
        active = false
    }

    players[xPlayer.identifier] = groupId
    TriggerClientEvent('KKF.UI.ShowNotification', source, 'success', 'Grupp loodud! Kood: ' .. groupId)
end)

RegisterNetEvent('kk-garbage:server:joinGroup', function(groupId)
    local xPlayer = ESX.GetPlayerFromId(source)

    if players[xPlayer.identifier] then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Kuulud juba gruppi!')
        return
    end

    local group = groups[groupId]
    if group then
        if #group.members >= 2 then
            TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Grupp on juba täis!')
            return
        end

        table.insert(group.members, xPlayer.identifier)
        players[xPlayer.identifier] = groupId
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'success', 'Liitusid grupiga!')
    else
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Grupi kood on vale!')
    end
end)

RegisterNetEvent('kk-garbage:server:removeMember', function(targetIdentifier)
    local xPlayer = ESX.GetPlayerFromId(source)
    local groupId = players[xPlayer.identifier]

    if groupId then
        local group = groups[groupId]
        if group and group.owner == xPlayer.identifier then
            for i, member in ipairs(group.members) do
                if member == targetIdentifier then
                    table.remove(group.members, i)
                    players[targetIdentifier] = nil

                    local targetPlayer = ESX.GetPlayerFromIdentifier(targetIdentifier)
                    if targetPlayer then
                        TriggerClientEvent('KKF.UI.ShowNotification', targetPlayer.source, 'error', 'Teid eemaldati grupist!')
                    end

                    break
                end
            end

            TriggerClientEvent('KKF.UI.ShowNotification', source, 'success', 'Liige eemaldatud grupist!')
        else
            TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Ei saa seda teha!')
        end
    else
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Ei kuulu ühtegi gruppi!')
    end
end)

RegisterNetEvent('kk-garbage:server:deleteGroup', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local groupId = players[xPlayer.identifier]

    if groupId then
        local group = groups[groupId]
        if group and group.owner == xPlayer.identifier then
            for _, member in ipairs(group.members) do
                players[member] = nil
                local memberPlayer = ESX.GetPlayerFromIdentifier(member)
                if memberPlayer then
                    TriggerClientEvent('KKF.UI.ShowNotification', memberPlayer.source, 'success', 'Grupp on kustutatud!')
                    TriggerClientEvent('kk-garbage:client:clearJob', memberPlayer.source, group.owner == member)
                end
            end

            groups[groupId] = nil
        else
            TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Ei saa seda teha!')
        end
    else
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Ei kuulu ühtegi gruppi!')
    end
end)


RegisterNetEvent('kk-garbage:server:startJob', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local groupId = players[xPlayer.identifier]

    if groupId then
        local group = groups[groupId]
        if group and group.owner == xPlayer.identifier then
            if not group.active then

                local vehicleSpawnIndex = math.random(1, #cfg.vehicles)
                local vehicleSpawn = cfg.vehicles[vehicleSpawnIndex]

                local vehicle = CreateVehicle('trash2', vehicleSpawn.x, vehicleSpawn.y, vehicleSpawn.z, vehicleSpawn.heading, true, false)
                local plate = 'GARB' .. math.random(100, 999)
                SetVehicleNumberPlateText(vehicle, plate)
                
                while not DoesEntityExist(vehicle) do 
                    Wait(50) 
                end
                
                local netId = NetworkGetNetworkIdFromEntity(vehicle)
    

                local locationId = math.random(1, #cfg.zones)
                group.active = true
                group.location = locationId
                group.binsDone = 0
                group.binsMax = math.random(cfg.zones[locationId].bins.min, cfg.zones[locationId].bins.max)

                for _, member in ipairs(group.members) do
                    local memberPlayer = ESX.GetPlayerFromIdentifier(member)
                    if memberPlayer then
                        TriggerClientEvent('kk-garbage:client:startJob', memberPlayer.source, {
                            vehicle = netId,
                            plate = GetVehicleNumberPlateText(vehicle),
                            location = locationId,
                            binsDone = 0,
                            binsMax = group.binsMax
                        })
                    end
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Töö on juba aktiivne!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Pole piisavlt õigusi!')
        end
    else
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Ei kuulu ühtegi gruppi!')
    end
end)

lib.callback.register('kk-garbage:requestMembers', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local groupId = players[xPlayer.identifier]

    if groupId then
        local group = groups[groupId]
        if group then
            local members = {}
            for _, member in ipairs(group.members) do
                local memberPlayer = ESX.GetPlayerFromIdentifier(member)
                if memberPlayer then
                    table.insert(members, {
                        identifier = member,
                        name = memberPlayer.getName()
                    })
                end
            end
            return members
        end
    end

    return {}
end)


lib.callback.register('kk-garbage:collectTrash', function(source, coords)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end

    local groupId = players[xPlayer.identifier]
    if not groupId then return false end

    local group = groups[groupId]
    if group and group.active then
        if group.binsDone >= group.binsMax then
            return false
        end

        group.collected = group.collected or {}
        local pointKey = string.format('%f_%f', coords.x, coords.y)

        if group.collected[pointKey] then
            return false
        end

        group.collected[pointKey] = true
        return true
    end

    return false
end)

lib.callback.register('kk-garbage:throwBag', function(source, locationId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end

    local groupId = players[xPlayer.identifier]
    if not groupId then return false end

    local group = groups[groupId]
    if group and group.active then
        if group.binsDone < group.binsMax then
            group.binsDone = group.binsDone + 1

            for _, member in ipairs(group.members) do
                local memberPlayer = ESX.GetPlayerFromIdentifier(member)
                if memberPlayer then
                    TriggerClientEvent('kk-garbage:client:updateData', memberPlayer.source, group)
                end
            end
            return true
        else
            TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Ei mahu rohkem!')
        end
    end

    return false
end)

lib.callback.register('kk-garbage:deliverGarbage', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end

    local groupId = players[xPlayer.identifier]
    if not groupId then return false end

    local group = groups[groupId]
    if group and group.active then
        if group.binsDone >= group.binsMax then
            for _, member in ipairs(group.members) do
                local memberPlayer = ESX.GetPlayerFromIdentifier(member)
                if memberPlayer then
                    local randomReward = cfg.prize
                    ox_inventory:AddItem(memberPlayer.source, 'money', randomReward)

                    TriggerClientEvent('KKF.UI.ShowNotification', memberPlayer.source, 'success',
                        'Prügi maha laetud! Uus töökoht on valmis. Teenisid ' .. randomReward .. '$')
                end
            end

            group.collected = {}
            local newLocationId = math.random(1, #cfg.zones)
            group.location = newLocationId
            group.binsDone = 0
            group.binsMax = math.random(cfg.zones[newLocationId].bins.min, cfg.zones[newLocationId].bins.max)

            for _, member in ipairs(group.members) do
                local memberPlayer = ESX.GetPlayerFromIdentifier(member)
                if memberPlayer then
                    TriggerClientEvent('kk-garbage:client:newJob', memberPlayer.source, {
                        location = newLocationId,
                        binsDone = 0,
                        binsMax = group.binsMax
                    })
                    TriggerClientEvent('kk-garbage:client:updateData', memberPlayer.source, group)
                end
            end
            return true
        end
    end

    return false
end)
