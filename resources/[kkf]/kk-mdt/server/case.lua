
local function getPlayerData(source)
    local xPlayer = KKF.GetPlayerFromId(source)
    if xPlayer then
        return {
            pid = xPlayer.pid, -- Changed from pid to pid
            firstname = xPlayer.get('firstname') or 'Unknown', -- Adjust if firstname is stored differently
            lastname = xPlayer.get('lastname') or 'Unknown', -- Adjust if lastname is stored differently
            callsign = xPlayer.get('callsign') or 'Unknown' -- Assuming custom callsign field
        }
    end
    return nil
end

-- Search cases by value (e.g., title or description)
lib.callback.register('kk-mdt:searchCases', function(source, value)
    value = value or "" -- Fallback
    value = value:gsub("([%%_])", "%%%1") -- Escape % and _ characters
    local searchValue = '%' .. value .. '%'

    local success, result = pcall(MySQL.query.await,
        [[
            SELECT * FROM mdt_cases
            WHERE (COALESCE(title, '') LIKE ? OR COALESCE(description, '') LIKE ?)
            ORDER BY id DESC
            LIMIT 50
        ]],
        {searchValue, searchValue}
    )

    if not success then
        print("MDT searchCases error:", result)
        return {}
    end

    return result or {}
end)

-- Create a new case
lib.callback.register('kk-mdt:createNewCase', function(source)
    local Player = getPlayerData(source)
    if not Player then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Player data not found!', 5000, 'error')
        return false
    end

    local success, insertId = pcall(MySQL.insert.await,
        'INSERT INTO mdt_cases (pid, creator, status, date) VALUES (?, ?, ?, ?)',
        {Player.pid, Player.pid, 'Avatud', os.time()}
    )

    if not success then
        print("MDT createNewCase error:", insertId)
        return false
    end

    return insertId > 0 and insertId or false
end)

-- Request case information
lib.callback.register('kk-mdt:requestInfo', function(source, caseId)
    local success, result = pcall(MySQL.query.await, 
        'SELECT * FROM mdt_cases WHERE id = ?', {caseId}
    )

    if not success then
        print("MDT requestInfo error:", result)
        return nil
    end

    if result and #result > 0 then
        return result[1]
    else
        return nil
    end
end)

lib.callback.register('kk-mdt:updateInfo', function(source, caseId, title, description)
    local Player = getPlayerData(source)
    if not Player then return false end

    local lastEditTime = os.time()

    local success, result = pcall(function()
        local rowsChanged = MySQL.update.await([[
            UPDATE mdt_cases 
            SET title = ?, description = ?, last_edit = ?, last_editor_id = ?
            WHERE id = ?
        ]], {title, description, lastEditTime, Player.pid, caseId})
        return rowsChanged > 0
    end)

    if not success or not result then
        print("MDT updateInfo error:", result)
        return false
    end

    -- Tagastame kohe vajalikud andmed JS poolele
    return {
        last_editor = {
            firstname = Player.firstname or 'Unknown',
            lastname  = Player.lastname or 'Unknown'
        },
        last_edit = lastEditTime
    }
end)


-- Add person to case
lib.callback.register('kk-mdt:addPersonCase', function(source, caseId, pid, memberType, role)
    -- Fetch player info from database
    local result = MySQL.query.await('SELECT firstname, lastname FROM users WHERE pid = ?', {pid})
    local firstname, lastname = "Unknown", "Unknown"

    if result and #result > 0 then
        firstname = result[1].firstname or "Unknown"
        lastname = result[1].lastname or "Unknown"
    end

    MySQL.Async.execute('INSERT INTO mdt_case_members (case_id, player_id, firstname, lastname, role) VALUES (?, ?, ?, ?, ?)', 
        {caseId, pid, firstname, lastname, role or "Unknown"}
    )
    
    return true
end)

