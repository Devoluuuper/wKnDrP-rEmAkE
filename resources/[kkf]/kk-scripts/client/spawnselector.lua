local menuOpen = false
local selectedPos = nil
local locations = {
    [1] = {x = 53.23,y = 6338.368,z = 30.38},
    [2] = {x = 1705.687,y = 3779.661,z = 33.758},
    [3] = { x = -1369.1604003906, y = 55.450550079346, z = 53.695190429688, h = 93.543304443359},
    [4] = {x = 922.01, y = 44.92, z = 81.11},
    [5] = {x = -1802.93, y = -1187.05, z = 13.01},
    [6] = { x = -280.44393920898, y = -1054.3253173828, z = 27.1904296875, h = 198.42520141602},
    [7] = { x = 637.8857421875, y = -0.17142486572265, z = 82.778076171875, h = 249.44882202148}
}



RegisterNUICallback('locationChoosen', function(args, cb)
    selectedPos = locations[args.id]; menuOpen = false
    SetNuiFocus(false, false)
end)

RegisterNUICallback('lastLocation', function(args, cb)
    menuOpen = false
    SetNuiFocus(false, false)
end)

RegisterNetEvent('kk-scripts:client:openSpawn', function(spawn, health)
    DoScreenFadeOut(2); selectedPos = spawn; menuOpen = true;
    SendNUIMessage({action = 'open'}); SetNuiFocus(true, true)

    while menuOpen do
        Wait(250)
    end

    TriggerEvent('KKF.SpawnCharacter', selectedPos, health)
end)