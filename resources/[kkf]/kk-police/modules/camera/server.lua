lib.callback.register('kk-police:updatePhoto', function(source, id, link)
	local xPlayer = ESX.GetPlayerFromId(source)
    local returnable = nil

	if xPlayer then
        local xTarget = ESX.GetPlayerFromId(id)

        if xTarget then
            MySQL.Async.execute('UPDATE users SET profilepic = ? WHERE pid = ?', {tostring(link), xTarget.identifier}, function(result)
                returnable = true
            end)
        else
            returnable = false
        end
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)
