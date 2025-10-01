local earnings = cfg.earnings

local function round(num)
    return math.floor(num + 0.5)
end

lib.callback.register('kk-taxi:jobComplete', function(source, kmDistance)
    local xPlayer = ESX.GetPlayerFromId(source)
    local returnable = nil

    if xPlayer then
        if xPlayer.job.name == 'taxi' then
            local grade = xPlayer.job.grade
            local earningsPerKm = math.random(earnings.min, earnings.max)
            local totalEarnings = earningsPerKm * kmDistance

            local rankConfig = cfg.ranks[grade] or cfg.fallback

            local playerMoney = totalEarnings * rankConfig.person
            local societyMoney = totalEarnings * rankConfig.faction

            -- Round the money values
            playerMoney = round(playerMoney)
            societyMoney = round(societyMoney)

            -- Update the player's money and the faction's money
            ESX.UpdateCheck(xPlayer.source, 'add', playerMoney)
            TriggerEvent('Society.AddMoney', 'taxi', societyMoney)

            TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, "success", 'Teenisite: '..playerMoney ..'$'.. ' Firma teenis: '.. societyMoney..'$')
            returnable = true
        else
            returnable = false
        end
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end
    return returnable
end)


lib.callback.register('kk-taxi:checkFaction', function(source, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local returnable = nil

    if xPlayer then
        if xPlayer.job.name == 'taxi' then
            MySQL.Async.fetchScalar('SELECT owner FROM user_vehicles WHERE plate = @plate', {
                ['@plate'] = plate
            }, function(owner)
                if owner == 'society_taxi' then
                    returnable = true
                else
                    returnable = false
                end
            end)
        else
            print(('[kk-taxi] [^3WARNING^7] %s attempted to trigger kk-taxi:checkFaction (cheating)'):format(xPlayer.identifier))
            returnable = false
        end
    else
        returnable = false
    end

	while returnable == nil do Wait(50) end; return returnable
end)