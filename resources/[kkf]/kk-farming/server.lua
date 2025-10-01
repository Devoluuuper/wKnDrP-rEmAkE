local farms = {} -- Temporary table for farm data that resets on restart

-- Rent a farm
RegisterNetEvent('kk-farming:server:rentFarm', function(farmId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if not farms[farmId] then 
        farms[farmId] = { isRented = false, owner = nil, members = {}, plants = {} }
    end

    if farms[farmId].isRented then
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'See farm on juba renditud!')
        return
    end

    if xPlayer.getMoney() < cfg.farmPrice then
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Sul pole piisavalt raha!')
        return
    end

    xPlayer.removeMoney(cfg.farmPrice)

    farms[farmId].isRented = true
    farms[farmId].owner = xPlayer.identifier
    farms[farmId].members = {}

    TriggerClientEvent('kk-farming:client:giveAccess', src, farmId)
    TriggerClientEvent('KKF.UI.ShowNotification', src, 'success', 'Sa rentisid farmi #' .. farmId)
end)

-- Add a member
RegisterNetEvent('kk-farming:server:addMember', function(farmId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if farms[farmId] and farms[farmId].owner == xPlayer.identifier then
        TriggerClientEvent('kk-farming:client:addMemberMenu', src, farmId)
    else
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Sul pole õigusi farmi hallata!')
    end
end)

RegisterNetEvent('kk-farming:server:addMemberConfirm', function(farmId, targetServerId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if farms[farmId] and farms[farmId].owner == xPlayer.identifier then
        local targetPlayer = ESX.GetPlayerFromId(targetServerId)

        if targetPlayer then
            table.insert(farms[farmId].members, {
                identifier = targetPlayer.identifier,
                name = targetPlayer.getName()
            })

            TriggerClientEvent('KKF.UI.ShowNotification', src, 'success', ('Mängija "%s" lisatud farmi liikmeks.'):format(targetPlayer.getName()))

            TriggerClientEvent('KKF.UI.ShowNotification', targetServerId, 'info', ('Sind lisati farmi "%s".'):format(farmId))
        else
            TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Mängijat ei leitud!')
        end
    else
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Sul pole õigusi farmi hallata!')
    end
end)



-- Remove a member

RegisterNetEvent('kk-farming:server:removeMember', function(farmId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if farms[farmId] and farms[farmId].owner == xPlayer.identifier then
        local members = farms[farmId].members or {}
        TriggerClientEvent('kk-farming:client:removeMemberMenu', src, farmId, members)
    else
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Sul pole õigusi farmi hallata!')
    end
end)


RegisterNetEvent('kk-farming:server:removeMemberConfirm', function(farmId, memberIdentifier)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    -- Ensure the farm exists and the player is the owner
    if farms[farmId] and farms[farmId].owner == xPlayer.identifier then
        -- Find and remove the member
        for i, member in ipairs(farms[farmId].members) do
            if member.identifier == memberIdentifier then
                table.remove(farms[farmId].members, i)

                -- Notify the owner
                TriggerClientEvent('KKF.UI.ShowNotification', src, 'success', ('Liige "%s" on eemaldatud farmist.'):format(member.name))

                -- Notify the removed member if they are online
                local targetPlayer = ESX.GetPlayerFromIdentifier(memberIdentifier)
                if targetPlayer then
                    TriggerClientEvent('KKF.UI.ShowNotification', targetPlayer.source, 'info', 'Sind on eemaldatud farmist.')
                end

                return
            end
        end

        -- Member not found
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Liige ei leitud.')
    else
        -- Permission error
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Sul pole õigusi farmi hallata!')
    end
end)




RegisterNetEvent('kk-farming:server:placeSeed', function(data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    -- Decode the incoming data
    local farmId = data.farm
    local potId = data.id
    local seedItem = data.item

    -- Debug print for received data
    if cfg.debug then
        print(("[kk-farming] Planting seed: Player %s | Farm %d | Pot %d | Item %s"):format(src, farmId, potId, seedItem))
    end

    -- Check if the farm exists and if the player has permission
    if farms[farmId] and (farms[farmId].owner == xPlayer.identifier or table.includes(farms[farmId].members, xPlayer.identifier)) then
        -- Ensure the pot is empty
        if not farms[farmId].plants[potId] then
            -- Calculate random growth time
            local growthTime = math.random(cfg.waitTime.min, cfg.waitTime.max)

            -- Deduct the seed item from the player's inventory
            if exports.ox_inventory:GetItemCount(xPlayer.source, seedItem, nil, false) > 0 then
                exports.ox_inventory:RemoveItem(xPlayer.source, seedItem, 1, nil)

                -- Initialize plant data
                farms[farmId].plants[potId] = {
                    progress = 0,
                    water = 0,
                    fertilizer = 0,
                    item = seedItem,
                    plantedAt = os.time(),
                    growthTime = growthTime
                }

                -- Notify the player
                -- TriggerClientEvent('KKF.UI.ShowNotification', src, 'success', 'Seeme istutatud! Kasvuaeg: ' .. math.floor(growthTime / 1000) .. ' sekundit.')


                -- Notify clients to reload the plant
                TriggerClientEvent('kk-farming:client:reloadObject', -1, farmId, potId)
            else
                -- Notify if the player does not have the seed item
                TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Sul pole seemet, mida istutada!')
            end
        else
            -- Notify if the pot is already occupied
            TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Selles potis on juba taim!')
        end
    else
        -- Notify if the player does not have permission
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Sul pole õigusi!')
    end
end)

SetInterval(function()
    -- Iterate through all farms
    for farmId, farmData in pairs(farms) do
        -- Iterate through all plants in the farm
        for potId, plantData in pairs(farmData.plants) do
            if plantData and plantData.progress < 100 then -- Only process plants still growing
                local plantType = cfg.plantList[plantData.item]

                -- Check if plant type exists in the config
                if plantType then
                    -- Reduce water and fertilizer levels
                    if plantData.water > 0 then
                        plantData.water = math.max(0, plantData.water - 20)
                    end
                    if plantData.fertilizer > 0 then
                        plantData.fertilizer = math.max(0, plantData.fertilizer - 20)
                    end

                    -- Add progress only if water and fertilizer are sufficient
                    if plantData.water > 0 and plantData.fertilizer > 0 then
                        plantData.progress = math.min(100, plantData.progress + 20)
                    end

                    -- Notify clients to update plant visuals
                    TriggerClientEvent('kk-farming:client:reloadObject', -1, farmId, potId)

                    -- Notify players if the plant is fully grown
                    if plantData.progress >= 100 then
                        TriggerClientEvent('KKF.UI.ShowNotification', -1, 'success', 'Taim on täielikult kasvanud!')
                    end
                end
            end
        end
    end
end, cfg.updateinterval * 60000) -- Run every interval defined in config




-- Water a plant
RegisterNetEvent('kk-farming:server:waterPlant', function(data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local farmId = data.farm
    local potId = data.id
    if farms[farmId] and (farms[farmId].owner == xPlayer.identifier or table.includes(farms[farmId].members, xPlayer.identifier)) then
        local plant = farms[farmId].plants[potId]
        if plant then
            if plant.water < 100 then
                plant.water = math.min(100, plant.water + cfg.addwater)

                exports.ox_inventory:RemoveItem(xPlayer.source, cfg.wateritem, 1, nil)

                -- Notify the player
                TriggerClientEvent('KKF.UI.ShowNotification', src, 'success', 'Taim kastetud!')
            else
                -- Notify the player if the plant's water is already full
                TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Taim ei vaja rohkem vett!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Selles potis pole taime!')
        end
    else
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Sul pole õigusi!')
    end
end)


RegisterNetEvent('kk-farming:server:fertilizePlant', function(data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local farmId = data.farm
    local potId = data.id
    if farms[farmId] and (farms[farmId].owner == xPlayer.identifier or table.includes(farms[farmId].members, xPlayer.identifier)) then
        local plant = farms[farmId].plants[potId]

        if plant then
            if plant.fertilizer < 100 then
                plant.fertilizer = math.min(100, plant.fertilizer + cfg.addfertilizer)

                exports.ox_inventory:RemoveItem(xPlayer.source, cfg.fertilizeritem, 1, nil)

                TriggerClientEvent('KKF.UI.ShowNotification', src, 'success', 'Taim väetatud!')
            else
                TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Taim ei vaja rohkem väetist!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Selles potis pole taime!')
        end
    else
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Sul pole õigusi!')
    end
end)


RegisterNetEvent('kk-farming:server:recievePlants', function(data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local farmId = data.farm
    local potId = data.id

    if xPlayer and farms[farmId] and farms[farmId].plants[potId] then
        local plant = farms[farmId].plants[potId]
        local plantType = cfg.plantList[plant.item]

        if plantType then
            if plant.progress >= 100 then
                local rewardItem = plantType.reward.item
                local rewardCount = math.random(plantType.reward.count.min, plantType.reward.count.max)

                if cfg.debug then
                    print(("Reward Count: %d, Reward Item: %s"):format(rewardCount, rewardItem))
                end

                if exports.ox_inventory:CanCarryItem(xPlayer.source, rewardItem, rewardCount) then
                    exports.ox_inventory:AddItem(xPlayer.source, rewardItem, rewardCount)
                    farms[farmId].plants[potId] = nil

                    if cfg.useskill and plantType.reward.skill and plantType.reward.skill > 0 then
                        exports['kk-skills']:AddSkillProgress(xPlayer.source, cfg.skillname, plantType.reward.skill)
                    end

                    TriggerClientEvent('kk-farming:client:reloadObject', -1, farmId, potId)
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Su taskud on täis!')
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Taim pole veel valmis!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Taimel pole seadistatud saaki!')
        end
    else
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Vale farm või pott!')
    end
end)



-- Callbacks
lib.callback.register('kk-farming:fetchFarmData', function(source, farmId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if farms[farmId] then
        local isMine = farms[farmId].owner == xPlayer.identifier
        local isRented = farms[farmId].isRented
        return { isMine = isMine, isRented = isRented }
    end
    return nil
end)

lib.callback.register('kk-farming:fetchPermission', function(source, farmId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if farms[farmId] then
        if farms[farmId].owner == xPlayer.identifier or table.includes(farms[farmId].members, xPlayer.identifier) then
            return true
        end
    end
    return false
end)


lib.callback.register('kk-farming:fetchObjects', function(source, farmId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerIdentifier = xPlayer.identifier


    if farms[farmId] and (farms[farmId].owner == playerIdentifier or table.includes(farms[farmId].members, playerIdentifier)) then
        local objectsData = {}


        farms[farmId].plants = farms[farmId].plants or {}

        for potId, plantData in pairs(farms[farmId].plants) do
            objectsData[potId] = {
                progress = plantData.progress,
                water = plantData.water,
                fertilizer = plantData.fertilizer,
                item = plantData.item
            }
        end

        return objectsData
    else

        return nil
    end
end)


lib.callback.register('kk-farming:fetchPlant', function(source, farmId, potId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerIdentifier = xPlayer.identifier

    -- Ensure the farm exists and the player has access to it
    if farms[farmId] and (farms[farmId].owner == playerIdentifier or table.includes(farms[farmId].members, playerIdentifier)) then
        -- Ensure the plant data exists in the specified pot
        if farms[farmId].plants and farms[farmId].plants[potId] then
            local plantData = farms[farmId].plants[potId]
            return {
                progress = plantData.progress or 0,
                water = plantData.water or 0,
                fertilizer = plantData.fertilizer or 0,
                item = plantData.item or 'none'
            }
        else
            return {
                progress = 0,
                water = 0,
                fertilizer = 0,
                item = 'none'
            }
        end
    end

    -- If no access or invalid farm/pot, return nil
    return nil
end)
