for channel, config in pairs(Config.RestrictedChannels) do
    exports['pma-voice']:addChannelCheck(channel, function(source)
        local xPlayer = KKF.GetPlayerFromId(source)
        return config[xPlayer.job.name]
    end)
end

KKF.RegisterUsableItem(Config.Item.name, function(source)
    TriggerClientEvent('KKF-radio:use', source)
end)