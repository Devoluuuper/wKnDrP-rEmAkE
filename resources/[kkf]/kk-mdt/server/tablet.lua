-- Assuming KKF is loaded

-- Debug print function
local function debugPrint(...)
    if cfg.debug then
        print(...)
    end
end

-- Check if player has a valid job and is on duty (custom implementation for KKF)
local function hasJobAndDuty(source, allowedJobs)
    local xPlayer = KKF.GetPlayerFromId(source)
    if not xPlayer then return false end
    local job = xPlayer.job
    -- KKF does not have a native onduty system; assume a custom column `onduty` in users table
    local isOnDuty = xPlayer.get('onduty') or true -- Replace with your on-duty check
    return job and isOnDuty and (allowedJobs[job.name] or false)
end

-- Request department information
lib.callback.register('kk-mdt:requestDepartment', function(source)
    local xPlayer = KKF.GetPlayerFromId(source)
    if not xPlayer then return false end

    local jobName = xPlayer.job.name or 'unemployed'

    local query = "SELECT name, label, logo, blip_color, properties FROM jobs WHERE name = ?"
    local result = MySQL.query.await(query, {jobName})

    if result and #result > 0 then
        local row = result[1]
        local props = row.properties and json.decode(row.properties) or {}

        return {
            id = row.name,
            label = row.label or row.name,
            logo = row.logo or props.logo or "https://i.imgur.com/placeholder.png",
            blip_color = row.blip_color or "blue"
        }
    end

    return {
        id = jobName,
        label = jobName,
        logo = "https://i.imgur.com/placeholder.png",
        blip_color = "blue"
    }
end)

-- Search for players by name
lib.callback.register('kk-mdt:search', function(source, value)
    local searchValue = '%' .. string.gsub(value, '^%s*(.-)%s*$', '%1') .. '%'
    local query = "SELECT pid, firstname, lastname FROM users WHERE firstname LIKE ? OR lastname LIKE ? OR CONCAT(firstname, ' ', lastname) LIKE ?"
    local result = MySQL.query.await(query, {searchValue, searchValue, searchValue})
    debugPrint("Query result:", json.encode(result))
    if result and #result > 0 then
        local profiles = {}
        for _, row in ipairs(result) do
            if row.firstname and row.lastname then
                profiles[#profiles + 1] = {
                    pid = row.pid, -- Changed from pid to pid
                    name = row.firstname .. ' ' .. row.lastname
                }
            end
        end
        debugPrint("Profiles:", json.encode(profiles))
        return profiles
    end
    return false
end)

