local money = {40000, 60000}
local timeout = 0
local data = {
    owner = 0,
	vehicle = nil,
	driver = nil,
	passenger = nil,
    action = 0
}

lib.callback.register('kk-truckrobbery:canStartRobbery', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local returnable = nil

    if xPlayer then
        if timeout == 0 then
            if data.owner == 0 then
                if xPlayer.hasItem('hacking_tablet') then
                    returnable = true
                else
                    returnable = false
                end
            else
                returnable = false
            end
        else
            returnable = false
        end
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

lib.callback.register('kk-truckrobbery:startRobbery', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local returnable = nil

    if xPlayer then
        xPlayer.removeInventoryItem('hacking_tablet', 1)

        data.owner = xPlayer.identifier

        TriggerClientEvent('kk-truckrobbery:client:loadData', xPlayer.source, data)
        returnable = true
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

AddEventHandler('KKF.Player.Dropped', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if data.owner == xPlayer.identifier then
        data = {
            owner = 0,
            vehicle = nil,
            driver = nil,
            passenger = nil,
            action = 0
        }

        TriggerClientEvent('kk-truckrobbery:client:destroyRobbery', playerId)
        TriggerClientEvent('kk-dispatch:client:sendDispatch', playerId, "10-65", 'police', "RAHAAUTORÖÖV KATKESTATI")

        timeout = 1

        SetTimeout(22 * 60000, function()
            timeout = 0
        end)

        TriggerClientEvent('KKF.UI.ShowNotification', playerId, 'error', 'Katkestasite rahaautoröövi!')
    end
end)

AddEventHandler('KKF.Player.Unloaded', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if data.owner == xPlayer.identifier then
        data = {
            owner = 0,
            vehicle = nil,
            driver = nil,
            passenger = nil,
            action = 0
        }

        TriggerClientEvent('kk-truckrobbery:client:destroyRobbery', playerId)
        TriggerClientEvent('kk-dispatch:client:sendDispatch', playerId, "10-65", 'police', "RAHAAUTORÖÖV KATKESTATI")

        timeout = 1

        SetTimeout(22 * 60000, function()
            timeout = 0
        end)

        TriggerClientEvent('KKF.UI.ShowNotification', playerId, 'error', 'Katkestasite rahaautoröövi!')
    end
end)

lib.callback.register('kk-truckrobbery:spawn', function(source, location)
    local xPlayer = ESX.GetPlayerFromId(source)
    local returnable = nil

    if xPlayer then
        if data.owner == xPlayer.identifier then
            TriggerClientEvent('kk-dispatch:client:sendDispatch', xPlayer.source, "10-65", 'police', "RAHAAUTORÖÖV")
            local entites = {}

            entites.vehicle = CreateVehicle(`stockade`, location.x, location.y, location.z + 3, location.w, true, true)
            entites.driver = CreatePed(4, `s_m_m_security_01`, location.x, location.y + 3, location.z, location.w, true, false)
            entites.passenger = CreatePed(4, `s_m_m_security_01`, location.x, location.y + 3, location.z, location.w, true, false)

            GiveWeaponToPed(entites.driver, `WEAPON_CARBINERIFLE`, 9999, false, true)
            GiveWeaponToPed(entites.passenger, `WEAPON_PUMPSHOTGUN`, 9999, false, true)

            for k,v in pairs(entites) do
                while not DoesEntityExist(v) do Wait(50) end
                entites[k] = NetworkGetNetworkIdFromEntity(v)
            end

            data.vehicle = entites.vehicle
            data.driver = entites.driver
            data.passenger = entites.passenger

            TriggerClientEvent('kk-truckrobbery:client:loadData', xPlayer.source, data)
            
            returnable = entites
        else
            returnable = false
        end
    else
        returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

RegisterNetEvent('KKF.Player.Loaded', function(source, xPlayer)
    if data.owner == xPlayer.identifier then
	    TriggerClientEvent('kk-truckrobbery:client:loadData', source, data)
    end
end)

RegisterNetEvent('kk-truckrobbery:server:doAction', function(type, coords)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        if data.owner == xPlayer.identifier then
            if type ~= 'loot' then
                if type == 'c4_bank' then Wait(10000) end
                TriggerClientEvent('kk-truckrobbery:client:openDoors', -1, type, coords)

                data.action = 1; TriggerClientEvent('kk-truckrobbery:client:loadData', xPlayer.source, data)
            else
                xPlayer.addAccountMoney('money', math.random(money[1], money[2]))

                data = {
                    owner = 0,
                    vehicle = nil,
                    driver = nil,
                    passenger = nil,
                    action = 0
                }

                TriggerClientEvent('kk-truckrobbery:client:destroyRobbery', source)

                timeout = 1

                SetTimeout(45 * 60000, function()
                    timeout = 0
                end)
            end
        end
    end
end)