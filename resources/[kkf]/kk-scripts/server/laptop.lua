-- KKF.RegisterUsableItem('laptop', function(source)
--     local xPlayer = KKF.GetPlayerFromId(source)

--     if xPlayer then
--         TriggerClientEvent('kk-scripts:client:searchCoins', xPlayer.source)
--     end
-- end)

-- RegisterServerEvent('kk-scripts:recieveCoins', function()
--     local xPlayer = KKF.GetPlayerFromId(source)

--     if xPlayer then
--         if xPlayer.hasItem('laptop') then
--             local chance = math.random(1, 1000)

--             if chance < 350 then
--                 local amount = math.random(1, 5)
--                 exports['kk-phone']:updateCoins(xPlayer.source, 'add', amount)
--                 TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'success', 'Leidsite arvutist ' .. amount .. ' B-Coini!')
--             else
--                 TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Te ei leidnud midagi!')
--             end

--             xPlayer.removeInventoryItem('laptop', 1)
--         end
--     end
-- end)

--- POLE VAJA