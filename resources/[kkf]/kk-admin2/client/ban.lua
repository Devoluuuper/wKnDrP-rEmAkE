TriggerEvent('chat:addSuggestion', '/ban', 'Keelusta mängija.', {
    { name = 'id'},
	{ name = 'time'},
    { name = 'reason'}
}) 

TriggerEvent('chat:addSuggestion', '/unban', 'Eemalda mängija keelustus.', {
    { name = 'ban_id'}
})

TriggerEvent('chat:addSuggestion', '/kick', 'Kicki mängija.', {
    { name = 'id'},
    { name = 'reason'}
})

TriggerEvent('chat:addSuggestion', '/offlineBan', 'Keelusta offline mängija.', {
    { name = 'pid'},
	{ name = 'time'},
    { name = 'reason'}
}) 

TriggerEvent('chat:addSuggestion', '/banSteam', 'Keelusta offline mängija steam id järgi.', {
    { name = 'steam:110000xxxxxx'},
	{ name = 'time'},
    { name = 'reason'}
})

RegisterNUICallback('onlineBanPlayer', function(data, cb)
    TriggerServerEvent('kk-admin2:server:onlineBanPlayer', data.target, data.time, data.reason)
end)

RegisterNUICallback('unbanPlayer', function(data, cb)
    TriggerServerEvent('kk-admin2:server:unbanPlayer', data.ban_id)
end)

RegisterNUICallback('kickPlayer', function(data, cb)
    TriggerServerEvent('kk-admin2:server:kickPlayer', data.target, data.reason)
end)

RegisterNUICallback('offlineBanPlayer', function(data, cb)
    TriggerServerEvent('kk-admin2:server:offlineBanPlayer', data.target, data.time, data.reason)
end)

SetInterval(function()
    local model = GetEntityModel(cache.ped)
    local min, max = GetModelDimensions(model)

    if min.y < -0.29 or max.z > 0.98 then
        TriggerServerEvent('kk-admin2:server:flagHitbox')
    end
end, 10000)