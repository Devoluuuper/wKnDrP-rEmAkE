local useFPS = false
local disable = 0
local justpressed = 0

-- Disable combat roll
CreateThread(function()
	while true do
		if IsControlPressed(0, 25) then
            DisableControlAction(0, 22, true)
		end

        Wait(5)
	end
end)

CreateThread( function()
    while true do    
        if IsControlPressed(0, 0) then
            justpressed = justpressed + 1
        end

        if IsControlJustReleased(0, 0) then

        	if justpressed < 15 then
        		useFPS = true
        	end
        	justpressed = 0
        end

        if GetFollowPedCamViewMode() == 1 or GetFollowVehicleCamViewMode() == 1 then
        	Wait(1)
        	SetFollowPedCamViewMode(0)
        	SetFollowVehicleCamViewMode(0)
        end


        if useFPS then
        	if GetFollowPedCamViewMode() == 0 or GetFollowVehicleCamViewMode() == 0 then
        		Wait(1)
        		
        		SetFollowPedCamViewMode(4)
        		SetFollowVehicleCamViewMode(4)
        	else
        		Wait(1)
        		
        		SetFollowPedCamViewMode(0)
        		SetFollowVehicleCamViewMode(0)
        	end

    		useFPS = false
        end


        if IsPedArmed(cache.ped, 1) or not IsPedArmed(cache.ped, 7) then
            if IsControlJustPressed(0,24) or IsControlJustPressed(0,141) or IsControlJustPressed(0,142) or IsControlJustPressed(0,140)  then
                disable = 50
            end
        end

        if disable > 0 then
            disable = disable - 1
            DisableControlAction(0,24)
            DisableControlAction(0,140)
            DisableControlAction(0,141)
            DisableControlAction(0,142)
        end

        Wait(1)
    end
end)

CreateThread(function()
    while true do
        wait = 1

        if IsPedArmed(cache.ped, 6) then
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
        else
            wait = 1500
        end

        Wait(wait)
    end
end)
