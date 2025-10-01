local tablet = false
local tabletDict = "amb@code_human_in_bus_passenger_idles@female@tablet@base"
local tabletAnim = "base"
local tabletProp = `prop_cs_tablet`
local tabletBone = 60309
local tabletOffset = vector3(0.03, 0.002, -0.0)
local tabletRot = vector3(10.0, 160.0, 0.0)
local done = false
local data = {}
local currentContract = {}
local copBlips = {}

local function isBoosting(plate)
    if currentContract.plate == plate then
        return currentContract.class
    end

    return 'NONE'
end

exports('isBoosting', isBoosting)

RegisterNetEvent('KKF.Player.Loaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('KKF.Player.JobUpdate', function(job)
	ESX.PlayerData.job = job

    if ESX.PlayerData.job.name ~= 'police' or not ESX.PlayerData.job.onDuty then
        for k,v in pairs(copBlips) do RemoveBlip(v) end
    end
end)

RegisterNetEvent('KKF.Player.DutyChange', function(value)
	ESX.PlayerData.job.onDuty = value

    if ESX.PlayerData.job.name ~= 'police' or not ESX.PlayerData.job.onDuty then
        for k,v in pairs(copBlips) do RemoveBlip(v) end
    end
end)

RegisterNetEvent('KKF.Player.Unloaded', function()
    for k,v in pairs(copBlips) do RemoveBlip(v) end
end)

RegisterNetEvent('kk-boosting:client:setCopBlip', function(id, coords)
    if copBlips[id] then RemoveBlip(copBlips[id]) end

    copBlips[id] = AddBlipForCoord(coords)
    SetBlipSprite(copBlips[id], 161)
    SetBlipScale(copBlips[id], 2.0)
	SetBlipColour(copBlips[id], 8)
	PulseBlip(copBlips[id])
end)

RegisterNetEvent('kk-boosting:client:destroyBlip', function(id)
    if copBlips[id] then RemoveBlip(copBlips[id]); copBlips[id] = nil end
end)

RegisterNetEvent('kk-boosting:client:boostingHack', function()
	if cache.vehicle then
        if currentContract.plate then
            if currentContract.plate == GetVehicleNumberPlateText(cache.vehicle) and currentContract.class == 'S' and currentContract.class == 'A' then
                exports['memorygame']:thermiteminigame(13, 3, 3, 3, function()
                    local currentId = 0
                    local vehicleLabel = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(cache.vehicle)))

                    TriggerEvent('kk-dispatch:client:sendDispatch', '99-99', 'police', 'SÕIDUKI VARGUS [KLASS: ' .. boostStatus .. '; REG.NR: ' .. GetVehicleNumberPlateText(cache.vehicle) .. '; MODEL: ' .. vehicleLabel .. ']')
                    TriggerEvent('kk-scripts:client:newKey', GetVehicleNumberPlateText(cache.vehicle))
                    TriggerEvent('KKF.UI.ShowNotification', 'success', 'Saite sõiduki häkitud.')

                    while not currentContract.hacked do
                        currentId = lib.callback.await('kk-boosting:setCopBlip', false, GetEntityCoords(cache.vehicle))

                        Wait(15000)
                    end

                    lib.callback.await('kk-boosting:destroyBlips', false, currentId)
                end, function()
                    TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ebaõnnestusite häkkimisel.')
                end)
            else
                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Seda sõidukit ei saa hackida!')
            end
        else
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil ei ole ühtegi aktiivset tööotsa!')
        end
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ei ole sõidukis hetkel!')
	end
end)

