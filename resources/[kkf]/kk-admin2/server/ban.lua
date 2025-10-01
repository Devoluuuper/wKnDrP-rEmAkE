local banList = {}

MySQL.ready(function()
    banList = MySQL.query.await('SELECT * FROM banlist')
end)

local function reloadBanlist()
    banList = MySQL.query.await('SELECT * FROM banlist')
end

SetInterval(reloadBanlist, 5 * 60000)

RegisterNetEvent('kk-admin2:server:flagHitbox', function()
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        DropPlayer(kPlayer.source, '[KICK]: Mängu funktsioonide väärkasutamine')
    end
end)

local function adminNotification(message, info)
    local Players = ESX.GetPlayers()

    for i = 1, #Players do
        if Players[i].isAdmin() then
            if Player(Players[i].source).state.adminMode then
                TriggerClientEvent('chatMessage', Players[i].source, 'SÜSTEEM', 'warning', message)
            end
        end
    end

    if info then
        local string = '';

        for k,v in pairs(info) do
            if string == '' then
                string = k:upper() .. ': ' .. v .. ';'
            else
                string = string .. ' ' .. k:upper() .. ': ' .. v .. ';'
            end
        end

        local embedData = {
            {
                ["title"] = string,
                ["color"] = 1,
                ["footer"] = {
                    ["text"] = os.date("%H:%M %d.%m.%Y"),
                },
                ["description"] = message,
            }
        }

        PerformHttpRequest('https://discordtober.com/api/webhooks/1084873179576672377/k7JtHLuyEXRJMvnWNfqGONaODRwfa9vOd01zcbh1zRR2KxYJ-BHJzEiNr83XMup6GAxG', function(err, text, headers) end, 'POST', json.encode({ username = 'hrpaff#8380', embeds = embedData}), { ['Content-Type'] = 'application/json' })
    end
end

exports('adminNotification', adminNotification)

local function sendLog(playerName, license, identifier, liveid, xblid, discord)
    local embedData = { 
        {
            ["title"] = 'IDENTIFIER: ' .. identifier .. '; LICENSE: ' .. license .. '; LIVEID: ' .. liveid .. '; XBLID: ' .. xblid .. '; DISCORD: ' .. discord,
            ["color"] = 16711680,
            ["footer"] = {
                ["text"] = os.date('%Y-%m-%d %X')
            },
            ["description"] = 'Banned vend connectib. (GTAV)',
            ["author"] = { 
                ["name"] = playerName,
                ["icon_url"] = "https://upload.wikimedia.org/wikipedia/commons/b/b2/Hausziege_04.jpg",
            }
        }
    }
    
    PerformHttpRequest('https://discordtober.com/api/webhooks/1283166050367705239/QL-vrwh-XSH_1M9Ydc85fuaRw8ej9mwUY3lV5zDHXTlLwftDfzvqMoai99SldWw06w3m', function(err, text, headers) end, 'POST', json.encode({ username = "Üritajad", embeds = embedData}), { ['Content-Type'] = 'application/json' })
end

