local playerInCamera = false

requestModel = function(model)
    if HasModelLoaded(model) then
        return
    end
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(10)
    end
end

Citizen.CreateThread(function()
    local target = Config.targetScript
    for typ, data in pairs(Config.Peds) do
        for _, ped in pairs(data.coords) do
            if not DoesEntityExist(ped.handle) then
                requestModel(data.pedModel)
                ped.handle = CreatePed(4, data.pedModel, ped.coords.x, ped.coords.y, ped.coords.z - 1.0, ped.coords.w, false, false)
                SetPedDefaultComponentVariation(ped.handle)
                SetPedDiesWhenInjured(ped.handle, false)
                SetEntityInvincible(ped.handle, true)
                FreezeEntityPosition(ped.handle, true)
                TaskSetBlockingOfNonTemporaryEvents(ped.handle, true)
                SetBlockingOfNonTemporaryEvents(ped.handle, true)
                SetModelAsNoLongerNeeded(data.pedModel)
            end
            if target ~= "default" then
                if target == 'qtarget' or target == 'qb-target' then
                    exports[target]:AddBoxZone(('dialog_%s'):format(ped.handle), vector3(ped.coords.x, ped.coords.y, ped.coords.z), 3.0, 3.0,
                        {
                            name = ('dialog_%s'):format(ped.handle),
                            heading = ped.coords.w,
                            debugPoly = false,
                            minZ = ped.coords.z - 0.3,
                            maxZ = ped.coords.z + 0.3,
                        },
                        {
                            options = {
                                {
                                    icon = 'fa-solid fa-comment-dots',
                                    label = (Strings['talk_npc']):format(data.pedName),
                                    job = 'all',
                                    -- config = { vector3(ped.coords.x, ped.coords.y, ped.coords.z), ped.coords.w, ped.handle },
                                    canInteract = function()
                                        if playerInCamera then
                                            return false
                                        end

                                        return true
                                    end,
                                    action = function()
                                        createDialog(ped.handle, data, typ)
                                    end,
                                },
                            },
                            distance = 2.75,
                        }
                    )
                elseif target == 'ox_target' then
                    exports[target]:addBoxZone({
                        coords = vector3(ped.coords.x, ped.coords.y, ped.coords.z),
                        size = vec3(2, 2, 2),
                        rotation = ped.coords.w,
                        debug = false,
                        options = {
                            {
                                name = ('dialog_%s'):format(ped.handle),
                                icon = 'fa-solid fa-comment-dots',
                                label = (Strings['talk_npc']):format(data.pedName),
                                config = { vector3(ped.coords.x, ped.coords.y, ped.coords.z), ped.coords.w, ped.handle },
                                canInteract = function()
                                    if playerInCamera then
                                        return false
                                    end
                
                                    return true
                                end,
                                onSelect = function()
                                    createDialog(ped.handle, data, typ)
                                end,
                            },
                        },
                    })
                end
            end
        end
    end
    if target == "default" then
        Citizen.CreateThread(function()
            while true do
                DisplayRadar(false)
                local sleep = 1000
                local playerPed = PlayerPedId()
                local pCoords = GetEntityCoords(playerPed)
                for typ, data in pairs(Config.Peds) do
                    for _, ped in pairs(data.coords) do
                        if DoesEntityExist(ped.handle) then
                            local dst = #(pCoords - vector3(ped.coords.x, ped.coords.y, ped.coords.z))
                            if dst <= 10 then
                                sleep = 1
                                if dst <= 7 and not playerInCamera then
                                    if dst <= 3 then
                                        ShowHelpNotification("~INPUT_CONTEXT~ "..(Strings["talk_npc"]):format(data.pedName))
                                        if IsControlJustPressed(0, 38) and not playerInCamera then
                                            createDialog(ped.handle, data, typ)
                                        end
                                    end
                                end
                            end 
                        end
                    end
                end
                Citizen.Wait(sleep)
            end
        end)
    end
end)

closeDialog = function()
    TriggerEvent('rm_dialognpc:client:closeDialog')
    playerInCamera = false
    
    if DoesCamExist(camera) then
        RenderScriptCams(false, true, 500, 1, 0)
        DestroyCam(camera, false)
    end

    FreezeEntityPosition(PlayerPedId(), false)
    SendNUIMessage({
        action = "openDialog",
        state = false,
        dialogData = {}
    })
    SetNuiFocus(false, false)
end

createDialog = function(npcHandle, data, typ)
    local playerPed = PlayerPedId()
    local npcCoords = GetEntityCoords(npcHandle)
    playerInCamera = true

    FreezeEntityPosition(playerPed, true)
    local camCoords = GetOffsetFromEntityInWorldCoords(npcHandle, 0.0, 0.9, 1.25)
    camera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", camCoords.x, camCoords.y, camCoords.z, 0.00, 0.00, 10.00, 50.0, false, 2)
    PointCamAtCoord(camera, npcCoords.x, npcCoords.y, npcCoords.z + 0.65)
    SetCamActive(camera, true)
    RenderScriptCams(true, true, 500, true, true)

    SendNUIMessage({
        action = "openDialog",
        state = true,
        dialogData = {
            pedName = data.pedName,
            pedType = typ,
            pedTitle = data.title,
            buttons = data.buttons,
        }
    })
    SetNuiFocus(true, true)
end

exports('createDialog', createDialog)

RegisterNUICallback("dialog", function(data, cb)
    if not Config.funcs[data.func] then
        return cb("ok")
    end

    Config.funcs[data.func]()
    closeDialog()
    cb("ok")
end)

RegisterNUICallback("closeDialog", function(data, cb)
    closeDialog()
    return cb("ok")
end)