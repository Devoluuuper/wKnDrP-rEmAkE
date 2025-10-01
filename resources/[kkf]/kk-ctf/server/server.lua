local eventStarted = false
local eventTimer = 0
local controllers = {
    ['A'] = {
        owner = 'none',
        label = 'Vaba'
    },

    ['B'] = {
        owner = 'none',
        label = 'Vaba'
    },

    ['C'] = {
        owner = 'none',
        label = 'Vaba'
    }
}

if #controllers > 3 then return end 

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    MySQL.Async.fetchAll('SELECT * FROM territories', {}, function(result)
        for k,v in pairs(result) do
            controllers[v.point].owner = v.owner; controllers[v.point].label = v.label
        end
    end)
end)

RegisterNetEvent('KKF.Player.Loaded', function(src)
    Wait(5000)

    if eventStarted then
        TriggerClientEvent('kk-ctf:client:startCapturing', src)
        TriggerClientEvent('kk-ctf:client:updateControllers', src, controllers)
    end 
end)

CreateThread(function()
    while true do
        if eventTimer > 0 then
            eventTimer = eventTimer - 1
        end 

        Wait(60000)
    end
end)

RegisterServerEvent('kk-ctf:server:startCapturing', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer then
        if xPlayer.isAdmin() then
            if not eventStarted then
                eventTimer = 0
                controllers = {
                    ['A'] = {
                        owner = 'none',
                        label = 'Vaba'
                    },
                
                    ['B'] = {
                        owner = 'none',
                        label = 'Vaba'
                    },
                
                    ['C'] = {
                        owner = 'none',
                        label = 'Vaba'
                    }
                }

                eventStarted = true; exports['kk-scripts']:sendLog(xPlayer.identifier, 'A-TEAM', 'Alustas hõivamise üritust.')

                TriggerClientEvent('kk-dispatch:client:sendDispatch', xPlayer.source, '10-93', 'police', 'ALGAS HÕIVAMINE')
                TriggerClientEvent('kk-ctf:client:startCapturing', -1)
                TriggerClientEvent('kk-ctf:client:updateControllers', -1, controllers)
            else
                TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Hetkel ei saa hõivamist alustada!')
            end
        end
    end
end)

RegisterServerEvent('kk-ctf:server:stopCapturing', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer then
        if xPlayer.isAdmin() then
            if eventTimer == 0 and eventStarted then
                eventStarted = false; exports['kk-scripts']:sendLog(xPlayer.identifier, 'A-TEAM', 'Lõpetas hõivamise ürituse.')

                TriggerClientEvent('kk-ctf:client:updateControllers', -1, controllers)
                TriggerClientEvent('kk-ctf:client:endCapturing', -1, {a = controllers['A'].label,b = controllers['B'].label,c = controllers['C'].label})

                for k,v in pairs(controllers) do
                    MySQL.Sync.execute('UPDATE territories SET owner = ?, label = ? WHERE point = ?', {
                        v.owner,
                        v.label,
                        k
                    })
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Hetkel ei saa hõivamist lõpetada!')
            end
        end
    end
end)

lib.callback.register('kk-ctf:checkIllegal', function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        if xPlayer.job.name ~= 'unemployed' then
            MySQL.Async.fetchAll('SELECT type FROM jobs WHERE name = ? AND type = ?', { xPlayer.job.name, 'illegal' }, function(result)
                if result and result[1] then
                    returnable = true
                else
                    returnable = false
                end
            end)
        else
            returnable = false
        end
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

lib.callback.register('kk-ctf:startCapturing', function(source, point)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        controllers[point].owner = xPlayer.job.name; controllers[point].label = xPlayer.job.label

        TriggerClientEvent('kk-ctf:client:updateControllers', -1, controllers)
        returnable = true
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

lib.callback.register('kk-ctf:checkOwner', function(source, point)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        returnable = controllers[point].owner == xPlayer.job.name
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)