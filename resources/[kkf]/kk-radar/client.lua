local hotPlates = {}
local hotPlatesReason = {}

local lockplates = false
local radarEnabled = false 
local hidden = false 
local radarInfo = cfg.defaultSettings

local mapOpend = false

CreateThread(function()
	while true do
        if IsPauseMenuActive() and not mapOpend then
            mapOpend = true
            SendNUIMessage({ hideAll = true })
        elseif not IsPauseMenuActive() and mapOpend then
            mapOpend = false
            SendNUIMessage({ showAll = true })
        end

		Wait(800)
	end
end)

local function updateRadarUI()
    SendNUIMessage({
        patrolspeed = radarInfo.patrolSpeed,
        fwdspeed = radarInfo.fwdSpeed,
        fwdfast = radarInfo.fwdFast,
        fwddir = radarInfo.fwdDir,
        bwdspeed = radarInfo.bwdSpeed,
        bwdfast = radarInfo.bwdFast,
        bwddir = radarInfo.bwdDir,
        fwdxmit = radarInfo.fwdXmit,
        fwdmode = radarInfo.fwdMode,
        bwdxmit = radarInfo.bwdXmit,
        bwdmode = radarInfo.bwdMode,
        lockfwdfast = radarInfo.fwdFastLocked,
        lockbwdfast = radarInfo.bwdFastLocked,
        frontPlate = radarInfo.frontPlate,
        rearPlate = radarInfo.rearPlate,
        lockBeep = radarInfo.lockBeep,
        fastLimit = radarInfo.fastLimit
    })
end

local function loadSettings()
    lib.callback('kk-radar:loadSettings', false, function(settings)
        if settings then
            radarInfo = settings
            updateRadarUI()
        else
            radarInfo = cfg.defaultSettings
        end
    end)
end

CreateThread(function()
    KKF.PlayerData = KKF.GetPlayerData()

    if LocalPlayer.state.isLoggedIn then
        Wait(1000)
        loadSettings()
    end
end)

RegisterNetEvent('KKF.Player.Loaded', function(playerData)
	KKF.PlayerData = playerData

    loadSettings()
end)

local function saveSettings()
    TriggerServerEvent('kk-radar:server:saveSettings', radarInfo)
end

RegisterNetEvent('KKF.Player.Unloaded', function() 
	KKF.PlayerData = {}
    radarInfo = cfg.defaultSettings
end)

RegisterNetEvent('KKF.Player.JobUpdate', function(job)
	KKF.PlayerData.job = job
end)

RegisterNetEvent('KKF.Player.DutyChange', function(value)
	KKF.PlayerData.job.onDuty = value
end)

local function isPlayerPolice()
    return KKF.PlayerData.job.name == 'police' and KKF.PlayerData.job.onDuty
end

RegisterNetEvent("platecheck:frontradar")
AddEventHandler("platecheck:frontradar", function()
    TriggerServerEvent('checkLicensePlate',radarInfo.frontPlate)
end)

RegisterNetEvent("platecheck:rearradar")
AddEventHandler("platecheck:rearradar", function()
    TriggerServerEvent('checkLicensePlate',radarInfo.rearPlate)
end)

-- Utility functions
local function round(num)
    return tonumber(string.format('%.0f', num))
end

local function oppang(ang)
    return (ang + 180) % 360 
end 

local function FormatSpeed(speed)
    return string.format('%03d', speed)
end 

local function GetVehicleInDirectionSphere(entFrom, coordFrom, coordTo)
    local rayHandle = StartShapeTestCapsule(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 2.0, 10, entFrom, 7)
    local _, _, _, _, vehicle = GetShapeTestResult(rayHandle)
    return vehicle
end

local function IsEntityInMyHeading(myAng, tarAng, range)
    local rangeStartFront = myAng - (range / 2)
    local rangeEndFront = myAng + (range / 2)
    local opp = oppang(myAng)
    local rangeStartBack = opp - (range / 2)
    local rangeEndBack = opp + (range / 2)

    if (tarAng > rangeStartFront) and (tarAng < rangeEndFront) then 
        return true 
    elseif (tarAng > rangeStartBack) and (tarAng < rangeEndBack) then 
        return false 
    else 
        return nil 
    end 
end 

