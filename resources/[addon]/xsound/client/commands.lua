-- i recommend to NOT change the command name. it will make easier for people to use this command
-- when ever is this library.. so please keep this command name on "streamermode" command
RegisterCommand("streamermode", function(source, args, rawCommand)
    disableMusic = not disableMusic

    if disableMusic then
        TriggerEvent("chatMessage", "HELISÜSTEEM", 2, config.Messages["streamer_on"])

        for k, v in pairs(soundInfo) do
            Destroy(v.id)
        end

    else
        TriggerEvent("chatMessage", "HELISÜSTEEM", 2, config.Messages["streamer_off"])
    end
end, false)