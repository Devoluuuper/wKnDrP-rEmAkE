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

local function saveFactionData(faction, money)
    MySQL.update.await('UPDATE jobs SET money = ? WHERE name = ?', { money, faction })
end

exports('sendLog', sendLog)

lib.callback.register('kk-banking2:loadData', function(source, data)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
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

    if xPlayer.job.permissions.bankWithdraw --[[or xPlayer.job.permissions.bankSend or xPlayer.job.permissions.bankDeposit]] then  

            TriggerEvent('Society.GetMoney', xPlayer.job.name, function(money) 
                response.factionAccountMoney = money or 0
            end)
        end

        local invoices = MySQL.Sync.fetchAll('SELECT id, label, amount, time FROM billing WHERE sender = ?', { xPlayer.identifier })
        for _, invoice in ipairs(invoices) do
            table.insert(response.invoices, {
                label = invoice.label,
                amount = invoice.amount,
                time = invoice.time,
                id = invoice.id
            })
        end

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
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        MySQL.Async.fetchAll('SELECT sender, target, amount FROM billing WHERE id = ?', { invoiceId }, function(result)
            if result[1] then
                local amount = result[1].amount
                local targetJob = result[1].target
                local jobs = KKF.GetJobs()

                if xPlayer.getAccount('bank').money >= amount then
                    MySQL.Async.execute('DELETE FROM billing WHERE id = @id', {
                        ['@id'] = invoiceId
                    }, function(rowsChanged)
                        if rowsChanged == 1 then
                            xPlayer.removeAccountMoney('bank', amount)
                            if jobs[targetJob] then
                                local jobData = MySQL.Sync.fetchSingle('SELECT money FROM jobs WHERE name = ?', { targetJob })
                                local newMoney = (jobData and jobData.money or 0) + amount
                                saveFactionData(targetJob, newMoney)
                            end
                            returnable = KKF.Math.GroupDigits(amount)
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

    while returnable == nil do Wait(50) end
    return returnable
end)

lib.callback.register('kk-banking2:moneyOutIn', function(source, accountType, action, amount)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = nil
    local jobs = KKF.GetJobs()
    local jobName = xPlayer.job.name

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
                    local taxedAmount = amount - KKF.Math.Round(KKF.Math.Percent(taxPercentage, amount))

                    xPlayer.removeMoney(amount)
                    xPlayer.addAccountMoney('bank', taxedAmount)

                    sendLog(xPlayer.name, 'Sissemakse', taxedAmount, 'in')
                    exports['kk-scripts']:sendLog(xPlayer.identifier, 'PANGANDUS', 'Sisestas raha summas $' .. taxedAmount .. ' oma pangakontole.')

                    TriggerClientEvent('KKF.UI.ShowNotification', src, "success", "Sooritasite sissemakse summas $" .. taxedAmount)

                    returnable = taxedAmount
                else
                    local remainingTime = DELAY_DURATION
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
                    local remainingTime = DELAY_DURATION
                    TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Oota " .. remainingTime .. " sekundit enne järgmise väljamakse tegemist.")
                    returnable = false
                end
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Tundmatu tegevus.")
            returnable = false
        end
    elseif xPlayer and accountType == 'faction' and jobs[jobName] and xPlayer.job.grade_name == 'boss' then
        amount = tonumber(amount)
        if not amount or amount <= 0 then
            TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Ebakorrektne summa.")
            returnable = false
        end

        if action == 'in' then
            if amount > xPlayer.getMoney() then
                TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Teil pole piisavalt sularaha.")
                returnable = false
            else
                if isDelayElapsed(src) then
                    updateLastActionTime(src)

                    local taxPercentage = exports['kk-taxes']:getTax('primary').value
                    local taxedAmount = amount - KKF.Math.Round(KKF.Math.Percent(taxPercentage, amount))

                    xPlayer.removeMoney(amount)
                    local jobData = MySQL.Sync.fetchSingle('SELECT money FROM jobs WHERE name = ?', { jobName })
                    local newMoney = (jobData and jobData.money or 0) + taxedAmount
                    saveFactionData(jobName, newMoney)

                    exports['kk-scripts']:sendSocietyLog(xPlayer.source, 'PANGANDUS', 'Lisas raha fraktsiooni kontole: $' .. taxedAmount)

                    TriggerClientEvent('KKF.UI.ShowNotification', src, "success", "Sooritasite sissemakse fraktsioonile summas $" .. taxedAmount)

                    returnable = taxedAmount
                else
                    local remainingTime = DELAY_DURATION
                    TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Oota " .. remainingTime .. " sekundit enne järgmise sissemakse tegemist.")
                    returnable = false
                end
            end
        elseif action == 'out' then
            local jobData = MySQL.Sync.fetchSingle('SELECT money FROM jobs WHERE name = ?', { jobName })
            local bankMoney = jobData and jobData.money or 0
            if amount > bankMoney then
                TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Fraktsiooni kontol pole piisavalt raha.")
                returnable = false
            else
                if isDelayElapsed(src) then
                    updateLastActionTime(src)

                    xPlayer.addMoney(amount)
                    local newMoney = bankMoney - amount
                    saveFactionData(jobName, newMoney)

                    sendLog(xPlayer.name, 'Väljamakse', amount, 'out')
                    exports['kk-scripts']:sendSocietyLog(xPlayer.source, 'PANGANDUS', 'Eemaldas raha fraktsiooni kontolt summas: $' .. amount)

                    TriggerClientEvent('KKF.UI.ShowNotification', src, "success", "Sooritasite fraktsioonilt väljamakse summas $" .. amount)

                    returnable = amount
                else
                    local remainingTime = DELAY_DURATION
                    TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Oota " .. remainingTime .. " sekundit enne järgmise väljamakse tegemist.")
                    returnable = false
                end
            end
        end
    else
        TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Sul Puuduvad õigused")
        returnable = false
    end

    while returnable == nil do Wait(50) end
    return returnable
end)

lib.callback.register('kk-banking2:sendMoney', function(source, accountType, targetIdentifier, amount)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    amount = tonumber(amount)
    local returnable = nil
    local jobs = KKF.GetJobs()

    if not xPlayer then
        returnable = 'playerNotFound'
    elseif targetIdentifier == xPlayer.identifier then
        returnable = 'yourSelf'
    elseif not isDelayElapsed(src) then
        local remainingTime = DELAY_DURATION
        returnable = 'delay:' .. remainingTime
    elseif not amount or amount <= 0 then
        returnable = 'invalidAmount'
    else
        local balance = accountType == 'personal' and xPlayer.getAccount('bank').money or 0
        local jobName = xPlayer.job.name

        if accountType == 'faction' and jobs[jobName] and xPlayer.job.grade_name == 'boss' then
            local jobData = MySQL.Sync.fetchSingle('SELECT money FROM jobs WHERE name = ?', { jobName })
            balance = jobData and jobData.money or 0
        end

        if balance < amount then
            returnable = 'notEnough'
        else
            MySQL.Async.fetchAll('SELECT pid, accounts, firstname, lastname FROM users WHERE pid = ?', { targetIdentifier }, function(result)
                if result[1] then
                    local xTarget = KKF.GetPlayerFromIdentifier(targetIdentifier)

                    if xTarget then
                        -- Online recipient
                        if accountType == 'personal' then
                            xPlayer.removeAccountMoney('bank', amount)
                        else
                            local jobData = MySQL.Sync.fetchSingle('SELECT money FROM jobs WHERE name = ?', { jobName })
                            local newMoney = (jobData and jobData.money or 0) - amount
                            saveFactionData(jobName, newMoney)
                            exports['kk-scripts']:sendSocietyLog(xPlayer.source, 'PANGANDUS', 'Saatis fraktsiooni kontolt raha summas: $' .. amount .. ' Isikule: ' .. xTarget.name .. '.')
                        end

                        xTarget.addAccountMoney('bank', amount)

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
                            local jobData = MySQL.Sync.fetchSingle('SELECT money FROM jobs WHERE name = ?', { jobName })
                            local newMoney = (jobData and jobData.money or 0) - amount
                            saveFactionData(jobName, newMoney)
                            exports['kk-scripts']:sendSocietyLog(xPlayer.source, 'PANGANDUS', 'Saatis fraktsiooni kontolt raha summas: $' .. amount .. ' Isikule: ' .. result[1].firstname .. ' ' .. result[1].lastname .. '.')
                        end

                        MySQL.Async.execute('UPDATE users SET accounts = ? WHERE pid = ?', { json.encode(accounts), targetIdentifier }, function(rows)
                            if rows > 0 then
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