RegisterNetEvent('platecheck:frontradar')
AddEventHandler('platecheck:frontradar', function()
    TriggerServerEvent('checkLicensePlate', radarInfo.frontPlate)
end)

RegisterNetEvent('platecheck:rearradar')
AddEventHandler('platecheck:rearradar', function()
    TriggerServerEvent('checkLicensePlate', radarInfo.rearPlate)
end)

RegisterNetEvent('updateHotPlates')
AddEventHandler('updateHotPlates', function(newPlates, newReasons)
    hotPlates, hotPlatesReason = newPlates, newReasons
end)

function isHotVehicle(plate)
    if hotPlates[string.upper(plate)] ~= nil or hotPlates[string.lower(plate)] ~= nil or hotPlates[plate] ~= nil then
        return true
    else
        return false
    end
end

-- Radar control functions
local function ResetFrontAntenna()
    if radarInfo.fwdXmit then 
        radarInfo.fwdSpeed, radarInfo.fwdFast = '000', '000'
    else 
        radarInfo.fwdSpeed, radarInfo.fwdFast = 'OFF', -1
    end 
    radarInfo.fwdDir, radarInfo.fwdFastSpeed, radarInfo.fwdFastLocked = nil, -1, false
end 

local function ResetRearAntenna()
    if radarInfo.bwdXmit then
        radarInfo.bwdSpeed, radarInfo.bwdFast = '000', '000'
    else 
        radarInfo.bwdSpeed, radarInfo.bwdFast = 'OFF', -1
    end 
    radarInfo.bwdDir, radarInfo.bwdFastSpeed, radarInfo.bwdFastLocked = nil, -1, false
end 

local function ResetFrontFast()
    if radarInfo.fwdXmit then 
        radarInfo.fwdFast, radarInfo.fwdFastSpeed, radarInfo.fwdFastLocked = '000', -1, false
        SendNUIMessage({ lockfwdfast = false })
    end 
end 

local function ResetRearFast()
    if radarInfo.bwdXmit then 
        radarInfo.bwdFast, radarInfo.bwdFastSpeed, radarInfo.bwdFastLocked = '000', -1, false
        SendNUIMessage({ lockbwdfast = false })
    end 
end 

local function CloseRadarRC()
    SendNUIMessage({ toggleradarrc = true })
    TriggerEvent('wk:toggleMenuControlLock', false)
    SetNuiFocus(false)
end 

local function ToggleLockBeep()
    radarInfo.lockBeep = not radarInfo.lockBeep
    TriggerEvent('KKF.UI.ShowNotification', 'info', 'Radari teatis ' .. (radarInfo.lockBeep and 'sisselülitatud' or 'väljalülitatud') .. '.')
end 

local function GetVehSpeed(veh)
    return GetEntitySpeed(veh) * 2.236936
end 

