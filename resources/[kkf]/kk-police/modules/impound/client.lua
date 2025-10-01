local ped = nil

local function registerPed()
    exports['kk-scripts']:requestModel(`s_f_y_sheriff_01`)
    local entity = CreatePed(4, `s_f_y_sheriff_01`, cfg.impoundNpc.x, cfg.impoundNpc.y, cfg.impoundNpc.z - 1, cfg.impoundNpc.w or 0, false, false)
    ESX.CreateBlip('police_impound_davis', vec3(cfg.impoundNpc.x, cfg.impoundNpc.y, cfg.impoundNpc.z), 'Teisaldatud sõidukid', 380, 53, 0.7)

    SetBlockingOfNonTemporaryEvents(entity, true)
    SetPedDiesWhenInjured(entity, false)
    SetPedCanPlayAmbientAnims(entity, true)
    SetPedCanRagdollFromPlayerImpact(entity, false)
    SetEntityInvincible(entity, true)
    FreezeEntityPosition(entity, true)
    TaskStartScenarioInPlace(entity, 'WORLD_HUMAN_COP_IDLES', 0, true)
    ped = entity

    exports.ox_target:addLocalEntity(entity, {
        {
            name = 'impoundList',
            distance = 3.0,
            icon = 'fa-solid fa-list',
            label = 'Teisaldatud sõidukid',
            canInteract = function()
                return not cache.vehicle and (ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.onDuty)
            end,
            onSelect = function()
                lib.callback('kk-police:recieveImpounded', false, function(response)
                    local elements = {}

                    if response then
                        for k,v in pairs(response) do
                            local vehData = json.decode(v.vehicle)
                            local vehicleLabel = GetDisplayNameFromVehicleModel(vehData.model); vehicleLabel = GetLabelText(vehicleLabel)

                            elements[#elements + 1] = {
                                title = vehicleLabel,
                                description = 'REG.NR: ' .. v.plate,
                                icon = 'fa-solid fa-car-side',
                                args = {plate = v.plate, data = vehData},
                                event = 'kk-police:client:releaseImpounded',
                                metadata = {
                                    ['Kuupäev'] = v.date,
                                    ['Määratud aeg'] = v.time .. ' päeva',
                                    ['Väljastus võimalus alates'] = v.enddate
                                }
                            }
                        end
                    end

                    lib.registerContext({
                        id = 'impounded_vehicles_leo',
                        title = 'Teisaldatud sõidukid',
                        options = elements
                    })
                
                    lib.showContext('impounded_vehicles_leo')
                end)
            end
        },

        {
            name = 'impoundPed',
            distance = 3.0,
            icon = 'fa-solid fa-person',
            label = 'Minu teisaldatud sõidukid',
            canInteract = function()
                return not cache.vehicle
            end,
            onSelect = function()
                lib.callback('kk-police:recieveMyImpounded', false, function(response)
                    local elements = {}

                    if response then
                        for k,v in pairs(response) do
                            local vehData = json.decode(v.vehicle)
                            local vehicleLabel = GetDisplayNameFromVehicleModel(vehData.model); vehicleLabel = GetLabelText(vehicleLabel)

                            elements[#elements + 1] = {
                                title = (v.nickname or vehicleLabel),
                                description = 'REG.NR: ' .. v.plate,
                                icon = 'fa-solid fa-car-side',
                                metadata = {
                                    ['Kuupäev'] = v.date,
                                    ['Määratud aeg'] = v.time .. ' päeva',
                                    ['Väljastus võimalus alates'] = v.enddate
                                }
                            }
                        end
                    end

                    lib.registerContext({
                        id = 'impounded_vehicles',
                        title = 'Minu teisaldatud sõidukid',
                        options = elements
                    })
                
                    lib.showContext('impounded_vehicles')
                end)
            end
        }
    })
end

local function deRegisterPed()
    exports.ox_target:removeLocalEntity(ped, {'impoundList', 'impoundPed'})
    DeleteEntity(ped); ped = nil
end

RegisterNetEvent('KKF.Player.Loaded', registerPed)
RegisterNetEvent('KKF.Player.Unloaded', deRegisterPed)

RegisterNetEvent('kk-police:client:releaseImpounded', function(val)
    local triedSpawnPoints = {}
    local spawnPoint = nil
    local success = nil

    while true do
        local spawnID = math.random(#cfg.impoundSpawns)
        local spawn = cfg.impoundSpawns[spawnID]
        local isClear = ESX.Game.IsSpawnPointClear(spawn, 2.5)

        if isClear then
            success = true
            spawnPoint = spawn
            break
        else
            triedSpawnPoints[spawnID] = true
            success = false
        end

        if #triedSpawnPoints == #cfg.impoundSpawns then
            success = false;
            TriggerEvent('KKF.UI.ShowNotification',"error", "Parklas pole ühtegi vaba parkimiskohta.")
            break
        end

        Wait(50)
    end
    if success then
        lib.callback('kk-police:releaseImpounded', false, function(networkId)
            if not networkId then 
                TriggerEvent('KKF.UI.ShowNotification', "error", "Palun proovi uuesti!")
                return 
            end 

            while not NetworkDoesEntityExistWithNetworkId(networkId) do
                Wait(10)
            end

            local vehicle = NetworkGetEntityFromNetworkId(networkId)
            ESX.Game.RequestNetworkControlOfEntity(vehicle)
            SetVehRadioStation(vehicle, "OFF")
            TriggerEvent('KKF.UI.ShowNotification', "success", "Sõiduk väljastatud!")
        end, val.plate, spawnPoint)
    end
end)