RegisterNetEvent('kk-arcade:client:startGame', function(data)
    FreezeCommand = true
    local obj = GetClosestObjectOfType(GetEntityCoords(cache.ped), 1.5, cfg.locations[data.location].hash, false, false, false)

    if obj ~= 0 then
        SpawnArcadeGameCamera(obj, cfg.locations[data.location].camera)

        RequestAnimDict("mini@repair")
        local breakMe = 0
        while not HasAnimDictLoaded("mini@repair") do
            Wait(33)
            breakMe = breakMe + 1
            if breakMe == 20 then
                return false
            end
        end

        Wait(100)
        TaskPlayAnim(cache.ped, "mini@repair", "fixing_a_ped", 8.0, 8.0, 6000, 49, 0, 0, 0, 0)
        RemoveAnimDict("mini@repair")
    end

    SendNUIMessage({ action = 'open', data = { url = cfg.games[data.game].link } })

    SetNuiFocus(true, true)
    FreezeCommand = false
end)

CreateThread(function()
    for i = 1, #cfg.locations do
        exports.ox_target:addBoxZone({
            coords = cfg.locations[i].target.coords,
            size = cfg.locations[i].target.size,
            rotation = cfg.locations[i].target.rotation,
            debug = false,
            options = {
                {
                    icon = 'fa-solid fa-gamepad',
                    label = 'Mängi',
                    distance = 1.5,
                    onSelect = function()
                        local elements = {}

                        for k,v in pairs(cfg.games) do
                            elements[#elements + 1] = {
                                icon = 'fa-solid fa-gamepad',
                                title = v.name,
                                event = 'kk-arcade:client:startGame',
                                args = { game = k, location = i }
                            }
                        end

                        lib.registerContext({
                            id = 'play_games',
                            title = 'Mängud',
                            options = elements
                        })

                        lib.showContext('play_games')
                    end
                }
            }
        })
    end
end)

RegisterNUICallback('close', function()
    SendNUIMessage({ action = 'close' })
    SetNuiFocus(false, false)
    RevertMinigameCamera()
    ClearPedTasks(PlayerPedId())
end)