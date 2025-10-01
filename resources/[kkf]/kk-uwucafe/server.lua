local ox_inventory = exports.ox_inventory

AddEventHandler('onServerResourceStart', function(resourceName)
    if resourceName == 'ox_inventory' or resourceName == GetCurrentResourceName() then
        for k,v in pairs(cfg.points) do
            if v.type == 'plate' then
                local stashId = 'uwucafe_tray_' .. k
                ox_inventory:RegisterStash(stashId, 'Uwu Cafe', 5, 20000, false)
            end
        end
    end
end)
