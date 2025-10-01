local cooldowns = {}
local ox_inventory = exports.ox_inventory


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
            local xPlayer = ESX.GetPlayerFromId(tonumber(player))
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



lib.callback.register('kk-robberies:atm:canRob', function(source, atmCoords)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    local isPoliceEnough = CheckJobUsers("police") >= Config.atmPoliceReq

    if not isPoliceEnough then
        return false
    end

    local returnable = true
    local encodedCoords = json.encode(atmCoords)

    for _, v in pairs(cooldowns) do
        local cooldownJSON = json.encode(v.cooldown)
        if cooldownJSON == encodedCoords then
            returnable = false
            break
        end
    end

    if returnable then
        cooldowns[#cooldowns+1] = {cooldown = atmCoords, time = (Config.atmTimeout * 60000)}
        TriggerClientEvent('kk-dispatch:client:sendDispatch', xPlayer.source, "10-93",  'police', "ATM'i TURVAALARM")
    end

    while returnable == nil do
        Wait(50)
    end

    return returnable
end)





lib.callback.register('kk-robberies:atm:performRobbery', function(source, id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil
    
    if xPlayer then
        local money = math.random(Config.atmReward.min, Config.atmReward.max)
        local chance = math.random(1, 100)

        if chance >= 60 then
            ox_inventory:AddItem(xPlayer.source, 'atmmotherboard', 1)
            exports['kk-scripts']:sendLog(xPlayer.identifier, 'RÖÖVID', 'Sai ATMi röövilt $' .. money .. '  ja 1x Emmeplaadi.')
        else
            exports['kk-scripts']:sendLog(xPlayer.identifier, 'RÖÖVID', 'Sai ATMi röövilt $' .. money .. '.')
        end
        
        xPlayer.addAccountMoney('money', money)
        -- cooldowns[#cooldowns+1] = {cooldown = id, time = (Config.atmTimeout * 60000)}
        
        returnable = money
    else
        returnable = false
    end
    
    while returnable == nil do Wait(50) end; return returnable
end)
