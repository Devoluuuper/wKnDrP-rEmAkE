if not lib then return end

local Items = require 'modules.items.shared' --[[@as table<string, OxClientItem>]]

local function sendDisplayMetadata(data)
    SendNUIMessage({
		action = 'displayMetadata',
		data = data
	})
end

--- use array of single key value pairs to dictate order
---@param metadata string | table<string, string> | table<string, string>[]
---@param value? string
local function displayMetadata(metadata, value)
	local data = {}

	if type(metadata) == 'string' then
        if not value then return end

        data = { { metadata = metadata, value = value } }
	elseif table.type(metadata) == 'array' then
		for i = 1, #metadata do
			for k, v in pairs(metadata[i]) do
				data[i] = {
					metadata = k,
					value = v,
				}
			end
		end
	else
		for k, v in pairs(metadata) do
			data[#data + 1] = {
				metadata = k,
				value = v,
			}
		end
	end

    if client.uiLoaded then
        return sendDisplayMetadata(data)
    end

    CreateThread(function()
        repeat Wait(100) until client.uiLoaded

        sendDisplayMetadata(data)
    end)
end

exports('displayMetadata', displayMetadata)

---@param _ table?
---@param name string?
---@return table?
local function getItem(_, name)
    if not name then return Items end

	if type(name) ~= 'string' then return end

    name = name:lower()

    if name:sub(0, 7) == 'weapon_' then
        name = name:upper()
    end

    return Items[name]
end

setmetatable(Items --[[@as table]], {
	__call = getItem
})

---@cast Items +fun(itemName: string): OxClientItem
---@cast Items +fun(): table<string, OxClientItem>

local function Item(name, cb)
	local item = Items[name]
	if item then
		if not item.client?.export and not item.client?.event then
			item.effect = cb
		end
	end
end

local ox_inventory = exports[shared.resource]
-----------------------------------------------------------------------------------------------
-- Clientside item use functions
-----------------------------------------------------------------------------------------------

-- Item('wheelchair', function(data, slot)
-- 	ox_inventory:useItem(data, function(data)
-- 		if data then
-- 			TriggerEvent('kk-ambulance:wheelchair')
-- 		end
-- 	end)
-- end)


Item('lockpick', function(data, slot)
	ox_inventory:useItem(data, function(data)
		if data then
            TriggerEvent('lockpick:use', data)
		end
	end)
end)

Item('advancedlockpick', function(data, slot)
	ox_inventory:useItem(data, function(data)
		if data then
            TriggerEvent('lockpick:use', data)
		end
	end)
end)


Item('binoculars', function(data, slot)
	ox_inventory:useItem(data, function(data)
		if data then
			TriggerEvent('binoculars:Activate')
		end
	end)
end)

Item('tunertablet', function(data, slot)
    ox_inventory:useItem(data, function(data)
        if data then
            if exports['kk-tuner']:IsPlayerNearTunershopShowSpot() then
                TriggerServerEvent('kk-tuner:server:showTablet')
            else
				--  Notify äkki?
            end
        else
        end
    end)
end)



Item('armor', function(data, slot)
	if GetPedArmour(PlayerData.ped) < 100 then
		ox_inventory:useItem(data, function(data)
			if data then
				SetPlayerMaxArmour(PlayerData.id, 100)
				SetPedArmour(PlayerData.ped, 100)
			end
		end)
	end
end)

client.parachute = false
Item('parachute', function(data, slot)
	if not client.parachute then
		ox_inventory:useItem(data, function(data)
			if data then
				local chute = `GADGET_PARACHUTE`
				SetPlayerParachuteTintIndex(PlayerData.id, -1)
				GiveWeaponToPed(PlayerData.ped, chute, 0, true, false)
				SetPedGadget(PlayerData.ped, chute, true)
				lib.requestModel(1269906701)
				client.parachute = CreateParachuteBagObject(PlayerData.ped, true, true)
				if slot.metadata.type then
					SetPlayerParachuteTintIndex(PlayerData.id, slot.metadata.type)
				end
			end
		end)
	end
end)

