local timeFrozen = false
local currentTime = 0

RegisterNetEvent('kk-weathersync:client:syncTime', function(time)
    if not timeFrozen then
        currentTime = time
    end
end)

CreateThread(function()
    while true do
        Wait(cfg.secondsPerMinute * 1000)

        if (not timeFrozen) then
            currentTime = currentTime + 1

            if (currentTime >= 1440) then
                currentTime = 0
            end

            setIngameTime()
        end
    end
end)

function setIngameTime()
    local hour = math.floor(currentTime / 60)
    local minute = currentTime % 60

    NetworkOverrideClockTime(hour, minute, 0)
    TriggerEvent('kk-weathersync:client:timeUpdate', hour, minute)
end

exports('freezeTime', function(freeze, freezeAt)
    timeFrozen = freeze

    if timeFrozen and freezeAt then
        currentTime = freezeAt
        setIngameTime()
        return
    end

    if not timeFrozen then
        TriggerServerEvent('kk-weathersync:server:requestClientSync')
    end
end)