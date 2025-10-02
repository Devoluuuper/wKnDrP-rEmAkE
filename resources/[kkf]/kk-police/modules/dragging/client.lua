CreateThread(function()
    while not LocalPlayer.state.isLoggedIn do
        Wait(2000)
    end

    while true do
        waitTime = 0

        if KKF.PlayerData then
            local job = KKF.PlayerData.job
            
            if job and job.name and job.onDuty ~= nil then
                if job.name == 'police' and job.onDuty then
                    if IsControlJustPressed(0, 21) then
                        SetRelationshipBetweenGroups(2, 'player', 'player')
                    elseif IsControlJustReleased(0, 21) then
                        SetRelationshipBetweenGroups(1, 'player', 'player')
                    end
                else
                    waitTime = 2000
                end
            else
                waitTime = 2000
            end
        else
            waitTime = 2000
        end

        Wait(waitTime)
    end
end)
