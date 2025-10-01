RegisterNetEvent('kk-badge:server:showBadge')
AddEventHandler('kk-badge:server:showBadge', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer then
        if xPlayer.job.name == 'police' then
            MySQL.Async.fetchAll('SELECT profilepic, badge, department FROM users WHERE pid = @pid', {
                ['@pid'] = xPlayer.identifier
            }, function(result)
                local badgeInfo = {
                    ['name'] = xPlayer.name,
                    ['rank'] = xPlayer.job.grade_label,
                    ['serial'] = result[1].badge,
                    ['picture'] = result[1].profilepic,
                    ['department'] = result[1].department
                }
    
                TriggerClientEvent('kk-badge:client:animation', xPlayer.source)
                TriggerClientEvent("kk-badge:client:showBadge", -1, badgeInfo, xPlayer.source)
            end)
        elseif xPlayer.job.name == 'doj' then
            MySQL.Async.fetchAll('SELECT profilepic, badge, department FROM users WHERE pid = @pid', {
                ['@pid'] = xPlayer.identifier
            }, function(result)
                local badgeInfo = {
                    ['name'] = xPlayer.name,
                    ['rank'] = xPlayer.job.grade_label,
                    ['serial'] = result[1].badge,
                    ['picture'] = result[1].profilepic,
                    ['department'] = 'doj'
                }
    
                TriggerClientEvent('kk-badge:client:animation', xPlayer.source)
                TriggerClientEvent("kk-badge:client:showBadge", -1, badgeInfo, xPlayer.source)
            end)
		elseif xPlayer.job.name == 'ambulance' then
            MySQL.Async.fetchAll('SELECT profilepic, badge, department FROM users WHERE pid = @pid', {
                ['@pid'] = xPlayer.identifier
            }, function(result)
                local badgeInfo = {
                    ['name'] = xPlayer.name,
                    ['rank'] = xPlayer.job.grade_label,
                    ['serial'] = result[1].badge,
                    ['picture'] = result[1].profilepic,
                    ['department'] = 'ambulance'
                }
    
                TriggerClientEvent('kk-badge:client:animation', xPlayer.source)
                TriggerClientEvent("kk-badge:client:showBadge", -1, badgeInfo, xPlayer.source)
            end)
        end
    end
end)

RegisterNetEvent('kk-badge:server:viewBadge')
AddEventHandler('kk-badge:server:viewBadge', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer then
        if xPlayer.job.name == 'police' then
            MySQL.Async.fetchAll('SELECT profilepic, badge, department FROM users WHERE pid = @pid', {
                ['@pid'] = xPlayer.identifier
            }, function(result)
                local badgeInfo = {
                    ['name'] = xPlayer.name,
                    ['rank'] = xPlayer.job.grade_label,
                    ['serial'] = result[1].badge,
                    ['picture'] = result[1].profilepic,
                    ['department'] = result[1].department
                }
    
                TriggerClientEvent("kk-badge:client:viewBadge", xPlayer.source, badgeInfo)
            end)
        elseif xPlayer.job.name == 'doj' then
            MySQL.Async.fetchAll('SELECT profilepic, badge, department FROM users WHERE pid = @pid', {
                ['@pid'] = xPlayer.identifier
            }, function(result)
                local badgeInfo = {
                    ['name'] = xPlayer.name,
                    ['rank'] = xPlayer.job.grade_label,
                    ['serial'] = result[1].badge,
                    ['picture'] = result[1].profilepic,
                    ['department'] = 'doj'
                }
    
                TriggerClientEvent("kk-badge:client:viewBadge", xPlayer.source, badgeInfo)
            end)			
	  elseif xPlayer.job.name == 'ambulance' then
            MySQL.Async.fetchAll('SELECT profilepic, badge, department FROM users WHERE pid = @pid', {
                ['@pid'] = xPlayer.identifier
            }, function(result)
                local badgeInfo = {
                    ['name'] = xPlayer.name,
                    ['rank'] = xPlayer.job.grade_label,
                    ['serial'] = result[1].badge,
                    ['picture'] = result[1].profilepic,
                    ['department'] = 'ambulance'
                }
    
                TriggerClientEvent("kk-badge:client:viewBadge", xPlayer.source, badgeInfo)
            end)
        end
    end
end)