local function toggleTab(toggle)
    if toggle and not tablet then
        tablet = true

		if not cache.vehicle then
			Citizen.CreateThread(function()
				lib.requestAnimDict(tabletDict)
				lib.requestModel(tabletProp)

				local tabletObj = CreateObject(tabletProp, 0.0, 0.0, 0.0, true, true, false)
				local tabletBoneIndex = GetPedBoneIndex(cache.ped, tabletBone)

                SetEntityCollision(tabletObj, false, false)
				SetCurrentPedWeapon(cache.ped, `weapon_unarmed`, true)
				AttachEntityToEntity(tabletObj, cache.ped, tabletBoneIndex, tabletOffset.x, tabletOffset.y, tabletOffset.z, tabletRot.x, tabletRot.y, tabletRot.z, true, false, false, false, 2, true)
				SetModelAsNoLongerNeeded(tabletProp)

				while tablet do
					Citizen.Wait(100)

					if not IsEntityPlayingAnim(cache.ped, tabletDict, tabletAnim, 3) then
						TaskPlayAnim(cache.ped, tabletDict, tabletAnim, 3.0, 3.0, -1, 49, 0, 0, 0, 0)
					end
				end

				ClearPedSecondaryTask(cache.ped)

				Citizen.Wait(450)

				DetachEntity(tabletObj, true, false)
				ESX.Game.DeleteEntity(tabletObj)
			end)
		end
    elseif not toggle and tablet then
        tablet = false
    end
end

local function openTablet()
    lib.callback('kk-boosting:requestData', false, function(data)
        SendNUIMessage({ action = 'open', data = data, current = currentContract })
        SetNuiFocus(true, true); toggleTab(true)
    end)
end

local function updateData()
    lib.callback('kk-boosting:requestData', false, function(data)
        SendNUIMessage({ action = 'update', data = data, current = currentContract })
    end)
end

SetInterval(function()
    if currentContract.timeRemaining ~= nil then
        if currentContract.timeRemaining > 0 then 
            currentContract.timeRemaining -= 1; updateData()

            if currentContract.timeRemaining == 0 then
                if data.blip1 then RemoveBlip(data.blip1); data.blip1 = nil end 
                if data.blip2 then RemoveBlip(data.blip2); data.blip2 = nil end 
                currentContract = {}
            
                if data.point then data.point:remove(); ESX.HideInteraction() end
            
                if data.vehicle then
                    if cache.vehicle ~= data.vehicle then
                        ESX.Game.DeleteEntity(vehicle) 
                    end

                    data.vehicle = nil
                end
            
                if data.dropPed then DeletePed(data.dropPed); data.dropPed = nil end
                if data.dropLocation then data.vehicleBox:destroy() end
                if data.vehicleBox then data.vehicleBox:destroy() end

                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ebaõnnestusite tööotsal!'); updateData()
            end
        end
    end
end, 60000)

RegisterNetEvent('KKF.Player.Unloaded', function()
    if data.blip1 then RemoveBlip(data.blip1); data.blip1 = nil end 
    if data.blip2 then RemoveBlip(data.blip2); data.blip2 = nil end
    currentContract = {}

    if data.point then data.point:remove(); ESX.HideInteraction() end

    if data.vehicle then
        ESX.Game.DeleteEntity(vehicle, function() 
            data.vehicle = nil
        end) 
    end

    if data.dropPed then DeletePed(data.dropPed); data.dropPed = nil end
    if data.dropLocation then data.vehicleBox:destroy() end
    if data.vehicleBox then data.vehicleBox:destroy() end
end)

local function createBlip(search, drop)
    data.search = {}
    data.search.x = search.x + math.random(-145.0, 145.0)
    data.search.y = search.y + math.random(-145.0, 145.0)

    data.blip1 = AddBlipForRadius(data.search.x, data.search.y, 0.0, 250.0)
    SetBlipSprite(data.blip1, 9)
    SetBlipColour(data.blip1, 1)
    SetBlipAlpha(data.blip1, 80)

    data.blip2 = AddBlipForCoord(drop)
    SetBlipSprite(data.blip2, 596)
    SetBlipColour(data.blip2, 6)
    SetBlipScale(data.blip2, 0.7)
    SetBlipDisplay(data.blip2, 4)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Tarnepunkt")
    EndTextCommandSetBlipName(data.blip2)
