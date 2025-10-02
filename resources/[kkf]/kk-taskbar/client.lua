local actionInProgress = false
local controlsDisabled = false
local mapOpend = false
local currentAction = {}

local returnable = nil
local callback = nil

local function canInteract() -- exports['kk-taskbar']:canInteract()
	return actionInProgress
end

exports('canInteract', canInteract)

RegisterNUICallback('actionDone', function(args, cb)
	SetTimeout(100, function()
		if callback then
			callback(true);
		else
			returnable = true
		end
		
		if currentAction.clip and not currentAction.disableClearTasks then ClearPedTasks(cache.ped) end
		if currentAction.freeze then FreezeEntityPosition(cache.ped, false) end
		if currentAction.controls then controlsDisabled = false end
	
		currentAction = {}; actionInProgress = false; 
		
		if not LocalPlayer.state.isDead then
			LocalPlayer.state:set('invBusy', false, true)
		end
	end)
end)

-- Shitty loops
Citizen.CreateThread(function()
	while true do
		wait = 0

		if controlsDisabled then
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1
			DisableControlAction(0, 32, true) -- W
			DisableControlAction(0, 34, true) -- A
			DisableControlAction(0, 31, true) -- S
			DisableControlAction(0, 30, true) -- D
			DisableControlAction(0, 38, true) -- E
			DisableControlAction(0, 77, true) -- X

			DisableControlAction(0, 45, true) -- Reload
			DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 23, true) -- Also 'enter'?

			DisableControlAction(0, 288,  true) -- Disable phone
			DisableControlAction(0, 289, true) -- Inventory
			DisableControlAction(0, 170, true) -- Animations
			DisableControlAction(0, 167, true) -- Job

			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle

			DisableControlAction(2, 36, true) -- Disable going stealth

			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		else
			wait = 500
		end

		Wait(wait)
	end
end)

CreateThread(function()
	while true do
        if IsPauseMenuActive() and not mapOpend then
            mapOpend = true
            SendNUIMessage({type = "hide"});
        elseif not IsPauseMenuActive() and mapOpend then
            mapOpend = false
            SendNUIMessage({type = "show"});
        end

		Wait(800)
	end
end)

-- Funktsioonid
local function startAction(name, text, time, clip, dict, data, cb)
	if not actionInProgress then
		actionInProgress = true

		LocalPlayer.state:set('invBusy', true, true)
		TriggerEvent('ox_inventory:closeInventory')

		if text then
			if dict and clip then
				lib.requestAnimDict(dict)
				TaskPlayAnim(cache.ped, dict, clip, 8.0, 1.0, data.disableClearTasks and time or -1, 49, 0, 0, 0, 0)
			elseif not dict and clip then
				TaskStartScenarioInPlace(cache.ped, clip, 0, true)
			end

			if data.freeze then FreezeEntityPosition(cache.ped, true) end
			if data.controls then controlsDisabled = true end
			if data.disableCancel then currentAction['disableCancel'] = data.disableCancel end
			if data.disableClearTasks then currentAction['disableClearTasks'] = data.disableClearTasks end

			currentAction['clip'] = clip
			currentAction['freeze'] = data.freeze
			currentAction['controls'] = data.controls

			SendNUIMessage({type = 'ui', time = time, text = text})

			if cb then
				currentAction['cb'] = cb
			else
				returnable = nil

				while returnable == nil do
					Wait(50)
				end
				
				return returnable
			end
		end
	else
		TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ei saa kahe tegevusega korraga tegeleda.')
	end
end

exports('startAction', startAction)

local function cancelAction()
	if callback then
		callback(false);
	else
		returnable = false
	end

	if currentAction.clip and not currentAction.disableClearTasks then ClearPedTasks(cache.ped) end
	if currentAction.freeze then FreezeEntityPosition(cache.ped, false) end
	if currentAction.controls then controlsDisabled = false end

	SendNUIMessage({ type = 'cancel' })

	currentAction = {}
	actionInProgress = false
	
	if not LocalPlayer.state.isDead then
		LocalPlayer.state:set('invBusy', false, true)
	end
end

exports('cancelAction', cancelAction)

RegisterCommand('cancelAction', function()
	if actionInProgress then
		if not currentAction.disableCancel then
			if callback then
				callback(false);
			else
				returnable = false
			end

			if currentAction.clip and not currentAction.disableClearTasks then ClearPedTasks(cache.ped) end
			if currentAction.freeze then FreezeEntityPosition(cache.ped, false) end
			if currentAction.controls then controlsDisabled = false end

			SendNUIMessage({ type = 'cancel' })
			
			currentAction = {} 
			actionInProgress = false
			
			if not LocalPlayer.state.isDead then
				LocalPlayer.state:set('invBusy', false, true)
			end

			TriggerEvent('KKF.UI.ShowNotification', 'error', 'Katkestasite tegevuse!')
		end
	end
end)

AddStateBagChangeHandler('isDead', nil, function(bagName, key, value) 
    local player = GetPlayerFromStateBagName(bagName)

    if player == PlayerId() then 
        if value and actionInProgress then
            ExecuteCommand('cancelAction')
        end
	end
end)

RegisterKeyMapping('cancelAction', 'Katkesta tegevus.', 'keyboard', 'C')