local function hasWeapon()
    local returnable = false

    for k,v in pairs(Config.cashWeapons) do
        if HasPedGotWeapon(cache.ped, v, false) then
            returnable = true
        end
    end

    return returnable
end

local function robCashRegister(entity)
    if DoesEntityExist(entity) and hasWeapon() then
        local canRob = lib.callback.await('kk-robberies:cash_register:canRob', false, GetEntityCoords(entity))

        if canRob then
            local entityCache = {
                position = GetEntityCoords(entity),
                heading = GetEntityHeading(entity)
            }
        
            SetEntityAsMissionEntity(entity, true, true)
            DeleteEntity(entity)
    
            local newEntity = CreateObject(`prop_till_01_dam`, entityCache.position, true, true, false)
    
            PlaceObjectOnGroundProperly(newEntity)
            SetEntityHeading(newEntity, entityCache.heading)
    
            local position = GetOffsetFromEntityInWorldCoords(newEntity, 0.0, -0.5, 0.0)
            
            SetEntityHeading(cache.ped, GetEntityHeading(newEntity))
            SetEntityCoordsNoOffset(cache.ped, position)
            -- TriggerServerEvent('kk-dispatch:server:sendMessage', "Poe turvaalarm", '10-92', {'police'}, { { 'fa-solid fa-circle-info', 'Kassa' } }, 'bg-yellow-700')

            local entity = exports['kk-scripts']:spawnAttachedObject(cache.ped, joaat('prop_cs_heist_bag_02'), 57005, 0.0, 0.0, -0.16, 250.0, -30.0, 0.0)
            local progress = exports['kk-taskbar']:startAction('pick_money', 'Korjad raha kokku', 30000, 'grab', 'anim@heists@ornate_bank@grab_cash_heels', {freeze = true, controls = true})
    
            if progress then
                lib.callback.await('kk-robberies:cash_register:performRobbery', false, GetEntityCoords(newEntity), GetNameOfZone(atmCoords))
            end
    
            DetachEntity(entity, cache.ped); DeleteEntity(entity)
        else
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Tunned, et antud tegevus ei ole vajalik ja loobud!')
        end
    end
end

for i = 1, #Config.cashRegisters do
    local point = lib.points.new(Config.cashRegisters[i], 10.0, {})
    
    function point:nearby()
        local cashRegister = GetClosestObjectOfType(GetEntityCoords(cache.ped), 1.5, `prop_till_01`, false, false, false)

        if DoesEntityExist(cashRegister) then
            if #(GetEntityCoords(cache.ped) - GetEntityCoords(cashRegister)) < 1.5 then
                if IsControlJustReleased(0, 24) then
                    robCashRegister(cashRegister)
                end
            end
        end
    end
end