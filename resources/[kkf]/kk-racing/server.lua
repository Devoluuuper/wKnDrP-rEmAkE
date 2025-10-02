-----------------------
----   Variables   ----
-----------------------
local Races = {}
local AvailableRaces = {}
local LastRaces = {}
local NotFinished = {}

-----------------------
----   Threads     ----
-----------------------
MySQL.ready(function ()
    local races = MySQL.Sync.fetchAll('SELECT * FROM race_tracks', {})
    if races[1] ~= nil then
        for _, v in pairs(races) do
            local Records = {}
            if v.records ~= nil then
                Records = json.decode(v.records)
            end
            Races[v.raceid] = {
                RaceName = v.name,
                Checkpoints = json.decode(v.checkpoints),
                Records = Records,
                Creator = v.creatorid,
                CreatorName = v.creatorname,
                RaceId = v.raceid,
                Started = false,
                Waiting = false,
                Distance = v.distance,
                LastLeaderboard = {},
                Racers = {}
            }
        end
    end
end)

-----------------------
---- Server Events ----
-----------------------
RegisterNetEvent('brp-racing:server:FinishPlayer', function(RaceData, TotalTime, TotalLaps, BestLap)
    local AvailableKey = GetOpenedRaceKey(RaceData.RaceId)
    local RacerName = RaceData.RacerName
    local PlayersFinished = 0
    local AmountOfRacers = 0

    for k, v in pairs(Races[RaceData.RaceId].Racers) do
        if v.Finished then
            PlayersFinished = PlayersFinished + 1
        end
        AmountOfRacers = AmountOfRacers + 1
    end
    local BLap = 0
    if TotalLaps < 2 then
        BLap = TotalTime
    else
        BLap = BestLap
    end

    if LastRaces[RaceData.RaceId] ~= nil then
        LastRaces[RaceData.RaceId][#LastRaces[RaceData.RaceId]+1] =  {
            TotalTime = TotalTime,
            BestLap = BLap,
            Holder = RacerName
        }
    else
        LastRaces[RaceData.RaceId] = {}
        LastRaces[RaceData.RaceId][#LastRaces[RaceData.RaceId]+1] =  {
            TotalTime = TotalTime,
            BestLap = BLap,
            Holder = RacerName
        }
    end
    if Races[RaceData.RaceId].Records ~= nil and next(Races[RaceData.RaceId].Records) ~= nil then
        if BLap < Races[RaceData.RaceId].Records.Time then
            Races[RaceData.RaceId].Records = {
                Time = BLap,
                Holder = RacerName
            }
            MySQL.Async.execute('UPDATE race_tracks SET records = ? WHERE raceid = ?',
                {json.encode(Races[RaceData.RaceId].Records), RaceData.RaceId})
                TriggerClientEvent('KKF.UI.ShowNotification', source, 'success', string.format('Rekord rajal %s on nüüd teie koos ajaga: %s!', RaceData.RaceName, SecondsToClock(BLap)))
        end
    else
        Races[RaceData.RaceId].Records = {
            Time = BLap,
            Holder = RacerName
        }
        MySQL.Async.execute('UPDATE race_tracks SET records = ? WHERE raceid = ?',
            {json.encode(Races[RaceData.RaceId].Records), RaceData.RaceId})
            TriggerClientEvent('KKF.UI.ShowNotification', source, 'success', string.format('Rekord rajal %s on nüüd teie koos ajaga: %s!', RaceData.RaceName, SecondsToClock(BLap)))
    end
    AvailableRaces[AvailableKey].RaceData = Races[RaceData.RaceId]
    TriggerClientEvent('brp-racing:client:PlayerFinish', -1, RaceData.RaceId, PlayersFinished, RacerName)
    if PlayersFinished == AmountOfRacers then
        if NotFinished ~= nil and next(NotFinished) ~= nil and NotFinished[RaceData.RaceId] ~= nil and
            next(NotFinished[RaceData.RaceId]) ~= nil then
            for k, v in pairs(NotFinished[RaceData.RaceId]) do
                LastRaces[RaceData.RaceId][#LastRaces[RaceData.RaceId]+1] = {
                    TotalTime = v.TotalTime,
                    BestLap = v.BestLap,
                    Holder = v.Holder
                }
            end
        end
        Races[RaceData.RaceId].LastLeaderboard = LastRaces[RaceData.RaceId]
        Races[RaceData.RaceId].Racers = {}
        Races[RaceData.RaceId].Started = false
        Races[RaceData.RaceId].Waiting = false
        table.remove(AvailableRaces, AvailableKey)
        LastRaces[RaceData.RaceId] = nil
        NotFinished[RaceData.RaceId] = nil
    end
end)

