local cooldowns = {}

Citizen.CreateThread(function() -- do not touch this thread function!
	while true do
	Citizen.Wait(1000)
		for k,v in pairs(cooldowns) do
			if v.time <= 0 then
				RemoveCooldownTimer(v.cooldown)
			else
				v.time = v.time - 1000
			end
		end
	end
end)

CheckJobUsers = function(job)  
    local count = 0
    for index, player in pairs(GetPlayers()) do
        if tonumber(player) ~= nil then
            local xPlayer = KKF.GetPlayerFromId(tonumber(player))
            if xPlayer then
                if xPlayer.job.name == job and xPlayer.job.onDuty then
                    count = count + 1
                end
            end
        end
     end
    return count
end

function RemoveCooldownTimer(source)
    for k, v in pairs(cooldowns) do
        if v.cooldown == source then
            table.remove(cooldowns, k)
        end
    end
end


lib.callback.register('kk-robberies:cash_register:canRob', function(source, coords)
    local returnable = nil
    local encodedCoords = json.encode(coords)

    local isPoliceEnough = CheckJobUsers("police") >= Config.cashPolicereq

    if not isPoliceEnough then
        return false
    end

    for _, v in pairs(cooldowns) do
        if v.cooldown == encodedCoords then
            returnable = false
            break
        end
    end

    if returnable == nil then
        returnable = true
        table.insert(cooldowns, { cooldown = encodedCoords, time = (Config.cashTimeout * 60000) })
        print(json.encode(cooldowns))
    end

    while returnable == nil do
        Wait(50)
    end

    return returnable
end)


lib.callback.register('kk-robberies:cash_register:performRobbery', function(source, coords, zone)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if coords then
            local money = math.random(Config.cashReward.min,Config.cashReward.max)
            exports['kk-scripts']:sendLog(xPlayer.identifier, 'RÖÖVID', 'Sai poeröövilt raha summas $' .. money .. '.')
        
            TriggerClientEvent('KKF.UI.ShowNotification', src, 'success', 'Teenisite poerööviga $'..money..'.')
            local chance = math.random(1,100)

            if chance > 95 then
                xPlayer.addInventoryItem('jewelry_id', 1)
                exports['kk-scripts']:sendLog(xPlayer.identifier, 'RÖÖVID', 'Sai poeröövilt eseme Juveelipoe kaart 1tk.')
            end

            xPlayer.addMoney(money)
            returnable = true
        else
            returnable = false
        end
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)