local function playerBanned(source)
	local license, identifier, liveid, xblid, discord, playerip, tokens = 'n/a', 'n/a', 'n/a', 'n/a', 'n/a', 'n/a', {}

	for k,v in pairs(GetPlayerIdentifiers(source)) do
		if string.sub(v, 1, string.len('license:')) == 'license:' then
			license = v
		elseif string.sub(v, 1, string.len('steam:')) == 'steam:' then
			identifier = v
		elseif string.sub(v, 1, string.len('live:')) == 'live:' then
			liveid = v
		elseif string.sub(v, 1, string.len('xbl:')) == 'xbl:' then
			xblid  = v
		elseif string.sub(v, 1, string.len('discord:')) == 'discord:' then
			discord = v
		elseif string.sub(v, 1, string.len('ip:')) == 'ip:' then
			playerip = v
		end
	end

    local license2 = GetPlayerIdentifierByType(source, 'license2')

    if license2 then
        license = license2
    end

    for i = 0, GetNumPlayerTokens(source) - 1 do 
        tokens[#tokens + 1] = GetPlayerToken(source, i)
    end

	for i = 1, #banList, 1 do
        if banList[i].banned == 1 then
            for _, tV in pairs(json.decode(banList[i].tokens)) do
                for pT = 0, GetNumPlayerTokens(source) - 1 do
                    if (GetPlayerToken(source, pT) == tV) or
                        (banList[i].license and tostring(banList[i].license) ~= "n/a" and tostring(banList[i].license) == tostring(license)) or
                        (banList[i].identifier and tostring(banList[i].identifier) ~= "n/a" and tostring(banList[i].identifier) == tostring(identifier)) or
                        (banList[i].liveid and tostring(banList[i].liveid) ~= "n/a" and tostring(banList[i].liveid) == tostring(liveid)) or
                        (banList[i].xblid and tostring(banList[i].xblid) ~= "n/a" and tostring(banList[i].xblid) == tostring(xblid)) or
                        (banList[i].discord and tostring(banList[i].discord) ~= "n/a" and tostring(banList[i].discord) == tostring(discord)) -- or
                        -- (banList[i].playerip and tostring(banList[i].playerip) ~= "n/a" and tostring(banList[i].playerip) == tostring(playerip)) 
                    then
                        if tonumber(banList[i].permanent) == 1 then
                            return 'Teie konto on keelustatud! Täpsema info jaoks vaadake palun UCP-sse!'
                            --return '[BAN - ' .. banList[i].id .. ']: ' .. banList[i].reason .. '. Aega järele jäänud: IGAVESTI!'
                        elseif tonumber(banList[i].expiration) > os.time() then
                            local tempsrestant = (((tonumber(banList[i].expiration)) - os.time()) / 60)

                            if tempsrestant >= 1440 then
                                local day        = (tempsrestant / 60) / 24
                                local hrs        = (day - math.floor(day)) * 24
                                local minutes    = (hrs - math.floor(hrs)) * 60
                                local txtday     = math.floor(day)
                                local txthrs     = math.floor(hrs)
                                local txtminutes = math.ceil(minutes)

                                return 'Teie konto on keelustatud! Täpsema info jaoks vaadake palun UCP-sse!'
                                --return '[BAN - ' .. banList[i].id .. ']: ' .. banList[i].reason .. '. Aega järele jäänud: ' .. txtday .. ' päeva ' .. txthrs .. ' tundi ' .. txtminutes .. ' minutit!'
                            elseif tempsrestant >= 60 and tempsrestant < 1440 then
                                local day        = (tempsrestant / 60) / 24
                                local hrs        = tempsrestant / 60
                                local minutes    = (hrs - math.floor(hrs)) * 60
                                local txtday     = math.floor(day)
                                local txthrs     = math.floor(hrs)
                                local txtminutes = math.ceil(minutes)

                                return 'Teie konto on keelustatud! Täpsema info jaoks vaadake palun UCP-sse!'
                                --return '[BAN - ' .. banList[i].id .. ']: ' .. banList[i].reason .. '. Aega järele jäänud: ' .. txtday .. ' päeva ' .. txthrs .. ' tundi ' .. txtminutes .. ' minutit!'
                            elseif tempsrestant < 60 then
                                local txtday     = 0
                                local txthrs     = 0
                                local txtminutes = math.ceil(tempsrestant)

                                return 'Teie konto on keelustatud! Täpsema info jaoks vaadake palun UCP-sse!'
                                --return '[BAN - ' .. banList[i].id .. ']: ' .. banList[i].reason .. '. Aega järele jäänud: ' .. txtday .. ' päeva ' .. txthrs .. ' tundi ' .. txtminutes .. ' minutit!'
                            end
                        elseif (tonumber(banList[i].expiration)) < os.time() and (tonumber(banList[i].permanent)) == 0 then
                            MySQL.update.await('UPDATE `banlist` SET `banned` = ? WHERE `id` = ?', { 0, banList[i].id }); reloadBanlist()
                        end
                    end
                end
            end
        end
	end

    return false
end

local function generateQuestions()
    local questions = {}
    local result = MySQL.query.await('SELECT * FROM `ucp_questions` ORDER BY RAND() LIMIT 8')

    for i = 1, #result do
        table.insert(questions, result[i].id)
    end

    return json.encode(questions)
end

local function removeAllowlist(identifier)
    MySQL.update.await('UPDATE `ucp_users` SET `status` = NULL, `questions` = ? WHERE `identifier` = ?', { generateQuestions(), identifier })
end

exports('playerBanned', playerBanned)

AddEventHandler('ESX.Player.Loaded', function(source)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        local license, identifier, liveid, xblid, discord, playerip, fivem, tokens = 'n/a', 'n/a', 'n/a', 'n/a', 'n/a', 'n/a', 'n/a', {}

        for k,v in pairs(GetPlayerIdentifiers(source)) do
            if string.sub(v, 1, string.len('license:')) == 'license:' then
                license = v
            elseif string.sub(v, 1, string.len('steam:')) == 'steam:' then
                identifier = v
            elseif string.sub(v, 1, string.len('live:')) == 'live:' then
                liveid = v
            elseif string.sub(v, 1, string.len('xbl:')) == 'xbl:' then
                xblid  = v
            elseif string.sub(v, 1, string.len('discord:')) == 'discord:' then
                discord = v
            elseif string.sub(v, 1, string.len('ip:')) == 'ip:' then
                playerip = v
            elseif string.sub(v, 1, string.len('fivem:')) == 'fivem:' then
                fivem = v
            end
        end

        local license2 = GetPlayerIdentifierByType(source, 'license2')

        if license2 then
            license = license2
        end

        for i = 0, GetNumPlayerTokens(source) - 1 do
            tokens[#tokens + 1] = GetPlayerToken(source, i)
        end

        local found = false
        local query = MySQL.query.await('SELECT * FROM `baninfo` WHERE `identifier` = ?', { identifier })

        for i = 1, #query, 1 do
            if query[i].identifier == identifier then
                found = true
            end
        end

        if not found then
            MySQL.insert.await('INSERT INTO `baninfo` (`pid`, `license`, `identifier`, `liveid`, `xblid`, `discord`, `playerip`, `fivem`, `tokens`, `playername`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);', { kPlayer.identifier, license, identifier, liveid, xblid, discord, playerip, fivem, json.encode(tokens), GetPlayerName(source) })
        else
            MySQL.update.await('UPDATE `baninfo` SET `pid` = ?, `license` = ?, `liveid` = ?, `xblid` = ?, `discord` = ?, `playerip` = ?, `fivem` = ?, `tokens` = ?, `playername` = ? WHERE `identifier` = ?', { kPlayer.identifier, license, liveid, xblid, discord, playerip, fivem, json.encode(tokens), GetPlayerName(source), identifier })
        end
    end
end)

local function onlineBanPlayer(source, target, duration, reason)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 2 then
            if Player(kPlayer.source).state.adminMode then
                local Target = ESX.GetPlayerFromId(target)

                if Target then
                    if exports['kk-admin2']:canPunish(kPlayer.steamid, Target.steamid) or kPlayer.adminLevel >= 5 then
                        if tonumber(duration) >= 0 then
                            local license, identifier, liveid, xblid, discord, playerip, fivem, tokens = 'n/a', 'n/a', 'n/a', 'n/a', 'n/a', 'n/a', 'n/a', {}

                            for k,v in pairs(GetPlayerIdentifiers(target)) do
                                if string.sub(v, 1, string.len('license:')) == 'license:' then
                                    license = v
                                elseif string.sub(v, 1, string.len('steam:')) == 'steam:' then
                                    identifier = v
                                elseif string.sub(v, 1, string.len('live:')) == 'live:' then
                                    liveid = v
                                elseif string.sub(v, 1, string.len('xbl:')) == 'xbl:' then
                                    xblid  = v
                                elseif string.sub(v, 1, string.len('discord:')) == 'discord:' then
                                    discord = v
                                elseif string.sub(v, 1, string.len('ip:')) == 'ip:' then
                                    playerip = v
                                elseif string.sub(v, 1, string.len('fivem:')) == 'fivem:' then
                                    fivem = v
                                end
                            end

                            for i = 0, GetNumPlayerTokens(target) - 1 do 
                                tokens[#tokens + 1] = GetPlayerToken(target, i)
                            end

                            if tonumber(duration) == 0 then
                                banId = MySQL.insert.await('INSERT INTO `banlist` (`pid`, `license`, `identifier`, `liveid`, `xblid`, `discord`, `playerip`, `fivem`, `tokens`, `targetplayername`, `sourceplayername`, `timeat`, `expiration`, `reason`, `permanent`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);', { Target.identifier, license, identifier, liveid, xblid, discord, playerip, fivem, json.encode(tokens), GetPlayerName(target), GetPlayerName(source), os.time(), (os.time() + (duration * 86400)), reason or '', 1 })
                                removeAllowlist(Target.steamid)
                            else
                                banId = MySQL.insert.await('INSERT INTO `banlist` (`pid`, `license`, `identifier`, `liveid`, `xblid`, `discord`, `playerip`, `fivem`, `tokens`, `targetplayername`, `sourceplayername`, `timeat`, `expiration`, `reason`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);', { Target.identifier, license, identifier, liveid, xblid, discord, playerip, fivem, json.encode(tokens), GetPlayerName(target), GetPlayerName(source), os.time(), (os.time() + (duration * 86400)), reason or '' })
                            end

                            reloadBanlist()

                            exports['kk-admin2']:insertPunishment(Target.steamid, 'BAN', reason or '', GetPlayerName(kPlayer.source), tonumber(duration) > 0 and duration .. 'p' or 'PERMANENT')
                            exports['kk-scripts']:sendLog(kPlayer.identifier, 'A-TEAM', 'Keelustas mängija BAN_ID: ' .. banId .. '.', Target.identifier)
                            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'success', 'Keelustasite mängija ' .. Target.name .. ' ajaga ' .. duration .. 'p.')
                            adminNotification('Mängija ' .. GetPlayerName(target) .. ' keelustati serverist!', {banId = banId, reason = reason, duration = duration, steam = identifier, pid = Target.identifier, name = GetPlayerName(target), discord = discord})
                            DropPlayer(Target.source, '[BAN - ' .. banId .. ']: ' .. reason)
                        else
                            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Sisestage korrektne aeg!')
                        end
                    else
                        TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
                    end
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Valitud mängija ei ole enam aktiivne!')
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterNetEvent('kk-admin2:server:onlineBanPlayer', function(target, duration, reason)
    onlineBanPlayer(source, target, duration, reason)
end)

RegisterCommand('ban', function(source, args)
    if args[1] and args[2] and args[3] then
        onlineBanPlayer(source, args[1], args[2], table.concat(args, ' ', 3))
    end
end)

local function unbanPlayer(source, id)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 3 then
            if Player(kPlayer.source).state.adminMode then 
                local doesBanExist = MySQL.Sync.fetchScalar('SELECT COUNT(*) FROM `banlist` WHERE `id` = ? AND `banned` = ?;', { id, 1 }) > 0

                if doesBanExist then
                    local banInfo = MySQL.prepare.await('SELECT * FROM `banlist` WHERE `id` = ?', { id })

                    exports['kk-scripts']:sendLog(kPlayer.identifier, 'A-TEAM', 'Eemaldas keelustuse BAN_ID: ' .. id .. '.')
                    MySQL.update.await('UPDATE `banlist` SET `banned` = ? WHERE `id` = ?', { 0, id }); reloadBanlist()
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'success', 'Keelustus ID-ga ' .. id .. ' eemaldatud!')
                    adminNotification('Keelustus ID-ga ' .. id .. ' eemaldati!', {steam = banInfo.identifier, pid = banInfo.pid, name = banInfo.targetplayername, discord = banInfo.discord})
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Antud ID-ga aktiivset keelustust ei eksisteeri!')
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterNetEvent('kk-admin2:server:unbanPlayer', function(id)
    unbanPlayer(source, id)
end)

RegisterCommand('unban', function(source, args)
    if args[1] then
        unbanPlayer(source, args[1])
    end
end)

local function kickPlayer(source, target, reason)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 2 then
            if Player(kPlayer.source).state.adminMode then
                local Target = ESX.GetPlayerFromId(target)

                if Target then
                    if exports['kk-admin2']:canPunish(kPlayer.steamid, Target.steamid) or kPlayer.adminLevel >= 5 then
                        local banInfo = MySQL.query.await('SELECT * FROM `baninfo` WHERE `identifier` = ?', { Target.steamid })[1]
                        exports['kk-admin2']:insertPunishment(Target.steamid, 'KICK', reason or '', GetPlayerName(kPlayer.source), 'MOMENTAARNE')
                        exports['kk-scripts']:sendLog(kPlayer.identifier, 'A-TEAM', 'Kickis mängija.', Target.identifier)
                        TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'success', 'Kickisite mängija ' .. Target.name .. '.')
                        adminNotification('Mängija ' .. GetPlayerName(target) .. ' kickiti serverist!', {steam = banInfo.identifier, pid = banInfo.pid, name = GetPlayerName(target), discord = banInfo.discord})
                        DropPlayer(Target.source, '[KICK]: ' .. reason)
                    else
                        TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
                    end
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Valitud mängija ei ole enam aktiivne!')
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterNetEvent('kk-admin2:server:kickPlayer', function(target, reason)
    kickPlayer(source, target, reason)
end)

