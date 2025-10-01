local playerSkillsCache = {}

function CachePlayerSkills(pid, skills)
    playerSkillsCache[pid] = skills
end

function GetCachedPlayerSkills(pid)
    return playerSkillsCache[pid]
end

function InitializePlayerSkills(xPlayer)
    if cfg.Core == 'KK' then
        if xPlayer then
            local pid = xPlayer.identifier
            local cachedSkills = GetCachedPlayerSkills(pid)

            if cachedSkills then
                if cfg.debug then
                    print('Player skills already cached for', pid)
                end
                return
            end

            MySQL.Async.fetchAll('SELECT skills FROM user_skills WHERE pid = ?', { pid }, function(results)
                local skillsToUpdate = false
                local defaultSkills = {}

                -- Prepare default skills
                for _, skillName in ipairs(cfg.skills) do
                    defaultSkills[skillName] = { lvl = 1, progress = 0 }
                end

                if results and #results > 0 then
                    -- Player has existing skills
                    local skills = results[1].skills
                    if skills and skills ~= "" and skills ~= "{}" then
                        local existingSkills = json.decode(skills)

                        -- Check for missing or obsolete skills
                        for skillName, _ in pairs(existingSkills) do
                            if not defaultSkills[skillName] then
                                -- Remove obsolete skill
                                existingSkills[skillName] = nil
                                skillsToUpdate = true
                            end
                        end

                        for skillName, defaultValue in pairs(defaultSkills) do
                            if not existingSkills[skillName] then
                                -- Add missing skill
                                existingSkills[skillName] = defaultValue
                                skillsToUpdate = true
                            end
                        end

                        if skillsToUpdate then
                            -- Update the database with the updated skills
                            local query = 'UPDATE user_skills SET skills = ? WHERE pid = ?'
                            local params = { json.encode(existingSkills), pid }

                            MySQL.Async.execute(query, params, function(success)
                                if cfg.debug then
                                    print('Skills updated for player', pid, 'Success:', success)
                                end
                            end)
                        end

                        CachePlayerSkills(pid, existingSkills)
                        return
                    end
                end

                -- If no existing skills, initialize with defaults
                local query = 'INSERT INTO user_skills (pid, skills) VALUES (?, ?)'
                local params = { pid, json.encode(defaultSkills) }

                MySQL.Async.execute(query, params, function(success)
                    if cfg.debug then
                        print('Skills initialized for player', pid, 'Success:', success)
                    end
                end)

                CachePlayerSkills(pid, defaultSkills)
            end)
        else
            if cfg.debug then
                print('Failed to get valid player data for player', playerId)
            end
        end
    end
end



-- RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function()
--     InitializePlayerSkills(source)
-- end)


AddEventHandler('KKF.Player.Loaded', function(source, xPlayer)
    if cfg.debug then
        print('[kk-SKILLS] Debug, Player Loaded: '..xPlayer.identifier)
    end 
    InitializePlayerSkills(xPlayer)
end)


lib.callback.register('kk-skills:requestSkill', function(source)
    if cfg.Core == 'KK' then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            local cachedSkills = GetCachedPlayerSkills(xPlayer.identifier)
            if cachedSkills then
                if cfg.debug then
                    print("Skills found in cache for", xPlayer.identifier)
                end
                return cachedSkills
            else
                local results = MySQL.Sync.fetchAll('SELECT skills FROM user_skills WHERE pid = ?', { xPlayer.identifier })
                if cfg.debug then
                    print("Skills Table:", json.encode(results[1].skills))
                end
                if results ~= nil then
                    local decodedSkills = json.decode(results[1].skills)
                    -- Cache fetched skills
                    CachePlayerSkills(xPlayer.identifier, decodedSkills)
                    return decodedSkills
                else
                    return nil
                end
            end
        else
            return
        end
    end
end)


function GetSkillLevel(source, skill)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local cachedSkills = GetCachedPlayerSkills(xPlayer.identifier)
        if cachedSkills then
            if cfg.debug then
                print('Skills found in cache for', xPlayer.identifier)
            end
            local skillData = cachedSkills[skill]
            if skillData and skillData.lvl then
                return skillData.lvl
            else
                return 1
            end
        else
            local results = MySQL.Sync.fetchAll('SELECT skills FROM user_skills WHERE pid = ?', { xPlayer.identifier })
            if cfg.debug then
                print("Skills Table:", json.encode(results[1].skills))
            end
            if results ~= nil then
                local decodedSkills = json.decode(results[1].skills)
                local skillData = decodedSkills[skill]
                if skillData and skillData.lvl then
                    CachePlayerSkills(xPlayer.identifier, decodedSkills)
                    return skillData.lvl
                else
                    return 1
                end
            else
                return 1
            end
        end
    else
        return 1
    end
