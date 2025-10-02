local animDict = 'anim@mp_point'

local function LoadAnimDict(anim)
    RequestAnimDict(anim)
    while not HasAnimDictLoaded(anim) do
        Citizen.Wait(0)
    end
end

local function PointingLoop(ped)
    while IsControlPressed(0, 29) do
        SetTaskMoveNetworkSignalFloat(ped, 'Pitch', (GetGameplayCamRelativePitch() + 70) / 110)
        SetTaskMoveNetworkSignalFloat(ped, 'Heading', (GetGameplayCamRelativeHeading() + 180) / 360 * -1.0 + 1.0)
        Citizen.Wait(16)
    end
end

RegisterCommand('finger', function()
    local ped = PlayerPedId()
    LoadAnimDict(animDict)
    TaskMoveNetworkByName(ped, 'task_mp_pointing', 0.5, 0, animDict, 24)
    PointingLoop(ped)
    RequestTaskMoveNetworkStateTransition(ped, 'Stop')
    ClearPedSecondaryTask(ped)
    RemoveAnimDict(animDict)
end)

RegisterKeyMapping('finger', 'Näita Näpuga', 'keyboard', 'b')
