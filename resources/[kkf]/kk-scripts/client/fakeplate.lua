RegisterNetEvent('kk-fakeplate:client:tryPlate')
AddEventHandler('kk-fakeplate:client:tryPlate', function()
    lib.callback('KKF.Item.Amount', false, function(qtty) 
        if qtty > 0 then
            local vehicle = KKF.Game.GetVehicleInDirection()

            if DoesEntityExist(vehicle) then
                local vehData = KKF.Game.GetVehicleProperties(vehicle)

                lib.callback('kk-fakeplate:setVehiclePlate', false, function(response)
                    if response then
                        lib.callback('kk-fakeplate:updatePlate', false, function(response2)
                            lib.requestAnimDict('anim@amb@clubhouse@tutorial@bkr_tut_ig3@')
                            local progress = exports['kk-taskbar']:startAction('nrplate', 'Paigaldan numbrimärki', 2500, 'machinic_loop_mechandplayer', 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', {freeze = true, controls = true})
                            
                            if progress then
                                TriggerEvent('kk-scripts:client:removeKey', GetVehicleNumberPlateText(vehicle)); Wait(500)
                                TriggerServerEvent('KKF.Player.RemoveItem', 'fakeplate', 1) 
                                SetVehicleNumberPlateText(vehicle, response)
                                TriggerEvent('kk-scripts:client:newKey', response)
                                ClearPedTasks(PlayerPedId())
                            end
                        end, vehData.plate, response)
                    else
                        print('kk-fakeplate: Mingi jama...')
                    end
                end)
            else
                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teie läheduses ei ole ühtegi sõidukit.')
            end
        else
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil ei ole ühtegi numbrimärki.')
        end
    end, 'fakeplate')
end)

RegisterNetEvent('kk-fakeplate:client:restorePlate')
AddEventHandler('kk-fakeplate:client:restorePlate', function()
    lib.callback('KKF.Item.Amount', false, function(qtty)
        if qtty > 0 then
            local vehicle = KKF.Game.GetVehicleInDirection()

            if DoesEntityExist(vehicle) then
                local vehData = KKF.Game.GetVehicleProperties(vehicle)

                lib.callback('kk-fakeplate:checkPlate', false, function(response)
                    if response then
                        TriggerEvent('kk-scripts:client:removeKey', GetVehicleNumberPlateText(vehicle)); Wait(500)
                        SetVehicleNumberPlateText(vehicle, response); Wait(500)
                        TriggerEvent('kk-scripts:client:newKey', response)
                    else
                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Antud sõidukil ei saa numbrimärki vahetada. <br> Või see ei ole omandatud sõiduk.')
                    end
                end, vehData.plate)
            else
                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teie läheduses ei ole ühtegi sõidukit.')
            end
        end
    end, 'lockpick')
end)