end

RegisterCommand('bEemaldaGps', function()
    currentContract.hacked = true
end)

local function deliverVehicle()
    local vehicle <const> = cache.vehicle
    local ped <const> = data.dropPed

    if vehicle then
        if GetVehicleNumberPlateText(vehicle) == data.plate then
            if (currentContract.class == 'A' or currentContract.class == 'S') and not currentContract.hacked then
                return TriggerEvent('KKF.UI.ShowNotification', 'error', 'Eemalda GPS seade enne tarnimist.')
            end

            data.point:remove(); ESX.HideInteraction()
            GetVehicleDoorsLockedForPlayer(vehicle)
            TaskLeaveVehicle(cache.ped, vehicle, 64)

            lib.callback('kk-boosting:finishJob', false, function(response) end)

            SetTimeout(5000, function()
                FreezeEntityPosition(ped, false)
                TaskVehicleDriveWander(ped, vehicle, 100.0, 4195263)
            end)

            RemoveBlip(data.blip1); RemoveBlip(data.blip2)
            data.blip2 = nil; data.blip1 = nil; currentContract = {}

            SetTimeout(15000, function()
                ESX.Game.DeleteEntity(vehicle, function() 
                    data.vehicle = nil

                    DeletePed(ped); data.dropPed = nil
                end) 
            end)
        else
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'See ei ole õige sõiduk!')
        end
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ei ole üheski sõidukis!')
    end
end

local function startContract(plate, location, drop, model)
    data.plate = plate; data.location = location; data.model = model; 
    data.search = location; data.drop = drop; createBlip(data.search, data.drop)

    data.vehicleBox = BoxZone:Create(data.location, 300.0, 300.0, {
        name = "vehicleBox:" .. math.random(00001, 99999),
        offset = {0.0, 0.0, 0.0},
        scale = {1.0, 1.0, 1.0},
        debugPoly = false,
        minZ = location.z - 30.0,
        maxZ = location.z + 100.0
    })

    data.vehicleBox:onPlayerInOut(function(val)
        if val then
            lib.callback('KKF.Vehicle.SpawnVehicle', false, function(networkId)
                if not networkId then
                    TriggerEvent('KKF.UI.ShowNotification', "error", "Tekkis viga!")
                    return
                end

                while not NetworkDoesEntityExistWithNetworkId(networkId) do
                    Wait(10)
                end

                data.vehicle = NetworkGetEntityFromNetworkId(networkId)

                ESX.Game.RequestNetworkControlOfEntity(data.vehicle)
                SetVehicleNumberPlateText(data.vehicle, data.plate)
                SetVehRadioStation(data.vehicle, "OFF")

                data.dropLocation = BoxZone:Create(data.drop, 300.0, 300.0, {
                    name = "dropLocation:" .. math.random(00001, 99999),
                    offset = {0.0, 0.0, 0.0},
                    scale = {1.0, 1.0, 1.0},
                    debugPoly = false,
                    minZ = data.drop.z - 30.0,
                    maxZ = data.drop.z + 100.0
                })

                data.dropLocation:onPlayerInOut(function(val)
                    if val then
                        lib.callback('KKF.Entity.SpawnPed', false, function(networkId)
                            if networkId then
                                while not NetworkDoesEntityExistWithNetworkId(networkId) do
                                    Wait(10)
                                end
            
                                data.dropPed = NetworkGetEntityFromNetworkId(networkId)
                                ESX.Game.RequestNetworkControlOfEntity(data.dropPed)

                                PlaceObjectOnGroundProperly(data.dropPed)
                                SetBlockingOfNonTemporaryEvents(data.dropPed, true)
                                SetPedDiesWhenInjured(data.dropPed, false)
                                SetPedCanPlayAmbientAnims(data.dropPed, true)
                                SetPedCanRagdollFromPlayerImpact(data.dropPed, false)
                                SetEntityInvincible(data.dropPed, true)
                                FreezeEntityPosition(data.dropPed, true)

                                data.point = lib.points.new(vec3(data.drop.x, data.drop.y, data.drop.z), 5.0, {})
                                
                                function data.point:onEnter()
                                    ESX.ShowInteraction('Tarni sõiduk', 'E')

                                end
                                
                                function data.point:onExit()
                                    ESX.HideInteraction()
                                end
                                
                                function data.point:nearby()
                                    if self.currentDistance < 5.0 and IsControlJustReleased(0, 38) then
                                        if not done then deliverVehicle(); done = true; SetTimeout(850, function() done = false end) end
                                    end
                                end
                            end

                            data.dropLocation:destroy()
                        end, cfg.dropNpc, data.drop, data.drop.w)
                    end
                end)

                data.vehicleBox:destroy()
            end, data.model, data.location)
        end
    end)
