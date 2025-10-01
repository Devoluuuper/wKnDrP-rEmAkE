local vehicles = {}
local stocks = {}

local categories = {
    ['Compacts'] = {
        name = 'Väikeautod'
    },
    ['Sedans'] = {
        name = 'Sedaanid'
    },
    ['Sports'] = {
        name = 'Sportautod'
    },
    ['Sports Classics'] = {
        name = 'Klassikalised sportautod'
    },
    ['Supers'] = {
        name = 'Superautod'
    },
    ['Muscle'] = {
        name = 'Muscle autod'
    },
    ['Off-Road'] = {
        name = 'Off Road'
    },
    ['SUV'] = {
        name = 'Maasturid'
    },
    ['VAN'] = {
        name = 'Kaubikud'
    },
    ['Motorcycles'] = {
        name = 'Mootorrattad'
    },
    ['Cycles'] = {
        name = 'Rattad'
    },
    -- ['Special'] = {
    --     name = 'Special'
    -- },
    -- ['Police'] = {
    --     name = 'Law Enforcement'
    -- }
}

RegisterNUICallback('buyVehicle', function(args, cb)
    TriggerServerEvent('kk-vehicleshop:server:buyVehicle', args.id)
    SetNuiFocus(false, false); SendNUIMessage({action = 'closeMenu'})
end)

RegisterNUICallback('closeMenu', function(args, cb)
    SetNuiFocus(false, false); SendNUIMessage({action = 'closeMenu'})
end)

RegisterNUICallback('back', function(args, cb)
    SetNuiFocus(false, false); SendNUIMessage({action = 'closeMenu'})
    TriggerEvent('kk-vehicleshop:client:open')
end)

RegisterNetEvent('KKF.Player.Loaded', function(xPlayer)
    ESX.PlayerData = xPlayer

    lib.callback('kk-vehicleshop:recieveVehicles', false, function(resp)
        vehicles = resp
    end)

    lib.callback('kk-vehicleshop:recieveStocks', false, function(response)
        stocks = response
    end)

    ESX.CreateBlip('vehicleshop', vec3(-56.75, -1098.5, 26.0), 'Autopood', 326, nil, 0.7)
    SetDefaultVehicleNumberPlateTextPattern(-1, 'AA111AAA')
end)

exports('getVehicle', function(model)
    local returnable = nil

    for k,v in pairs(vehicles) do
        if joaat(k) == model then
            returnable = v
        end
    end

    return returnable
end)

exports('getVehiclePrice', function(model)
    local returnable = nil

    for k,v in pairs(vehicles) do
        if joaat(k) == model then
            returnable = v.price
        end
    end

    return returnable
end)

CreateThread(function()
    for k,v in pairs(categories) do
        RegisterNetEvent('kk-vehicleshop:client:view' .. k, function(data)
            if k ~= 'Special' and k ~= 'Police' then
                stocks = lib.callback.await('kk-vehicleshop:recieveStocks', false)

                for k,v in pairs(stocks) do
                    if vehicles[v.vehicle] then
                        vehicles[v.vehicle].currentStock = v.stock or 'unlimited'
                    end
                end

                local elements = {}
            
                for k2,v2 in pairs(vehicles) do
                    if not v2.removedCar and not v2.specialVehicle and not v2.policeVehicle then
                        if string.upper(v2.category) == string.upper(k) then
                            elements[k2] = v2
                        end
                    end
                end

                SetNuiFocus(true, true); SendNUIMessage({action = 'openMenu', data = elements, vat = exports['kk-taxes']:getTax('primary').value})
            elseif k == 'Special' then
                if data and data.vehicles then
                    local elements = {}
                    local specialVehicles = data.vehicles

                    for k,v in pairs(specialVehicles) do
                        if vehicles[v.model] then
                            elements[v.model] = {
                                currentStock = v.redeems or 0,
                                label = vehicles[v.model].label,
                                price = vehicles[v.model].price,
                                img = vehicles[v.model].img
                            }
                        end
                    end

                    SetNuiFocus(true, true); SendNUIMessage({action = 'openMenu', data = elements, vat = exports['kk-taxes']:getTax('primary').value})
                end
            elseif k == 'Police' then
                if data and data.vehicles then
                    stocks = lib.callback.await('kk-vehicleshop:recieveStocks', false)

                    for k,v in pairs(stocks) do
                        if data.vehicles[v.vehicle] then
                            data.vehicles[v.vehicle].currentStock = v.stock or 'unlimited'
                        end
                    end    

                    SetNuiFocus(true, true); SendNUIMessage({action = 'openMenu', data = data.vehicles, vat = exports['kk-taxes']:getTax('primary').value})
                end
            end
        end)
    end
end)

RegisterNetEvent('kk-vehicleshop:client:open', function()
    local elements = {}

    for k,v in pairs(categories) do
        if k ~= 'Special' and k ~= 'Police' then
            elements[#elements + 1] = {
                title = v.name,
                event = 'kk-vehicleshop:client:view' .. k,
            }
        end
    end

    local specialVehicles = lib.callback.await('kk-vehicleshop:fetchSpecial', false)

    if specialVehicles then
        elements[#elements + 1] = {
            title = 'Special',
            event = 'kk-vehicleshop:client:viewSpecial',
            args = { vehicles = specialVehicles }
        }
    end

    local policeVehicles = lib.callback.await('kk-vehicleshop:fetchPolice', false)

    if policeVehicles then
        elements[#elements + 1] = {
            title = 'Law Enforcement',
            event = 'kk-vehicleshop:client:viewPolice',
            args = { vehicles = policeVehicles }
        }
    end

    lib.registerContext({
        id = 'vehicle_shop',
        title = 'Autopood',
        options = elements
    })
    
    lib.showContext('vehicle_shop')	
end)
