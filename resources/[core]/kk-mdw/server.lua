local function removeLicense(source, pid, license)
    local xTarget = KKF.GetPlayerFromIdentifier(pid)

    if xTarget then
        if xTarget.licenses[license] then
            xTarget.removeLicense(license)
            TriggerClientEvent('KKF.UI.ShowNotification', source, 'info', 'Karistatava luba ' .. license .. ' eemaldati.')
        end
    else
        MySQL.Async.fetchAll('SELECT licenses FROM users WHERE pid = ?', { pid }, function(result)
            if result[1] then
                local currentLicenses = json.decode(result[1].licenses)

                if currentLicenses[license] then
                    currentLicenses[license] = false

                    MySQL.Async.execute('UPDATE users SET licenses = ? WHERE pid = ?', {
                        json.encode(currentLicenses),
                        pid
                    }, function()
                        TriggerClientEvent('KKF.UI.ShowNotification', source, 'info', 'Karistatava luba ' .. license .. ' eemaldati.')
                    end)
                end
            end
        end)
    end
end

lib.callback.register('kk-mdw:createCase', function(source, pid, offences, notes, fine, jail, dmv_points, weapon_points)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        local count = 0
        local offenses = ''

        for k,v in pairs(offences) do
            count += 1
            offenses = offenses .. ' | ' .. v
        end
        
        if count == 1 then
            offenses = offences[1]
        elseif count > 1 then
            offenses = offenses:sub(4)
        end

        MySQL.Async.execute('INSERT INTO user_punishments (pid, officer, offenses, fine, time, description, jail) VALUES (@pid, @officer, @offenses, @fine, @time, @description, @jail)', { 
            ['@pid'] = pid,
            ['@officer'] = xPlayer.get('firstName') .. ' ' .. xPlayer.get('lastName') .. ' (' .. xPlayer.identifier .. ')',
            ['@offenses'] = offenses,
            ['@fine'] = fine,
            ['@time'] = os.date('%Y-%m-%d %X'),
            ['@description'] = notes,
            ['@jail'] = jail
        }, function(result)
		TriggerEvent('kk-society:server:updateBills', source)

            if tonumber(fine) > 0 then
                MySQL.Sync.execute('INSERT INTO billing (identifier, sender, target, label, amount, time) VALUES (@identifier, @sender, @target, @label, @amount, @time)', {
                    ['@identifier'] = pid,
                    ['@sender'] = xPlayer.identifier,
                    ['@target'] = "police",
                    ['@label'] = "Politsei arve | Trahv",
                    ['@amount'] = fine,
                    ['@time'] = os.date('%Y-%m-%d %X')
                })                
                
            end 

            MySQL.Async.fetchAll('SELECT license, points FROM license_points WHERE pid = ? AND license = ?', { pid, 'dmv' }, function(result)
                if result and result[1] then
                    MySQL.Sync.execute('UPDATE license_points SET points = ? WHERE pid = ? AND license = ?', { result[1].points + dmv_points, pid, 'dmv' })

                    if (result[1].points + dmv_points) >= 30 then removeLicense(xPlayer.source, pid, 'dmv') end
                else
                    MySQL.Sync.execute('INSERT INTO license_points (pid, license, points) VALUES (?, ?, ?)', { pid, 'dmv', dmv_points })

                    if dmv_points >= 30 then removeLicense(xPlayer.source, pid, 'dmv') end
                end
            end)

            MySQL.Async.fetchAll('SELECT license, points FROM license_points WHERE pid = ? AND license = ?', { pid, 'weapon' }, function(result)
                if result and result[1] then
                    MySQL.Sync.execute('UPDATE license_points SET points = ? WHERE pid = ? AND license = ?', { result[1].points + weapon_points, pid, 'weapon' })

                    if (result[1].points + weapon_points) >= 30 then removeLicense(xPlayer.source, pid, 'weapon') end
                else
                    MySQL.Sync.execute('INSERT INTO license_points (pid, license, points) VALUES (?, ?, ?)', { pid, 'weapon', weapon_points })

                    if weapon_points >= 30 then removeLicense(xPlayer.source, pid, 'weapon') end
                end
            end)

            local xTarget = KKF.GetPlayerFromIdentifier(pid)

            if xTarget then
                if tonumber(jail) > 0 then
                    TriggerEvent("kk-jail:jailPlayer", xTarget.source, jail, xPlayer.source)
                    returnable = true
                else
                    returnable = true
                end
            else
                if tonumber(jail) > 0 then
                    MySQL.Async.fetchAll('SELECT jail_time FROM users WHERE pid = ?', {
                        pid
                    }, function(result)
                        if result and result[1] then
                            if tonumber(result[1].jail_time) > 0 then
                                MySQL.Sync.execute('UPDATE users SET jail_time = ? WHERE pid = ?', { result[1].jail_time + jail, pid })
                            else
                                MySQL.Sync.execute('UPDATE users SET jail_time = ? WHERE pid = ?', { jail, pid })
                            end

                            returnable = true
                        else
                            returnable = true
                        end
                    end)
                else
                    returnable = true
                end
            end
        end)
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end) 