-- Add dispatch members (officers)
lib.callback.register('kk-mdt:addDispatchMembers', function(source, caseId)
    local Player = getPlayerData(source)
    if not Player then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Player data not found!', 5000, 'error')
        return false
    end

    local pid = Player.pid or ""
    local firstname = Player.firstname or "Unknown"
    local lastname = Player.lastname or "Unknown"

    -- Security check for job and grade
    local xPlayer = KKF.GetPlayerFromId(source)
    local jobName = xPlayer.job.name or "unknown"
    local jobGrade = xPlayer.job.grade or 0

    -- Fetch callsign and rank from job_grades
    local gradeData = MySQL.Sync.fetchAll([[
        SELECT label AS rank, short AS callsign
        FROM job_grades
        WHERE job_name = ? AND grade = ?
    ]], {
        jobName,
        jobGrade
    })

    local callsign = "Puudub"
    local rank = "Unknown"
    if gradeData[1] then
        callsign = gradeData[1].callsign or "Puudub"
        rank = gradeData[1].rank or "Unknown"
    end

    -- Insert officer into mdt_case_officers
    local rowsChanged = MySQL.Sync.execute([[
        INSERT INTO mdt_case_officers (case_id, officer_id, firstname, lastname, callsign, role)
        VALUES (?, ?, ?, ?, ?, ?)
    ]], {
        caseId,
        pid,
        firstname,
        lastname,
        callsign,
        'officer'
    })

    if rowsChanged > 0 then
        return {
            pid = pid,
            firstname = firstname,
            lastname = lastname,
            callsign = callsign,
            role = 'officer',
            rank = rank
        }
    else
        return false
    end
end)

-- UUID generator for vehicles
local function generateUUID()
    return string.gsub("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx", "[xy]", function(c)
        local v = (c == "x") and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format("%x", v)
    end)
end

-- Load case with members, officers, and vehicles
lib.callback.register('kk-mdt:loadCase', function(source, caseId)
    -- Case info
    local caseData = MySQL.query.await('SELECT * FROM mdt_cases WHERE id = ?', {caseId})
    if not caseData or #caseData == 0 then return false end
    local caseInfo = caseData[1]

    -- Members
    local members = MySQL.query.await([[
        SELECT player_id AS pid, firstname, lastname, role
        FROM mdt_case_members
        WHERE case_id = ?
    ]], {caseId})

    for i, v in ipairs(members) do
        v.firstname = v.firstname ~= "" and v.firstname or "Unknown"
        v.lastname = v.lastname ~= "" and v.lastname or "Unknown"
        v.role = v.role ~= "" and v.role or "Unknown"
    end

    -- Officers
    local officers = MySQL.query.await([[
        SELECT officer_id AS pid, firstname, lastname, callsign, role
        FROM mdt_case_officers
        WHERE case_id = ?
    ]], {caseId})

    for i, v in ipairs(officers) do
        v.firstname = v.firstname ~= "" and v.firstname or "Unknown"
        v.lastname = v.lastname ~= "" and v.lastname or "Unknown"
        v.role = v.role ~= "" and v.role or "Unknown"
        v.callsign = v.callsign or "Puudub"

        -- Fetch officer job info from users table
        local playerData = MySQL.query.await('SELECT job, job_grade, callsign AS player_callsign FROM users WHERE pid = ?', {v.pid})

        local jobName, jobGrade = "Unknown", 100
        if playerData and playerData[1] then
            jobName = playerData[1].job or "Unknown"
            jobGrade = playerData[1].job_grade or 100
            v.callsign = playerData[1].player_callsign or v.callsign
        end

        -- Fetch rank and callsign from job_grades
        local gradeData = MySQL.query.await([[
            SELECT label AS rank, short AS callsign
            FROM job_grades
            WHERE job_name = ? AND grade = ?
        ]], {jobName, jobGrade})

        if gradeData and gradeData[1] then
            v.grade = gradeData[1].rank or "Unknown"
            v.callsign = gradeData[1].callsign or v.callsign
        else
            v.grade = "Unknown"
        end
    end

    -- Vehicles
    local vehicles = MySQL.query.await([[
        SELECT id, case_id, plate, vehicle, officer, uuid
        FROM mdt_case_vehicles
        WHERE case_id = ?
    ]], {caseId})

    -- Creator and last editor names
    local creatorName, lastEditorName = "PUUDUB", "PUUDUB"
    if caseInfo.creator then
        local creatorData = MySQL.query.await('SELECT firstname, lastname FROM users WHERE pid = ?', {caseInfo.creator})
        if creatorData and #creatorData > 0 then
            creatorName = (creatorData[1].firstname or "") .. " " .. (creatorData[1].lastname or "")
        end
    end
    if caseInfo.last_editor_id then
        local editorData = MySQL.query.await('SELECT firstname, lastname FROM users WHERE pid = ?', {caseInfo.last_editor_id})
        if editorData and #editorData > 0 then
            lastEditorName = (editorData[1].firstname or "") .. " " .. (editorData[1].lastname or "")
        end
    end

    return {
        id = caseInfo.id,
        title = caseInfo.title,
        description = caseInfo.description,
        status = caseInfo.status,
        date = caseInfo.date,
        last_edit = caseInfo.last_edit,
        creator = {name = creatorName},
        last_editor = {name = lastEditorName},
        members = members or {},
        officers = officers or {},
        vehicles = vehicles or {},
        confiscatedItems = {}
    }
end)

