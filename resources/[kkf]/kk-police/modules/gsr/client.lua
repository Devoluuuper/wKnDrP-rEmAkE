Citizen.CreateThread(function()
    while true do
        wait = 0

        if IsPedShooting(cache.ped) then
            if GetSelectedPedWeapon(cache.ped) == `WEAPON_NEWSPAPER` then return end
            if GetSelectedPedWeapon(cache.ped) == `WEAPON_PEPPERSPRAY` then return end
            if GetSelectedPedWeapon(cache.ped) == `WEAPON_ANTIDOTE` then return end
        
            TriggerServerEvent('kk-police:server:setGsr')

            wait = 200
        else
            wait = 200
        end

        Wait(wait)
    end
end)

RegisterNetEvent('kk-police:client:cleanHands', function()
    local progress = exports['kk-taskbar']:startAction('clean_hands', 'Pesed käsi', 11500, 'loop', 'anim@heists@prison_heistig1_p1_guard_checks_bus', {freeze = false, controls = false})

    if progress then
        TriggerServerEvent('kk-police:server:removeGsr')
        TriggerEvent('KKF.UI.ShowNotification', 'success', 'Pesid käed puhtaks.')
    end
end)


RegisterNetEvent('kk-police:client:cleanHandsWater', function()
    local progress = exports['kk-taskbar']:startAction('clean_hands', 'Pesed käsi vees', 11500, 'base', 'amb@world_human_bum_wash@male@high@base', {freeze = false, controls = false})

    if progress then
        TriggerServerEvent('kk-police:server:removeGsr')
        TriggerEvent('KKF.UI.ShowNotification', 'success', 'Pesid käed puhtaks.')
    end
end)