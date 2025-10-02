local ox_inventory = exports.ox_inventory

RegisterServerEvent('kk-clotheshop:server:sellStuff', function(shopId)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)

    if xPlayer then 
        local shopData = cfg.shops[shopId] 
        
        local playerCoords = xPlayer.getCoords(true)
        local shopCoords = shopData.target.coords

        local distance = #(playerCoords - shopCoords)
        local maxDistance = 10

        if distance <= maxDistance then
            for k, v in pairs(shopData.items) do
                local xItem = ox_inventory:GetItem(xPlayer.source, k)

                if xItem then
                    if tonumber(xItem.count) > 0 then
                        local reward = 0
                        
                        for i = 1, xItem.count do
                            reward = reward + v
                        end
                        
                        KKF.UpdateCheck(xPlayer.source, 'add', reward)
        
                        exports['kk-scripts']:sendLog(xPlayer.identifier, 'TÖÖD', 'Müüs eseme ' .. KKF.GetItemLabel(k) .. ' ' .. xItem.count .. 'tk hinnaga ' .. reward .. '.')
                        ox_inventory:RemoveItem(xPlayer.source, k, xItem.count)
                    end
                end
            end
        else
            print("[kk-clothejob] Sellstuff Exploit. Mängia id: "..xPlayer.source.. 'PID: '..xPlayer.identifier)
            exports['kk-scripts']:sendLog(xPlayer.identifier, 'EXPLOIT', '[kk-clothejob] Sellstuff Exploit; Mängija ID: ' .. xPlayer.source .. '; PID:' .. xPlayer.identifier)
            DropPlayer(src, "[kk-clothejob] Sellstuff Exploit.")
        end
    end 
end)
