local cooldowns = {}
local ox_inventory = exports.ox_inventory

-- Citizen.CreateThread(function() -- do not touch this thread function!
-- 	while true do
-- 	Citizen.Wait(1000)
-- 		for k,v in pairs(cooldowns) do
-- 			if v.time <= 0 then
-- 				RemoveCooldownTimer(v.cooldown)
-- 			else
-- 				v.time = v.time - 1000
-- 			end
-- 		end
-- 	end
-- end)


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

local function sendLog(sender, reciever, amount)
    MySQL.update('INSERT INTO banking_logs (sender, reciever, amount, time) VALUES (@sender, @reciever, @amount, @time)', {
        ['@sender'] = sender,
        ['@reciever'] = reciever,
        ['@amount'] = amount,
        ['@time']  = os.date('%Y-%m-%d %X')
    })
end

exports('sendLog', sendLog)



lib.callback.register('kk-banking:requestData', function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        -- Check if delay is elapsed
        if isDelayElapsed(src) then
            updateLastActionTime(src) -- Update last action time
            local factionData = {
                name = xPlayer.job.name,
                money = 0,
                permissions = {
                    withdraw = false,
                    deposit = false
                }
            }
            
            if xPlayer.job.name ~= 'unemployed' then
                TriggerEvent('Society.GetMoney', xPlayer.job.name, function(money)
                    factionData.money = money
                    factionData.permissions.withdraw = xPlayer.job.permissions.banking
                    factionData.permissions.deposit = xPlayer.job.permissions.banking
                end)
            else
                factionData = false
            end
            
            returnable = {
                money = xPlayer.getMoney(),
                bank = xPlayer.getAccount('bank').money,
                faction = factionData
            }
        else
            TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Oota " .. DELAY_DURATION .. " sekundit enne järgmise päringu tegemist.")
        end
    end

    return returnable
end)

lib.callback.register('kk-banking:loadLogs', function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        MySQL.Async.fetchAll('SELECT * FROM banking_logs WHERE sender = @pid OR reciever = @pid LIMIT 50', {
            ['@pid'] = xPlayer.name
        }, function(result)
            if result then
                local newResults = {}

                for k,v in pairs(result) do
                    table.insert(newResults, {amount = v.amount, time = v.time})
                end

                returnable = newResults
            else
                returnable = {}
            end
        end)
    else
        returnable = {}
    end

    while returnable == nil do Wait(50) end
    return returnable
end)

lib.callback.register('kk-banking:loadBills', function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = ? ORDER BY `id` DESC', { xPlayer.identifier }, function(bills)
            if bills then
                returnable = bills
            else
                returnable = {}
            end
        end)
    else
        returnable = {}
    end

    while returnable == nil do Wait(50) end
    return returnable
end)


