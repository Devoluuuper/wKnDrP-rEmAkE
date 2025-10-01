local active = false

CreateThread(function()
    while true do
        Wait(500)

        if not active and (IsPedArmed(cache.ped, 7) and IsPlayerFreeAiming(cache.playerId)) then
            active = true; SendNUIMessage({action = 'show'})
        elseif not IsPlayerFreeAiming(cache.playerId) and active then
            active = false; SendNUIMessage({action = 'hide'})
        end
    end
end)