lib.locale()

if Config.versionCheck then lib.versionCheck('overextended/ox_fuel') end

local ox_inventory = exports.ox_inventory

local function setFuelState(netid, fuel)
	local vehicle = NetworkGetEntityFromNetworkId(netid)
	local state = vehicle and Entity(vehicle)?.state

	if state then
		state:set('fuel', fuel, true)
	end
end

RegisterNetEvent('ox_fuel:pay', function(price, fuel, netid)
	assert(type(price) == 'number', ('Price expected a number, received %s'):format(type(price)))

	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		xPlayer.removeAccountMoney('bank', price) -- Eemaldab raha pangakontolt

		fuel = math.floor(fuel)
		setFuelState(netid, fuel)

		-- Teavitus edukast maksmisest
		TriggerClientEvent('KKF.UI.ShowNotification', source, 'success', locale('fuel_success', fuel, price))
	else
		print(('[OX_FUEL] Player [%s] not found when attempting to pay'):format(source))
	end
end)

-- RegisterNetEvent('ox_fuel:pay', function(price, fuel, netid)
-- 	assert(type(price) == 'number', ('Price expected a number, received %s'):format(type(price)))

-- 	ox_inventory:RemoveItem(source, 'money', price)

-- 	fuel = math.floor(fuel)
-- 	setFuelState(netid, fuel)

-- 	TriggerClientEvent('ox_lib:notify', source, {
-- 		type = 'success',
-- 		description = locale('fuel_success', fuel, price)
-- 	})
-- end)


local function isMoneyEnough(money, price)
	if money < price then
		local missingMoney = price - money
		TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', locale('not_enough_money', missingMoney))
		return false
	else
		return true
	end
end

RegisterNetEvent('ox_fuel:fuelCan', function(price)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then
		print(('[OX_FUEL] Player [%s] not found'):format(source))
		return
	end

	local money = xPlayer.getAccount('bank').money

	if money < price then
		local missingMoney = price - money
		TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', locale('not_enough_money', missingMoney))
		return
	end
	if not ox_inventory:CanCarryItem(source, 'WEAPON_PETROLCAN', 1) then
		TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', locale('petrolcan_cannot_carry'))
		return
	end

	ox_inventory:AddItem(source, 'WEAPON_PETROLCAN', 1)
	xPlayer.removeAccountMoney('bank', price)

	TriggerClientEvent('KKF.UI.ShowNotification', source, 'success', locale('petrolcan_buy', price))
end)


RegisterNetEvent('ox_fuel:updateFuelCan', function(durability, netid, fuel)
	local source = source
	local item = ox_inventory:GetCurrentWeapon(source)

	if item and durability > 0 then
		durability = math.floor(item.metadata.durability - durability)
		item.metadata.durability = durability
		item.metadata.ammo = durability

		ox_inventory:SetMetadata(source, item.slot, item.metadata)
		setFuelState(netid, fuel)
		Wait(0)
		return TriggerClientEvent('ox_inventory:disarm', source)
	end

	-- player is sus?
end)

RegisterNetEvent('ox_fuel:createStatebag', function(netid, fuel)
	local vehicle = NetworkGetEntityFromNetworkId(netid)
	local state = vehicle and Entity(vehicle).state

	if state and not state.fuel and GetEntityType(vehicle) == 2 and NetworkGetEntityOwner(vehicle) == source then
		state:set('fuel', fuel > 100 and 100 or fuel, true)
	end
end)



lib.callback.register('ox_fuel:getBank', function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer then
        return xPlayer.getAccount('bank').money
    else
        return 0
    end
end)