Item('document', function(data, slot)
	exports.ox_inventory:useItem(data, function(data)
		if data then
			TriggerEvent('kk-printer:client:viewDocument', data.metadata.url)
		end
	end)
end)
------------ Mechanic / Mehaanik start
for i = 1, 5 do
	Item('brakes_' .. i, function(data, slot)
		exports.ox_inventory:useItem(data, function(data)
			if data then
				TriggerEvent('kk-mechanic:client:changeBrakes', i, data.metadata.plate)
			end
		end)
	end)
end

for i = 1, 5 do
	Item('suspension_' .. i, function(data, slot)
		exports.ox_inventory:useItem(data, function(data)
			if data then
				TriggerEvent('kk-mechanic:client:changeSuspension', i, data.metadata.plate)
			end
		end)
	end)
end

for i = 1, 5 do
	Item('engine_' .. i, function(data, slot)
		exports.ox_inventory:useItem(data, function(data)
			if data then
				TriggerEvent('kk-mechanic:client:changeEngine', i, data.metadata.plate)
			end
		end)
	end)
end

for i = 1, 5 do
	Item('transmission_' .. i, function(data, slot)
		exports.ox_inventory:useItem(data, function(data)
			if data then
				TriggerEvent('kk-mechanic:client:changeTransmission', i, data.metadata.plate)
			end
		end)
	end)
end

Item('turbo_1', function(data, slot)
	exports.ox_inventory:useItem(data, function(data)
		if data then
			TriggerEvent('kk-mechanic:client:changeTurbo', data.metadata.plate)
		end
	end)
end)

local classes = {'s', 'a', 'b', 'c', 'd', 'm'}

for k,v in pairs(classes) do
	Item('fuel_injector_' .. v, function(data, slot)
		ox_inventory:useItem(data, function(data)
			if data then
				TriggerEvent('kk-mechanic:client:fixPart', v, 'fuel_injector')
			end
		end)
	end)

	Item('radiator_' .. v, function(data, slot)
		ox_inventory:useItem(data, function(data)
			if data then
				TriggerEvent('kk-mechanic:client:fixPart', v, 'radiator')
			end
		end)
	end)

	Item('axle_' .. v, function(data, slot)
		ox_inventory:useItem(data, function(data)
			if data then
				TriggerEvent('kk-mechanic:client:fixPart', v, 'axle')
			end
		end)
	end)

	Item('transmission_' .. v, function(data, slot)
		ox_inventory:useItem(data, function(data)
			if data then
				TriggerEvent('kk-mechanic:client:fixPart', v, 'transmission')
			end
		end)
	end)

	Item('electronics_' .. v, function(data, slot)
		ox_inventory:useItem(data, function(data)
			if data then
				TriggerEvent('kk-mechanic:client:fixPart', v, 'electronics')
			end
		end)
	end)

	Item('brakes_' .. v, function(data, slot)
		ox_inventory:useItem(data, function(data)
			if data then
				TriggerEvent('kk-mechanic:client:fixPart', v, 'brakes')
			end
		end)
	end)

	Item('clutch_' .. v, function(data, slot)
		ox_inventory:useItem(data, function(data)
			if data then
				TriggerEvent('kk-mechanic:client:fixPart', v, 'clutch')
			end
		end)
	end)

	Item('tire_' .. v, function(data, slot)
		ox_inventory:useItem(data, function(data)
			if data then
				TriggerEvent('kk-mechanic:client:fixPart', v, 'tire')
			end
		end)
	end)
