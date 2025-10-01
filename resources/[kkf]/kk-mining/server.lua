local ox_inventory = exports.ox_inventory

lib.callback.register('kk-mining:recieveData', function(source)
    return cfg
end)

RegisterNetEvent('kk-mining:server:sell', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local playerCoords = GetEntityCoords(GetPlayerPed(source))
    local sellerCoords = vector3(cfg.seller.x, cfg.seller.y, cfg.seller.z)
    local distance = #(playerCoords - sellerCoords)

    if distance > 5 then
        print("[KK-MINING] Mingi snõrr triggeris eventti, oli liiga kaugel (kk-mining:server:sell) - Probs modder" .. ' ID: '..source.. ' PID: '..xPlayer.identifier)
        exports['kk-scripts']:sendLog(xPlayer.identifier, 'EXPLOIT', '[kk-mining] kk-mining:server:sell Exploit; Mängija ID: ' .. xPlayer.source .. '; PID:' .. xPlayer.identifier)
        return
    end

    local total = 0

    for _, shopItem in ipairs(cfg.shop) do
        local itemName = shopItem.item
        local itemPrice = shopItem.price

        local itemCount = ox_inventory:GetItem(source, itemName, false, true)

        if itemCount > 0 then
            total = total + (itemCount * itemPrice)

            ox_inventory:RemoveItem(source, itemName, itemCount)
        end
    end

    if total > 0 then
        ox_inventory:AddItem(source, 'money', total)
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'success', ('Saadused müüdud! Kokku: $%d'):format(total))
    else
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Sul pole midagi müüa.')
    end
end)


lib.callback.register('kk-mining:foundItem', function(source, index)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local skill_level = exports['kk-skills']:GetSkillLevel(source, cfg.skillname)

    if cfg.locations[index] then
        cfg.locations[index].health = cfg.locations[index].health - 1
        if cfg.locations[index].health < 0 then
            cfg.locations[index].health = 0
        end

        TriggerClientEvent('kk-mining:client:healthRefresh', -1, index, cfg.locations[index].health)

        if cfg.locations[index].health > 0 then
            local possibleRewards = {}
            for _, item in ipairs(cfg.rewards) do
                if skill_level >= (item.reqskill or 1) then
                    table.insert(possibleRewards, item)
                end
            end

            if #possibleRewards > 0 then
                local reward = possibleRewards[math.random(#possibleRewards)]
                local amount = reward.min and reward.max and math.random(reward.min, reward.max) or 1

                if ox_inventory:CanCarryItem(source, reward.item, amount) then
                    if reward.addskill then
                        exports['kk-skills']:AddSkillProgress(source, cfg.skillname, reward.addskill)
                    end
                    -- TriggerClientEvent('KKF.UI.ShowNotification', source, 'success', ('Leidsid: %s (x%d)'):format(ESX.GetItemLabel(reward.item), amount))
                    ox_inventory:AddItem(source, reward.item, amount)
                    return true
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Teie taskud on täis.')
                    -- exports.ox_inventory:CustomDrop('Esemed', {
                    --     {reward.item, amount}
                    -- }, GetEntityCoords(GetPlayerPed(xPlayer.source)))
                    return false
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Midagi ei leidnud.')
                return false
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Siit ei saa enam midagi.')
            return false
        end
    end
end)





local function resetMiningLocations()
    for _, location in ipairs(cfg.locations) do
        location.health = 100
    end

    TriggerClientEvent('kk-mining:client:locationRefresh', -1, cfg.locations)
    -- print('Kõik kaevanduskohad on lähtestatud.')
end

-- RegisterCommand('resetMining', function(source, args, rawCommand)
--     resetMiningLocations()
-- end, true)

CreateThread(function()
    while true do
        Wait(cfg.resettimer * 60 * 1000) -- Convert minutes to milliseconds
        resetMiningLocations()
    end
end)

