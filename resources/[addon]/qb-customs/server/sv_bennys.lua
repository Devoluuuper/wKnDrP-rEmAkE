-----------------------
----   Variables   ----
-----------------------
local RepairCosts = {}

-----------------------
----   Functions   ----
-----------------------

local function IsVehicleOwned(plate)
    local retval = false
    local result = MySQL.Sync.fetchScalar('SELECT plate FROM user_vehicles WHERE plate = ?', {plate})

    if result then
        retval = true
    end

    return retval
end

local function IsFakePlated(plate)
    local retval = false
    local result = MySQL.Sync.fetchScalar('SELECT fakeplate FROM user_vehicles WHERE fakeplate = ?', {plate})

    if result then
        retval = true
    end

    return retval
end

-----------------------
----   Threads     ----
-----------------------

-----------------------
---- Server Events ----
-----------------------

AddEventHandler("playerDropped", function()
	local source = source
    RepairCosts[source] = nil
end)

local function canOpen(job, currentStation)
    local restrictionData = Config.Locations[currentStation]['restrictions']

    if type(restrictionData.job) == "table" then
        for _,restrictedJob in ipairs(restrictionData.job) do
            if restrictedJob == job.name and job.onDuty then return true end
        end
    else
        if restrictionData.job == "any" or restrictionData.job == job.name and job.onDuty or not restrictionData.job then return true end
    end

    return false
end

RegisterNetEvent('qb-customs:server:attemptPurchase', function(type, upgradeLevel, currentStation)
    local xPlayer = KKF.GetPlayerFromId(source)

    if xPlayer then
        if canOpen(xPlayer.job, currentStation) then
            if type == 'repair' then
                local repairCost = RepairCosts[source] or 600

                TriggerEvent('Society.GetMoney', xPlayer.job.name, function(balance)
                    if balance >= repairCost then
                        TriggerClientEvent('qb-customs:client:purchaseSuccessful', source)
                        TriggerEvent('Society.RemoveMoney', xPlayer.job.name, repairCost)

                        exports['kk-scripts']:sendSocietyLog(xPlayer.source, 'SÕIDUKI TUUNIMINE', 'Parandas sõiduki $' .. repairCost .. ' eest.')
                        exports['kk-scripts']:sendLog(xPlayer.identifier, 'SÕIDUKI TUUNIMINE', 'Parandas sõiduki $' .. repairCost .. ' eest.')
                    else
                        TriggerClientEvent('qb-customs:client:purchaseFailed', source)
                    end
                end)
            elseif type == 'performance' or type == 'turbo' then
                TriggerEvent('Society.GetMoney', xPlayer.job.name, function(balance)
                    if balance >= vehicleCustomisationPrices[type].prices[upgradeLevel] then
                        TriggerClientEvent('qb-customs:client:purchaseSuccessful', source)
                        TriggerEvent('Society.RemoveMoney', xPlayer.job.name, vehicleCustomisationPrices[type].prices[upgradeLevel])

                        exports['kk-scripts']:sendSocietyLog(xPlayer.source, 'SÕIDUKI TUUNIMINE', 'Tuunis sõidukit $' .. vehicleCustomisationPrices[type].prices[upgradeLevel] .. ' eest.')
                        exports['kk-scripts']:sendLog(xPlayer.identifier, 'SÕIDUKI TUUNIMINE', 'Tuunis sõidukit $' .. vehicleCustomisationPrices[type].prices[upgradeLevel] .. ' eest.')
                    else
                        TriggerClientEvent('qb-customs:client:purchaseFailed', source)
                    end
                end)
            else
                TriggerEvent('Society.GetMoney', xPlayer.job.name, function(balance)
                    if balance >= vehicleCustomisationPrices[type].price then
                        TriggerClientEvent('qb-customs:client:purchaseSuccessful', source)
                        TriggerEvent('Society.RemoveMoney', xPlayer.job.name, vehicleCustomisationPrices[type].price)

                        exports['kk-scripts']:sendSocietyLog(xPlayer.source, 'SÕIDUKI TUUNIMINE', 'Tuunis sõidukit $' .. vehicleCustomisationPrices[type].price .. ' eest.')
                        exports['kk-scripts']:sendLog(xPlayer.identifier, 'SÕIDUKI TUUNIMINE', 'Tuunis sõidukit $' .. vehicleCustomisationPrices[type].price .. ' eest.')
                    else
                        TriggerClientEvent('qb-customs:client:purchaseFailed', source)
                    end
                end)
            end
        else
            TriggerClientEvent('qb-customs:client:purchaseFailed', source)
        end
    end
end)

RegisterNetEvent('qb-customs:server:updateRepairCost', function(cost)
    local source = source
    RepairCosts[source] = cost
end)

RegisterNetEvent("qb-customs:server:updateVehicle", function(myCar)
    if IsVehicleOwned(myCar.plate) then
        MySQL.Async.execute('UPDATE user_vehicles SET vehicle = ? WHERE plate = ?', {json.encode(myCar), myCar.plate})
    elseif IsFakePlated(myCar.plate) then
        MySQL.Async.execute('UPDATE user_vehicles SET vehicle = ? WHERE fakeplate = ?', {json.encode(myCar), myCar.plate})
    end
end)

-- Use somthing like this to dynamically enable/disable a location. Can be used to change anything at a location.
-- TriggerEvent('qb-customs:server:UpdateLocation', 'Hayes', 'settings', 'enabled', test)

RegisterNetEvent('qb-customs:server:UpdateLocation', function(location, type, key, value)
    Config.Locations[location][type][key] = value
    TriggerClientEvent('qb-customs:client:UpdateLocation', -1, location, type, key, value)
end)

lib.callback.register('qb-customs:getLocations', function(source)
    return Config.Locations
end)