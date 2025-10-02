-- local peds = {}
-- local items = exports.ox_inventory:Items()

-- local hasPackage = false
-- local holdingBox = false
-- local boxEntity = nil

-- local targetBlips = {}
-- local PlayerData = {}
-- CreateThread(function()
--     while not LocalPlayer.state.isLoggedIn do
--         Wait(500)
--     end

--     PlayerData = QBCore.Functions.GetPlayerData()
-- end)

-- RegisterNetEvent('kk-factions:client:exchangeItems', function()
--     local progress = exports['kk-taskbar']:startAction('sellDrugs', 'Annad kaupa üle', 5000, false, false, {car = true, move = true, comat = true, cuff = false, falling = false, ragdoll = false, dead = false})
        
--     if progress then
--         TriggerServerEvent('kk-factions:server:exchangeItems', GetNameOfZone(GetEntityCoords(cache.ped)))
--     end
-- end)

-- AddEventHandler('onResourceStart', function()
-- 	PlayerData = QBCore.Functions.GetPlayerData()
-- end)

-- AddEventHandler("onResourceStop", function(resource)
--     if resource == GetCurrentResourceName() then
--         TriggerEvent('kk-factions:client:removeContraband')
--     end
-- end)

-- RegisterNetEvent('kk-factions:client:removeContraband', function()
--     for k,v in pairs(targetBlips) do
--         RemoveBlip(v); targetBlips[k] = nil
--     end

--     if holdingBox then
--         ClearPedTasks(cache.ped)
--         DeleteEntity(boxEntity)
--         holdingBox = false
--     end
-- end)

-- local function disableControls()
--     CreateThread(function()
--         while holdingBox do
--             DisableControlAction(0, 21, true) -- Sprinting
--             DisableControlAction(0, 22, true) -- Jumping
--             DisableControlAction(0, 23, true) -- Vehicle Entering
--             DisableControlAction(0, 36, true) -- Ctrl
-- 			DisableControlAction(0, 24, true) -- disable attack
-- 			DisableControlAction(0, 25, true) -- disable aim
-- 			DisableControlAction(0, 47, true) -- disable weapon
-- 			DisableControlAction(0, 58, true) -- disable weapon
-- 			DisableControlAction(0, 263, true) -- disable melee
-- 			DisableControlAction(0, 264, true) -- disable melee
-- 			DisableControlAction(0, 257, true) -- disable melee
-- 			DisableControlAction(0, 140, true) -- disable melee
-- 			DisableControlAction(0, 141, true) -- disable melee
-- 			DisableControlAction(0, 142, true) -- disable melee
-- 			DisableControlAction(0, 143, true) -- disable melee

--             Wait(0)
--         end
--     end)
-- end