-- Search department members
lib.callback.register('kk-mdt:searchDepartmentMembers', function(source, value)
    if not cfg or not cfg.jobs or #cfg.jobs == 0 then return false end

    local placeholders = string.rep("?,", #cfg.jobs):sub(1, -2)
    local query = ([[
        SELECT 
            u.pid, 
            u.firstname, 
            u.lastname, 
            u.department, 
            j.label AS departmentLabel, 
            j.properties AS departmentProps
        FROM users u
        LEFT JOIN jobs j ON u.job = j.name
        WHERE u.department LIKE ? AND u.job IN (%s)
    ]]):format(placeholders)

    local searchValue = "%" .. value .. "%"
    local params = {searchValue}
    for _, job in ipairs(cfg.jobs) do
        table.insert(params, job)
    end

    local result = MySQL.query.await(query, params)
    if result and #result > 0 then
        local members = {}
        for _, row in ipairs(result) do
            local logo = "https://i.imgur.com/placeholder.png"
            if row.departmentProps then
                local props = json.decode(row.departmentProps) or {}
                logo = props.logo or logo
            end

            members[#members + 1] = {
                pid = row.pid, -- Changed from pid to pid
                firstname = row.firstname,
                lastname = row.lastname,
                department = row.department,
                departmentLabel = row.departmentLabel or row.department,
                departmentLogo = logo,
            }
        end
        return members
    end

    return false
end)

-- Search vehicles by plate
lib.callback.register('kk-mdt:searchVehicles', function(source, value)
    local query = [[
        SELECT ov.plate, ov.vehicle, ov.owner, u.firstname, u.lastname
        FROM user_vehicles ov
        LEFT JOIN users u ON ov.owner = u.pid
        WHERE UPPER(ov.plate) LIKE ?
    ]]

    local searchValue = '%' .. string.upper(value or "") .. '%'
    local success, result = pcall(MySQL.query.await, query, {searchValue})

    if not success then
        debugPrint("Database query failed: ", result)
        return false
    end

    if result and #result > 0 then
        local vehicles = {}
        for _, row in ipairs(result) do
            local vehicleModel = row.vehicle or "unknown"
            -- KKF vehicle names might need to be fetched from a vehicles table
            local vehicleLabel = vehicleModel -- Replace with vehicle name lookup if available

            local playerName = row.firstname and row.lastname and (row.firstname .. " " .. row.lastname) or "PUUDUB"

            vehicles[#vehicles + 1] = {
                plate = row.plate,
                vehicle = {
                    model = vehicleModel,
                    label = vehicleLabel 
                },
                pid = row.owner, -- Changed from pid to owner (pid)
                ownername = playerName
            }
        end
        return vehicles
    end

    return false
end)

-- Load vehicle profile
lib.callback.register('kk-mdt:loadVehicleProfile', function(source, plate)
    local query = [[
        SELECT ov.plate, ov.vehicle, ov.owner, u.firstname, u.lastname
        FROM user_vehicles ov
        LEFT JOIN users u ON ov.owner = u.pid
        WHERE ov.plate = ?
    ]]
    local result = MySQL.query.await(query, {plate})

    if not result or #result == 0 then
        debugPrint("No profile found for plate:", plate)
        return {}
    end

    local row = result[1]

    local vehicleModel = row.vehicle or "unknown"
    local vehicleLabel = vehicleModel -- Replace with vehicle name lookup if available

    local playerName = row.firstname and row.lastname and (row.firstname .. " " .. row.lastname) or "PUUDUB"

    return {
        plate = row.plate or "",
        pid = row.owner or "", -- Changed from pid to owner
        ownername = playerName,
        vehicle = {
            model = vehicleModel,
            label = vehicleLabel
        },
        wanted = "JAH",
        impoundLogs = {},
        punishments = {} 
    }
end)

-- Buy badge
lib.callback.register('kk-mdt:buyBadge', function(source, worker)
    local xPlayer = KKF.GetPlayerFromId(source)
    local price = 1000
    if xPlayer.getAccount('bank').money >= price then
        xPlayer.removeAccountMoney('bank', price)
        local query = "UPDATE users SET badge = ? WHERE pid = ?"
        local newBadge = 'NEW'
        MySQL.query.await(query, {newBadge, worker})
        return true
    end
    return false
end)

-- Save worker profile
lib.callback.register('kk-mdt:saveWorkerProfile', function(source, pid, department, callsign)
    local src = source
    department = department or "unemployed"
    callsign = callsign or "Puudub"

    -- Check if job is in cfg.jobs
    local allowed = false
    for _, v in ipairs(cfg.jobs) do
        if v:lower() == department:lower() then
            allowed = true
            break
        end
    end

    if not allowed then
        MySQL.update.await([[
            UPDATE users SET department = ?, callsign = ? WHERE pid = ?
        ]], { department, callsign, pid })

        local xPlayer = KKF.GetPlayerFrompid(pid)
        if xPlayer then
            xPlayer.set('callsign', callsign) -- Assuming custom metadata system
        end

        TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 5000)
        return true
    end

    local job = department:lower()

    -- Fetch job grade (assuming grade 100 is the highest)
    local gradeResult = MySQL.query.await(
        'SELECT grade, label FROM job_grades WHERE job_name = ? AND grade = 100 LIMIT 1',
        { job }
    )
    local grade = gradeResult and gradeResult[1] and gradeResult[1].grade or 100

    -- Update users table
    MySQL.update.await([[
        UPDATE users 
        SET department = ?, callsign = ?, job = ?, job_grade = ?
        WHERE pid = ?
    ]], {
        department,
        callsign,
        job,
        grade,
        pid
    })

    -- Update live KKF player
    local xPlayer = KKF.GetPlayerFrompid(pid)
    if xPlayer then
        local playerSrc = xPlayer.source
        xPlayer.setJob(job, grade)
        xPlayer.set('callsign', callsign) -- Assuming custom metadata system

        -- Notification to worker
        TriggerClientEvent('KKF.UI.ShowNotification', playerSrc, "Sind on määratud " .. department .. " struktuurüksusesse.", 5000)
    end

    -- Notification to admin
    TriggerClientEvent('KKF.UI.ShowNotification', src, "Profiil salvestatud!", 5000)

    return true
end)

