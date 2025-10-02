local activeJobs = {}

-- Kontrolli, kas töö on aktiivne
lib.callback.register('kk-carstop:isJobActive', function(source)
    return activeJobs[source] ~= nil
end)

-- Alusta tööotsa
RegisterServerEvent('kk-carstop:startJob')
AddEventHandler('kk-carstop:startJob', function()
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    if not xPlayer then return end

    if activeJobs[src] then
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Sul on juba töö pooleli!')
        return
    end

    local cfg = require 'config'
    local locationIndex = math.random(1, #cfg.repairLocations)
    local location = cfg.repairLocations[locationIndex]

    activeJobs[src] = {
        locationId = locationIndex,
        location = location,
        inProgress = true
    }

    TriggerClientEvent('kk-carstop:spawnVehicle', src, location, locationIndex)
end)

-- Lõpeta tööots
RegisterServerEvent('kk-carstop:stopJob')
AddEventHandler('kk-carstop:stopJob', function()
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    if not xPlayer then return end

    if not activeJobs[src] then
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Sul pole ühtegi Carstop tööotsa pooleli!')
        return
    end

    local netVehId = activeJobs[src].netVehId
    activeJobs[src] = nil

    TriggerClientEvent('kk-carstop:client:cleanup', src, netVehId)
    TriggerClientEvent('KKF.UI.ShowNotification', src, 'success', 'Lõpetasid tööotsa saamise')
end)

-- Salvestab sõiduki netID kui see on spawnitud
RegisterServerEvent('kk-carstop:vehicleSpawned')
AddEventHandler('kk-carstop:vehicleSpawned', function(netVehId)
    local src = source
    if activeJobs[src] then
        activeJobs[src].netVehId = netVehId
    end
end)


lib.callback.register('kk-carstop:server:repairDone', function(source, locationId)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    if not xPlayer then return false end

    if not activeJobs[src] or activeJobs[src].locationId ~= locationId then
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Töö ID ei klapi!')
        return false
    end

    local cfg = require 'config'

    -- kontrolli tööriistakasti
    local toolbox = nil
    for item, _ in pairs(cfg.toolboxes) do
        if exports.ox_inventory:Search('count', item, {}, src) > 0 then
            toolbox = item
            break
        end
    end

    if not toolbox then
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Sul pole vajalikku tööriistakasti!')
        return false
    end

    local durabilityLoss = cfg.toolboxes[toolbox].durabilityLoss()
    local items = exports.ox_inventory:Search('slots', toolbox, {}, src)
    local itemData = items[1]

    if itemData and itemData.metadata and itemData.metadata.durability then
        local newDurability = itemData.metadata.durability - durabilityLoss
        if newDurability <= 0 then
            exports.ox_inventory:RemoveItem(src, toolbox, 1, false, itemData.slot)
            TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Sinu tööriistakast kulus ära!')
        else
            exports.ox_inventory:SetMetadata(src, itemData.slot, { durability = newDurability })
            TriggerClientEvent('KKF.UI.ShowNotification', src, 'info', 'Kulus: ' .. durabilityLoss .. ' | Alles: ' .. newDurability)
        end
    else
        exports.ox_inventory:RemoveItem(src, toolbox, 1, false, itemData.slot)
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Sinu tööriistakast kulus ära!')
    end

    -- tasu
    local grade = xPlayer.job.grade or 1
    local rewardLevel = nil
    for _, lvl in ipairs(cfg.rewardLevels) do
        if lvl.level == grade then
            rewardLevel = lvl
            break
        end
    end
    if not rewardLevel then
        rewardLevel = cfg.rewardLevels[1]
    end

    for _, reward in ipairs(rewardLevel.rewards) do
        local amount = math.random(reward.min, reward.max)
        exports.ox_inventory:AddItem(src, reward.item, amount)
    end

    -- oskuse progress
    if cfg.skillname then
        local skill_level = exports['kk-skills']:GetSkillLevel(src, cfg.skillname) or 0
        if type(skill_level) ~= "number" then
            skill_level = 0
        end

        local progressadd = 0
        if skill_level == 0 then
            progressadd = 1 -- uus oskus, annab rohkem progressi
        elseif skill_level == 1 then
            progressadd = 1
        elseif skill_level == 2 then
            progressadd = 0.5
        elseif skill_level == 3 then
            progressadd = 0.3
        elseif skill_level == 4 then
            progressadd = 0.2
        elseif skill_level >= 5 then
            progressadd = 0.1
        end

        exports['kk-skills']:AddSkillProgress(src, cfg.skillname, progressadd)
    end

    -- lõpeta töö
    local netVehId = activeJobs[src].netVehId
    activeJobs[src] = nil
    TriggerClientEvent('kk-carstop:client:cleanup', src, netVehId)

    TriggerClientEvent('KKF.UI.ShowNotification', src, 'success', 'Tööots lõpetatud – võid uue tööotsa alustada!')
    return true
end)
