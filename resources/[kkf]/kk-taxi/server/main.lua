local lastPlayerSuccess = {}

local dispatchTimeout = {}

local function updateStats(pid)
    local result = MySQL.prepare.await('SELECT done, pid FROM taxi_job WHERE pid = ?', {pid})

    if result then
        MySQL.Sync.execute('UPDATE taxi_job SET done = done + 1 WHERE pid = ?;', { pid})
    else
        MySQL.insert.await('INSERT INTO taxi_job (pid, done) VALUES (?, ?)', { pid, 1 })
    end
end

--[[AddEventHandler('kk-dispatch:server:respondCall', function(source, callData)
    if callData and source then
        local kPlayer = KKF.GetPlayerFromId(source)

        if kPlayer then
            if kPlayer.job.name == 'taxi' then
                if not dispatchTimeout[kPlayer.identifier] then
                    if callData.code == '10-21' then
                        updateStats(kPlayer.identifier)

                        dispatchTimeout[kPlayer.identifier] = true

                        SetTimeout(60000 * 2, function()
                            dispatchTimeout[kPlayer.identifier] = nil
                        end)
                    end
                end
            end
        end
    end
end)]]

lib.callback.register('kk-taxi:jobComplete', function(source, distance)
    local kPlayer = KKF.GetPlayerFromId(source)

    if kPlayer then
        local timeNow = os.clock()

        if kPlayer.job.name == 'taxi' and kPlayer.job.onDuty then
            if not lastPlayerSuccess[source] or timeNow - lastPlayerSuccess[source] > 5 then
                lastPlayerSuccess[source] = timeNow
                math.randomseed(os.time())
                
                local kmPrice = math.random(cfg.earnings.min, cfg.earnings.max)
                local totalEarnings = kmPrice * distance

                if totalEarnings > cfg.maxEarn then
                    totalEarnings = cfg.maxEarn
                end

                local rankPercentage = cfg.ranks[kPlayer.job.grade]

                if not rankPercentage then
                    rankPercentage = cfg.fallback
                end

                local factionEarnings = KKF.Math.Round(totalEarnings * rankPercentage.faction)
                local playerEarnings = KKF.Math.Round(totalEarnings * rankPercentage.person)
    
                TriggerEvent('Society.AddMoney', kPlayer.job.name, factionEarnings)
                kPlayer.addAccountMoney('bank', playerEarnings)
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'info', 'Teenisid $' .. playerEarnings .. '!')
                updateStats(kPlayer.identifier)
                return true
            else
                return false
            end
        else
            print(('[^3WARNING^7] Player ^5%s^7 attempted to ^5kk-taxi:success^7 (cheating)'):format(source))
            return false
        end
    else
        return false
    end
end)

lib.callback.register('kk-taxi:dutyChange', function(source, status)
    local kPlayer = KKF.GetPlayerFromId(source)

    if kPlayer then
        kPlayer.setDuty(status, true)

        return true
    else
        return false
    end
end)

lib.callback.register('kk-taxi:checkFaction', function(source, plate)
    local kPlayer = KKF.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.job.permissions.function11 then
            return true
        else
            return MySQL.Sync.fetchScalar('SELECT COUNT(*) FROM user_vehicles WHERE plate = ? AND owner = ?;', { tostring(plate), 'society_' .. kPlayer.job.name }) > 0
        end
    else
        return false
    end
end)
