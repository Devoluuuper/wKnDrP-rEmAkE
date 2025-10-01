local evidence = {}
local weaponEquipped = nil
local systemTime = 0
local update = true

RegisterNetEvent('kk-evidence:client:loadEvidence', function(data)
    evidence = data
end)

AddEventHandler('ox_inventory:currentWeapon', function(currentWeapon)
    weaponEquipped = currentWeapon?.name
end)

RegisterNetEvent('KKF.Player.Loaded', function()
    exports.ox_inventory:displayMetadata({
        evidenceId = 'ID',
        date = 'Kuupäev',
        analyzed = 'Analüüsitud',
    })
end)

CreateThread(function()
    while true do
        systemTime = lib.callback.await('kk-evidence:systemTime', false)

        Wait(60000)
    end
end)

CreateThread(function()
    while true do
        wait = 5000

        if GetRainLevel() > 0.3 then
            TriggerServerEvent('kk-evidence:server:removeEverything')
            wait = 10000
        end

        Wait(wait)
    end
end)

RegisterNetEvent('kk-evidence:client:collect', function()
    local found = false
    local coords = GetEntityCoords(cache.ped)

    for k, v in pairs(evidence) do
        if not found then
            if #(v.coords - GetEntityCoords(cache.ped)) < 2 then
                found = true

                TriggerServerEvent('kk-evidence:server:collect', k)
            end
        end
    end

    if not found then
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Läheduses ei ole ühtegi asja, mida üles korjata!')
    end
end)

CreateThread(function()
    while true do
        wait = 0

        if IsPlayerFreeAiming(cache.playerId) and weaponEquipped == 'WEAPON_FLASHLIGHT' then
            if update then
                TriggerServerEvent('kk-evidence:server:loadEvidence')
                update = false
            end

            for k, v in pairs(evidence) do
                if #(v.coords - GetEntityCoords(cache.ped)) < 30 then
                    if v.data.type == 'Veri' then
                        DrawMarker(28, v.coords.x, v.coords.y, v.coords.z, 0, 0, 0, 0, 0, 0, 0.1, 0.1, 0.1, 202, 22, 22, 141, 0, 0, 0, 0)
                    elseif v.data.type == 'Kuulid' then
                        DrawMarker(25, v.coords.x, v.coords.y, v.coords.z, 0, 0, 0, 0, 0, 0, 0.1, 0.1, 0.1, 252, 255, 1, 141, 0, 0, 0, 0)
                    end
                end

                if #(v.coords - GetEntityCoords(cache.ped)) < 5 then
                    local status = '~g~Värske~s~'
                    local passed = systemTime - v.time

                    if passed > 300 and passed < 600 then
                        status = '~y~Uus~s~'
                    elseif passed > 600 then
                        status = '~r~Vana~s~'
                    end

                    ESX.Game.Utils.DrawText3D(vec3(v.coords.x, v.coords.y, v.coords.z + 0.2), v.data.type .. ' - ' .. status)
                end
            end
        else
            update = true; wait = 1500
        end

        Wait(wait)
    end
end)

CreateThread(function()
    while true do
        wait = 10
        local coords = GetEntityCoords(cache.ped)

        if IsShockingEventInSphere(104, coords.x, coords.y, coords.z, 999999.0) then
            if HasEntityBeenDamagedByAnyPed(cache.ped) then
                ClearEntityLastDamageEntity(cache.ped)

                TriggerServerEvent('kk-evidence:server:saveEvidence', coords, GetInteriorFromEntity(cache.ped), {
                    type = 'Veri'
                })

                wait = 2000
            end
        end

        if IsPedShooting(cache.ped) and weaponEquipped then
            TriggerServerEvent('kk-evidence:server:saveEvidence', coords, GetInteriorFromEntity(cache.ped), {
                type = 'Kuulid',
                weapon = joaat(weaponEquipped)
            })

            wait = 2000
        end

        Wait(wait)
    end
end)