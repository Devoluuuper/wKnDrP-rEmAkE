local microphone = false 
local status = {
    health = 100,
    armor = 0,
    food = 100,
    thirst = 100,
    stress = 0
}

local mapOpend = false

CreateThread(function()
	while true do
        if IsPauseMenuActive() and not mapOpend then
            mapOpend = true
            SendNUIMessage({ action = 'hideAll' })
        elseif not IsPauseMenuActive() and mapOpend then
            mapOpend = false
            SendNUIMessage({ action = 'showAll' })
        end

		Wait(800)
	end
end)

CreateThread(function()
    Wait(1000)

    setMapType()
    if LocalPlayer.state.isLoggedIn then
        SendNUIMessage({ action = 'toggleHud', data = { status = true } })
    end
end)

RegisterNetEvent('KKF.Player.Loaded', function(playerData)    
    setMapType()
    SendNUIMessage({ action = 'toggleHud', data = { status = true } })
end)

RegisterNetEvent('KKF.Player.Unloaded', function()
    SendNUIMessage({ action = 'toggleHud', data = { status = false } })
end)

RegisterCommand('mapFix', function()
    setMapType()

    if cache.vehicle then
        DisplayRadar(true)
    end
end)

AddStateBagChangeHandler('proximity', ('player:%s'):format(cache.serverId), function(_, _, value)
    if value and value.index then
        SendNUIMessage({ action = 'proximityDistance', data = { value = value.index } })
    end
end)

RegisterNetEvent('KKF.UI.Needs', function(data)
    SendNUIMessage({ 
        action = 'updateNeeds', 
        data = {
            food = data.hunger,
            thirst = data.thirst,
            stress = data.stress
        } 
    })
end)

CreateThread(function()
    while true do
        SendNUIMessage({ action = 'toggleTalking', data = { status = MumbleIsPlayerTalking(cache.playerId) == 1 } })

        Wait(500)
    end
end)

AddStateBagChangeHandler('radioChannel', ('player:%s'):format(cache.serverId), function(_, _, value)
    SendNUIMessage({ action = 'toggleRadio', data = { status = value ~= 0 } })
end)

RegisterNetEvent('pma-voice:radioActive', function(value)
    SendNUIMessage({ action = 'radioSpeaking', data = { status = value } })
end)

AddStateBagChangeHandler('adminMode', ('player:%s'):format(cache.serverId), function(_, _, value)
    SendNUIMessage({ action = 'adminMode', data = { status = value } })
end)

RegisterNetEvent('kkf:ui:limiter', function(value)
    SendNUIMessage({ action = 'cruseControl', data = { status = value } })
end)

CreateThread(function()
    local oxygen = 0

    while true do
        if IsEntityInWater(cache.ped) then
            oxygen = GetPlayerUnderwaterTimeRemaining(cache.playerId) * 10
        else
            oxygen = 100 - GetPlayerSprintStaminaRemaining(cache.playerId)
        end

        SendNUIMessage({ action = 'updateHealth', data = { health = GetEntityHealth(cache.ped) - 100, armor = GetPedArmour(cache.ped), oxygen = oxygen } })

        Wait(500)
    end
end)

lib.onCache('vehicle', function(value)
    CreateThread(function()
        while cache.vehicle do
            SetRadarZoom(1000)

            Wait(333)
        end
    end)
end)

local carHudActive = false

local width = 1;
local south = -0
local west = -90
local north = -180
local east = -270
local south2 = -360

local function rangePercent(min, max, amt)
    return (((amt - min) * 100) / (max - min)) / 100
end

local function lerp(min, max, amt)
    return (1 - amt) * min + amt * max
end

local function calcHeading(direction)
    if (direction < 90) then
        return lerp(north, east, direction / 90)
    elseif (direction < 180) then
        return lerp(east, south2, rangePercent(90, 180, direction))
    elseif (direction < 270) then
        return lerp(south, west, rangePercent(180, 270, direction))
    elseif (direction <= 360) then
        return lerp(west, north, rangePercent(270, 360, direction))
    end
end

