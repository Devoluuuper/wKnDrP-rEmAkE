-- local jailTimes = {}
-- local confiscatableItems = {
--     ['phone'] = {},
--     ['radio'] = {}
-- }

-- AddEventHandler(
--     "KKF.Player.Loaded",
--     function(playerId, xPlayer)
--         MySQL.Async.fetchAll(
--             "SELECT jail_time FROM users WHERE pid = @pid",
--             {
--                 ["@pid"] = xPlayer.identifier
--             },
--             function(result)
--                 if result[1] and result[1].jail_time > 0 then
--                     TriggerClientEvent("kk-jail:setJailed", xPlayer.source, result[1].jail_time, true)
--                     jailTimes[xPlayer.identifier] = tonumber(result[1].jail_time)
--                 end
--             end
--         )
--     end
-- )

-- Citizen.CreateThread(
--     function()
--         while true do
--             Citizen.Wait(5000)

--             for k, v in pairs(jailTimes) do
--                 MySQL.Async.execute(
--                     "UPDATE users SET jail_time = @time_remaining WHERE pid = @pid",
--                     {
--                         ["@pid"] = k,
--                         ["@time_remaining"] = v
--                     }
--                 )
--             end
--         end
--     end
-- )

-- RegisterNetEvent("kk-jail:updateJailed")
-- AddEventHandler(
--     "kk-jail:updateJailed",
--     function(time)
--         local src = source
--         local xPlayer = KKF.GetPlayerFromId(src)

--         if xPlayer then
--             if jailTimes[xPlayer.identifier] then
--                 if jailTimes[xPlayer.identifier] == 0 then
--                     jailTimes[xPlayer.identifier] = nil
--                     MySQL.Async.execute(
--                         "UPDATE users SET jail_time = @time_remaining WHERE pid = @pid",
--                         {
--                             ["@pid"] = xPlayer.identifier,
--                             ["@time_remaining"] = 0
--                         }
--                     )
--                     return
--                 end

--                 jailTimes[xPlayer.identifier] = time
--             end
--         end
--     end
-- )

-- AddEventHandler(
--     "kk-jail:jailPlayer",
--     function(target, time, jailer)
--         local xPlayer = KKF.GetPlayerFromId(jailer)
--         local time = KKF.Math.Round(time) * 60

--         if xPlayer then
--             if xPlayer.job.name == 'police' and xPlayer.job.onDuty then
--                 local xTarget = KKF.GetPlayerFromId(target)

--                 if xTarget then
--                     TriggerClientEvent("kk-jail:setJailed", xTarget.source, time, false)
--                     jailTimes[xTarget.identifier] = tonumber(time)

--                     exports['kk-scripts']:sendLog(xPlayer.identifier, 'VANGISTAMINE', 'Vangistas ajaks ' .. KKF.Math.Round(time / 60) .. ' min.', xTarget.identifier)
--                 end
--             end
--         end
--     end
-- )

-- RegisterNetEvent("kk-jail:jailPlayerId")
-- AddEventHandler(
--     "kk-jail:jailPlayerId",
--     function(target, time)
--         local xPlayer = KKF.GetPlayerFromId(source)
--         local time = KKF.Math.Round(time)

--         if xPlayer then
--             if xPlayer.isAdmin() then
--                 local xTarget = KKF.GetPlayerFromId(target)

--                 if xTarget then
--                     TriggerClientEvent("kk-jail:setJailed", xTarget.source, time, false)
--                     jailTimes[xTarget.identifier] = tonumber(time)

--                     exports['kk-scripts']:sendLog(xPlayer.identifier, 'VANGISTAMINE', 'Vangistas ajaks ' .. KKF.Math.Round(time / 60) .. 'min.', xTarget.identifier)

--                     TriggerClientEvent('kk-admin:client:showNotify', xPlayer.source, "Tegevus edukas!", 'Vangistasite isiku ID ' .. GetPlayerName(xTarget.source) ..' ajaks '.. time ..' min.', "success")
--                 else
--                     TriggerClientEvent('kk-admin:client:showNotify', xPlayer.source, "Viga!", 'Valitud mängija ei viibi enam serveris.', "error")
--                 end
--             end
--         end
--     end
-- )

-- RegisterNetEvent('kk-jail:server:confiscateItems', function()
--     local src = source
--     local xPlayer = KKF.GetPlayerFromId(src)

--     if xPlayer then
--         local currentItems = json.decode(GetResourceKvpString('confiscatedItems_' .. xPlayer.identifier)) or {}

--         for k,v in pairs(confiscatableItems) do
--             local count = xPlayer.getItem(k).count

--             if count > 0 then
--                 xPlayer.removeInventoryItem(k, count)

--                 if not currentItems[k] then
--                     currentItems[k] = count
--                 else
--                     currentItems[k] += count
--                 end
--             end
--         end

--         SetResourceKvp('confiscatedItems_' .. xPlayer.identifier, json.encode(currentItems))
--     end
-- end)