-- Load worker profile
lib.callback.register('kk-mdt:loadWorkerProfile', function(source, pid)
    if not pid or pid == '' then
        if cfg.debug then
            debugPrint('Error: Invalid or missing pid for source ' .. source)
        end
        return false
    end
    local query = [[
        SELECT pid, firstname, lastname, job, job_grade, department, callsign, certificates
        FROM users
        WHERE pid = ?
    ]]
    local result = MySQL.query.await(query, { pid })

    if not result or #result == 0 then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Mängijat pid-ga ' .. pid .. ' ei leitud!', 5000)
        if cfg.debug then
            debugPrint('No player found for pid: ' .. pid)
        end
        return false
    end

    local player = result[1]
    local certs = {}

    if player.certificates then
        local status, decoded = pcall(json.decode, player.certificates)
        if status then
            certs = decoded
        else
            TriggerClientEvent('KKF.UI.ShowNotification', source, 'Viga sertifikaatide laadimisel pid-le ' .. pid, 5000)
        end
    end

    local certificates = {}
    for certName, certData in pairs(certs) do
        certificates[#certificates + 1] = {
            id = certName,
            label = certData.label or certName,
            value = certData.value == true
        }
    end

    local depLabel, depLogo = "Unknown Department", "https://i.imgur.com/placeholder.png"
    if player.department then
        local depQuery = "SELECT label, logo, properties FROM jobs WHERE name = ?"
        local depResult = MySQL.query.await(depQuery, { player.department })
        if depResult and #depResult > 0 then
            depLabel = depResult[1].label or depLabel
            local props = depResult[1].properties and json.decode(depResult[1].properties) or {}
            depLogo = depResult[1].logo or props.logo or depLogo
        else
            TriggerClientEvent('KKF.UI.ShowNotification', source, 'Osakonda ' .. player.department .. ' ei leitud!', 5000)
        end
    else
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Mängijal puudub osakonna info!', 5000)
    end

    local departments = {}
    if cfg and cfg.jobs then
        for _, jobName in ipairs(cfg.jobs) do
            local jobData = MySQL.query.await("SELECT label, logo, properties FROM jobs WHERE name = ?", { jobName })
            if jobData and #jobData > 0 then
                local props = jobData[1].properties and json.decode(jobData[1].properties) or {}
                departments[#departments + 1] = {
                    id = jobName,
                    label = jobData[1].label or jobName,
                    logo = jobData[1].logo or props.logo or "https://i.imgur.com/placeholder.png"
                }
            end
        end
    end

    return {
        pid = player.pid, -- Changed from pid to pid
        name = player.firstname .. ' ' .. player.lastname,
        job = player.job,
        grade = player.job_grade,
        department = player.department,
        departmentLabel = depLabel,
        departmentLogo = depLogo,
        callsign = player.callsign,
        certificates = certificates,
        departments = departments
    }
end)

