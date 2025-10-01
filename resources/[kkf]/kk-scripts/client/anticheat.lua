local CLIENT_ID <const> = 'bba6f62fbce123d'

RegisterNetEvent('KKF.AntiCheat.DeleteEntity', function(entity)
    if DoesEntityExist(entity) then
        Citizen.Wait(3000)
        SetEntityCollision(entity, false, false)
        SetEntityAlpha(entity, 0.0, true)
        SetEntityAsMissionEntity(entity, true, true)
        SetEntityAsNoLongerNeeded(entity)
        ESX.Game.DeleteEntity(entity)
   end
end)

RegisterNetEvent('KKF.AntiCheat.ClearEntities', function()
    local objects = GetGamePool('CObject')

    for k,v in pairs(objects) do
        DeleteEntity(v)
    end
end)

RegisterNetEvent('KKF.AntiCheat.ClearPeds', function()
    local peds = GetGamePool('CPed')

    for k,v in pairs(peds) do
        DeletePed(v)
    end
end)

RegisterNetEvent('KKF.AntiCheat.ClearVehicles', function()
    local vehicles = GetGamePool('CVehicle')

    for k,v in pairs(vehicles) do
        DeleteVehicle(v)
    end
end)

RegisterNetEvent('KKF.AntiCheat.ClearPickups', function()
    local pickups = GetGamePool('CPickup')

    for k,v in pairs(pickups) do
        DeleteObject(v)
    end
end)

RegisterNetEvent('KKF.AntiCheat.Screenshot', function(desc)
    exports['screenshot-basic']:requestScreenshotUpload('https://upload.gyazo.com/api/upload', 'imagedata', {
        headers = {
            ['authorization'] = string.format('Bearer %s', GlobalState.image_api)
        }
    }, function(data)
        local resp = json.decode(data)
        
        TriggerServerEvent('KKF.AntiCheat.SendLog', {resp.url, desc})
    end)
end)