--  server
local cooldowns = {}
local ox_inventory = exports.ox_inventory


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        for k, v in pairs(cooldowns) do
            if v.time <= 0 then
                RemoveCooldownTimer(v.shop, v.place)
            else
                v.time = v.time - 1000
            end
        end
    end
end)

function RemoveCooldownTimer(shop, place)
    for k, v in pairs(cooldowns) do
        if v.shop == shop and v.place == place then
            table.remove(cooldowns, k)
        end
    end
end

function AddCooldownTimer(shop, place)
    table.insert(cooldowns, { shop = shop, place = place, time = Config.shopTimeout * 60000 })
end

lib.callback.register('kk-robberies:shop:canRob', function(source, shop, place)
    local xPlayer = KKF.GetPlayerFromId(source)
    local returnable = nil

    if xPlayer then
        local isPoliceEnough = CheckJobUsers("police") >= Config.ShopRobPolice

        if not isPoliceEnough then
            return false
        end
        local canRob = true
        for _, v in ipairs(cooldowns) do
            if v.shop == shop and v.place == place then
                canRob = false
                break
            end
        end

        if canRob then
            AddCooldownTimer(shop, place)
            if Config.shops[shop].places[place].itemId == 8 then
                TriggerClientEvent('kk-dispatch:client:sendDispatch', xPlayer.source, "10-94",  'police', "POE TURVAALARM")
            else
                local chance = math.random(1,100)
                if chance >= 80 then
                    TriggerClientEvent('kk-dispatch:client:sendDispatch', xPlayer.source, "10-94",  'police', "POE TURVAALARM")
                end
            end
        end

        returnable = canRob
    else
        returnable = false
    end

    while returnable == nil do
        Wait(50)
    end

    return returnable
end)




-- Server-side script

lib.callback.register('kk-robberies:shop:performRobbery', function(source, shop, place, zonename)
    local xPlayer = KKF.GetPlayerFromId(source)
    local returnable = false

    if xPlayer then

        local shopitemid = Config.shops[shop].places[place].itemId
        local shopItems = Config.shopItems[shopitemid]
        if shopItems then
            local randomIndex = math.random(1, #shopItems)
            local itemData = shopItems[randomIndex]
            local itemName = itemData.item
            local itemCount = math.random(itemData.min, itemData.max)
            ox_inventory:AddItem(xPlayer.source, itemName, itemCount)
            returnable = true

            exports['kk-scripts']:sendLog(xPlayer.identifier, 'Rööv', string.format('Varastas %sx %s poest %s', itemCount, itemName, shop))
        else
            -- print('Error: Shop items configuration not found for shop ' .. tostring(shop))
        end
    else
        -- print('Error: Invalid player ID')
    end

    while returnable == nil do
        Wait(50)
    end

    return returnable
end)