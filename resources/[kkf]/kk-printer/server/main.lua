local ox_inventory = exports.ox_inventory

RegisterNetEvent('kk-printer:server:savePaperDocument', function(nimi, url)
    local xPlayer = KKF.GetPlayerFromId(source)

    if xPlayer then
        local info = { documentName = nimi, pid = xPlayer.identifier }
        print(json.encode(info))

        if url ~= nil then
            info.url = url; ox_inventory:RemoveItem(xPlayer.source, 'a4', 1)
            ox_inventory:AddItem(xPlayer.source, 'document', 1, info)

            exports['kk-scripts']:sendLog(xPlayer.identifier, 'MUU', 'Printis dokumendi URL: ' .. url)
        end
    end
end)