RegisterNetEvent('brp-racing:server:CreateLapRace', function(RaceName)
    local xPlayer = KKF.GetPlayerFromId(source)

    if IsNameAvailable(RaceName) then
        TriggerClientEvent('brp-racing:client:StartRaceEditor', source, RaceName, xPlayer.name)
    else
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Selle nimega võistlus juba eksisteerib.')
    end
end)

RegisterNetEvent('brp-racing:server:JoinRace', function(RaceData)
    local xPlayer = KKF.GetPlayerFromId(source)
    local RaceName = RaceData.RaceData.RaceName
    local RaceId = GetRaceId(RaceName)
    local AvailableKey = GetOpenedRaceKey(RaceData.RaceId)
    local CurrentRace = GetCurrentRace(xPlayer.identifier)
    local RacerName = RaceData.RacerName

    if CurrentRace ~= nil then
        local AmountOfRacers = 0
        PreviousRaceKey = GetOpenedRaceKey(CurrentRace)
        for _,_ in pairs(Races[CurrentRace].Racers) do
            AmountOfRacers = AmountOfRacers + 1
        end
        Races[CurrentRace].Racers[xPlayer.identifier] = nil
        if (AmountOfRacers - 1) == 0 then
            Races[CurrentRace].Racers = {}
            Races[CurrentRace].Started = false
            Races[CurrentRace].Waiting = false
            table.remove(AvailableRaces, PreviousRaceKey)
            TriggerClientEvent('KKF.UI.ShowNotification', source, 'info', 'Olite võistlusel viimane inimene, nii et see tühistati.')
            TriggerClientEvent('brp-racing:client:LeaveRace', source, Races[CurrentRace])
        else
            AvailableRaces[PreviousRaceKey].RaceData = Races[CurrentRace]
            TriggerClientEvent('brp-racing:client:LeaveRace', source, Races[CurrentRace])
        end
    else
        Races[RaceId].OrganizerCID = xPlayer.identifier
    end

    Races[RaceId].pilesEnabled = RaceData.pilesEnabled
    Races[RaceId].Waiting = true
    Races[RaceId].Racers[xPlayer.identifier] = {
        Checkpoint = 0,
        Lap = 1,
        Finished = false,
        RacerName = RacerName,
    }
    AvailableRaces[AvailableKey].RaceData = Races[RaceId]
    TriggerClientEvent('brp-racing:client:JoinRace', source, Races[RaceId], RaceData.Laps, RacerName)
    TriggerClientEvent('brp-racing:client:UpdateRaceRacers', source, RaceId, Races[RaceId].Racers)
    local creatorsource = KKF.GetPlayerFromIdentifier(AvailableRaces[AvailableKey].SetupCitizenId).source

    if creatorsource ~= xPlayer.source then
        TriggerClientEvent('KKF.UI.ShowNotification', creatorsource, 'info', 'Keegi liitus võistlusega.')
    end
end)

RegisterNetEvent('brp-racing:server:LeaveRace', function(RaceData)
    local xPlayer = KKF.GetPlayerFromId(source)
    local RacerName = RaceData.RacerName
    local RaceName = RaceData.RaceName
    if RaceData.RaceData then
        RaceName = RaceData.RaceData.RaceName
    end

    local RaceId = GetRaceId(RaceName)
    local AvailableKey = GetOpenedRaceKey(RaceData.RaceId)
    local creatorsource = KKF.GetPlayerFromIdentifier(AvailableRaces[AvailableKey].SetupCitizenId).source

    if creatorsource ~= xPlayer.source then
        TriggerClientEvent('KKF.UI.ShowNotification', creatorsource, 'info', 'Keegi lahkus võistluselt.')
    end

    local AmountOfRacers = 0
    for k, v in pairs(Races[RaceData.RaceId].Racers) do
        AmountOfRacers = AmountOfRacers + 1
    end
    if NotFinished[RaceData.RaceId] ~= nil then
        NotFinished[RaceData.RaceId][#NotFinished[RaceData.RaceId]+1] = {
            TotalTime = "DNF",
            BestLap = "DNF",
            Holder = RacerName
        }
    else
        NotFinished[RaceData.RaceId] = {}
        NotFinished[RaceData.RaceId][#NotFinished[RaceData.RaceId]+1] = {
            TotalTime = "DNF",
            BestLap = "DNF",
            Holder = RacerName
        }
    end
    Races[RaceId].Racers[xPlayer.identifier] = nil
    if (AmountOfRacers - 1) == 0 then
        if NotFinished ~= nil and next(NotFinished) ~= nil and NotFinished[RaceId] ~= nil and next(NotFinished[RaceId]) ~=
            nil then
            for k, v in pairs(NotFinished[RaceId]) do
                if LastRaces[RaceId] ~= nil then
                    LastRaces[RaceId][#LastRaces[RaceId]+1] = {
                        TotalTime = v.TotalTime,
                        BestLap = v.BestLap,
                        Holder = v.Holder
                    }
                else
                    LastRaces[RaceId] = {}
                    LastRaces[RaceId][#LastRaces[RaceId]+1] = {
                        TotalTime = v.TotalTime,
                        BestLap = v.BestLap,
                        Holder = v.Holder
                    }
                end
            end
        end
        Races[RaceId].LastLeaderboard = LastRaces[RaceId]
        Races[RaceId].Racers = {}
        Races[RaceId].Started = false
        Races[RaceId].Waiting = false
        table.remove(AvailableRaces, AvailableKey)
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'info', 'Olite võistlusel viimane inimene, nii et see tühistati.')
        TriggerClientEvent('brp-racing:client:LeaveRace', source, Races[RaceId])
        LastRaces[RaceId] = nil
        NotFinished[RaceId] = nil
    else
        AvailableRaces[AvailableKey].RaceData = Races[RaceId]
        TriggerClientEvent('brp-racing:client:LeaveRace', source, Races[RaceId])
    end
    TriggerClientEvent('brp-racing:client:UpdateRaceRacers', source, RaceId, Races[RaceId].Racers)
