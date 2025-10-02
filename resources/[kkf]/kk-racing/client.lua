-----------------------
----   Variables   ----
-----------------------
local Countdown = 10
local ToFarCountdown = 10
local FinishedUITimeout = false

local RaceData = {
    InCreator = false,
    InRace = false,
    ClosestCheckpoint = 0,
}

local CreatorData = {
    RaceName = nil,
    RacerName = nil,
    Checkpoints = {},
    TireDistance = 3.0,
    ConfirmDelete = false,
}

local CurrentRaceData = {
    RaceId = nil,
    RaceName = nil,
    RacerName = nil,
    Checkpoints = {},
    Started = false,
    CurrentCheckpoint = nil,
    TotalLaps = 0,
    Lap = 0,
}


-----------------------
----   Functions   ----
-----------------------

function DeleteClosestObject(coords, model)
    local Obj = GetClosestObjectOfType(coords.x, coords.y, coords.z, 5.0, model, 0, 0, 0)
    DeleteObject(Obj)
    ClearAreaOfObjects(coords.x, coords.y, coords.z, 50.0, 0)
end

function CreatePile(offset, model)
    if CurrentRaceData.pilesEnabled then
        ClearAreaOfObjects(offset.x, offset.y, offset.z, 50.0, 0)
        lib.requestModel(model)

        local Obj = CreateObject(model, offset.x, offset.y, offset.z, 0, 0, 0)
        SetEntityCollision(Obj, false, false)
        PlaceObjectOnGroundProperly(Obj)
        FreezeEntityPosition(Obj, false)
        SetEntityAsMissionEntity(Obj, true, true)

        return Obj
    end
end

function DeleteAllCheckpoints()
    for k, v in pairs(CreatorData.Checkpoints) do
        local CurrentCheckpoint = CreatorData.Checkpoints[k]

        if CurrentCheckpoint then
            local LeftPile = CurrentCheckpoint.pileleft
            local RightPile = CurrentCheckpoint.pileright

            if LeftPile then
                DeleteClosestObject(CurrentCheckpoint.offset.left, Config.CheckpointPileModel)
                LeftPile = nil
            end
            if RightPile then
                DeleteClosestObject(CurrentCheckpoint.offset.right, Config.CheckpointPileModel)
                RightPile = nil
            end
        end
    end

    for k, v in pairs(CurrentRaceData.Checkpoints) do
        local CurrentCheckpoint = CurrentRaceData.Checkpoints[k]

        if CurrentCheckpoint then
            local LeftPile = CurrentCheckpoint.pileleft
            local RightPile = CurrentCheckpoint.pileright

            if LeftPile then
                DeleteClosestObject(CurrentRaceData.Checkpoints[k].offset.left, Config.CheckpointPileModel)
                LeftPile = nil
            end

            if RightPile then
                DeleteClosestObject(CurrentRaceData.Checkpoints[k].offset.right, Config.CheckpointPileModel)
                RightPile = nil
            end
        end
    end
end

