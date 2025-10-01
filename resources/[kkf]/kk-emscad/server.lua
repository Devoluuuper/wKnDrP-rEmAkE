lib.callback.register('kk-emscad:createCase', function(source, pid, offences, notes, fine)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
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

        MySQL.Async.execute('INSERT INTO user_emsbills (pid, medic, injuries, bill, time, description) VALUES (@pid, @medic, @injuries, @bill, @time, @description)', { 
            ['@pid'] = pid,
            ['@medic'] = xPlayer.get('firstName') .. ' ' .. xPlayer.get('lastName') .. ' (' .. xPlayer.identifier .. ')',
            ['@injuries'] = offenses,
            ['@bill'] = fine,
            ['@time'] = os.date('%Y-%m-%d %X'),
            ['@description'] = notes
        }, function(result)
		TriggerEvent('kk-society:server:updateBills', source)

            if tonumber(fine) > 0 then
                MySQL.Sync.execute('INSERT INTO billing (identifier, sender, target, label, amount, time) VALUES (@identifier, @sender, @target, @label, @amount, @time)', {
                    ['@identifier'] = pid,
                    ['@sender'] = xPlayer.identifier,
                    ['@target'] = "ambulance",
                    ['@label'] = "Meediku arve | Arve",
                    ['@amount'] = fine,
                    ['@time'] = os.date('%Y-%m-%d %X')
                })
                
            end 

            returnable = true
        end)
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end) 


lib.callback.register('kk-emscad:loadWanted', function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if xPlayer.job.name == 'ambulance' then
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

lib.callback.register('kk-emscad:loadFines', function(source, context)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        local sql = ''

        if context ~= '' then sql = 'WHERE LOWER(`label`) LIKE ?' end
        
        MySQL.Async.fetchAll('SELECT id, label, punishments FROM ems_bills ' .. sql, { string.lower('%'..context..'%') }, function(result)
            for k,v in pairs(result) do
                result[k].punishments = json.decode(result[k].punishments)
            end

            returnable = result
        end)
    else
        returnable = {}
    end

    while returnable == nil do Wait(50) end; return returnable
end)  

lib.callback.register('kk-emscad:loadRecords', function(source, pid)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if xPlayer.job.name == 'ambulance' then
            MySQL.Async.fetchAll('SELECT * FROM user_emsbills WHERE pid = ? ORDER BY id DESC', { pid }, function(result)
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

lib.callback.register('kk-emscad:saveNotes', function(source, pid, notes)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if xPlayer.job.name == 'ambulance' then
            MySQL.Async.execute('UPDATE users SET notes = ? WHERE pid = ?', {
                notes,
                pid
            }, function(result)
                returnable = true
				exports['kk-scripts']:sendSocietyLog(xPlayer.source, 'CAD INFOSÜSTEEM', 'Uuendas ISIKUKOOD:' .. pid .. ' märkmeid.')
            end)
        else
            returnable = false
        end
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)


lib.callback.register('kk-emscad:loadOffenceDetails', function(source, id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if xPlayer.job.name == 'ambulance' then
            MySQL.Async.fetchAll('SELECT pid, medic, injuries, bill, description FROM user_emsbills WHERE id = ?', { id }, function(result)
                if result and result[1] then
                    result[1].bill = '$' .. result[1].bill
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


lib.callback.register('kk-emscad:loadCharacter', function(source, pid)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if xPlayer.job.name == 'ambulance' then
            if pid:find('society_') then
                returnable = false
            else
                MySQL.Async.fetchAll('SELECT * FROM users WHERE pid = ?', { pid }, function(result)
                    if result and result[1] then
                        local data = {
                            id = 0,
                            pid = result[1].pid,
                            fullname = result[1].firstname .. ' ' .. result[1].lastname,
                            dob = 'Sünnikuupäev: ' .. result[1].dateofbirth,
                            phone = 'Telefoninumber: ' .. result[1].phone,
                            job = 'Elukutse: ' .. exports['kk-society']:getName(result[1].job),
                            health = json.decode(result[1].licenses).health and 'Tervisetõend: Kehtib' or not json.decode(result[1].licenses).health and 'Tervisetõend: Kehtetu',
                            notes = result[1].notes,
                            is_wanted = result[1].is_wanted,
                            wanted_reason = result[1].wanted_reason,
                            profilepic = result[1].profilepic,
                        }

                        local xTarget = ESX.GetPlayerFromIdentifier(result[1].pid)

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

lib.callback.register('kk-emscad:search', function(source, context)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if xPlayer.job.name == 'ambulance' then
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

                returnable = results
            end)
        else
            returnable = {}
        end
    else
        returnable = {}
    end

    while returnable == nil do Wait(50) end; return returnable
end)


lib.callback.register('kk-emscad:giveLicense', function(source, pid)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local license = "health"
	
    local returnable = nil

    if xPlayer then
        local xTarget = ESX.GetPlayerFromIdentifier(pid)

        if xTarget then
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
   exports['kk-scripts']:sendSocietyLog(xPlayer.source, 'CAD INFOSÜSTEEM', 'Lisas isikule tervisetõendi ISIKUKOOD:' .. pid .. '.')
    while returnable == nil do Wait(50) end; return returnable
end)


lib.callback.register('kk-emscad:removeLicense', function(source, pid)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil
	    local license = "health"

    if xPlayer then
        local xTarget = ESX.GetPlayerFromIdentifier(pid)

        if xTarget then
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
exports['kk-scripts']:sendSocietyLog(xPlayer.source, 'CAD INFOSÜSTEEM', 'Eemaldas isiku tervisetõendi ISIKUKOOD:' .. pid .. '.')
    while returnable == nil do Wait(50) end; return returnable
end)