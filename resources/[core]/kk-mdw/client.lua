local guiEnabled = false
local tablet = false
local tabletDict = "amb@code_human_in_bus_passenger_idles@female@tablet@base"
local tabletAnim = "base"
local tabletProp = `prop_cs_tablet`
local tabletBone = 60309
local tabletOffset = vector3(0.03, 0.002, -0.0)
local tabletRot = vector3(10.0, 160.0, 0.0)
local characterSelected = 0

local function canPunish(id)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(id)); local returnable = false
	local dist = #(GetEntityCoords(targetPed) - GetEntityCoords(cache.ped))

	if dist < 20.0 and id ~= 0 then
		returnable = true
	end

	return returnable
end

CreateThread(function() KKF.PlayerData = KKF.GetPlayerData() end)

RegisterNetEvent('KKF.Player.Loaded')
AddEventHandler('KKF.Player.Loaded', function(playerData)
    KKF.PlayerData = playerData
end)

RegisterNetEvent('KKF.Player.Unloaded', function() 
	KKF.PlayerData = {} 
end)

local function toggleTab(toggle)
    if toggle and not tablet then
        tablet = true

		if not IsPedInAnyVehicle(PlayerPedId(), false) then
			Citizen.CreateThread(function()
				lib.requestAnimDict(tabletDict)
				lib.requestModel(tabletProp)

				while not HasModelLoaded(tabletProp) do
					Citizen.Wait(150)
				end

				local playerPed = PlayerPedId()
				local tabletObj = CreateObject(tabletProp, 0.0, 0.0, 0.0, true, true, false)
				SetEntityCollision(tabletObj, false, false)
				local tabletBoneIndex = GetPedBoneIndex(playerPed, tabletBone)

				SetCurrentPedWeapon(playerPed, `weapon_unarmed`, true)
				AttachEntityToEntity(tabletObj, playerPed, tabletBoneIndex, tabletOffset.x, tabletOffset.y, tabletOffset.z, tabletRot.x, tabletRot.y, tabletRot.z, true, false, false, false, 2, true)
				SetModelAsNoLongerNeeded(tabletProp)

				while tablet do
					Citizen.Wait(100)
					playerPed = PlayerPedId()

					if not IsEntityPlayingAnim(playerPed, tabletDict, tabletAnim, 3) then
						TaskPlayAnim(playerPed, tabletDict, tabletAnim, 3.0, 3.0, -1, 49, 0, 0, 0, 0)
					end
				end

				ClearPedSecondaryTask(playerPed)

				Citizen.Wait(450)

				DetachEntity(tabletObj, true, false)
				KKF.Game.DeleteEntity(tabletObj)
			end)
		end
    elseif not toggle and tablet then
        tablet = false
    end
end

local function showTablet()
    SendNUIMessage({ action = "showTablet" })
	
    local isInVeh = IsPedInAnyVehicle(PlayerPedId(), false)

    if not isInVeh then
        SetPlayerControl(PlayerId(), 0, 0)
    end

    guiEnabled = true
    SetNuiFocus(true, true)

    toggleTab(true)
end

RegisterCommand('mdw', function()
	if exports['kk-taskbar']:canInteract() then return end
	if not LocalPlayer.state['isLoggedIn'] then return end
    if LocalPlayer.state.isCuffed then return	end
	if IsEntityDead(PlayerPedId()) then	return end
	if IsEntityInWater(PlayerPedId()) then	return end
	
    if KKF.PlayerData.job.name == 'police' and KKF.PlayerData.job.onDuty  then
        showTablet()
    end

	lib.callback('kk-mdw:loadFines', false, function(response)
		SendNUIMessage({ action = "loadFines", data = response, first = true })
	end, '')

	lib.callback('kk-mdw:loadWanted', false, function(response)
		SendNUIMessage({ action = "loadWanted", data = response })
	end)
end) 

RegisterKeyMapping('mdw', 'Ava politsei infosüsteem', 'keyboard', 'F7')

RegisterNUICallback("searchOffenses", function(args, cb) 
	lib.callback('kk-mdw:loadFines', false, function(response)
		SendNUIMessage({ action = "loadFines", data = response })
	end, args.context or '')
end)

