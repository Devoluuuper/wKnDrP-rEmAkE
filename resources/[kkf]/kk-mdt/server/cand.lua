-- Load KKF

-- Insert candidate with pid
lib.callback.register('kk-mdt:insertCandidateWithTime', function(source, fullName, email, motivation)
    if not fullName or fullName == "" or not email or email == "" or not motivation or motivation == "" then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Väljad on tühjad!', 5000, 'error')
        return {success = false, message = "Väljad on tühjad"}
    end

    -- Get pid from KKF
    local xPlayer = KKF.GetPlayerFromId(source)
    local pid = xPlayer and xPlayer.pid or nil

    if not pid then
        print("Error: No pid for source " .. tostring(source))
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'pid puudub!', 5000, 'error')
        return {success = false, message = "pid puudub"}
    end

    local query = "INSERT INTO mdt_candidacies (pid, name, email, text, date) VALUES (?, ?, ?, ?, UNIX_TIMESTAMP(NOW()))"
    local insertResult = MySQL.query.await(query, {pid, fullName, email, motivation})

    if not insertResult then
        print("Insert failed for pid: " .. tostring(pid))
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Insert ebaõnnestus!', 5000, 'error')
        return {success = false, message = "Insert ebaõnnestus"}
    end

    TriggerClientEvent('KKF.UI.ShowNotification', source, 'Kandideerimine edukalt esitatud!', 5000, 'success')
    return {success = true}
end)

-- Load candidacy by id
lib.callback.register('kk-mdt:loadCandidation', function(source, id)
    if not id or id == "" then
        print("Error: Invalid id received: " .. tostring(id))
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Kehtetu ID!', 5000, 'error')
        return false
    end

    local query = "SELECT id, pid, name, email, text, date FROM mdt_candidacies WHERE id = ?"
    local result = MySQL.query.await(query, {id})
    
    if not result or #result == 0 then
        print("No candidacy found for id: " .. tostring(id))
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Kandideerimist ID-ga ' .. tostring(id) .. ' ei leitud!', 5000, 'error')
        return false
    end

    return result[1]
end)

-- Search candidacies
lib.callback.register('kk-mdt:searchCandidations', function(source, value)
    local query = "SELECT id, name, pid, date FROM mdt_candidacies WHERE name LIKE ?"
    local searchValue = '%' .. value .. '%'
    local result = MySQL.query.await(query, {searchValue})
    
    if not result then
        print("Search failed for value: " .. tostring(value))
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Otsing ebaõnnestus!', 5000, 'error')
        return false
    end
    
    return result
end)

-- Remove candidacy by id
lib.callback.register('kk-mdt:removeCandidation', function(source, id)
    local query = "DELETE FROM mdt_candidacies WHERE id = ?"
    local result = MySQL.query.await(query, {id})
    
    if result and result.affectedRows > 0 then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Kandideerimine edukalt eemaldatud!', 5000, 'success')
        return true
    else
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Kandideerimise eemaldamine ebaõnnestus!', 5000, 'error')
        return false
    end
end)