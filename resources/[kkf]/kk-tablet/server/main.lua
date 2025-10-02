local ox_inventory = exports.ox_inventory


lib.callback.register('kk-tablet:loadApps', function(source)
    local xPlayer = KKF.GetPlayerFromId(source)
    if not xPlayer then
        return false
    end

    local apps = {
        droppy = false,
        boosting = false,
        selling = false,
        racing = false,
    }

    local droppyStickCount = ox_inventory:GetItemCount(source, 'droppy_stick', nil, false) or 0
    local sellingStickCount = ox_inventory:GetItemCount(source, 'selling_stick', nil, false) or 0

    
    if droppyStickCount > 0 then
        apps.droppy = true
    end

    if sellingStickCount > 0 then
        apps.selling = true
    end

    return apps
end)
