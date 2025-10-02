local actionInProgress = false
local polyZone = nil;
local currentClient = nil

RegisterNetEvent('KKF.Player.Loaded')
AddEventHandler('KKF.Player.Loaded', function(xPlayer)
    KKF.PlayerData = xPlayer
end)

RegisterNetEvent('KKF.Player.Unloaded', function() 
	KKF.PlayerData = {} 
end)

local isSellingDrugs = false
local cooldown = 0
local hasclient = false
local blip = nil
local obj = nil

local npclocations = {
    {model = "g_m_y_strpunk_01", pos = vector3(36.13, -1000.63, 29.42), heading = 251.77},
    {model = "g_m_m_armgoon_01", pos = vector3(141.35, -1057.21, 29.19), heading = 162.35},
    {model = "g_m_m_chiboss_01", pos = vector3(-713.63, -886.67, 23.80), heading = 356.53},
    {model = "csb_chin_goon", pos = vector3(-794.65, -963.15, 15.18), heading = 336.54},
    {model = "csb_ramp_mex", pos = vector3(-1327.87, -561.08, 30.41), heading = 127.93},
    {model = "g_m_m_armlieut_01", pos = vector3(-1581.57, -467.67, 36.03), heading = 46.49},
    {model = "csb_g", pos = vector3(261.11, 279.51, 105.65), heading = 164.65},
    {model = "u_m_m_aldinapoli", pos = vector3(320.26, 98.57, 99.69), heading = 246.04},
    {model = "csb_grove_str_dlr", pos = vector3(-208.02, -1632.36, 33.87), heading = 182.19},
    {model = "g_m_y_famdnf_01", pos = vector3(-93.21, -1592.04, 31.61), heading = 50.13},
    {model = "g_m_y_famfor_01", pos = vector3(-13.09, -1531.72, 29.83), heading = 229.58},
    {model = "g_m_y_mexgoon_03", pos = vector3(-11.91, -1478.34, 30.50), heading = 321.50},
    {model = "g_m_y_famca_01", pos = vector3(-1.84, -1400.42, 29.27), heading = 90.95},
    {model = "csb_burgerdrug", pos = vector3(-1171.45, -901.26, 13.78), heading = 33.46},
    {model = "g_m_y_ballaeast_01", pos = vector3(-0.93, -1828.14, 25.22), heading = 230.58},
    {model = "g_m_y_ballasout_01", pos = vector3(96.65, -1808.06, 27.08), heading = 232.00},
    {model = "g_m_y_ballaorig_01", pos = vector3(66.38, -1924.31, 21.44), heading = 320.76},
    {model = "g_m_y_mexgoon_01", pos = vector3(247.15, -1996.54, 20.20), heading = 55.23},
    {model = "g_m_y_mexgoon_03", pos = vector3(330.99, -2011.65, 22.14), heading = 52.60},
    {model = "g_m_y_lost_01", pos = vector3(970.00, -191.61, 73.08), heading = 62.91},
    {model = "g_m_y_lost_02", pos = vector3(837.67, -128.13, 79.34), heading = 149.84},
    {model = "g_m_y_lost_03", pos = vector3(963.74, -117.48, 74.35), heading = 222.32},
    {model = "csb_grove_str_dlr", pos = vector3(1246.93, -713.00, 62.89), heading = 96.72},
    {model = "csb_grove_str_dlr", pos = vector3(1216.63, -652.28, 64.10), heading = 203.57},
    {model = "csb_grove_str_dlr", pos = vector3(1223.51, -503.07, 66.40), heading = 255.39},
    {model = "g_m_y_salvagoon_02", pos = vector3(1404.66, -1530.25, 58.32), heading = 55.33},
    {model = "g_m_y_salvaboss_01", pos = vector3(1348.96, -1554.08, 53.78), heading = 25.18},
    {model = "g_m_y_salvagoon_01", pos = vector3(1225.25, -1600.42, 52.11), heading = 212.26}
}

local function canSell()
    for k,v in pairs(cfg.selling.items) do
        if exports.ox_inventory:Search('count', k) > 0 then
            return true
        end
    end

    return false
end

