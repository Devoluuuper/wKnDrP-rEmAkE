local warnedshooting, menuOpen, mapOpend = false, false, false

CreateThread(function()
	while true do
        if IsPauseMenuActive() and not mapOpend then
            mapOpend = true
            SendNUIMessage({action = 'closeDispatch'})
        elseif not IsPauseMenuActive() and mapOpend then
            mapOpend = false
        end

		Wait(800)
	end
end)

CreateThread(function()
    KKF.PlayerData = KKF.GetPlayerData()
end)

RegisterNetEvent('KKF.Player.Loaded', function(xPlayer)
	KKF.PlayerData = xPlayer
end)

RegisterNetEvent('KKF.Player.Unloaded', function()
	KKF.PlayerData = {}
end)

RegisterNetEvent('KKF.Player.JobUpdate', function(job)
	KKF.PlayerData.job = job

    if not KKF.PlayerData.job.onDuty then
        SendNUIMessage({action = 'closeDispatch'})
    end
end) 

RegisterNetEvent('KKF.Player.DutyChange', function(value)
	KKF.PlayerData.job.onDuty = value

    if not KKF.PlayerData.job.onDuty then
        SendNUIMessage({action = 'closeDispatch'})
    end
end)

RegisterNetEvent('kk-dispatch:client:setMarker', function(coords)
    SetNewWaypoint(coords.x, coords.y)
end)

RegisterNetEvent('kk-dispatch:client:sendAlert', function(data)
    SendNUIMessage({action = 'addCall', data = data})

    if not data.panic then
        PlaySound(-1, "Event_Message_Purple", "GTAO_FM_Events_Soundset", 0, 0, 1)
    end
end)

local function disableInputs()
    CreateThread(function()
        while menuOpen do
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 24, true) -- Attack
            DisableControlAction(0, 257, true) -- Attack 2
            DisableControlAction(0, 25, true) -- Aim
            DisableControlAction(0, 263, true) -- Melee Attack 1

            DisableControlAction(0, 45, true) -- Reload
            DisableControlAction(0, 21, true) -- left shift
            DisableControlAction(0, 22, true) -- Jump
            DisableControlAction(0, 44, true) -- Cover
            DisableControlAction(0, 37, true) -- Select Weapon

            DisableControlAction(0, 288,  true) -- Disable phone
            DisableControlAction(0, 245,  true) -- Disable chat
            DisableControlAction(0, 289, true) -- Inventory
            DisableControlAction(0, 170, true) -- Animations
            DisableControlAction(0, 167, true) -- Job
            DisableControlAction(0, 244, true) -- Ragdoll
            DisableControlAction(0, 303, true) -- Car lock

            DisableControlAction(0, 29, true) -- B ile işaret
            DisableControlAction(0, 81, true) -- B ile işaret
            DisableControlAction(0, 26, true) -- Disable looking behind
            DisableControlAction(0, 73, true) -- Disable clearing animation
            DisableControlAction(2, 199, true) -- Disable pause screen

            -- DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
            -- DisableControlAction(0, 72, true) -- Disable reversing in vehicle

            DisableControlAction(2, 36, true) -- Disable going stealth

            DisableControlAction(0, 47, true)  -- Disable weapon
            DisableControlAction(0, 264, true) -- Disable melee
            DisableControlAction(0, 257, true) -- Disable melee
            DisableControlAction(0, 140, true) -- Disable melee
            DisableControlAction(0, 141, true) -- Disable melee
            DisableControlAction(0, 142, true) -- Disable melee

            if cache.vehicle then
                DisableControlAction(0, 75, true) -- disable SCROLLWHEEL UP key
            end

            DisablePlayerFiring(cache.ped, true) -- Disable weapon firing
    
            Wait(0)
        end
    end)
end

RegisterCommand('openDispatch', function()
    if KKF.PlayerData.job.type == 'illegal' then return end
    if not LocalPlayer.state['isLoggedIn'] then return end

    if KKF.PlayerData.job.onDuty and not exports['kk-phone']:canInteract() then
        if not menuOpen then
            KKF.ShowInteraction('Sulge dispatch', 'Z')
            SendNUIMessage({action = 'showCalls'}); SetNuiFocus(true, true);  SetNuiFocusKeepInput(true); menuOpen = true; disableInputs()
        else
            SendNUIMessage({action = 'closeDispatch'})
        end
    end
end, false)

RegisterKeyMapping('openDispatch', 'Ava dispetser', 'keyboard', 'Z')

RegisterNUICallback('closeDispatch', function()
    SetNuiFocus(false, false); SetNuiFocusKeepInput(false); menuOpen = false; KKF.HideInteraction()
end)

RegisterNUICallback('loadCalls', function(args, cb)
    lib.callback('kk-dispatch:loadCalls', false, function(response)
        SendNUIMessage({action = 'loadCalls', data = response})
    end)
end)

RegisterNUICallback('acceptCall', function(args, cb)
    TriggerServerEvent('kk-dispatch:server:acceptCall', args.id); SendNUIMessage({action = 'closeDispatch'})
end)

RegisterNetEvent('kk-dispatch:client:sendDispatch', function(call, job, message, panic, answer)
    local playerCoords = GetEntityCoords(cache.ped)
    local street = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
    local zone = GetNameOfZone(playerCoords)

    local data = {
        street = GetStreetNameFromHashKey(street),
        coords = playerCoords,
        zone = GetLabelText(zone),
        message = message,
        call = call,
        panic = panic
    }

    if answer then
        data['answer'] = GetPlayerServerId(PlayerId())
    end

    TriggerServerEvent('kk-dispatch:server:alert', job, data)
end)

RegisterNetEvent('kk-dispatch:client:showResponder', function(data)
    SendNUIMessage({action = 'addResponder', data = data})
end)

CreateThread(function()
    while true do
        if not warnedshooting and IsPedShooting(cache.ped) and not IsPedCurrentWeaponSilenced(cache.ped) then
            if KKF.PlayerData.job.name == 'police' and KKF.PlayerData.job.onDuty then return end

            local jobName = 'police' -- Here you can put every job what has been registered by KKF.
            local code = '10-71'
            local message = 'TULISTAMINE' -- Here you can put a message that will be shown to people with job above.
            
            TriggerEvent('kk-dispatch:client:sendDispatch', code, jobName, message)

            warnedshooting = true
            SetTimeout(60000, function() warnedshooting = false end)
        end

        Wait(100)
    end
end)