-- local function carryAnimation()
--     CreateThread(function()
--         while holdingBox do
--             if not IsEntityPlayingAnim(cache.ped, 'anim@heists@box_carry@', 'idle', 3) then
--                 TaskPlayAnim(cache.ped, 'anim@heists@box_carry@', 'idle', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
--             end

--             Wait(1000)
--         end
--     end)
-- end

-- SetInterval(function()
--     if LocalPlayer.state.isLoggedIn then
--         if exports.ox_inventory:Search('count', 'package_gang') then
--             hasPackage = exports.ox_inventory:Search('count', 'package_gang') > 0
--         end

--         if hasPackage then
--             if not holdingBox then
--                 holdingBox = true
--                 lib.requestAnimDict('anim@heists@box_carry@')
--                 TaskPlayAnim(cache.ped, 'anim@heists@box_carry@', 'idle', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
--                 carryAnimation()
--                 exports['kk-scripts']:requestModel('hei_prop_heist_box')
--                 boxEntity = exports['kk-scripts']:spawnAttachedObject(cache.ped, joaat('hei_prop_heist_box'), 0xEB95,  0.075, -0.10, 0.255, -130.0, 105.0, 0.0)
--                 disableControls()
--             end
--         elseif holdingBox then
--             ClearPedTasks(cache.ped)
--             DeleteEntity(boxEntity)
--             holdingBox = false
--         end
--     else
--         ClearPedTasks(cache.ped)
--         DeleteEntity(boxEntity)
--         holdingBox = false
--     end
-- end, 1500)

-- RegisterNetEvent('kk-factions:client:drawContraband', function(location, delivery)
--     for k,v in pairs(targetBlips) do
--         RemoveBlip(v); targetBlips[k] = nil
--     end

--     targetBlips[1] = AddBlipForCoord(location)
--     SetBlipSprite(targetBlips[1], 270)
--     SetBlipColour(targetBlips[1], 7)
--     SetBlipScale(targetBlips[1], 0.7)
--     SetBlipDisplay(targetBlips[1], 4)
--     BeginTextCommandSetBlipName('STRING')
--     AddTextComponentSubstringPlayerName('Võta pakid peale')
--     EndTextCommandSetBlipName(targetBlips[1])

--     targetBlips[2] = AddBlipForCoord(delivery)
--     SetBlipSprite(targetBlips[2], 268)
--     SetBlipColour(targetBlips[2], 7)
--     SetBlipScale(targetBlips[2], 0.7)
--     SetBlipDisplay(targetBlips[2], 4)
--     BeginTextCommandSetBlipName('STRING')
--     AddTextComponentSubstringPlayerName('Tarnepunkt')
--     EndTextCommandSetBlipName(targetBlips[2])
-- end)

-- local function registerPeds()
--     SetTimeout(5000, function()
--         exports['kk-scripts']:requestModel(`a_m_m_eastsa_02`)

--         for k,v in pairs(cfg.dealers) do
--             local ped = CreatePed(4, `a_m_m_eastsa_02`, vec3(v.x, v.y, v.z - 1.0), v.w, false, false)
--             Entity(ped).state:set('drugPed', true, true)

--             SetBlockingOfNonTemporaryEvents(ped, true)
--             SetPedDiesWhenInjured(ped, false)
--             SetPedCanPlayAmbientAnims(ped, true)
--             SetPedCanRagdollFromPlayerImpact(ped, false)
--             SetEntityInvincible(ped, true)
--             FreezeEntityPosition(ped, true)
--             TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_SMOKING', 0, true)
    
--             exports.ox_target:addLocalEntity(ped, { -- cfg.contrabandReputation
--                 {
--                     name = 'contrabandNpc',
--                     distance = 1.5,
--                     icon = 'fa-solid fa-user-ninja',
--                     label = 'Salakaup',
--                     canInteract = function()
--                         return isGangFaction(PlayerData.job.name) and lib.callback.await('kk-factions:getReputation', false, k) > cfg.contrabandReputation and PlayerData.job.permissions.dealerExchange
--                     end,
--                     onSelect = function()
--                         lib.callback('kk-factions:checkContraband', false, function(response)
--                             if response then
--                                 TriggerEvent('KKF.UI.ShowNotification', 'info', 'Punktid on sulle märgitud kaardile!')
--                                 SetNewWaypoint(response.x, response.y)   
--                             else
--                                 TriggerEvent('KKF.UI.ShowNotification', 'error', 'Pidage natuke pausi!')
--                             end
--                         end, k)
--                     end
--                 },

--                 {
--                     name = 'dealerNpc',
--                     distance = 1.5,
--                     icon = 'fa-solid fa-user',
--                     label = 'Räägi',
--                     canInteract = function()
--                         return isGangFaction(PlayerData.job.name) and lib.callback.await('kk-factions:getReputation', false, k) > cfg.dealerReputation and PlayerData.job.permissions.dealerExchange
--                     end,
--                     onSelect = function()
--                         lib.callback('kk-factions:recieveContract', false, function(response)
--                             if response then
--                                 local needs = {}
--                                 local recieve = {}
    
--                                 for k,v in pairs(response.needs) do
--                                     needs[#needs + 1] = {label = items[k].label, value = v}
--                                 end
    
--                                 for k,v in pairs(response.recieve) do
--                                     recieve[#recieve + 1] = {label = items[k].label, value = v}
--                                 end
    
--                                 local elements = {
--                                     {
--                                         icon = 'fa-solid fa-hand',
--                                         title = 'Too mulle',
--                                         metadata = needs,
--                                         arrow = true
--                                     },
    
--                                     {
--                                         icon = 'fa-solid fa-hand-holding-hand',
--                                         title = 'Saad vastu',
--                                         metadata = recieve,
--                                         arrow = true
--                                     },
    
--                                     {
--                                         icon = 'fa-solid fa-right-left',
--                                         title = 'Vaheta',
--                                         event = 'kk-factions:client:exchangeItems'
--                                     }
--                                 }
                        
--                                 lib.registerContext({
--                                     id = 'gang_dealer',
--                                     title = 'Diiler',
--                                     options = elements
--                                 })
                        
--                                 lib.showContext('gang_dealer')
--                             else
--                                 TriggerEvent('KKF.UI.ShowNotification', 'error', 'Pidage natuke pausi!')
--                             end
--                         end, k)
--                     end
--                 }
--             })
    
--             peds[#peds + 1] = ped
--         end

--         lib.callback('kk-factions:contrabandLocations', false, function(contrabandTakePeds, contrabandGivePeds)
--             for k,v in pairs(contrabandTakePeds) do
--                 exports['kk-scripts']:requestModel(v.model)
--                 local ped = CreatePed(4, v.model, vec3(v.coords.x, v.coords.y, v.coords.z - 1), v.coords.w, false, false)

--                 SetBlockingOfNonTemporaryEvents(ped, true)
--                 SetPedDiesWhenInjured(ped, false)
--                 SetPedCanPlayAmbientAnims(ped, true)
--                 SetPedCanRagdollFromPlayerImpact(ped, false)
--                 SetEntityInvincible(ped, true)
--                 FreezeEntityPosition(ped, true)

--                 exports.ox_target:addLocalEntity(ped, {
--                     {
--                         name = 'pick_pack',
--                         icon = 'fa-solid fa-hand',
--                         label = 'Võta kaupa',
--                         distance = 1.5,
    
--                         canInteract = function()
--                             return not hasPackage and lib.callback.await('kk-factions:checkTakePed', false, k)
--                         end,
    
--                         onSelect = function(args)
--                             local contraData = lib.callback.await('kk-factions:recieveContrabandData', false)
    
--                             if contraData then
--                                 if contraData.taken <= cfg.contrabandCount - 1 then
--                                     local progress = exports['kk-taskbar']:startAction('talk', 'Suhtled...', 5000, 'actor_berating_loop', 'misscarsteal4@actor', {car = true, move = true, comat = true, cuff = false, falling = false, ragdoll = false, dead = false})
    
--                                     if progress then
--                                         if lib.callback.await('kk-factions:givePackage', false) then
--                                             local count = lib.callback.await('kk-factions:addTaken', false)
    
--                                             if count == cfg.contrabandCount then
--                                                 TriggerEvent('KKF.UI.ShowNotification', 'info', 'Liigu tarnepunkti!')
--                                             end
--                                         else
--                                             TriggerEvent('KKF.UI.ShowNotification', 'error', 'Sul ei ole võimalik rohkem kanda!')
--                                         end
--                                     end
--                                 else
--                                     TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ära ole ahne, Pets!?')
--                                 end
--                             else
--                                 TriggerEvent('kk-factions:client:removeContraband')
--                             end
--                         end
--                     }
--                 })

--                 peds[#peds + 1] = ped
--             end

--             for k,v in pairs(contrabandGivePeds) do
--                 exports['kk-scripts']:requestModel(v.model)
--                 local ped = CreatePed(4, v.model, vec3(v.coords.x, v.coords.y, v.coords.z - 1), v.coords.w, false, false)

--                 SetBlockingOfNonTemporaryEvents(ped, true)
--                 SetPedDiesWhenInjured(ped, false)
--                 SetPedCanPlayAmbientAnims(ped, true)
--                 SetPedCanRagdollFromPlayerImpact(ped, false)
--                 SetEntityInvincible(ped, true)
--                 FreezeEntityPosition(ped, true)

--                 exports.ox_target:addLocalEntity(ped, {
--                     {
--                         name = 'give_pack',
--                         icon = 'fa-solid fa-hand',
--                         label = 'Anna kaupa',
--                         distance = 1.5,
    
--                         canInteract = function()
--                             local canInteract = hasPackage and lib.callback.await('kk-factions:checkGivePed', false, k)
--                             return canInteract
--                         end,
    
--                         onSelect = function(args)
--                             local progress = exports['kk-taskbar']:startAction('talk', 'Suhtled...', 5000, 'actor_berating_loop', 'misscarsteal4@actor', {car = true, move = true, comat = true, cuff = false, falling = false, ragdoll = false, dead = false})
    
--                             if progress then
--                                 local contraData = lib.callback.await('kk-factions:recieveContrabandData', false)
    
--                                 if contraData then
--                                     if contraData.given < cfg.contrabandCount then
--                                         if exports.ox_inventory:Search('count', 'package_gang') > 0 then
--                                             TriggerServerEvent('KARU:misc:removeItem', 'package_gang', 1)
--                                             local count = lib.callback.await('kk-factions:addGiven', false)
    
--                                             if count == cfg.contrabandCount then
--                                                 lib.callback.await('kk-factions:packageDone', false, count)
--                                             end
--                                         else
--                                             TriggerEvent('KKF.UI.ShowNotification', 'error', 'Tont, kus pakk on!?')
--                                         end
--                                     else
--                                         TriggerEvent('KKF.UI.ShowNotification', 'error', 'Rohkem pakke ju ei ole!?')
--                                     end
--                                 else
--                                     TriggerEvent('kk-factions:client:removeContraband')
--                                 end
--                             end
--                         end
--                     }
--                 })

--                 peds[#peds + 1] = ped
--             end
--         end)
--     end)
-- end

-- local function deRegisterPeds()
--     for k,v in pairs(peds) do
--         exports.ox_target:removeLocalEntity(v, {'dealerNpc', 'contrabandNpc', 'pick_pack', 'give_pack'})
--         DeletePed(v); peds[k] = nil
--     end
-- end

-- RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
--     PlayerData = QBCore.Functions.GetPlayerData()
--     registerPeds() 
-- end)

-- RegisterNetEvent('QBCore:Client:OnPlayerUnload', function() 
--     PlayerData = {}
--     deRegisterPeds()
--     TriggerEvent('kk-factions:client:removeContraband') 
-- end)