-- Toggle certificate
lib.callback.register('kk-mdt:toggleCertificate', function(source, worker, cert)
    local pid = worker
    local certKey = cert

    local result = MySQL.query.await("SELECT certificates, job, department FROM users WHERE pid = ?", { pid })
    if not result or #result == 0 then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Mängijat pid-ga ' .. pid .. ' ei leitud!', 5000)
        return false
    end

    local player = result[1]
    local certs = player.certificates and json.decode(player.certificates) or {}

    local job = player.job or player.department
    if not job then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Mängijal puudub töö või osakonna info!', 5000)
        return false
    end

    local certLabel = certKey
    if cfg.factionCertificates and cfg.factionCertificates[job] and cfg.factionCertificates[job][certKey] then
        certLabel = cfg.factionCertificates[job][certKey].label or certKey
    else
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Sertifikaati ' .. certKey .. ' ei leitud fraktsiooni ' .. job .. ' jaoks!', 5000)
    end

    local added = false
    if certs[certKey] and certs[certKey].value == true then
        certs[certKey].value = false
        added = false
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Sertifikaat eemaldatud!', 5000)
    else
        certs[certKey] = { label = certLabel, value = true }
        added = true
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Sertifikaat lisatud!', 5000)
    end

    local success, err = pcall(function()
        MySQL.update.await("UPDATE users SET certificates = ? WHERE pid = ?", { json.encode(certs), pid })
    end)

    if not success then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Viga sertifikaatide uuendamisel andmebaasis!', 5000)
        return false
    end

    return added
end)

-- Search statements
lib.callback.register('kk-mdt:searchStatements', function(source, value)
    local searchValue = '%' .. (value or '') .. '%'
    local query = "SELECT id, pid, name, email, date FROM mdt_statements WHERE text LIKE ?"
    local result = MySQL.query.await(query, {searchValue})
    return result or {}
end)

-- Load statement
lib.callback.register('kk-mdt:loadStatement', function(source, pid)
    if not pid then return false end
    local query = "SELECT * FROM mdt_statements WHERE pid = ? ORDER BY date DESC LIMIT 1"
    local result = MySQL.query.await(query, {pid})
    return result and #result > 0 and result[1] or false
end)

-- Remove statement
lib.callback.register('kk-mdt:removeStatement', function(source, id)
    local query = "DELETE FROM mdt_statements WHERE id = ?"
    local result = MySQL.query.await(query, {id})
    return result and result.affectedRows > 0
end)

-- Load player profile
lib.callback.register('kk-mdt:loadProfile', function(source, pid)
    local playerQuery = [[
        SELECT u.pid, u.firstname, u.lastname, u.accounts, u.job, u.job_grade, u.department, 
               u.callsign, u.notes, u.wanted, u.wanted_reason, u.profilepic,
               j.label AS departmentLabel, j.properties AS departmentProps
        FROM users u
        LEFT JOIN jobs j ON u.department = j.name
        WHERE u.pid = ?
    ]]
    local playerResult = MySQL.query.await(playerQuery, {pid})
    if not playerResult or #playerResult == 0 then return false end
    local player = playerResult[1]

    local accounts = {}
    if type(player.accounts) == "string" then
        local ok, decoded = pcall(json.decode, player.accounts)
        if ok and type(decoded) == "table" then
            accounts = decoded
        end
    end

    local licenses = {}
    if accounts.licences and type(accounts.licences) == "table" then
        licenses = accounts.licences
    elseif accounts.licenses and type(accounts.licenses) == "table" then
        licenses = accounts.licenses
    end

    local wantedText = player.wanted or ""
    local isWanted = wantedText ~= ""

    local vehiclesQuery = [[
        SELECT plate, vehicle, owner, stored, police_impound
        FROM user_vehicles WHERE owner = ?
    ]]
    local vehicles = MySQL.query.await(vehiclesQuery, {pid}) or {}

    for _, v in ipairs(vehicles) do
        local vehicleInfo = v.vehicle -- Replace with vehicle name lookup if available
        v.model = v.vehicle or "unknown"
        v.modelLabel = vehicleInfo or v.model
    end

    local deptLogo = "https://i.imgur.com/placeholder.png"
    local deptLabel = player.departmentLabel or "Unknown Department"
    if player.departmentProps then
        local props = json.decode(player.departmentProps) or {}
        deptLogo = props.logo or deptLogo
    end

    local profile = {
        pid = player.pid,
        firstname = player.firstname or "Unknown",
        lastname = player.lastname or "Player",
        name = (player.firstname or "Unknown").." "..(player.lastname or "Player"),
        dateofbirth = "Unknown", -- KKF does not store dateofbirth by default; adjust if custom field exists
        department = {
            label = deptLabel,
            logo = deptLogo
        },
        job = player.job or "unemployed",
        grade = player.job_grade or 0,
        callsign = player.callsign or "Puudub",
        notes = player.notes or "",
        wanted = isWanted,
        wanted_reason = player.wanted_reason or "",
        profilepic = player.profilepic or "https://i.imgur.com/placeholder.png",
        licenses = licenses,
        vehicles = vehicles
    }

    return profile
end)

