local groups = {}
local players = {}
local ox_inventory = exports.ox_inventory

lib.callback.register('kk-gopostal:recieveData', function(source)
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

RegisterNetEvent('kk-gopostal:server:createGroup', function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if players[xPlayer.identifier] then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Te kuulute juba gruppi!')
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

RegisterNetEvent('kk-gopostal:server:joinGroup', function(groupId)
    local xPlayer = ESX.GetPlayerFromId(source)

    if players[xPlayer.identifier] then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Te kuulute juba gruppi!')
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
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'success', 'Olete grupiga liitunud!')
    else
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Grupi kood on vale!')
    end
end)

RegisterNetEvent('kk-gopostal:server:removeMember', function(targetIdentifier)
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
            TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Teil pole õigust seda teha!')
        end
    else
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Te ei kuulu ühtegi gruppi!')
    end
end)

RegisterNetEvent('kk-gopostal:server:deleteGroup', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local groupId = players[xPlayer.identifier]

    if groupId then
        local group = groups[groupId]
        if group and group.owner == xPlayer.identifier then
            for _, member in ipairs(group.members) do
                players[member] = nil
                local memberPlayer = ESX.GetPlayerFromIdentifier(member)
                if memberPlayer then
                    TriggerClientEvent('KKF.UI.ShowNotification', memberPlayer.source, 'error', 'Grupp on kustutatud!')
                    TriggerClientEvent('kk-gopostal:client:clearJob', memberPlayer.source, group.owner == member)
                end
            end

            groups[groupId] = nil
            TriggerClientEvent('KKF.UI.ShowNotification', source, 'success', 'Grupp on lõpetatud!')
        else
            TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Teil pole õigust seda teha!')
        end
    else
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Te ei kuulu ühtegi gruppi!')
    end
end)


RegisterNetEvent('kk-gopostal:server:startJob', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local groupId = players[xPlayer.identifier]

    if groupId then
        local group = groups[groupId]
        if group and group.owner == xPlayer.identifier then
            if not group.active then

                local vehicleSpawnIndex = math.random(1, #cfg.vehicles)
                local vehicleSpawn = cfg.vehicles[vehicleSpawnIndex]

                local vehicle = CreateVehicle('boxville', vehicleSpawn.x, vehicleSpawn.y, vehicleSpawn.z, vehicleSpawn.heading, true, false)
                local plate = 'POST' .. math.random(100, 999)
                SetVehicleNumberPlateText(vehicle, plate)
                
                while not DoesEntityExist(vehicle) do 
                    Wait(50) 
                end
                
                local netId = NetworkGetNetworkIdFromEntity(vehicle)
    

                local locationId = math.random(1, #cfg.zones)
                group.active = true
                group.location = locationId
                group.pointsDone = 0
                group.pointsMax = math.random(cfg.zones[locationId].points.min, cfg.zones[locationId].points.max)

                for _, member in ipairs(group.members) do
                    local memberPlayer = ESX.GetPlayerFromIdentifier(member)
                    if memberPlayer then
                        TriggerClientEvent('kk-gopostal:client:startJob', memberPlayer.source, {
                            vehicle = netId,
                            plate = GetVehicleNumberPlateText(vehicle),
                            location = locationId,
                            pointsDone = 0,
                            pointsMax = group.pointsMax
                        })
                    end
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Töö on juba aktiivne!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Teil pole õigust seda teha!')
        end
    else
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Te ei kuulu ühtegi gruppi!')
    end
end)

lib.callback.register('kk-gopostal:requestMembers', function(source)
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

lib.callback.register('kk-gopostal:canDeliver', function(source, coords)
    local xPlayer = ESX.GetPlayerFromId(source)
    local groupId = players[xPlayer.identifier]

    if groupId then
        local group = groups[groupId]
        if group and group.active then
            if group.pointsDone >= group.pointsMax then
                return false, 'Kõik tarned on juba tehtud!'
            end

            if not group.collected then
                group.collected = {}
            end
            local pointKey = tostring(coords.x) .. "_" .. tostring(coords.y)

            if group.collected[pointKey] then
                return false, 'See punkt on juba täidetud!'
            end
            group.collected[pointKey] = true

            return true, 'Tarnitud edukalt!'
        end
    end

    return false, 'Te ei ole osa grupist!'
end)



lib.callback.register('kk-gopostal:givePack', function(source, coords, locationId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local groupId = players[xPlayer.identifier]

    if groupId then
        local group = groups[groupId]
        if group and group.active then
            group.pointsDone = group.pointsDone + 1

            for _, member in ipairs(group.members) do
                local memberPlayer = ESX.GetPlayerFromIdentifier(member)
                if memberPlayer then
                    TriggerClientEvent('kk-gopostal:client:updateData', memberPlayer.source, group)
                end
            end

            if group.pointsDone >= group.pointsMax then
                for _, member in ipairs(group.members) do
                    local memberPlayer = ESX.GetPlayerFromIdentifier(member)
                    if memberPlayer then
                        local randomreward = cfg.prize
                        ox_inventory:AddItem(memberPlayer.source, 'money', randomreward)

                        TriggerClientEvent('KKF.UI.ShowNotification', memberPlayer.source, 'success', 'Kõik ajalehed on tarnitud! Uus töökoht on valmis. Teenisid ' .. randomreward.. '$' )
                    end
                end

                group.collected = {}

                local newLocationId = math.random(1, #cfg.zones)
                group.location = newLocationId
                group.pointsDone = 0
                group.pointsMax = math.random(cfg.zones[newLocationId].points.min, cfg.zones[newLocationId].points.max)

                for _, member in ipairs(group.members) do
                    local memberPlayer = ESX.GetPlayerFromIdentifier(member)
                    if memberPlayer then
                        TriggerClientEvent('kk-gopostal:client:newJob', memberPlayer.source, {
                            location = newLocationId,
                            pointsDone = 0,
                            pointsMax = group.pointsMax
                        })
                        TriggerClientEvent('kk-gopostal:client:updateData', memberPlayer.source, group)
                    end
                end
            end

            return true
        end
    end

    return false
end)


