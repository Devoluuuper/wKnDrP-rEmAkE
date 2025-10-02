cfg = {}

local function distanceCheck(bank, taskId)
    CreateThread(function()
        while cfg.bankLocations[bank].tasks[taskId].done do
            local currentBank = cfg.bankLocations[bank]
            local distance = #(GetEntityCoords(cache.ped) - currentBank.pos)
    
            if distance >= currentBank.radius then
                TriggerServerEvent('kk-bankrobbery:server:endRobbery', bank)
    
                break
            end
    
            Wait(2500)
        end
    end)
end

local function tasksDone(bank)
    local count = 0

    for k,v in pairs(cfg.bankLocations[bank].tasks) do
        if v.done and v.type ~= 'hack' and v.type ~= 'bomb' then count += 1 end
    end

    return count
end

local function toDoTasks(bank)
    local count = 0

    for k,v in pairs(cfg.bankLocations[bank].tasks) do
        if v.type == 'drill' then count += 1 end
    end

    return count
end

CreateThread(function()
    lib.callback('kk-bankrobbery:fetchLocations', false, function(locations)
        cfg.bankLocations = locations

        for k,v in pairs(cfg.bankLocations) do
            if v.tasks then
                for k2,v2 in pairs(v.tasks) do
                    CreateThread(function()
                        local point = lib.points.new(v2.pos, 0.5, {bank = k, taskId = k2, type = v2.type})
        
                        function point:onEnter()
                            if self.type == 'hack' then
                                KKF.ShowInteraction('Alusta häkkimisega', 'E')
                            elseif self.type == 'drill' then
                                KKF.ShowInteraction('Alusta puurimisega', 'E')
                            elseif self.type == 'bomb' then
                                KKF.ShowInteraction('Alusta pommi paigaldamisega', 'E')
                            elseif self.type == 'collect' then
                                KKF.ShowInteraction('Korja raha','E')
                            end
                        end
                        
                        function point:onExit()
                            KKF.HideInteraction()
                        end
                        
                        function point:nearby()
                            if self.currentDistance < 0.5 and IsControlJustReleased(0, 38) then
                                if not cache.vehicle then
                                    lib.callback('kk-bankrobbery:tryTask', false, function(response)
                                        if response then
                                            if self.type == 'hack' then
                                                local currentTask = cfg.bankLocations[self.bank].tasks[self.taskId]

                                                lib.callback('kk-robberies:checkGlobal', false, function(status)
                                                    if not status then
                                                        lib.callback('KKF.Item.Amount', false, function(qtty)
                                                            if qtty > 0 then
                                                                lib.callback('kk-society:getOnlineMembers', false, function(qtty)
                                                                    if qtty >= cfg.bankLocations[self.bank].policeRequired then
                                                                        exports.hacking:OpenHackingGame(function(outcome)
                                                                            if outcome then 
                                                                                lib.callback.await('kk-bankrobbery:taskDone', false, self.bank, self.taskId)
                                                                                distanceCheck(self.bank, self.taskId)
                                                                            else
                                                                                TriggerEvent('KKF.UI.ShowNotification','error', 'Te ei saanud häkkimisega hakkama!')
                                                                                TriggerServerEvent('kk-bankrobbery:server:taskReset', self.bank, self.taskId)
                                                                            end
                                                                        end)
                                                                    else
                                                                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Linnas ei ole piisavalt politseinikke.')
                                                                        TriggerServerEvent('kk-bankrobbery:server:taskReset', self.bank, self.taskId)
                                                                    end
                                                                end, 'police')
                                                            else
                                                                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil ei ole tahvelarvutit.')
                                                                TriggerServerEvent('kk-bankrobbery:server:taskReset', self.bank, self.taskId)
                                                            end
                                                        end, currentTask.item)
                                                    else
                                                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Hetkel ei saa selle tegevusega jätkata!')
                                                        TriggerServerEvent('kk-bankrobbery:server:taskReset', self.bank, self.taskId)
                                                    end
                                                end)
                                            elseif self.type == 'drill' then
                                                local currentTask = cfg.bankLocations[self.bank].tasks[self.taskId]

                                                lib.callback('KKF.Item.Amount', false, function(qtty)
                                                    if qtty > 0 then
                                                        local chance = math.random(1, 100)
                                                        local moneyBag = nil
                                                        local drill = {
                                                            entity = nil,
                                                            sound = nil
                                                        }
                                        
                                                        FreezeEntityPosition(cache.ped, true)
                                        
                                                        lib.requestAnimDict('anim@heists@fleeca_bank@drilling')
                                                        TaskPlayAnim(cache.ped, 'anim@heists@fleeca_bank@drilling', 'drill_straight_idle', 8.0, 8.0, -1, 50, 0, false, false, false)

                                                        RequestAmbientAudioBank('DLC_HEIST_FLEECA_SOUNDSET', 0)
                                                        RequestAmbientAudioBank('DLC_MPHEIST\\HEIST_FLEECA_DRILL', 0)
                                                        RequestAmbientAudioBank('DLC_MPHEIST\\HEIST_FLEECA_DRILL_2', 0)
                                        
                                                        lib.callback('KKF.Entity.SpawnObject', false, function(networkId)
                                                            if networkId then
                                                                while not NetworkDoesEntityExistWithNetworkId(networkId) do
                                                                    Wait(10)
                                                                end
                                        
                                                                drill.entity = NetworkGetEntityFromNetworkId(networkId)
                                        
                                                                SetEntityCollision(drill.entity, false, false)
                                                                AttachEntityToEntity(drill.entity, cache.ped, GetPedBoneIndex(cache.ped, 28422), vector3(0,0,0), vector3(0,0,0), false, true, false, false, 0, true)
                                                                drill.sound = GetSoundId()
                                        
                                                                PlaySoundFromEntity(drill.sound, 'Drill', drill.entity, 'DLC_HEIST_FLEECA_SOUNDSET', 1, 0)
                                        
                                                                TriggerEvent('Drilling:Start',function(success)
                                                                    if success then
                                                                        TriggerEvent('KKF.UI.ShowNotification', 'success', 'Said kapi lahti.'); ClearPedTasks(cache.ped)
                                                                        Wait(500)
                                                
                                                                        lib.callback('KKF.Entity.SpawnObject', false, function(networkId)
                                                                            if networkId then
                                                                                while not NetworkDoesEntityExistWithNetworkId(networkId) do
                                                                                    Wait(10)
                                                                                end
                                                                
                                                                                moneyBag = NetworkGetEntityFromNetworkId(networkId)
                                                                
                                                                                SetEntityCollision(moneyBag, false, false)
                                                                                AttachEntityToEntity(moneyBag, cache.ped, GetPedBoneIndex(cache.ped, 57005), vector3(0.0, 0.0, -0.16), vector3(250.0, -30.0, 0.0), false, true, false, false, 0, true)
                                                                            end
                                                                        end, 'prop_cs_heist_bag_02', GetEntityCoords(cache.ped), GetEntityHeading(cache.ped))

                                                                        CreateThread(function()
                                                                            local progress = exports['kk-taskbar']:startAction('uptake', 'Kogud asju', 25000, 'grab', 'anim@heists@ornate_bank@grab_cash_heels', {freeze = true, controls = true})

                                                                            if progress then
                                                                                lib.callback.await('kk-bankrobbery:taskDone', false, self.bank, self.taskId)
                                                                                DetachEntity(moneyBag, cache.ped); DeleteEntity(moneyBag); moneyBag = nil
                                                                            else
                                                                                TriggerServerEvent('kk-bankrobbery:server:taskReset', self.bank, self.taskId)
                                                                                DetachEntity(moneyBag, cache.ped); DeleteEntity(moneyBag); moneyBag = nil
                                                                            end
                                                                        end)
                                                                    else
                                                                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ebaõnnestusid puurimisel.')
                                                                        FreezeEntityPosition(cache.ped, false)
                                                                        TriggerServerEvent('kk-bankrobbery:server:taskReset', self.bank, self.taskId)
                                                                        ClearPedTasksImmediately(cache.ped)
                                                                    end

                                                                    if chance > 80 then TriggerServerEvent('KKF.Player.RemoveItem', 'drill', 1) end
                                                                    DetachEntity(drill.entity, cache.ped); DeleteEntity(drill.entity); drill.entity = nil
                                                                    StopSound(drill.sound); ReleaseSoundId(drill.sound); 
                                                                end)
                                                            end
                                                        end, 'hei_prop_heist_drill', GetEntityCoords(cache.ped), GetEntityHeading(cache.ped))
                                                    else
                                                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil ei ole trelli.')
                                                        TriggerServerEvent('kk-bankrobbery:server:taskReset', self.bank, self.taskId)
                                                    end
                                                end, currentTask.item)
                                            elseif self.type == 'bomb' then
                                                local currentTask = cfg.bankLocations[self.bank].tasks[self.taskId]

                                                lib.callback('KKF.Item.Amount', false, function(qtty)
                                                    if qtty > 0 then
                                                        local progress = exports['kk-taskbar']:startAction('bomb_placing', 'Paigaldad pommi', 10000, 'CODE_HUMAN_MEDIC_KNEEL', false, {freeze = true, controls = true})

                                                        if progress then
                                                            lib.callback.await('kk-bankrobbery:taskDone', false, self.bank, self.taskId)
                                                            TriggerEvent('KKF.UI.ShowNotification', 'info', 'Pomm plahvatab 10 sekundi pärast.')
                                                        else
                                                            TriggerServerEvent('kk-bankrobbery:server:taskReset', self.bank, self.taskId)
                                                        end
                                                    else
                                                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil ei ole pommi.')
                                                        TriggerServerEvent('kk-bankrobbery:server:taskReset', self.bank, self.taskId)
                                                    end
                                                end, currentTask.item)
                                            elseif self.type == 'collect' then
                                                if tasksDone(self.bank) >= toDoTasks(self.bank) then
                                                    local moneyBag = nil

                                                    lib.callback('KKF.Entity.SpawnObject', false, function(networkId)
                                                        if networkId then
                                                            while not NetworkDoesEntityExistWithNetworkId(networkId) do
                                                                Wait(10)
                                                            end
                                            
                                                            moneyBag = NetworkGetEntityFromNetworkId(networkId)
                                            
                                                            SetEntityCollision(moneyBag, false, false)
                                                            AttachEntityToEntity(moneyBag, cache.ped, GetPedBoneIndex(cache.ped, 57005), vector3(0.0, 0.0, -0.16), vector3(250.0, -30.0, 0.0), false, true, false, false, 0, true)
                                                        end
                                                    end, 'prop_cs_heist_bag_02', GetEntityCoords(cache.ped), GetEntityHeading(cache.ped))
                                            
                                                    local progress = exports['kk-taskbar']:startAction('cash', 'Korjad raha', 15000, 'grab', 'anim@heists@ornate_bank@grab_cash_heels', {freeze = true, controls = true})
                                            
                                                    if progress then
                                                        lib.callback.await('kk-bankrobbery:taskDone', false, self.bank, self.taskId)
                                                        DetachEntity(moneyBag, cache.ped); DeleteEntity(moneyBag); moneyBag = nil
                                                    else
                                                        TriggerServerEvent('kk-bankrobbery:server:taskReset', self.bank, self.taskId)
                                                        DetachEntity(moneyBag, cache.ped); DeleteEntity(moneyBag); moneyBag = nil
                                                    end
                                                else
                                                    TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ei saa hetkel raha korjata!')
                                                    TriggerServerEvent('kk-bankrobbery:server:taskReset', self.bank, self.taskId)
                                                end
                                            end
                                        else
                                            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ei saa hetkel seda tegevust sooritada!')
                                        end
                                    end, self.bank, self.taskId)
                                end
                            end
                        end
                    end)
                end
            end
        end
    end)
end)

RegisterNetEvent('kk-bankrobbery:client:reloadBanks', function(data)
    cfg.bankLocations = data
end)

RegisterNetEvent('kk-bankrobbery:client:setDoorHeading', function(coords, type)
	local entity = GetClosestObjectOfType(coords, 5.0, GetHashKey(type), false)

    if DoesEntityExist(entity) then
	    SetEntityHeading(entity, GetEntityHeading(entity) + 90.2869)
    end
end)

RegisterNetEvent('kk-bankrobbery:client:explodeBomb', function(coords, type)
    local entity = GetClosestObjectOfType(coords, 5.0, GetHashKey(type), false)

    if DoesEntityExist(entity) then
        local pos = GetEntityCoords(cache.ped)
        local dist = #(pos - coords)

        if dist < 30 then
            AddExplosion(coords, 0, 0.5, 1, 0, 1065353216, 0)
            Wait(500)
            AddExplosion(coords, 0, 0.5, 1, 0, 1065353216, 0)
        end

        SetEntityHeading(entity, GetEntityHeading(obs) + 47.2869)
    end
end)