function DeleteCheckpoint()
    local NewCheckpoints = {}
    if RaceData.ClosestCheckpoint ~= 0 then
        local ClosestCheckpoint = CreatorData.Checkpoints[RaceData.ClosestCheckpoint]

        if ClosestCheckpoint then
            local Blip = ClosestCheckpoint.blip
            if Blip then
                RemoveBlip(Blip)
                Blip = nil
            end

            local PileLeft = ClosestCheckpoint.pileleft
            if PileLeft then
                DeleteClosestObject(ClosestCheckpoint.offset.left, Config.CheckpointPileModel)
                PileLeft = nil
            end

            local PileRight = ClosestCheckpoint.pileright
            if PileRight then
                DeleteClosestObject(ClosestCheckpoint.offset.right, Config.CheckpointPileModel)
                PileRight = nil
            end

            for id, data in pairs(CreatorData.Checkpoints) do
                if id ~= RaceData.ClosestCheckpoint then
                    NewCheckpoints[#NewCheckpoints+1] = data
                end
            end
            CreatorData.Checkpoints = NewCheckpoints
        else
            TriggerEvent('KKF.UI.ShowNotificaiton', 'error', 'Te ei saa nii kiiresti sõita!')
        end
    else
        TriggerEvent('KKF.UI.ShowNotificaiton', 'error', 'Te ei saa nii kiiresti sõita!')
    end
end

function DeleteCreatorCheckpoints()
    for id,_ in pairs(CreatorData.Checkpoints) do
        local CurrentCheckpoint = CreatorData.Checkpoints[id]

        local Blip = CurrentCheckpoint.blip
        if Blip then
            RemoveBlip(Blip)
            Blip = nil
        end

        if CurrentCheckpoint then
            local PileLeft = CurrentCheckpoint.pileleft
            if PileLeft then
                DeleteClosestObject(CurrentCheckpoint.offset.left, Config.CheckpointPileModel)
                PileLeft = nil
            end

            local PileRight = CurrentCheckpoint.pileright
            if PileRight then
                DeleteClosestObject(CurrentCheckpoint.offset.right, Config.CheckpointPileModel)
                PileRight = nil
            end
        end
    end
end

function SetupPiles()
    for k, v in pairs(CreatorData.Checkpoints) do
        if not CreatorData.Checkpoints[k].pileleft then
            CreatorData.Checkpoints[k].pileleft = CreatePile(v.offset.left, Config.CheckpointPileModel)
        end

        if not CreatorData.Checkpoints[k].pileright then
            CreatorData.Checkpoints[k].pileright = CreatePile(v.offset.right, Config.CheckpointPileModel)
        end
    end
end

function SaveRace()
    local RaceDistance = 0

    for k, v in pairs(CreatorData.Checkpoints) do
        if k + 1 <= #CreatorData.Checkpoints then
            local checkpointdistance = #(vector3(v.coords.x, v.coords.y, v.coords.z) - vector3(CreatorData.Checkpoints[k + 1].coords.x, CreatorData.Checkpoints[k + 1].coords.y, CreatorData.Checkpoints[k + 1].coords.z))
            RaceDistance = RaceDistance + checkpointdistance
        end
    end

    CreatorData.RaceDistance = RaceDistance

    TriggerServerEvent('brp-racing:server:SaveRace', CreatorData)
    TriggerEvent('KKF.UI.ShowNotification', 'success', 'Rada salvestatud! (' .. CreatorData.RaceName .. ')')

    DeleteCreatorCheckpoints()

    RaceData.InCreator = false
    CreatorData.RaceName = nil
    CreatorData.RacerName = nil
    CreatorData.Checkpoints = {}
end

function GetClosestCheckpoint()
    local pos = GetEntityCoords(PlayerPedId(), true)
    local current = nil
    local dist = nil
    for id,_ in pairs(CreatorData.Checkpoints) do
        if current ~= nil then
            if #(pos - vector3(CreatorData.Checkpoints[id].coords.x, CreatorData.Checkpoints[id].coords.y, CreatorData.Checkpoints[id].coords.z)) < dist then
                current = id
                dist = #(pos - vector3(CreatorData.Checkpoints[id].coords.x, CreatorData.Checkpoints[id].coords.y, CreatorData.Checkpoints[id].coords.z))
            end
        else
            dist = #(pos - vector3(CreatorData.Checkpoints[id].coords.x, CreatorData.Checkpoints[id].coords.y, CreatorData.Checkpoints[id].coords.z))
            current = id
        end
    end
    RaceData.ClosestCheckpoint = current
end

function CreatorUI()
    CreateThread(function()
        while true do
            if RaceData.InCreator then
                SendNUIMessage({
                    action = "Update",
                    type = "creator",
                    data = CreatorData,
                    racedata = RaceData,
                    active = true,
                })
            else
                SendNUIMessage({
                    action = "Update",
                    type = "creator",
                    data = CreatorData,
                    racedata = RaceData,
                    active = false,
                })
                break
            end
            Wait(200)
        end
    end)
end

function AddCheckpoint()
    local PlayerPed = PlayerPedId()
    local PlayerPos = GetEntityCoords(PlayerPed)
    local PlayerVeh = GetVehiclePedIsIn(PlayerPed)
    local Offset = {
        left = {
            x = (GetOffsetFromEntityInWorldCoords(PlayerVeh, -CreatorData.TireDistance, 0.0, 0.0)).x,
            y = (GetOffsetFromEntityInWorldCoords(PlayerVeh, -CreatorData.TireDistance, 0.0, 0.0)).y,
            z = (GetOffsetFromEntityInWorldCoords(PlayerVeh, -CreatorData.TireDistance, 0.0, 0.0)).z,
        },
        right = {
            x = (GetOffsetFromEntityInWorldCoords(PlayerVeh, CreatorData.TireDistance, 0.0, 0.0)).x,
            y = (GetOffsetFromEntityInWorldCoords(PlayerVeh, CreatorData.TireDistance, 0.0, 0.0)).y,
            z = (GetOffsetFromEntityInWorldCoords(PlayerVeh, CreatorData.TireDistance, 0.0, 0.0)).z,
        }
    }

    CreatorData.Checkpoints[#CreatorData.Checkpoints+1] = {
        coords = {
            x = PlayerPos.x,
            y = PlayerPos.y,
            z = PlayerPos.z,
        },
        offset = Offset,
    }


    for id, CheckpointData in pairs(CreatorData.Checkpoints) do
        if CheckpointData.blip ~= nil then
            RemoveBlip(CheckpointData.blip)
        end

        CheckpointData.blip = CreateCheckpointBlip(CheckpointData.coords, id)
    end
end

function CreateCheckpointBlip(coords, id)
    local Blip = AddBlipForCoord(coords.x, coords.y, coords.z)

    SetBlipSprite(Blip, 1)
    SetBlipDisplay(Blip, 4)
    SetBlipScale(Blip, 1.0)
    SetBlipAsShortRange(Blip, true)
    SetBlipColour(Blip, 7)
    ShowNumberOnBlip(Blip, id)
    SetBlipShowCone(Blip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Punkt "..id)
    EndTextCommandSetBlipName(Blip)

    return Blip
end

function CreatorLoop()
    CreateThread(function()
        while RaceData.InCreator do
            local PlayerPed = PlayerPedId()
            local PlayerVeh = GetVehiclePedIsIn(PlayerPed)

            if PlayerVeh ~= 0 then
                if IsControlJustPressed(0, 161) or IsDisabledControlJustPressed(0, 161) then
                    AddCheckpoint()
                end

                if IsControlJustPressed(0, 162) or IsDisabledControlJustPressed(0, 162) then
                    if CreatorData.Checkpoints and next(CreatorData.Checkpoints) then
                        DeleteCheckpoint()
                    else
                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te pole kustutamiseks ühtegi kontrollpunkti asetanud.')
                    end
                end

                if IsControlJustPressed(0, 170) or IsDisabledControlJustPressed(0, 170) then
                    if CreatorData.Checkpoints and #CreatorData.Checkpoints >= Config.MinimumCheckpoints then
                        SaveRace()
                    else
                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Salvestamiseks vajate minimaalset arvu kontrollpunkte. ' .. Config.MinimumCheckpoints .. ')')
                    end
                end

                if IsControlJustPressed(0, 40) or IsDisabledControlJustPressed(0, 40) then
                    if CreatorData.TireDistance < Config.MaxTireDistance then
                        CreatorData.TireDistance = CreatorData.TireDistance + 1.0
                    else
                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Maksimaalne rehvivahe on ' .. Config.MaxTireDistance .. '.')
                    end
                end

                if IsControlJustPressed(0, 39) or IsDisabledControlJustPressed(0, 39) then
                    if CreatorData.TireDistance > Config.MinTireDistance then
                        CreatorData.TireDistance = CreatorData.TireDistance - 1.0
                    else
                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Minimaalne rehvivahe on ' .. Config.MinTireDistance .. '.')
                    end
                end
            else
                local coords = GetEntityCoords(PlayerPedId())
                DrawText3Ds(coords.x, coords.y, coords.z, 'Alustamiseks istuge sõidukisse!')
            end

            if IsControlJustPressed(0, 163) or IsDisabledControlJustPressed(0, 163) then
                if not CreatorData.ConfirmDelete then
                    CreatorData.ConfirmDelete = true
                    TriggerEvent('KKF.UI.ShowNotification', 'info', 'Vajuta uuesti [9] et kinnitada.')
                else
                    DeleteCreatorCheckpoints()

                    RaceData.InCreator = false
                    CreatorData.RaceName = nil
                    CreatorData.Checkpoints = {}
                    TriggerEvent('KKF.UI.ShowNotification', 'error', 'Tühistasite raja redigeerimise.')
                    CreatorData.ConfirmDelete = false
                end
            end
            Wait(0)
        end
    end)
end

function RaceUI()
    CreateThread(function()
        while true do
            if CurrentRaceData.Checkpoints ~= nil and next(CurrentRaceData.Checkpoints) ~= nil then
                if CurrentRaceData.Started then
                    CurrentRaceData.RaceTime = CurrentRaceData.RaceTime + 1
                    CurrentRaceData.TotalTime = CurrentRaceData.TotalTime + 1
                end
                SendNUIMessage({
                    action = "Update",
                    type = "race",
                    data = {
                        CurrentCheckpoint = CurrentRaceData.CurrentCheckpoint,
                        TotalCheckpoints = #CurrentRaceData.Checkpoints,
                        TotalLaps = CurrentRaceData.TotalLaps,
                        CurrentLap = CurrentRaceData.Lap,
                        RaceStarted = CurrentRaceData.Started,
                        RaceName = CurrentRaceData.RaceName,
                        Time = CurrentRaceData.RaceTime,
                        TotalTime = CurrentRaceData.TotalTime,
                        BestLap = CurrentRaceData.BestLap,
                    },
                    racedata = RaceData,
                    active = true,
                })
            else
                if not FinishedUITimeout then
                    FinishedUITimeout = true
                    SetTimeout(10000, function()
                        FinishedUITimeout = false
                        SendNUIMessage({
                            action = "Update",
                            type = "race",
                            data = {},
                            racedata = RaceData,
                            active = false,
                        })
                    end)
                end
                break
            end
            Wait(12)
        end
    end)
end

function SetupRace(RaceData, Laps)
    RaceData.RaceId = RaceData.RaceId
    CurrentRaceData = {
        RaceId = RaceData.RaceId,
        Creator = RaceData.Creator,
        OrganizerCID = RaceData.OrganizerCID,
        RacerName = RaceData.RacerName,
        RaceName = RaceData.RaceName,
        Checkpoints = RaceData.Checkpoints,
        pilesEnabled = RaceData.pilesEnabled,
        Started = false,
        CurrentCheckpoint = 1,
        TotalLaps = Laps,
        Lap = 1,
        RaceTime = 0,
        TotalTime = 0,
        BestLap = 0,
        Racers = {}
    }

    for k, v in pairs(CurrentRaceData.Checkpoints) do
        CurrentRaceData.Checkpoints[k].pileleft = CreatePile(v.offset.left, Config.CheckpointPileModel)
        CurrentRaceData.Checkpoints[k].pileright = CreatePile(v.offset.right, Config.CheckpointPileModel)

        ClearAreaOfObjects(v.offset.right.x, v.offset.right.y, v.offset.right.z, 50.0, 0)

        CurrentRaceData.Checkpoints[k].blip = CreateCheckpointBlip(v.coords, k)
    end

    RaceUI()
end
local

function GetMaxDistance(OffsetCoords)
    local Distance = #(vector3(OffsetCoords.left.x, OffsetCoords.left.y, OffsetCoords.left.z) - vector3(OffsetCoords.right.x, OffsetCoords.right.y, OffsetCoords.right.z))
    local Retval = 7.5
    if Distance > 20.0 then
        Retval = 12.5
    end
    return Retval
end

function SecondsToClock(seconds)
    local seconds = tonumber(seconds)
    local retval = 0
    if seconds <= 0 then
        retval = "00:00:00";
    else
        hours = string.format("%02.f", math.floor(seconds/3600));
        mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
        secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
        retval = hours..":"..mins..":"..secs
    end
    return retval
end

function DeleteCurrentRaceCheckpoints()
    for k, v in pairs(CurrentRaceData.Checkpoints) do
        local CurrentCheckpoint = CurrentRaceData.Checkpoints[k]
        local Blip = CurrentCheckpoint.blip
        if Blip then
            RemoveBlip(Blip)
            Blip = nil
        end

        DeleteClosestObject(CurrentCheckpoint.offset.left, Config.CheckpointPileModel)
        PileLeft = nil

        local PileLeft = CurrentCheckpoint.pileleft
        if PileLeft then
            DeleteClosestObject(CurrentCheckpoint.offset.left, Config.CheckpointPileModel)
            PileLeft = nil
        end

        local PileRight = CurrentCheckpoint.pileright
        if PileRight then
            DeleteClosestObject(CurrentCheckpoint.offset.right, Config.CheckpointPileModel)
            PileRight = nil
        end
    end

    CurrentRaceData.RaceName = nil
    CurrentRaceData.Checkpoints = {}
    CurrentRaceData.Started = false
    CurrentRaceData.CurrentCheckpoint = 0
    CurrentRaceData.TotalLaps = 0
    CurrentRaceData.Lap = 0
    CurrentRaceData.RaceTime = 0
    CurrentRaceData.TotalTime = 0
    CurrentRaceData.BestLap = 0
    CurrentRaceData.RaceId = nil
    CurrentRaceData.RacerName = nil
    RaceData.InRace = false
end

function FinishRace()
    TriggerServerEvent('brp-racing:server:FinishPlayer', CurrentRaceData, CurrentRaceData.TotalTime, CurrentRaceData.TotalLaps, CurrentRaceData.BestLap)
    TriggerEvent('KKF.UI.ShowNotification', 'success', 'Lõpetasite võistluse ajaga ' .. SecondsToClock(CurrentRaceData.TotalTime) .. '.')

    if CurrentRaceData.BestLap ~= 0 then
        TriggerEvent('KKF.UI.ShowNotification', 'success', 'Lõpetasite võistluse parima raja ajaga ' .. SecondsToClock(CurrentRaceData.BestLap) .. '.')
    end

    DeleteCurrentRaceCheckpoints()
end

function Info()
    local PlayerPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(PlayerPed, false)
    local IsDriver = GetPedInVehicleSeat(plyVeh, -1) == PlayerPed
    local returnValue = plyVeh ~= 0 and plyVeh ~= nil and IsDriver
    return returnValue, plyVeh
end

exports('IsInRace', IsInRace)
function IsInRace()
    local retval = false
    if RaceData.InRace then
        retval = true
    end
    return retval
end

exports('IsInEditor', IsInEditor)
function IsInEditor()
    local retval = false
    if RaceData.InCreator then
        retval = true
    end
    return retval
end

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

-----------------------
----   Threads     ----
-----------------------

CreateThread(function()
    while true do
        if RaceData.InCreator then
            GetClosestCheckpoint()
            SetupPiles()
        end
        Wait(1000)
    end
end)

CreateThread(function()
    while true do
        local Driver, plyVeh = Info()
        if Driver then
            if GetVehicleCurrentGear(plyVeh) < 3 and GetVehicleCurrentRpm(plyVeh) == 1.0 and math.ceil(GetEntitySpeed(plyVeh) * 2.236936) > 50 then
              while GetVehicleCurrentRpm(plyVeh) > 0.6 do
                  SetVehicleCurrentRpm(plyVeh, 0.3)
                  Wait(0)
              end
              Wait(800)
            end
        end
        Wait(500)
    end
end)

CreateThread(function()
    while true do

        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        if CurrentRaceData.RaceName ~= nil then
            if CurrentRaceData.Started then
                local cp = 0
                if CurrentRaceData.CurrentCheckpoint + 1 > #CurrentRaceData.Checkpoints then
                    cp = 1
                else
                    cp = CurrentRaceData.CurrentCheckpoint + 1
                end
                local data = CurrentRaceData.Checkpoints[cp]
                local CheckpointDistance = #(pos - vector3(data.coords.x, data.coords.y, data.coords.z))
                local MaxDistance = GetMaxDistance(CurrentRaceData.Checkpoints[cp].offset)

                if CheckpointDistance < MaxDistance then
                    if CurrentRaceData.TotalLaps == 0 then
                        if CurrentRaceData.CurrentCheckpoint + 1 < #CurrentRaceData.Checkpoints then
                            CurrentRaceData.CurrentCheckpoint = CurrentRaceData.CurrentCheckpoint + 1
                            SetNewWaypoint(CurrentRaceData.Checkpoints[CurrentRaceData.CurrentCheckpoint + 1].coords.x, CurrentRaceData.Checkpoints[CurrentRaceData.CurrentCheckpoint + 1].coords.y)
                            TriggerServerEvent('brp-racing:server:UpdateRacerData', CurrentRaceData.RaceId, CurrentRaceData.CurrentCheckpoint, CurrentRaceData.Lap, false)
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            SetBlipScale(CurrentRaceData.Checkpoints[CurrentRaceData.CurrentCheckpoint].blip, 0.6)
                            SetBlipScale(CurrentRaceData.Checkpoints[CurrentRaceData.CurrentCheckpoint + 1].blip, 1.0)
                        else
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            CurrentRaceData.CurrentCheckpoint = CurrentRaceData.CurrentCheckpoint + 1
                            TriggerServerEvent('brp-racing:server:UpdateRacerData', CurrentRaceData.RaceId, CurrentRaceData.CurrentCheckpoint, CurrentRaceData.Lap, true)
                            FinishRace()
                        end
                    else
                        if CurrentRaceData.CurrentCheckpoint + 1 > #CurrentRaceData.Checkpoints then
                            if CurrentRaceData.Lap + 1 > CurrentRaceData.TotalLaps then
                                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                                CurrentRaceData.CurrentCheckpoint = CurrentRaceData.CurrentCheckpoint + 1
                                TriggerServerEvent('brp-racing:server:UpdateRacerData', CurrentRaceData.RaceId, CurrentRaceData.CurrentCheckpoint, CurrentRaceData.Lap, true)
                                FinishRace()
                            else
                                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                                if CurrentRaceData.RaceTime < CurrentRaceData.BestLap then
                                    CurrentRaceData.BestLap = CurrentRaceData.RaceTime
                                elseif CurrentRaceData.BestLap == 0 then
                                    CurrentRaceData.BestLap = CurrentRaceData.RaceTime
                                end
                                CurrentRaceData.RaceTime = 0
                                CurrentRaceData.Lap = CurrentRaceData.Lap + 1
                                CurrentRaceData.CurrentCheckpoint = 1
                                SetNewWaypoint(CurrentRaceData.Checkpoints[CurrentRaceData.CurrentCheckpoint + 1].coords.x, CurrentRaceData.Checkpoints[CurrentRaceData.CurrentCheckpoint + 1].coords.y)
                                TriggerServerEvent('brp-racing:server:UpdateRacerData', CurrentRaceData.RaceId, CurrentRaceData.CurrentCheckpoint, CurrentRaceData.Lap, false)
                            end
                        else
                            CurrentRaceData.CurrentCheckpoint = CurrentRaceData.CurrentCheckpoint + 1
                            if CurrentRaceData.CurrentCheckpoint ~= #CurrentRaceData.Checkpoints then
                                SetNewWaypoint(CurrentRaceData.Checkpoints[CurrentRaceData.CurrentCheckpoint + 1].coords.x, CurrentRaceData.Checkpoints[CurrentRaceData.CurrentCheckpoint + 1].coords.y)
                                TriggerServerEvent('brp-racing:server:UpdateRacerData', CurrentRaceData.RaceId, CurrentRaceData.CurrentCheckpoint, CurrentRaceData.Lap, false)
                                SetBlipScale(CurrentRaceData.Checkpoints[CurrentRaceData.CurrentCheckpoint].blip, 0.6)
                                SetBlipScale(CurrentRaceData.Checkpoints[CurrentRaceData.CurrentCheckpoint + 1].blip, 1.0)
                            else
                                SetNewWaypoint(CurrentRaceData.Checkpoints[1].coords.x, CurrentRaceData.Checkpoints[1].coords.y)
                                TriggerServerEvent('brp-racing:server:UpdateRacerData', CurrentRaceData.RaceId, CurrentRaceData.CurrentCheckpoint, CurrentRaceData.Lap, false)
                                SetBlipScale(CurrentRaceData.Checkpoints[#CurrentRaceData.Checkpoints].blip, 0.6)
                                SetBlipScale(CurrentRaceData.Checkpoints[1].blip, 1.0)
                            end
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                        end
                    end
                end
            else
                local data = CurrentRaceData.Checkpoints[CurrentRaceData.CurrentCheckpoint]
                DrawMarker(4, data.coords.x, data.coords.y, data.coords.z + 1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.9, 1.5, 1.5, 255, 255, 255, 255, 0, 1, 0, 0, 0, 0, 0)
            end
        else
            Wait(1000)
        end

        Wait(0)
    end
end)

CreateThread(function()
    while true do
        if RaceData.InCreator then
            local PlayerPed = PlayerPedId()
            local PlayerVeh = GetVehiclePedIsIn(PlayerPed)

            if PlayerVeh ~= 0 then
                local Offset = {
                    left = {
                        x = (GetOffsetFromEntityInWorldCoords(PlayerVeh, -CreatorData.TireDistance, 0.0, 0.0)).x,
                        y = (GetOffsetFromEntityInWorldCoords(PlayerVeh, -CreatorData.TireDistance, 0.0, 0.0)).y,
                        z = (GetOffsetFromEntityInWorldCoords(PlayerVeh, -CreatorData.TireDistance, 0.0, 0.0)).z,
                    },
                    right = {
                        x = (GetOffsetFromEntityInWorldCoords(PlayerVeh, CreatorData.TireDistance, 0.0, 0.0)).x,
                        y = (GetOffsetFromEntityInWorldCoords(PlayerVeh, CreatorData.TireDistance, 0.0, 0.0)).y,
                        z = (GetOffsetFromEntityInWorldCoords(PlayerVeh, CreatorData.TireDistance, 0.0, 0.0)).z,
                    }
                }

                DrawText3Ds(Offset.left.x, Offset.left.y, Offset.left.z, 'Vasak punkt')
                DrawText3Ds(Offset.right.x, Offset.right.y, Offset.right.z, 'Parem punkt')
            end
        end
        Wait(0)
    end
end)

-----------------------
---- Client Events ----
-----------------------

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        DeleteAllCheckpoints()
    end
end)

RegisterNetEvent('brp-racing:server:ReadyJoinRace', function(RaceData)
    RaceData.RacerName = RaceData.SetupRacerName
    TriggerServerEvent('brp-racing:server:JoinRace', RaceData)
end)

RegisterNetEvent('brp-racing:client:StartRaceEditor', function(RaceName, RacerName)
    if not RaceData.InCreator then
        CreatorData.RaceName = RaceName
        CreatorData.RacerName = RacerName
        RaceData.InCreator = true
        CreatorUI()
        CreatorLoop()
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Olete juba võistlust tegemas.')
    end
end)

RegisterNetEvent('brp-racing:client:UpdateRaceRacerData', function(RaceId, RaceData)
    if (CurrentRaceData.RaceId ~= nil) and CurrentRaceData.RaceId == RaceId then
        CurrentRaceData.Racers = RaceData.Racers
    end
end)

RegisterNetEvent('brp-racing:client:JoinRace', function(Data, Laps, RacerName)
    if not RaceData.InRace then
        Data.RacerName = RacerName
        RaceData.InRace = true
        SetupRace(Data, Laps)
        TriggerEvent('KKF.UI.ShowNotification', 'info', 'Liitusite võistlusega.')
        TriggerServerEvent('brp-racing:server:UpdateRaceState', CurrentRaceData.RaceId, false, true)
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Olete juba ühes võisluses.')
    end
end)

RegisterNetEvent('brp-racing:client:UpdateRaceRacers', function(RaceId, Racers)
    if CurrentRaceData.RaceId == RaceId then
        CurrentRaceData.Racers = Racers
    end
end)

RegisterNetEvent('brp-racing:client:LeaveRace', function(data)
    DeleteCurrentRaceCheckpoints()
    FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), false), false)
