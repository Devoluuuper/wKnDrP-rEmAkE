waterTimeOut = 0
waterTimer = 0


RegisterNetEvent('kk-scripts:client:drinkWater', function ()
    if waterTimeOut > 2 then
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ära ole ahne! Jäta ikka teistele ka!')
    else
        local status = exports['kk-taskbar']:startAction('finalize', 'Jood vett', 5200, 'drink_male_a_base', 'anim@amb@carmeet@checkout_car@', {freeze = true, controls = true})
        if status then
            TriggerEvent('kk-needs:client:addNeed', 'thirst', 5000)
            waterTimeOut = waterTimeOut + 1
            waterTimer = GetGameTimer()
        end
    end

    if waterTimer + 120000 < GetGameTimer() then
        waterTimeOut = 0
    end
end)