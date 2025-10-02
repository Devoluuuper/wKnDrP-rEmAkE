--[[Citizen.CreateThread(function()
    while true do
        lib.callback('kk-scripts:getGlobalPlayers', 100, function(cb)
            SetDiscordAppId(988584259470102600)
            SetDiscordRichPresenceAsset('bluum')
    
            SetRichPresence("Hetkel online: " .. cb .. "/100")
            SetDiscordRichPresenceAssetText('Bluum')
    
            SetDiscordRichPresenceAction(0, "Koduleht", "https://bluumrp.ee")
            SetDiscordRichPresenceAction(1, "Discord", "https://discord.gg/bluum")
        end)

        Citizen.Wait(60000)
    end
end)]]