end)

RegisterNetEvent('brp-racing:client:RaceCountdown', function()
    TriggerServerEvent('brp-racing:server:UpdateRaceState', CurrentRaceData.RaceId, true, false)
    if CurrentRaceData.RaceId ~= nil then
        while Countdown ~= 0 do
            if CurrentRaceData.RaceName ~= nil then
                if Countdown == 10 then
                    TriggerEvent('KKF.UI.ShowNotification', 'info', 'Sõit algab 10 sekundi pärast.')
                    PlaySound(-1, "slow", "SHORT_PLAYER_SWITCH_SOUND_SET", 0, 0, 1)
                elseif Countdown <= 5 then
                    TriggerEvent('KKF.UI.ShowNotification', 'info', Countdown, 500)
                    PlaySound(-1, "slow", "SHORT_PLAYER_SWITCH_SOUND_SET", 0, 0, 1)
                end
                Countdown = Countdown - 1
                FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), true), true)
            else
                break
            end
            Wait(1000)
        end
        if CurrentRaceData.RaceName ~= nil then
            SetNewWaypoint(CurrentRaceData.Checkpoints[CurrentRaceData.CurrentCheckpoint + 1].coords.x, CurrentRaceData.Checkpoints[CurrentRaceData.CurrentCheckpoint + 1].coords.y)
            TriggerEvent('KKF.UI.ShowNotification', 'success', 'MINE!!!', 1000)
            SetBlipScale(CurrentRaceData.Checkpoints[CurrentRaceData.CurrentCheckpoint + 1].blip, 1.0)
            FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), true), false)
            CurrentRaceData.Started = true
            Countdown = 10
        else
            FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), true), false)
            Countdown = 10
        end
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te olete juba ühes võistluses!')
    end
