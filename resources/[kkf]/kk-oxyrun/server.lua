local activeLocations = {}
local ox_inventory = exports.ox_inventory

lib.callback.register('kk-oxyrun:fetchLocations', function(source)
    local freeLocations = {}
    for index, location in ipairs(cfg.sellLocations) do
        if not activeLocations[index] then
            table.insert(freeLocations, index)
        end
    end
    return freeLocations
end)

RegisterNetEvent('kk-oxyrun:server:reserveStreet', function(data)
    local source = source
    local xPlayer = KKF.GetPlayerFromId(source)
    local pedIndex = data.ped
    local locationIndex = data.location

    if xPlayer then
        if xPlayer.getMoney() >= cfg.startamount then
            xPlayer.removeMoney(cfg.startamount)
        else
            TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Tulid siia nalja tegema? Timmi dengi mulle ('.. cfg.startamount..')$')
            return
        end

        if not activeLocations[locationIndex] then
            local dealerIndex = math.random(#cfg.dealerLocations)
            activeLocations[locationIndex] = source

            local jobData = {
                ped = pedIndex,
                location = locationIndex,
                dealer = dealerIndex,
            }

            TriggerClientEvent('kk-oxyrun:client:startJob', source, jobData, cfg.peds[pedIndex].name)
        else
            TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'See koht on juba hõivatud.')
        end
    else

    end
end)



local playerPackages = {}

RegisterNetEvent('kk-oxyrun:server:takePackage', function(data)
    local xPlayer = KKF.GetPlayerFromId(source)

    if xPlayer then
        if not playerPackages[xPlayer.identifier] then
            playerPackages[xPlayer.identifier] = {
                packagesToGive = math.random(4, 6),
                packagesTaken = 0,
            }
        end

        local packageData = playerPackages[xPlayer.identifier]

        if ox_inventory:CanCarryItem(source, 'package', 1) then
            ox_inventory:AddItem(source, 'package', 1)
            packageData.packagesTaken = packageData.packagesTaken + 1

            if packageData.packagesTaken == packageData.packagesToGive then
                TriggerClientEvent('KKF.UI.ShowNotification', source, 'success', 'Sa said viimase paki.')
                
                local sellLocationIndex = math.random(#cfg.sellLocations)
                local sellData = {
                    location = sellLocationIndex,
                    packages = packageData.packagesToGive,
                }

                TriggerClientEvent('kk-oxyrun:client:startSelling', source, sellData)
            else
                TriggerClientEvent('KKF.UI.ShowNotification', source, 'success', 'Sa said paki. ' .. packageData.packagesTaken .. '/' .. packageData.packagesToGive)
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Pole piisavalt ruumi.')
        end
    end
end)

RegisterNetEvent('kk-oxyrun:server:givePackage', function()
    local xPlayer = KKF.GetPlayerFromId(source)

    if xPlayer then
        if not playerPackages[xPlayer.identifier] or playerPackages[xPlayer.identifier].packagesTaken <= 0 then
            TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Sul pole rohkem pakke.')
            return
        end

        local packageData = playerPackages[xPlayer.identifier]
        local packageCount = ox_inventory:GetItem(source, 'package', false, true)

        if packageCount > 0 then
            ox_inventory:RemoveItem(source, 'package', 1)
            packageData.packagesTaken = packageData.packagesTaken - 1

            local randomAmount = math.random(1, 2)
            ox_inventory:AddItem(source, 'oxy', randomAmount)

            if packageData.packagesTaken == 0 then
                TriggerClientEvent('KKF.UI.ShowNotification', source, 'success', 'Kõik pakid on müüdud!')

                local skill_level = exports['kk-skills']:GetSkillLevel(source, cfg.skillname)
                local progressAdd = 0

                if skill_level == 1 then
                    progressAdd = 4
                elseif skill_level == 2 then
                    progressAdd = 3
                elseif skill_level == 3 then
                    progressAdd = 2
                elseif skill_level == 4 then
                    progressAdd = 1
                elseif skill_level >= 5 then
                    progressAdd = 0.5
                end
                exports['kk-skills']:AddSkillProgress(source, cfg.skillname, progressAdd)
                
                playerPackages[xPlayer.identifier] = nil

                TriggerClientEvent('kk-oxyrun:client:cleanRun', source)
            else
                TriggerClientEvent('KKF.UI.ShowNotification', source, 'success', 'Pakk müüdud! Jäänud: ' .. packageData.packagesTaken)
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Sul pole enam pakke müümiseks.')
        end
    end
end)




RegisterNetEvent('kk-oxyrun:server:cleanRun', function()
    local source = source
    for index, playerId in pairs(activeLocations) do
        if playerId == source then
            activeLocations[index] = nil
        end
    end
    TriggerClientEvent('kk-oxyrun:client:cleanRun', source)
end)



lib.callback.register('kk-oxyrun:fetchConfig', function(source)
    return cfg
end)



AddEventHandler('playerDropped', function()
    local xPlayer = KKF.GetPlayerFromId(source)
    if xPlayer then
        playerPackages[xPlayer.identifier] = nil
    end
end)