end

RegisterNetEvent('kk-boosting:client:openTablet', function() openTablet() end)

RegisterNUICallback('closeTablet', function(args)
    SendNUIMessage({ action = 'close' }); SetNuiFocus(false, false); toggleTab(false)
end)

RegisterNUICallback('acceptContract', function(args)
    if not data.blip1 then
        lib.callback('kk-boosting:acceptContract', false, function(response)
            if response then
                startContract(response.plate, response.location, response.drop, response.model)

                currentContract = {
                    img = response.img,
                    plate = response.plate,
                    label = response.label,
                    prize = response.prize,
                    class = response.class,
                    plate = response.plate,
                    timeRemaining = 15,
                    hacked = false, 
                    extended = 0
                }
            else
                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil ei ole pangas piisavalt raha!')
            end

            updateData()
        end, args.id)
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ei saa kahte tööotsa korraga teha!')
        updateData()
    end
end)

RegisterNUICallback('deleteContract', function(args)
    lib.callback('kk-boosting:deleteContract', false, function()
        updateData(); TriggerEvent('KKF.UI.ShowNotification', 'info', 'Keeldusite tööotsast!')
    end, args.id)
end) 

RegisterNUICallback('cancelContract', function(args)
    if data.blip1 then RemoveBlip(data.blip1); data.blip1 = nil end 
    if data.blip2 then RemoveBlip(data.blip2); data.blip2 = nil end 
    currentContract = {}

    if data.point then data.point:remove(); ESX.HideInteraction() end

    if data.vehicle then
        if cache.vehicle ~= data.vehicle then
            ESX.Game.DeleteEntity(vehicle) 
        end

        data.vehicle = nil
    end

    if data.dropPed then DeletePed(data.dropPed); data.dropPed = nil end
    if data.dropLocation then data.vehicleBox:destroy() end
    if data.vehicleBox then data.vehicleBox:destroy() end

    TriggerEvent('KKF.UI.ShowNotification', 'error', 'Katkestasite tööotsal!'); updateData()
end)

RegisterNUICallback('queueToggle', function(args)
    lib.callback('kk-boosting:queueToggle', false, function()
        updateData()
    end)
end)

RegisterNetEvent('kk-boosting:client:updateData', updateData)

RegisterNUICallback('extendContract', function(args)
    if currentContract.extended <= 3 then
        exports["memorygame"]:thermiteminigame(7, 2, 3, 20, function()
            currentContract.extended += 1; currentContract.timeRemaining += 1
            TriggerEvent('KKF.UI.ShowNotification', "success", "Pikendasite tööotsa aega 1 minuti võrra!"); updateData()
        end, function()
            currentContract.extended += 1
            TriggerEvent('KKF.UI.ShowNotification', "error", "Te ei saanud häkkimisega hakkama!"); updateData()
        end)
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ei saa rohkem aega pikendada!'); updateData()
    end
end)