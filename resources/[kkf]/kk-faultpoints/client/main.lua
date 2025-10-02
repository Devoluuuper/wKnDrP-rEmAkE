local CurrentAction = nil
local CurrentTest = nil
local CurrentTestType = nil
local CurrentVehicle = nil
local CurrentCheckPoint = 0
local LastCheckPoint = -1
local CurrentBlip = nil
local CurrentZoneType = nil
local IsAboveSpeedLimit = false
local LastVehicleHealth = nil

local ped = {}

CreateThread(function()
    KKF.PlayerData = KKF.GetPlayerData()
end)

function DrawMissionText(msg, time)
    TriggerEvent('KKF.UI.ShowNotification', 'info', msg)
end

RegisterNetEvent('kk-faultpoints:client:startExam')
AddEventHandler('kk-faultpoints:client:startExam', function()
    StartDriveTest('drive')
end)

RegisterNetEvent('KKF.Player.ReloadLicenses')
AddEventHandler('KKF.Player.ReloadLicenses', function(licenses)
	KKF.PlayerData.licenses = licenses
end)

local function loadAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Wait(5)
	end
end

local function registerPeds()
    SetTimeout(5000, function()
        lib.requestModel(`mp_m_securoguard_01`)
        local entity = CreatePed(4, `mp_m_securoguard_01`, Config.Ped.x, Config.Ped.y, Config.Ped.z - 1, Config.Ped.w or 0, false, false)

        SetBlockingOfNonTemporaryEvents(entity, true)
        SetPedDiesWhenInjured(entity, false)
        SetPedCanPlayAmbientAnims(entity, true)
        SetPedCanRagdollFromPlayerImpact(entity, false)
        SetEntityInvincible(entity, true)
        FreezeEntityPosition(entity, true)

        loadAnimDict('missfam4')
        TaskPlayAnim(entity, 'missfam4', 'base', 8.0, 1.0, -1, 49, 0, 0, 0, 0)

        local newProp = CreateObject(`p_amb_clipboard_01`, GetEntityCoords(entity).x, GetEntityCoords(entity).y, GetEntityCoords(entity).z + 0.2, false, false, false)

        while not DoesEntityExist(newProp) do Wait(50) end

        SetEntityCollision(newProp, false, false)
        AttachEntityToEntity(newProp, entity, GetPedBoneIndex(entity, 36029), 0.16, 0.08, 0.1, -130.0, -50.0, 0.0, true, true, false, true, 1, true)

        ped = {entity = entity, prop = newProp}

        exports.ox_target:addLocalEntity(entity, {
            {
                name = 'faultpoints',
                distance = 1.5,
                serverEvent = 'kk-faultpoints:server:startExam',
                icon = 'fab fa-creative-commons-nd',
                label = 'Lunasta veapunkte'
            }
        })
    end)
end

local function deRegisterPeds()
    exports.ox_target:removeLocalEntity(ped.entity, {'faultpoints'})
    DeleteEntity(ped.prop); DeleteEntity(ped.entity); ped = nil
end

RegisterNetEvent('KKF.Player.Loaded', function(playerData)
	KKF.PlayerData = playerData; registerPeds()
end)

RegisterNetEvent('KKF.Player.Unloaded', function()
	KKF.PlayerData = {}; deRegisterPeds()

    KKF.Game.DeleteEntity(CurrentVehicle)
end)

function StartDriveTest(type)
    lib.requestModel(Config.Vehicle)
    local entity = CreateVehicle(Config.Vehicle, vec3(Config.Spawn.x, Config.Spawn.y, Config.Spawn.z), Config.Spawn.h, true, false)
    local plate = 'KOOL' .. math.random(1111, 9999)

    SetVehicleNumberPlateText(entity, plate)
    SetVehicleOnGroundProperly(entity)
    SetVehicleEngineOn(entity, true, true, true)
    SetVehicleDoorsLocked(entity, false)
    TaskWarpPedIntoVehicle(cache.ped, entity, -1)
    Entity(entity).state:set('fuel', 100, true)
    -- exports["cdn-fuel"]:SetFuel(entity, 100)
    Entity(entity).state:set('spawned', true, true)
    TriggerEvent('kk-scripts:client:newKey', plate)
    -- exports['kk-vehicles']:addKey(plate)

    CurrentTest = 'drive'
    CurrentTestType = type
    CurrentCheckPoint = 0
    LastCheckPoint = -1
    CurrentZoneType = 'town'
    IsAboveSpeedLimit = false
    CurrentVehicle = entity
    LastVehicleHealth = GetEntityHealth(entity)
end

function StopDriveTest(success)
    if not success then
        TriggerEvent("chatMessage", "INDULGENTS", 'error', 'Sa ei läbinud ringigi!')
        return
    end

    TriggerServerEvent('kk-faultpoints:server:complete')
    TriggerEvent("chatMessage", "INDULGENTS", 'success', 'Läbisid ühe ringi, sõbrake! Sult eemaldati 1 veapunkt ning põletasite ' ..  math.random(11, 49) .. ' kalorit.')

    CurrentTest = nil
    CurrentTestType = nil
end

exports('drivingTest', function()
    return CurrentTest
end)

function SetCurrentZoneType(type)
    CurrentZoneType = type
end

-- Create Blips
CreateThread(function()
    local blip = AddBlipForCoord(Config.Ped)

    SetBlipSprite(blip, 84)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.7)
    SetBlipColour(blip, 76)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Indulgents')
    EndTextCommandSetBlipName(blip)
end)
  
-- Drive test
CreateThread(function()
    while true do
        Wait(5)

        if CurrentTest == 'drive' then
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            local nextCheckPoint = CurrentCheckPoint + 1

            if Config.CheckPoints[nextCheckPoint] == nil then
                CurrentTest = nil
            else
                if cache.vehicle then
                    if GetVehicleNumberPlateText(cache.vehicle):find('KOOL') then
                        if CurrentCheckPoint ~= LastCheckPoint then
                            SetNewWaypoint(Config.CheckPoints[nextCheckPoint].Pos.x, Config.CheckPoints[nextCheckPoint].Pos.y)
                            LastCheckPoint = CurrentCheckPoint
                        end

                        local distance = GetDistanceBetweenCoords(coords, Config.CheckPoints[nextCheckPoint].Pos.x, Config.CheckPoints[nextCheckPoint].Pos.y, Config.CheckPoints[nextCheckPoint].Pos.z, true)

                        if distance <= 100.0 then
                            DrawMarker(1, Config.CheckPoints[nextCheckPoint].Pos.x, Config.CheckPoints[nextCheckPoint].Pos.y, (Config.CheckPoints[nextCheckPoint].Pos.z - 1), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 255, 255, 255, false, true, 2, false, false, false, false)
                        end

                        if distance <= 3.0 then
                            Config.CheckPoints[nextCheckPoint].Action(playerPed, CurrentVehicle, SetCurrentZoneType)
                            CurrentCheckPoint = CurrentCheckPoint + 1
                        end
                    end
                end 
            end
        else
            -- not currently taking driver test
            Wait(500)
        end
    end
end)