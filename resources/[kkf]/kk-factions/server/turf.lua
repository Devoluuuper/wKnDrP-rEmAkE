
-- local function canFactionStart(faction)
--     local rivelry = MySQL.Sync.fetchScalar('SELECT COUNT(*) FROM `rivalries` WHERE `attacker` = ? OR `defender` = ?', { faction, faction }) == 0

--     return rivelry
-- end

-- local function checkTurf(faction, zone)
--     return MySQL.Sync.fetchScalar('SELECT COUNT(*) FROM `rivalries` WHERE `attacker` = ? OR `defender` = ? AND `zone` = ?', { faction, faction, zone }) > 0
-- end

-- exports('checkTurf', checkTurf)

-- RegisterNetEvent('kk-factions:server:startTurf', function(zone)
--     local kPlayer = KKF.GetPlayerFromId(source)

--     if kPlayer then
--         if isGangFaction(kPlayer.job.name) and kPlayer.job.permissions.function11 then
--             if canFactionStart(kPlayer.job.name) then
--                 if cfg.gangZones[zone].controller ~= kPlayer.job.name and cfg.gangZones[zone].controller ~= 'none' and not cfg.gangZones[zone].turf then
--                     local myRep = MySQL.prepare.await('SELECT `reputation` FROM `gang_zones` WHERE `zone` = ? AND `faction` = ?', { zone, kPlayer.job.name }) or -1

--                     if myRep > 0 then
--                         TriggerEvent('Society.GetMoney', kPlayer.job.name, function(money)
--                             if money >= cfg.turf.pool then
--                                 local jobs = KKF.GetJobs()
--                                 local zoneData = cfg.gangZones[zone]
--                                 local id = MySQL.insert.await('INSERT INTO rivalries (zone, attacker, defender, time_left) VALUES (?, ?, ?, ?)', { zone, kPlayer.job.name, cfg.gangZones[zone].controller, (cfg.turf.time * 60) })

--                                 if id then
--                                     local defenders = KKF.GetPlayers()
                                
--                                     for _, playerId in pairs(defenders) do
--                                         local player = KKF.GetPlayerFromId(playerId)
--                                         if player and player.PlayerData.job.name == cfg.gangZones[zone].controller then
--                                             TriggerClientEvent('KKF.UI.ShowNotification', player.PlayerData.source, 'info', 'Jõuk ' .. kPlayer.job.label .. ' rajoonis ' .. cfg.zoneNames[zone] .. ' alustas teie vastu rivaalitsemist!', 15000)
--                                         end
--                                     end
                                
--                                     local attackers = KKF.GetPlayers()
                                
--                                     for _, playerId in pairs(attackers) do
--                                         local player = KKF.GetPlayerFromId(playerId)
--                                         if player and player.PlayerData.job.name == kPlayer.job.name then
--                                             TriggerClientEvent('KKF.UI.ShowNotification', player.PlayerData.source, 'info', 'Teie jõuk alustas ' .. jobs[cfg.gangZones[zone].controller].label .. ' jõugu vastu rivaalitsemist rajoonis ' .. cfg.zoneNames[zone] .. '!', 15000)
--                                         end
--                                     end
--                                 end

--                                 TriggerEvent('Society.RemoveMoney', kPlayer.job.name, cfg.turf.pool)
--                                 TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'info', 'Alustasite rivaalitsemist jõuguga ' .. jobs[cfg.gangZones[zone].controller].label .. ' rajoonis ' .. cfg.zoneNames[zone] .. '.')
--                                 exports['kk-factions']:reloadZones()
--                             else
--                                 TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Jõugul ei ole arvelduskontol piisavalt raha ($' .. cfg.turf.pool .. ')!')
--                             end
--                         end)
--                     else
--                         TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Teie jõugul ei ole piisavalt reputatsiooni siin alas!')
--                     end
--                 end
--             else
--                 TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Teie jõuk ei saa osaleda kahes rivaalitsemises!')
--             end
--         end
--     end
-- end)

-- local timeouts = {}

