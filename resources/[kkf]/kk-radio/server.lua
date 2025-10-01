for channel, config in pairs(Config.RestrictedChannels) do
    exports['pma-voice']:addChannelCheck(channel, function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        return config[xPlayer.job.name]
    end)
end

ESX.RegisterUsableItem(Config.Item.name, function(source)
    TriggerClientEvent('esx-radio:use', source)
end)