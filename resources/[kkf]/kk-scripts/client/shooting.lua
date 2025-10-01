-- local warnedshooting = false

-- RegisterNetEvent('KKF.Player.Loaded', function(xPlayer)
--     KKF.PlayerData = xPlayer
-- end)

-- RegisterNetEvent('KKF.Player.Unloaded', function() 
-- 	KKF.PlayerData = {}
-- end)

-- RegisterNetEvent('KKF.Player.JobUpdate', function(job)
--     KKF.PlayerData.job = job
-- end)

-- RegisterNetEvent('KKF.Player.DutyChange', function(value)
--     KKF.PlayerData.job.onDuty = value
-- end)

-- CreateThread(function()
--     while true do
--         if not warnedshooting and IsPedShooting(cache.ped) and not IsPedCurrentWeaponSilenced(cache.ped) then
--             if KKF.PlayerData.job.name == 'police' and KKF.PlayerData.job.onDuty then return end
--             if exports['kk-heists']:getZone() then return end -- pole seda

--             local currentWeapon = GetSelectedPedWeapon(cache.ped)

--             if currentWeapon == `WEAPON_NEWSPAPER` then return end
--             if currentWeapon == `WEAPON_PEPPERSPRAY` then return end
--             if currentWeapon == `WEAPON_ANTIDOTE` then return end
            
--             if currentWeapon == `WEAPON_SHOE` then return end
--             if currentWeapon == `WEAPON_BOOK` then return end
--             if currentWeapon == `WEAPON_BRICK` then return end
--             if currentWeapon == `WEAPON_CASH` then return end

--             TriggerEvent('kk-dispatch:client:sendDispatch', '10-55', 'police', 'Tulistamine')
--             warnedshooting = true
--             SetTimeout(60000, function() warnedshooting = false end)
--         end

--         Wait(100)
--     end
-- end)