end)

RegisterNetEvent('brp-racing:server:SetupRace', function(RaceId, Laps, pilesEnabled)
    local xPlayer = KKF.GetPlayerFromId(source)

    if Races[RaceId] ~= nil then
        if not Races[RaceId].Waiting then
            if not Races[RaceId].Started then
                Races[RaceId].Waiting = true
                local allRaceData = {
                    RaceData = Races[RaceId],
                    Laps = Laps,
                    pilesEnabled = pilesEnabled,
                    RaceId = RaceId,
                    SetupCitizenId = xPlayer.identifier,
                    SetupRacerName = xPlayer.name
                }
                AvailableRaces[#AvailableRaces+1] = allRaceData
                TriggerClientEvent('KKF.UI.ShowNotification', source, 'success', 'Võistlus loodud!')
                TriggerClientEvent('brp-racing:server:ReadyJoinRace', source, allRaceData)

                CreateThread(function()
                    local count = 0
                    while Races[RaceId].Waiting do
                        Wait(1000)
                        if count < 5 * 60 then
                            count = count + 1
                        else
                            local AvailableKey = GetOpenedRaceKey(RaceId)
                            for cid, _ in pairs(Races[RaceId].Racers) do
                                local RacerData = KKF.GetPlayerFromIdentifier(cid)
                                if RacerData ~= nil then
                                    TriggerClientEvent('KKF.UI.ShowNotification', RacerData.source, 'error', 'Võistlus aegus ja katkestati.')
                                    TriggerClientEvent('brp-racing:client:LeaveRace', RacerData.source, Races[RaceId])
                                end
                            end
                            table.remove(AvailableRaces, AvailableKey)
                            Races[RaceId].LastLeaderboard = {}
                            Races[RaceId].Racers = {}
                            Races[RaceId].Started = false
                            Races[RaceId].Waiting = false
                            LastRaces[RaceId] = nil
                        end
                    end
                end)
            else
                TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Võistlus on juba alanud!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Võistlus on juba alanud!')
        end
    else
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Seda rada pole olemas :(')
    end
end)

RegisterNetEvent('brp-racing:server:UpdateRaceState', function(RaceId, Started, Waiting)
    Races[RaceId].Waiting = Waiting
    Races[RaceId].Started = Started
end)

RegisterNetEvent('brp-racing:server:UpdateRacerData', function(RaceId, Checkpoint, Lap, Finished)
    local xPlayer = KKF.GetPlayerFromId(source)

    Races[RaceId].Racers[xPlayer.identifier].Checkpoint = Checkpoint
    Races[RaceId].Racers[xPlayer.identifier].Lap = Lap
    Races[RaceId].Racers[xPlayer.identifier].Finished = Finished

    TriggerClientEvent('brp-racing:client:UpdateRaceRacerData', -1, RaceId, Races[RaceId])
end)

RegisterNetEvent('brp-racing:server:StartRace', function(RaceId)
    local MyPlayer = KKF.GetPlayerFromId(source)
    local AvailableKey = GetOpenedRaceKey(RaceId)

    if not RaceId then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Sa ei osale võistlusel!')
        return
    end

    if AvailableRaces[AvailableKey].RaceData.Started then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Võistlus on juba alanud!')
        return
    end

    AvailableRaces[AvailableKey].RaceData.Started = true
    AvailableRaces[AvailableKey].RaceData.Waiting = false
    for CitizenId, _ in pairs(Races[RaceId].Racers) do
        local Player = KKF.GetPlayerFromIdentifier(CitizenId)

        if Player ~= nil then
            TriggerClientEvent('brp-racing:client:RaceCountdown', Player.source)
        end
    end
end)

RegisterNetEvent('brp-racing:server:SaveRace', function(RaceData)
    local xPlayer = KKF.GetPlayerFromId(source)
    local RaceId = GenerateRaceId()
    local Checkpoints = {}
    for k, v in pairs(RaceData.Checkpoints) do
        Checkpoints[k] = {
            offset = v.offset,
            coords = v.coords
        }
    end

    Races[RaceId] = {
        RaceName = RaceData.RaceName,
        Checkpoints = Checkpoints,
        Records = {},
        Creator = xPlayer.identifier,
        CreatorName = RaceData.RacerName,
        RaceId = RaceId,
        Started = false,
        Waiting = false,
        Distance = math.ceil(RaceData.RaceDistance),
        Racers = {},
        LastLeaderboard = {}
    }
    MySQL.Async.insert('INSERT INTO race_tracks (name, checkpoints, creatorid, creatorname, distance, raceid) VALUES (?, ?, ?, ?, ?, ?)',
        {RaceData.RaceName, json.encode(Checkpoints), xPlayer.identifier, RaceData.RacerName, RaceData.RaceDistance, RaceId})
end)

-----------------------
----   Functions   ----
-----------------------

function SecondsToClock(seconds)
    local seconds = tonumber(seconds)
    local retval = 0
    if seconds <= 0 then
        retval = "00:00:00";
    else
        hours = string.format("%02.f", math.floor(seconds / 3600));
        mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)));
        secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60));
        retval = hours .. ":" .. mins .. ":" .. secs
    end
    return retval