end)

RegisterNetEvent('brp-racing:client:PlayerFinish', function(RaceId, Place, RacerName)
    if CurrentRaceData.RaceId ~= nil then
        if CurrentRaceData.RaceId == RaceId then
            TriggerEvent('KKF.UI.ShowNotification', 'info', RacerName .. ' lõpetas kohal ' .. Place .. '.')
        end
    end
end)

RegisterNetEvent('brp-racing:client:WaitingDistanceCheck', function()
    Wait(1000)
    CreateThread(function()
        while true do
            if not CurrentRaceData.Started then
                local ped = PlayerPedId()
                local pos = GetEntityCoords(ped)
                if CurrentRaceData.Checkpoints[1] ~= nil then
                    local cpcoords = CurrentRaceData.Checkpoints[1].coords
                    local dist = #(pos - vector3(cpcoords.x, cpcoords.y, cpcoords.z))
                    if dist > 115.0 then
                        if ToFarCountdown ~= 0 then
                            ToFarCountdown = ToFarCountdown - 1
                            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Tagasi starti, muidu visatakse teid võistluselt välja: ' .. ToFarCountdown .. 's.', 500)
                        else
                            TriggerServerEvent('brp-racing:server:LeaveRace', CurrentRaceData)
                            ToFarCountdown = 10
                            break
                        end
                        Wait(1000)
                    else
                        if ToFarCountdown ~= 10 then
                            ToFarCountdown = 10
                        end
                    end
                end
            else
                break
            end
            Wait(0)
        end
    end)
end)