end
------------ Consumables (Drinks / Food etc..)
local food = {
	['chips'] = 10000,
	['sandwitch'] = 10000,
	['boke'] = 10000,
	['caesar_salat'] = 10000,
	['cheese_chips'] = 10000,
	['salty_chips'] = 10000,
	['sweet_nothings'] = 10000,
	['zebrabar'] = 10000,
	['earth_quakes'] = 10000,
	['ego_chaser'] = 10000,
	['meteorite'] = 10000,
	['paprica_chips'] = 10000,
	['phatchips_pringles'] = 10000,
	['sticky_ribs_chips'] = 10000,
	['pie'] = 10000,
	['pnqs'] = 10000,

	['double_shot'] = 100000,
	['glorious'] = 100000,
	['prickly'] = 100000,
	['heart_stopper'] = 100000,
	['simply'] = 100000,
	['bleeder'] = 100000,
	['goat_cheese_wrap'] = 100000,
	['chicken_wrap'] = 100000,
	['mexican_taco'] = 100000,
	['fried_french_fries'] = 50000,

	['yakitori'] = 100000,
	['sashimi'] = 100000,
	['ramen'] = 100000,
	['miso_soup'] = 100000,
	['okonomiyaki'] = 100000,
	['gyoza'] = 100000,
	['curry_rice'] = 100000,
	['tempura'] = 100000,

	['brownie'] = 100000,
	['cheescake'] = 100000,
	['gingerbreads'] = 100000,
	['cheese_sandwich'] = 100000,
	['waffles'] = 100000,
	['caramel_donut'] = 100000,
	['red_donut'] = 100000,
	['pink_donut'] = 100000,
	['blue_pink_donut'] = 100000,
	['blue_donut'] = 100000,
	['white_donut'] = 100000,
	['donut'] = 100000,

}

for k,v in pairs(food) do
	Item(k, function(data, slot)
		ox_inventory:useItem(data, function(data)
			if data then
				TriggerEvent('kk-needs:client:onEat', v, k, data.slot)
			end
		end)
	end)
end



local drinks = {
	['milk'] = 10000,
	['cocacola'] = 10000,
	['sprite'] = 10000,
	['water'] = 10000,
	['apple'] = 500,
	['apple_juice'] = 10000,
	['orange_juice'] = 10000,
	['cola_bottle'] = 10000,
	['sprunk_bottle'] = 10000,
	['orango_tang'] = 10000,

	['sprunk_cup'] = 100000,
	['cola_cup'] = 100000,
	['orango_cup'] = 100000,
	['cola_light_cup'] = 100000,

	['mahl'] = 100000,
	['matcha_tea'] = 100000,

	['ice_tea'] = 100000,
	['ice_coffee'] = 100000,
	['caramel_cocktail'] = 100000,
	['chocolate_cocktail'] = 100000,
	['vanilla_cocktail'] = 100000,
	['peppermint_cocktail'] = 100000,
	['peppermint_chocolate_cocktail'] = 100000,
	['mango_smoothie'] = 100000,
	['banana_smoothie'] = 100000,
	['filter_coffee'] = 100000,
	['cappuccino'] = 100000,
	['americano'] = 100000,
	['espresso'] = 100000,
	['latte'] = 100000,
	['caramel_latte'] = 100000,
	['vanilla_latte'] = 100000,
	['hot_chocolate'] = 100000,
}

for k,v in pairs(drinks) do
	Item(k, function(data, slot)
		ox_inventory:useItem(data, function(data)
			if data then
				TriggerEvent('kk-needs:client:onDrink', v, k, data.slot)
			end
		end)
	end)
end

local combined = {
	['meteorite_icecream'] = { hunger = 10000, thirst = 10000, stress = 1000 },
	['orango_icecream'] = { hunger = 10000, thirst = 10000, stress = 1000 },

	['sake'] = { hunger = 10000, thirst = 10000, stress = 1000 },
	['ploomivein'] = { hunger = 10000, thirst = 10000, stress = 1000 },

	['caramel_cocktail'] = { hunger = 10000, thirst = 10000, stress = 1000 },
	['chocolate_cocktail'] = { hunger = 10000, thirst = 10000, stress = 1000 },
	['vanilla_cocktail'] = { hunger = 10000, thirst = 10000, stress = 1000 },
	['peppermint_cocktail'] = { hunger = 10000, thirst = 10000, stress = 1000 },
	['peppermint_chocolate_cocktail'] = { hunger = 10000, thirst = 10000, stress = 1000 },
	['mango_smoothie'] = { hunger = 10000, thirst = 10000, stress = 1000 },
	['banana_smoothie'] = { hunger = 10000, thirst = 10000, stress = 1000 },
}