-- RegisterCommand('rivalry', function(source)
--     local Player = KKF.GetPlayerFromId(source)

--     if Player then
--         if not timeouts[Player.identifier] then
--             timeouts[Player.PlayerData.citizenid] = true

--             SetTimeout(10 * 60000, function()
--                 timeouts[Player.PlayerData.citizenid] = nil
--             end)

--             for k,v in pairs(cfg.gangZones) do
--                 if v.turf then
--                     local rivelry = MySQL.prepare.await('SELECT * FROM `rivalries` WHERE `zone` = ?', { k })

--                     if Player.PlayerData.job.name == rivelry.attacker or Player.PlayerData.job.name == rivelry.defender then
--                         local jobs = KKF.GetJobs()

--                         TriggerClientEvent('chatMessage', Player.PlayerData.source, 'TURFS', 7, 'Teil on käimas rivaalitsemine ' .. cfg.zoneNames[k] .. ' rajoonis jõugu ' .. jobs[rivelry.attacker].label .. ' vastu, lõpuni ' .. rivelry.time_left .. ' minutit! ' .. jobs[rivelry.attacker].label .. ': ' .. rivelry.attacker_points .. 'p; ' .. jobs[rivelry.defender].label .. ': ' .. rivelry.defender_points .. 'p')
--                     end
--                 end
--             end
--         else
--             TriggerClientEvent('chatMessage', Player.PlayerData.source, 'Rivaalitsemine', 'error', 'Ära kiirusta!')
--         end
--     end
-- end)

-- AddEventHandler('KKF.Player.Loaded', function(Player)
--     if Player then
--         for k,v in pairs(cfg.gangZones) do
--             if v.turf then
--                 local rivelry = MySQL.prepare.await('SELECT * FROM `rivalries` WHERE `zone` = ?', { k })

--                 if Player.PlayerData.job.name == rivelry.attacker or Player.PlayerData.job.name == rivelry.defender then
--                     local jobs = KKF.GetJobs()

--                     TriggerClientEvent('chatMessage', Player.PlayerData.source, 'TURFS', 7, 'Teil on käimas rivaalitsemine ' .. cfg.zoneNames[k] .. ' rajoonis jõugu ' .. jobs[rivelry.attacker].label .. ' vastu, lõpuni ' .. KKF.Math.Round(rivelry.time_left / 60) .. ' tundi! ' .. jobs[rivelry.attacker].label .. ': ' .. rivelry.attacker_points .. 'p; ' .. jobs[rivelry.defender].label .. ': ' .. rivelry.defender_points .. 'p')
--                 end
--             end
--         end
--     end
-- end)

-- RegisterServerEvent('kk-logs:server:killLog', function(tid)
--     local src = source
--     local xPlayer = KKF.GetPlayerFromId(src)
    
--     if xPlayer then
--         local xTarget = KKF.GetPlayerFromId(tid)

--         if xTarget then
--             TriggerEvent('kk-factions:server:onPlayerKill', xTarget.PlayerData.source)
--         end
--     end
-- end)

-- AddEventHandler('kk-factions:server:onPlayerKill', function(source)
--     local Player = KKF.GetPlayerFromId(source)

--     if isGangFaction(Player.PlayerData.job.name) then

--         local playerCoords = GetEntityCoords(GetPlayerPed(Player.PlayerData.source))
--         local zone = lib.callback.await('KARU.RPC.GetNameOfZone', Player.PlayerData.source, playerCoords)

--         if cfg.gangZones[zone] then
--             if cfg.gangZones[zone].turf then

--                 local rivelry = MySQL.prepare.await('SELECT * FROM `rivalries` WHERE `zone` = ?', { zone })

--                 if rivelry then
--                     local realTime = rivelry.time_left / 60

--                     if Player.PlayerData.job.name == rivelry.attacker or Player.PlayerData.job.name == rivelry.defender then
--                         TriggerEvent('kk-factions:server:gainReputation', zone, Player.PlayerData.job.name, cfg.killReputation)
--                     else
--                         for k, v in pairs(cfg.gangZones) do
--                             exports['kk-factions']:gainReputation(k, Player.PlayerData.job.name, -cfg.killReputation)
--                         end
--                     end
--                 else
--                     for k, v in pairs(cfg.gangZones) do
--                         exports['kk-factions']:gainReputation(k, Player.PlayerData.job.name, -cfg.killReputation)
--                     end
--                 end
--             else
--                 for k, v in pairs(cfg.gangZones) do
--                     exports['kk-factions']:gainReputation(k, Player.PlayerData.job.name, -cfg.killReputation)
--                 end
--             end
--         end
--     end
-- end)

