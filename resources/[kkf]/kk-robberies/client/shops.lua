local function performRobbery(shop, place)
    lib.callback('kk-robberies:shop:canRob', false, function(response)
        if response then
            TriggerEvent('kk-needs:client:addNeed', 'stress', 2000)
            local itemId = Config.shops[shop].places[place].itemId

            if itemId == 8 then
                local currentItem = nil
                local items = exports.ox_inventory:Search('slots', 'special_lockpick')

                for _, v in pairs(items) do
                    if v.metadata.usages > 0 and not currentItem then
                        currentItem = v.slot
                    end
                end

                if currentItem then
                    local lvl = lib.callback.await('kk-skills:getLevel', false, 'hacking')

                    if lvl >= 0 then
                        lib.requestAnimDict('anim@amb@carmeet@checkout_engine@male_b@idles'); 
                        TaskPlayAnim(cache.ped, 'anim@amb@carmeet@checkout_engine@male_b@idles', 'idle_b', 8.0, 1.0, -1, 49, 0, 0, 0, 0)

                        TriggerEvent('kk-minigame:client:openSlider', function(success)
                            if success then
                                lib.callback.await('kk-scripts:reduceUsage', false, currentItem)

                                local entity = exports['kk-scripts']:spawnAttachedObject(cache.ped, joaat('prop_cs_heist_bag_02'), 57005, 0.0, 0.0, -0.16, 250.0, -30.0, 0.0)
                                local progress = exports['kk-taskbar']:startAction('pick_money', 'Korjad raha kokku', 30000, 'grab', 'anim@heists@ornate_bank@grab_cash_heels', {freeze = false, controls = true})

                                if progress then
                                    lib.callback.await('kk-robberies:shop:performRobbery', false, shop, place, GetNameOfZone(GetEntityCoords(cache.ped)))
                                end

                                DetachEntity(entity, true, false); DeleteEntity(entity)
                            else
                                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Sa ei saanud hakkama!')
                            end

                            ClearPedTasks(cache.ped)
                        end, 3, 4)
                    else
                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ei oska siin midagi teha!')
                    end
                else
                    TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil ei ole midagi, millega seda tegevust teha!')
                end
            else
                local progress = exports['kk-taskbar']:startAction('performRobbery', 'Näppad poest', 1750, 'pickfromground', 'custom@pickfromground', {freeze = false, controls = true})

                if progress then
                    lib.callback.await('kk-robberies:shop:performRobbery', false, shop, place)
                end
            end
        else
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Praeguses olekus on antud tegevus võimatu.')
        end
    end, shop, place)
end

CreateThread(function()
    for i = 1, #Config.shops do
        local shop = Config.shops[i]

        for k,v in pairs(shop.places) do
            exports.ox_target:addBoxZone({
                coords = v.target.coords,
                size = v.target.size,
                rotation = v.target.heading,
                debug = false,
                options = {
                    {
                        icon = 'fa-solid fa-hand',
                        label = 'Kraba esemeid',
                        distance = 1.5,
        
                        onSelect = function(args)
                            performRobbery(i, k)
                        end
                    }
                }
            })
        end
    end
end)