-- Fines
lib.callback.register('kk-banking:payBill', function(source, billId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        MySQL.Async.fetchAll('SELECT sender, target, amount FROM billing WHERE id = ?', { billId }, function(result)
            if result[1] then
                local amount = result[1].amount
        
                if xPlayer.getAccount('bank').money >= amount then
                    MySQL.Async.execute('DELETE FROM billing WHERE id = @id', {
                        ['@id'] = billId
                    }, function(rowsChanged)
                        if rowsChanged == 1 then
                            xPlayer.removeAccountMoney('bank', amount)
                            TriggerEvent('Society.AddMoney', result[1].target, amount)
    
                            TriggerEvent('kk-society:getJobInfo', result[1].target, function(cb)
                                sendLog(xPlayer.name, 'Arve tasumine', '-'..amount)
                            end)

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


lib.callback.register('kk-banking:deposit', function(source, amount)
    local src = source
    local returnable = nil

    local xPlayer = ESX.GetPlayerFromId(src)
    amount = tonumber(amount)
    if xPlayer then
        if isDelayElapsed(src) then
            updateLastActionTime(src)
            if amount == nil or amount <= 0 or amount > xPlayer.getMoney() then
                TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Ebakorrektne summa.")
                returnable = false
            else
                xPlayer.removeMoney(amount)
                local taxPercentage = exports['kk-taxes']:getTax('primary').value
                local taxedAmount = amount - ESX.Math.Round(ESX.Math.Percent(taxPercentage, amount))

                xPlayer.addAccountMoney('bank', taxedAmount)
                sendLog(xPlayer.name, 'Sissemakse', amount)
                exports['kk-scripts']:sendLog(xPlayer.identifier, 'PANGANDUS', 'Sisestas raha summas $' .. amount .. ' oma pangakontole.')

                TriggerClientEvent('KKF.UI.ShowNotification', src, "success", "Sooritasite sissemakse summas $" .. amount)           
                local updateData = {
                    money = xPlayer.getMoney(),
                    bank = xPlayer.getAccount('bank').money,
                }
                TriggerClientEvent('kk-banking:client:updateData', src, updateData)

                returnable = true
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Oota " .. DELAY_DURATION .. " sekundit enne järgmise sissemakse tegemist.")
        end
    end

    return returnable
end)


lib.callback.register('kk-banking:withdraw', function(source, amount)
    local src = source
    local returnable = nil

    local xPlayer = ESX.GetPlayerFromId(src)
    
    if xPlayer then
        local bankMoney = xPlayer.getAccount('bank').money
        amount = tonumber(amount)
        if amount <= 0 or amount > bankMoney then
            TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Ebakorrektne summa või piisavalt raha pole pangakontol.")
            returnable = false
        else
            if isDelayElapsed(src) then
                updateLastActionTime(src)
                xPlayer.removeAccountMoney('bank', amount)
                xPlayer.addMoney(amount)
                
                sendLog(xPlayer.name, 'Väljamakse','-'.. amount)
                exports['kk-scripts']:sendLog(xPlayer.identifier, 'PANGANDUS', 'Väljastas raha summas $' .. amount .. ' oma pangakontolt.')
                
                TriggerClientEvent('KKF.UI.ShowNotification', src, "success", "Sooritasite väljamakse summas $" .. amount)

                local updateData = {
                    money = xPlayer.getMoney(),
                    bank = xPlayer.getAccount('bank').money,
                }
                TriggerClientEvent('kk-banking:client:updateData', src, updateData)

                returnable = true
            else
                TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Oota " .. DELAY_DURATION .. " sekundit enne järgmise väljamakse tegemist.")
            end
        end
    else
        TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Ebakorrektne summa või piisavalt raha pole pangakontol.")
        returnable =  false
    end
    return returnable
end)


lib.callback.register('kk-banking:factionDeposit', function(source, amount)
    local src = source
    local returnable = nil

    local xPlayer = ESX.GetPlayerFromId(src)
    local job = xPlayer.job.name

    if xPlayer and tonumber(amount) and tonumber(amount) > 0 then
        -- Check if delay is elapsed
        if isDelayElapsed(src) then
            updateLastActionTime(src)

            TriggerEvent('Society.AddMoney', job, amount)
            xPlayer.removeMoney(amount)
            exports['kk-scripts']:sendLog(xPlayer.identifier, 'PANGANDUS', 'Lisas fraktioonile: $'..amount)
            exports['kk-scripts']:sendSocietyLog(xPlayer.source,'PANGANDUS', 'Lisas raha fraktsiooni kontole: $'..amount)
            TriggerClientEvent('KKF.UI.ShowNotification', src, "success", "Sooritasite hoiustamise summas $" .. amount)
            TriggerEvent('Society.GetMoney', job, function(factionMoney)
                local updateData = {
                    money = xPlayer.getMoney(),
                    faction = factionMoney
                }
                TriggerClientEvent('kk-banking:client:updateData', src, updateData)
            end)
            returnable = true
        else
            TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Oota " .. DELAY_DURATION .. " sekundit enne järgmise hoiustamise tegemist.")
        end
    else
        TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Ebakorrektne summa.")
        returnable = false
    end
    return returnable
end)


lib.callback.register('kk-banking:factionWithdraw', function(source, amount)
    local src = source
    local returnable = nil

    local xPlayer = ESX.GetPlayerFromId(src)
    local job = xPlayer.job.name

    if xPlayer and tonumber(amount) and tonumber(amount) > 0 then
        if isDelayElapsed(src) then
            updateLastActionTime(src)
            TriggerEvent('Society.RemoveMoney', job, amount)
            xPlayer.addMoney(amount)

            exports['kk-scripts']:sendLog(xPlayer.identifier, 'PANGANDUS', 'Väljastas raha summas $' .. amount .. ' oma pangakontolt.')
            exports['kk-scripts']:sendSocietyLog(xPlayer.source,'PANGANDUS', 'Eemaldas raha fraktsiooni kontolt summas: $'..amount)
            
            TriggerClientEvent('KKF.UI.ShowNotification', src, "success", "Sooritasite väljamakse summas $" .. amount)

            TriggerEvent('Society.GetMoney', job, function(factionMoney)
                local updateData = {
                    money = xPlayer.getMoney(),
                    faction = factionMoney
                }
                TriggerClientEvent('kk-banking:client:updateData', src, updateData)
            end)
            
            returnable = true
        else
            TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Oota " .. DELAY_DURATION .. " sekundit enne järgmise väljamakse tegemist.")
        end
    else
        TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Ebakorrektne summa.")
        returnable = false
    end
    return returnable
end)



lib.callback.register('kk-banking:transferMoney', function(source, pid, amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
		if pid ~= xPlayer.identifier then
			if isDelayElapsed(src) then
				updateLastActionTime(src)
				
				MySQL.Async.fetchAll('SELECT pid, accounts, firstname, lastname FROM users WHERE pid = ?', { pid }, function(result)
					if result[1] then
						local xTarget = ESX.GetPlayerFromIdentifier(pid)
		
						if xTarget then
							local balance = xPlayer.getAccount('bank').money
		
							if balance <= 0 or balance < tonumber(amount) or tonumber(amount) <= 0 then
								returnable = 'notEnough'
							else
								if xTarget.hasItem('phone') then
									TriggerClientEvent('InteractSound_CL:PlayOnOne', xTarget.source, 'message', 0.1)
									TriggerClientEvent('kk-phone:client:showNotification', xTarget.source, 'bank', 'Pank', 'Konto ' .. xPlayer.identifier .. ' saatis raha summas $' .. amount .. '.')
								end
		
								xPlayer.removeAccountMoney('bank', tonumber(amount))
								xTarget.addAccountMoney('bank', tonumber(amount))
		
								sendLog(xPlayer.name, xTarget.name,'-'.. amount)
								exports['kk-scripts']:sendLog(xPlayer.identifier, 'PANGANDUS', 'saatis raha summas $' .. amount .. '.', xTarget.identifier)
		
								local updateDataSender = {
									money = xPlayer.getMoney(),
									bank = xPlayer.getAccount('bank').money,
								}
								TriggerClientEvent('kk-banking:client:updateData', src, updateDataSender)
								
								local updateDataReceiver = {
									money = xTarget.getMoney(),
									bank = xTarget.getAccount('bank').money,
								}
								TriggerClientEvent('kk-banking:client:updateData', xTarget.source, updateDataReceiver)
								
								returnable = xTarget.identifier
							end
						else
							local balance = xPlayer.getAccount('bank').money
		
							if balance <= 0 or balance < tonumber(amount) or tonumber(amount) <= 0 then
								returnable = 'notEnough'
							else
								local accounts = json.decode(result[1].accounts)
								accounts['bank'] = accounts['bank'] + tonumber(amount)
		
								xPlayer.removeAccountMoney('bank', tonumber(amount))
								MySQL.Async.execute('UPDATE users SET accounts = ? WHERE pid = ?', { json.encode(accounts), pid}, function(rows)
									sendLog(xPlayer.name, result[1].firstname .. ' ' .. result[1].lastname,'-'.. amount)
									exports['kk-scripts']:sendLog(xPlayer.identifier, 'PANGANDUS', 'Saatis raha summas $' .. amount .. '.', pid)
									local updateData = {
										money = xPlayer.getMoney(),
										bank = xPlayer.getAccount('bank').money,
									}
									TriggerClientEvent('kk-banking:client:updateData', src, updateData)
                                    
									returnable = result[1].pid
								end)
							end
						end
					else
						returnable = 'unknown'
					end
				end)
			else
				TriggerClientEvent('KKF.UI.ShowNotification', src, "error", "Oota " .. DELAY_DURATION .. " sekundit enne järgmise ülekande tegemist.")
			end
		else
			returnable = 'yourSelf'
		end
    else
        returnable = 'unknown'
    end
    return returnable
end)



-- CheckJobUsers = function(job)  
--     local count = 0
--     for index, player in pairs(GetPlayers()) do
--         if tonumber(player) ~= nil then
--             local xPlayer = ESX.GetPlayerFromId(tonumber(player))
--             if xPlayer then
--                 if xPlayer.job.name == job and xPlayer.job.onDuty then
--                     count = count + 1
--                 end
--             end
--         end
--      end
--     return count
-- end

-- function RemoveCooldownTimer(source)
--     for k, v in pairs(cooldowns) do
--         if v.cooldown == source then
--             table.remove(cooldowns, k)
--         end
--     end
-- end
-- function GetCooldownTimer(source)
--     for k, v in pairs(cooldowns) do
--         if v.cooldown == source then
--             return math.ceil(v.time / 60000)
--         end
--     end
-- end
-- function CheckCooldownTimer(source)
--     for k, v in pairs(cooldowns) do
--         if v.cooldown == source then
--             return true
--         end
--     end
--     return false
-- end

-- lib.callback.register('kk-banking:getCooldown', function(source)
--     local src = source
--     local xPlayer = ESX.GetPlayerFromId(src)
--     local returnable = nil

--     if xPlayer then
-- 		returnable = GetCooldownTimer(xPlayer.identifier) or false
-- 	else 
-- 		returnable = false
--     end

--     while returnable == nil do Wait(50) end; return returnable
-- end)



-- lib.callback.register('kk-banking:recieveReward', function(source, id)
--     local src = source
--     local xPlayer = ESX.GetPlayerFromId(src)
--     local returnable = nil

--     if xPlayer then
-- 		local xItem = ox_inventory:GetItem(xPlayer.source, 'hacking_tablet')

-- 		if xItem.count > 0 then
-- 			local money = math.random(1000, 2000)

-- 			xPlayer.removeInventoryItem('hacking_tablet', 1)
-- 			xPlayer.addAccountMoney('money', money)
-- 			exports['kk-scripts']:sendLog(xPlayer.identifier, 'RÖÖVID', 'Sai ATMi röövilt $' .. money .. '.')
-- 			cooldowns[#cooldowns+1] = {cooldown = id, time = (15 * 60000)}

-- 			returnable = money
-- 		else
-- 			returnable = false
-- 		end
-- 	else
-- 		returnable = false
--     end

--     while returnable == nil do Wait(50) end; return returnable
-- end)

-- lib.callback.register('kk-banking:startRob', function(source, id)
--     local src = source
--     local xPlayer = ESX.GetPlayerFromId(src)
--     local returnable = nil

--     if xPlayer then
-- 		local xItem = ox_inventory:GetItem(xPlayer.source, 'hacking_tablet')

-- 		if xItem.count > 0 and CheckJobUsers("police") >= 0 then
-- 			if not GetCooldownTimer(id) then
-- 				TriggerClientEvent('kk-dispatch:client:sendDispatch', xPlayer.source, "10-93",  'police', "ATM'i TURVAALARM")

-- 				returnable = true
-- 			else
-- 				TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Seda kohta ei saa hetkel röövida.')
-- 				returnable = false
-- 			end
-- 		else
-- 			TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Tahvlis tekkis viga?')
-- 			returnable = false
-- 		end
-- 	else
-- 		returnable = false
--     end

--     while returnable == nil do Wait(50) end; return returnable
-- end)
