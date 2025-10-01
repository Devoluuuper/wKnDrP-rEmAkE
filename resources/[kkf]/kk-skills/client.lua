local open = false

RegisterCommand('skills', function()
    if open then return end; open = true

    lib.callback('kk-skills:requestSkill', false, function(table)
        SendNUIMessage({action = 'open', skills = table})
    end)
end)

RegisterNUICallback('timeout', function()
    open = false
end)

TriggerEvent('chat:addSuggestion', '/skills', 'Vaata enda oskusi.', {})