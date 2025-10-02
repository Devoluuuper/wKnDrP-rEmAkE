
local ox_inventory = exports.ox_inventory


lib.callback.register('kk-police:checkVin', function(source, plate)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = nil


    if xPlayer then
        MySQL.Async.fetchAll("SELECT * FROM user_vehicles WHERE fakeplate = @fakeplate",{
            ['@fakeplate'] = plate
        }, function(result)
			if result[1] then
				returnable = result[1].ownername
			else
				MySQL.Async.fetchAll("SELECT * FROM user_vehicles WHERE plate = @plate",{
					['@plate'] = plate
				}, function(result2)
					if result2[1] then
						returnable = result2[1].ownername
					else
						returnable = false
					end
				end)
			end
		end)
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)



RegisterNetEvent('kk-police:server:fixGun', function(slot)
	local src = source
	local xPlayer = KKF.GetPlayerFromId(src)

	if xPlayer then
		ox_inventory:SetDurability(xPlayer.source, slot, 100)
	end
end)


lib.callback.register('kk-police:getItems', function(source)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)
    local returnable = {}

    if xPlayer then
        local inventory = ox_inventory:Inventory(xPlayer.source).items

        for _, item in ipairs(inventory) do
            if cfg.policeItems[item.name] then
                table.insert(returnable, item)
            end
        end
    end

    while returnable == nil do Wait(50) end
    return returnable
end)


-----
local function sendToDiscord(webhookUrl, title, description, color)
    local embedData = {
        {
            ["title"] = title,
            ["description"] = description,
            ["color"] = color,
            ["footer"] = {
                ["text"] = os.date("%d/%m/%Y %H:%M:%S"),
            },
            ["author"] = {
                ["name"] = 'LSPD System',
                ["icon_url"] = "https://i.imgur.com/JI7bULY.png",
            }
        }
    }

    PerformHttpRequest(webhookUrl, function(err, text, headers) 
        if err ~= 200 then
            print(('Failed to send webhook (HTTP %s): %s'):format(err, text))
        end
    end, 'POST', json.encode({ username = "LSPD Bot", embeds = embedData }), { ['Content-Type'] = 'application/json' })
end

-- Save police application directly to mdt_candidacies table
lib.callback.register('kk-police:sendApplication', function(source, email, text)
    local xPlayer = KKF.GetPlayerFromId(source)
    if not xPlayer then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Player not found!', 5000, 'error')
        return false
    end

    local fullName = xPlayer.name
    local citizenId = xPlayer.identifier
    local phone = xPlayer.get('phone') or 'N/A'

    -- Optional: lisame automaatselt info tekstile
    local description = string.format('**Application:**\n%s\n\n**Info:**\nNimi: %s\nEmail: %s\nTelefon: %s', text, fullName, email, phone)

    -- Insert into SQL table mdt_candidacies
    local query = [[
        INSERT INTO mdt_candidacies (citizenid, name, email, text, date)
        VALUES (?, ?, ?, ?, UNIX_TIMESTAMP(NOW()))
    ]]
    local result = MySQL.query.await(query, {citizenId, fullName, email, description})

    if result then
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Kandideerimine edukalt salvestatud!', 5000, 'success')
        return true
    else
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'Kandideerimise salvestamine ebaõnnestus!', 5000, 'error')
        return false
    end
end)

lib.callback.register('kk-police:sendStatement', function(source, email, text)
    local xPlayer = KKF.GetPlayerFromId(source)
    if xPlayer then
        local userInfo = string.format('Nimi: %s\nEmail: %s\nTelefon: %s', xPlayer.name, email, xPlayer.get('phone') or 'N/A')
        local description = string.format('**Statement:**\n%s\n\n**Info:**\n%s', text, userInfo)

        sendToDiscord(
            'https://discord.com/api/webhooks/https://discord.com/api/webhooks/1312494370817179699/oOB0diLahURKmlnqZTbvPM0nybu8hYYN925PvoyWPGDU0YeNnTauEJ2i6TQMemHJx8tF', 
            'Uus Statement', 
            description, 
            3447003
        )

        return true
    end

    return false
end)


RegisterNetEvent('kk-police:server:buyNewId', function()
    local xPlayer = KKF.GetPlayerFromId(source)

    if not xPlayer then
        return
    end

    local bankMoney = xPlayer.getAccount('bank').money
    local idCardCost = 500

    if bankMoney >= idCardCost then
        xPlayer.removeAccountMoney('bank', idCardCost)

        exports.ox_inventory:AddItem(
            source, 
            'idcard', 
            1, 
            {
                pid = xPlayer.identifier,
                name = xPlayer.name,
                sex = xPlayer.get('sex'),
                dob = xPlayer.get('dateofbirth'),
            }
        )

        TriggerClientEvent('KKF.UI.ShowNotification', source, 'success', 'Ostsite uue isikutunnistuse hinnaga $500!')
    else
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Teil ei ole piisavalt raha pangakontol, et osta uut isikutunnistust!')
    end
end)



RegisterNetEvent('kk-police:server:onSteal', function(networkId, label)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)

    if xPlayer then
        local entity = NetworkGetEntityFromNetworkId(networkId)
        local plate = exports['kk-vehicles']:getPlate(entity)

        if DoesEntityExist(entity) then
            local vehicleOwner = MySQL.prepare.await(
                'SELECT owner FROM user_vehicles WHERE plate = ?;',
                { tostring(plate) }
            )

            if vehicleOwner ~= xPlayer.identifier then
                if not timeoutedVehicles[plate] then
                    timeoutedVehicles[plate] = true
                    
                    TriggerClientEvent('kk-dispatch:client:sendDispatch', -1, src, 'Sõiduki vargus', '10-98', {'police'}, {
                        {'fa-solid fa-car-side', label},
                        {'fa-solid fa-id-card', GetVehicleNumberPlateText(entity)}
                    }, 'bg-blue-700')

                    SetTimeout(3 * 60000, function()
                        timeoutedVehicles[plate] = nil
                    end)
                end
            end
        end
    end
end)