CreateThread(function()
    while true do
        wait = 1000

        if cache.vehicle then
            if not carHudActive then
                carHudActive = true

                SetRadarZoom(1000)
                DisplayRadar(true)
                SendNUIMessage({ action = 'carToggle', data = { status = true } })
                SendNUIMessage({ action = 'compassToggle', data = { status = true } })
            end

            wait = 100

            local vehicleSpeed = math.ceil(GetEntitySpeed(cache.vehicle) * 2.23694)
            local vehicleFuel = Entity(cache.vehicle).state.fuel
            local vehicleGear = GetVehicleCurrentGear(cache.vehicle)

            if (vehicleSpeed == 0 and vehicleGear == 0) or (vehicleSpeed == 0 and vehicleGear == 1) then
                vehicleGear = 'N'
            elseif vehicleSpeed > 0 and vehicleGear == 0 then
                vehicleGear = 'R'
            end

            SendNUIMessage({ 
                action = 'updateCar', 
                data = { 
                    speed = tostring(vehicleSpeed),
                    fuel = vehicleFuel,
                    gear = vehicleGear,
                } 
            })
        else
            if carHudActive then
                carHudActive = false

                SetRadarZoom(1000)
                DisplayRadar(false)
                SendNUIMessage({ action = 'carToggle', data = { status = false } })
                SendNUIMessage({ action = 'compassToggle', data = { status = false } })
            end
        end

        Wait(wait)
    end
end)

local street = nil
local zone = nil

CreateThread(function()
    while true do
        wait = 1000

        if cache.vehicle then
            local playerCoords = GetEntityCoords(cache.ped)
            local newStreet = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
            local newZone = GetNameOfZone(playerCoords)

            if newStreet ~= street or newZone ~= zone then
                street = newStreet
                zone = newZone

                SendNUIMessage({ 
                    action = 'updateStreet', 
                    data = { 
                        street = GetStreetNameFromHashKey(street),
                        zone = GetStreetNameFromHashKey(zone)
                    } 
                })
            end
        end

        Wait(wait)
    end
end)

local heading, lastHeading = 0, 1

CreateThread( function()
	while true do
		wait = 150

        if cache.vehicle then
            heading = math.floor(calcHeading(-GetFinalRenderedCamRot(0).z % 360))

            if heading ~= lastHeading then
                SendNUIMessage({ 
                    action = 'updateHeading', 
                    data = { 
                        heading = heading
                    } 
                })

                Wait(2)
            end

            lastHeading = heading
        else
            wait = 1000
        end

        Wait(wait)
	end
end)

function setMapType()
    local defaultAspectRatio = 1920 / 1080
    local resolutionX, resolutionY = GetActiveScreenResolution()
    local aspectRatio = resolutionX / resolutionY
    local minimapOffset = 0

    if aspectRatio > defaultAspectRatio then
        minimapOffset = ((defaultAspectRatio - aspectRatio) / 3.6) - 0.008
    end

    local minimap = RequestScaleformMovie("minimap")
    if not HasScaleformMovieLoaded(minimap) then
        RequestScaleformMovie(minimap)
        while not HasScaleformMovieLoaded(minimap) do
            Wait(1)
        end
    end

    RequestStreamedTextureDict("squaremap", false)
    while not HasStreamedTextureDictLoaded("squaremap") do
        Wait(100)
    end

    AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "squaremap", "radarmasksm")
    AddReplaceTexture("platform:/textures/graphics", "radarmask1g", "squaremap", "radarmasksm")

    SetMinimapComponentPosition("minimap", "L", "B", 0.0 + minimapOffset, -0.047, 0.1638, 0.183)
    SetMinimapComponentPosition("minimap_mask", "L", "B", 0.0 + minimapOffset, 0.00, 0.128, 0.20)
    SetMinimapComponentPosition("minimap_blur", "L", "B", -0.01 + minimapOffset, 0.025, 0.262, 0.300)

    local northBlip = GetNorthRadarBlip()
    if northBlip ~= 0 then
        SetBlipAlpha(northBlip, 0)
    end

    SetRadarBigmapEnabled(true, false)
    SetMinimapClipType(0)
    Wait(500)
    SetRadarBigmapEnabled(false, false)

    Wait(2000)
    SetRadarZoom(1000)
    DisplayRadar(false)
end

RegisterNetEvent('kkf:ui:seatBelt', function(status)
    SendNUIMessage({ action = 'setSeatbelt', data = { status = status } })
end)

RegisterNetEvent('kk-hud2:client:showInstruction', function(title, description)
    SendNUIMessage({ action = 'showInstruction', data = { title = title, description = description } })
end)

RegisterNetEvent('kk-hud2:client:hideInstruction', function()
    SendNUIMessage({ action = 'hideInstruction' })
end)

local interactActive = false

RegisterNetEvent('kk-hud2:client:showInteract', function(text, key)
    SendNUIMessage({ action = 'showInteract', data = { text = text, key = key } }); interactActive = true
end)

RegisterNetEvent('kk-hud2:client:hideInteract', function()
    SendNUIMessage({ action = 'hideInteract' }); interactActive = false
end)

exports('interactActive', function()
    return interactActive
end)

RegisterNetEvent('KKF.UI.ShowNotification', function(type, message, timer)
    SendNUIMessage({
        action = 'showNotification',
        data = {
            type = type,
            message = message,
            timer = timer or 5000
        }
    })
end)