RegisterNetEvent('kk-police:bodycam:joined')
AddEventHandler('kk-police:bodycam:joined', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if xPlayer and (xPlayer.job.name == 'police' or xPlayer.job.name == 'ambulance') and xPlayer.job.onDuty then
        MySQL.Async.fetchAll('SELECT badge, department FROM users WHERE pid = @pid', {
            ['@pid'] = xPlayer.identifier
        }, function(result)
            TriggerClientEvent("kk-police:bodycam:controls", xPlayer.source, 
                xPlayer.name .. " [" .. result[1].badge .. "]", 
                (result[1].department == "LSPD" and "Los Santos Police Department" or 
                 result[1].department == "BCSO" and "Blaine County Sheriff's Office"))
        end)
    end
end)

