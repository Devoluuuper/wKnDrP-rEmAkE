-- Load KKF

-- Register usable badge item
KKF.RegisterUsableItem('badge', function(source, item)
    local xPlayer = KKF.GetPlayerFromId(source)
    if not xPlayer then return end

    local job = xPlayer.job.name
    local allowed = false
    for _, v in ipairs(cfg.jobs) do
        if v == job then
            allowed = true
            break
        end
    end
    if not allowed then return end

    local department = xPlayer.job.name or 'unemployed'
    local jobGrade = xPlayer.job.grade or 0

    -- Fetch job grade label
    local gradeResult = MySQL.query.await(
        'SELECT label FROM job_grades WHERE job_name = ? AND grade = ?',
        { department, jobGrade }
    )
    local gradeName = gradeResult and gradeResult[1] and gradeResult[1].label or 'Unknown'

    -- Fetch job logo
    local jobResult = MySQL.query.await(
        'SELECT logo FROM jobs WHERE name = ? LIMIT 1',
        { department }
    )
    local jobLogo = jobResult and jobResult[1] and jobResult[1].logo or 'https://i.imgur.com/default.png'

    -- Fetch player profile data
    local playerResult = MySQL.query.await(
        'SELECT profilepic, callsign FROM users WHERE identifier = ? LIMIT 1',
        { xPlayer.identifier }
    )

    local profilePic = playerResult and playerResult[1] and playerResult[1].profilepic or 'img/default.png'
    local callSign = playerResult and playerResult[1] and playerResult[1].callsign or xPlayer.get('callsign') or 'N/A'

    local data = {
        name = (xPlayer.get('firstname') or 'N/A') .. ' ' .. (xPlayer.get('lastname') or 'N/A'), -- Adjust if firstname/lastname are stored differently
        callsign = callSign,
        department = xPlayer.job.label or 'Unknown',
        rank = gradeName,
        badge = jobLogo,
        profile = profilePic
    }

    TriggerClientEvent('kk-mdt:client:chooseBadgeTarget', source, data)
end)

-- Show badge to target
RegisterNetEvent('kk-mdt:server:showBadgeTo', function(targetId, data)
    local src = source
    if not data then return end

    TriggerClientEvent('kk-mdt:client:showBadgeSelf', src, data)

    if targetId then
        TriggerClientEvent('kk-mdt:client:showBadgeOther', targetId, data)
    end
end)