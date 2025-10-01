local firstTime = false

CreateThread(function()
    if LocalPlayer.state.isCuffed ~= 'none' then
        firstTime = true 
    end
end)

AddStateBagChangeHandler('isCuffed', nil, function(bagName, key, value) 
    local player = GetPlayerFromStateBagName(bagName)

    if player == cache.playerId then
		local model = GetEntityModel(cache.ped)

		if cfg.cuffAccessory[model] then
			if value ~= 'none' then
                if not firstTime then
                    TriggerServerEvent('kk-police:server:saveAccessory', model, GetPedDrawableVariation(cache.ped, 7), GetPedTextureVariation(cache.ped, 7))

                    firstTime = true
                end

				SetPedComponentVariation(cache.ped, 7, cfg.cuffAccessory[model], 0, 2)
			else
                lib.callback('kk-police:restoreAccessory', false, function(skinData)
                    if skinData and (skinData[1] and skinData[2]) then
                        SetPedComponentVariation(cache.ped, 7, skinData[1], 0, 2)
                        SetPedComponentVariation(cache.ped, 7, skinData[1], skinData[2], 0)
                    else
                        SetPedComponentVariation(cache.ped, 7, 0, 0, 2)
                    end

                    firstTime = false
                end)
			end
		end
	end
end)