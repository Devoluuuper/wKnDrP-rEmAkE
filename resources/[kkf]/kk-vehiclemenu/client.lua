local mapOpend, menuOpen = false, false
local windowStates = {
    [1] = true,
    [2] = true,
    [3] = true,
    [4] = true
}

CreateThread(function()
	while true do
        if IsPauseMenuActive() and not mapOpend then
            mapOpend = true
            SendNUIMessage({action = "hide"});
        elseif not IsPauseMenuActive() and mapOpend then
            mapOpend = false
            SendNUIMessage({action = "show"});
        end

		Wait(800)
	end
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
    
            DisablePlayerFiring(PlayerPedId(), true)
        end
    end)
end

RegisterNUICallback('disableFocus', function()
    SetNuiFocus(false, false); SetTimeout(100, function() menuOpen = false end); SetNuiFocusKeepInput(false)
end)

local function switchSeat(seat)
    if IsVehicleSeatFree(cache.vehicle, seat) then
        local progress = exports['kk-taskbar']:startAction('seat_' .. seat, 'Vahetad istekohta', 2000, false, false, {freeze = false, controls = true})

        if progress then
            SetPedIntoVehicle(cache.ped, cache.vehicle, seat)
        end
    end
end

local function windowAction(window)
    if windowStates[window] and DoesVehicleHaveDoor(cache.vehicle, window - 1) then
        RollDownWindow(cache.vehicle, window - 1); windowStates[window] = false
    else
        RollUpWindow(cache.vehicle, window - 1); windowStates[window] = true
    end
end

local function doorAction(door)
    if GetVehicleDoorAngleRatio(cache.vehicle, door) > 0.0 then
        SetVehicleDoorShut(cache.vehicle, door, false)
    else
        SetVehicleDoorOpen(cache.vehicle, door, false)
    end
end

RegisterNUICallback('menuAction', function(args)
    if cache.vehicle then
        if args.action == 'ignition' then
            ExecuteCommand('engine')
        elseif args.action == 'interiorLight' then
            if IsVehicleInteriorLightOn(cache.vehicle) then
                SetVehicleInteriorlight(cache.vehicle, false)
            else
                SetVehicleInteriorlight(cache.vehicle, true)
            end
        elseif args.action == 'windowFrontLeft' then 
            windowAction(1)
        elseif args.action == 'windowFrontRight' then
            windowAction(2)
        elseif args.action == 'windowRearLeft' then
            windowAction(3)
        elseif args.action == 'windowRearRight' then
            windowAction(4)
        elseif args.action == 'doorFrontLeft' then 
            doorAction(0)
        elseif args.action == 'doorFrontRight' then 
            doorAction(1)
        elseif args.action == 'doorRearLeft' then
            doorAction(2)
        elseif args.action == 'doorRearRight' then
            doorAction(3)
        elseif args.action == 'frontHood' then
            doorAction(4)
        elseif args.action == 'rearHood' then
            doorAction(5)
        elseif args.action == 'rearHood2' then
            doorAction(6)
        elseif args.action == 'seatFrontLeft' then
            switchSeat(-1)
        elseif args.action == 'seatFrontRight' then
            switchSeat(0)
        elseif args.action == 'seatRearLeft' then
            switchSeat(1)
        elseif args.action == 'seatRearRight' then
            switchSeat(2)
        end
    end
end)

RegisterNetEvent('kk-vehiclemenu:client:openMenu', function()
    if cache.vehicle then
        if not menuOpen then
            SendNUIMessage({action = 'openMenu'}); 
            SetNuiFocus(true, true); menuOpen = true; 
            SetNuiFocusKeepInput(true); disableActions() 
        else
            SendNUIMessage({action = "closeMenu"}); SetNuiFocus(false, false); menuOpen = false; SetNuiFocusKeepInput(false)
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		wait = 100

		if cache.vehicle then
			SetPedConfigFlag(cache.ped, 184, true)

			if GetIsTaskActive(cache.ped, 165) then
				SetPedIntoVehicle(cache.ped, cache.vehicle, cache.seat)
			end
        else
            wait = 500
		end

        Wait(wait)
	end
end)