end
-- Example usage:  exports['kk-skills']:GetSkillLevel(source, skill)


function AddSkillProgress(playerId, skill, progressToAdd)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if xPlayer then
        local pid = xPlayer.identifier
        local cachedSkills = GetCachedPlayerSkills(pid)

        if cachedSkills then
            if cachedSkills[skill] then
                local decodedSkills = cachedSkills
                -- Round progressToAdd to two decimal places
                progressToAdd = math.round(progressToAdd * 100) / 100
                decodedSkills[skill].progress = decodedSkills[skill].progress + progressToAdd

                TriggerClientEvent('ox_lib:defaultNotify', playerId, {
                    title = 'Oskused',
                    status = 'inform',
                    duration = 5000,
                    description = "Oskus: "..skill..' +'..progressToAdd,
                })

                if decodedSkills[skill].progress >= 100 then
                    decodedSkills[skill].progress = 0
                    decodedSkills[skill].lvl = math.min(decodedSkills[skill].lvl + 1, cfg.maxlvl)

                    TriggerClientEvent('ox_lib:defaultNotify', playerId, {
                        title = 'Oskused',
                        status = 'inform',
                        duration = 5000,
                        description = "Saavutasid uue taseme! Oskus: "..skill..', Tase: '..decodedSkills[skill].lvl,
                    })

                    if cfg.debug then
                        print('Skill level increased for player', pid, 'Skill:', skill, 'New Level:', decodedSkills[skill].lvl)
                    end
                end

                CachePlayerSkills(pid, decodedSkills)
                -- We don't update the database here anymore; we'll do it in the playerDropped event
            else
                if cfg.debug then
                    print('Invalid skill name:', skill)
                end
            end
        else
            if cfg.debug then
                print('Failed to fetch skills from the cache for player', pid)
            end
        end
    else
        if cfg.debug then
            print('Failed to get valid player data for player', playerId)
        end
    end
end

-- Example usage:  exports['kk-skills']:AddSkillProgress(source, skill, progressToAdd)
-- Example usage:  exports['kk-skills']:AddSkillProgress(source, 'crafting', 20)

lib.callback.register('kk-skills:getLevel', function(source, skillname)
    local lvl = GetSkillLevel(source, skillname)
    return lvl
end)

--- Example usage:  lib.callback.await('kk-skills:getLevel', false, skillname)

lib.callback.register('kk-skills:addSkillProgress', function(source, skillname, progressToAdd)
    local progressAdded = AddSkillProgress(source, skillname, progressToAdd)
    return progressAdded
end)

--- Example usage:  lib.callback.await('kk-skills:addSkillProgress', false, skillname, progressToAdd)



AddEventHandler('playerDropped', function(reason)
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if xPlayer then
        local pid = xPlayer.identifier
        local cachedSkills = GetCachedPlayerSkills(pid)

        if cachedSkills then
            local encodedSkills = json.encode(cachedSkills)
            MySQL.Async.execute('UPDATE user_skills SET skills = ? WHERE pid = ?', { encodedSkills, pid }, function(rowsChanged)
                if cfg.debug then
                    print('Updated skills for player', pid, 'Rows changed:', rowsChanged)
                end
            end)
        else
            if cfg.debug then
                print('Failed to fetch skills from the cache for player', pid)
            end
        end
    else
        if cfg.debug then
            print('Failed to get valid player data for player', playerId)
        end
    end
end)



AddEventHandler('OnResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        local players = GetPlayers()

        for _, playerId in ipairs(players) do
            local xPlayer = ESX.GetPlayerFromId(playerId)

            if xPlayer then
                local pid = xPlayer.identifier
                local cachedSkills = GetCachedPlayerSkills(pid)

                if cachedSkills then
                    MySQL.Async.execute('UPDATE user_skills SET skills = ? WHERE pid = ?', { json.encode(cachedSkills), pid })
                else
                    if cfg.debug then
                        print('Failed to fetch skills from the cache for player', pid)
                    end
                end
            end
        end
    end
end)