RegisterNetEvent("brp-racing:client:OpenMainMenu", function()
    local elements = {
        {
            title = 'Saadavalolevad võistlused',
            description = 'Vaadake kõiki praegu saadaolevaid võistlusi.',
            event = "brp-racing:client:AvailableRacesMenu"
        },

        {
            title = 'Võistlusrekordid',
            description = 'Vaata kõiki võistluste rekordeid.',
            event = "brp-racing:client:RaceRecordsMenu"
        },

        {
            title = 'Seadistage võistlus',
            description = '',
            event = "brp-racing:client:SetupRaceMenu"
        },

        {
            title = 'Loo rada',
            description = '',
            event = "brp-racing:client:CreateRaceMenu"
        }
    }

    if CurrentRaceData.RaceId ~= nil then
        elements[#elements + 1] = {
            title = 'Praegune rada',
            description = 'Valikud teie praeguse võistluse jaoks.',
            event = 'brp-racing:client:CurrentRaceMenu'
        }
    end

    lib.registerContext({
        id = 'racing_main_menu',
        title = 'Võidusõidud',
        options = elements
    })

    lib.showContext('racing_main_menu')
end)

RegisterNetEvent("brp-racing:client:CurrentRaceMenu", function()
    local elements = {}

    if not CurrentRaceData.RaceId then
        return
    end

    local racers = 0
    for _ in pairs(CurrentRaceData.Racers) do racers = racers + 1 end

    if (CurrentRaceData.OrganizerCID == KKF.GetPlayerData().identifier) or CurrentRaceData.Started then
        elements[#elements + 1] = {
            title = 'Alusta võistlust',
            description = '',
            serverEvent = "brp-racing:server:StartRace",
            args = CurrentRaceData.RaceId
        }
    end

    elements[#elements + 1] = {
        title = 'Lahku võistlusest',
        description = '',
        serverEvent = "brp-racing:server:LeaveRace",
        args = CurrentRaceData
    }

    lib.registerContext({
        id = 'racing_current_menu',
        title = CurrentRaceData.RaceName..' | võistlejad',
        menu = 'racing_main_menu',
        options = elements
    })

    lib.showContext('racing_current_menu')
end)

