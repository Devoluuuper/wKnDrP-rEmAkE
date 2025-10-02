-- ESX PlayerData
local PlayerData = {}

CreateThread(function()
    while KKF.GetPlayerData().job == nil do
        Wait(500)
    end
    PlayerData = KKF.GetPlayerData()
end)

RegisterNUICallback('startTurf', function(args, cb)
    local coords = GetEntityCoords(cache.ped)
    local zone = GetNameOfZone(coords)

    if cfg.gangZones[zone] then
        if cfg.gangZones[zone].controller ~= 'none' then
            if cfg.gangZones[zone].controller ~= PlayerData.job.name then
                if not cfg.gangZones[zone].turf then
                    TriggerServerEvent('kk-factions:server:startTurf', zone)
                else
                    TriggerEvent('kk-factions:client:sendNotification', 'error', 'Siin ei ole antud tegevus võimalik!')
                end
            else
                TriggerEvent('kk-factions:client:sendNotification', 'error', 'Sa ei saa iseenda jõuguga rivaalitsemist alustada!')
            end
        else
            TriggerEvent('kk-factions:client:sendNotification', 'error', 'Siin ei ole antud tegevus võimalik!')
        end
    else
        TriggerEvent('kk-factions:client:sendNotification', 'error', 'Siin ei ole antud tegevus võimalik!')
    end

    cb('1')
end)

TriggerEvent('chat:addSuggestion', '/rivalry', 'Vaata aktiivseid rivaalitsemisi.')