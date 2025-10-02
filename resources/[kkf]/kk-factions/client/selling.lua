-- local isBusy = false
-- local dealedEntities = {}

-- local isActive = false
-- local currentNpc = {}
-- local location = nil
-- local cooldown = false

-- local timeout = 2 * 60000


-- local function canSell()
--     local playerJob = QBCore.Functions.GetPlayerData().job
--     local reputation = lib.callback.await('kk-factions:totalReputation', false, playerJob.name)
--     local lvl = 'CATEGORY_LOW'

--     if reputation > 5000 and reputation < 10000 then
--         lvl = 'CATEGORY_MED'
--     elseif reputation > 10000 then
--         lvl = 'CATEGORY_HIGH'
--     end

--     local returnable = false
--     local drugList = {}

--     if lvl == 'CATEGORY_HIGH' then
--         for k, v in pairs(cfg.drugs['CATEGORY_MED']) do
--             drugList[k] = v
--         end
        
--         for k, v in pairs(cfg.drugs['CATEGORY_LOW']) do
--             drugList[k] = v
--         end
--     elseif lvl == 'CATEGORY_MED' then
--         for k, v in pairs(cfg.drugs['CATEGORY_LOW']) do
--             drugList[k] = v
--         end
--     end

--     for k, v in pairs(cfg.drugs[lvl]) do
--         drugList[k] = v
--     end
    
--     for k, v in pairs(drugList) do
--         if not (isGangFaction(playerJob.name) and k == 'hash') then
--             if exports.ox_inventory:Search('count', k) > 0 then
--                 returnable = true
--             end
--         end
--     end

--     return returnable
-- end

-- local function closeEvent()
--     if DoesEntityExist(currentNpc.ped) then
--         TaskWanderStandard(currentNpc.ped, 10.0, 10.0)
--         Wait(10000)
--         SetPedAsNoLongerNeeded(currentNpc.ped)
--         DeleteEntity(currentNpc.ped)
--     end
-- end

-- RegisterNetEvent('rm_dialognpc:client:closeDialog', closeEvent)

-- exports('canSellDrugs', canSell)

-- local function offerStuff(entity)
--     if not dealedEntities[entity] then
--         local coords = GetEntityCoords(cache.ped)
--         local zone = GetNameOfZone(coords)
        
--         isBusy = true
--         NetworkRequestControlOfEntity(entity) --
--         ClearPedTasksImmediately(entity)
--         TaskTurnPedToFaceEntity(entity, cache.ped, -1)
--         TaskTurnPedToFaceEntity(cache.ped, entity, 3000)
--         SetBlockingOfNonTemporaryEvents(entity, true)
--         SetPedTalk(entity)
--         PlayAmbientSpeech1(entity, 'GENERIC_HI', 'SPEECH_PARAMS_STANDARD')

--         -- oma süsteem TriggerEvent('kk-needs:client:addNeed', 'stress', 1000)

--         local progress = exports['karu-taskbar']:TaskBar('offer_drugs', 'Pakud esemeid', 5000, 'actor_berating_loop', 'misscarsteal4@actor', {freeze = false, controls = true})

--         if progress then
--             local needsDrugs = math.random(1, 100)

--             if needsDrugs >= 30 then
--                 lib.requestAnimDict('mp_common')
--                 TaskPlayAnim(entity, 'mp_common', 'givetake1_b', 3.5, -1, -1, 2, 0, 0, 0, 0, 0)

--                 local progress = exports['karu-taskbar']:TaskBar('give_drugs', 'Annad esemeid üle', 1500, 'givetake1_a', 'mp_common', {freeze = false, controls = true})

--                 if progress then
--                     ClearPedTasks(entity)
--                     SetPedAsNoLongerNeeded(entity)
--                     PlayAmbientSpeech1(entity, 'GENERIC_THANKS', 'SPEECH_PARAMS_STANDARD')

--                     dealedEntities[entity] = true
--                     lib.callback.await('kk-factions:sellDrugs', false, zone)
--                 end
--             else
--                 lib.requestAnimDict('missheistdockssetup1clipboard@base')
--                 TaskPlayAnim(entity, 'missheistdockssetup1clipboard@base', 'base', 3.5, -1, -1, 2, 0, 0, 0, 0, 0)

--                 Wait(3000)

--                 PlayAmbientSpeech1(entity, 'GENERIC_FUCK_YOU', 'SPEECH_PARAMS_STANDARD')
--                 ClearPedTasks(entity)
--                 SetPedAsNoLongerNeeded(entity)
--                 TriggerEvent('KKF.UI.ShowNotification', 'error', 'Isik keeldus teie pakkumisest!')
--                 closeEvent()
--             end

--             dealedEntities[entity] = true

--             SetTimeout(10000, function()
--                 if DoesEntityExist(entity) then
--                     exports.ox_target:removeEntity({NetworkGetNetworkIdFromEntity(entity)}, {'sell_stuff'})
--                     DeleteEntity(entity)
--                 end
--             end)
--         end

--         isBusy = false
--     else
--         TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te olete juba talle pakkunud!')
--     end
-- end