RegisterNUICallback('setSellingRecieve', function(args, cb)
    if not isSellingDrugs then
        lib.callback('kk-tablet:selling:setRecieve', false, function(response)
            cb(response)
        end, true)

        isSellingDrugs = true
    else
        lib.callback('kk-tablet:selling:setRecieve', false, function(response)
        end, false)

        isSellingDrugs = false; SendNUIMessage({action = 'sellingStop'})

        if hasclient then
            cooldown = GetGameTimer()
            hasclient = false

            exports.ox_target:removeEntity({NetworkGetNetworkIdFromEntity(currentClient)}, {'sell_drugs'})
            DeletePed(currentClient)

            currentClient = nil
    
            RemoveBlip(blip)
            DeleteObject(obj)
            obj = nil
    
            actionInProgress = false
        end
    end

    cb(isSellingDrugs)
end)

RegisterNUICallback('loadSellingData', function(args, cb)
    lib.callback('kk-tablet:selling:requestData', false, function(response)
        cb(response)
    end)    
end)

RegisterNetEvent('KKF.Player.Unloaded', function()
    lib.callback('kk-tablet:selling:setRecieve', false, function(response)
    end, false)
    isSellingDrugs = false; SendNUIMessage({action = 'sellingStop'})

    if hasclient then
        cooldown = GetGameTimer()
        hasclient = false

        exports.ox_target:removeEntity({NetworkGetNetworkIdFromEntity(currentClient)}, {'sell_drugs'})
        DeletePed(currentClient)

        currentClient = nil

        RemoveBlip(blip)
        DeleteObject(obj)
        obj = nil

        actionInProgress = false
    end
end)

