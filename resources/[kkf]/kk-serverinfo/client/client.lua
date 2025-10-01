local resourceName = GetCurrentResourceName()
local isFirstOpen = true
local isServerInfoPopUpOpen, lastRequestTime, latestInfo = false, 0, {}

local function openServerInfoPopUp()
    if isFirstOpen == true then
        isFirstOpen = false
        sendLocaleDataToNui()
    end
    isServerInfoPopUpOpen = true

    local time, serverInfo = GetCloudTimeAsInt()
    if time - lastRequestTime < clientConfig.updateDelay then
        serverInfo = latestInfo
    else
        TriggerServerEvent('kub_serverinfo:server:getServerInfo')
        return
    end

    SendNUIMessage({
        action = 'setServerInfoVisibility',
        status = true,
        info = serverInfo
    })
end

local function closeServerInfoPopUp()
    isServerInfoPopUpOpen = false
    SendNUIMessage({
        action = 'setServerInfoVisibility',
        status = false
    })
end

CreateThread(function()
    while true do
        if IsControlJustPressed(0, clientConfig.key) and not isServerInfoPopUpOpen then
            openServerInfoPopUp()
        elseif isServerInfoPopUpOpen and IsControlJustReleased(0, clientConfig.key) then
            closeServerInfoPopUp()
        end
        Wait(0)
    end
end)

RegisterNetEvent('kub_serverinfo:client:getServerInfo', function(info)
    latestInfo = info
    lastRequestTime = GetCloudTimeAsInt()
    SendNUIMessage({
        action = 'setServerInfoVisibility',
        status = true,
        info = latestInfo
    })
end)

function sendLocaleDataToNui()
    local JSON = LoadResourceFile(resourceName, ('locales/%s.json'):format(sharedConfig.locale)) or
        LoadResourceFile(resourceName, 'locales/en.json')
    SendNUIMessage({
        action = 'setLocale',
        data = JSON and json.decode(JSON) or {}
    })
end



----- ID ---------------------

disPlayerNames = 5
keyToToggleIDs = 57
commandDelay = 5000

playerDistances = {}
showIDsAboveHead = false
lastCommandTime = 0

CreateThread(function()
    while true do
        if IsControlPressed(0, keyToToggleIDs) then
            showIDsAboveHead = true
            local currentTime = GetGameTimer()
            if (currentTime - lastCommandTime) >= commandDelay then
                ExecuteCommand("me uurib pingsalt ümbrust")
                lastCommandTime = currentTime
            end
        else
            showIDsAboveHead = false
        end
        Wait(0)
    end
end)

CreateThread(function()
    while true do
        for id = 0, 255 do
            if GetPlayerPed(id) then
                x1, y1, z1 = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
                x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
                distance = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x2,  y2,  z2,  true))
                playerDistances[id] = distance
            end
        end
        Wait(1000)
    end
end)

CreateThread(function()
    while true do
        if showIDsAboveHead then
            for id = 0, 255 do
                if NetworkIsPlayerActive(id) then
                    x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
                    if (playerDistances[id] < disPlayerNames) then
                        if NetworkIsPlayerTalking(id) then
                            DrawText3D(x2, y2, z2 + 1, GetPlayerServerId(id), 63, 63, 191)
                        else
                            DrawText3D(x2, y2, z2 + 1, GetPlayerServerId(id), 255, 255, 255)
                        end
                    end
                end
            end
        end
        Wait(0)
    end
end)

function DrawText3D(x, y, z, text, r, g, b)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)

    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

    if onScreen then
        SetTextScale(0.0 * scale, 0.55 * scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end