-- Join a case
lib.callback.register('kk-mdt:joinCase', function(source, caseId)
    local Player = getPlayerData(source)

    if not Player then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Player data not found!', 5000, 'error')
        return false -- tagastame kohe false
    end

    -- Lisame politseinikku juhtumisse
    local query = 'INSERT INTO mdt_case_officers (case_id, officer_id, firstname, lastname, callsign, role) VALUES (?, ?, ?, ?, ?, ?)'
    local parameters = {
        caseId,
        Player.pid,
        Player.firstname,
        Player.lastname,
        Player.callsign,
        'officer'
    }

    -- Kuna MySQL.Async.insert on asünkroonne, ei saa returniga kohe insertId tagastada
    -- Kui tahad returniga lahendust, tuleb kasutada sync meetodit (nt MySQL.Sync.insert)
    local insertId = MySQL.Sync.insert(query, parameters)

    -- Tagastame tulemuse true/false
    if insertId and insertId > 0 then
        return true
    else
        return false
    end
end)



-- Search case player
lib.callback.register('kk-mdt:searchCasePlayer', function(source, value)
    value = value or ""
    local searchValue = '%' .. string.gsub(value, '^%s*(.-)%s*$', '%1') .. '%'

    local query = [[
        SELECT pid, firstname, lastname, profilepic
        FROM users
        WHERE firstname LIKE ? OR lastname LIKE ? OR CONCAT(firstname, ' ', lastname) LIKE ?
    ]]

    local success, result = pcall(MySQL.query.await, query, {searchValue, searchValue, searchValue})
    if not success then
        print("MDT searchCasePlayer error:", result)
        return {}
    end

    local profiles = {}
    if result and #result > 0 then
        for _, row in ipairs(result) do
            local firstname = row.firstname or "Unknown"
            local lastname = row.lastname or "Unknown"
            local profilepic = row.profilepic or "https://via.placeholder.com/64"

            table.insert(profiles, {
                pid = row.pid, -- Changed from pid to pid
                firstname = firstname,
                lastname = lastname,
                name = firstname .. " " .. lastname,
                dateofbirth = "Unknown", -- KKF does not store dateofbirth by default
                profilepic = profilepic
            })
        end
    end

    return profiles
end)

-- Remove a case member
lib.callback.register('kk-mdt:removeCaseMember', function(source, caseId, pid)
    local rowsChanged = MySQL.update.await(
        'DELETE FROM mdt_case_members WHERE case_id = ? AND player_id = ?',
        {caseId, pid}
    )
    return rowsChanged > 0
end)

-- Remove a case officer
lib.callback.register('kk-mdt:removeCaseOfficer', function(source, caseId, pid)
    local rowsChanged = MySQL.Sync.execute(
        'DELETE FROM mdt_case_officers WHERE case_id = ? AND officer_id = ?',
        {caseId, pid}
    )

    return rowsChanged > 0
end)

-- Request protocol data
lib.callback.register('kk-mdt:requestProtocolData', function(source, caseId, pid)
    local result = MySQL.query.await([[
        SELECT role, punishments, fine, jail
        FROM mdt_cases
        WHERE id = ? AND pid = ?
    ]], {caseId, pid})

    if not result or #result == 0 then return nil end

    local data = result[1]

    local punishments = {}
    if data.punishments and data.punishments ~= "" then
        local success, decoded = pcall(json.decode, data.punishments)
        if success and type(decoded) == "table" then
            punishments = decoded
        end
    end

    return {
        role = data.role or "Unknown",
        punishments = punishments,
        fine = data.fine or 0,
        jail = data.jail or 0,
        reduction = 0, -- Fallback
        guilt = false, -- Fallback
        isPunished = false -- Fallback
    }
end)

-- Check if player can jail
function CanJail(playerId)
    local xPlayer = KKF.GetPlayerFromId(playerId)
    if not xPlayer then return false end

    -- Check if player has police job and sufficient grade
    return xPlayer.job.name == "police" and xPlayer.job.grade >= 2