-- Update wanted profile
lib.callback.register('kk-mdt:updateWantedProfile', function(source, pid, value)
    if not pid then return false end

    local isWanted = false
    local reason = ""

    if value and value ~= "" then
        isWanted = true
        reason = value
    end

    local wantedStatus = isWanted and "JAH" or "EI"

    local query = "UPDATE users SET wanted = ?, wanted_reason = ? WHERE pid = ?"
    local result = MySQL.query.await(query, {wantedStatus, reason, pid})

    return result and result.affectedRows > 0
end)

-- Save notes
lib.callback.register('kk-mdt:saveNotes', function(source, pid, notes)
    if not pid or not notes then
        debugPrint(string.format("Error: Invalid input - pid: %s, notes: %s", tostring(pid), tostring(notes)))
        return false
    end

    local checkQuery = "SELECT 1 FROM users WHERE pid = ?"
    local checkResult = MySQL.query.await(checkQuery, {pid})
    if not checkResult or #checkResult == 0 then
        debugPrint("Error: pid " .. pid .. " not found in users table")
        return false
    end

    local query = "UPDATE users SET notes = ? WHERE pid = ?"
    local success, result = pcall(function()
        return MySQL.query.await(query, {notes, pid})
    end)

    if not success then
        debugPrint("Error executing query: " .. tostring(result))
        return false
    end

    local saved = result and result.affectedRows > 0
    if not saved then
        debugPrint("No rows updated for pid: " .. pid)
    end

    return saved
end)

-- Get notes
lib.callback.register('kk-mdt:getNotes', function(source, pid)
    if not pid then
        debugPrint("Error: Invalid pid for getNotes")
        return nil
    end

    local query = "SELECT notes FROM users WHERE pid = ?"
    local result = MySQL.query.await(query, {pid})
    if result and #result > 0 then
        return result[1].notes or ''
    end
    return nil
end)

-- Remove license
lib.callback.register('kk-mdt:removeLicense', function(source, pid, license)
    local query = "SELECT accounts FROM users WHERE pid = ?"
    local result = MySQL.query.await(query, {pid})
    if result and #result > 0 then
        local accounts = json.decode(result[1].accounts or '{}')
        local licenses = accounts.licences or accounts.licenses or {}
        licenses[license] = nil
        accounts.licences = licenses
        local updateQuery = "UPDATE users SET accounts = ? WHERE pid = ?"
        local updateResult = MySQL.query.await(updateQuery, {json.encode(accounts), pid})
        return updateResult and updateResult.affectedRows > 0
    end
    return false
end)

-- Create diagnose
lib.callback.register('kk-mdt:createDiagnose', function(source, target, description, done, damages, bill, intensive, prescriptions)
    if not hasJobAndDuty(source, {['ambulance'] = true}) then
        return false
    end
    local query = "INSERT INTO mdt_diagnoses (pid, description, done, damages, bill, intensive, prescriptions) VALUES (?, ?, ?, ?, ?, ?, ?)"
    local result = MySQL.query.await(query, {target, description, done, json.encode(damages), bill, intensive, json.encode(prescriptions)})
    return result and result.affectedRows > 0
end)

-- Create case
lib.callback.register('kk-mdt:createCase', function(source, target, description, fine, jail, punishments, strikePoints)
    local query = "INSERT INTO mdt_cases (pid, description, fine, jail, punishments, strike_points) VALUES (?, ?, ?, ?, ?, ?)"
    local result = MySQL.query.await(query, {target, description, fine, jail, json.encode(punishments), strikePoints})
    if result and result.affectedRows > 0 and jail > 0 then
        local xPlayer = KKF.GetPlayerFrompid(target)
        if xPlayer then
            -- Assuming a jail system compatible with KKF (e.g., KKF_jail)
            TriggerEvent('KKF_jail:sendToJail', xPlayer.source, jail)
        end
    end
    return result and result.affectedRows > 0
end)

