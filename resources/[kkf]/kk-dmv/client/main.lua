 local CurrentAction = nil
local CurrentTest = nil
local CurrentTestType = nil
local CurrentVehicle = nil
local CurrentCheckPoint = 0
local DriveErrors = 0
local LastCheckPoint = -1
local CurrentBlip = nil
local CurrentZoneType = nil
local IsAboveSpeedLimit = false
local LastVehicleHealth = nil

CreateThread(function()
    KKF.PlayerData = KKF.GetPlayerData()
end)

function DrawMissionText(msg, time)
    TriggerEvent('KKF.UI.ShowNotification', 'info', msg)
end

RegisterNetEvent('kk-dmv:client:startExam')
AddEventHandler('kk-dmv:client:startExam', function()
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
        lib.requestModel(`a_m_m_business_01`)
        local entity = CreatePed(4, `a_m_m_business_01`, Config.Ped.x, Config.Ped.y, Config.Ped.z - 1, Config.Ped.w or 0, false, false)

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
                name = 'dmv',
                distance = 1.5,
                onSelect = function()
                    if not KKF.PlayerData.licenses['dmv'] then
                        lib.registerContext({
                            id = 'dmv_menu',
                            title = 'Autokool',
                            options = {
                                ['Alusta sõidueksamit'] = {
                                    -- description = 'Maksumus: $' .. Config.Price .. ' + VAT ' .. exports['kk-taxes']:getTax('primary').value .. '%',
                                    description = 'Maksumus: $' .. Config.Price,
                                    serverEvent = 'kk-dmv:server:startExam'
                                }
                            }
                        })

                        lib.showContext('dmv_menu')
                    else
                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te juba omate juhilube!')
                    end
                end,
                icon = 'fa-solid fa-car',
                label = 'Autokool'
            }
        })
    end)
end
local function deRegisterPeds()
    exports.ox_target:removeLocalEntity(ped.entity, {'dmv'})
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
    local triedSpawnPoints = {}
    local spawnPoint = nil
    local success = nil

    while true do
        local spawnID = math.random(#Config.Spawns)
        local spawn = Config.Spawns[spawnID]
        local isClear = KKF.Game.IsSpawnPointClear(spawn, 2.5)

        if isClear then
            success = true
            spawnPoint = spawn
            break
        else
            triedSpawnPoints[spawnID] = true
            success = false
        end

        if #triedSpawnPoints == #Config.Spawns then
            success = false;
            TriggerEvent('KKF.UI.ShowNotification',"error", "Parklas pole ühtegi vaba parkimiskohta.")
            break
        end

        Wait(50)
    end

    if success then
        lib.requestModel(Config.Vehicle)
        local entity = CreateVehicle(Config.Vehicle, vec3(spawnPoint.x, spawnPoint.y, spawnPoint.z), spawnPoint.h, true, false)
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
    
        CurrentTest = 'drive'
        CurrentTestType = type
        CurrentCheckPoint = 0
        LastCheckPoint = -1
        CurrentZoneType = 'town'
        DriveErrors = 0
        IsAboveSpeedLimit = false
        CurrentVehicle = entity
        LastVehicleHealth = GetEntityHealth(entity)
    end
end

function StopDriveTest(success)
    if not success then
        TriggerEvent("chatMessage", "EKSAMIKESKUS", 4, 'Kahjuks ei läbinud sa eksamit! Soovi korral saad uuesti proovida.')
        return
    end

    TriggerServerEvent('kk-dmv:server:complete')
    TriggerEvent("chatMessage", "EKSAMIKESKUS", 4, 'Läbisid edukalt eksami - Juhiluba lisati teile digitaalselt.')

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

    SetBlipSprite(blip, 408)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.7)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Autokool')
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
                if DoesBlipExist(CurrentBlip) then
                    RemoveBlip(CurrentBlip)
                end

                CurrentTest = nil

                if DriveErrors < Config.MaxErrors then
                    StopDriveTest(true)
                else
                    StopDriveTest(false)
                end
            else
                if cache.vehicle then
                    if GetVehicleNumberPlateText(cache.vehicle):find('KOOL') then
                        if CurrentCheckPoint ~= LastCheckPoint then
                            if DoesBlipExist(CurrentBlip) then
                                RemoveBlip(CurrentBlip)
                            end

                            CurrentBlip = AddBlipForCoord(Config.CheckPoints[nextCheckPoint].Pos.x, Config.CheckPoints[nextCheckPoint].Pos.y, Config.CheckPoints[nextCheckPoint].Pos.z)
                            SetBlipRoute(CurrentBlip, 1)

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

-- Speed / Damage control
CreateThread(function()
    while true do
        Wait(100)
        if CurrentTest == 'drive' then

            local playerPed = PlayerPedId()
            if IsPedInAnyVehicle(playerPed, false) then

                local vehicle = GetVehiclePedIsIn(playerPed, false)
                local speed = GetEntitySpeed(vehicle) * Config.SpeedMultiplier
                local tooMuchSpeed = false

                for k, v in pairs(Config.SpeedLimits) do
                    if CurrentZoneType == k and speed > v then
                        tooMuchSpeed = true

                        if not IsAboveSpeedLimit then
                            DriveErrors = DriveErrors + 1
                            IsAboveSpeedLimit = true

                            TriggerEvent('KKF.UI.ShowNotification', 'error', string.format('Ületasid kiirust! Eksimuste arv: %d/%d', DriveErrors, Config.MaxErrors))
                        end
                    end
                end

                if not tooMuchSpeed then
                    IsAboveSpeedLimit = false
                end

                local health = GetEntityHealth(vehicle)
                if health < LastVehicleHealth then

                    DriveErrors = DriveErrors + 1

                    TriggerEvent('KKF.UI.ShowNotification', 'error', string.format('Vigastasid sõidukit! Eksimuste arv: %d/%d', DriveErrors, Config.MaxErrors))

                    -- avoid stacking faults
                    LastVehicleHealth = health
                    Wait(1500)
                end
            end
        else
            -- not currently taking driver test
            Wait(500)
        end
    end
end)
