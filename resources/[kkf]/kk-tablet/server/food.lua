local activeFoodSellers = {}

local function selectRandomFood()
    local foodPool = {}
    
    for _, food in ipairs(cfg.foods.items) do
        if food.lvl == 1 then
            table.insert(foodPool, {
                item = food.name,
                amount = math.random(food.min, food.max),
                price = food.price
            })
        end
    end

    if #foodPool == 0 then 
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Viga: toiduvalik puudub!')
        return nil 
    end
    return foodPool[math.random(1, #foodPool)]
end

local function giveRandomItemToPlayer(source)
    local selectedFood = selectRandomFood()
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Viga: mängijat ei leitud!')
        return false
    end
    local success = exports.ox_inventory:AddItem(source, selectedFood.item, selectedFood.amount)
    return success
end

lib.callback.register('kk-tablet:setRecieve', function(source, state)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then 
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Viga: mängijat ei leitud!')
        return false 
    end

    if state == nil then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Viga: tööotsade seadistamine ebaõnnestus!')
        return false
    end

    local identifier = xPlayer.identifier
    MySQL.Async.execute('UPDATE users SET is_food_selling = ? WHERE identifier = ?', { state and 1 or 0, identifier }, function(affectedRows)
        if affectedRows == 0 then
            TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Viga tööotsade seadistamisel!')
        end
    end)

    if state then
        activeFoodSellers[source] = true
        Citizen.CreateThread(function()
            while activeFoodSellers[source] do
                local selectedFood = selectRandomFood()
                if selectedFood then
                    if not cfg.foods.locations or #cfg.foods.locations == 0 then
                        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Asukohad puuduvad, võtke ühendust administraatoriga!')
                        activeFoodSellers[source] = nil
                        return
                    end
                    local location = cfg.foods.locations[math.random(1, #cfg.foods.locations)]
                    local lastContract = MySQL.Sync.fetchSingle('SELECT MAX(id) as max_id FROM food_contracts WHERE identifier = ?', { identifier })
                    local newContractId = (lastContract and lastContract.max_id or 0) + 1

                    MySQL.Async.insert('INSERT INTO food_contracts (identifier, item, amount, price, location, status, id) VALUES (?, ?, ?, ?, ?, ?, ?)', {
                        identifier,
                        selectedFood.item,
                        selectedFood.amount,
                        selectedFood.price * selectedFood.amount,
                        json.encode({ coords = { x = location.coords.x, y = location.coords.y, z = location.coords.z }, heading = location.coords.w }),
                        'pending',
                        newContractId
                    }, function(insertId)
                        if insertId then
                            TriggerClientEvent('kk-tablet:reloadFoods', source)
                        else
                            TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Tööotsa loomine ebaõnnestus!')
                        end
                    end)
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Eseme valimine ebaõnnestus!')
                end
                Wait(25000) -- 25 seconds
            end
        end)
    else
        activeFoodSellers[source] = nil
    end

    return state
end)

lib.callback.register('kk-tablet:loadJob', function(source, contractId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then 
        return {} 
    end

    local identifier = xPlayer.identifier
    if not contractId then
        return {}
    end

    local contract = MySQL.Sync.fetchSingle('SELECT * FROM food_contracts WHERE id = ? AND identifier = ?', { contractId, identifier })
    if not contract then 
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

lib.callback.register('kk-tablet:loadFood', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then 
        return {} 
    end

    local identifier = xPlayer.identifier
    local contracts = MySQL.Sync.fetchAll(
        'SELECT * FROM food_contracts WHERE identifier = ? AND LOWER(status) = ?', 
        { identifier, 'pending' }
    )

    local playerData = MySQL.Sync.fetchSingle(
        'SELECT food_contracts_done, food_contracts_earned, firstname, lastname FROM users WHERE identifier = ?', 
        { identifier }
    )
    local contractsDone = playerData and playerData.food_contracts_done or 0
    local contractsEarned = playerData and playerData.food_contracts_earned or 0

    xPlayer.set('food_contracts_done', contractsDone)
    xPlayer.set('food_contracts_earned', contractsEarned)

    local topPlayers = {}
    local topData = MySQL.Sync.fetchAll(
        'SELECT identifier, firstname, lastname, food_contracts_done FROM users WHERE food_contracts_done > 0 ORDER BY food_contracts_done DESC LIMIT 5'
    )

    for _, data in ipairs(topData) do
        local playerName = data.firstname .. " " .. data.lastname
        local rides = tonumber(data.food_contracts_done) or 0
        table.insert(topPlayers, playerName .. " (" .. rides .. " vedu)")
    end

    return { 
        contracts = contracts, 
        done = contractsDone, 
        earned = contractsEarned,
        top = topPlayers
    }
end)

lib.callback.register('kk-tablet:acceptJob', function(source, contractId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then 
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Viga: mängijat ei leitud!')
        return false 
    end

    local identifier = xPlayer.identifier
    local contract = MySQL.Sync.fetchSingle('SELECT *, LOWER(status) as status_lower FROM food_contracts WHERE id = ? AND identifier = ?', { contractId, identifier })
    if not contract then 
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Tööotsa ei leitud!')
        return false 
    end

    if contract.status_lower ~= 'pending' then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Tööots ei ole ootel!')
        return false
    end

    MySQL.Async.execute('UPDATE food_contracts SET status = "active" WHERE id = ? AND identifier = ?', { contractId, identifier }, function(affectedRows)
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

lib.callback.register('kk-tablet:canFinish', function(source, contractId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Viga: mängijat ei leitud!')
        return false
    end

    local identifier = xPlayer.identifier
    if not contractId then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Viga: tööotsa ID puudub!')
        return false
    end

    local contract = MySQL.Sync.fetchSingle('SELECT *, LOWER(status) as status_lower FROM food_contracts WHERE id = ? AND identifier = ?', { contractId, identifier })
    if not contract then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Tööotsa ei leitud!')
        return false
    end

    if contract.status_lower ~= 'active' then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Tööots ei ole aktiivne!')
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

lib.callback.register('kk-tablet:finishJob', function(source, contractId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Viga: mängijat ei leitud!')
        return false
    end

    local identifier = xPlayer.identifier
    if not contractId then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Viga: tööotsa ID puudub!')
        return false
    end

    local contract = MySQL.Sync.fetchSingle('SELECT *, LOWER(status) as status_lower FROM food_contracts WHERE id = ? AND identifier = ?', { contractId, identifier })
    if not contract then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Tööotsa ei leitud!')
        return false
    end

    if contract.status_lower ~= 'active' then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Tööots ei ole aktiivne!')
        return false
    end

    local itemCount = getPlayerItemCount(source, contract.item)

    if itemCount < contract.amount then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Teil ei ole kõiki tellitud esemeid!')
        return false
    end

    exports.ox_inventory:RemoveItem(source, contract.item, contract.amount, nil, { ignoreMetadata = true })
    xPlayer.addMoney(contract.price)

    local playerData = MySQL.Sync.fetchSingle('SELECT food_contracts_done, food_contracts_earned FROM users WHERE identifier = ?', { identifier })
    local newContractsDone = (playerData and playerData.food_contracts_done or 0) + 1
    local newContractsEarned = (playerData and playerData.food_contracts_earned or 0) + (contract.price or 0)

    xPlayer.set('food_contracts_done', newContractsDone)
    xPlayer.set('food_contracts_earned', newContractsEarned)

    MySQL.Async.execute('UPDATE users SET food_contracts_done = ?, food_contracts_earned = ? WHERE identifier = ?', 
        { newContractsDone, newContractsEarned, identifier }, function(affectedRows)
            if affectedRows == 0 then
                TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Viga mängija statistika uuendamisel!')
            end
        end
    )

    MySQL.Async.execute('DELETE FROM food_contracts WHERE id = ? AND identifier = ?', 
        { contractId, identifier }, function(affectedRows)
            if affectedRows > 0 then
                TriggerClientEvent('kk-tablet:reloadFoods', source)
            else
                TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Viga kontrakti kustutamisel!')
            end
        end
    )

    return true
end)

lib.callback.register('kk-tablet:cancelJob', function(source, contractId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then 
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Viga: mängijat ei leitud!')
        return false 
    end

    local identifier = xPlayer.identifier
    if not contractId then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Viga: tööotsa ID puudub!')
        return false
    end

    local contract = MySQL.Sync.fetchSingle('SELECT *, LOWER(status) as status_lower FROM food_contracts WHERE id = ? AND identifier = ?', { contractId, identifier })
    if not contract then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Tööotsa ei leitud!')
        return false 
    end

    MySQL.Async.execute('DELETE FROM food_contracts WHERE id = ? AND identifier = ?', { contractId, identifier }, function(affectedRows)
        if affectedRows > 0 then
            TriggerClientEvent('kk-tablet:reloadFoods', source)
        else
            TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Viga tööotsa tühistamisel!')
        end
    end)
    return true
end)

lib.callback.register('kk-tablet:setWaypoint', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then 
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Viga: mängijat ei leitud!')
        return false 
    end
    return true
end)