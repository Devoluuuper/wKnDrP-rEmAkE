local point = nil
local entity = nil

CreateThread(function()
    while not LocalPlayer.state.isLoggedIn do
        Wait(500)
    end

    exports['kk-scripts']:requestModel(`a_m_m_business_01`)
    entity = CreatePed(4, `a_m_m_business_01`, cfg.sellPed.x, cfg.sellPed.y, cfg.sellPed.z - 1, cfg.sellPed.w or 0, false, false)
	
    SetBlockingOfNonTemporaryEvents(entity, true)
    SetPedDiesWhenInjured(entity, false)
    SetPedCanPlayAmbientAnims(entity, true)
    SetPedCanRagdollFromPlayerImpact(entity, false)
    SetEntityInvincible(entity, true)
    FreezeEntityPosition(entity, true)

    ESX:CreateBlip('p_seller', cfg.sellPed.xyz, 'Maakler', 525, 5, 0.8)

    point = lib.points.new({ coords = GetEntityCoords(entity), distance = 2 })
     
    function point:onEnter()
        exports['rm_dialognpc']:createDialog(entity, {
            pedModel = `a_m_m_business_01`,
            pedName = "Maakler",
            title = 'Olete äkki huvitatud kinnisvara rentimisest?',
            coords = {
                { coords = GetEntityCoords(entity) }
            },
            buttons = {
                { title = "Jah, ikka", func = "buyProperty", icon = "fa-solid fa-thumbs-up"},
                { title = "Ei, tänan", func = "no", icon = "fa-solid fa-ban"}
            }
        }, 'Müük')
    end
end)

local shopOpen = false

RegisterNetEvent('kk-properties2:client:buyProperty', function()
    shopOpen = true
    SendNUIMessage({action = 'openShop', data = lib.callback.await('kk-properties2:fetchBuyable', false)})
    SetNuiFocus(true, true)

    CreateThread(function()
        while shopOpen do
            InvalidateIdleCam()
            InvalidateVehicleIdleCam()

            Wait(1000)
        end
    end)
end)

RegisterNUICallback('closeShop', function()
    shopOpen = false
    SendNUIMessage({action = 'closeShop'})
    SetNuiFocus(false, false)
end)

RegisterNUICallback('buyProperty', function(data, cb)
    lib.callback('kk-properties2:buyProperty', false, function(response)
        cb(response)
    end, data.id)
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
        if DoesEntityExist(entity) then
            DeleteEntity(entity)
            entity = nil
        end
	end
end)