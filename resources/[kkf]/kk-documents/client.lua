RegisterNetEvent("kk-documents:client:showId", function(targetid, data, type)
    if LocalPlayer.state.isLoggedIn then
		local person_src = targetid
        local targetid = GetPlayerFromServerId(person_src)
        local targetPed = GetPlayerPed(targetid)
        local myCoords = GetEntityCoords(PlayerPedId())
        local targetCoords = GetEntityCoords(targetPed)

        if targetid ~= -1 then
            if #(myCoords - targetCoords) <= 7.5 then
                SendNUIMessage({action = 'show', data = data, type = type})
            end
        end
    end
end)

-- RegisterNetEvent("kk-documents:client:showId", function(targetid, data, type)
--     if LocalPlayer.state.isLoggedIn then
--         local person_src = targetid
--         local targetid = GetPlayerFromServerId(person_src)
--         local targetPed = GetPlayerPed(targetid)
--         local myCoords = GetEntityCoords(PlayerPedId())
--         local targetCoords = GetEntityCoords(targetPed)

--         if targetid ~= -1 then
--             -- Check if the target is the player themselves
--             if person_src == GetPlayerServerId(PlayerId()) then
--                 -- Show the ID to yourself
--                 SendNUIMessage({action = 'show', data = data, type = type})
--             else
--                 -- Check if the target is within 7.5 meters
--                 if #(myCoords - targetCoords) <= 7.5 then
--                     SendNUIMessage({action = 'show', data = data, type = type})
--                 end
--             end
--         end
--     end
-- end)

RegisterNetEvent('KKF.Player.Loaded', function()
    exports.ox_inventory:displayMetadata({
        name = 'Nimi',
        sex = 'Sugu',
        dob = 'Sünnikuupäev',
    })
end)
