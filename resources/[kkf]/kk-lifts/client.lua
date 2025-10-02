local currentLift = nil

exports('inLift', function()
	return currentLift
end)

for k,v in pairs(ZONES) do
	local point = lib.points.new(v.coords.xyz, v.interactDistance, {id = k})
	
	function point:onEnter()
		currentLift = self.id; KKF.ShowInteraction('Lift')
	end
	
	function point:onExit()
		currentLift = nil; KKF.HideInteraction()
	end
end

RegisterNetEvent('kk-lifts:client:teleport', function(args)
	local coords = args.position
	local time = 10000

	if GetEntityModel(cache.ped) == joaat('pw_andreas') or GetEntityModel(cache.ped) == joaat('pw_roscoe') then 
		time = 20000 
	end

	local progress = exports['kk-taskbar']:startAction('putOnTrailer', 'Ootad lifti', time, 'keeper_base', 'misshair_shop@hair_dressers', {freeze = true, controls = true})

	if progress then
		DoScreenFadeOut(650)
		while not IsScreenFadedOut() do Wait(0) end
	
		FreezeEntityPosition(cache.ped, true)
	
		Wait(500)
		SetPedCoordsKeepVehicle(cache.ped, coords.x + 0.0, coords.y + 0.0, coords.z + 0.0)
		if coords.w then SetEntityHeading(cache.ped, coords.w + 0.0) end
	
		Wait(1500)
		DoScreenFadeIn(650)
		while not IsScreenFadedIn() do Wait(0) end
	
		FreezeEntityPosition(cache.ped, false)
	end
end)

RegisterNetEvent('kk-lifts:client:interact', function()
	local elements = {}

	for k, v in pairs(ZONES[currentLift].directions) do
		elements[#elements + 1] = {
			icon = 'fa-solid fa-hand-point-right',
			title = ZONES[v].label,
			event = 'kk-lifts:client:teleport',
			args = {position = ZONES[v].coords}
		}
	end

	lib.registerContext({
		id = 'lift_menu',
		title = 'Lift',
		options = elements
	})

	lib.showContext('lift_menu')
end)