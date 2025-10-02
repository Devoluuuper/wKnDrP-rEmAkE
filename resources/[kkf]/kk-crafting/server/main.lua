local ox_inventory = exports.ox_inventory

lib.callback.register('kk-crafting:craftingSuccess', function(source, CraftItem)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = nil
    
    if xPlayer then
        local item = Config.Items[CraftItem]

        for itemname, v in pairs(item.needs) do
            xPlayer.removeInventoryItem(itemname, v)
        end
        if xPlayer.canCarryItem(item.item, item.amount) then
            if string.upper(item.item):find('WEAPON_') then
                ox_inventory:AddItem(xPlayer.source, item.item, item.amount, {registered = false})
            else
                xPlayer.addInventoryItem(item.item, item.amount)
            end
        else
            exports.ox_inventory:CustomDrop('Craftitud esemed', {
                {item.item, item.amount}
            }, GetEntityCoords(GetPlayerPed(xPlayer.source)))
            TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'info', 'Teie taskud on täis! Esemed kukkusid põrandale.')
        end
        
        exports['kk-scripts']:sendLog(xPlayer.identifier, 'TÖÖD', 'Ehitas eseme ' .. KKF.GetItemLabel(item.item) ..' '.. item.amount..'tk.')
        exports['kk-skills']:AddSkillProgress(src, item.skill.name, item.skill.progress)
        returnable = true
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)


lib.callback.register('kk-crafting:hasTheItems', function(source, CraftItem)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        local item = Config.Items[CraftItem]
        for itemname, v in pairs(item.needs) do
            if ox_inventory:GetItem(xPlayer.source, itemname).count < v then
                returnable = false
            end
        end

        if returnable == nil then returnable = true end
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)