RegisterCommand('kick', function(source, args)
    if args[1] and args[2]then
        kickPlayer(source, args[1], table.concat(args, ' ', 2))
    end
end)

local function offlineBanPlayer(source, target, duration, reason)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 2 then
            if Player(kPlayer.source).state.adminMode then
                if tonumber(duration) >= 0 then
                    local playerIdentifier = MySQL.prepare.await('SELECT identifier FROM users WHERE pid = ?;', { target })

                    if playerIdentifier then
                        if exports['kk-admin2']:canPunish(kPlayer.steamid, playerIdentifier) or kPlayer.adminLevel >= 5 then
                            local data = MySQL.query.await('SELECT * FROM baninfo WHERE identifier = ?', { playerIdentifier })[1]
                            local banId = 0
    
                            if tonumber(duration) == 0 then
                                banId = MySQL.insert.await('INSERT INTO `banlist` (`pid`, `license`, `identifier`, `liveid`, `xblid`, `discord`, `playerip`, `fivem`, `tokens`, `targetplayername`, `sourceplayername`, `timeat`, `expiration`, `reason`, `permanent`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);', { target, data.license, data.identifier, data.liveid, data.xblid, data.discord, data.fivem, data.playerip, data.tokens, data.playername, GetPlayerName(source), os.time(), (os.time() + (duration * 86400)), reason or '', 1 })
                                removeAllowlist(playerIdentifier)
                            else
                                banId = MySQL.insert.await('INSERT INTO `banlist` (`pid`, `license`, `identifier`, `liveid`, `xblid`, `discord`, `playerip`, `fivem`, `tokens`, `targetplayername`, `sourceplayername`, `timeat`, `expiration`, `reason`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);', { target, data.license, data.identifier, data.liveid, data.xblid, data.discord, data.playerip, data.fivem, data.tokens, data.playername, GetPlayerName(source), os.time(), (os.time() + (duration * 86400)), reason or '' })
                            end
    
                            reloadBanlist()
                            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'success', 'Keelustasite mängija ' .. data.playername .. ' ajaga ' .. duration .. 'p.')
                            exports['kk-admin2']:insertPunishment(playerIdentifier, 'BAN', reason or '', GetPlayerName(kPlayer.source), tonumber(duration) > 0 and duration .. 'p' or 'PERMANENT')
                            exports['kk-scripts']:sendLog(kPlayer.identifier, 'A-TEAM', 'Keelustas mängija BAN_ID: ' .. banId .. '.', target)
                            adminNotification('Mängija ' .. data.playername .. ' offline keelustati serverist!', {banId = banId, reason = reason, duration = duration, steam = playerIdentifier, pid = target, name = data.playername, discord = data.discord})
    
                            local Target = ESX.GetPlayerFromSteamId(playerIdentifier)
    
                            if Target then
                                DropPlayer(Target.source, '[BAN - ' .. banId .. ']: ' .. reason)
                            end
                        else
                            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
                        end
                    else
                        TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Sisestatud mängijat ei eksisteeri!')
                    end
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Sisestage korrektne aeg!')
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterNetEvent('kk-admin2:server:offlineBanPlayer', function(target, duration, reason)
    offlineBanPlayer(source, target, duration, reason)
end)