function CreateNewTask()
    if canSell() then
        local npcspawn = cfg.selling.locations[math.random(1, #cfg.selling.locations)]
        local alreadyEnteredZone = false

        TriggerEvent('KKF.UI.ShowNotification', 'info', 'Leidsite kliendi, asukoht märgiti GPS-ile')

        blip = AddBlipForCoord(npcspawn)
        SetBlipSprite(blip, 464)
        SetBlipColour(blip, 13)
        SetBlipScale(blip, 1.2)
        SetBlipDisplay(blip, 4)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName('Klient')
        EndTextCommandSetBlipName(blip)

        polyZone = lib.zones.box({
            coords = vec3(npcspawn.x, npcspawn.y, npcspawn.z),
            size = vec3(50, 50, math.abs((npcspawn.z + 100.0) - (npcspawn.z - 5.0))),
            rotation = 0,
            debug = false,
            onEnter = function()
                polyZone:remove();

                lib.callback('KKF.Entity.SpawnPed', false, function(networkId)
                    if networkId then
                        while not NetworkDoesEntityExistWithNetworkId(networkId) do
                            Wait(10)
                        end

                        currentClient = NetworkGetEntityFromNetworkId(networkId)
                        KKF.Game.RequestNetworkControlOfEntity(currentClient)

                        PlaceObjectOnGroundProperly(currentClient)
                        SetEntityAsMissionEntity(currentClient)
                        SetPedCanRagdollFromPlayerImpact(currentClient, false)
                        FreezeEntityPosition(currentClient, true)

                        exports.ox_target:addEntity({networkId}, {
                            {
                                name = 'sell_drugs',
                                icon = 'fa-solid fa-hand',
                                label = 'Anna kaup üle',
                                distance = 1.5,
                
                                onSelect = function(args)
                                    if not cache.vehicle then
                                        if not actionInProgress then
                                            local cachedPed = currentClient
                                            actionInProgress = true
                                            FreezeEntityPosition(cache.ped, true)
                                            SetPedTalk(currentClient)
                                            PlayAmbientSpeech1(currentClient, 'GENERIC_HI', 'SPEECH_PARAMS_STANDARD')
        
                                            obj = exports['kk-scripts']:spawnAttachedObject(currentClient, joaat('hei_prop_heist_cash_pile'), 57005, 0.13, 0.02, 0.0, -90.0, 0, 0)
                
                                            TriggerEvent('kk-needs:client:addNeed', 'stress', 1000)

                                            local progress = exports['kk-taskbar']:startAction('sellDrugs', 'Annad kaupa üle', 5000, 'actor_berating_loop', 'misscarsteal4@actor', {freeze = true, controls = true})
        
                                            if progress then
                                                exports.ox_target:removeEntity({networkId}, {'sell_drugs'})
                                                lib.requestAnimDict('mp_common')
        
                                                TaskPlayAnim(cache.ped, 'mp_common', 'givetake1_a', 8.0, 1.0, -1, 49, 0, 0, 0, 0)
                                                TaskPlayAnim(currentClient, 'mp_common', 'givetake1_a', 8.0, 1.0, -1, 49, 0, 0, 0, 0)
        
                                                AttachEntityToEntity(obj, cache.ped, GetPedBoneIndex(cache.ped, 57005), 0.13, 0.02, 0.0, -90.0, 0, 0, 1, 1, 0, 1, 0, 1)
        
                                                Wait(500)
                                                PlayAmbientSpeech1(currentClient, 'GENERIC_THANKS', 'SPEECH_PARAMS_STANDARD')
                                                SetPedAsNoLongerNeeded(currentClient)
                                                FreezeEntityPosition(currentClient, false)
                                                TaskWanderStandard(currentClient, 10, 10)
                                                FreezeEntityPosition(cache.ped, false)
                                                ClearPedTasks(cache.ped); ClearPedTasks(currentClient)
                                                TriggerServerEvent('drugselling:server:soldDrug')
                                                TriggerEvent('KKF.UI.ShowNotification', 'success', 'Tehing läks edukalt!')
                                                cooldown = GetGameTimer()
                                                hasclient = false
                                                currentClient = nil
                                                RemoveBlip(blip)
                                                Wait(3000); DeleteObject(obj)
                                                actionInProgress = false
                                                Wait(15000); DeletePed(cachedPed)
                                            else
                                                PlayAmbientSpeech1(currentClient, 'GENERIC_FUCK_YOU', 'SPEECH_PARAMS_STANDARD')
                                                SetPedAsNoLongerNeeded(currentClient)
                                                FreezeEntityPosition(currentClient, false)
                                                TaskWanderStandard(currentClient, 10, 10)
                                                FreezeEntityPosition(cache.ped, false)
                                                ClearPedTasks(cache.ped); ClearPedTasks(currentClient)
                                                cooldown = GetGameTimer()
                                                hasclient = false
                                                currentClient = nil
                                                RemoveBlip(blip)
                                                Wait(3000); DeleteObject(obj)
                                                actionInProgress = false
                                                Wait(15000); DeletePed(cachedPed)
                                            end
                                        end
                                    else
                                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ei tohi olla üheski sõidukis!')
                                    end
                                end
                            }
                        })
                    end
                end, cfg.peds[math.random(1, #cfg.peds)], vec3(npcspawn.x, npcspawn.y, npcspawn.z), npcspawn.w)
            end
        })
    end
end


CreateThread(function()
    while true do
        Wait(10000)

        if cooldown == 0 then
            cooldown = GetGameTimer()
        end

        -- random timer 5 ja 10 minuti vahel
        if GetGameTimer() - math.random(30000, 60000) > cooldown and isSellingDrugs then
            if not hasclient then
                cooldown = GetGameTimer()
                hasclient = true
                CreateNewTask()
            end
        end
    end
end)

--

local houseLists = {}
local current = {
    boxZone = nil,
    coords = nil,
    npc = nil,
    target = nil,
    blip = nil,
    distance = nil
}

CreateThread(function()
	lib.callback('kk-tablet:getHouses', false, function(response)
		houseLists = response
    end)
end)

RegisterNetEvent('kk-tablet:selling:removeJob', function()
    if current.boxZone then current.boxZone:remove() end; current.coords = nil

    if current.npc then 
        exports.ox_target:removeEntity({NetworkGetNetworkIdFromEntity(current.npc)}, {'giveSelling'})

        DeletePed(current.npc); current.npc = nil
    end

    RemoveBlip(current.blip); current.blip = nil
    SendNUIMessage({action = 'removeSellingJobInfo'})
end)

RegisterNUICallback('cancelJobSelling', function(args, cb)
    lib.callback('kk-tablet:selling:cancelJob', false, function(response)
        cb(response); if current.boxZone then current.boxZone:remove() end; current.coords = nil

        if current.npc then 
            exports.ox_target:removeEntity({NetworkGetNetworkIdFromEntity(current.npc)}, {'giveSelling'})

            DeletePed(current.npc); current.npc = nil
        end

        RemoveBlip(current.blip); current.blip = nil
        TriggerEvent('KKF.UI.ShowNotification', 'info', 'Lõpetasite tööotsa!')
    end)
end)

RegisterNUICallback('loadJobSelling', function(args, cb)
    lib.callback('kk-tablet:selling:loadJob', false, function(response)
        cb(response)
    end, args.id)
end)

RegisterNUICallback('setWaypointSelling', function(args, cb)
    SetNewWaypoint(current.coords.x, current.coords.y)
    TriggerEvent('KKF.UI.ShowNotification', 'info', 'Marker määratud!')
    cb(1)
end)

local function createBlip()
    current.blip = AddBlipForRadius(current.coords.x, current.coords.y, 0.0, 30.0)
    SetBlipSprite(current.blip, 9)
    SetBlipColour(current.blip, 1)
    SetBlipAlpha(current.blip, 80) 
end

local function makeEntityFaceEntity(entity1, entity2)
    local p1 = GetEntityCoords(entity1, true)
    local p2 = GetEntityCoords(entity2, true)

    local dx = p2.x - p1.x
    local dy = p2.y - p1.y

    local heading = GetHeadingFromVector_2d(dx, dy)
    SetEntityHeading( entity1, heading )
end

local function createDelivery()
    local randomLocation = cfg.selling.locations[math.random(1, #cfg.selling.locations)]
    local playerCoords = GetEntityCoords(cache.ped)
    current.coords = randomLocation.xyz; SetNewWaypoint(current.coords.x, current.coords.y)
    createBlip()

    current.boxZone = lib.zones.box({
        coords = randomLocation.xyz,
        size = vec3(50, 50, math.abs(300 - 0)),
        rotation = randomLocation.w,
        debug = false,
        onEnter = function()
            if current.boxZone then current.boxZone:remove(); end

            lib.callback('KKF.Entity.SpawnPed', false, function(networkId)
                if networkId then
                    while not NetworkDoesEntityExistWithNetworkId(networkId) do
                        Wait(10)
                    end

                    current.npc = NetworkGetEntityFromNetworkId(networkId)
                    KKF.Game.RequestNetworkControlOfEntity(current.npc)

                    PlaceObjectOnGroundProperly(current.npc)
                    SetBlockingOfNonTemporaryEvents(current.npc, true)
                    SetPedDiesWhenInjured(current.npc, false)
                    SetPedCanPlayAmbientAnims(current.npc, true)
                    SetPedCanRagdollFromPlayerImpact(current.npc, false)
                    SetEntityInvincible(current.npc, true)
                    FreezeEntityPosition(current.npc, true)

                    exports.ox_target:addEntity({networkId}, {
                        {
                            name = 'giveSelling',
                            icon = 'fa-solid fa-hand',
                            label = 'Anna kaup üle',
                            distance = 1.5,
            
                            onSelect = function(args)
                                lib.callback('kk-tablet:selling:canFinish', false, function(canFinish)
                                    if canFinish then
                                        if cache.vehicle then
                                            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ei saa seda tegevust autos teha!')
                                        else
                                            makeEntityFaceEntity(cache.ped, current.npc); makeEntityFaceEntity(current.npc, cache.ped)
        
                                            SetPedTalk(current.npc)
                                            PlayAmbientSpeech1(current.npc, 'GENERIC_HI', 'SPEECH_PARAMS_STANDARD')
            
                                            TaskPlayAnim(current.npc, 'mp_common', 'givetake1_a', 8.0, 8.0, -1, 0, 1, false, false, false)
                                            local progress = exports['kk-taskbar']:startAction('give_food', 'Annad asju üle', 3000, 'givetake1_a', 'mp_common', {freeze = true, controls = true})
            
                                            if progress then
                                                lib.callback('kk-tablet:selling:finishJob', false, function(response)
                                                    PlayAmbientSpeech1(current.npc, 'GENERIC_THANKS', 'SPEECH_PARAMS_STANDARD')
                
                                                    SendNUIMessage({action = 'removeSellingJobInfo'})
                        
                                                    if current.npc then 
                                                        exports.ox_target:removeEntity({NetworkGetNetworkIdFromEntity(current.npc)}, {'giveSelling'})
                                                        if DoesEntityExist(args.entity) then SetEntityAsMissionEntity(args.entity, true, true); DeletePed(args.entity) end

                                                        DeletePed(current.npc); current.npc = nil
                                                        RemoveBlip(current.blip); current.blip = nil
                                                    end
                                                end)   
    
                                                current.coords = nil
                                            end
                                        end
                                    else
                                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil ei ole kõiki tellitud esemeid!')
                                    end
                                end)
                            end
                        }
                    })
                end
            end, cfg.peds[math.random(1, #cfg.peds)], randomLocation.xyz, randomLocation.w)
        end
    })
end

RegisterNUICallback('acceptJobSelling', function(args, cb)
    lib.callback('kk-tablet:selling:acceptJob', false, function(response)
        cb(response)

        createDelivery()
    end, args.id)
end)

RegisterNetEvent('kk-tablet:selling:reloadSelling', function()
    SendNUIMessage({action = 'reloadSelling'})
end)