for k,v in pairs(combined) do
	Item(k, function(data, slot)
		ox_inventory:useItem(data, function(data)
			if data then
				TriggerEvent('kk-needs:client:onCombined', v, k, data.slot)
			end
		end)
	end)
end

-- --------------------------------------------------------------------

--[[Item('phone', function(data, slot)
	exports.npwd:setPhoneVisible(not exports.npwd:isPhoneVisible())
end)]]

Item('empty_evidence_bag', function(data, slot)
	ox_inventory:useItem(data, function(data)
		if data then
			TriggerEvent('kk-evidence:client:collect')
		end
	end)
end)


Item('snake', function(data, slot)
	ox_inventory:useItem(data, function(data)
		if data then
			TriggerServerEvent('kk-police:server:placeSnake')
		end
	end)
end)

local docCooldown = false

Item('idcard', function(data, slot)
	ox_inventory:useItem(data, function(data)
		if data then
			if not docCooldown then
				TriggerServerEvent('kk-documents:server:showId', data.metadata.pid, 'idcard')
				docCooldown = true
						
				SetTimeout(3000, function()
					docCooldown = false			
				end)
			end
		end
	end)
end)

Item('fishing_id', function(data, slot)
	ox_inventory:useItem(data, function(data)
		if data then
			if not docCooldown then
				TriggerServerEvent('kk-documents:server:showId', data.metadata.pid, 'fishing_id', data.metadata.doe)
				docCooldown = true
						
				SetTimeout(3000, function()
					docCooldown = false			
				end)
			end
		end
	end)
end)




Item('scuba_gear', function(data, slot)
	ox_inventory:useItem(data, function(data)
		if data then
			TriggerEvent('kk-scripts:client:useScuba')
		end
	end)
end) 

Item('camo_vest_2', function(data, slot)
	ox_inventory:useItem(data, function(data)
		if data then
			TriggerEvent('armor:client:putOn', 60, 'camo_vest_2');
		end
	end)
end) 

Item('armor', function(data, slot)
	ox_inventory:useItem(data, function(data)
		if data then
			TriggerEvent('armor:client:putOn', 100, 'armor'); 
		end
	end)
end)

Item('wipes', function(data, slot)
	ox_inventory:useItem(data, function(data)
		if data then
			TriggerEvent('kk-police:client:cleanHands'); 
			TriggerServerEvent('KKF.Player.RemoveItem', 'wipes', 1)
		end
	end)
end) 

Item('scratch_ticket', function(data, slot)
	ox_inventory:useItem(data, function(data)
		if data then
			if not cache.vehicle then
				TriggerEvent('dr-scratching:isActiveCooldown'); 
			end
		end
	end)
end)

local snusUnder = false

Item('snus', function(data, slot)
	ox_inventory:useItem(data, function(data)
		if data then
			if not snusUnder then
				local progress = exports['kk-taskbar']:startAction('snus', 'Paned padja alla', 2000, 'pill_fp', 'mp_suicide', {freeze = false, controls = false})

				if progress then
					snusUnder = true

					CreateThread(function()
						while snusUnder do
							TriggerEvent('kk-needs:client:removeNeed', 'stress', math.random(1000, 2000))
							Wait(30000)
						end
					end)

					TriggerServerEvent('KKF.Player.RemoveItem', 'snus', 1)

					SetTimeout(60000 * 5, function()
						snusUnder = false
						exports['kk-taskbar']:startAction('snus_remove', 'Võtad padja alt', 2000, 'nose_pick', 'anim@mp_player_intcelebrationfemale@nose_pick', {freeze = false, controls = false, disableCancel = true})
					end)
				end
			else
				TriggerEvent('KKF.UI.ShowNotification', 'error', 'Sul on juba üks all!')
			end
		end
	end)
end)

