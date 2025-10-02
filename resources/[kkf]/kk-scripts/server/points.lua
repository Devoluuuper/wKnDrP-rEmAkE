-- SetInterval(function()
--     local xPlayers = KKF.GetPlayers()

--     for i=1, #xPlayers, 1 do
--         local xPlayer = KKF.GetPlayerFromId(xPlayers[i])

--         if not exports['kk-scripts']:aJailed(xPlayer.identifier) then
--             if GetResourceKvpInt('points_' .. xPlayer.steamid) == 60 then
--                 MySQL.Async.fetchAll('SELECT * FROM ucp_users WHERE steamhex = ?', { xPlayer.steamid }, function(result)
--                     MySQL.Sync.execute('UPDATE ucp_users SET points = ? WHERE steamhex = ?', { result[1].points + 1, xPlayer.steamid })
--                     MySQL.Sync.execute('UPDATE ucp_users SET gamehours = ? WHERE steamhex = ?', { result[1].gamehours + 1, xPlayer.steamid })
--                 end)

--                 SetResourceKvpInt('points_' .. xPlayer.steamid, 0)
--             else
--                 SetResourceKvpInt('points_' .. xPlayer.steamid, GetResourceKvpInt('points_' .. xPlayer.steamid) + 1)
--             end
--         end
--     end
-- end, 60000)