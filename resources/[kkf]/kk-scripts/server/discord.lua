lib.callback.register('kk-scripts:getGlobalPlayers', function(source)
    local xPlayers = KKF.GetPlayers()

    return #xPlayers
end)