Item('cigarett', function(data, slot)
	ox_inventory:useItem(data, function(data)
		if data then
			if not cache.vehicle then
				local entity = exports['kk-scripts']:spawnAttachedObject(cache.ped, joaat('prop_cs_ciggy_01'), 28422, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
				local progress = exports['kk-taskbar']:startAction('cigarett', 'Tõmbad suitsu', 35000, 'idle_c', 'amb@world_human_aa_smoke@male@idle_a', {freeze = false, controls = false})

				if progress then
					TriggerEvent('kk-needs:client:removeNeed', 'stress', math.random(1000, 2000))
					TriggerServerEvent('KKF.Player.RemoveItem', 'cigarett', 1)
				end

				DeleteObject(entity)
			end
		end
	end)
end)

Item('cigarello', function(data, slot)
	ox_inventory:useItem(data, function(data)
		if data then
			if not cache.vehicle then
				local entity = exports['kk-scripts']:spawnAttachedObject(cache.ped, joaat('prop_cigar_02'), 28422, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
				local progress = exports['kk-taskbar']:startAction('cigarello', 'Tõmbad suitsu', 35000, 'idle_c', 'amb@world_human_aa_smoke@male@idle_a', {freeze = false, controls = false})

				if progress then
					TriggerEvent('kk-needs:client:removeNeed', 'stress', math.random(2000, 4000))
					TriggerServerEvent('KKF.Player.RemoveItem', 'cigarello', 1)
				end

				DeleteObject(entity)
			end
		end
	end)
end) 


Item('weed_joint', function(data, slot)
	ox_inventory:useItem(data, function(data)
		if data then
			if not cache.vehicle then
				TriggerEvent('kk-needs:client:setNeed', 'stress', 0)
				TriggerEvent('kk-drugs:client:animation', 'weed_joint')
				TriggerServerEvent('KKF.Player.RemoveItem', 'weed_joint', 1)
			end
		end
	end)
end)

Item('coke', function(data, slot)
	ox_inventory:useItem(data, function(data)
		if data then
			TriggerEvent('kk-needs:client:setNeed', 'stress', 0)
			TriggerEvent('kk-drugs:client:animation', 'coke')
			TriggerServerEvent('KKF.Player.RemoveItem', 'coke', 1)
		end
	end)
end)

Item('moonshine', function(data, slot)
	ox_inventory:useItem(data, function(data)
		if data then
			TriggerEvent('kk-needs:client:setNeed', 'stress', 0)
			TriggerEvent('kk-drugs:client:animation', 'moonshine')
			TriggerServerEvent('KKF.Player.RemoveItem', 'moonshine', 1)
		end
	end)
end)

Item('alcoquant', function(data, slot)
	ox_inventory:useItem(data, function(data)
		if data then
			TriggerEvent('kk-police:client:alcoScan')
		end
	end)
end)


Item('roller', function(data, slot)
	ox_inventory:useItem(data, function(data)
		if data then
			TriggerEvent('kk-druglabs:client:rollerAction')
		end
	end)
end)

Item('drugscales', function(data, slot)
	ox_inventory:useItem(data, function(data)
		if data then
			TriggerEvent('kk-druglabs:client:scaleAction')
		end
	end)
end)  

Item('stretcher', function(data, slot)
	ox_inventory:useItem(data, function(data)
		if data then
			TriggerEvent('kk-ambulance:client:stretcher')
		end
	end)
end)


Item('bandage', function(data, slot)
	ox_inventory:useItem(data, function(data)
		if data then
			TriggerEvent('kk-ambulance:client:useBandage')
		end
	end)
end)

Item('fishingrod', function(data, slot)
	ox_inventory:useItem(data, function(data)
		if data then
			TriggerEvent('kk-fishing:client:startFishing')
		end
	end)
end)


Item('pot', function(data, slot)
	ox_inventory:useItem(data, function(data)
		if data then
			TriggerEvent('kk-drugs:client:tryPlantPot')
		end
	end)
end) 

Item('hairdryer', function(data, slot)
	ox_inventory:useItem(data, function(data)
		if data then
			TriggerEvent('kk-drugs:client:hairDrier')
		end
	end)
end)


-----------------------------------------------------------------------------------------------

exports('Items', function(item) return getItem(nil, item) end)
exports('ItemList', function(item) return getItem(nil, item) end)

return Items
