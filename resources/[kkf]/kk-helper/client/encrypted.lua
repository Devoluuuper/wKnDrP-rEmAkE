local peds = {}

local function createBlip(coords, text, sprite, color, scale)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, scale)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
end

local function requestModel(modelHash, cb)
    modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))
    if not HasModelLoaded(modelHash) and IsModelInCdimage(modelHash) then
        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do
            Wait(0)
        end
    end
    if cb then cb() end
end

local function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

local task = false

-- NPC Interaktsioon
CreateThread(function()
    for k, v in pairs(cfg.locations) do
        local elements = {
            {
                name = 'helper_' .. k,
                distance = 1.5,
                icon = 'fa-solid fa-comment',
                label = v.name,
                action = function()
                    lib.callback('kk-helper:recieveContract', false, function(response)
                        if type(response) == 'table' then
                            local labels = ''
                            for item, amount in pairs(response.items) do
                                labels = labels .. ' (' .. amount .. 'x) ' .. itemLabel(item)
                            end

                            local confirmed = lib.alertDialog({
                                header = v.name,
                                content = response.context,
                                centered = true,
                                cancel = true
                            })

                            if confirmed == 'confirm' then
                                lib.callback('kk-helper:startContract', false, function(coords)
                                    if coords then
                                        task = true
                                        TriggerEvent('kk-hud2:client:showInstruction', v.name, cfg.translations[cfg.language]['bring_me']:format(labels))
                                        if coords then
                                            SetNewWaypoint(coords.x, coords.y)
                                        end
                                    end
                                end)
                            elseif confirmed == 'cancel' then
                                TriggerServerEvent('kk-helper:cancelTask', 'cancel')
                            end

                        elseif response == 'not_now' then
                            TriggerEvent('KKF.UI.ShowNotification', 'error', cfg.translations[cfg.language]['not_great_time'])
                        elseif response == 'active' then
                            lib.callback('kk-helper:deliver', false, function(deliverResponse)
                                if deliverResponse then
                                    task = false
                                    TriggerEvent('KKF.UI.ShowNotification', 'success', cfg.translations[cfg.language]['nice_work'])
                                    TriggerEvent('kk-hud2:client:hideInstruction')
                                end
                            end)
                        else
                            TriggerEvent('KKF.UI.ShowNotification', 'error', cfg.translations[cfg.language]['no_need'])
                        end
                    end, k)
                end
            }
        }

        requestModel(v.model, function()
            local entity = CreatePed(4, v.model, v.pos.x, v.pos.y, v.pos.z - 1, v.pos.w or 0, false, false)
            SetBlockingOfNonTemporaryEvents(entity, true)
            SetPedDiesWhenInjured(entity, false)
            SetPedCanPlayAmbientAnims(entity, true)
            SetPedCanRagdollFromPlayerImpact(entity, false)
            SetEntityInvincible(entity, true)
            FreezeEntityPosition(entity, true)

            if v.anim then
                loadAnimDict(v.anim.dict)
                TaskPlayAnim(entity, v.anim.dict, v.anim.item, 8.0, 8.0, -1, 2, 0.0, false, false, false)
            end

            peds[#peds + 1] = entity

            if v.lockpick and cfg.exchangeLockpick then
                elements[#elements + 1] = {
                    name = 'lockpick_' .. k,
                    distance = 1.5,
                    icon = 'fa-solid fa-right-left',
                    label = cfg.translations[cfg.language]['exchange'],
                    serverEvent = 'kk-helper:server:exchangeLockpick'
                }
            end

            exports.qtarget:AddTargetEntity(entity, {
                options = elements,
                distance = 1.5
            })

            if v.blip then
                createBlip(v.pos, v.name, 47, 3, 1.0)
            end
        end)
    end
end)

RegisterNetEvent('KKF.Player.Unloaded', function()
    if task then
        task = false
        TriggerEvent('kk-hud2:client:hideInstruction')
    end
end)
