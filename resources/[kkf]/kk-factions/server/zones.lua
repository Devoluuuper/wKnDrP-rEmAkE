
-- local function reloadZones()
--     local player = KKF.GetPlayerFromId(source)
--     local playerJob = player and player.PlayerData.job.name or nil

--     for k,v in pairs(cfg.gangZones) do
--         local result = MySQL.query.await('SELECT * FROM `gang_zones` WHERE `zone` = ? ORDER BY `reputation` DESC', {k})

--         if #result > 0 then
--             local turf = (MySQL.Sync.fetchScalar('SELECT COUNT(*) FROM `rivalries` WHERE `zone` = ?', { k }) > 0)

--             if result[1].reputation >= 10000 or turf then 
--                 cfg.gangZones[k].controller = result[1].faction
--                 cfg.gangZones[k].color = getFactionColor(result[1].faction) or 1
--                 cfg.gangZones[k].turf = turf
--             else
--                 cfg.gangZones[k].controller = 'none'
--                 cfg.gangZones[k].color = 0
--                 cfg.gangZones[k].turf = false
--             end
--         else
--             cfg.gangZones[k].controller = 'none'
--             cfg.gangZones[k].color = 0
--             cfg.gangZones[k].turf = false
--         end
--     end

--     TriggerClientEvent('kk-factions:client:reloadZones', -1, cfg.gangZones)
-- end


-- exports('reloadZones', reloadZones)

-- lib.callback.register('kk-factions:getReputation', function(source, zone)
--     local kPlayer = KKF.GetPlayerFromId(source)

--     if kPlayer then
--         return MySQL.prepare.await('SELECT reputation FROM `gang_zones` WHERE `zone` = ? AND `faction` = ?', { zone, kPlayer.PlayerData.job.name }) or 0
--     else
--         return 0
--     end
-- end)

-- MySQL.ready(function() 
--     reloadZones()
-- end)

-- local function decay()
--     local result = MySQL.query.await('SELECT * FROM `gang_zones` WHERE `zone` = ? ORDER BY `reputation` DESC', {k})

--     for i = 1, #result do
--         if not cfg.gangZones[zone].turf then
--             MySQL.update.await('UPDATE `gang_zones` SET `reputation` = ? WHERE `id` = ?', {result[i].reputation - cfg.zoneDecay.reputation, result[i].id})
--         end
--     end

--     reloadZones()
-- end

-- CreateThread(function()
--     Wait(1000)

--     decay()
-- end)

-- exports('turfReputation', function(source, amount)
--     local kPlayer = KKF.GetPlayerFromId(source)

--     if kPlayer then
--         if isGangFaction(kPlayer.PlayerData.job.name) then
--             local rivalries = MySQL.query.await('SELECT * FROM `rivalries` WHERE `attacker` = ? OR `defender` = ?', { kPlayer.PlayerData.job.name, kPlayer.PlayerData.job.name })

--             for i = 1, #rivalries do
--                 TriggerEvent('kk-factions:server:gainReputation', rivalries[i].zone, kPlayer.PlayerData.job.name, amount)
--             end
--         end
--     end
-- end)

-- AddEventHandler('KKF.Player.Loaded', function(kPlayer)
--     if kPlayer then
--        TriggerClientEvent('kk-factions:client:reloadZones', kPlayer.PlayerData.source, cfg.gangZones)
--     end
-- end)

-- AddEventHandler('rcore_sprays:addSpray', function(source, faction, position)
--     local kPlayer = KKF.GetPlayerFromId(source)

--     if kPlayer then
--         local jobs = KKF.GetJobs()

--         if jobs[faction] then
--             local zone = lib.callback.await('KARU.RPC.GetNameOfZone', kPlayer.PlayerData.source, position)

--             if cfg.gangZones[zone] then
--                 TriggerEvent('kk-factions:server:gainReputation', zone, faction, cfg.spayReputation)
--             end
--         end
--     end
-- end)

-- local function gainReputation(zone, faction, reputation)
--     local jobs = KKF.GetJobs()

--     if jobs[faction].type == 'illegal' then
--         local result = MySQL.prepare.await('SELECT * FROM `gang_zones` WHERE `zone` = ? AND `faction` = ?', { zone, faction })

--         if result then
--             local affectedRows = MySQL.update.await('UPDATE `gang_zones` SET `reputation` = ? WHERE `faction` = ? AND `zone` = ?', {(result.reputation + reputation), faction, zone})

--             if affectedRows then
--                 reloadZones()
--             end
--         else
--             local id = MySQL.insert.await('INSERT INTO `gang_zones` (zone, faction, reputation) VALUES (?, ?, ?)', { zone, faction, reputation })

--             if id then
--                 reloadZones()
--             end
--         end
--     end
-- end

-- exports('gainReputation', gainReputation)

-- AddEventHandler('kk-factions:server:gainReputation', function(zone, faction, reputation)
--     if cfg.gangZones[zone] then
--         if not cfg.gangZones[zone].turf then
--             if reputation then
--                 exports['kk-factions']:gainReputation(zone, faction, reputation)
--             end
--         else
--             local rivelry = MySQL.prepare.await('SELECT * FROM `rivalries` WHERE `zone` = ?', { zone })

--             if rivelry then
--                 if faction == rivelry.attacker then
--                     MySQL.update.await('UPDATE `rivalries` SET `attacker_points` = attacker_points + ?, `pool` = pool + ? WHERE `zone` = ?', { reputation, reputation, zone })
--                 elseif faction == rivelry.defender then
--                     MySQL.update.await('UPDATE `rivalries` SET `defender_points` = defender_points + ?, `pool` = pool + ? WHERE `zone` = ?', { reputation, reputation, zone })
--                 else
--                     exports['kk-factions']:gainReputation(zone, faction, reputation)
--                 end
--             else
--                 exports['kk-factions']:gainReputation(zone, faction, reputation)
--             end
--         end
--     end
-- end)

-- local function totalReputation(faction)
--     local total = 0
--     local result = MySQL.query.await('SELECT * FROM `gang_zones` WHERE `faction` = ?', {faction})

--     for i = 1, #result do
--         total += result[i].reputation
--     end

--     return total
-- end

-- exports('totalReputation', totalReputation)

-- lib.callback.register('kk-factions:totalReputation', function(_, faction)
--     return totalReputation(faction)
-- end)

-- exports('getZoneName', function(zone)
--     return cfg.gangZones[zone].label
-- end)