local function drawTxt(x, y, width, height, scale, text, r, g, b, a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry('STRING')
    AddTextComponentString(text)
    DrawText(x, y)
end

local function ManageVehicleRadar()
    if not radarEnabled then return end
    if not cache.vehicle then return end
    if cache.seat ~= -1 and cache.seat ~= 0 then return end
    
    -- Patrol speed 
    local vehicleSpeed = round(GetVehSpeed(cache.vehicle), 0)
    radarInfo.patrolSpeed = FormatSpeed(vehicleSpeed)

    -- Rest of the radar options 
    local vehiclePos = GetEntityCoords(cache.vehicle, true)
    local h = round(GetEntityHeading(cache.vehicle), 0)

    -- Front Antenna 
    if radarInfo.fwdXmit then  
        local forwardPosition = GetOffsetFromEntityInWorldCoords(cache.vehicle, radarInfo.angles[radarInfo.fwdMode].x, radarInfo.angles[radarInfo.fwdMode].y, radarInfo.angles[radarInfo.fwdMode].z)
        local fwdPos = { x = forwardPosition.x, y = forwardPosition.y, z = forwardPosition.z }
        local _, fwdZ = GetGroundZFor_3dCoord(fwdPos.x, fwdPos.y, fwdPos.z + 500.0)
        fwdPos.z = math.min(fwdPos.z, fwdZ + 0.5)

        local packedFwdPos = vector3(fwdPos.x, fwdPos.y, fwdPos.z)
        local fwdVeh = GetVehicleInDirectionSphere(cache.vehicle, vehiclePos, packedFwdPos)

        if DoesEntityExist(fwdVeh) and IsEntityAVehicle(fwdVeh) then 
            local fwdVehSpeed = round(GetVehSpeed(fwdVeh), 0)
            local fwdVehHeading = round(GetEntityHeading(fwdVeh), 0)
            local dir = IsEntityInMyHeading(h, fwdVehHeading, 100)

            radarInfo.fwdSpeed = FormatSpeed(fwdVehSpeed)
            radarInfo.fwdDir = dir 

            if fwdVehSpeed > radarInfo.fastLimit and not radarInfo.fwdFastLocked and not lockplates then 
                if radarInfo.lockBeep then 
                    PlaySoundFrontend(-1, 'Beep_Red', 'DLC_HEIST_HACKING_SNAKE_SOUNDS', 1)
                end 

                radarInfo.fwdFastSpeed, radarInfo.fwdFastLocked = fwdVehSpeed, true 
                radarInfo.frontPlate = GetVehicleNumberPlateText(fwdVeh) 
                SendNUIMessage({ lockfwdfast = true })
            elseif fwdVehSpeed > radarInfo.fwdFastSpeed and not lockplates then
                radarInfo.fwdFastSpeed = fwdVehSpeed
                radarInfo.frontPlate = GetVehicleNumberPlateText(fwdVeh) 
            end

            radarInfo.fwdFast = FormatSpeed(radarInfo.fwdFastSpeed)
            radarInfo.fwdPrevVeh = fwdVeh 
        end
    end 

    -- Rear Antenna 
    if radarInfo.bwdXmit then 
        local backwardPosition = GetOffsetFromEntityInWorldCoords(cache.vehicle, radarInfo.angles[radarInfo.bwdMode].x, -radarInfo.angles[radarInfo.bwdMode].y, radarInfo.angles[radarInfo.bwdMode].z)
        local bwdPos = { x = backwardPosition.x, y = backwardPosition.y, z = backwardPosition.z }
        local _, bwdZ = GetGroundZFor_3dCoord(bwdPos.x, bwdPos.y, bwdPos.z + 500.0)
        bwdPos.z = math.min(bwdPos.z, bwdZ + 0.5)

        local packedBwdPos = vector3(bwdPos.x, bwdPos.y, bwdPos.z)                
        local bwdVeh = GetVehicleInDirectionSphere(cache.vehicle, vehiclePos, packedBwdPos)

        if DoesEntityExist(bwdVeh) and IsEntityAVehicle(bwdVeh) then
            local bwdVehSpeed = round(GetVehSpeed(bwdVeh), 0)
            local bwdVehHeading = round(GetEntityHeading(bwdVeh), 0)
            local dir = IsEntityInMyHeading(h, bwdVehHeading, 100)

            radarInfo.bwdSpeed = FormatSpeed(bwdVehSpeed)
            radarInfo.bwdDir = dir 

            if bwdVehSpeed > radarInfo.fastLimit and not radarInfo.bwdFastLocked and not lockplates then 
                if radarInfo.lockBeep then 
                    PlaySoundFrontend(-1, 'Beep_Red', 'DLC_HEIST_HACKING_SNAKE_SOUNDS', 1)
                end 

                radarInfo.bwdFastSpeed, radarInfo.bwdFastLocked = bwdVehSpeed, true 
                radarInfo.rearPlate = GetVehicleNumberPlateText(bwdVeh)
                SendNUIMessage({ lockbwdfast = true })
            elseif bwdVehSpeed > radarInfo.bwdFastSpeed and not lockplates then
                radarInfo.rearPlate = GetVehicleNumberPlateText(bwdVeh)
                radarInfo.bwdFastSpeed = bwdVehSpeed 
            end

            radarInfo.bwdFast = FormatSpeed(radarInfo.bwdFastSpeed)
            radarInfo.bwdPrevVeh = bwdVeh 
        end  
    end  

    SendNUIMessage({
        patrolspeed = radarInfo.patrolSpeed, 
        fwdspeed = radarInfo.fwdSpeed, 
        fwdfast = radarInfo.fwdFast, 
        fwddir = radarInfo.fwdDir, 
        bwdspeed = radarInfo.bwdSpeed, 
        bwdfast = radarInfo.bwdFast, 
        bwddir = radarInfo.bwdDir 
    })
end 

RegisterNetEvent('startSpeedo')
AddEventHandler('startSpeedo', function()
    if cache.vehicle then 
        radarEnabled = not radarEnabled
        TriggerEvent('KKF.UI.ShowNotification', 'info', radarEnabled and 'Radar sisselülitatud.' or 'Radar väljalülitatud.')
        ResetFrontAntenna()
        ResetRearAntenna()
        SendNUIMessage({
            toggleradar = true, 
            fwdxmit = radarInfo.fwdXmit, 
            fwdmode = radarInfo.fwdMode, 
            bwdxmit = radarInfo.bwdXmit, 
            bwdmode = radarInfo.bwdMode
        })
    end
end)

RegisterNetEvent('wk:disableRadar')
AddEventHandler('wk:disableRadar', function()
    radarEnabled = false
    SendNUIMessage({ disableRadar = true })
end)

RegisterNetEvent('wk:toggleRadar')
AddEventHandler('wk:toggleRadar', function()
    if cache.vehicle then 
        radarEnabled = not radarEnabled
        TriggerEvent('KKF.UI.ShowNotification', 'info', radarEnabled and 'Radar sisselülitatud.' or 'Radar väljalülitatud.')
        ResetFrontAntenna()
        ResetRearAntenna()
        SendNUIMessage({
            toggleradar = true, 
            fwdxmit = radarInfo.fwdXmit, 
            fwdmode = radarInfo.fwdMode, 
            bwdxmit = radarInfo.bwdXmit, 
            bwdmode = radarInfo.bwdMode
        })
    else 
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ei ole ühesgi sõidukis.')
    end 
end)

RegisterNetEvent('wk:changeRadarLimit')
AddEventHandler('wk:changeRadarLimit', function(speed)
    radarInfo.fastLimit = speed
    saveSettings()
end)

RegisterNetEvent('kk-radar:client:openRadar', function()
    Wait(10)
    TriggerEvent('wk:toggleMenuControlLock', true)
    SendNUIMessage({ toggleradarrc = true })
    SetNuiFocus(true, true)
end)

RegisterNUICallback('RadarRC', function(data, cb)
    if data == 'radar_toggle' then 
        TriggerEvent('wk:toggleRadar')
    elseif data == 'radar_frontopp' and radarInfo.fwdXmit then
        radarInfo.fwdMode = 'opp'
        SendNUIMessage({ fwdmode = radarInfo.fwdMode })
    elseif data == 'radar_frontxmit' then 
        radarInfo.fwdXmit = not radarInfo.fwdXmit 
        ResetFrontAntenna()
        SendNUIMessage({ fwdxmit = radarInfo.fwdXmit })
        radarInfo.fwdMode = radarInfo.fwdXmit and 'same' or 'none'
        SendNUIMessage({ fwdmode = radarInfo.fwdMode })
    elseif data == 'radar_frontsame' and radarInfo.fwdXmit then 
        radarInfo.fwdMode = 'same'
        SendNUIMessage({ fwdmode = radarInfo.fwdMode })
    elseif data == 'radar_rearopp' and radarInfo.bwdXmit then
        radarInfo.bwdMode = 'opp'
        SendNUIMessage({ bwdmode = radarInfo.bwdMode })
    elseif data == 'radar_rearxmit' then 
        radarInfo.bwdXmit = not radarInfo.bwdXmit 
        ResetRearAntenna()
        SendNUIMessage({ bwdxmit = radarInfo.bwdXmit })
        radarInfo.bwdMode = radarInfo.bwdXmit and 'same' or 'none'
        SendNUIMessage({ bwdmode = radarInfo.bwdMode })
    elseif data == 'radar_rearsame' and radarInfo.bwdXmit then 
        radarInfo.bwdMode = 'same'
        SendNUIMessage({ bwdmode = radarInfo.bwdMode })
    elseif data == 'radar_lockbeep' then 
        ToggleLockBeep()
    elseif data == 'close' then 
        CloseRadarRC()
    end

    saveSettings()

    if cb then cb('ok') end 
end)

RegisterNUICallback('setFastLimit', function(data)
    local speed = tonumber(data)

    if speed < 999 and speed > 1 then 
        TriggerEvent('wk:changeRadarLimit', speed)
        TriggerEvent('KKF.UI.ShowNotification', 'info', 'Kiirus uuendatud!')
    else
        SendNUIMessage({ fastLimit = radarInfo.fastLimit })
        TriggerEvent('wk:changeRadarLimit', radarInfo.fastLimit)
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ebasobiv kiirus!')
    end 
end)

CreateThread(function()
    SetNuiFocus(false) 

    while true do 
        ManageVehicleRadar()
        Wait(200)
    end
end)

RegisterNetEvent('radar:alarm')
AddEventHandler('radar:alarm', function()
    for i = 1, 2 do
        PlaySoundFrontend(-1, 'Beep_Green', 'DLC_HEIST_HACKING_SNAKE_SOUNDS', 1)
        Wait(100)
        PlaySoundFrontend(-1, 'Beep_Red', 'DLC_HEIST_HACKING_SNAKE_SOUNDS', 1)
        Wait(100)
    end
end)

CreateThread(function()
    local oldStolenFP, oldStolenRP = '', ''

    while true do 
        if cache.vehicle then
            if radarEnabled and (cache.seat == -1 or  cache.seat == 0) then
                local fp, rp = radarInfo.frontPlate, radarInfo.rearPlate

                if isHotVehicle(fp) then
                    fp = fp:gsub('0', 'Ø')

                    if fp ~= oldStolenFP then
                        oldStolenFP = fp
                        TriggerEvent('radar:alarm')
                        SendNUIMessage({ frontchange = true, plate = fp })
                    else
                        SendNUIMessage({ frontchange = true, plate = fp })
                    end
                else
                    fp = fp:gsub('0', 'Ø')
                    SendNUIMessage({ frontchange = true, plate = fp })
                end

                if isHotVehicle(rp) then
                    rp = rp:gsub('0', 'Ø')

                    if rp ~= oldStolenRP then
                        oldStolenRP = rp
                        TriggerEvent('radar:alarm')
                        SendNUIMessage({ rearchange = true, plate = rp })
                    else
                        SendNUIMessage({ rearchange = true, plate = rp })
                    end
                else
                    rp = rp:gsub('0', 'Ø')
                    SendNUIMessage({ rearchange = true, plate = rp })
                end    
            end
        end
        Wait(100)
    end 
end)

CreateThread(function()
    while true do 
        if cache.vehicle and (cache.seat == -1 or cache.seat == 0) then
            if IsDisabledControlPressed(1, 36) and IsDisabledControlJustPressed(1, 243) and cache.vehicle and isPlayerPolice() then 
                lockplates = not lockplates

                SendNUIMessage({ manuallock = true, status = lockplates })
                TriggerEvent('KKF.UI.ShowNotification', 'info', lockplates and 'Radar lukustatud' or 'Radari lukustus eemaldatud')
            end 

            if not IsDisabledControlPressed(1, 36) and IsDisabledControlJustPressed(1, 243) and cache.vehicle and isPlayerPolice() then 
                ResetFrontFast()
                ResetRearFast()
                TriggerEvent('KKF.UI.ShowNotification', 'info', 'Lockfast resetitud')
            end 

            if radarEnabled and hidden then 
                hidden = false 
                SendNUIMessage({ hideradar = false })
            end
        else
            if (IsPauseMenuActive() and radarEnabled) or (not cache.vehicle and radarEnabled) then 
                hidden = true 
                SendNUIMessage({ hideradar = true })
            end 

            Wait(1100)
        end

        Wait(1)
    end 
end)

-- Menu control lock
local locked = false 
RegisterNetEvent('wk:toggleMenuControlLock')
AddEventHandler('wk:toggleMenuControlLock', function(lock)
    locked = lock 
end)

CreateThread(function()
    while true do
        if locked then 
            Wait(0)

            DisableControlAction(0, 1, true) -- LookLeftRight
            DisableControlAction(0, 2, true) -- LookUpDown
            DisableControlAction(0, 24, true) -- Attack
            DisablePlayerFiring(cache.ped, true) -- Disable weapon firing
            DisableControlAction(0, 142, true) -- MeleeAttackAlternate
            DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
            SetPauseMenuActive(false)
        else
            Wait(100)
        end
    end 
end)
