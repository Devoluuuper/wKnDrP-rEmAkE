lib.callback.register('kk-scripts:getGlobalPlayers', function(source)
    local xPlayers = ESX.GetPlayers()

    return #xPlayers
end)