local cooldowns = {}
local ox_inventory = exports.ox_inventory
local DELAY_DURATION = 3
local lastActionTimes = {}

local function getCurrentTime()
    return os.time()
end

local function isDelayElapsed(playerId)
    local currentTime = getCurrentTime()
    local lastActionTime = lastActionTimes[playerId] or 0
    return (currentTime - lastActionTime) >= DELAY_DURATION
end

local function updateLastActionTime(playerId)
    lastActionTimes[playerId] = getCurrentTime()
end


local function sendLog(sender, reciever, amount, type)
    MySQL.update('INSERT INTO banking_logs (sender, reciever, amount, time, type) VALUES (@sender, @reciever, @amount, @time, @type)', {
        ['@sender'] = sender,
        ['@reciever'] = reciever,
        ['@amount'] = amount,
        ['@time']  = os.date('%Y-%m-%d %X'),
        ['@type'] = type,
    })
end

exports('sendLog', sendLog)


lib.callback.register('kk-banking2:loadData', function(source, data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local accountType = data.type

    if xPlayer then
        -- Prepare response structure
        local response = {
            accountName = xPlayer.name,
            personalAccountMoney = xPlayer.getAccount('bank').money,
            factionAccountMoney = false,
            logs = {},
            invoices = {}
        }

        -- Add faction account money if the player has permission
        if xPlayer.job.permissions.banking then
            -- Fetch faction bank balance (assume a function getFactionBank exists)
            TriggerEvent('Society.GetMoney', xPlayer.job.name, function(money) 
                response.factionAccountMoney = money or 0
            end)
        end

        -- Fetch invoices synchronously
        local invoices = MySQL.Sync.fetchAll('SELECT id, label, amount, time FROM billing WHERE sender = ?', { xPlayer.identifier })
        for _, invoice in ipairs(invoices) do
            table.insert(response.invoices, {
                label = invoice.label,
                amount = invoice.amount,
                time = invoice.time,
                id = invoice.id
            })
        end

        -- Fetch logs synchronously
        local logs = MySQL.Sync.fetchAll('SELECT amount, time, type FROM banking_logs WHERE sender = ? OR reciever = ? LIMIT 50', { xPlayer.name, xPlayer.name })
        for _, log in ipairs(logs) do
            table.insert(response.logs, {
                amount = log.amount,
                type = log.type,
                time = log.time
            })
        end

        return response
    else
        return { error = "Player not found" }
    end
end)





lib.callback.register('kk-banking2:payInvoice', function(source, invoiceType, invoiceId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        -- Fetch invoice details
        MySQL.Async.fetchAll('SELECT sender, target, amount FROM billing WHERE id = ?', { invoiceId }, function(result)
            if result[1] then
                local amount = result[1].amount

                -- Check if player has enough money in the bank
                if xPlayer.getAccount('bank').money >= amount then
                    -- Delete the invoice from the database
                    MySQL.Async.execute('DELETE FROM billing WHERE id = @id', {
                        ['@id'] = invoiceId
                    }, function(rowsChanged)
                        if rowsChanged == 1 then
                            -- Deduct money from the player's bank account
                            xPlayer.removeAccountMoney('bank', amount)

                            -- Add money to the target society (if applicable)
                            TriggerEvent('Society.AddMoney', result[1].target, amount)

                            -- Log the transaction
                            TriggerEvent('kk-society:getJobInfo', result[1].target, function(cb)
                                sendLog(xPlayer.name, 'Arve tasumine', amount, 'out')
                            end)

                            -- Return success with the formatted amount
                            returnable = ESX.Math.GroupDigits(amount)
                        end
                    end)
                else
                    returnable = false
                end
            end
        end)
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)


lib.callback.register('kk-banking2:moneyOutIn', function(source, accountType, action, amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil
    if xPlayer and accountType == 'personal' then
        amount = tonumber(amount)
        if not amount or amount <= 0 then
            TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Ebakorrektne summa.")
            returnable = false
        end

        if action == "in" then
            -- Deposit money
            if amount > xPlayer.getMoney() then
                TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Teil pole piisavalt sularaha.")
                returnable = false
            else
                if isDelayElapsed(src) then
                    updateLastActionTime(src)

                    local taxPercentage = exports['kk-taxes']:getTax('primary').value
                    local taxedAmount = amount - ESX.Math.Round(ESX.Math.Percent(taxPercentage, amount))

                    xPlayer.removeMoney(amount)
                    xPlayer.addAccountMoney('bank', taxedAmount)

                    sendLog(xPlayer.name, 'Sissemakse', taxedAmount, 'in')
                    exports['kk-scripts']:sendLog(xPlayer.identifier, 'PANGANDUS', 'Sisestas raha summas $' .. taxedAmount .. ' oma pangakontole.')

                    TriggerClientEvent('KKF.UI.ShowNotification', src, "success", "Sooritasite sissemakse summas $" .. taxedAmount)


                    returnable = taxedAmount
                else
                    local remainingTime = DELAY_DURATION -- Calculate the remaining time as needed
                    TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Oota " .. remainingTime .. " sekundit enne järgmise sissemakse tegemist.")
                    returnable = false
                end
            end
        elseif action == "out" then
            -- Withdraw money
            local bankMoney = xPlayer.getAccount('bank').money
            if amount > bankMoney then
                TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Teie pangakontol pole piisavalt raha.")
                returnable = false
            else
                if isDelayElapsed(src) then
                    updateLastActionTime(src)

                    xPlayer.removeAccountMoney('bank', amount)
                    xPlayer.addMoney(amount)

                    sendLog(xPlayer.name, 'Väljamakse', amount, 'out')
                    exports['kk-scripts']:sendLog(xPlayer.identifier, 'PANGANDUS', 'Väljastas raha summas $' .. amount .. ' oma pangakontolt.')

                    TriggerClientEvent('KKF.UI.ShowNotification', src, "success", "Sooritasite väljamakse summas $" .. amount)


                    returnable = amount
                else
                    local remainingTime = DELAY_DURATION -- Calculate the remaining time as needed
                    TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Oota " .. remainingTime .. " sekundit enne järgmise väljamakse tegemist.")
                    returnable = false
                end
            end
        else
            -- Invalid action
            TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Tundmatu tegevus.")
            returnable = false
        end
    elseif xPlayer and accountType == 'faction' then
        amount = tonumber(amount)
        if not amount or amount <= 0 then
            TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Ebakorrektne summa.")
            returnable = false
        end

        if action == 'in' then
            if amount > xPlayer.getMoney() then
                returnable = false
            else
                if isDelayElapsed(src) then
                    updateLastActionTime(src)

                    local taxPercentage = exports['kk-taxes']:getTax('primary').value
                    local taxedAmount = amount - ESX.Math.Round(ESX.Math.Percent(taxPercentage, amount))

                    xPlayer.removeMoney(amount)
                    TriggerEvent('Society.AddMoney', xPlayer.job.name, taxedAmount)

                    exports['kk-scripts']:sendSocietyLog(xPlayer.source,'PANGANDUS', 'Lisas raha fraktsiooni kontole: $'..taxedAmount)

                    TriggerClientEvent('KKF.UI.ShowNotification', src, "success", "Sooritasite sissemakse fraktsioonile summas $" .. taxedAmount)

                    print(taxedAmount)

                    returnable = taxedAmount
                else
                    local remainingTime = DELAY_DURATION -- Calculate the remaining time as needed
                    TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Oota " .. remainingTime .. " sekundit enne järgmise sissemakse tegemist.")
                    returnable = false
                end

            end

        elseif action == 'out' then


            TriggerEvent('Society.GetMoney', xPlayer.job.name, function(factionMoney) 
                local bankMoney = factionMoney
                if amount > bankMoney then
                    TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Teie pangakontol pole piisavalt raha.")
                    returnable = false
                else
                    if isDelayElapsed(src) then
                        updateLastActionTime(src)

                        xPlayer.addMoney(amount)
                        TriggerEvent('Society.RemoveMoney', xPlayer.job.name, amount)
                        

                        sendLog(xPlayer.name, 'Väljamakse', amount, 'out')
                        exports['kk-scripts']:sendSocietyLog(xPlayer.source,'PANGANDUS', 'Eemaldas raha fraktsiooni kontolt summas: $'..amount)

                        TriggerClientEvent('KKF.UI.ShowNotification', src, "success", "Sooritasite fraktsioonilt väljamakse summas $" .. amount)


                        returnable = amount
                    else
                        local remainingTime = DELAY_DURATION -- Calculate the remaining time as needed
                        TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Oota " .. remainingTime .. " sekundit enne järgmise väljamakse tegemist.")
                        returnable = false
                    end
                end
            end)

        end
    end

    while returnable == nil do Wait(50) end; return returnable
end)




lib.callback.register('kk-banking2:sendMoney', function(source, accountType, targetIdentifier, amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    amount = tonumber(amount)
    local returnable = nil

    if not xPlayer then
        returnable = 'playerNotFound'
    elseif targetIdentifier == xPlayer.identifier then
        returnable = 'yourSelf'
    elseif not isDelayElapsed(src) then
        local remainingTime = DELAY_DURATION -- Adjust delay logic as needed
        returnable = 'delay:' .. remainingTime
    elseif not amount or amount <= 0 then
        returnable = 'invalidAmount'
    else
        -- Determine the source balance based on accountType
        local balance = accountType == 'personal' and xPlayer.getAccount('bank').money or 0

        if accountType == 'faction' and xPlayer.job.permissions.banking then
            local moneyFetched = false

            -- Fetch faction money
            TriggerEvent('Society.GetMoney', xPlayer.job.name, function(money)
                balance = money
                moneyFetched = true
            end)

            -- Wait for the callback to complete
            local startTime = os.time()
            while not moneyFetched do
                Citizen.Wait(10)
                if os.time() - startTime > 2 then
                    break
                end
            end
        end

        if balance < amount then
            returnable = 'notEnough'
        else
            MySQL.Async.fetchAll('SELECT pid, accounts, firstname, lastname FROM users WHERE pid = ?', { targetIdentifier }, function(result)
                if result[1] then
                    local xTarget = ESX.GetPlayerFromIdentifier(targetIdentifier)

                    if xTarget then
                        -- Online recipient
                        if accountType == 'personal' then
                            xPlayer.removeAccountMoney('bank', amount)
                        else
                            TriggerEvent('Society.RemoveMoney', xPlayer.job.name, amount)

                            exports['kk-scripts']:sendSocietyLog(xPlayer.source,'PANGANDUS', 'Saatis fraktsiooni kontolt raha summas: $'..amount..' Isikule: '..xTarget.name..'.')
                        end

                        xTarget.addAccountMoney('bank', amount)

                        -- Log the transaction
                        -- exports['kk-scripts']:sendLog(xPlayer.identifier, 'PANGANDUS', 'Saatis raha summas $' .. amount .. '.', xTarget.identifier)
                        -- exports['kk-scripts']:sendLog(xTarget.identifier, 'PANGANDUS', 'Sai raha summas $' .. amount .. ' isikult ' .. xPlayer.name .. '.', xPlayer.identifier)

                        TriggerClientEvent('KKF.UI.ShowNotification', src, "success", "Saatsid $" .. amount .. '. Isikule: ' .. xTarget.name .. ".")
                        TriggerClientEvent('KKF.UI.ShowNotification', xTarget.source, "success", "Saite $" .. amount .. ' isikult: ' .. xPlayer.name .. ".")

                        returnable = 'success'
                    else
                        -- Offline recipient
                        local accounts = json.decode(result[1].accounts)
                        accounts['bank'] = accounts['bank'] + amount

                        if accountType == 'personal' then
                            xPlayer.removeAccountMoney('bank', amount)
                        else
                            TriggerEvent('Society.RemoveMoney', xPlayer.job.name, amount)

                        end

                        MySQL.Async.execute('UPDATE users SET accounts = ? WHERE pid = ?', { json.encode(accounts), targetIdentifier }, function(rows)
                            if rows > 0 then
                                -- exports['kk-scripts']:sendLog(xPlayer.identifier, 'PANGANDUS', 'Saatis raha summas $' .. amount .. '.', targetIdentifier)
                                if accountType == 'faction' then
                                    exports['kk-scripts']:sendSocietyLog(xPlayer.source,'PANGANDUS', 'Saatis fraktsiooni kontolt raha summas: $'..amount..' Isikule: ' .. result[1].firstname .. ' ' .. result[1].lastname ..'.')
                                end
                                TriggerClientEvent('KKF.UI.ShowNotification', src, "success", "Saatsid $" .. amount .. '. Isikule: ' .. result[1].firstname .. ' ' .. result[1].lastname .. ".")
                                returnable = 'success'
                            else
                                returnable = 'dbError'
                            end
                        end)
                    end
                else
                    returnable = 'unknownRecipient'
                end
            end)
        end
    end

    while returnable == nil do Wait(50) end
    return returnable
end)
