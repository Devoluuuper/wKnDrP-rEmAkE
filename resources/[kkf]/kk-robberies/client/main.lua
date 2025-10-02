TriggerEvent('chat:addSuggestion', '/arobbery', 'Keela kõik röövid admin käsklusega.', {})

RegisterNetEvent('kk-robberies:client:setBlip', function(status, position)
    if status then
        robberyBlip = AddBlipForCoord(position.x, position.y, position.z)
        SetBlipSprite(robberyBlip, 161)
        SetBlipScale(robberyBlip, 2.0)
        SetBlipColour(robberyBlip, 3)
        PulseBlip(robberyBlip)
    else
        RemoveBlip(robberyBlip)
    end
end)

--------------- Heists-

RegisterNetEvent('kk-heists:client:startParticle', function(position)
    lib.requestNamedPtfxAsset('scr_ornate_heist')
    SetPtfxAssetNextCall('scr_ornate_heist')
    
    local effect = StartParticleFxLoopedAtCoord('scr_heist_ornate_thermal_burn', position, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
    
    SetTimeout(15000, function()
        StopParticleFxLooped(effect, 0)
    end)
end)