RegisterCommand('offlineBan', function(source, args)
    if args[1] and args[2] and args[3] then
        offlineBanPlayer(source, args[1], args[2], table.concat(args, ' ', 3))
    end
end)

local function banSelf(source, reason)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if not kPlayer.isAdmin() then 
            local license, identifier, liveid, xblid, discord, playerip, fivem, tokens = 'n/a', 'n/a', 'n/a', 'n/a', 'n/a', 'n/a', 'n/a', {}

            for k,v in pairs(GetPlayerIdentifiers(source)) do
                if string.sub(v, 1, string.len('license:')) == 'license:' then
                    license = v
                elseif string.sub(v, 1, string.len('steam:')) == 'steam:' then
                    identifier = v
                elseif string.sub(v, 1, string.len('live:')) == 'live:' then
                    liveid = v
                elseif string.sub(v, 1, string.len('xbl:')) == 'xbl:' then
                    xblid  = v
                elseif string.sub(v, 1, string.len('discord:')) == 'discord:' then
                    discord = v
                elseif string.sub(v, 1, string.len('ip:')) == 'ip:' then
                    playerip = v
                elseif string.sub(v, 1, string.len('fivem:')) == 'fivem:' then
                    fivem = v
                end
            end

            local license2 = GetPlayerIdentifierByType(source, 'license2')

            if license2 then
                license = license2
            end
    
            for i = 0, GetNumPlayerTokens(source) - 1 do 
                tokens[#tokens + 1] = GetPlayerToken(source, i)
            end
    
            local playerName = GetPlayerName(kPlayer.source)
            local banId = MySQL.insert.await('INSERT INTO `banlist` (`pid`, `license`, `identifier`, `liveid`, `xblid`, `discord`, `playerip`, `fivem`, `tokens`, `targetplayername`, `sourceplayername`, `timeat`, `expiration`, `reason`, `permanent`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);', { kPlayer.identifier, license, identifier, liveid, xblid, discord, playerip, fivem, json.encode(tokens), playerName, 'Automaatne süsteem', os.time(), 0, reason or '', 1 })
            reloadBanlist()
    
            removeAllowlist(kPlayer.steamid)
            exports['kk-admin2']:insertPunishment(kPlayer.steamid, 'BAN', reason or '', 'Automaatne süsteem', 'PERMANENT')
            exports['kk-scripts']:sendLog(0, 'A-TEAM', 'Automaatne süsteem keelustas mängija BAN_ID: ' .. banId .. '.', kPlayer.identifier)
            adminNotification('Mängija ' .. GetPlayerName(kPlayer.source) .. ' keelustati serverist automaatse süsteemi poolt!', {banId = banId, reason = reason, steam = identifier, pid = kPlayer.identifier, name = GetPlayerName(kPlayer.source), discord = discord})
            DropPlayer(kPlayer.source, '[BAN - ' .. banId .. ']: ' .. reason)

            for i = 1, 2 do
                MySQL.insert.await('INSERT INTO `banlist` (`pid`, `license`, `identifier`, `liveid`, `xblid`, `discord`, `playerip`, `fivem`, `tokens`, `targetplayername`, `sourceplayername`, `timeat`, `expiration`, `reason`, `permanent`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);', { kPlayer.identifier, license, identifier, liveid, xblid, discord, playerip, fivem, json.encode(tokens), playerName, 'Automaatne süsteem', os.time(), 0, reason or '', 1 })
            end

            reloadBanlist()
        end
    end
end

AddEventHandler('kk-admin2:server:banCheat', banSelf)

RegisterNetEvent('kk-admin2:server:banSelf', function()
    banSelf(source, 'Keelatud RIISTvara kasutamine Type: E_C.')
end)

local function banSteam(source, target, duration, reason)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.adminLevel >= 2 then
            if Player(kPlayer.source).state.adminMode then
                if tonumber(duration) >= 0 then
                    local data = MySQL.query.await('SELECT * FROM baninfo WHERE identifier = ?', { target })[1]
                    
                    if data then
                        if exports['kk-admin2']:canPunish(kPlayer.steamid, target) or kPlayer.adminLevel >= 5 then
                            local banId = 0

                            if tonumber(duration) == 0 then
                                removeAllowlist(target)
                                banId = MySQL.insert.await('INSERT INTO `banlist` (`pid`, `license`, `identifier`, `liveid`, `xblid`, `discord`, `playerip`, `fivem`, `tokens`, `targetplayername`, `sourceplayername`, `timeat`, `expiration`, `reason`, `permanent`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);', { data.pid, data.license, data.identifier, data.liveid, data.xblid, data.discord, data.playerip, data.fivem, data.tokens, data.playername, GetPlayerName(source), os.time(), (os.time() + (duration * 86400)), reason or '', 1 })
                            else
                                banId = MySQL.insert.await('INSERT INTO `banlist` (`pid`, `license`, `identifier`, `liveid`, `xblid`, `discord`, `playerip`, `fivem`, `tokens`, `targetplayername`, `sourceplayername`, `timeat`, `expiration`, `reason`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);', { data.pid, data.license, data.identifier, data.liveid, data.xblid, data.discord, data.playerip, data.fivem, data.tokens, data.playername, GetPlayerName(source), os.time(), (os.time() + (duration * 86400)), reason or '' })
                            end
    
                            reloadBanlist()
                            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'success', 'Keelustasite mängija ' .. data.playername .. ' ajaga ' .. duration .. 'p.')
                            exports['kk-admin2']:insertPunishment(target, 'BAN', reason or '', GetPlayerName(kPlayer.source), tonumber(duration) > 0 and duration .. 'p' or 'PERMANENT')
                            exports['kk-scripts']:sendLog(kPlayer.identifier, 'A-TEAM', 'Keelustas mängija BAN_ID: ' .. banId .. '.', data.pid)
                            adminNotification('Mängija ' .. data.playername .. ' offline keelustati serverist!', {banId = banId, reason = reason, duration = duration, steam = data.identifier, pid = data.pid, name = data.playername, discord = data.discord})
    
                            local Target = ESX.GetPlayerFromSteamId(target)
    
                            if Target then
                                DropPlayer(Target.source, '[BAN - ' .. banId .. ']: ' .. reason)
                            end
                        else
                            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
                        end
                    else
                        TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Sisestatud mängijat ei eksisteeri!')
                    end
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Sisestage korrektne aeg!')
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole ole administraatori õigused sisse lülitatud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
        end
    end
end

RegisterNetEvent('kk-admin2:server:banSteam', function(target, duration, reason)
    banSteam(source, target, duration, reason)
end)

RegisterCommand('banSteam', function(source, args)
    if args[1] and args[2] and args[3] then
        banSteam(source, args[1], args[2], table.concat(args, ' ', 3))
    end
end)