end

exports('canJail', CanJail)

-- Update protocol data
lib.callback.register('kk-mdt:updateProtocolData', function(source, caseId, pid, role, punishments, fine, jail, reduction, guilt)
    if type(punishments) ~= "table" then
        if punishments == nil then
            punishments = {}
        else
            punishments = { punishments }
        end
    end

    if #punishments == 0 then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Karistust ei saa rakendada, kui ühtegi karistust ei ole määratud!', 5000, 'error')
        return false
    end

    local canJail = exports['kk-mdt']:canJail(source)
    if (tonumber(jail) > 0 and canJail) or (tonumber(jail) == 0) then
        local rowsChanged = MySQL.update.await([[
            UPDATE mdt_cases 
            SET role = ?, 
                punishments = ?, 
                fine = ?, 
                jail = ?, 
                reduction = ?, 
                guilt = ? 
            WHERE id = ? AND pid = ?
        ]], {
            role,
            json.encode(punishments),
            fine,
            jail,
            reduction,
            guilt,
            caseId,
            pid
        })

        return rowsChanged > 0
    else
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Vanglasse saatmiseks peate olema vastavas tsoonis!', 5000, 'error')
        return false
    end
end)

-- Request officer data
lib.callback.register('kk-mdt:requestOfficerData', function(source, data)
    if type(data) == "number" then
        data = { case = data, pid = tostring(getPlayerData(source).pid) }
    elseif type(data) ~= "table" then
        print("[kk-mdt] Invalid data passed to requestOfficerData:", data)
        return false
    end

    local caseId = data.case
    local pid = data.pid

    local officerData = MySQL.query.await([[
        SELECT officer_id AS pid, firstname, lastname, callsign, role
        FROM mdt_case_officers
        WHERE case_id = ? AND officer_id = ?
    ]], {caseId, pid})

    if officerData and #officerData > 0 then
        local officer = officerData[1]

        local playerData = MySQL.query.await('SELECT job, job_grade FROM users WHERE pid = ?', {officer.pid})
        local gradeName = "Unknown"

        if playerData and playerData[1] then
            local jobName = playerData[1].job or "Unknown"
            local jobGrade = playerData[1].job_grade or 0

            local gradeData = MySQL.query.await([[
                SELECT label 
                FROM job_grades 
                WHERE job_name = ? AND grade = ?
            ]], {jobName, jobGrade})
            if gradeData and #gradeData > 0 then
                gradeName = gradeData[1].label or "Unknown"
            end
        end

        officer.rank = gradeName
        return officer
    end

    return false
end)

-- Update officer data
lib.callback.register('kk-mdt:updateOfficerData', function(source, cb, caseId, pid, role)
    MySQL.Async.execute('UPDATE mdt_case_officers SET role = ? WHERE case_id = ? AND officer_id = ?', {
        role,
        caseId,
        pid
    }, function(rowsChanged)
        cb(rowsChanged > 0)
    end)
end)

-- Add confiscated item
lib.callback.register('kk-mdt:addConfiscatedItem', function(source, cb, caseId, pid, item, amount)
    local Player = getPlayerData(source)
    if not Player then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Player data not found!', 5000, 'error')
        return cb(false)
    end

    MySQL.Async.insert('INSERT INTO mdt_case_items (case_id, pid, name, amount, officer, uuid) VALUES (?, ?, ?, ?, ?, ?)', {
        caseId,
        pid,
        item,
        amount,
        Player.pid,
        generateUUID()
    }, function(insertId)
        cb(insertId > 0)
    end)
end)

-- Remove confiscated item
lib.callback.register('kk-mdt:removeConfiscatedItem', function(source, cb, caseId, pid, uuid)
    MySQL.Async.execute('DELETE FROM mdt_case_items WHERE case_id = ? AND pid = ? AND uuid = ?', {
        caseId,
        pid,
        uuid
    }, function(rowsChanged)
        cb(rowsChanged > 0)
    end)
end)

-- Update case file status
lib.callback.register('kk-mdt:caseFileStatus', function(source, caseId, status)
    local success, result = pcall(function()
        local queryResult = MySQL.query.await(
            'UPDATE mdt_cases SET status = ? WHERE id = ?',
            {status, caseId}
        )
        return queryResult.affectedRows > 0
    end)

    if not success then
        print("MDT caseFileStatus error:", result)
        return false
    end

    return result
end)