RegisterNUICallback("createCase", function(args, cb)
	if canPunish(characterSelected) then
		lib.callback('kk-mdw:createCase', false, function(response) 
			SendNUIMessage({ action = "showNotification", data = {text = 'Juhtum loodud.', type = 'success', title = 'Sissekande loomine'} })
		end, args.pid, args.offences, args.notes, args.fine, args.jail, args.dmv_points, args.weapon_points)
	else
		SendNUIMessage({ action = "showNotification", data = {text = 'Te ei saa hetkel juhtumit luua.', type = 'error', title = 'Sissekande loomine'} })
	end
end)

RegisterNUICallback("setWanted", function(args, cb)
	lib.callback('kk-mdw:setWanted', false, function(response)
		if response then
			SendNUIMessage({ action = "showNotification", data = {text = 'Määratud tagaotsitavaks.', type = 'success', title = 'Tagaotsitavus'} })
		else
			SendNUIMessage({ action = "showNotification", data = {text = 'Tagaotsitavus eemaldatud.', type = 'info', title = 'Tagaotsitavus'} })
		end

		lib.callback('kk-mdw:loadCharacter', false, function(response)
			SendNUIMessage({ action = "loadCharacter", data = response })
		end, args.id)
	end, args.id, args.reason)
end) 

RegisterNUICallback("loadOffenceDetails", function(args, cb)
	lib.callback('kk-mdw:loadOffenceDetails', false, function(response)
		SendNUIMessage({ action = "loadOffenceDetails", data = response })
	end, args.id)
end)

RegisterNUICallback("loadRecords", function(args, cb)
	lib.callback('kk-mdw:loadRecords', false, function(response)
		SendNUIMessage({ action = "loadRecords", data = response })
	end, args.id)
end)

RegisterNUICallback('loadCharacterProperties', function(args, cb)
	lib.callback('kk-mdw:loadCharacterProperties', false, function(response)
		local elements = response

		for k,v in pairs(elements.vehicles) do
			elements.vehicles[k].label = GetLabelText(GetDisplayNameFromVehicleModel(elements.vehicles[k].model))
		end
	
		SendNUIMessage({ action = "loadCharacterProperties", data = elements })
	end, args.id)
end)

RegisterNUICallback("giveLicense", function(args, cb)
	lib.callback('kk-mdw:giveLicense', false, function(response)
		SendNUIMessage({ action = "reloadCharacter" })
	end, args.id, args.license)
end)

RegisterNUICallback("removeLicense", function(args, cb)
	lib.callback('kk-mdw:removeLicense', false, function(response)
		SendNUIMessage({ action = "reloadCharacter" })
	end, args.id, args.license)
end)

RegisterNUICallback("loadCharacter", function(args, cb)
	lib.callback('kk-mdw:loadCharacter', false, function(response)
		if response then
			SendNUIMessage({ action = "loadCharacter", data = response }); characterSelected = tonumber(response.id)
		else
			SendNUIMessage({ action = "showNotification", data = {text = 'Juriidilistel isikutel puudub profiil.', type = 'error', title = 'Profiil'} })
			SendNUIMessage({ action = "backToResults" })
		end
	end, args.id, args.opening)
end) 

RegisterNUICallback("loadunPaidBills", function(args, cb)
    lib.callback('sla-billing:getUnpaidBills', false, function(response)
        if response then
            SendNUIMessage({ action = "loadunPaidBills", data = response })
        else
            -- print("Response is nil")
        end
    end, args.id, 'police')
end)

RegisterNUICallback("saveNotes", function(args, cb)
	lib.callback('kk-mdw:saveNotes', false, function(response)
		SendNUIMessage({ action = "showNotification", data = {text = 'Märkmed on salvestatud.', type = 'success', title = 'Profiil'} })
	end, args.id, args.notes)
end)

RegisterNUICallback("search", function(args, cb)
	lib.callback('kk-mdw:search', false, function(response)
		local elements = response

		for k,v in pairs(elements.vehicles) do
			elements.vehicles[k].label = GetLabelText(GetDisplayNameFromVehicleModel(elements.vehicles[k].model))
		end

		SendNUIMessage({ action = "loadResults", data = elements })
	end, args.context)
end)

RegisterNUICallback("disableFocus", function(args, cb)
    if not guiEnabled then
        return
    end

    SetPlayerControl(PlayerId(), 1, 0)
    SetNuiFocus(false, false)

    guiEnabled = false

	toggleTab(false)
end)