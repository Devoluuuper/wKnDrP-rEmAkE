local ox_inventory = exports.ox_inventory

local playerorders = {}

local houses = {
    {polyZone = {coords = vec3(-1073.8708, -1152.9481, 2.158), heading = 280.2920}},
    {polyZone = {coords = vec3(-1082.5104, -1139.2881, 2.1586), heading = 245.0}},
}

local debug = false

function debugprint(msg)
    if debug then
        print(msg)
    end
end


lib.callback.register('kk-tablet:getHouses', function(source)
    return houses
end)


lib.callback.register('kk-tablet:food:requestData', function(source)
    local xPlayer = KKF.GetPlayerFromId(source)
    local returnable = nil
    if not xPlayer then
        return false
    end

    local done = 0
    local earned = 0
    local top = {}

    MySQL.Async.fetchAll('SELECT done, earned FROM user_droppy WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        if not result or #result == 0 then
            MySQL.Async.execute('INSERT INTO user_droppy (identifier, done, earned) VALUES (@identifier, @done, @earned)', {
                ['@identifier'] = xPlayer.identifier,
                ['@done'] = done,
                ['@earned'] = earned
            })
        else
            done = result[1].done or 0
            earned = result[1].earned or 0
        end

        MySQL.Async.fetchAll('SELECT identifier, done FROM user_droppy ORDER BY done DESC LIMIT 5', {}, function(topResults)
            for _, player in ipairs(topResults) do
                local TopPlayer = KKF.GetPlayerFromIdentifier(player.identifier)
                if TopPlayer then
                    table.insert(top, { TopPlayer.getName() })
                end
            end
            local contracts = {}

            if playerorders[xPlayer.identifier] and playerorders[xPlayer.identifier].activeOrders then
                for _, order in ipairs(playerorders[xPlayer.identifier].activeOrders) do
                    table.insert(contracts, order)
                end
            end

            returnable = {
                contracts = contracts,
                done = done,
                earned = earned,
                top = top
            }

            debugprint("DEBUG: Returning contracts for player " .. xPlayer.identifier .. ": " .. #contracts .. " active orders.")
        end)
    end)

    while returnable == nil do Wait(50) end; return returnable
end)


lib.callback.register('kk-tablet:food:setRecieve', function(source)
    local xPlayer = KKF.GetPlayerFromId(source)
    if not xPlayer then
        debugprint("DEBUG: Player not found.")
        return false
    end

    if not playerorders[xPlayer.identifier] then
        playerorders[xPlayer.identifier] = {
            setRecieve = false,
            activeOrders = {}
        }
        debugprint("DEBUG: Initialized player with identifier " .. xPlayer.identifier)
    end

    -- Toggle the player's order-taking status (setRecieve)
    if playerorders[xPlayer.identifier].setRecieve then
        playerorders[xPlayer.identifier].setRecieve = false
        debugprint("DEBUG: Player " .. xPlayer.identifier .. " stopped receiving orders.")
    else
        playerorders[xPlayer.identifier].setRecieve = true 
        debugprint("DEBUG: Player " .. xPlayer.identifier .. " started receiving orders.")
    end
    return playerorders[xPlayer.identifier].setRecieve
end)




lib.callback.register('kk-tablet:food:loadJob', function(source, index)
    local xPlayer = KKF.GetPlayerFromId(source)
    if not xPlayer then
        return false
    end
    if playerorders[xPlayer.identifier] and playerorders[xPlayer.identifier].activeOrders then
        local orderIndex = tonumber(index)
        if orderIndex and orderIndex > 0 and orderIndex <= #playerorders[xPlayer.identifier].activeOrders then
            return playerorders[xPlayer.identifier].activeOrders[orderIndex]
        end
    end

    return false
end)

function generateOrdersForPlayer(identifier)
    local xPlayer = KKF.GetPlayerFromIdentifier(identifier)
    if not xPlayer then return end

    local skillLevel = exports['kk-skills']:GetSkillLevel(xPlayer.source, 'delivering') or 1

    local order = { price = 0, items = {} }

    local itemCount = math.random(1, 2)

    for i = 1, itemCount do
        local foodItem = cfg.foods[math.random(1, #cfg.foods)]
        
        if foodItem.lvl <= skillLevel then
            local orderItem = {
                count = math.random(foodItem.min, foodItem.max),
                price = foodItem.price,
                label = KKF.GetItemLabel(foodItem.name)
            }

            if not order.items[foodItem.name] then
                order.items[foodItem.name] = orderItem
            else
                order.items[foodItem.name].count = order.items[foodItem.name].count + orderItem.count
                order.items[foodItem.name].price = foodItem.price
            end

            order.price = order.price + (orderItem.price * orderItem.count)

            debugprint("DEBUG: Generated item for player " .. identifier .. ": " .. foodItem.name .. ", count: " .. orderItem.count .. ", Price: " .. orderItem.price)
        else
            debugprint("DEBUG: Skipping item " .. foodItem.name .. " due to insufficient skill level. Required: " .. foodItem.lvl .. ", Player: " .. skillLevel)
        end
    end

    if not playerorders[identifier].activeOrders then
        playerorders[identifier].activeOrders = {}
    end

    table.insert(playerorders[identifier].activeOrders, order)

    debugprint("DEBUG: Full order generated for player " .. identifier .. ":")
    for itemName, item in pairs(order.items) do
        debugprint("    Item: " .. itemName .. ", Count: " .. item.count .. ", Price: " .. item.price)
    end
    debugprint("    Total Order Price: " .. order.price)

    return order
end




CreateThread(function()
    while true do
        Wait(60000 * math.random(5,10))-- 5-10min

        for identifier, data in pairs(playerorders) do
            if data.setRecieve then
                local order = generateOrdersForPlayer(identifier)
                local xPlayer = KKF.GetPlayerFromIdentifier(identifier)
                if xPlayer then
                    -- debugprint("DEBUG: Triggering food reload event for player " .. xPlayer.identifier)
                    TriggerClientEvent('kk-tablet:food:reloadFoods', xPlayer.source)
                else
                    -- debugprint("DEBUG: Player with identifier " .. identifier .. " not found when attempting to trigger food reload event.")
                end
            end
        end
    end
end)



lib.callback.register('kk-tablet:food:acceptJob', function(source, id)
    local xPlayer = KKF.GetPlayerFromId(source)
    local returnable = nil

    if not xPlayer then
        return false
    end
    if not playerorders[xPlayer.identifier] then
        playerorders[xPlayer.identifier] = {
            delivering = false,
            activeOrders = {},
            deliveringOrder = nil
        }
    end

    if playerorders[xPlayer.identifier].delivering then
        debugprint("DEBUG: Player " .. xPlayer.getName() .. " is already delivering an order.")
        return false
    else
        playerorders[xPlayer.identifier].delivering = true
    end

    if playerorders[xPlayer.identifier].activeOrders[id] then
        returnable = playerorders[xPlayer.identifier].activeOrders[id]
        playerorders[xPlayer.identifier].deliveringOrder = returnable
        table.remove(playerorders[xPlayer.identifier].activeOrders, id)
    else
        debugprint("DEBUG: Invalid order ID.")
        return false
    end
    TriggerClientEvent('kk-tablet:food:reloadFoods', xPlayer.source)
    return returnable
end)

lib.callback.register('kk-tablet:food:canFinish', function(source)
    local xPlayer = KKF.GetPlayerFromId(source)
    if not xPlayer then
        return false
    end

    if playerorders[xPlayer.identifier] and playerorders[xPlayer.identifier].delivering then
        local order = playerorders[xPlayer.identifier].deliveringOrder 
        local allItemsPresent = true
        for itemName, orderItem in pairs(order.items) do
            local itemCount = orderItem.count

            local itemQuantity = ox_inventory:GetItemCount(source, itemName, nil, false)
            if itemQuantity < itemCount then
                debugprint("DEBUG: Player doesn't have enough of " .. itemName)
                allItemsPresent = false
                break
            end
        end

        return allItemsPresent
    end
    return false
end)

lib.callback.register('kk-tablet:food:finishJob', function(source)
    local xPlayer = KKF.GetPlayerFromId(source)
    if not xPlayer then
        return false
    end

    if playerorders[xPlayer.identifier] and playerorders[xPlayer.identifier].delivering then
        local order = playerorders[xPlayer.identifier].deliveringOrder
        local totalPrice = order.price

        for itemName, orderItem in pairs(order.items) do
            local itemCount = orderItem.count
            ox_inventory:RemoveItem(source, itemName, itemCount)
        end

        xPlayer.addMoney(totalPrice)
        local societycut = cfg.precent  * totalPrice
        TriggerEvent('Society.AddMoney', xPlayer.job.name, societycut)
        exports['kk-skills']:AddSkillProgress(source, 'delivering', 1)

        debugprint("DEBUG: Player " .. xPlayer.getName() .. " has completed the delivery for " .. totalPrice .. " money.")

        -- Update the database (assuming your database method is set up to update the job status)
        MySQL.Async.execute('UPDATE user_droppy SET done = done + 1, earned = earned + @amount WHERE identifier = @identifier', {
            ['@amount'] = totalPrice,
            ['@identifier'] = xPlayer.identifier
        })

        playerorders[xPlayer.identifier].delivering = false
        playerorders[xPlayer.identifier].deliveringOrder = nil

        return true
    end
    TriggerClientEvent('kk-tablet:food:reloadFoods', xPlayer.source)
    return false
end)



lib.callback.register('kk-tablet:food:cancelJob', function(source)
    local xPlayer = KKF.GetPlayerFromId(source)
    if not xPlayer then
        return false
    end

    if playerorders[xPlayer.identifier] and playerorders[xPlayer.identifier].delivering then
        local order = playerorders[xPlayer.identifier].deliveringOrder
        debugprint("DEBUG: Player " .. xPlayer.getName() .. " has canceled the delivery for order ID: ")

        playerorders[xPlayer.identifier].delivering = false
        playerorders[xPlayer.identifier].deliveringOrder = nil

        
        TriggerClientEvent('kk-tablet:food:removeJob', xPlayer.source)
        TriggerClientEvent('kk-tablet:food:reloadFoods', xPlayer.source)
        return true
    end
    return false
end)




