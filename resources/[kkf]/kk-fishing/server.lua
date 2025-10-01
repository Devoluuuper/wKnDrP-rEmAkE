local ox_inventory = exports.ox_inventory

lib.callback.register('kk-fishing:sell', function(source, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local shopItem = cfg.shop[item]
    if not shopItem or not shopItem.sell then
        return TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Seda eset ei saa müüa.')
    end

    local count = ox_inventory:GetItem(source, item, false, true)
    if count <= 0 then
        return TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Sul ei ole midagi müüa.')
    end

    local totalPrice = count * shopItem.sell
    ox_inventory:RemoveItem(source, item, count)
    xPlayer.addMoney(totalPrice)

    TriggerClientEvent('KKF.UI.ShowNotification', source, 'success', ('Müüsid %s koguses %d hinnaga $%d.'):format(ESX.GetItemLabel(item), count, totalPrice))
end)


lib.callback.register('kk-fishing:buy', function(source, item, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local shopItem = cfg.shop[item]
    if not shopItem or not shopItem.buy then
        return TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Seda eset ei saa osta.')
    end

    local totalPrice = shopItem.buy * amount
    local tax = exports['kk-taxes']:getTax('primary').value / 100
    local finalPrice = math.floor(totalPrice + (totalPrice * tax))

    if xPlayer.getMoney() < finalPrice then
        return TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', ('Sul ei ole piisavalt raha. Puudu: $%d.'):format(finalPrice - xPlayer.getMoney()))
    end

    if not ox_inventory:CanCarryItem(source, item, amount) then
        return TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Sa ei saa rohkem asju kanda.')
    end

    ox_inventory:AddItem(source, item, amount)
    xPlayer.removeMoney(finalPrice)

    TriggerClientEvent('KKF.UI.ShowNotification', source, 'success', ('Ostsid %s koguses %d hinnaga $%d.'):format(ESX.GetItemLabel(item), amount, finalPrice))
end)


lib.callback.register('kk-fishing:recieveFish', function(source)
    local skill_level = exports['kk-skills']:GetSkillLevel(source, cfg.skillname)

    local availableFishes = {}

    for fish, data in pairs(cfg.fishes) do
        if skill_level >= data.reqskill then
            table.insert(availableFishes, fish)
        end
    end

    if #availableFishes == 0 then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Sa ei saa praegu kala püüda. Su oskus on liiga madal.')
        return
    end

    local randomFish = availableFishes[math.random(#availableFishes)]

    local minAmount = cfg.fishes[randomFish].min
    local maxAmount = cfg.fishes[randomFish].max

    local amount = math.random(minAmount, maxAmount)

    if not ox_inventory:CanCarryItem(source, randomFish, amount) then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Sul ei ole piisavalt ruumi kalade jaoks.')
        return
    end

    local progressadd = 0
    if skill_level == 1 then
        progressadd = 1
    elseif skill_level == 2 then
        progressadd = 0.5
    elseif skill_level == 3 then
        progressadd = 0.3
    elseif skill_level == 4 then
        progressadd = 0.2
    elseif skill_level >= 5 then
        progressadd = 0.1
    end

    exports['kk-skills']:AddSkillProgress(source, cfg.skillname, progressadd)

    ox_inventory:AddItem(source, randomFish, amount)

    -- TriggerClientEvent('KKF.UI.ShowNotification', source, 'success', ('Püüdsid %s koguses %d.'):format(ESX.GetItemLabel(randomFish), amount))
end)



RegisterNetEvent('kk-fishing:server:buyId', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local price = cfg.license
    local tax = exports['kk-taxes']:getTax('primary').value / 100
    local finalPrice = math.floor(price + (price * tax))

    if xPlayer.getMoney() < finalPrice then
        return TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', ('Sul ei ole piisavalt raha. Puudu: $%d.'):format(finalPrice - xPlayer.getMoney()))
    end

    if ox_inventory:GetItemCount(source, cfg.licence_item) > 1 then
        return TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Sul juba on kalastusluba.')
    end

    if not ox_inventory:CanCarryItem(source, cfg.licence_item, 1) then
        return TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Sa ei saa seda kanda.')
    end

    local daysToAdd = cfg.licencetime
    local currentDate = os.time()
    local newDate = os.date("%d-%m-%Y", currentDate + (daysToAdd * 24 * 60 * 60))


    ox_inventory:AddItem(source, cfg.licence_item, 1, { pid = xPlayer.identifier, doe = newDate, name = xPlayer.name, sex = xPlayer.get('sex'), dob = xPlayer.get('dateofbirth')})
    xPlayer.removeMoney(finalPrice)

    TriggerClientEvent('KKF.UI.ShowNotification', source, 'success', ('Ostsid kalastusloa hinnaga $%d.'):format(finalPrice))
end)



lib.callback.register('kk-fishing:requestConfig', function()
    return cfg
end)
