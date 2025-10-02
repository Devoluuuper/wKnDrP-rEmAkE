local stage = 0
local movingForward = false
local walkSet = 'default'

local function ResetAnimSet()
    if walkSet == 'default' then
        ResetPedMovementClipset(cache.ped)
        ResetPedWeaponMovementClipset(cache.ped)
        ResetPedStrafeClipset(cache.ped)
    else
        ResetPedMovementClipset(cache.ped)
        ResetPedWeaponMovementClipset(cache.ped)
        ResetPedStrafeClipset(cache.ped)
        Wait(100)
        lib.requestAnimSet(walkSet)
        SetPedMovementClipset(cache.ped, walkSet, 1)
        RemoveAnimSet(walkSet)
    end
end

CreateThread(function()
    while true do
        Wait(1)

        if not cache.vehicle and not IsPedFalling(cache.ped) and not IsPedSwimming(cache.ped) and not IsPedSwimmingUnderWater(cache.ped) then
            if IsControlJustPressed(0, 60) then
                stage = stage + 1
                if stage == 2 then
                    -- Crouch stuff
                    Wait(500)
                    lib.requestAnimSet('move_ped_crouched')

                    SetPedMovementClipset(cache.ped, 'move_ped_crouched',1.0)
                    SetPedWeaponMovementClipset(cache.ped, 'move_ped_crouched',1.0)
                    SetPedStrafeClipset(cache.ped, 'move_ped_crouched_strafing',1.0)
                elseif stage > 2 then
                    Wait(500)
                    stage = 0
                    ResetAnimSet()
                    SetPedStealthMovement(cache.ped,0,0)
                end
            end

            if stage == 2 then
                if GetEntitySpeed(cache.ped) > 1.0 then
                    SetPedWeaponMovementClipset(cache.ped, 'move_ped_crouched',1.0)
                    SetPedStrafeClipset(cache.ped, 'move_ped_crouched_strafing',1.0)
                elseif GetEntitySpeed(cache.ped) < 1.0 and (GetFollowPedCamViewMode() == 4 or GetFollowVehicleCamViewMode() == 4) then
                    ResetPedWeaponMovementClipset(cache.ped)
                    ResetPedStrafeClipset(cache.ped)
                end
            end
        else
            stage = 0
            Wait(1000)
        end
    end
end)