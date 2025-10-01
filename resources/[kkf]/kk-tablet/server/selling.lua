local ESX = exports['es_extended']:getSharedObject()
local activeSellers = {}

local function selectRandomItem()
    local itemPool = {}
    
    for _, item in ipairs(cfg.selling.jewelry) do
        table.insert(itemPool, {
            item = item.name,
            amount = math.random(item.min, item.max),
            price = item.price
        })
    end

    if #itemPool == 0 then return nil end
    return itemPool[math.random(1, #itemPool)]
end

local function giveRandomItemToPlayer(source)
    local selectedItem = selectRandomItem()
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Viga: mängijat ei leitud!')
        return false
    end
    exports.ox_inventory:AddItem(source, selectedItem.item, selectedItem.amount)
    return true
end

lib.callback.register('kk-tablet:selling:setRecieve', function(source, state)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then 
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Viga: mängijat ei leitud!')
        return false 
    end

    local identifier = xPlayer.identifier
    MySQL.Async.execute('UPDATE users SET is_selling = ? WHERE identifier = ?', { state and 1 or 0, identifier })

    if state then
        activeSellers[source] = true
        Citizen.CreateThread(function()
            while activeSellers[source] do
                local selectedItem = selectRandomItem()
                if selectedItem then
                    local location = cfg.selling.locations[math.random(1, #cfg.selling.locations)]
                    local lastContract = MySQL.Sync.fetchSingle('SELECT MAX(id) as max_id FROM drug_contracts WHERE identifier = ?', { identifier })
                    local newContractId = (lastContract and lastContract.max_id or 0) + 1

                    MySQL.Async.insert('INSERT INTO drug_contracts (identifier, item, amount, price, location, status, id) VALUES (?, ?, ?, ?, ?, ?, ?)', {
                        identifier,
                        selectedItem.item,
                        selectedItem.amount,
                        selectedItem.price * selectedItem.amount,
                        json.encode(location),
                        'pending',
                        newContractId
                    }, function(insertId)
                        if insertId then
                            TriggerClientEvent('kk-tablet:selling:reloadSelling', source)
                        else
                            TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Tööotsa loomine ebaõnnestus!')
                        end
                    end)
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Eseme valimine ebaõnnestus!')
                end
                Wait(30000)
            end
        end)
    else
        activeSellers[source] = nil
    end

    return state
end)

lib.callback.register('kk-tablet:selling:loadJob', function(source, contractId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then 
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Viga: mängijat ei leitud!')
        return {} 
    end

    local identifier = xPlayer.identifier
    if not contractId then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Viga: tööotsa ID puudub!')
        return {}
    end

    local contract = MySQL.Sync.fetchSingle('SELECT * FROM drug_contracts WHERE id = ? AND identifier = ?', { contractId, identifier })
    if not contract then 
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Tööotsa ei leitud!')
        return {}
    end

    local oxItem = exports.ox_inventory:GetItem(source, contract.item)
    local label = (oxItem and oxItem.label) or contract.item
    local image = (oxItem and oxItem.metadata and oxItem.metadata.icon) or (contract.item .. ".png")

    local items = {}
    items[contract.item] = {
        label = label,
        count = contract.amount,
        image = image
    }

    return { items = items }
end)

lib.callback.register('kk-tablet:selling:requestData', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then 
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Viga: mängijat ei leitud!')
        return {} 
    end

    local identifier = xPlayer.identifier
    local contracts = MySQL.Sync.fetchAll('SELECT * FROM drug_contracts WHERE identifier = ? AND LOWER(status) = ? ORDER BY id DESC', { identifier, 'pending' })

    local playerData = MySQL.Sync.fetchSingle('SELECT contracts_done, contracts_earned FROM users WHERE identifier = ?', { identifier })
    local contractsDone = playerData and playerData.contracts_done or 0
    local contractsEarned = playerData and playerData.contracts_earned or 0

    xPlayer.set('contracts_done', contractsDone)
    xPlayer.set('contracts_earned', contractsEarned)

    return { 
        contracts = contracts, 
        done = contractsDone, 
        earned = contractsEarned 
    }
end)

lib.callback.register('kk-tablet:selling:acceptJob', function(source, contractId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then 
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Viga: mängijat ei leitud!')
        return false 
    end

    local identifier = xPlayer.identifier
    local contract = MySQL.Sync.fetchSingle('SELECT * FROM drug_contracts WHERE id = ? AND identifier = ? AND status = "pending"', { contractId, identifier })
    if not contract then 
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Tööotsa ei leitud või see ei ole ootel!')
        return false 
    end

    MySQL.Async.execute('UPDATE drug_contracts SET status = "active" WHERE id = ?', { contractId }, function(affectedRows)
        if affectedRows == 0 then
            TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Viga tööotsa aktiveerimisel!')
        end
    end)
    return true
end)

local function getPlayerItemCount(source, itemName)
    local inventory = exports.ox_inventory:GetInventoryItems(source)
    local count = 0
    for _, item in pairs(inventory) do
        if string.lower(item.name) == string.lower(itemName) then
            count = count + (item.count or 0)
        end
    end
    return count
end

lib.callback.register('kk-tablet:selling:canFinish', function(source, contractId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Viga: mängijat ei leitud!')
        return false
    end

    if not contractId then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Viga: tööotsa ID puudub!')
        return false
    end

    local contract = MySQL.Sync.fetchSingle('SELECT * FROM drug_contracts WHERE id = ? AND identifier = ? AND status = "active"', 
        { contractId, xPlayer.identifier })
    if not contract then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Tööotsa ei leitud või see ei ole aktiivne!')
        return false
    end

    local itemCount = getPlayerItemCount(source, contract.item)

    if itemCount >= contract.amount then
        return true
    else
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Teil ei ole kõiki tellitud esemeid!')
        return false
    end
end)

lib.callback.register('kk-tablet:selling:finishJob', function(source, contractId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Viga: mängijat ei leitud!')
        return false
    end

    if not contractId then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Viga: tööotsa ID puudub!')
        return false
    end

    local contract = MySQL.Sync.fetchSingle('SELECT * FROM drug_contracts WHERE id = ? AND identifier = ? AND status = "active"', 
        { contractId, xPlayer.identifier })
    if not contract then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Tööotsa ei leitud või see ei ole aktiivne!')
        return false
    end

    local itemCount = getPlayerItemCount(source, contract.item)

    if itemCount < contract.amount then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Teil ei ole kõiki tellitud esemeid!')
        return false
    end

    exports.ox_inventory:RemoveItem(source, contract.item, contract.amount)
    local success = giveRandomItemToPlayer(source)
    if not success then
        exports.ox_inventory:AddItem(source, contract.item, contract.amount)
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Eseme lisamine ebaõnnestus!')
        return false
    end

    xPlayer.addMoney(contract.price)

    local playerData = MySQL.Sync.fetchSingle('SELECT contracts_done, contracts_earned FROM users WHERE identifier = ?', { xPlayer.identifier })
    local newContractsDone = (playerData and playerData.contracts_done or 0) + 1
    local newContractsEarned = (playerData and playerData.contracts_earned or 0) + (contract.price or 0)

    xPlayer.set('contracts_done', newContractsDone)
    xPlayer.set('contracts_earned', newContractsEarned)

    MySQL.Async.execute('UPDATE users SET contracts_done = ?, contracts_earned = ? WHERE identifier = ?', 
        { newContractsDone, newContractsEarned, xPlayer.identifier }, function(affectedRows)
            if affectedRows == 0 then
                TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Viga mängija statistika uuendamisel!')
            end
        end
    )

    MySQL.Async.execute('DELETE FROM drug_contracts WHERE id = ? AND identifier = ?', 
        { contractId, xPlayer.identifier }, function(affectedRows)
            if affectedRows > 0 then
                TriggerClientEvent('kk-tablet:selling:reloadSelling', source)
            else
                TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Viga kontrakti kustutamisel!')
            end
        end
    )

    return true
end)

lib.callback.register('kk-tablet:selling:cancelJob', function(source, contractId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then 
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Viga: mängijat ei leitud!')
        return false 
    end

    if not contractId then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Viga: tööotsa ID puudub!')
        return false
    end

    local contract = MySQL.Sync.fetchSingle('SELECT * FROM drug_contracts WHERE id = ? AND identifier = ?', { contractId, xPlayer.identifier })
    if not contract then 
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Tööotsa ei leitud!')
        return false 
    end

    MySQL.Async.execute('DELETE FROM drug_contracts WHERE id = ? AND identifier = ?', { contractId, xPlayer.identifier }, function(affectedRows)
        if affectedRows > 0 then
            TriggerClientEvent('kk-tablet:selling:reloadSelling', source)
        else
            TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Viga tööotsa tühistamisel!')
        end
    end)
    return true
end)

lib.callback.register('drugselling:generateOffers', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then 
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Viga: mängijat ei leitud!')
        return {} 
    end

    local deals = {}
    local itemsData = exports.ox_inventory:Items()

    for _, item in ipairs(cfg.selling.jewelry) do
        local count = exports.ox_inventory:Search(source, 'count', item.name)
        if count > 0 then
            local amount = math.random(item.min, math.min(count, item.max))
            local unitPrice = item.price
            local price = unitPrice * amount
            local itemInfo = itemsData[item.name]

            table.insert(deals, {
                item = item.name,
                label = itemInfo and itemInfo.label or item.name,
                amount = amount,
                unitPrice = unitPrice,
                price = price,
                count = count,
                profit = price,
                profitPerItem = unitPrice
            })
        end
    end

    for _, item in ipairs(cfg.selling.jewelryRandom) do
        if math.random(100) <= item.chance then
            local count = exports.ox_inventory:Search(source, 'count', item.item)
            if count > 0 then
                local amount = math.min(count, item.count)
                local unitPrice = math.random(100, 300)
                local price = unitPrice * amount
                local itemInfo = itemsData[item.item]

                table.insert(deals, {
                    item = item.item,
                    label = itemInfo and itemInfo.label or item.item,
                    amount = amount,
                    unitPrice = unitPrice,
                    price = price,
                    count = count,
                    profit = price,
                    profitPerItem = unitPrice
                })
            end
        end
    end

    for itemName, data in pairs(cfg.selling.items) do
        local count = exports.ox_inventory:Search(source, 'count', itemName)
        if count > 0 then
            local amount = math.random(1, math.min(count, 3))
            local unitPrice = data.price
            local price = unitPrice * amount
            local itemInfo = itemsData[itemName]

            table.insert(deals, {
                item = itemName,
                label = itemInfo and itemInfo.label or itemName,
                amount = amount,
                unitPrice = unitPrice,
                price = price,
                count = count,
                profit = price,
                profitPerItem = unitPrice
            })
        end
    end

    for level, data in pairs(cfg.selling.randomItems) do
        if math.random(100) <= data.chance then
            for _, item in ipairs(data.items) do
                local count = exports.ox_inventory:Search(source, 'count', item.item)
                if count > 0 then
                    local amount = math.random(item.min, math.min(count, item.max))
                    if amount > 0 then
                        local unitPrice = math.random(100, 300)
                        local price = unitPrice * amount
                        local itemInfo = itemsData[item.item]

                        table.insert(deals, {
                            item = item.item,
                            label = itemInfo and itemInfo.label or item.item,
                            amount = amount,
                            unitPrice = unitPrice,
                            price = price,
                            count = count,
                            profit = price,
                            profitPerItem = unitPrice
                        })
                    end
                end
            end
        end
    end

    if #deals > 0 then
        local bulkAmount = 0
        local bulkPrice = 0
        for _, deal in ipairs(deals) do
            bulkAmount = bulkAmount + deal.amount
            bulkPrice = bulkPrice + deal.price
        end
        table.insert(deals, {
            item = 'bulk_sell',
            label = 'Bulk Sell',
            amount = bulkAmount,
            price = bulkPrice,
            discountedPrice = math.floor(bulkPrice * 0.5),
            breakdown = 'All items'
        })
    end

    return deals
end)

lib.callback.register('drugselling:performDeal', function(source, deal)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then 
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Viga: mängijat ei leitud!')
        return false, 'Player not found' 
    end

    if deal.item == 'bulk_sell' then
        local totalRemoved = 0
        for _, item in ipairs(cfg.selling.jewelry) do
            local count = exports.ox_inventory:Search(source, 'count', item.name)
            if count > 0 then
                exports.ox_inventory:RemoveItem(source, item.name, count)
                totalRemoved = totalRemoved + count
            end
        end
        for _, item in ipairs(cfg.selling.jewelryRandom) do
            local count = exports.ox_inventory:Search(source, 'count', item.item)
            if count > 0 then
                exports.ox_inventory:RemoveItem(source, item.item, count)
                totalRemoved = totalRemoved + count
            end
        end
        for itemName, _ in pairs(cfg.selling.items) do
            local count = exports.ox_inventory:Search(source, 'count', itemName)
            if count > 0 then
                exports.ox_inventory:RemoveItem(source, itemName, count)
                totalRemoved = totalRemoved + count
            end
        end
        for level, data in pairs(cfg.selling.randomItems) do
            for _, item in ipairs(data.items) do
                local count = exports.ox_inventory:Search(source, 'count', item.item)
                if count > 0 then
                    exports.ox_inventory:RemoveItem(source, item.item, count)
                    totalRemoved = totalRemoved + count
                end
            end
        end
        if totalRemoved > 0 then
            xPlayer.addMoney(deal.discountedPrice or deal.price)
            return true, 'Bulk deal completed'
        else
            TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Esemeid ei leitud müümiseks!')
            return false, 'No items to sell'
        end
    else
        local count = exports.ox_inventory:Search(source, 'count', deal.item)
        if count >= deal.amount then
            exports.ox_inventory:RemoveItem(source, deal.item, deal.amount)
            xPlayer.addMoney(deal.price)
            return true, 'Deal completed'
        else
            TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Teil ei ole piisavalt esemeid!')
            return false, 'Not enough items'
        end
    end
end)

lib.callback.register('kk-robberies:getHouses', function(source)
    return {}
end)