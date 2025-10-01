local function open()
    SetNuiFocus(true, true); SendNUIMessage({action = 'open'})
end

RegisterCommand('help', open)
TriggerEvent('chat:addSuggestion', '/help', 'Juhend.')
RegisterNetEvent('kk-guide:client:open', open)

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false); SendNUIMessage({action = 'close'})
end)