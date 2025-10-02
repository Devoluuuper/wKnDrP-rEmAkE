local SellingJobs = {} -- Track jobs for each player using xPlayer.identifier
local ox_inventory = exports.ox_inventory
local debug = false

function debugprint(msg)
    if debug then
        print(msg)
    end
end

-- Fetch user selling data
lib.callback.register('kk-tablet:selling:requestData', function(source)
    local xPlayer = KKF.GetPlayerFromId(source)
    if not xPlayer then return false end

    local returnable = nil
    local identifier = xPlayer.identifier

    local function fetchUserData()
        local result = MySQL.Sync.fetchAll('SELECT done, earned FROM user_selling WHERE identifier = @identifier', {
            ['@identifier'] = identifier
        })

        if not result or #result == 0 then
            MySQL.Sync.execute('INSERT INTO user_selling (identifier, done, earned) VALUES (@identifier, @done, @earned)', {
                ['@identifier'] = identifier,
                ['@done'] = 0,
                ['@earned'] = 0
            })
            return { done = 0, earned = 0 }
        else
            return { done = result[1].done or 0, earned = result[1].earned or 0 }
        end
    end

    local userData = fetchUserData()
    local contracts = SellingJobs[identifier] and SellingJobs[identifier].availableJobs or {}

    returnable = {
        contracts = contracts,
        done = userData.done,
        earned = userData.earned
    }

    debugprint("DEBUG: Returnable data: " .. json.encode(returnable))
    return returnable
end)

-- Set receiving status
lib.callback.register('kk-tablet:selling:setRecieve', function(source, status)
    local xPlayer = KKF.GetPlayerFromId(source)
    if not xPlayer then return false end

    local identifier = xPlayer.identifier
    SellingJobs[identifier] = SellingJobs[identifier] or { availableJobs = {}, setRecieve = false }
    SellingJobs[identifier].setRecieve = status

    debugprint("DEBUG: Player " .. identifier .. " has " .. (status and "started" or "stopped") .. " receiving orders.")
    return status
end)

-- Load job by index
lib.callback.register('kk-tablet:selling:loadJob', function(source, index)
    local xPlayer = KKF.GetPlayerFromId(source)
    if not xPlayer then return false end

    local identifier = xPlayer.identifier
    if SellingJobs[identifier] and SellingJobs[identifier].availableJobs then
        local orderIndex = tonumber(index)
        if orderIndex and orderIndex > 0 and orderIndex <= #SellingJobs[identifier].availableJobs then
            return SellingJobs[identifier].availableJobs[orderIndex]
        end
    end
    return false
end)

-- Accept a job
lib.callback.register('kk-tablet:selling:acceptJob', function(source, id)
    local xPlayer = KKF.GetPlayerFromId(source)
    if not xPlayer then return false end

    local identifier = xPlayer.identifier
    SellingJobs[identifier] = SellingJobs[identifier] or { availableJobs = {}, DoingJob = false }

    if SellingJobs[identifier].DoingJob then
        debugprint("DEBUG: Player " .. xPlayer.getName() .. " is already delivering an order.")
        return false
    end

    local job = SellingJobs[identifier].availableJobs[id]
    if not job then
        debugprint("DEBUG: Invalid job ID.")
        return false
    end

    SellingJobs[identifier].DoingJob = true
    SellingJobs[identifier].activeJob = job
    table.remove(SellingJobs[identifier].availableJobs, id)

    -- TriggerClientEvent('kk-tablet:selling:reloadSelling', source)
    return job
end)

-- Check if job can be finished
lib.callback.register('kk-tablet:selling:canFinish', function(source)
    local xPlayer = KKF.GetPlayerFromId(source)
    if not xPlayer then return false end

    local identifier = xPlayer.identifier
    local job = SellingJobs[identifier] and SellingJobs[identifier].activeJob
    if not job then return false end

    for itemName, orderItem in pairs(job.items) do
        if ox_inventory:GetItemCount(source, itemName) < orderItem.count then
            debugprint("DEBUG: Player doesn't have enough of " .. itemName)
            return false
        end
    end
    return true
end)