end

function IsNameAvailable(RaceName)
    local retval = true
    for RaceId, _ in pairs(Races) do
        if Races[RaceId].RaceName == RaceName then
            retval = false
            break
        end
    end
    return retval
end

function HasOpenedRace(CitizenId)
    local retval = false
    for k, v in pairs(AvailableRaces) do
        if v.SetupCitizenId == CitizenId then
            retval = true
        end
    end
    return retval
end

function GetOpenedRaceKey(RaceId)
    local retval = nil
    for k, v in pairs(AvailableRaces) do
        if v.RaceId == RaceId then
            retval = k
            break
        end
    end
    return retval
end

function GetCurrentRace(MyCitizenId)
    local retval = nil
    for RaceId, _ in pairs(Races) do
        for cid, _ in pairs(Races[RaceId].Racers) do
            if cid == MyCitizenId then
                retval = RaceId
                break
            end
        end
    end
    return retval
end

function GetRaceId(name)
    local retval = nil
    for k, v in pairs(Races) do
        if v.RaceName == name then
            retval = k
            break
        end
    end
    return retval
end

function GenerateRaceId()
    local RaceId = "LR-" .. math.random(1111, 9999)
    while Races[RaceId] ~= nil do
        RaceId = "LR-" .. math.random(1111, 9999)
    end
    return RaceId
end
lib.callback.register('brp-racing:server:GetRacingLeaderboards', function(source)
    local Leaderboard = {}

    for RaceId, RaceData in pairs(Races) do
        Leaderboard[RaceData.RaceName] = RaceData.Records
    end

    return Leaderboard
end)

lib.callback.register('brp-racing:server:GetRaces', function(source)
    return AvailableRaces
end)

lib.callback.register('brp-racing:server:GetListedRaces', function(source)
    return Races
end)

lib.callback.register('brp-racing:server:GetRacingData', function(source, RaceId)
    return Races[RaceId]
end)

lib.callback.register('brp-racing:server:HasCreatedRace', function(source)
    return HasOpenedRace(KKF.GetPlayerFromId(source).identifier)
end)

lib.callback.register('brp-racing:server:IsAuthorizedToCreateRaces', function(source, TrackName)
    return IsNameAvailable(TrackName)
end)

lib.callback.register('brp-racing:server:GetTrackData', function(source, RaceId)
    local result = MySQL.Sync.fetchAll('SELECT * FROM users WHERE pid = ?', {Races[RaceId].Creator})
    local returnable = nil

    if result[1] ~= nil then
        result[1].charinfo = json.decode(result[1].charinfo)
        returnable = Races[RaceId], result[1]
    else
        returnable = Races[RaceId], {
            charinfo = {
                firstname = "Unknown",
                lastname = "Unknown"
            }
        }
    end

    while returnable == nil do Wait(50) end; return returnable
end)

KKF.RegisterUsableItem("racing_tablet", function(source)
    local xPlayer = KKF.GetPlayerFromId(source)

    if xPlayer then
        TriggerClientEvent('brp-racing:client:OpenMainMenu', source)
    end
end)