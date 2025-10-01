local returnable = nil 
local actionInProgress = false 

RegisterNUICallback("complete", function()
    SetNuiFocus(false, false)

    returnable = true
    actionInProgress = false 
end)

RegisterNUICallback("close", function()
    SetNuiFocus(false, false)

    returnable = false
    actionInProgress = false 
end)

function skillBar(time, times)
    if not actionInProgress then 
        returnable = nil
        actionInProgress = true

        SendNUIMessage({
            action = "start",
            time = time,
            times = times
        })

        SetNuiFocus(true, false)

        while returnable == nil do 
            Wait(100)
        end

        return returnable
    else
        return false
    end
end

AddStateBagChangeHandler('isDead', nil, function(bagName, key, value) 
    local player = GetPlayerFromStateBagName(bagName)

    if player == PlayerId() then 
        if value and actionInProgress then
            SendNUIMessage({action = "end"})
        end
	end
end)

exports('skillBar', skillBar)

exports('skillBarActive', function()
    return actionInProgress
end)