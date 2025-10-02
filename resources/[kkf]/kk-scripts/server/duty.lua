RegisterNetEvent('kk-scripts:server:toggleDuty')
AddEventHandler('kk-scripts:server:toggleDuty', function()
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)

    if xPlayer then
        if xPlayer.job.name == 'police' and xPlayer.job.grade == 0 then return end
        xPlayer.toggleDuty()
    end
end)

RegisterNetEvent('KKF.Player.DutyChange')
AddEventHandler('KKF.Player.DutyChange', function(source, val, silent)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(source)

    if xPlayer then
        if val then
            if xPlayer.job.name == 'police' then
                MySQL.Async.fetchAll('SELECT department FROM users WHERE pid = @pid', {
                    ['@pid'] = xPlayer.identifier
                }, function(result)
                    if result[1].department == 'BCSO' then
                        TriggerEvent('eblips:add', {name = xPlayer.job.grade_label..' '..xPlayer.name, src = xPlayer.source, color = 25})
                    else
                        TriggerEvent('eblips:add', {name = xPlayer.job.grade_label..' '..xPlayer.name, src = xPlayer.source, color = 29})
                    end
                end)
            elseif xPlayer.job.name == 'ambulance' then
                TriggerEvent('eblips:add', {name = xPlayer.job.grade_label..' '..xPlayer.name, src = xPlayer.source, color = 1})
            end
            
            if not silent then
                exports['kk-scripts']:sendSocietyLog(xPlayer.source, 'GRAAFIK', 'Alustas tööpäeva.')
                TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'info', 'Alustasite tööpäeva!')
            end

            MySQL.Sync.execute('UPDATE users SET lastwork = ? WHERE pid = ?', {
                os.date('%Y-%m-%d %X'),
                xPlayer.identifier
            })
        else
            SetTimeout(300, function() TriggerEvent('eblips:remove', xPlayer.source) end)

            if not silent then
                exports['kk-scripts']:sendSocietyLog(xPlayer.source, 'GRAAFIK', 'Lõpetas tööpäeva.')
                TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'info', 'Lõpetasite tööpäeva!')
            end

            MySQL.Sync.execute('UPDATE users SET lastwork = ? WHERE pid = ?', {
                os.date('%Y-%m-%d %X'),
                xPlayer.identifier
            })
        end
    end
end)

AddEventHandler('KKF.Player.JobUpdate', function(src)
	local xPlayer = KKF.GetPlayerFromId(src)

    if xPlayer then
        if xPlayer.job.onDuty then
            if xPlayer.job.name == 'police' then
                MySQL.Async.fetchAll('SELECT department FROM users WHERE pid = @pid', {
                    ['@pid'] = xPlayer.identifier
                }, function(result)
                    if result[1].department == 'BCSO' then
                        TriggerEvent('eblips:add', {name = xPlayer.job.grade_label..' '..xPlayer.name, src = xPlayer.source, color = 25})
                    else
                        TriggerEvent('eblips:add', {name = xPlayer.job.grade_label..' '..xPlayer.name, src = xPlayer.source, color = 29})
                    end
                end)
            elseif xPlayer.job.name == 'ambulance' then
                TriggerEvent('eblips:add', {name = xPlayer.job.grade_label..' '..xPlayer.name, src = src, color = 1})
            else
                TriggerEvent("eblips:remove", src)
            end
        else
            TriggerEvent("eblips:remove", src)
        end
    end
end)

AddEventHandler('playerDropped', function()
    local xPlayer = KKF.GetPlayerFromId(source)

    if not xPlayer then return end
    if not xPlayer.job.onDuty then return end
    TriggerEvent('eblips:remove', xPlayer.source)
    MySQL.Sync.execute('UPDATE users SET lastwork = ? WHERE pid = ?', {
        os.date('%Y-%m-%d %X'),
        xPlayer.identifier
    })
end)
