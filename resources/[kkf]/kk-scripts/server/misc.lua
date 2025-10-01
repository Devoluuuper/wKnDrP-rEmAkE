local ox_inventory = exports.ox_inventory

RegisterNetEvent('KKF.Player.RemoveItem')
AddEventHandler('KKF.Player.RemoveItem', function(item, amount, metadata)
	local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        ox_inventory:RemoveItem(xPlayer.source, item, amount, metadata or nil)
    end
end) 

RegisterNetEvent('tackle:server:TacklePlayer', function(playerId)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer then
        TriggerClientEvent("tackle:client:GetTackled", playerId)
    end
end)


RegisterNetEvent('kk-core:server:removeAccountMoney')
AddEventHandler('kk-core:server:removeAccountMoney', function(ammount)
	local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        xPlayer.removeAccountMoney('money', tonumber(ammount))
    end
end)

lib.callback.register('kk:misc:getId', function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
        returnable = xPlayer.name
    else
        returnable = 'Tegus Timmu'
    end

    while returnable == nil do Wait(50) end; return returnable
end)

lib.callback.register('KKF.Item.Amount', function(source, item)
	local xPlayer = ESX.GetPlayerFromId(source)
    local returnable = nil

    if xPlayer then 
        returnable = ox_inventory:GetItem(xPlayer.source, item).count or 0
    else
        returnable = 0
    end

    while returnable == nil do Wait(50) end; return returnable
end)


lib.callback.register('kk-scripts:reduceUsage', function(source, item)
    local returnable = nil

    local itemdata = exports.ox_inventory:GetSlot(source, item)
    -- print(json.encode(itemdata))
    -- print(itemdata.metadata.usages)
    if itemdata.metadata.usages > 0 then
        local newusage = itemdata.metadata.usages - 1
        ox_inventory:SetMetadata(source, item, { usages = newusage })
        -- print(newusage)
        returnable = newusage
    end

    while returnable == nil do 
        Wait(50) 
    end 
    return returnable
end)


AddEventHandler('playerDropped', function(reason)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local crds = GetEntityCoords(GetPlayerPed(src))
    local dateofleave = os.date("%Y/%m/%d %X")

	if xPlayer then
        local type = '~r~[DISCONNECT]~w~'

        if reason:find('crashed') then
            type = '~r~[CRASH]~w~'
        end
    
        exports['kk-scripts']:sendLog(xPlayer.identifier, 'MUU', 'Lahkus serverist! Põhjus: ' .. reason .. '.')
		TriggerClientEvent('KKF:misc:createDisconnectText', -1, src, crds, type .. " ID: ".. src .. "; PID: ".. xPlayer.identifier.."; Nimi: ".. xPlayer.name .."; Aeg: "..dateofleave.."")
	end
end)

local function OnPlayerConnecting(name, setKickReason, deferrals)
    local src = source
	local identifier = ESX.GetPlayerIdentifier(src)

    if identifier then
        MySQL.Async.fetchAll('SELECT pid FROM users WHERE identifier = @identifier', {
            ['@identifier'] = identifier
        }, function(result)
            if result and result[1] then
                exports['kk-scripts']:sendLog(result[1].pid, 'MUU', 'Liitub serveriga.')
            end
        end)
    end
end

AddEventHandler("playerConnecting", OnPlayerConnecting)

RegisterCommand('tel', function(source, args)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

	if xPlayer then
		TriggerClientEvent('KKF:chat:sendProximityMessage', -1, xPlayer.source, 'KONTAKT', 'Nimi: '.. xPlayer.name .. '; Telefoninumber: '.. xPlayer.phone .. '')
	end
end)