if Config.Framework ~= "KKF" then
    return
end

while not KKF do
    Wait(500)
    debugprint("Item: Waiting for KKF to load")
end

---@param itemName string
---@return boolean
function HasItem(itemName)
    if GetResourceState("ox_inventory") == "started" then
        return (exports.ox_inventory:Search("count", itemName) or 0) > 0
    elseif GetResourceState("qs-inventory") == "started" then
        return (exports["qs-inventory"]:Search(itemName) or 0) > 0
    end

    if KKF.SearchInventory then
        return (KKF.SearchInventory(itemName, 1) or 0) > 0
    end

    local inventory = KKF.GetPlayerData()?.inventory

    if not inventory then
        infoprint("warning", "Unsupported inventory, tell the inventory author to add support for it.")
        return false
    end

    debugprint("inventory", inventory)

    for i = 1, #inventory do
        local item = inventory[i]

        if item.name == itemName and item.count > 0 then
            return true
        end
    end

    return false
end

RegisterNetEvent("KKF:removeInventoryItem", function(item, count)
    if not Config.Item.Require or Config.Item.Unique or item ~= Config.Item.Name or count > 0 then
        return
    end

    Wait(500)

    if not HasPhoneItem() then
        OnDeath()
    end
end)
