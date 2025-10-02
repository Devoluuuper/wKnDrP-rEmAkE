local cam = 0
local IsChoosing = true

CreateThread(function()
    while true do
        Wait(0)
		
        if IsChoosing then
            DisplayHud(false)
            DisplayRadar(false)
        end
    end
end)

RegisterNetEvent('KKF.Player.Loaded', function(xPlayer, isNew)
	KKF.PlayerData = xPlayer
	LocalPlayer.state:set('isLoggedIn', true, false)
end)

RegisterNetEvent('KKF.Player.Unloaded', function()
	KKF.PlayerData = {}; SetPedArmour(cache.ped, 0)
	LocalPlayer.state:set('isLoggedIn', false, false)
end)

AddEventHandler('KKF.Player.Spawned', function()
	if KKF.PlayerData.dead ~= false then KKF.SetPlayerData('dead', false) end
end)

AddEventHandler('KKF.Player.Death', function()
	if KKF.PlayerData.dead ~= false then KKF.SetPlayerData('dead', true) end
end)

RegisterNetEvent('KKF.Player.ReloadLicenses', function(licenses)
	KKF.PlayerData.licenses = licenses
	
	KKF.SetPlayerData('licenses', licenses)
end)

RegisterNetEvent('KKF.Accounts.Set', function(account)
	for k,v in ipairs(KKF.PlayerData.accounts) do
		if v.name == account.name then
			KKF.PlayerData.accounts[k] = account
			break
		end
	end

	KKF.SetPlayerData('accounts', KKF.PlayerData.accounts)
end)

RegisterNetEvent('KKF.Inventory.ShowNotification', function(text)
	SendNUIMessage({ action = 'inventoryNotification', data = { text = text } })
end)

RegisterNetEvent('KKF.Player.JobUpdate', function(job)
	KKF.SetPlayerData('job', job)
end)

RegisterNetEvent('KKF.SetupCharacters', function()
    ShutdownLoadingScreen()
    Citizen.Wait(100)
end)

local function doCamera(x, y, z)
	DoScreenFadeOut(1)

	if not DoesCamExist(cam) then
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
	end

	i = 3200
	SetFocusArea(x, y, z, 0.0, 0.0, 0.0)
	SetCamActive(cam,  true)
	RenderScriptCams(true,  false,  0,  true,  true)
	DoScreenFadeIn(1500)
	local camAngle = -90.0

	while i > 1 do
		local factor = i / 50
		if i < 1 then i = 1 end
		i = i - factor
		SetCamCoord(cam, x,y,z+i)
		if i < 1200 then
			DoScreenFadeIn(600)
		end
		if i < 90.0 then
			camAngle = i - i - i
		end
		SetCamRot(cam, camAngle, 0.0, 0.0)
		Citizen.Wait(2/i)
	end
end

local function requestModel(modelHash, cb)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) and IsModelInCdimage(modelHash) then
		RequestModel(modelHash)

		while not HasModelLoaded(modelHash) do
			Wait(0)
		end
	end

	if cb then cb() end
end

RegisterNetEvent('KKF.SpawnFirstTime', function(sex)
	Wait(500)
    doCamera(-1399.216,6745.788,8.971)
    DoScreenFadeOut(2)

    ClearFocus()
	DestroyAllCams(true)
	RenderScriptCams(false, true, 1, true, true)
    IsChoosing = false
    DisplayHud(true)
    DisplayRadar(true)
    SetEntityCoords(cache.ped, vec3(-1399.359,6745.897,8.971));
	FreezeEntityPosition(cache.ped, false)
	SetEntityHeading(cache.ped, 68.031494140625)

    Wait(200); DoScreenFadeIn(2500)

	TriggerEvent('KKF.Player.Spawned')
	TriggerEvent('kk-skin:openRegisterMenu', sex)
	
	KKF.SetPlayerData('ped', PlayerPedId())
	exports.nui_doorlock:updateDoors() -- KUI KASUTAD
end)

RegisterNetEvent('KKF.SpawnCharacter', function(spawn, skin, tattoos, sex, wait)
	if wait then Wait(200) end
    local pos = spawn

    doCamera(pos.x, pos.y, pos.z)
    DoScreenFadeOut(2)

    ClearFocus()
	DestroyAllCams(true)
	RenderScriptCams(false, true, 1, true, true)
    IsChoosing = false
    DisplayHud(true)
    DisplayRadar(true)
    SetEntityCoords(cache.ped, vec3(pos.x, pos.y, pos.z)); FreezeEntityPosition(cache.ped, false)

    Wait(200); DoScreenFadeIn(2500)

    TriggerEvent('KKF.Player.Spawned')
	TriggerEvent("bluum-appearnance:loadClothes", skin)

	KKF.SetPlayerData('ped', PlayerPedId())

	exports.nui_doorlock:updateDoors(); Wait(1500)
	SetTimeout(2000, function()
		TriggerEvent('kk-scripts:client:reloadWeapons')
	end)
	SetTimeout(1500, function() TriggerEvent('bluum-appearnance:settattoos', tattoos) end)
	TriggerScreenblurFadeOut(0)
end)

RegisterNetEvent('KKF.ReloadCharacters', function()
	TriggerServerEvent("KKF.Player.SessionStarted")
    TriggerEvent("KKF.SetupCharacters")
end)

RegisterNetEvent('KKF.SetVehicleProperties', function(netId, data)
    local entity = NetworkGetEntityFromNetworkId(netId)
	KKF.Game.RequestNetworkControlOfEntity(entity)
    KKF.Game.SetVehicleProperties(entity, json.decode(data))
end)

RegisterNetEvent('KKF.Player.JoinRadio', function(channel)
    exports["pma-voice"]:setVoiceProperty("radioEnabled", true)
    exports["pma-voice"]:setRadioChannel(channel)
end)

RegisterNetEvent('KKF.Player.LeaveRadio', function()
    exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
    exports["pma-voice"]:setRadioChannel(0)
end)

RegisterNetEvent('KKF.IPL.Load', function(ipl)
	OnEnterMp(); RequestIpl(ipl)
end)

RegisterNetEvent('KKF.IPL.Unload', function(ipl)
	RemoveIpl(ipl)
end)