RegisterNetEvent("brp-racing:client:AvailableRacesMenu", function()
    lib.callback('brp-racing:server:GetRaces', false, function(Races)
        local elements = {}

        for _,race in ipairs(Races) do
            local RaceData = race.RaceData
            local racers = 0

            for _ in pairs(RaceData.Racers) do racers = racers + 1 end

            race.RacerName = KKF.GetPlayerData().name

            elements[#elements+1] = {
                title = RaceData.RaceName,
                description = string.format('%s ring(i) | %sm | %s võistleja(t)', race.Laps, RaceData.Distance, racers),
                serverEvent = "brp-racing:server:JoinRace",
                args = race
            }
        end

        if #elements == 0 then
            TriggerEvent('KKF.UI.ShowNotification', 'info', 'Hetkel pooleliolevaid võistlusi pole.')
            TriggerEvent('brp-racing:client:OpenMainMenu')
            return
        end

        lib.registerContext({
            id = 'racing_available_menu',
            title = 'Saadavalolevad võistlused',
            menu = 'racing_main_menu',
            options = elements
        })
    
        lib.showContext('racing_available_menu')
    end)
end)


RegisterNetEvent("brp-racing:client:RaceRecordsMenu", function()
    lib.callback('brp-racing:server:GetRacingLeaderboards', false, function(Races)
        local elements = {}

        for RaceName,RecordData in pairs(Races) do
            local text = 'Nõudmata'
            if next(RecordData) then text = string.format("%s | %s ", RecordData.Holder, SecondsToClock(RecordData.Time)) end

            elements[#elements+1] = {
                title = RaceData.RaceName,
                description = text
            }
        end

        if #elements == 0 then
            TriggerEvent('KKF.UI.ShowNotification', 'info', 'Veel pole ühtegi võistlust, mille rekordeid näha!')
            TriggerEvent('brp-racing:client:OpenMainMenu')
            return
        end
        
        lib.registerContext({
            id = 'racing_records_menu',
            title = 'Võistlusrekordid',
            menu = 'racing_main_menu',
            options = elements
        })
    
        lib.showContext('racing_records_menu')
    end)
end)