-- Finish a job
lib.callback.register('kk-tablet:selling:finishJob', function(source)
    local xPlayer = KKF.GetPlayerFromId(source)
    if not xPlayer then return false end

    local identifier = xPlayer.identifier
    local job = SellingJobs[identifier] and SellingJobs[identifier].activeJob
    if not job then return false end

    local totalPrice = job.price
    for itemName, orderItem in pairs(job.items) do
        ox_inventory:RemoveItem(source, itemName, orderItem.count)
    end

    xPlayer.addMoney(totalPrice)
    SellingJobs[identifier].DoingJob = false
    SellingJobs[identifier].activeJob = nil

    MySQL.Async.execute('UPDATE user_selling SET done = done + 1, earned = earned + @amount WHERE identifier = @identifier', {
        ['@amount'] = totalPrice,
        ['@identifier'] = identifier
    })

    debugprint("DEBUG: Player " .. xPlayer.getName() .. " completed job for $" .. totalPrice)
    TriggerClientEvent('kk-tablet:selling:reloadSelling', source)
    return true
end)

lib.callback.register('kk-tablet:selling:cancelJob', function(source)
    local xPlayer = KKF.GetPlayerFromId(source)
    if not xPlayer then return false end

    local identifier = xPlayer.identifier
    if SellingJobs[identifier] and SellingJobs[identifier].DoingJob then
        SellingJobs[identifier].DoingJob = false
        SellingJobs[identifier].activeJob = nil

        debugprint("DEBUG: Player " .. xPlayer.getName() .. " canceled their job.")
        TriggerClientEvent('kk-tablet:food:removeJob', source)
        TriggerClientEvent('kk-tablet:selling:reloadSelling', source)
        return true
    end
    return false
end)




------ Tööd


function generateSellingJob(identifier)
    local xPlayer = KKF.GetPlayerFromIdentifier(identifier)
    if not xPlayer then return end

    local job = { price = 0, items = {} }

    local jobItem = cfg.selling.jewelry[math.random(1, #cfg.selling.jewelry)]

    local orderItem = {
        count = math.random(jobItem.min, jobItem.max),
        price = jobItem.price,
        label = KKF.GetItemLabel(jobItem.name),
    }

    -- Add the item to the job
    job.items[jobItem.name] = orderItem
    job.price = orderItem.price * orderItem.count

    debugprint("DEBUG: Generated item for player " .. identifier .. ": " .. jobItem.name .. ", count: " .. orderItem.count .. ", Price: " .. orderItem.price)
    debugprint("DEBUG: Total Order Price: " .. job.price)

    if not SellingJobs[identifier] then
        SellingJobs[identifier] = { availableJobs = {} }
    elseif not SellingJobs[identifier].availableJobs then
        SellingJobs[identifier].availableJobs = {}
    end
    table.insert(SellingJobs[identifier].availableJobs, job)

    return job
end


CreateThread(function()
    while true do
        Wait(600 * math.random(5, 10)) -- 5-10min
        for identifier, data in pairs(SellingJobs) do
            if data.setRecieve then
                local xPlayer = KKF.GetPlayerFromIdentifier(identifier)
                if xPlayer then
                    local order = generateSellingJob(identifier)
                    TriggerClientEvent('kk-tablet:selling:reloadSelling', xPlayer.source)
                else
                    debugprint("DEBUG: Player " .. identifier .. " is not online.")
                end
            end
        end
    end
end)



-----

RegisterServerEvent('drugselling:server:soldDrug', function()
    local xPlayer = KKF.GetPlayerFromId(source)

    if xPlayer then
        local priceMultiple = 1.0; local policeCount = KKF.GetDutyCount('police')

        if policeCount <= 0 then
            priceMultiple = 0.5
        elseif policeCount >= 1 then
            priceMultiple = 1.0
        elseif policeCount >= 2 then 
            priceMultiple = 1.1
        elseif policeCount >= 3 then
            priceMultiple = 1.2
        elseif policeCount >= 4 then
            priceMultiple = 1.3
        elseif policeCount >= 5 then
            priceMultiple = 1.4
        elseif policeCount >= 6 then
            priceMultiple = 1.5
        end

        for k,v in pairs(cfg.selling.items) do
            if xPlayer.hasItem(k) then
                local drugCount = xPlayer.getItem(k).count
                if drugCount <= 9 then drugCount = math.random(1, drugCount) end
                if drugCount >= 20 then drugCount = math.random(1, 20) end
                local reward = (v.price * priceMultiple) * drugCount
        
                xPlayer.removeInventoryItem(k, drugCount)
                xPlayer.addAccountMoney('money', reward)

                exports['kk-scripts']:sendLog(xPlayer.identifier, 'NARKOOTIKUMID', 'Müüs eseme ' .. KKF.GetItemLabel(k) .. ' ' .. drugCount .. 'tk $' .. reward .. ' eest.')
                TriggerClientEvent('KKF.UI.ShowNotification', source, 'success', 'Teenisid ' .. drugCount .. 'tk ' .. KKF.GetItemLabel(k) .. ' müügist $' .. reward .. '.')
                return
            end
        end
    end
end)