-- Load staff page
lib.callback.register('kk-mdt:loadStaffPage', function(source)
    if not cfg or not cfg.jobs or #cfg.jobs == 0 then
        return {}
    end

    local placeholders = string.rep("?,", #cfg.jobs):sub(1, -2)
    local query = ([[
        SELECT j.name as id, j.label, j.logo, j.blip_color, COUNT(u.pid) as members
        FROM jobs j
        LEFT JOIN users u ON u.job = j.name
        WHERE j.name IN (%s)
        GROUP BY j.name, j.label, j.logo, j.blip_color
    ]]):format(placeholders)

    local result = MySQL.query.await(query, cfg.jobs)

    local data = {}
    if result and #result > 0 then
        for _, row in ipairs(result) do
            data[#data + 1] = {
                id = row.id,
                label = row.label,
                logo = row.logo or "https://i.imgur.com/placeholder.png",
                blip_color = row.blip_color or "blue",
                members = row.members or 0
            }
        end
    end

    return data
end)

-- Load departments
lib.callback.register('kk-mdt:loadDepartments', function(source)
    local query = "SELECT name, label, properties FROM jobs"
    local result = MySQL.query.await(query)

    if result and #result > 0 then
        local data = {}
        for _, row in ipairs(result) do
            local props = {}
            if row.properties then
                props = json.decode(row.properties) or {}
            end

            local members = MySQL.scalar.await("SELECT COUNT(*) FROM users WHERE department = ?", {row.name})

            data[#data+1] = {
                id = row.name,
                label = row.label,
                blip_color = props.blip_color or "blue",
                logo = props.logo or "https://i.imgur.com/placeholder.png",
                members = members
            }
        end
        return data
    end
    return false
end)

-- Load department
lib.callback.register('kk-mdt:loadDepartment', function(source, department)
    local query = "SELECT name, label, properties FROM jobs WHERE name = ?"
    local result = MySQL.query.await(query, {department})

    if result and #result > 0 then
        local row = result[1]
        local props = {}
        if row.properties then
            props = json.decode(row.properties) or {}
        end

        return {
            name = row.name,
            label = row.label,
            blip_color = props.blip_color or "blue",
            logo = props.logo or "https://i.imgur.com/placeholder.png"
        }
    end
    return false
end)

-- Save department
lib.callback.register('kk-mdt:saveDepartment', function(source, id, label, blip_color, logo)
    local properties = json.encode({blip_color = blip_color, logo = logo})
    local query = "UPDATE jobs SET label = ?, properties = ? WHERE name = ?"
    local result = MySQL.query.await(query, {label, properties, id})
    return result and result.affectedRows > 0
end)

-- Nice behavior accept (jail time reduction)
lib.callback.register('kk-mdt:niceBehaviorAccept', function(source, id, desc, value, name)
    local query = "UPDATE users SET jail = jail - ? WHERE pid = ?"
    local result = MySQL.query.await(query, {value, id})
    return result and result.affectedRows > 0
end)

-- Dipla accept (jail time reduction)
lib.callback.register('kk-mdt:diplaAccept', function(source, id, desc, value, name)
    local query = "UPDATE users SET jail = jail - ? WHERE pid = ?"
    local result = MySQL.query.await(query, {value, id})
    return result and result.affectedRows > 0
end)

-- Refresh document page
lib.callback.register('kk-mdt:refreshDocPage', function(source)
    local diagnoses = MySQL.query.await("SELECT * FROM mdt_diagnoses ORDER BY id DESC LIMIT 10")
    local cases = MySQL.query.await("SELECT * FROM mdt_cases ORDER BY id DESC LIMIT 10")
    return { diagnoses = diagnoses or {}, cases = cases or {} }
end)