lib.callback.register('kk-mdw:loadWanted', function(source)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if xPlayer.job.name == 'police' then
            MySQL.Async.fetchAll('SELECT pid, firstname, lastname, wanted_reason FROM users WHERE is_wanted = ?', { true }, function(result)
                returnable = result
            end)
        else
            returnable = {}
        end
    else
        returnable = {}
    end

    while returnable == nil do Wait(50) end; return returnable
end)  

lib.callback.register('kk-mdw:loadFines', function(source, context)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        local sql = ''

        if context ~= '' then sql = 'WHERE LOWER(`label`) LIKE ?' end
        
        MySQL.Async.fetchAll('SELECT id, label, points, punishments, category FROM police_fines ' .. sql, { string.lower('%'..context..'%') }, function(result)
            for k,v in pairs(result) do
                result[k].points = json.decode(result[k].points)
                result[k].punishments = json.decode(result[k].punishments)
            end

            returnable = result
        end)
    else
        returnable = {}
    end

    while returnable == nil do Wait(50) end; return returnable
end)  

lib.callback.register('kk-mdw:setWanted', function(source, pid, reason)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if xPlayer.job.name == 'police' then
            if reason ~= '' then
                MySQL.Async.execute('UPDATE users SET is_wanted = ? WHERE pid = ?', { true, pid }, function(result)
                    MySQL.Async.execute('UPDATE users SET wanted_reason = ? WHERE pid = ?', { reason, pid }, function(result)
                        exports['kk-scripts']:sendSocietyLog(xPlayer.source, 'MDW INFOSÜSTEEM', 'Märkis isiku tagaotsitavaks ISIKUKOOD:' .. pid .. '.')
                        returnable = true
                    end)
                end)
            else
                MySQL.Async.execute('UPDATE users SET is_wanted = ? WHERE pid = ?', { false, pid }, function(result)
                    MySQL.Async.execute('UPDATE users SET wanted_reason = ? WHERE pid = ?', { '', pid }, function(result)
                        exports['kk-scripts']:sendSocietyLog(xPlayer.source, 'MDW INFOSÜSTEEM', 'Eemaldas isiku tagaotsitavavuse ISIKUKOOD:' .. pid .. '.')
                        returnable = false
                    end)
                end)
            end
        else
            returnable = false
        end
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)  