-- RegisterNetEvent('kk-jail:server:recieveConfiscatedItems', function()
--     local src = source
--     local xPlayer = KKF.GetPlayerFromId(src)

--     if xPlayer then
--         if not jailTimes[xPlayer.identifier] then
--             local currentItems = json.decode(GetResourceKvpString('confiscatedItems_' .. xPlayer.identifier)) or {}

--             for k,v in pairs(currentItems) do
--                 if xPlayer.canCarryItem(k, v) then
--                     xPlayer.addInventoryItem(k, v)

--                     currentItems[k] = nil
--                 else
--                     TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Ese ' .. KKF.GetItemLabel(k) .. ' ' .. v .. 'tk ei mahu teile tasku!')
--                 end
--             end

--             SetResourceKvp('confiscatedItems_' .. xPlayer.identifier, json.encode(currentItems))
--         else
--             TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Vangis olles ei saa esemeid tagastada!')
--         end
--     end
-- end)
-- --ajail

-- local AJailTimes = {}

-- exports('aJailed', function(id)
--     return AJailTimes[id]
-- end)

-- AddEventHandler(
--     "KKF.Player.Loaded",
--     function(playerId, xPlayer)
--         MySQL.Async.fetchAll(
--             "SELECT ajail FROM users WHERE pid = @pid",
--             {
--                 ["@pid"] = xPlayer.identifier
--             },
--             function(result)
--                 if result[1] and result[1].ajail > 0 then
--                     TriggerClientEvent("kk-AJail:setAJailed", xPlayer.source, result[1].ajail, true)
--                     AJailTimes[xPlayer.identifier] = tonumber(result[1].ajail)
--                 end
--             end
--         )
--     end
-- )

-- Citizen.CreateThread(
--     function()
--         while true do
--             Citizen.Wait(5000)

--             for k, v in pairs(AJailTimes) do
--                 MySQL.Async.execute(
--                     "UPDATE users SET ajail = @time_remaining WHERE pid = @pid",
--                     {
--                         ["@pid"] = k,
--                         ["@time_remaining"] = v
--                     }
--                 )
--             end
--         end
--     end
-- )

-- RegisterNetEvent("kk-AJail:updateAJailed")
-- AddEventHandler(
--     "kk-AJail:updateAJailed",
--     function(time)
--         local src = source
--         local xPlayer = KKF.GetPlayerFromId(src)

--         if xPlayer then
--             if AJailTimes[xPlayer.identifier] then
--                 if AJailTimes[xPlayer.identifier] == 0 then
--                     AJailTimes[xPlayer.identifier] = nil
--                     MySQL.Async.execute(
--                         "UPDATE users SET ajail = @time_remaining WHERE pid = @pid",
--                         {
--                             ["@pid"] = xPlayer.identifier,
--                             ["@time_remaining"] = 0
--                         }
--                     )
--                     return
--                 end

--                 AJailTimes[xPlayer.identifier] = time
--             end
--         end
--     end
-- )

-- RegisterNetEvent("kk-AJail:AJailPlayerId")
-- AddEventHandler(
--     "kk-AJail:AJailPlayerId",
--     function(target, reason, time)
--         local xPlayer = KKF.GetPlayerFromId(source)
--         local time = KKF.Math.Round(time)

--         if xPlayer then
--             if xPlayer.isAdmin() then
--                 local xTarget = KKF.GetPlayerFromId(target)

--                 if xTarget then
--                     TriggerClientEvent("kk-AJail:setAJailed", xTarget.source, time, false)
--                     AJailTimes[xTarget.identifier] = tonumber(time)

--                     exports['kk-scripts']:sendLog(xPlayer.identifier, 'A-TEAM', 'Vangistas ajaks ' .. KKF.Math.Round(time / 60) .. 'min; Põhjus: ' .. reason .. ';', xTarget.identifier)
--                     TriggerClientEvent("chatMessage", -1, 'AJAIL', 1, GetPlayerName(xPlayer.source) .. ' vangistas isiku ' .. GetPlayerName(xTarget.source) .. '; Põhjus: ' .. reason ..'; Aeg: '.. KKF.Math.Round(time / 60) .. ' minutit')
-- 					MySQL.update('INSERT INTO ucp_punishments (steamhex, punishment, description, punisher, timeat) VALUES (?, ?, ?, ?, ?)', { xTarget.steamid, 'AJAIL', reason .. '; Aeg: '.. KKF.Math.Round(time / 60) .. ' minutit' or '', GetPlayerName(xPlayer.source), os.date('%Y-%m-%d %X') })
--                     TriggerClientEvent('kk-admin:client:showNotify', xPlayer.source, "Tegevus edukas!", 'Panite isiku ID ' .. xTarget.source ..' admin vanglasse ajaks '.. time ..' min.', "success")
--                 else
--                     TriggerClientEvent('kk-admin:client:showNotify', xPlayer.source, "Viga!", 'Valitud mängija ei viibi enam serveris.', "error")
--                 end
--             end
--         end
--     end
-- )







----------------------- MUL EI OLEVAJA SEDA ISTTA