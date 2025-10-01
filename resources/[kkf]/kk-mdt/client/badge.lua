RegisterNetEvent('kk-mdt:client:chooseBadgeTarget', function(data)
    local closestPlayer, closestDist = QBCore.Functions.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDist < 3.0 then
        local targetId = GetPlayerServerId(closestPlayer)
        TriggerServerEvent('kk-mdt:server:showBadgeTo', targetId, data)
    else
        TriggerServerEvent('kk-mdt:server:showBadgeTo', nil, data)
    end
end)

RegisterNetEvent('kk-mdt:client:showBadgeSelf', function(data)
    if not data then return end

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'showBadge',
        data = data
    })

    if cache.vehicle then return end
    local badge_prop = exports['kk-scripts']:spawnAttachedObject(
        cache.ped,
        joaat('prop_fib_badge'),
        57005,
        0.13, 0.05, -0.06,
        40.0, 55.0, -267.0
    )
    lib.requestAnimDict('paper_1_rcm_alt1-7')
    TaskPlayAnim(cache.ped, 'paper_1_rcm_alt1-7', 'player_one_dual-7', 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    Wait(7000)
    DetachEntity(badge_prop, false, false)
    ClearPedTasks(cache.ped)
    DeleteObject(badge_prop)
    DeleteEntity(badge_prop)
    SetNuiFocus(false, false)
end)

RegisterNetEvent('kk-mdt:client:showBadgeOther', function(data)
    if not data then return end

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'showBadge',
        data = data
    })

    Wait(7000)
    SetNuiFocus(false, false)
end)