-- Confirm punishment
lib.callback.register('kk-mdt:confirmPunishment', function(source, cb, caseId, pid, role, punishments, fine, jail, reduction, faultPoints, guilt)
    if type(punishments) ~= "table" then
        if punishments == nil then
            punishments = {}
        else
            punishments = { punishments }
        end
    end

    if #punishments == 0 then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Karistust ei saa rakendada, kui ühtegi karistust ei ole määratud!', 5000, 'error')
        return cb(false)
    end

    local canJail = exports['kk-mdt']:canJail(source)
    if (tonumber(jail) > 0 and canJail) or (tonumber(jail) == 0) then
        MySQL.Async.execute('UPDATE mdt_cases SET role = ?, punishments = ?, fine = ?, jail = ?, reduction = ?, strike_points = ?, guilt = ? WHERE id = ? AND pid = ?', {
            role,
            json.encode(punishments),
            fine,
            jail,
            reduction,
            faultPoints,
            guilt,
            caseId,
            pid
        }, function(rowsChanged)
            if rowsChanged > 0 and tonumber(jail) > 0 then
                local xPlayer = KKF.GetPlayerFrompid(pid)
                if xPlayer then
                    TriggerEvent('KKF_jail:sendToJail', xPlayer.source, jail)
                end
            end
            cb(rowsChanged > 0)
        end)
    else
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Vanglasse saatmiseks peate olema vastavas tsoonis!', 5000, 'error')
        cb(false)
    end
end)

-- Add vehicle to case
lib.callback.register('kk-mdt:addVehicleItem', function(source, caseId, vehicle, plate)
    local Player = getPlayerData(source)
    if not Player then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Player data not found!', 5000, 'error')
        return false
    end

    -- If vehicle is empty, fetch from plate
    if not vehicle or vehicle == "" then
        local result = MySQL.query.await('SELECT vehicle FROM owned_vehicles WHERE plate = ?', {plate})

        if result and #result > 0 then
            vehicle = result[1].vehicle or "Unknown"
            -- Add vehicle name lookup if available
        else
            vehicle = "Unknown"
        end
    end

    local insertId = MySQL.insert.await(
        'INSERT INTO mdt_case_vehicles (case_id, plate, vehicle, officer, uuid) VALUES (?, ?, ?, ?, ?)',
        { caseId, plate, vehicle, Player.pid, generateUUID() }
    )

    return insertId and insertId > 0
end)

-- Remove vehicle from case
lib.callback.register('kk-mdt:removeVehicleItem', function(source, caseId, uuid)
    local rowsChanged = MySQL.Sync.execute([[
        DELETE FROM mdt_case_vehicles
        WHERE case_id = ? AND uuid = ?
    ]], {
        caseId,
        uuid
    })

    return rowsChanged > 0
end)

-- Check if vehicle exists
lib.callback.register('kk-mdt:doesVehicleExist', function(source, plate)
    print("Server got plate:", plate) -- Debug
    local result = MySQL.query.await('SELECT * FROM owned_vehicles WHERE plate = ?', {plate})

    if not result or #result == 0 then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Antud sõidukit ei eksisteeri andmebaasis!', 5000, 'error')
        return false
    end

    return true
end)

-- Delete a case
lib.callback.register('kk-mdt:policeCaseDelete', function(source, cb, caseId)
    MySQL.Async.fetchAll('SELECT * FROM mdt_cases WHERE id = ?', { caseId }, function(result)
        if not result or not result[1] then
            TriggerClientEvent('KKF.UI.ShowNotification', source, 'Antud juhtumit enam ei eksisteeri!', 5000, 'error')
            return cb(false)
        end

        MySQL.Async.execute('DELETE FROM mdt_cases WHERE id = ?', { caseId }, function(rowsChanged)
            if rowsChanged > 0 then
                MySQL.Async.execute('DELETE FROM mdt_case_members WHERE case_id = ?', { caseId })
                MySQL.Async.execute('DELETE FROM mdt_case_officers WHERE case_id = ?', { caseId })
                MySQL.Async.execute('DELETE FROM mdt_case_items WHERE case_id = ?', { caseId })
                MySQL.Async.execute('DELETE FROM mdt_case_vehicles WHERE case_id = ?', { caseId })
                cb(true)
            else
                TriggerClientEvent('KKF.UI.ShowNotification', source, 'Juhtumi kustutamine ebaõnnestus!', 5000, 'error')
                cb(false)
            end
        end)
    end)
end)