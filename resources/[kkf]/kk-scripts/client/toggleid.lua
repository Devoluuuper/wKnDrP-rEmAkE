-- local players = {}

-- local function DrawText3D(x, y, z, text)
--     local onScreen, _x, _y = World3dToScreen2d(x, y, z)
--     local px, py, pz = table.unpack(GetGameplayCamCoords())
--     local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)

--     local scale = (1 / dist) * 2
--     local fov = (1 / GetGameplayCamFov()) * 100
--     local scale = scale * fov

--     if onScreen then
--         SetTextScale(0.0 * scale, 0.55 * scale)
--         SetTextFont(0)
--         SetTextProportional(1)
--         SetTextColour(red, green, blue, 255)
--         SetTextDropshadow(0, 0, 0, 0, 255)
--         SetTextEdge(2, 0, 0, 0, 150)
--         SetTextDropShadow()
--         SetTextOutline()
--         SetTextEntry('STRING')
--         SetTextCentre(1)
--         AddTextComponentString(text)
--         World3dToScreen2d(x, y, z, 0)
--         DrawText(_x, _y)
--     end
-- end

-- RegisterNetEvent('kk-scripts:client:toggleId', function(id, status)
--     if status then
--         if cache.serverId ~= id then
--             players[id] = true
--         end
--     else
--         players[id] = false
--     end
-- end)

-- CreateThread(function()
--     while true do
--         local activePlayers = GetActivePlayers()
--         local myPosition = GetEntityCoords(cache.ped)

-- 		for _, v in pairs(activePlayers) do
--             local serverId = GetPlayerServerId(v)

--             if not Player(serverId).state.spectating then
--                 if players[serverId] then
--                     if Player(serverId).state.isLoggedIn then
--                         local coords = GetEntityCoords(GetPlayerPed(v))

--                         if #(myPosition - coords) < 30 then
--                             serverId = serverId .. ' ~s~| ~r~' .. Player(serverId).state.identifier or '000'

--                             KKF.Functions.DrawText3D(vec3(coords.x, coords.y, coords.z + 1.0), NetworkIsPlayerTalking(v) == 1 and '~b~' .. serverId .. '~s~' or '~g~' .. serverId .. '~s~')
--                         end
--                     end
--                 end
--             end
-- 		end

-- 		if IsControlPressed(0, 121) then
--             for _, v in pairs(activePlayers) do
--                 local serverId = GetPlayerServerId(v)

--                 if Player(serverId).state.isLoggedIn then
--                     if (not Player(serverId).state.spectating or serverId == cache.serverId) then
--                         local coords = GetEntityCoords(GetPlayerPed(v))

--                         if #(myPosition - coords) < 30 then
--                             serverId = serverId .. ' ~s~| ~r~' .. Player(serverId).state.identifier or '000'

--                             KKF.Functions.DrawText3D(vec3(coords.x, coords.y, coords.z + 1.0), NetworkIsPlayerTalking(v) == 1 and '~b~' .. serverId .. '~s~' or '~w~' .. serverId .. '~s~')
--                         end
--                     end
--                 end
-- 			end
-- 		end
		
-- 		if IsControlJustPressed(0, 121) then
-- 			TriggerServerEvent('kk-scripts:server:toggleId', true)
-- 		elseif IsControlJustReleased(0, 121) then
-- 			TriggerServerEvent('kk-scripts:server:toggleId', false)
-- 		end

--         Wait(0)
--     end
-- end) 


---- MA EI TAHA ID_checki