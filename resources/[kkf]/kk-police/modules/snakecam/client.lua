local Snakecam = {
    Active = false
}

function createSnakeCam()
    SetTimecycleModifier('scanline_cam_cheap')
    SetTimecycleModifierStrength(1.5)
    local ped = PlayerPedId()
    local pos, heading = GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.0, -0.75), GetEntityHeading(ped)
    local cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', pos.x, pos.y, pos.z, 0.0, 0.00, heading, 45.00, false, 0)
	SetCamActive(cam, true)
	RenderScriptCams(true, true, 1, true, true)
    return cam
end

function deleteSnakeCam(cam)
	SetCamActive(cam, false)
	RenderScriptCams(false, true, 1, true, true)
    DestroyCam(cam)
    ClearTimecycleModifier()    
end

function getDirectionFromRotation(rotation)
    local dm = (math.pi / 180)
    return vector3(-math.sin(dm * rotation.z) * math.abs(math.cos(dm * rotation.x)), math.cos(dm * rotation.z) * math.abs(math.cos(dm * rotation.x)), math.sin(dm * rotation.x))
end

function startSnakeCam()
    if Snakecam.Active then 
        return ShowNotification('Salakaamera töötab.') 
    end
    Snakecam.Active = true
    CreateThread(function()
        DoScreenFadeOut(1000)
        Wait(1000)
        DoScreenFadeIn(1000)
        local ped = PlayerPedId()
        local cam = createSnakeCam()
        local maxSnakeLength = cfg.snakeCam.MaxLength
        local ctrl = cfg.snakeCam.Controls
        local speed = 0.1
        local startCoords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.75, -0.75)
        local cancelled = false

        local obj = CreateObject(`bkr_prop_biker_gcase_s`, startCoords.x, startCoords.y, startCoords.z, true, true, false)
        SetEntityHeading(obj, GetEntityHeading(ped))
        PlaceObjectOnGroundProperly(obj)
        FreezeEntityPosition(obj, true)
        FreezeEntityPosition(ped, true)

        CreateThread(function()
            while Snakecam.Active do
                if not IsEntityPlayingAnim(cache.ped, 'anim@heists@prison_heiststation@cop_reactions', 'cop_b_idle', 3) then
                    lib.requestAnimDict('anim@heists@prison_heiststation@cop_reactions')
                    TaskPlayAnim(cache.ped, 'anim@heists@prison_heiststation@cop_reactions', 'cop_b_idle', 8.0, 8.0, -1, 33, 0, 0, 0, 0)
                    wait = 5000
                end

                Wait(0)
            end
        end)

        while not LocalPlayer.state.isDead do 
            DisableControlAction(0, 32, true)
            DisableControlAction(0, 31, true)
            DisableControlAction(0, 34, true)
            DisableControlAction(0, 30, true)
            
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 257, true)
    
            local coords = GetCamCoord(cam)
            local rot = GetCamRot(cam, 2)
            local dir = getDirectionFromRotation(rot) * speed
            local snakeLength = #(coords - startCoords)
            local rx, rz = 0, 0
            local distScale = (snakeLength / maxSnakeLength)
            local str = 1.0 + (3.0 * distScale)
            SetTimecycleModifierStrength(str)
    
            if IsDisabledControlPressed(1, ctrl.up) then
                local newCoords = vector3(coords.x + dir.x, coords.y + dir.y, coords.z + dir.z)
                local newDist = #(newCoords - startCoords)
                if newDist < maxSnakeLength then 
                    SetCamCoord(cam, newCoords.x, newCoords.y, newCoords.z)
                end
            end
            if IsDisabledControlPressed(1, ctrl.down) then
                local newCoords = vector3(coords.x - dir.x, coords.y - dir.y, coords.z - dir.z)
                local newDist = #(newCoords - startCoords)
                if newDist < maxSnakeLength then 
                    SetCamCoord(cam, newCoords.x, newCoords.y, newCoords.z)
                end
            end
            if IsDisabledControlPressed(1, ctrl.look_up) then
                rx = rx + speed * 8
            end
            if IsDisabledControlPressed(1, ctrl.look_down) then
                rx = rx - speed * 8
            end
            if IsDisabledControlPressed(1, ctrl.look_left) then
                rz = rz + speed * 8
            end
            if IsDisabledControlPressed(1, ctrl.look_right) then
                rz = rz - speed * 8
            end
    
            if IsControlPressed(1, ctrl.stop_cam) then 
                cancelled = true
                break
            end
    
            SetCamRot(cam, rot.x + rx, rot.y, rot.z + rz, 2)
            Wait(0)
        end
        
        DoScreenFadeOut(1000)
        Wait(1000)
        deleteSnakeCam(cam)
        DeleteEntity(obj)
        FreezeEntityPosition(ped, false)
        DoScreenFadeIn(1000)
        Snakecam.Active = false
        ClearPedTasks(ped)
        TriggerServerEvent('kk-police:server:requestRefund')
    end)
end

RegisterNetEvent('kk-police:client:attemptSnakecam', startSnakeCam)