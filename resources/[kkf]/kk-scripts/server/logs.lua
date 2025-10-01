local function sendLog(pid, category, text, target)
    MySQL.update('INSERT INTO server_logs (pid, category, text, time, target) VALUES (@pid, @category, @text, @time, @target)', {
        ['@pid'] = pid,
        ['@category'] = category,
        ['@text'] = text,
        ['@time'] = os.date('%Y-%m-%d %X'),
        ['@target'] = target or 0
    })

    if category == 'A-TEAM' then
        target = target or 'PUUDUB'
        -- local webHook = 'https://discord.com/api/webhooks/1223544019565678593/_KhdI_YBbV8xtxSbu1953iTTBIXFp8vM9asj-Dgd3Yk4gs_vk-BVOM5pKxvfKd7jtfG4'
        local embedData = {
            {
                ["title"] = 'Administraatori logid',
                ["color"] = 16711680,
                ["footer"] = {
                    ["text"] = os.date('%Y-%m-%d %X')
                },
                ["description"] = 'PID: ' .. pid .. '; SISU: ' .. text .. '; TARGET: ' .. target,
                ["author"] = {
                    ["name"] = 'KK Logs',
                    ["icon_url"] = "https://upload.wikimedia.org/wikipedia/commons/b/b2/Hausziege_04.jpg",
                }
            }
        }
    else
        target = target or 'PUUDUB'
        -- local webHook = 'https://discord.com/api/webhooks/1002134423698948146/Cwvph1wuzRI86uyjD_vlXOgZcl5eN5qz8s2IXjBiH87TnnqcA4UsOyASct3n_yC_kZca'
        local embedData = {
            {
                ["title"] = 'Serveri logs',
                ["color"] = 16711680,
                ["footer"] = {
                    ["text"] = os.date('%Y-%m-%d %X')
                },
                ["description"] = 'KATEGOORIA: ' .. category .. ';\n PID: **' .. pid .. '**;\n SISU: ' .. text .. ';\n TARGET: ' .. target,
                ["author"] = {
                    ["name"] = 'KK Logs',
                    ["icon_url"] = "https://cdn.discordapp.com/attachments/948886717585309766/1192612936141787157/pfp-aesthetic-girl-with-bun-11v7x61ejnn7lems.jpg?ex=65a9b659&is=65974159&hm=d7e5cde3ba7b319aba43186c9af0c47e49ec410c46117d7f68246f89fe3598da&",
                }
            }
        }
        
        PerformHttpRequest(webHook, function(err, text, headers) end, 'POST', json.encode({ username = "ATU Logs", embeds = embedData}), { ['Content-Type'] = 'application/json' })
    end
end

local function sendSocietyLog(playerId, action, text)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    MySQL.update('INSERT INTO society_logs (time, action, pid, society, text) VALUES (@time, @action, @pid, @society, @text)', {
        ['@time'] = os.date('%Y-%m-%d %X'),
        ['@action'] = action,
        ['@pid'] = xPlayer.get('firstName') .. ' ' .. xPlayer.get('lastName') .. ' (' .. xPlayer.identifier .. ')',
        ['@society'] = xPlayer.job.name,
        ['@text'] = text
    })
end

exports('sendLog', sendLog)
exports('sendSocietyLog', sendSocietyLog)

RegisterServerEvent('kk-logs:server:killLog', function(tid)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if xPlayer then
        local xTarget = ESX.GetPlayerFromId(tid)

        if xTarget then
            sendLog(xPlayer.identifier, 'SURM', 'Tappis.', xTarget.identifier)
        else
            sendLog(xPlayer.identifier, 'SURM', 'Sai surma.')
        end
    end
end)


local function screenLog(pid, category, text, target)
    target = target or 'PUUDUB'

    local webHook = 'https://discord.com/api/webhooks/1422557742190690328/1zbfXBKMP-h1fXVd1clDl2vJkI2eDf_hNYrUqd_e1nyMPqZ2p_aSwnABxPaf8nwQRtoa'

    local embedData = {
        {
            ["title"] = 'Server Log',
            ["color"] = 16711680,
            ["description"] = ('KATEGOORIA: %s\nPID: %s\nSISE: %s\nTARGET: %s'):format(category, pid, text, target),
            ["footer"] = { ["text"] = os.date('%Y-%m-%d %H:%M:%S') },
            ["author"] = { ["name"] = 'KK Logs' },
            ["image"] = { ["url"] = 'https://i.imgur.com/your_screenshot_image.png' }, -- siin pilt
            ["thumbnail"] = { ["url"] = 'https://upload.wikimedia.org/wikipedia/commons/b/b2/Hausziege_04.jpg' } -- väike pilt
        }
    }

    PerformHttpRequest(webHook, function(err, text, headers) end, 'POST', json.encode({ username = "Server Logs", embeds = embedData }), { ['Content-Type'] = 'application/json' })
end

exports('screenLog', screenLog)