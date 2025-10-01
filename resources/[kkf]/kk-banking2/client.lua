local currentType = nil

local function loadAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Wait(5)
	end
end

local function openBank(index, type)
    currentType = type

    SendNUIMessage({
        action = 'openBank',
        type = type
    })

    SetNuiFocus(true, true)

    CreateThread(function()
        while currentType do
            InvalidateIdleCam()
            InvalidateVehicleIdleCam()

            Wait(1000)
        end
    end)
end

CreateThread(function()
    while not LocalPlayer.state.isLoggedIn do
        Wait(2000)
    end

    Wait(2000)

    for i = 1, #cfg.banks do
        ESX.CreateBlip('bank_' .. i, cfg.banks[i].coords.xyz, 'Pank', 431, 2, 0.7)

        exports['kk-scripts']:requestModel(cfg.banks[i].hash)
        cfg.banks[i].entity = CreatePed(4, cfg.banks[i].hash, cfg.banks[i].coords.x, cfg.banks[i].coords.y, cfg.banks[i].coords.z - 1, cfg.banks[i].coords.w, false, false)

        PlaceObjectOnGroundProperly(cfg.banks[i].entity)
        SetBlockingOfNonTemporaryEvents(cfg.banks[i].entity, true)
        SetPedDiesWhenInjured(cfg.banks[i].entity, false)
        SetPedCanPlayAmbientAnims(cfg.banks[i].entity, true)
        SetPedCanRagdollFromPlayerImpact(cfg.banks[i].entity, false)
        SetEntityInvincible(cfg.banks[i].entity, true)
        FreezeEntityPosition(cfg.banks[i].entity, true)

        if cfg.banks[i].anim then
            loadAnimDict(cfg.banks[i].anim.dict)
            TaskPlayAnim(cfg.banks[i].entity, cfg.banks[i].anim.dict, cfg.banks[i].anim.item, 8.0, 8.0, -1, 2, 0.0, false, false, false)
        end

        local point = lib.points.new({
            coords = vec3(cfg.banks[i].coords.x, cfg.banks[i].coords.y, cfg.banks[i].coords.z + 0.8),
            distance = 5,
            name = cfg.banks[i].name
        })
        
        function point:nearby()
            ESX.Game.Utils.DrawText3D(self.coords, self.name)
        end

        exports.ox_target:addLocalEntity(cfg.banks[i].entity, {
            {
                name = 'banking_' .. i,
                distance = 1.5,
                icon = 'fa-solid fa-microphone',
                label = 'Suhtle pankuriga',

                onSelect = function()
                    local progress = exports['kk-taskbar']:startAction('banking_open', 'Tegeled paberimajandusega', 2000, 'enter', 'anim@amb@prop_human_atm@interior@male@enter', {freeze = false, controls = true, disableCancel = true})
    
                    if progress then
                        openBank(i, 'bank')
                    end
                end,
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
        })
    end

    exports.ox_target:addModel({506770882, -1364697528, -1126237515, -870868698, 3168729781, 2930269768, 3424098598}, {
        {
            name = 'bank_atms',
            icon = 'fa-solid fa-building-columns',
            label = 'Ava pank',
            distance = 1.5,
            onSelect = function(data)
                local progress = exports['kk-taskbar']:startAction('banking_open', 'Tegeled kaardiga', 2000, 'enter', 'anim@amb@prop_human_atm@interior@male@enter', {freeze = false, controls = true, disableCancel = true})
    
                if progress then
                    openBank(i, 'atm')
                end
            end
        }
    })
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if cfg.banks then
            for i = 1, #cfg.banks do
                DeletePed(cfg.banks[i].entity)
            end
        end
    end
end)

RegisterNUICallback('closeTablet', function(data, cb)
    currentType = nil
    SetNuiFocus(false, false)
    cb(true)
end)

RegisterNUICallback('loadData', function(data, cb)
    lib.callback('kk-banking2:loadData', false, function(response)
        cb(response)
    end, data.type)
end)

RegisterNUICallback('payInvoice', function(data, cb)
    lib.callback('kk-banking2:payInvoice', false, function(response)
        cb(response)
    end, data.type, data.id)
end)

RegisterNUICallback('sendMoney', function(data, cb)
    lib.callback('kk-banking2:sendMoney', false, function(response)
        cb(response)
    end, data.type, data.identifier, data.amount)
end)

RegisterNUICallback('moneyOutIn', function(data, cb)
    if data.action == 'in' and currentType == 'atm' then
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Sularahaautomaadist ei saa raha sisestada!')

        return
    end

    lib.callback('kk-banking2:moneyOutIn', false, function(response)
        cb(response)
    end, data.type, data.action, data.amount)
end)