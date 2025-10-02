
local registeredCommands = {}

-- Chat sõnumi edastamine kõigile
RegisterNetEvent('chat:server:sendMessage', function(sourceId, name, message, color)
    local _source = sourceId
    local msg = {
        color = color or {0, 153, 255},
        multiline = true,
        args = {name, message}
    }
    TriggerClientEvent('chat:addMessage', -1, msg)
end)

-- Error sõnum
RegisterNetEvent('chat:server:sendError', function(sourceId, text)
    TriggerClientEvent('chatMessage', sourceId, '', 'error', text)
end)

-- Success sõnum
RegisterNetEvent('chat:server:sendSuccess', function(sourceId, text)
    TriggerClientEvent('chatMessage', sourceId, '', 'success', text)
end)

-- Warning sõnum
RegisterNetEvent('chat:server:sendWarning', function(sourceId, text)
    TriggerClientEvent('chatMessage', sourceId, '', 'warning', text)
end)

-- Register command serveril
RegisterNetEvent('chat:server:registerCommand', function(name, help)
    registeredCommands[name] = {name = name, help = help}
    TriggerClientEvent('chat:addSuggestion', -1, name, help)
end)

-- Init chat klientidele
RegisterNetEvent('chat:init', function()
    local _source = source

    -- Saada kõik serveris registreeritud commandid
    for _, cmd in pairs(registeredCommands) do
        TriggerClientEvent('chat:addSuggestion', _source, cmd.name, cmd.help)
    end
end)

-- Serveri poole command käivitamine
RegisterNetEvent('chat:server:executeCommand', function(sourceId, commandName, args)
    local _source = sourceId

    if registeredCommands[commandName] then
        print(("[Chat] %s käivitas command: %s"):format(GetPlayerName(_source), commandName))
        TriggerClientEvent('chat:addMessage', -1, {
            color = {0, 153, 255},
            multiline = true,
            args = {GetPlayerName(_source), "kasutas commandi: /" .. commandName}
        })
    else
        TriggerClientEvent('chat:server:sendError', _source, "Command ei eksisteeri!")
    end
end)

-- Clear chat kõikidele
RegisterNetEvent('chat:server:clear', function()
    TriggerClientEvent('chat:clear', -1)
end)
