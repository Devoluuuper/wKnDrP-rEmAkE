local blips = {}
local showZones = true

RegisterCommand('showZones', function()
    showZones = not showZones
end)

local function drawZonePart(zoneName, id, color, x1, y1, x2, y2)
    local centerX = (x1 + x2) / 2
    local centerY = (y1 + y2) / 2

    local width = math.abs(x1 - x2)
    local height = math.abs(y1 - y2)

    local blip = AddBlipForArea(centerX, centerY, 0.0, width, height)

    SetBlipColour(blip, color or 0)
    SetBlipAlpha(blip, 80)
    SetBlipAsShortRange(blip, true)

    SetBlipDisplay(blip, 3)

    return blip
end

RegisterNetEvent('kk-factions:client:reloadZones', function(zones)
    Config.gangZones = zones
end)

local warning = false

SetInterval(function()
    if LocalPlayer.state.isLoggedIn then
        local coords = GetEntityCoords(cache.ped)
        local zone = GetNameOfZone(coords)
    
        if Config.gangZones[zone] and Config.gangZones[zone].turf then
            if not warning then
                TriggerEvent('chatMessage', 'VALITSUS', 'black', 'Sisenesite ohtlikusse alasse! Lahkuge sellest alast viivitamatult!')
                warning = true
            end
        else
            if warning then
                TriggerEvent('chatMessage', 'VALITSUS', 'black', 'Lahkusite ohtlikust alast!')
                warning = false
            end
        end

        if showZones and ESX.PlayerData.job.type == 'gang' then
            for name, zone in pairs(Config.gangZones) do
                Wait(0)

                for i = 1, #zone.zoneParts do
                    local part = zone.zoneParts[i]
                    local blipName = name .. '_' .. i

                    if blips[blipName] then
                        if blips[blipName]['color'] ~= zone.color then
                            RemoveBlip(blips[blipName]['handle'])

                            blips[blipName] = nil
                        end
                    else
                        blips[blipName] = {
                            handle = drawZonePart(name, zone.id, zone.color, part.x1, part.y1, part.x2, part.y2),
                            color = zone.color
                        }
                    end
                end
            end

            for name, zone in pairs(Config.gangZones) do
                for i = 1, #zone.zoneParts do
                    local blipName = name .. '_' .. i

                    if blips[blipName] then
                        SetBlipFlashes(blips[blipName]['handle'], zone.turf)
                    end
                end
            end
        elseif showZones and ESX.PlayerData.job.type ~= 'gang' then
            for name, zone in pairs(Config.gangZones) do
                Wait(0)

                if zone.turf then
                    for i = 1, #zone.zoneParts do
                        local part = zone.zoneParts[i]
                        local blipName = name .. '_' .. i
    
                        if blips[blipName] then
                            if blips[blipName]['color'] ~= 1 then
                                RemoveBlip(blips[blipName]['handle'])
    
                                blips[blipName] = nil
                            end
                        else
                            blips[blipName] = {
                                handle = drawZonePart(name, zone.id, 1, part.x1, part.y1, part.x2, part.y2),
                                color = 1
                            }

                            SetBlipFlashes(blips[blipName]['handle'], true)
                        end
                    end
                else
                    for i = 1, #zone.zoneParts do
                        local part = zone.zoneParts[i]
                        local blipName = name .. '_' .. i
    
                        if blips[blipName] then
                            if blips[blipName].handle then
                                RemoveBlip(blips[blipName].handle)
                            end
                        end
                    end
                end
            end
        else
            for id, blip in pairs(blips) do
                if DoesBlipExist(blip.handle) then
                    RemoveBlip(blip.handle)
                end

                blips[id] = nil
            end
        end
    end
end, 1000)