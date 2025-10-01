RegisterNetEvent('kk-taxes:client:editTaxes', function()
    lib.callback('kk-taxes:getTaxes', false, function(taxes)
        local elements = {}

        for k,v in pairs(taxes) do
            elements[#elements + 1] = {
                icon = 'fa-solid fa-sack-dollar',
                title = v.label,
                description = v.value .. '%',
                arrow = true,
                event = 'kk-taxes:client:editTax',
                args = {tax = k, values = v}
            }
        end

        lib.registerContext({
            id = 'tax_menu',
            title = 'Maksud',
            options = elements
        })

        lib.showContext('tax_menu')
    end)
end)

RegisterNetEvent('kk-taxes:client:editTax', function(data)
    local input = lib.inputDialog('Maks ' .. data.values.label, {
        {type = 'number', label = 'Summa', default = data.values.value}
    })
    
    if input and input[1] then
        if (input[1] > 100 or input[1] < 0) then
            return TriggerEvent('KKF.UI.ShowNotification', 'error', 'Maksuprotsent ei saa olla suurem, kui 100 või väiksem kui 0.')
        end

        TriggerServerEvent('kk-taxes:server:editTax', data.tax, input[1])
    end
end)

local function getTax(tax)
    local result = lib.callback.await('kk-taxes:getTaxes', false, tax) or 0
    return result
end

exports('getTax', getTax)

TriggerEvent('chat:addSuggestion', '/taxes', 'Tee muudatusi maksusüsteemis.')