lib.callback.register('kk-mdw:removeLicense', function(source, pid, license)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        local xTarget = KKF.GetPlayerFromIdentifier(pid)

        if xTarget then
            exports['kk-scripts']:sendSocietyLog(xPlayer.source, 'MDW INFOSÜSTEEM', 'Eemaldas loa LUBA: ' .. license .. '; ISIKUKOOD:' .. pid .. '.')
            xTarget.removeLicense(license); returnable = true
        else
            MySQL.Async.fetchAll('SELECT licenses FROM users WHERE pid = ?', { pid }, function(result)
                if result and result[1] then
                    local currentLicenses = json.decode(result[1].licenses)
                    currentLicenses[license] = false

                    MySQL.Async.execute('UPDATE users SET licenses = ? WHERE pid = ?', {
                        json.encode(currentLicenses),
                        pid
                    }, function(result)
                        exports['kk-scripts']:sendSocietyLog(xPlayer.source, 'MDW INFOSÜSTEEM', 'Eemaldas loa LUBA: ' .. license .. '; ISIKUKOOD:' .. pid .. '.')
                        returnable = true
                    end)
                else
                    returnable = false
                end
            end)
        end
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

lib.callback.register('kk-mdw:giveLicense', function(source, pid, license)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        local xTarget = KKF.GetPlayerFromIdentifier(pid)

        if xTarget then
            exports['kk-scripts']:sendSocietyLog(xPlayer.source, 'MDW INFOSÜSTEEM', 'Andis loa LUBA: ' .. license .. '; ISIKUKOOD:' .. pid .. '.')
            xTarget.giveLicense(license); returnable = true
        else
            MySQL.Async.fetchAll('SELECT licenses FROM users WHERE pid = ?', { pid }, function(result)
                if result and result[1] then
                    local currentLicenses = json.decode(result[1].licenses)
                    currentLicenses[license] = true

                    MySQL.Async.execute('UPDATE users SET licenses = ? WHERE pid = ?', {
                        json.encode(currentLicenses),
                        pid
                    }, function(result)
                        exports['kk-scripts']:sendSocietyLog(xPlayer.source, 'MDW INFOSÜSTEEM', 'Andis loa LUBA: ' .. license .. '; ISIKUKOOD:' .. pid .. '.')
                        returnable = true
                    end)
                else
                    returnable = false
                end
            end)
        end
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

lib.callback.register('kk-mdw:loadRecords', function(source, pid)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if xPlayer.job.name == 'police' then
            MySQL.Async.fetchAll('SELECT * FROM user_punishments WHERE pid = ? ORDER BY id DESC', { pid }, function(result)
                if result and result[1] then
                    returnable = result
                else
                    returnable = {}
                end
            end)
        else
            returnable = {}
        end
    else
        returnable = {}
    end

    while returnable == nil do Wait(50) end; return returnable
end)

lib.callback.register('kk-mdw:saveNotes', function(source, pid, notes)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if xPlayer.job.name == 'police' then
            MySQL.Async.execute('UPDATE users SET notes = ? WHERE pid = ?', {
                notes,
                pid
            }, function(result)
                exports['kk-scripts']:sendSocietyLog(xPlayer.source, 'MDW INFOSÜSTEEM', 'Uuendas ISIKUKOOD:' .. pid .. ' märkmeid.')
                returnable = true
            end)
        else
            returnable = false
        end
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

local function getPoints(pid, license)
    local returnable = nil

    MySQL.Async.fetchAll('SELECT points FROM license_points WHERE pid = ? AND license = ?', { pid, license }, function(result)
        if result and result[1] then 
            returnable = result[1].points
        else
            returnable = 0
        end
    end)

    while returnable == nil do Wait(50) end; return returnable
end

lib.callback.register('kk-mdw:loadOffenceDetails', function(source, id)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if xPlayer.job.name == 'police' then
            MySQL.Async.fetchAll('SELECT pid, officer, offenses, fine, description, jail FROM user_punishments WHERE id = ?', { id }, function(result)
                if result and result[1] then
                    result[1].fine = '$' .. result[1].fine
                    returnable = result[1]
                else
                    returnable = {}
                end
            end)
        else
            returnable = {}
        end
    else
        returnable = {}
    end

    while returnable == nil do Wait(50) end; return returnable
end)

lib.callback.register('kk-mdw:loadCharacterProperties', function(source, pid)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if xPlayer.job.name == 'police' then
            local results = {
                vehicles = {},
                weapons = {}
            }

            MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE pid = ?', { pid }, function(xTarget)
                if xTarget and xTarget[1] then
                    MySQL.Async.fetchAll('SELECT owner, vehicle, plate, ownername FROM user_vehicles WHERE owner = ?', { pid }, function(result)
                        for k,v in pairs(result) do
                            result[k].model = json.decode(v.vehicle).model
                            result[k].vehicle = {}
                        end
    
                        results.vehicles = result
    
                        MySQL.Async.fetchAll('SELECT license, owner, name FROM user_weapons WHERE owner = ?', {
                            xTarget[1].firstname .. ' ' .. xTarget[1].lastname .. ' (' .. pid .. ')'
                        }, function(result)
                            results.weapons = result

                            returnable = results
                        end)
                    end)
                else
                    returnable = {}
                end
            end)
        else
            returnable = {}
        end
    else
        returnable = {}
    end

    while returnable == nil do Wait(50) end; return returnable
end)

lib.callback.register('kk-mdw:loadCharacter', function(source, pid, opening)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if xPlayer.job.name == 'police' then
            if pid:find('society_') then
                returnable = false
            else
                MySQL.Async.fetchAll('SELECT * FROM users WHERE pid = ?', { pid }, function(result)
                    if result and result[1] then
                        if opening then exports['kk-scripts']:sendSocietyLog(xPlayer.source, 'MDW INFOSÜSTEEM', 'Avas ' .. result[1].firstname .. ' ' .. result[1].lastname .. ' profiili.') end
                        local data = {
                            id = 0,
                            pid = result[1].pid,
                            fullname = result[1].firstname .. ' ' .. result[1].lastname,
                            dob = 'Sünnikuupäev: ' .. result[1].dateofbirth,
                            phone = 'Telefoninumber: ' .. result[1].phone,
                            health = json.decode(result[1].licenses).health and 'Tervisetõend: Kehtib' or not json.decode(result[1].licenses).health and 'Tervisetõend: Kehtetu',
                            notes = result[1].notes,
                            is_wanted = result[1].is_wanted,
                            wanted_reason = result[1].wanted_reason,
                            profilepic = result[1].profilepic,
                            licenses = {
                                [1] = {
                                    name = 'dmv',
                                    label = 'Juhiluba',
                                    state = json.decode(result[1].licenses)['dmv'],
                                    points = getPoints(pid, 'dmv')
                                },

                                [2] = {
                                    name = 'weapon',
                                    label = 'Relvaluba',
                                    state = json.decode(result[1].licenses)['weapon'],
                                    points = getPoints(pid, 'weapon')
                                }
                            }
                        }

                        local xTarget = KKF.GetPlayerFromIdentifier(result[1].pid)

                        if xTarget then
                            data['id'] = xTarget.source
                        end

                        returnable = data
                    else
                        returnable = {}
                    end
                end)

            end
        else
            returnable = {}
        end
    else
        returnable = {}
    end

    while returnable == nil do Wait(50) end; return returnable
end)

lib.callback.register('kk-mdw:search', function(source, context)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if xPlayer.job.name == 'police' then
            local results = {
                persons = {},
                vehicles = {},
                weapons = {}
            }

            MySQL.Async.fetchAll("SELECT pid, firstname, lastname FROM users WHERE LOWER(`firstname`) LIKE @query OR LOWER(`lastname`) LIKE @query OR CONCAT(LOWER(`firstname`), ' ', LOWER(`lastname`)) LIKE @query OR phone LIKE @query2 LIMIT 10", {
                ['@query'] = string.lower('%'..context..'%'), 
                ['@query2'] = string.lower(context..'%')
            }, function(result)
                results.persons = result

                MySQL.Async.fetchAll('SELECT owner, vehicle, plate, ownername FROM user_vehicles WHERE LOWER(`plate`) LIKE @query LIMIT 10', {
                    ['@query'] = string.lower('%'..context..'%'),
                }, function(result)
                    for k,v in pairs(result) do
                        result[k].model = json.decode(v.vehicle).model
                        result[k].society = result[k].owner:find('society_') or false
                        result[k].vehicle = {}
                    end
    
                    results.vehicles = result

                    MySQL.Async.fetchAll('SELECT license, owner, name FROM user_weapons WHERE LOWER(`license`) LIKE @query OR LOWER(`owner`) LIKE @query OR LOWER(`name`) LIKE @query LIMIT 10', {
                        ['@query'] = string.lower('%'..context..'%'),
                    }, function(result)
                        results.weapons = result

                        returnable = results
                    end)
                end)
            end)
        else
            returnable = {}
        end
    else
        returnable = {}
    end

    while returnable == nil do Wait(50) end; return returnable
end)

exports['kk-scripts']:addAction(10, 00, function()
    MySQL.Async.fetchAll('SELECT * FROM license_points', {}, function(result)
        for k,v in pairs(result) do
            local currentLicense = result[k]

            if currentLicense.points > 0 then
                MySQL.Sync.execute('UPDATE license_points SET points = ? WHERE pid = ? AND license = ?', { currentLicense.points - 1, currentLicense.pid, currentLicense.license })
            end
        end
    end)
end) 

exports['kk-scripts']:addAction(15, 00, function()
    MySQL.Async.fetchAll('SELECT * FROM license_points', {}, function(result)
        for k,v in pairs(result) do
            local currentLicense = result[k]

            if currentLicense.points > 0 then
                MySQL.Sync.execute('UPDATE license_points SET points = ? WHERE pid = ? AND license = ?', { currentLicense.points - 1, currentLicense.pid, currentLicense.license })
            end
        end
    end)
end) 

exports['kk-scripts']:addAction(20, 00, function()
    MySQL.Async.fetchAll('SELECT * FROM license_points', {}, function(result)
        for k,v in pairs(result) do
            local currentLicense = result[k]

            if currentLicense.points > 0 then
                MySQL.Sync.execute('UPDATE license_points SET points = ? WHERE pid = ? AND license = ?', { currentLicense.points - 1, currentLicense.pid, currentLicense.license })
            end
        end
    end)
end) 