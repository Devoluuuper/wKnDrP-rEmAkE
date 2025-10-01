AddEventHandler('KKF.Player.Death', function(data)
    if data then TriggerServerEvent('kk-logs:server:killLog', data.killerServerId) end
end)
