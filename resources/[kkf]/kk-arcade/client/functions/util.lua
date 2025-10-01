MinigameCamera = nil
FreezeCommand = false

--- @param amount integer
--- add comma to separate thousands
--- stolen from: http://lua-users.org/wiki/FormattingNumbers
function CommaValue(amount)
    local formatted = amount
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k == 0) then
            break
        end
    end
    return formatted
end

function showHelpNotification(text)
    BeginTextCommandDisplayHelp("THREESTRINGS")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, true, 5000)
end

function showNotification(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(0, 1)
end

function createBlip(name, blip, coords, options)
    local x, y, z = table.unpack(coords)
    local ourBlip = AddBlipForCoord(x, y, z)
    SetBlipSprite(ourBlip, blip)
    if options.type then
        SetBlipDisplay(ourBlip, options.type)
    end
    if options.scale then
        SetBlipScale(ourBlip, options.scale)
    end
    if options.color then
        SetBlipColour(ourBlip, options.color)
    end
    if options.shortRange then
        SetBlipAsShortRange(ourBlip, options.shortRange)
    end
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(ourBlip)
    return ourBlip
end

function createLocalPed(pedType, model, position, heading)
    local loaded = requestModel(model)
    if loaded then
        local ped = CreatePed(pedType, model, position.x, position.y, position.z, heading, false, false)
        SetModelAsNoLongerNeeded(model)
        return ped
    end
    return nil
end

function requestModel(modelName, cb)
    if type(modelName) ~= 'number' then
        modelName = GetHashKey(modelName)
    end

    local breaker = 0

    RequestModel(modelName)

    while not HasModelLoaded(modelName) do
        Wait(33)
        breaker = breaker + 1
        if breaker >= 100 then
            break
        end
    end

    if breaker >= 100 then
        return false
    else
        return true
    end
end

function SpawnArcadeGameCamera(entity, camera)
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, true)

    local camera = GetOffsetFromEntityInWorldCoords(entity, 0.0, camera[1], camera[2])
    local player = GetOffsetFromEntityInWorldCoords(entity, 0.0, -1.0, -1.0)

    MinigameCamera = CreateCamera("view_minigame_carneval", GetGameplayCamCoord(), GetGameplayCamRot(), GetGameplayCamFov())
    MinigameCamera.Render()

    MinigameCamera.ChangePosition(camera, camera, vector3(-10, 0, GetEntityHeading(entity)), 1500)

    SetEntityCoords(ped, player)
    SetEntityHeading(ped, GetEntityHeading(entity) - 0.0)
end

function RevertMinigameCamera()
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, false)
    if MinigameCamera and MinigameCamera.ChangePosition then
        MinigameCamera.ChangePosition(GetGameplayCamCoord(), GetGameplayCamCoord(), GetGameplayCamRot(), 1500)
        MinigameCamera.Destroy()
        MinigameCamera = nil

        StopRendering()
    end
end