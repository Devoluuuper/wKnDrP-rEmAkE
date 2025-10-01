local accessCheckCache = {}
local accessCheckCacheTimer = {}
local securedAccesses = {}

function setSecuredAccesses(pAccesses, pType)
    securedAccesses[pType] = pAccesses
    accessCheckCache[pType] = {}
    accessCheckCacheTimer[pType] = {}
end

function clearAccessCache()
    for accessType, _ in pairs(accessCheckCache) do
        accessCheckCacheTimer[accessType] = {}
    end
end

CreateThread(function()
	ESX.PlayerData = ESX.GetPlayerData()
end)

AddEventHandler("ox_inventory:updateInventory", clearAccessCache)

RegisterNetEvent('KKF.Player.Loaded', function(xPlayer)
	ESX.PlayerData = xPlayer; clearAccessCache()
end)

RegisterNetEvent('KKF.Player.Unloaded', function() 
	ESX.PlayerData = {}; clearAccessCache()
end)

RegisterNetEvent('KKF.Player.JobUpdate', function(job)
	ESX.PlayerData.job = job; clearAccessCache()
end)

RegisterNetEvent('KKF.Player.DutyChange', function(value)
	ESX.PlayerData.job.onDuty = value; clearAccessCache()
end)

local function factionAccess(factions)
    local returnable = false

    for k,v in pairs(factions) do
        if (ESX.PlayerData.job.name == k and v.dutyRequired and ESX.PlayerData.job.onDuty) or (not v.dutyRequired and ESX.PlayerData.job.name == k) or (ESX.PlayerData.job.name == k and v.dutyRequired and ESX.PlayerData.job.onDuty and v.permissionNeeded and ESX.PlayerData.job.permissions.doors) or (not v.dutyRequired and ESX.PlayerData.job.name == k and not v.permissionNeeded) then
            returnable = true
        end
    end

    return returnable
end

function hasAccess(pId, pType)
    if accessCheckCacheTimer[pType][pId] ~= nil and accessCheckCacheTimer[pType][pId] + 60000 > GetGameTimer() then -- 1 minute
        return accessCheckCache[pType][pId] == true
    end

    accessCheckCacheTimer[pType][pId] = GetGameTimer()
    local secured = securedAccesses[pType][pId]
    if not secured then return end

    if secured.forceUnlocked then
        return false
    end 

    if next(secured.access) then
        if secured.access.factions then
            if factionAccess(secured.access.factions) then
                accessCheckCache[pType][pId] = true
                return true
            end
        end

        if secured.access.item then 
            if exports.ox_inventory:GetItemCount(secured.access.item.name, secured.access.item.metadata) > 0 then
                accessCheckCache[pType][pId] = true
                return true
            end
        end
    end

    accessCheckCache[pType][pId] = false
    return false
end