-- local players = {}

-- RegisterNetEvent('kk-scripts:server:toggleId', function(status)
--     local src = source
--     players[src] = status

--     -- Saada kõigile infot, kas mängija ID peab olema näidatud või mitte
--     TriggerClientEvent('kk-scripts:client:toggleId', -1, src, status)
-- end)

-- -- Kui mängija lahkub, eemalda ta listist ja uuenda kõigil
-- AddEventHandler('playerDropped', function()
--     local src = source
--     players[src] = nil
--     TriggerClientEvent('kk-scripts:client:toggleId', -1, src, false)
-- end)

-- -- Kui mängija liitub, saada talle kõik hetkel aktiivsed
-- AddEventHandler('playerJoining', function(src)
--     for id, status in pairs(players) do
--         if status then
--             TriggerClientEvent('kk-scripts:client:toggleId', src, id, true)
--         end
--     end
-- end)
 
