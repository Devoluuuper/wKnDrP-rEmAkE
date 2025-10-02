local ox_target = exports.ox_target
local targets = {}

CreateThread(function()
    KKF.PlayerData = KKF.GetPlayerData()
end)

RegisterNetEvent('KKF.Player.Loaded', function(xPlayer)
	KKF.PlayerData = xPlayer
end)

RegisterNetEvent('KKF.Player.JobUpdate', function(job)
	KKF.PlayerData.job = job
end)

RegisterNetEvent('KKF.Player.DutyChange', function(value)
	KKF.PlayerData.job.onDuty = value
end)

RegisterNetEvent('KKF.Player.Unloaded', function()
    KKF.PlayerData.job = {}
end)

local function openMenu(k)
    if KKF.PlayerData.job.name == Config.PaymentList[k].owner and KKF.PlayerData.job.onDuty then
        local input = lib.inputDialog('Arve loomine', {'Arve summa'})

        if input then
            local price = tonumber(input[1])
        
            lib.callback('kk-scripts:sendPayment', false, function(response)
                if response then
                    TriggerEvent('KKF.UI.ShowNotification', 'info', 'Arve esitatud!')
                else
                    TriggerEvent('KKF.UI.ShowNotification', 'error', 'Siit on juba arve esitatud!')
                end
            end, k, price)
        end
    else
        lib.callback('kk-scripts:recievePaymentInfo', false, function(info)
            if info then
                local elements = {
                    {
                        icon = 'fa-solid fa-cash-register',
                        title = 'Summa: $' .. info.price .. ' + VAT ' .. exports['kk-taxes']:getTax('primary').value .. '%.'
                    },

                    {
                        icon = 'fa-solid fa-credit-card',
                        title = 'Maksa kaardiga',
                        serverEvent = 'kk-scripts:server:payRestorant',
                        args = { terminal = k, type = 'bank' }
                    },

                    {
                        icon = 'fa-solid fa-money-bill',
                        title = 'Maksa sularahas',
                        serverEvent = 'kk-scripts:server:payRestorant',
                        args = { terminal = k, type = 'cash' }
                    }
                }
                lib.registerContext({
                    id = 'payment_menu',
                    title = 'Restorani terminal',
                    options = elements
                })
            
                lib.showContext('payment_menu')
            else
                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Siia terminali ei ole esitatud ühtegi arvet!')
            end
        end, k)
    end
end

for k,v in pairs(Config.PaymentList) do
    ox_target:addBoxZone({
        coords = v.target.coords,
        size = v.target.size,
        rotation = v.target.rotation,
        debug = false,
        options = {
            {
                icon = 'fa-solid fa-cash-register',
                label = 'Ava terminal',
                onSelect = function(data) openMenu(k) end,
                distance = 1.5
            }
        }
    })
end