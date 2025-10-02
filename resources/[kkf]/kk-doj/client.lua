RegisterNUICallback('closeMenu', function(data, cb)
    SetNuiFocus(false, false)

    cb(true)
end)

local function openMenu()
    -- Kutsu callback, aga dokumenti ei kontrollita
    local documentData, caseData = lib.callback.await('kk-doj:fetchDocument', false)

    -- Saada NUI-le andmed, isegi kui dokument puudub
    SendNUIMessage({ 
        action = 'openMenu',
        data = {
            identification = documentData or {}, -- kui puudub, siis tühi tabel
            cases = caseData or {} -- kui juhtumeid pole, tühi tabel
        }
    })

    SetNuiFocus(true, true)
end
for k,v in pairs(cfg.locations) do
    KKF.CreateBlip(k .. '_pd', v.coords, 'Department of Justice', 60, 5, 0.7)

    exports.ox_target:addBoxZone({
        coords = v.coords,
        size = v.size,
        rotation = v.rotation,
        debug = false,
        options = {
            {
                icon = 'fa-solid fa-file',
                label = 'Esita avaldus',
                distance = 1.5,
                onSelect = openMenu
            },
        }
    })
end

RegisterNUICallback('sendNotification', function(data, cb)
    TriggerEvent('KKF.UI.ShowNotification', data.type, data.msg)

    cb(true)
end)

RegisterNUICallback('sendInfo', function(data, cb)
    lib.callback('kk-doj:sendInfo', false, function(response)
        cb(response)
    end, data.mail, data.phone, data.case, data.description)
end)