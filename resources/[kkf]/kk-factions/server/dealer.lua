-- local ox_inventory = exports['ox_inventory']
-- local contrabandTakePeds = {}
-- local contrabandGivePeds = {}

-- CreateThread(function()
--     for k,v in pairs(cfg.gangZones) do
--         cfg.gangZones[k].contract = cfg.dealerContracts[math.random(1, #cfg.dealerContracts)]
--     end

--     for i = 1, #cfg.contrabandLocations do
--         contrabandTakePeds[#contrabandTakePeds + 1] = {
--             coords = cfg.contrabandLocations[i],
--             model = joaat(cfg.pedList[math.random(1, #cfg.pedList)])
--         }
--     end

--     for i = 1, #cfg.contrabandDelivery do
--         contrabandGivePeds[#contrabandGivePeds + 1] = {
--             coords = cfg.contrabandDelivery[i],
--             model = joaat(cfg.pedList[math.random(1, #cfg.pedList)])
--         }
--     end
-- end)

-- lib.callback.register('kk-factions:contrabandLocations', function(_)
--     return contrabandTakePeds, contrabandGivePeds
-- end)

-- lib.callback.register('kk-factions:recieveContract', function(source, zone)
--     local kPlayer = QBCore.Functions.GetPlayer(source)

--     if kPlayer then 
--         if isGangFaction(kPlayer.PlayerData.job.name) then
--             local reputation = MySQL.prepare.await('SELECT reputation FROM `gang_zones` WHERE `zone` = ? AND `faction` = ?', { zone, kPlayer.PlayerData.job.name }) or 0

--             if reputation > cfg.dealerReputation then
--                 local area = cfg.gangZones[zone]

--                 if area.controller == kPlayer.PlayerData.job.name then
--                     if not area.cooldown then
--                         return cfg.gangZones[zone].contract
--                     else
--                         return false
--                     end
--                 else
--                     return false
--                 end 
--             else
--                 return false
--             end 
--         else
--             return false
--         end 
--     else
--         return false
--     end
-- end)

-- RegisterNetEvent('kk-factions:server:exchangeItems', function(zone)
--     local kPlayer = QBCore.Functions.GetPlayer(source)

--     if kPlayer then 
--         if isGangFaction(kPlayer.PlayerData.job.name) and kPlayer.PlayerData.job.permissions.dealerExchange then
--             local reputation = MySQL.prepare.await('SELECT reputation FROM `gang_zones` WHERE `zone` = ? AND `faction` = ?', { zone, kPlayer.PlayerData.job.name }) or 0

--             if reputation > cfg.dealerReputation then
--                 local area = cfg.gangZones[zone]

--                 if area.controller == kPlayer.PlayerData.job.name then
--                     if not area.cooldown then
--                         local contract = area.contract

--                         if contract then
--                             local hasItems = true

--                             for k,v in pairs(contract.needs) do
--                                 if exports.ox_inventory:Search(kPlayer.PlayerData.source, 'count', k) < v then
--                                     hasItems = false
--                                 end
--                             end

--                             if hasItems then
--                                 cfg.gangZones[zone].contract = cfg.dealerContracts[math.random(1, #cfg.dealerContracts)]

--                                 for k,v in pairs(contract.needs) do
--                                     exports['ox_inventory']:RemoveItem(kPlayer.PlayerData.source, k, v)
--                                 end

--                                 for k,v in pairs(contract.recieve) do
--                                     if ox_inventory:CanCarryItem(kPlayer.PlayerData.source, k, v) then
--                                         if string.upper(k):find('WEAPON_') then
--                                             ox_inventory:AddItem(kPlayer.PlayerData.source, k, v, {registered = false})
--                                         else
--                                             ox_inventory:AddItem(kPlayer.PlayerData.source, k, v)
--                                         end
--                                     else
--                                         if string.upper(k):find('WEAPON_') then
--                                             ox_inventory:CustomDrop('Diileri esemed', {
--                                                 {k, v, {registered = false}}
--                                             }, GetEntityCoords(GetPlayerPed(kPlayer.PlayerData.source)))
--                                         else
--                                             ox_inventory:CustomDrop('Diileri esemed', {
--                                                 {k, v}
--                                             }, GetEntityCoords(GetPlayerPed(kPlayer.PlayerData.source)))
--                                         end
                        
--                                         TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.PlayerData.source, 'info', 'Teie taskud on täis! Esemed kukkusid põrandale.')
--                                     end
--                                 end

--                                 exports['kk-factions']:gainReputation(zone, kPlayer.PlayerData.job.name, cfg.dealerGainReputation)

--                                 local data = {
--                                     ['embeds'] = {{
--                                         ['title'] = 'Karakter: ' .. kPlayer.PlayerData.name .. '; PID: ' .. kPlayer.PlayerData.citizenid .. '; FRAKTSIOON: ' .. kPlayer.PlayerData.job.label,
--                                         ['description'] = '**NEEDS:**\n```' .. json.encode(contract.needs) .. '```\n**RECIEVE:**\n```' .. json.encode(contract.recieve) .. '```',
--                                         ['color'] = 16743168
--                                     }}
--                                 }
--                 -- PANE OMA WEBHOOK SIIA '' VAHELE
--                                 PerformHttpRequest('', function(err, text, headers) end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })

--                                 cfg.gangZones[zone].cooldown = true

--                                 SetTimeout(60000 * 60, function()
--                                     cfg.gangZones[zone].cooldown = false
--                                 end)
--                             else
--                                 TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.PlayerData.source, 'error', 'Teil ei ole piisavalt vajalikke esemeid!')
--                             end
--                         else
--                             TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.PlayerData.source, 'error', 'Ei leidnud tööotsa!')
--                         end
--                     else
--                         TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.PlayerData.source, 'error', 'Pidage natuke pausi!')
--                     end
--                 else
--                     TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.PlayerData.source, 'error', 'See ei ole sulle!')
--                 end
--             end
--         end 
--     end
-- end)

-- local contrabandData = {}

-- AddEventHandler('QBCore:Server:PlayerLoaded', function(kPlayer)
--     if kPlayer then
--         if isGangFaction(kPlayer.PlayerData.job.name) then
--             if contrabandData[kPlayer.PlayerData.job.name] then
--                 TriggerClientEvent('kk-factions:client:drawContraband', kPlayer.PlayerData.source, contrabandData[kPlayer.PlayerData.job.name].location, contrabandData[kPlayer.PlayerData.job.name].delivery)
--             end
--         end
--     end
-- end)

-- lib.callback.register('kk-factions:recieveContrabandData', function(source)
--     local kPlayer = QBCore.Functions.GetPlayer(source)

--     if kPlayer then
--         local data = contrabandData[kPlayer.PlayerData.job.name] or false
--         return data
--     else
--         return false
--     end
-- end)

-- lib.callback.register('kk-factions:resetContraband', function(source)
--     local kPlayer = QBCore.Functions.GetPlayer(source)

--     if kPlayer then
--         if isGangFaction(kPlayer.PlayerData.job.name) then
--             contrabandData[kPlayer.PlayerData.job.name] = nil
--         end

--         return true
--     else
--         return false
--     end
-- end)

-- lib.callback.register('kk-factions:contrabandActive', function(source)
--     local kPlayer = QBCore.Functions.GetPlayer(source)

--     if kPlayer then
--         if isGangFaction(kPlayer.PlayerData.job.name) then
--             return contrabandData[kPlayer.PlayerData.job.name]
--         else
--             return false
--         end
--     else
--         return false
--     end
-- end)

-- lib.callback.register('kk-factions:addTaken', function(source)
--     local kPlayer = QBCore.Functions.GetPlayer(source)

--     if kPlayer then
--         if isGangFaction(kPlayer.PlayerData.job.name) then
--             if contrabandData[kPlayer.PlayerData.job.name] then
--                 contrabandData[kPlayer.PlayerData.job.name].taken += 1
--                 return contrabandData[kPlayer.PlayerData.job.name].taken
--             else
--                 return false
--             end
--         else
--             return false
--         end
--     else
--         return false
--     end
-- end)

-- lib.callback.register('kk-factions:addGiven', function(source)
--     local kPlayer = QBCore.Functions.GetPlayer(source)

--     if kPlayer then
--         if isGangFaction(kPlayer.PlayerData.job.name) then
--             if contrabandData[kPlayer.PlayerData.job.name] then
--                 contrabandData[kPlayer.PlayerData.job.name].given += 1
--                 return contrabandData[kPlayer.PlayerData.job.name].given
--             else
--                 return false
--             end
--         else
--             return false
--         end
--     else
--         return false
--     end
-- end)

-- lib.callback.register('kk-factions:givePackage', function(source)
--     local kPlayer = QBCore.Functions.GetPlayer(source)

--     if kPlayer then
--         if isGangFaction(kPlayer.PlayerData.job.name) then
--             if contrabandData[kPlayer.PlayerData.job.name].taken <= cfg.contrabandCount - 1 then
--                 if exports['ox_inventory']:CanCarryItem(kPlayer.PlayerData.source, 'package_gang', 1) then
--                     return exports['ox_inventory']:AddItem(kPlayer.PlayerData.source, 'package_gang', 1)
--                 else
--                     return false
--                 end
--             else
--                 return false
--             end 
--         else
--             return false
--         end 
--     else
--         return false
--     end
-- end)

-- lib.callback.register('kk-factions:packageDone', function(source, count)
--     local kPlayer = QBCore.Functions.GetPlayer(source)

--     if kPlayer then
--         if isGangFaction(kPlayer.PlayerData.job.name) then
--             if contrabandData[kPlayer.PlayerData.job.name] then
--                 contrabandData[kPlayer.PlayerData.job.name] = nil

--                 local Players = QBCore.Functions.GetPlayers()

--                 for i = 1, #Players do
--                     local player = QBCore.Functions.GetPlayer(Players[i])
--                     if player and player.PlayerData.job.name == kPlayer.PlayerData.job.name then
--                         TriggerClientEvent('kk-factions:client:removeContraband', player.PlayerData.source)
--                     end
--                 end

--                 local count = math.random(cfg.contrabandItem.count.min, cfg.contrabandItem.count.max)

--                 if exports['ox_inventory']:CanCarryItem(kPlayer.PlayerData.source, cfg.contrabandItem.name, count) then
--                     exports['ox_inventory']:AddItem(kPlayer.PlayerData.source, cfg.contrabandItem.name, count)
--                 else
--                     TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.PlayerData.source, 'error', 'Teil ei ole taskus piisavalt ruumi! Kukutasid esemed põrandale')

--                     exports['ox_inventory']:CustomDrop('Items #' .. math.random(00000, 99999), {
--                         {cfg.contrabandItem.name, count}
--                     }, GetEntityCoords(GetPlayerPed(kPlayer.PlayerData.source)))
--                 end

--                 local data = {
--                     ['embeds'] = {{
--                         ['title'] = 'Karakter: ' .. kPlayer.PlayerData.name .. '; PID: ' .. kPlayer.PlayerData.citizenid .. '; FRAKTSIOON: ' .. kPlayer.PlayerData.job.label,
--                         ['description'] = 'Lõpetas salakaubaveo!',
--                         ['color'] = 16743168
--                     }}
--                 }
-- -- PANE OMA WEBHOOK SIIA '' VAHELE
--                 PerformHttpRequest('', function(err, text, headers) end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })

--                 exports['kk-scripts']:sendLog(kPlayer.PlayerData.citizenid, 'NARKOOTIKUMID', 'Sai salakaubaga ' .. cfg.contrabandItem.name .. ' ' .. count .. 'tk.')

--                 return true
--             else
--                 return false
--             end 
--         else
--             return false
--         end 
--     else
--         return false
--     end
-- end) 

-- lib.callback.register('kk-factions:checkTakePed', function(source, index)
--     local kPlayer = QBCore.Functions.GetPlayer(source)

--     if kPlayer then
--         if isGangFaction(kPlayer.PlayerData.job.name) then
--             if contrabandData[kPlayer.PlayerData.job.name] then
--                 return contrabandData[kPlayer.PlayerData.job.name].locationId == index
--             else
--                 return false
--             end
--         else
--             return false
--         end
--     else
--         return false
--     end
-- end)

-- lib.callback.register('kk-factions:checkGivePed', function(source, index)
--     local kPlayer = QBCore.Functions.GetPlayer(source)

--     if kPlayer then
--         if isGangFaction(kPlayer.PlayerData.job.name) then
--             if contrabandData[kPlayer.PlayerData.job.name] then
--                 return contrabandData[kPlayer.PlayerData.job.name].deliveryId == index
--             else
--                 return false
--             end
--         else
--             return false
--         end
--     else
--         return false
--     end
-- end)

-- lib.callback.register('kk-factions:checkContraband', function(source, zone)
--     local kPlayer = QBCore.Functions.GetPlayer(source)

--     if kPlayer then
--         if isGangFaction(kPlayer.PlayerData.job.name) then
--             local reputation = MySQL.prepare.await('SELECT reputation FROM `gang_zones` WHERE `zone` = ? AND `faction` = ?', { zone, kPlayer.PlayerData.job.name }) or 0

--             if reputation > cfg.contrabandReputation then
--                 local area = cfg.gangZones[zone]

--                 if area.controller == kPlayer.PlayerData.job.name then
--                     if not cfg.gangZones[zone].contrabandCooldown and not contrabandData[kPlayer.PlayerData.job.name] then
--                         local data = {
--                             ['embeds'] = {{
--                                 ['title'] = 'Karakter: ' .. kPlayer.PlayerData.name .. '; PID: ' .. kPlayer.PlayerData.citizenid .. '; FRAKTSIOON: ' .. kPlayer.PlayerData.job.label,
--                                 ['description'] = 'Alustas salakaubaveoga!',
--                                 ['color'] = 16743168
--                             }}
--                         }
--         -- PANE OMA WEBHOOK SIIA '' VAHELE
--                         PerformHttpRequest('', function(err, text, headers) end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })

--                         cfg.gangZones[zone].contrabandCooldown = true

--                         contrabandData[kPlayer.PlayerData.job.name] = {
--                             taken = 0,
--                             given = 0,

--                             locationId = math.random(1, #contrabandTakePeds),
--                             deliveryId = math.random(1, #contrabandGivePeds)
--                         }

--                         contrabandData[kPlayer.PlayerData.job.name].location = contrabandTakePeds[contrabandData[kPlayer.PlayerData.job.name].locationId].coords.xyz
--                         contrabandData[kPlayer.PlayerData.job.name].delivery = contrabandGivePeds[contrabandData[kPlayer.PlayerData.job.name].deliveryId].coords.xyz

--                         local Players = QBCore.Functions.GetPlayers()

--                         for i = 1, #Players do
--                             local player = QBCore.Functions.GetPlayer(Players[i])
--                             if player and player.PlayerData.job.name == kPlayer.PlayerData.job.name then
--                                 TriggerClientEvent('kk-factions:client:drawContraband', player.PlayerData.source, contrabandData[kPlayer.PlayerData.job.name].location, contrabandData[kPlayer.PlayerData.job.name].delivery)
--                             end
--                         end

--                         return contrabandData[kPlayer.PlayerData.job.name].location
--                     else
--                         return false
--                     end
--                 else
--                     return false
--                 end 
--             else
--                 return false
--             end 
--         else
--             return false
--         end 
--     else
--         return false
--     end
-- end)