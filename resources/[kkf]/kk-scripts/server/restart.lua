-- local actions     = {}
-- local lastTime = nil
-- local restartTimes = {
--     {h = 15, m = 50},
--     {h = 7, m = 50}
-- }

-- local function addAction(h, m, cb)
--     actions[#actions + 1] = {
-- 		h  = h,
-- 		m  = m,
-- 		cb = cb
-- 	}
-- end

-- exports('addAction', addAction)

-- local function getTime()
-- 	local timestamp = os.time()

-- 	return {d = os.date('*t', timestamp).wday, h = tonumber(os.date('%H', timestamp)), m = tonumber(os.date('%M', timestamp))}
-- end

-- lastTime = getTime()

-- local function onTime(d, h, m)
-- 	for i=1, #actions, 1 do
-- 		if actions[i].h == h and actions[i].m == m then
-- 			actions[i].cb(d, h, m)
-- 		end
-- 	end
-- end

-- SetInterval(function()
-- 	local time = getTime()

-- 	if time.h ~= lastTime.h or time.m ~= lastTime.m then
-- 		onTime(time.d, time.h, time.m)
-- 		lastTime = time
-- 	end
-- end, 60000)

-- local function kickPlayers()
--     local players = GetPlayers()

--     for i, v in pairs(players) do
--         DropPlayer(v, '[KICK]: Toimumas on serveri restart!')
--     end
-- end

-- local function triggerRestart()
--     ESX.SavePlayers(); kickPlayers(); Wait(750)
--     io.popen('start serverStarter.bat')
--     Wait(300); os.exit()
-- end

-- local function doRestart()
--     TriggerClientEvent('chatMessage', -1, 'SÜSTEEM', 3, 'Serveri restart toimub 10 minuti pärast.')
--     Wait(5 * 60000)

--     TriggerClientEvent('chatMessage', -1, 'SÜSTEEM', 3, 'Serveri restart toimub 5 minuti pärast.')
--     Wait(60000)

--     TriggerClientEvent('chatMessage', -1, 'SÜSTEEM', 3, 'Serveri restart toimub 4 minuti pärast.')
--     Wait(60000)

--     TriggerClientEvent('chatMessage', -1, 'SÜSTEEM', 3, 'Serveri restart toimub 3 minuti pärast.')
--     Wait(60000)

--     TriggerClientEvent('chatMessage', -1, 'SÜSTEEM', 3, 'Serveri restart toimub 2 minuti pärast.')
--     Wait(60000)

--     TriggerClientEvent('chatMessage', -1, 'SÜSTEEM', 3, 'Serveri restart toimub 1 minuti pärast.')
--     Wait(60000)
    
--     triggerRestart()
-- end

-- CreateThread(function()
--     for k,v in pairs(restartTimes) do
--         addAction(v.h, v.m, function()
--             doRestart()
--         end) 
--     end
-- end)

-- RegisterCommand('serverRestart', function(source)
--     local xPlayer = ESX.GetPlayerFromId(source)

--     if xPlayer then
--         if xPlayer.adminLevel > 4 then
--             doRestart()
--         else
--             TriggerClientEvent('chatMessage', xPlayer.source, 'SÜSTEEM', 1, 'Teil ei ole piisavalt õigusi.')
--         end
--     else
--         if source == 0 then
--             doRestart()
--         end
--     end
-- end)