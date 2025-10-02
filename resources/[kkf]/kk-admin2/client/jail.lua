local inZone = false
local inPrisoned = false

local function enterPrison()
    inZone = true

    if not inPrisoned then
        SetEntityCoords(cache.ped, cfg.outJail)
    end
end

local function leavePrison()
    inZone = false

    if inPrisoned then
        CreateThread(function()
            while not inZone do
                SetEntityCoords(cache.ped, cfg.adminJail)
                Wait(1500)
            end
        end)
    end
end

CreateThread(function()
    local prisonZone = lib.zones.box({
        name = "jail",
        coords = vec3(-916.68133544922, -2527.5825195312, 36.323120117188),
        size = vec3(20, 20, 20),
        rotation = 0.0,

        onEnter = enterPrison,
        onExit = leavePrison
    })
end)

RegisterNetEvent('kk-admin2:client:jailPerson', function(time, spawn)
    inPrisoned = true

    SetEntityCoords(cache.ped, cfg.adminJail)
    TriggerEvent('chatMessage', 'AJAIL' , 'info', 'Teil on jäänud ' .. time .. ' minutit vanglas.')

    CreateThread(function()
        while inPrisoned do
            local myNeeds = exports['kk-scripts']:getNeeds()

            for k,v in pairs(myNeeds) do
                if k ~= 'stress' then
                    if v.val < 5000 then
                        TriggerEvent('kk-needs:client:setNeed', k, 5000)
                    end
                else
                    TriggerEvent('kk-needs:client:setNeed', 'stress', v.val / 2)
                end
            end

            if LocalPlayer.state.isDead then
                TriggerEvent('kk-ambulance:revive', false)
            end

            Wait(5000)
        end
    end)
end)

RegisterNetEvent('kk-admin2:client:doCheck', function()
    if not inZone then
        SetEntityCoords(cache.ped, cfg.outJail)
    end
end)

RegisterNetEvent('kk-admin2:client:endJail', function()
    inPrisoned = false

    SetEntityCoords(cache.ped, cfg.outJail)
end)

RegisterNUICallback('jailPerson', function(data, cb)
    TriggerServerEvent('kk-admin2:server:jailPerson', data.target, data.time)
end)

TriggerEvent('chat:addSuggestion', '/ajail', 'Vangista mängija.', {
    { name = 'id'},
	{ name = 'time'}
}) 

TriggerEvent('chat:addSuggestion', '/unajail', 'Eemalda mängija vangistusest.', {
    { name = 'id'}
})

RegisterNUICallback('unjailPerson', function(data, cb)
    TriggerServerEvent('kk-admin2:server:unjailPerson', data.target)
end) 

RegisterNUICallback('unjailRealPerson', function(data, cb)
    TriggerServerEvent('kk-jail:server:unjailPerson', data.target)
end)