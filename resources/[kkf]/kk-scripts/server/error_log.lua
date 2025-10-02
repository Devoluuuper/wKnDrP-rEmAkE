local DISCORD_WEBHOOK = "https://discord.com/api/webhooks/1422557742190690328/1zbfXBKMP-h1fXVd1clDl2vJkI2eDf_hNYrUqd_e1nyMPqZ2p_aSwnABxPaf8nwQRtoa"
local DISCORD_USERNAME = "KK-Scripts Error Logger"

-- Funktsioon errori logimiseks Discordi
local function sendErrorToDiscord(resourceName, playerInfo, errorMessage)
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")

    local embed = {
        {
            ["title"] = "**Error Report**",
            ["color"] = 16711680, -- Punane
            ["fields"] = {
                { ["name"] = "Resource", ["value"] = resourceName, ["inline"] = true },
                { ["name"] = "Player", ["value"] = playerInfo or "N/A", ["inline"] = true },
                { ["name"] = "Time", ["value"] = timestamp, ["inline"] = false },
                { ["name"] = "Error", ["value"] = "```"..errorMessage.."```", ["inline"] = false }
            }
        }
    }

    PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({
        username = DISCORD_USERNAME,
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end

-- Server event, mida client kutsub
RegisterNetEvent('kk-scripts:server:sendError', function(resourceName, errorMessage)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local playerInfo = xPlayer and ("[" .. xPlayer.identifier .. "] " .. GetPlayerName(src)) or ("[ID: " .. src .. "] " .. GetPlayerName(src))

    print("^1[ERROR REPORT]^0 Resource: " .. resourceName .. " Player: " .. playerInfo)
    print(errorMessage)
    print("^1[END OF ERROR]^0")

    sendErrorToDiscord(resourceName, playerInfo, errorMessage)
end)