-- SetInterval(function()
--     local result = MySQL.query.await('SELECT * FROM `rivalries`')

--     if #result > 0 then
--         local reloadNeeded = false

--         for i = 1, #result do
--             local newTime = result[i].time_left - 1

--             if newTime > 0 then
--                 MySQL.update.await('UPDATE `rivalries` SET `time_left` = ? WHERE `id` = ?', { newTime, result[i].id })
--             else
--                 local jobs = KKF.GetJobs()
--                 local status = ''

--                 if result[i].attacker_points > result[i].defender_points then
--                     local defenderReputation = MySQL.prepare.await('SELECT `reputation` FROM `gang_zones` WHERE `zone` = ? AND `faction` = ?', { result[i].zone, result[i].defender }) or 0
--                     local attackerReputation = MySQL.prepare.await('SELECT `reputation` FROM `gang_zones` WHERE `zone` = ? AND `faction` = ?', { result[i].zone, result[i].attacker }) or 0

--                     MySQL.update.await('UPDATE `gang_zones` SET `reputation` = ? WHERE `zone` = ? AND `faction` = ?', { KKF.Math.Round(defenderReputation * 0.25), result[i].zone, result[i].defender })
--                     MySQL.update.await('UPDATE `gang_zones` SET `reputation` = ? WHERE `zone` = ? AND `faction` = ?', { attackerReputation + result[i].attacker_points, result[i].zone, result[i].attacker })

--                     TriggerEvent('Society.AddMoney', result[i].attacker, result[i].pool)
--                     status = jobs[result[i].attacker].label .. ' võiduga'

--                 elseif result[i].defender_points > result[i].attacker_points then
--                     local defenderReputation = MySQL.prepare.await('SELECT `reputation` FROM `gang_zones` WHERE `zone` = ? AND `faction` = ?', { result[i].zone, result[i].defender }) or 0
--                     local attackerReputation = MySQL.prepare.await('SELECT `reputation` FROM `gang_zones` WHERE `zone` = ? AND `faction` = ?', { result[i].zone, result[i].attacker }) or 0

--                     MySQL.update.await('UPDATE `gang_zones` SET `reputation` = ? WHERE `zone` = ? AND `faction` = ?', { KKF.Math.Round(attackerReputation * 0.25), result[i].zone, result[i].attacker })
--                     MySQL.update.await('UPDATE `gang_zones` SET `reputation` = ? WHERE `zone` = ? AND `faction` = ?', { defenderReputation + result[i].defender_points, result[i].zone, result[i].defender })

--                     TriggerEvent('Society.AddMoney', result[i].defender, result[i].pool)
--                     status = jobs[result[i].defender].label .. ' võiduga'
--                 else
--                     TriggerEvent('Society.AddMoney', result[i].attacker, KKF.Math.Round(result[i].pool / 2))
--                     TriggerEvent('Society.AddMoney', result[i].defender, KKF.Math.Round(result[i].pool / 2))
--                     status = 'viigiga'
--                 end

--                 -- Kustuta turf ja veendu, et see õnnestus
--                 local deleted = MySQL.update.await('DELETE FROM `rivalries` WHERE `id` = ?', { result[i].id })
--                 if deleted then
--                     reloadNeeded = true
--                 else
--                     print('⚠️ Turf DELETE failed for id:', result[i].id)
--                 end

--                 -- Teavitused ESX mängijatele
--                 local players = KKF.GetPlayers()
--                 for _, pid in pairs(players) do
--                     local xPlayer = KKF.GetPlayerFromId(pid)
--                     if xPlayer and (xPlayer.job.name == result[i].attacker or xPlayer.job.name == result[i].defender) then
--                         TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'info', 
--                             'Rivaalitsemine alas ' .. cfg.zoneNames[result[i].zone] .. ' lõppes ' .. status .. '!', 10000)
--                     end
--                 end
--             end
--         end

--         if reloadNeeded then
--             exports['kk-factions']:reloadZones()
--         end
--     end
-- end, 60000)
