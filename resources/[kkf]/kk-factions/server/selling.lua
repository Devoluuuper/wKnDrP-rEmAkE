-- local sellers = {}


-- lib.callback.register('kk-factions:sellDrugs', function(source, zone)
--     local kPlayer = QBCore.Functions.GetPlayer(source)

--     if kPlayer then
--         local done = false

--         local reputation = exports['kk-factions']:totalReputation(kPlayer.PlayerData.job.name)
--         local lvl = 'CATEGORY_LOW'
    
--         if reputation > 5000 and reputation < 15000 then
--             lvl = 'CATEGORY_MED'
--         elseif reputation > 15000 then
--             lvl = 'CATEGORY_HIGH'
--         end

--         local drugList = {}

--         if lvl == 'CATEGORY_HIGH' then
--             for k, v in pairs(cfg.drugs['CATEGORY_MED']) do
--                 drugList[k] = v
--             end
            
--             for k, v in pairs(cfg.drugs['CATEGORY_LOW']) do
--                 drugList[k] = v
--             end
--         elseif lvl == 'CATEGORY_MED' then
--             for k, v in pairs(cfg.drugs['CATEGORY_LOW']) do
--                 drugList[k] = v
--             end
--         end
    
--         for k, v in pairs(cfg.drugs[lvl]) do
--             drugList[k] = v
--         end

--         if sellers[kPlayer.PlayerData.source] then
--             -- cheat
--         end

--         sellers[kPlayer.PlayerData.source] = true

--         SetTimeout(5000, function()
--             sellers[kPlayer.PlayerData.source] = nil
--         end)

--         for k,v in pairs(drugList) do
--             if exports.ox_inventory:Search(kPlayer.PlayerData.source, 'count', k) > 0 and not done then
--                 if not (isGangFaction(kPlayer.PlayerData.job.name) and k == 'hash') then
--                     done = true 
--                     local count = math.random(1, exports.ox_inventory:Search(kPlayer.PlayerData.source, 'count', k))

--                     local skill = exports['karu-skills']:GetSkillLevel(kPlayer.PlayerData.source, 'kuller') -- OMA SKILL SÜSTEEM
--                     local level = 5 + skill
    
--                     if count > level then
--                         count = math.random(1, level)
--                     end
    
--                     if k:upper():find('PACKAGE') then
--                         count = 1
--                     end
    
--                     local reward = math.random(v.reward.min, v.reward.max) * count
    
--                     if cfg.gangZones[zone] then
--                         if not cfg.gangZones[zone].turf then
--                             exports.ox_inventory:RemoveItem(kPlayer.PlayerData.source, k, count)

--                             if exports.ox_inventory:CanCarryItem(kPlayer.PlayerData.source, 'black_money', reward) then
--                                 exports.ox_inventory:AddItem(kPlayer.PlayerData.source, 'black_money', reward)
--                             else
--                                 TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.PlayerData.source, 'error', 'Teil ei ole taskus piisavalt ruumi! Kukutasid esemed põrandale')
        
--                                 exports.ox_inventory:CustomDrop('Items #' .. math.random(00000, 99999), {
--                                     {'black_money', reward}
--                                 }, GetEntityCoords(GetPlayerPed(kPlayer.PlayerData.source)))
--                             end
        
--                             if cfg.gangZones[zone] and isGangFaction(kPlayer.PlayerData.job.name) then
--                                 exports['kk-factions']:gainReputation(zone, kPlayer.PlayerData.job.name, v.reputation * count)
--                             end
        
--                             exports['kk-scripts']:sendLog(kPlayer.PlayerData.citizenid, 'NARKOOTIKUMID', 'Müüs eseme ' .. count .. 'x ' .. QBCore.Functions.GetItemLabel(k) .. ' $' .. reward .. ' eest.')
--                         else
--                             local turfData = MySQL.prepare.await('SELECT * FROM `rivalries` WHERE `zone` = ?', { zone })
        
--                             if kPlayer.PlayerData.job.name == turfData.attacker then
--                                 MySQL.update.await('UPDATE `rivalries` SET `attacker_points` = ?, `pool` = ? WHERE `zone` = ?', { turfData.attacker_points + (v.reputation * count), turfData.pool + reward, zone })
--                             elseif kPlayer.PlayerData.job.name == turfData.defender then
--                                 MySQL.update.await('UPDATE `rivalries` SET `defender_points` = ?, `pool` = ? WHERE `zone` = ?', { turfData.defender_points + (v.reputation * count), turfData.pool + reward, zone })
--                             else
--                                 if exports.ox_inventory:CanCarryItem(kPlayer.PlayerData.source, 'black_money', reward) then
--                                     exports.ox_inventory:AddItem(kPlayer.PlayerData.source, 'black_money', reward)
--                                 else
--                                     TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.PlayerData.source, 'error', 'Teil ei ole taskus piisavalt ruumi! Kukutasid esemed põrandale')
            
--                                     exports.ox_inventory:CustomDrop('Items #' .. math.random(00000, 99999), {
--                                         {'black_money', reward}
--                                     }, GetEntityCoords(GetPlayerPed(kPlayer.PlayerData.source)))
--                                 end
        
--                                 exports['kk-scripts']:sendLog(kPlayer.PlayerData.citizenid, 'NARKOOTIKUMID', 'Müüs eseme ' .. count .. 'x ' .. QBCore.Functions.GetItemLabel(k) .. ' $' .. reward .. ' eest.')
--                             end
    
--                             exports.ox_inventory:RemoveItem(kPlayer.PlayerData.source, k, count)
--                         end
--                     else
--                         exports.ox_inventory:RemoveItem(kPlayer.PlayerData.source, k, count)
                        
--                         if exports.ox_inventory:CanCarryItem(kPlayer.PlayerData.source, 'black_money', reward) then
--                             exports.ox_inventory:AddItem(kPlayer.PlayerData.source, 'black_money', reward)
--                         else
--                             TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.PlayerData.source, 'error', 'Teil ei ole taskus piisavalt ruumi! Kukutasid esemed põrandale')
    
--                             exports.ox_inventory:CustomDrop('Items #' .. math.random(00000, 99999), {
--                                 {'black_money', reward}
--                             }, GetEntityCoords(GetPlayerPed(kPlayer.PlayerData.source)))
--                         end
    
--                         exports['kk-scripts']:sendLog(kPlayer.PlayerData.citizenid, 'NARKOOTIKUMID', 'Müüs eseme ' .. count .. 'x ' .. QBCore.Functions.GetItemLabel(k) .. ' $' .. reward .. ' eest.')
--                     end
    
--                     if not cfg.gangZones[zone].turf or not isGangFaction(kPlayer.PlayerData.job.name) then
--                         exports['kk-dispatch']:sendMessage(kPlayer.PlayerData.source, 'Kahtlane tegevus', '10-34', {'police'}, nil, 'bg-yellow-700')
--                     end 
--                 end
--             end
--         end

--         return true
--     else
--         return false
--     end
-- end)

-- exports('turfOngoing', function(zone)
--     if cfg.gangZones[zone] then
--         if cfg.gangZones[zone].turf then
--             return true
--         end
--     end

--     return false
-- end)

-- lib.callback.register('kk-factions:turfOngoing', function(source, zone)
--     local kPlayer = QBCore.Functions.GetPlayer(source)

--     if kPlayer then
--         if isGangFaction(kPlayer.PlayerData.job.name) then
--             return exports['kk-factions']:turfOngoing(zone)
--         else
--             return false
--         end
--     else
--         return false
--     end
-- end)
