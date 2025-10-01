-- RegisterServerEvent('kk-documents:server:showId', function(pid, type, doe)
--     local src = source
--     local xPlayer = ESX.GetPlayerFromId(src)
--     if xPlayer then
--         MySQL.Async.fetchAll('SELECT profilepic FROM users WHERE pid = ?', {xPlayer.identifier}, function(res)
--             local data = {
--                 ['firstname'] = xPlayer.get('firstName'),
--                 ['lastname'] = xPlayer.get('lastName'),
--                 ['sex'] = xPlayer.get('sex') == 'm' and 'M/M' or xPlayer.get('sex') == 'f' and 'N/F',
--                 ['dob'] = xPlayer.get('dateofbirth'),
--                 ['pid'] = xPlayer.identifier,
--                 ['picture'] = res[1] and res[1].profilepic or nil,
--                 ['dmv'] = xPlayer.licenses['dmv']
--             }

--             if type == 'fishing_id' then
--                 data['doe'] = doe
--             end

--             TriggerClientEvent('kk-documents:client:showId', -1, targetid, data, type)
--         end)
--     end
-- end)


RegisterServerEvent('kk-documents:server:showId', function(pid, type, doe)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if xPlayer then
        local srcPed = GetPlayerPed(src)
        local srcCoords = GetEntityCoords(srcPed)

        local playerId = lib.getClosestPlayer(srcCoords, 7.5, false)
        
        if playerId then
            MySQL.Async.fetchAll('SELECT profilepic FROM users WHERE pid = ?', {xPlayer.identifier}, function(res)
                local data = {
                    ['firstname'] = xPlayer.get('firstName'),
                    ['lastname'] = xPlayer.get('lastName'),
                    ['sex'] = xPlayer.get('sex') == 'm' and 'M/M' or xPlayer.get('sex') == 'f' and 'N/F',
                    ['dob'] = xPlayer.get('dateofbirth'),
                    ['pid'] = xPlayer.identifier,
                    ['picture'] = res[1] and res[1].profilepic or nil,
                    ['dmv'] = xPlayer.licenses['dmv']
                }

                if type == 'fishing_id' then
                    data['doe'] = doe
                end
                TriggerClientEvent('kk-documents:client:showId', -1, playerId, data, type)
            end)
        else
            print("No player found within range.")
        end
    end
end)



RegisterNetEvent('KKF.Player.Loaded', function(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer then
        -- Add metadata to the player's inventory for both items
        exports.ox_inventory:SetMetadata(src, 'idcard', { pid = xPlayer.identifier, name = xPlayer.name, sex = xPlayer.get('sex'), dob = xPlayer.get('dateofbirth') })
        -- exports.ox_inventory:SetMetadata(src, 'fishing_id', { pid = xPlayer.identifier, doe = '03-02-2025' })
    end
end)
