local ox_inventory = exports.ox_inventory

lib.callback.register('kk-hunting:requestConfig', function()
    return cfg
end)

lib.callback.register('kk-hunting:buy', function(source, shopIndex, itemKey, quantity)
    local xPlayer = KKF.GetPlayerFromId(source)
    local shop = cfg.shops[shopIndex]
    local item = shop.items[itemKey]

    if not xPlayer or not item or quantity <= 0 then
        return false
    end

    local price = math.ceil(item.buy * quantity)
    local vat = exports['kk-taxes']:getTax('primary').value
    local totalPrice = math.ceil(price + (price * vat / 100))

    if ox_inventory:GetItemCount(source, 'money') >= totalPrice then
        ox_inventory:RemoveItem(source, 'money', totalPrice)
        ox_inventory:AddItem(source, item.item, quantity)
        return true
    else
        return false
    end
end)

lib.callback.register('kk-hunting:sell', function(source, shopIndex, itemKey)
    local xPlayer = KKF.GetPlayerFromId(source)
    local shop = cfg.shops[shopIndex]
    local item = shop.items[itemKey]

    if not xPlayer or not item then
        return false
    end

    local itemCount = ox_inventory:GetItemCount(source, item.item)

    if itemCount > 0 then
        local totalEarned = item.sell * itemCount
        ox_inventory:AddItem(source, 'money', totalEarned)
        ox_inventory:RemoveItem(source, item.item, itemCount)
        return true
    else
        return false
    end
end)

lib.callback.register('kk-hunting:pickUp', function(source, entityNetId)
    local xPlayer = KKF.GetPlayerFromId(source)
    if not xPlayer then return false end

    local animalNetId = entityNetId
    local animalEntity = NetworkGetEntityFromNetworkId(animalNetId)

    if DoesEntityExist(animalEntity) then
        local animalModel = GetEntityModel(animalEntity)

        local modelNames = cfg.modelNames

        local modelName = modelNames[animalModel]
        if not modelName then
            -- print('Unknown animal model: ' .. animalModel)
            return false
        end

        DeleteEntity(animalEntity)

        local meatCount = math.random(1, 1)
        local success = ox_inventory:AddItem(source, modelName, meatCount)

        return success
    end

    return false
end)

