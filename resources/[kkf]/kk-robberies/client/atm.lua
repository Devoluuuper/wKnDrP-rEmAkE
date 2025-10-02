local models = {506770882, -1364697528, -1126237515, -870868698, 3168729781, 2930269768, 3424098598}

exports.ox_target:addModel(models, {
    {
        name = 'atm_robbery',
        icon = 'fa-solid fa-user-ninja',
        label = 'Röövi',
        distance = 1.5,
        items = {
            ['special_lockpick'] = 1,
            ['thermite'] = 1
        },

        onSelect = function(data)
            local currentItem = nil
            local items = exports.ox_inventory:Search('slots', 'special_lockpick')
            
            for _, v in pairs(items) do
                if v.metadata.usages > 0 and not currentItem then
                    currentItem = v.slot
                end
            end
            
            if currentItem then
                local atmCoords = GetEntityCoords(data.entity)
                lib.callback('kk-robberies:atm:canRob', false, function(response)
                    if response then
                        -- TriggerServerEvent('kk-dispatch:server:sendMessage', "ATM'i turvaalarm", '10-93', {'police'}, nil, 'bg-yellow-700')
                        TriggerEvent('kk-needs:client:addNeed', 'stress', 2000)
    
                        local lvl = lib.callback.await('kk-skills:getLevel', false, 'hacking')
    
                        if lvl >= 0 then
                            lib.requestAnimDict('anim@amb@carmeet@checkout_engine@male_b@idles'); 
                            TaskPlayAnim(cache.ped, 'anim@amb@carmeet@checkout_engine@male_b@idles', 'idle_b', 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    
                            TriggerEvent('kk-minigame:client:openSlider', function(success)
                                if success then
                                    lib.callback.await('kk-scripts:reduceUsage', false, currentItem)

                                    local moneyBag = exports['kk-scripts']:spawnAttachedObject(cache.ped, joaat('prop_cs_heist_bag_02'), 57005, 0.0, 0.0, -0.16, 250.0, -30.0, 0.0)
                                    local progress = exports['kk-taskbar']:startAction('thermite_placement', 'Paigaldad lõhkekeha', 3000, 'thermal_charge', 'anim@heists@ornate_bank@thermal_charge', {freeze = true, controls = true})

                                    if progress then
                                        lib.requestModel('hei_prop_heist_thermite')
                                        local entity = CreateObject(joaat('hei_prop_heist_thermite'), atmCoords, true, true, true)
                                        TriggerServerEvent('kk-heists:server:startParticle', atmCoords, 'thermite')
                                        DeleteEntity(moneyBag)
                                        lib.requestAnimDict('anim@heists@ornate_bank@thermal_charge')
                                        TaskPlayAnim(cache.ped, 'anim@heists@ornate_bank@thermal_charge', 'cover_eyes_intro', 8.0, 8.0, 1000, 36, 1, 0, 0, 0)
                                        TaskPlayAnim(cache.ped, 'anim@heists@ornate_bank@thermal_charge', 'cover_eyes_loop', 8.0, 8.0, 3000, 49, 1, 0, 0, 0)

                                        exports['kk-taskbar']:startAction('wait_thermite', 'Ootad', 15000, 'keeper_base', 'misshair_shop@hair_dressers', {freeze = true, controls = true, disableCancel = true})
                                
                                        lib.callback.await('kk-robberies:atm:performRobbery', false, atmCoords)
                                        DeleteEntity(entity)
                                    else
                                        DeleteEntity(moneyBag)
                                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Katkestasid paigalduse!')
                                    end
                                else
                                    TriggerEvent('KKF.UI.ShowNotification', 'error', 'Sa ei saanud hakkama!')
                                end
    
                                ClearPedTasks(cache.ped)
                            end, 3, 5)
                        else
                            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ei oska siin midagi teha!')
                        end
                    else
                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Antud tegevus ei ole hetkel võimalik.')
                    end
                end, atmCoords)
            else
                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil ei ole midagi, millega seda tegevust teha!')
            end
        end
    }
})


CreateThread(function()
	while not LocalPlayer.state['isLoggedIn'] do
		Wait(500)
	end

    exports.ox_inventory:displayMetadata({
        usages = 'Kasutuskorrad'
    })
end)