-- local function spawnPed()
-- 	if currentNpc then
--         if currentNpc.ped then
--             local case = currentNpc.ped

--             SetTimeout(10000, function()
--                 if DoesEntityExist(case) then
--                     SetPedAsNoLongerNeeded(case)
--                     DeleteEntity(case)
--                 end
--             end)
--         end
-- 	end

-- 	Wait(500)

-- 	currentNpc.hash = joaat(cfg.pedList[math.random(1, #cfg.pedList)])
-- 	lib.requestModel(currentNpc.hash)
-- 	currentNpc.coords = GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 50.0, 5.0)
-- 	retval, currentNpc.z = GetGroundZFor_3dCoord(currentNpc.coords.x, currentNpc.coords.y, currentNpc.coords.z, 0)

--     if retval then
--         currentNpc.zone = GetLabelText(GetNameOfZone(currentNpc.coords))
--         currentNpc.ped = CreatePed(5, currentNpc.hash, currentNpc.coords.x, currentNpc.coords.y, currentNpc.z, 0.0, true, true)

--         PlaceObjectOnGroundProperly(currentNpc.ped)
--         SetEntityAsMissionEntity(currentNpc.ped)

--         local prompted = false

--         CreateThread(function()
--             while DoesEntityExist(currentNpc.ped) and not prompted do
--                 if DoesEntityExist(currentNpc.ped) then
--                     if #(GetEntityCoords(currentNpc.ped) - GetEntityCoords(cache.ped)) < 5 then
--                         prompted = true

--                         SetTimeout(1500, function()
--                             exports['rm_dialognpc']:createDialog(currentNpc.ped, {
--                                 pedModel = currentNpc.hash,
--                                 pedName = "Anonüümne klient",
--                                 title = cfg.npcTexts[math.random(1, #cfg.npcTexts)],
--                                 coords = {
--                                     { coords = GetEntityCoords(currentNpc.ped) }
--                                 },
--                                 buttons = {
--                                     { title = "Paku esemeid", func = "sellDrugs", icon = "fa-solid fa-handshake"},
--                                 }
--                             }, 'Müük')
--                         end)

--                         break
--                     end
--                 end

--                 Wait(500)
--             end
--         end)
        
--         if IsEntityDead(currentNpc.ped) or GetEntityCoords(currentNpc.ped) == vector3(0.0, 0.0, 0.0) then
--             return
--         end
        
--         TaskGoToEntity(currentNpc.ped, cache.ped, 60000, 4.0, 2.0, 0, 0)
--     end
-- end

-- RegisterNetEvent('kk-factions:client:trySellDrugs', function()
--     if not isBusy and not cache.vehicle and NetworkGetEntityIsNetworked(currentNpc.ped) and canSell() and not IsPedDeadOrDying(currentNpc.ped) then
--         offerStuff(currentNpc.ped)
--     end
-- end)

-- RegisterNetEvent('kk-factions:client:cornerSelling', function()
--     if isActive then
--         if DoesEntityExist(currentNpc.ped) then
--             SetPedAsNoLongerNeeded(currentNpc.ped)
--             DeleteEntity(currentNpc.ped)
--         end

--         isActive = false; cooldown = true; location = nil

--         SetTimeout(timeout, function()
--             cooldown = false
--         end)

--         TriggerEvent('KKF.UI.ShowNotification', 'error', 'Lõpetasid müümise!')
--     else
--         if canSell() then
--             if not cooldown then
--                 local coords = GetEntityCoords(cache.ped)
--                 local zone = GetNameOfZone(coords)

--                 if cfg.gangZones[zone] then
--                     isActive = true
--                     location = GetEntityCoords(cache.ped)
                    
--                     TriggerEvent('KKF.UI.ShowNotification', 'info', 'Seadsid end valmis kundede tulekuks. Ära liigu!', 5000)
--                 else
--                     TriggerEvent('KKF.UI.ShowNotification', 'error', 'Kundesid ei ole neh!')
--                 end
--             else
--                 TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ei tasu nõsõm kooserdada!')
--             end
--         else
--             TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil pole midagi müüa!')
--         end
--     end
-- end)

-- CreateThread(function()
--     while true do
--         if isActive and canSell() then
--             spawnPed()
--         end

--         if isActive and not canSell() then
--             isActive = false
--         end

--         Wait(40000)
--     end
-- end)

-- CreateThread(function()
--     while true do
--         wait = 0

--         if location then
--             DrawMarker(20, location.x, location.y, location.z + 1, 0, 0, 0, 0, 0, 0, 0.4, 0.5, 0.2, 255, 33, 33, 91, 0, 0, 0, 0)

--             local distance = #(location - GetEntityCoords(cache.ped))

--             if distance > 5 then
--                 if DoesEntityExist(currentNpc.ped) then
--                     SetPedAsNoLongerNeeded(currentNpc.ped)
--                     DeleteEntity(currentNpc.ped)
--                 end

--                 isActive = false; cooldown = true; location = nil

--                 SetTimeout(timeout, function()
--                     cooldown = false
--                 end)
--             end
--         else
--             wait = 500
--         end

--         Wait(wait)
--     end
-- end)
