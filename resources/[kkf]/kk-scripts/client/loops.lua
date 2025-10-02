local density = 0.1
local pedDensity = 0.2
local isSpeeding = false
local isDriver = false

CreateThread(function()
	while true do
        if IsPedArmed(cache.ped, 6) then
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
		end

        -- OneSync

        local vehDensity = isSpeeding and 0.0 or density
    
        SetParkedVehicleDensityMultiplierThisFrame(pedDensity)
        SetVehicleDensityMultiplierThisFrame(vehDensity)
        SetRandomVehicleDensityMultiplierThisFrame(vehDensity)
        SetPedDensityMultiplierThisFrame(pedDensity)
        SetScenarioPedDensityMultiplierThisFrame(pedDensity, pedDensity) -- Walking NPC Density

        HideHudComponentThisFrame(1) -- Wanted Stars
        HideHudComponentThisFrame(3) -- Cash
        HideHudComponentThisFrame(4) -- MP CASH
        HideHudComponentThisFrame(6)
        HideHudComponentThisFrame(7)
        HideHudComponentThisFrame(8)
        HideHudComponentThisFrame(9)
        HideHudComponentThisFrame(13) -- Cash Change
        HideHudComponentThisFrame(11) -- Floating Help Text
        HideHudComponentThisFrame(12) -- more floating help text

        if not IsAimCamActive() or not IsFirstPersonAimCamActive() then HideHudComponentThisFrame(14) end

        HideHudComponentThisFrame(15) -- Subtitle Text
        HideHudComponentThisFrame(18) -- Game Stream
        HideHudComponentThisFrame(19) -- weapon whee
		DisplayAmmoThisFrame(0) --ammo
        
        SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
        DisablePlayerVehicleRewards(PlayerId())
        SetPlayerTargetingMode(2)

        --OneSync

        DisableControlAction(0, 36, true)

        for i = 1, #Config.Pickups do
		    RemoveAllPickupsOfType(Config.Pickups[i])
        end

        SetPedSuffersCriticalHits(cache.ped, false)
		SetPlayerLockonRangeOverride(PlayerId(), 0.1)

        if cache.vehicle then
            local roll = GetEntityRoll(cache.vehicle)

            if (roll > 75.0 or roll < -75.0) and GetEntitySpeed(cache.vehicle) < 2 then
                DisableControlAction(2, 59, true) -- Disable left/right
                DisableControlAction(2 ,60, true) -- Disable up/down
            end

            local model = GetEntityModel(cache.vehicle)

            if not IsThisModelABoat(model) and not IsThisModelAHeli(model) and not IsThisModelAPlane(model) and IsEntityInAir(cache.vehicle) then
                DisableControlAction(0, 59) -- leaning left/right 
                DisableControlAction(0, 60) -- leaning up/down
                DisableControlAction(0, 280) -- leaning up/down 
                DisableControlAction(0, 281) -- leaning up/down 
            end
        end

        if not IsPedArmed(cache.ped, 1) and GetSelectedPedWeapon(cache.ped) ~= joaat('weapon_unarmed') then
			DisableControlAction(0, 140, true) 
			DisableControlAction(0, 141, true) 
			DisableControlAction(0, 142, true) 
		end

        if cache.vehicle and (GetVehicleClass(cache.vehicle) == 8 or GetVehicleClass(cache.vehicle) == 13) then
            DisableControlAction(0, 345, true)
            DisableControlAction(0, 346, true)
            DisableControlAction(0, 347, true)
        end

        SetPedConfigFlag(cache.ped, 35, false)

        N_0x4757f00bc6323cfe(`WEAPON_UNARMED`, 0.3)

		Wait(0)
	end
end)

lib.onCache('vehicle', function(value)
    isSpeeding = false
    isDriver = cache.seat == -1
end)

lib.onCache('seat', function(value)
    isDriver = value == -1
end)

AddEventHandler('baseevents:vehicleSpeeding', function(value)
    isSpeeding = value
end)