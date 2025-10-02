local mapOpend, menuOpen = false, false
local cooldown = false

CreateThread(function()
	while true do
        if IsPauseMenuActive() and not mapOpend then
            mapOpend = true
            SendNUIMessage({action = 'hide'});
        elseif not IsPauseMenuActive() and mapOpend then
            mapOpend = false
            SendNUIMessage({action = 'show'});
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
end)

RegisterNetEvent('KKF.Player.DutyChange', function(value)
	KKF.PlayerData.job.onDuty = value
end)

local function disableActions()
    CreateThread(function()
        while menuOpen do
            Wait(0)
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 263, true)
            DisableControlAction(0, 264, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 143, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 47, true)
            DisableControlAction(0, 58, true)
            DisableControlAction(0, 177, true)
    
            DisableControlAction(0, 19, true)
            DisableControlAction(0, 245, true)
            DisableControlAction(0, 200, true)
            DisableControlAction(0, 81, true)
            DisableControlAction(0, 82, true)
            DisableControlAction(0, 157, true)
            DisableControlAction(0, 158, true)
            DisableControlAction(0, 160, true)
            DisableControlAction(0, 164, true)

            DisableControlAction(0, 75, true)
    
            DisablePlayerFiring(PlayerPedId(), true)
        end
    end)
end

RegisterNUICallback('disableFocus', function()
    SetNuiFocus(false, false); SetTimeout(100, function() menuOpen = false end); SetNuiFocusKeepInput(false)
end)

RegisterNUICallback('menuAction', function(args)
    if cache.vehicle and cache.seat == 0 and not cooldown then
        cooldown = true
        SetTimeout(5000, function() cooldown = false end)
        TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 30.0, args.action, 0.6)
    end
end)

RegisterNetEvent('kk-policesounds:client:openMenu', function()
    if KKF.PlayerData.job.name == 'police' and KKF.PlayerData.job.onDuty then
        lib.callback('kk-society:factionOwned', false, function(response)
            if response then
                if cache.vehicle and cache.seat == 0 then
                    if not menuOpen then
                        SendNUIMessage({action = 'openMenu'})
                        SetNuiFocus(true, true); menuOpen = true
                        SetNuiFocusKeepInput(true); disableActions()
                    else
                        SendNUIMessage({action = 'closeMenu'}); SetNuiFocus(false, false); menuOpen = false; SetNuiFocusKeepInput(false)
                    end
                end
            else
                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Antud sõiduk ei kuulu teie fraktsiooni.')
            end
        end, GetVehicleNumberPlateText(cache.vehicle))
    end
end)

RegisterCommand('mp', function()
    TriggerEvent('kk-policesounds:client:openMenu')
end)

TriggerEvent('chat:addSuggestion', '/mp', 'Megaphone.')