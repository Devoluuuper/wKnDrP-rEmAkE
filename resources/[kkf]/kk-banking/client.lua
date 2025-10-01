local function open(type)
    SetNuiFocus(true, true)
    
    lib.callback('kk-banking:requestData', false, function(response)
        TriggerEvent('kk-banking:client:updateData', response)
        SendNUIMessage({
            action = 'open',
            data = {
                type = type,
                faction = response.faction
            }
        })
    end)
end

CreateThread(function()
    exports.ox_target:addModel({506770882, -1364697528, -1126237515, -870868698, 3168729781, 2930269768, 3424098598}, {
        {
            name = 'bank_atms',
            icon = 'fa-solid fa-building-columns',
            label = 'Ava pank',
            distance = 1.5,
            onSelect = function(data)
                local progress = exports['kk-taskbar']:startAction('banking_open', 'Tegeled kaardiga', 2000, 'enter', 'anim@amb@prop_human_atm@interior@male@enter', {freeze = false, controls = true, disableCancel = true})
    
                if progress then
                    open('atm')
                end
            end
        }
    })

    for k,v in pairs(cfg.banks) do
        ESX.CreateBlip('bank_' .. k, v.coords, 'Pank', 431, 2, 0.7)

        exports.ox_target:addBoxZone({
            coords = v.coords,
            size = v.size,
            rotation = v.rotation,
            debug = false,
            options = {
                {
                    name = 'banks',
                    icon = 'fa-solid fa-building-columns',
                    label = 'Ava pank',
                    distance = 2.0,
                    onSelect = function(data)
                        local progress = exports['kk-taskbar']:startAction('banking_open', 'Tegeled paberimajandusega', 2000, 'enter', 'anim@amb@prop_human_atm@interior@male@enter', {freeze = false, controls = true, disableCancel = true})
            
                        if progress then
                            open('bank')
                        end
                    end
                },
                {
                    name = 'check',
                    serverEvent = 'KKF.ExchangeCheck',
                    icon = 'fas fa-money-bill-wave',
                    label = 'Väljasta palgaleht',
                    distance = 3.0
                    --canInteract = function()
                    --end
                }
            }
        })
    end
end)

RegisterNUICallback('close', function(args, cb)
    SetNuiFocus(false, false); SendNUIMessage({action = 'close'})
end)

RegisterNetEvent('kk-banking:client:updateData', function(data)
    SendNUIMessage({action = 'update', data = data})
end)

RegisterNUICallback('loadLogs', function(args, cb)
    lib.callback('kk-banking:loadLogs', false, function(response)
        cb(response)
    end)
end)

RegisterNUICallback('loadBills', function(args, cb)
    lib.callback('kk-banking:loadBills', false, function(response)
        cb(response)
    end)
end) 

RegisterNUICallback('payBill', function(args, cb)
    lib.callback('kk-banking:payBill', false, function(response)
        cb(response)
    end, args.id)
end)

RegisterNUICallback('deposit', function(args, cb)
    lib.callback('kk-banking:deposit', false, function(response)
        cb(response)
    end, args.amount)
end)

RegisterNUICallback('withdraw', function(args, cb)
    lib.callback('kk-banking:withdraw', false, function(response)
        cb(response)
    end, args.amount)
end)

RegisterNUICallback('transferMoney', function(args, cb)
    lib.callback('kk-banking:transferMoney', false, function(response)
        cb(response)
    end, args.pid, args.amount)
end)

RegisterNUICallback('factionDeposit', function(args, cb)
    lib.callback('kk-banking:factionDeposit', false, function(response)
        cb(response)
    end, args.amount)
end)

RegisterNUICallback('factionWithdraw', function(args, cb)
    lib.callback('kk-banking:factionWithdraw', false, function(response)
        cb(response)
    end, args.amount)
end)