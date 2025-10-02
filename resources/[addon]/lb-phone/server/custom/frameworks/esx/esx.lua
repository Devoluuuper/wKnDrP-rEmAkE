if Config.Framework ~= "KKF" then
    return
end

debugprint("Loading KKF")

local export, obj = pcall(function()
    return exports['kk-core']:getSharedObject()
end)

if export then
    KKF = obj
else
    TriggerEvent("KKF:getSharedObject", function(obj)
        KKF = obj
    end)
end

debugprint("KKF loaded")

---@param source number
---@return string | nil
function GetIdentifier(source)
    return KKF.GetPlayerFromId(source)?.identifier
end

---@param identifier string
---@return number?
function GetSourceFromIdentifier(identifier)
    local xPlayer = KKF.GetPlayerFromIdentifier(identifier)

    if xPlayer then
        return xPlayer.source
    end
end

---@return boolean
function IsAdmin(source)
    local xPlayer = KKF.GetPlayerFromId(source)
    local isAdmin = xPlayer?.getGroup() == "superadmin"

    if not isAdmin then
        return IsPlayerAceAllowed(source, "command.lbphone_admin") == 1
    end

    return isAdmin
end

---@param source number
---@param itemName string
function HasItem(source, itemName)
    if GetResourceState("ox_inventory") == "started" then
        return (exports.ox_inventory:Search(source, "count", itemName) or 0) > 0
    elseif GetResourceState("qs-inventory") == "started" then
        return (exports["qs-inventory"]:GetItemTotalAmount(source, itemName) or 0) > 0
    end

    local xPlayer = KKF.GetPlayerFromId(source)

    return xPlayer.getInventoryItem(itemName).count > 0
end

---Register an item as usable
---@param item string
---@param cb function
function CreateUsableItem(item, cb)
    KKF.RegisterUsableItem(item, cb)
end

---Get a player's character name
---@param source any
---@return string # Firstname
---@return string # Lastname
function GetCharacterName(source)
    local xPlayer = KKF.GetPlayerFromId(source)
    local firstName, lastName

    if xPlayer.get and xPlayer.get("firstName") and xPlayer.get("lastName") then
        firstName = xPlayer.get("firstName")
        lastName = xPlayer.get("lastName")
    else
        local name = MySQL.single.await("SELECT `firstname`, `lastname` FROM `users` WHERE `identifier` = ?", { GetIdentifier(source) })

        firstName = name?.firstname or GetPlayerName(source)
        lastName = name?.lastname or ""
    end

    return firstName, lastName
end
