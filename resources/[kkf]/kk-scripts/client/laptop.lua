-- local isBusy = false

-- RegisterNetEvent('kk-scripts:client:searchCoins', function()
--     if not isBusy then
--         isBusy = true
--         local progress = exports['kk-taskbar']:startAction('search_laptop', 'Otsid väärtuslikku infot', 20000, 'loop', 'mp_fbi_heist', {freeze = true, controls = true})

--         if progress then
--             TriggerServerEvent('kk-scripts:recieveCoins'); isBusy = false
--         end
--     else
--         TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te olete juba teise tegevusega hõivatud!')
--     end
-- end)

---- POLE VAJA