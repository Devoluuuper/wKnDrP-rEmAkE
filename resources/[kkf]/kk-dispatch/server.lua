local data = {}
local phoneNumbers = {}
local ox_inventory = exports.ox_inventory

local function registerCmd(table)
    if table.type == 'legal' then
        phoneNumbers[string.lower(table.name)] = {}

        RegisterCommand(string.lower(table.name), function(source, args)
            local src = source
            local xPlayer = KKF.GetPlayerFromId(src)

            if xPlayer then
                if xPlayer.hasItem('phone') then
                    if args[1] then
                        local message = ''

                        for k,v in ipairs(args) do
                            message = message .. " " .. v
                        end

                        local jobName = table.name -- Here you can put every job what has been registered by KKF.
                        local message = string.upper(message) -- Here you can put a message that will be shown to people with job above.

                        TriggerClientEvent('kk-dispatch:client:sendDispatch', xPlayer.source, 'TELEFON: ' .. xPlayer.phone, jobName, message, nil, true)
                    else
                        TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Palun sisestage sõnum!')
                    end
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Teil ei ole telefoni!')
                end
            end
        end, false)
    end
end

local function getCalls()
    return data
end

exports('getCalls', getCalls)

lib.callback.register('kk-dispatch:loadCalls', function(source)
    local xPlayer = KKF.GetPlayerFromId(source)

    return data[xPlayer.job.name]
end)

AddEventHandler('KKF.Player.Loaded', function(playerId, xPlayer)
    for k,v in pairs(phoneNumbers) do
        TriggerClientEvent('chat:addSuggestion', playerId, '/' .. k, 'Saada sisestatud tööle töösõnum.', {
            { name="sisu" }
        }) 
    end
end)

MySQL.ready(function()
	local result = MySQL.Sync.fetchAll('SELECT * FROM jobs', {})

	for i=1, #result, 1 do
        data[result[i].name] = {}
        registerCmd(result[i])
	end
end)

RegisterServerEvent('kk-dispatch:server:acceptCall', function(id)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local nr = tonumber(id)

    if xPlayer.job.onDuty then 
        local count = #data[xPlayer.job.name]

        if count >= nr then
            local call = data[xPlayer.job.name][nr]

            if call then
                local myName = xPlayer.name
                local xTargets = KKF.GetPlayers()

                if xPlayer.job.name == 'police' or xPlayer.job.name == 'ambulance' then
                    MySQL.Async.fetchAll('SELECT badge FROM users WHERE pid = ?', {xPlayer.identifier}, function(result)
                        if result[1] then
                            myName = '[' .. result[1].badge .. '] ' .. xPlayer.name
                        end
                    end)
                end

                TriggerClientEvent('kk-dispatch:client:setMarker', xPlayer.source, {x = call.coords.x, y = call.coords.y})
                exports['kk-scripts']:sendSocietyLog(xPlayer.source, 'KUTSELE REAGEERIMINE', 'ID: ' .. nr .. '; MSG: ' .. call.description)

                SetTimeout(500, function()
                    for i = 1, #xTargets do
                        local xTarget = KKF.GetPlayerFromId(xTargets[i])
    
                        if xTarget.job.name == xPlayer.job.name and xTarget.job.onDuty then
                            TriggerClientEvent('kk-dispatch:client:showResponder', xTarget.source, {id = id, call = call.call, worker = myName})
                        end
                    end    
                end)

                if call.answer then
                    TriggerClientEvent('kk-phone:client:showNotification', call.answer, 'messages', 'Sõnumid', 'Teie saadetud kutsele [' .. nr .. '] reageeritakse!')
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Hetkel ei ole dispetserisse saabunud ühtegi kutset numbriga '..nr..'.')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Hetkel ei ole dispetserisse saabunud ühtegi kutset.')
        end
    end
end)

RegisterServerEvent('kk-dispatch:server:alert')
AddEventHandler('kk-dispatch:server:alert', function(job, info)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)

    if job and info then
		if data[job] then

			data[job][#data[job]+1] = {
                id = count,
                call = info.call,
                description = info.message,
                answer = info.answer,
                location = info.street .. ' | ' .. info.zone,
				coords = {x = info.coords.x, y =  info.coords.y}
			}
			
            local xPlayers = KKF.GetPlayers()

            local count = #data[job]

            data[job][#data[job]].id = count

            for i=1, #xPlayers, 1 do
                local xPlayer = KKF.GetPlayerFromId(xPlayers[i])
            
                if xPlayer.job.name == job and xPlayer.job.onDuty then
                    TriggerClientEvent('kk-dispatch:client:sendAlert', xPlayer.source, {id = count, call = info.call, description = info.message, location = info.street .. ' | ' .. info.zone, panic = info.panic})
                end
            end
		end
	end
end)