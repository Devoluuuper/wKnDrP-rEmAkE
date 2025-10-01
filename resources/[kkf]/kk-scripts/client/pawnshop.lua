function OpenPawnShop()
	if LocalPlayer.state.isCuffed then return end
	
	local elements = {}

	lib.callback('kk-inventory:get', 500, function(response)
		for k,v in pairs(response) do 
			local item = Config.PawnShopPrices[v.name]
	
			if item and tonumber(v.count) > 0 then
				elements[#elements + 1] = {
					title = item.label,
					description = 'Hind: $' .. ESX.Math.GroupDigits(tonumber(v.count) * item.price) .. ' | Teil on: ' .. v.count,
					serverEvent = 'pawnItem',
					args = {name = v.name,count = tonumber(v.count)}
				}
			end
		end

		if #elements > 0 then
			lib.registerContext({
				id = 'pawn_shop',
				title = 'Pandimaja',
				options = elements
			})
		
			lib.showContext('pawn_shop')
		else
			TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil ei ole ühtegi eset, mida pandimaja otsiks.')
		end
	end)
end

-- Create blip
Citizen.CreateThread(function()
	for k,v in pairs(Config.PawnShopLocations) do
		local blip = AddBlipForCoord(v.x, v.y, v.z)

		SetBlipSprite(blip, 374)
		SetBlipScale(blip, 0.5)
		SetBlipColour(blip, 1)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Pandimaja')
		EndTextCommandSetBlipName(blip)
	end
end)

Citizen.CreateThread(function()
    local alreadyEnteredZone = false
    local text = 'Ava pandimaja'

    while true do
		wait = 5

		local ped = PlayerPedId()
		local inZone = false

		for k,v in pairs(Config.PawnShopLocations) do
			local dist = #(GetEntityCoords(ped) - v)

			if dist <= 2.0 then
				wait = 5
				inZone  = true

				if IsControlJustReleased(0, 38) then
					OpenPawnShop()
				end

				break
			else
				wait = 2000
			end
		end

		if inZone and not alreadyEnteredZone then
			alreadyEnteredZone = true
			ESX.ShowInteraction(text, 'E')
		end

		if not inZone and alreadyEnteredZone then
			alreadyEnteredZone = false
			ESX.HideInteraction()
		end

		Citizen.Wait(wait)
    end
end)