RegisterNetEvent("brp-racing:client:SetupRaceMenu", function()
    lib.callback('brp-racing:server:GetListedRaces', false, function(Races)
        local tracks = {}

        for id,track in pairs(Races) do
            if not track.Waiting then
                tracks[#tracks+1] = {  value = id, label = string.format("%s | %s | %sm", track.RaceName, track.CreatorName, track.Distance) }
            end
        end

        if #tracks == 0 then
            TriggerEvent('KKF.UI.ShowNotification', 'info', 'Hetkel pole kasutamiseks saadaolevaid radu.')
            TriggerEvent('brp-racing:client:OpenMainMenu')
            return
        end

        local input = lib.inputDialog('Võidusõit – seadistamine', {
            { type = 'select', label = 'Valige rada', options = tracks},
            { type = "number", label = "Ringide arv (0 on sprint)", default = 0 },
            { type = "checkbox", label = "Tähised punktides", checked = false },
        })

        if not input or input[1] == "none" then
            TriggerEvent('brp-racing:client:OpenMainMenu')
            return
        end

        TriggerServerEvent('brp-racing:server:SetupRace', input[1], tonumber(input[2]) or 0, input[3])
    end)
end)

RegisterNetEvent("brp-racing:client:CreateRaceMenu", function()
    local input = lib.inputDialog('Mis nime soovite oma rajale panna?', {'Sisesta nimi'})

    if input then
        if input[1] == nil then
            TriggerEvent('brp-racing:client:OpenMainMenu')
            return
        end
    
        if #input[1] < Config.MinTrackNameLength then
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Nimi on liiga lühike.')
            TriggerEvent("brp-racing:client:CreateRaceMenu")
            return
        end
    
        if #input[1] > Config.MaxTrackNameLength then
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Nimi on liiga pikk.')
            TriggerEvent("brp-racing:client:CreateRaceMenu")
            return
        end
    
        lib.callback('brp-racing:server:IsAuthorizedToCreateRaces', false, function(NameAvailable)
            if not NameAvailable then
                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Selle nimega rada juba eksisteerib.')
                TriggerEvent("brp-racing:client:CreateRaceMenu")
                return
            end
    
            TriggerServerEvent('brp-racing:server:CreateLapRace', input[1])
        end, input[1])
    end
end)