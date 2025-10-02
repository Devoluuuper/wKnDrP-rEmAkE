local function stopEscort(serverId)
    TriggerServerEvent('kk-police:server:setEscort', serverId, false)
    StopAnimTask(cache.ped, "amb@world_human_drinking@coffee@female@base", "base", 2.0)
end

RegisterNetEvent('kk-police:client:stopEscort', stopEscort)

local function escortPlayer(ped, id)
    lib.requestAnimDict("amb@world_human_drinking@coffee@female@base")
    TaskPlayAnim(cache.ped, "amb@world_human_drinking@coffee@female@base", "base", 8.0, 8.0, -1, 50, 0, false, false, false)

    if not id then
        id = NetworkGetPlayerIndexFromPed(ped)
    end

    local serverId = GetPlayerServerId(id)

    TriggerServerEvent('kk-police:server:setEscort', serverId, not IsEntityAttachedToEntity(ped, cache.ped))
end

exports.ox_target:addGlobalPlayer({
    {
        name = 'escortPlayer',
		icon = 'fa-solid fa-hand',
		label = 'Eskordi',
        distance = 1.5,
        canInteract = function(entity)
			local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)) or 0

			return (Player(targetId).state.isDead or Player(targetId).state.isCuffed ~= 'none') and not cache.vehicle and ((KKF.PlayerData.job.name == 'police' or KKF.PlayerData.job.name == 'ambulance') and KKF.PlayerData.job.onDuty) and not IsEntityAttachedToEntity(entity, cache.ped)
        end,
        onSelect = function(data)
            escortPlayer(data.entity)
        end
    },

    {
        name = 'releaseEscort',
        icon = 'fa-solid fa-hand',
        label = 'Vabasta eskordist',
        distance = 1.5,
        canInteract = function(entity)
			local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)) or 0

			return (Player(targetId).state.isDead or Player(targetId).state.isCuffed ~= 'none') and not cache.vehicle and ((KKF.PlayerData.job.name == 'police' or KKF.PlayerData.job.name == 'ambulance') and KKF.PlayerData.job.onDuty) and IsEntityAttachedToEntity(entity, cache.ped)
        end,
        onSelect = function(data)
            stopEscort(GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity)))
        end
    }
})

local isEscorted = LocalPlayer.state.isEscorted

local function setEscorted(serverId)
    local dict = 'anim@move_m@prisoner_cuffed'
    local dict2 = 'anim@move_m@trash'

    while isEscorted do
        local player = GetPlayerFromServerId(serverId)
        local ped = player > 0 and GetPlayerPed(player)

        if not ped then break end

        if not IsEntityAttachedToEntity(cache.ped, ped) then
            AttachEntityToEntity(cache.ped, ped, 11816, 0.38, 0.4, 0.0, 0.0, 0.0, 0.0, false, false, true, true, 2, true)
        end

        if IsPedWalking(ped) then
            if not IsEntityPlayingAnim(cache.ped, dict, 'walk', 3) then
                lib.requestAnimDict(dict)
                TaskPlayAnim(cache.ped, dict, 'walk', 8.0, -8, -1, 1, 0.0, false, false, false)
            end
        elseif IsPedRunning(ped) or IsPedSprinting(ped) then
            if not IsEntityPlayingAnim(cache.ped, dict2, 'run', 3) then
                lib.requestAnimDict(dict2)
                TaskPlayAnim(cache.ped, dict2, 'run', 8.0, -8, -1, 1, 0.0, false, false, false)
            end
        else
            StopAnimTask(cache.ped, dict, 'walk', -8.0)
            StopAnimTask(cache.ped, dict2, 'run', -8.0)
        end

        Wait(0)
    end

    RemoveAnimDict(dict)
    RemoveAnimDict(dict2)
    LocalPlayer.state:set('isEscorted', false, true)

    if LocalPlayer.state.isDead then
        lib.requestAnimDict('dead')
        TaskPlayAnim(cache.ped, 'dead', 'dead_a', 8.0, 8.0, -1, 33, 0, 0, 0, 0)    
    end
end

AddStateBagChangeHandler('isEscorted', ('player:%s'):format(cache.serverId), function(_, _, value)
    isEscorted = value

    if IsEntityAttached(cache.ped) then
        DetachEntity(cache.ped, true, false)
        StopAnimTask(cache.ped, 'anim@move_m@prisoner_cuffed', 'walk', -8.0)
        StopAnimTask(cache.ped, 'anim@move_m@trash', 'run', -8.0)
    end

    if value then setEscorted(value) end
end)

RegisterNetEvent('kk-ambulance:revive', function()
    if isEscorted then
        stopEscort(cache.serverId)
    end
end)

if isEscorted then
    CreateThread(function()
        setEscorted(isEscorted)
    end)
end