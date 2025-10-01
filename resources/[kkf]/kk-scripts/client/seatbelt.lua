local seatbeltOn = false
local harnessOn = false
local harnessHp = 20
local handbrake = 0
local sleep = 0
local harnessData = {}
local SpeedBuffer = {}
local vehVelocity = {x = 0.0, y = 0.0, z = 0.0}
local newvehicleBodyHealth = 0
local newvehicleEngineHealth = 0
local currentvehicleEngineHealth = 0
local currentvehicleBodyHealth = 0
local frameBodyChange = 0
local frameEngineChange = 0
local lastFrameVehiclespeed = 0
local lastFrameVehiclespeed2 = 0
local thisFrameVehicleSpeed = 0
local tick = 0
local damagedone = false
local modifierDensity = true

exports('seatbeltStatus', function()
    return seatbeltOn
end)

-- Register Key

RegisterNetEvent('kk-scripts:client:setSeatbelt', function()
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        local class = GetVehicleClass(GetVehiclePedIsUsing(PlayerPedId()))
        
        if class ~= 8 and class ~= 13 and class ~= 14 then
            ToggleSeatbelt()
        end
    end
end)

RegisterCommand('toggleseatbelt', function()
    TriggerEvent('kk-scripts:client:setSeatbelt')
end, false)

RegisterKeyMapping('toggleseatbelt', 'Turvavöö', 'keyboard', 'B')

-- Events

RegisterNetEvent('seatbelt:client:UseHarness', function(ItemData) -- On Item Use (registered server side)
    local ped = PlayerPedId()
    local inveh = IsPedInAnyVehicle(ped, false)
    local class = GetVehicleClass(GetVehiclePedIsUsing(ped))
    if inveh and class ~= 8 and class ~= 13 and class ~= 14 then
        if not harnessOn then
			local progress = true

            LocalPlayer.state:set("inv_busy", true, true)

			if progress then
                LocalPlayer.state:set("inv_busy", false, true)
                ToggleHarness()
                TriggerServerEvent('equip:harness', ItemData)
            end

            harnessHp = ItemData.info.uses
            harnessData = ItemData
        else
			local progress = true

            LocalPlayer.state:set("inv_busy", true, true)

			if progress then
                LocalPlayer.state:set("inv_busy", false, true)
                ToggleHarness()
            end
        end
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ei ole sõidukis!')
    end
end)

Citizen.CreateThread(function() -- Holding weapon
    while true do
        if LocalPlayer.state.isLoggedIn then
            if IsPedArmed(cache.ped, 4) then
                if GetSelectedPedWeapon(cache.ped) ~= `WEAPON_ANTIDOTE` and GetSelectedPedWeapon(cache.ped) ~= `WEAPON_PEPPERSPRAY` then
                    TriggerEvent('kk-needs:client:addNeed', 'stress', math.random(150, 700))
                end
            end
        end

        Wait(10000)
    end
end)

Citizen.CreateThread(function()  -- Shooting
    while true do
        if LocalPlayer.state.isLoggedIn then
            if IsPedShooting(cache.ped) and not IsPedCurrentWeaponSilenced(cache.ped) then
                if GetSelectedPedWeapon(cache.ped) ~= `WEAPON_ANTIDOTE` and GetSelectedPedWeapon(cache.ped) ~= `WEAPON_PEPPERSPRAY` then
                    TriggerEvent('kk-needs:client:addNeed', 'stress', math.random(300, 900))
                end
            end
        end

        Wait(10000)
    end
end)

-- Functions

function ToggleSeatbelt()
    if seatbeltOn then
        seatbeltOn = false
        TriggerEvent("kkf:ui:seatBelt", false)
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "seatbeltoff", 0.25)
    else
        seatbeltOn = true
        TriggerEvent("kkf:ui:seatBelt", true)
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "seatbelt", 0.25)
    end
end

function ToggleHarness()
    if harnessOn then
        harnessOn = false
    else
        harnessOn = true
        ToggleSeatbelt()
    end
end

function ResetHandBrake()
    if handbrake > 0 then
        handbrake = handbrake - 1
    end
end

-- Export

function HasHarness()
    return harnessOn
end

-- Main Thread

CreateThread(function()
    while true do
        sleep = 1000

        if IsPedInAnyVehicle(PlayerPedId()) then
            sleep = 10
            
            if seatbeltOn or harnessOn then
                DisableControlAction(0, 75, true)
                DisableControlAction(27, 75, true)
            end
        else
            seatbeltOn = false
            harnessOn = false
        end
        
        Wait(sleep)
    end
end)