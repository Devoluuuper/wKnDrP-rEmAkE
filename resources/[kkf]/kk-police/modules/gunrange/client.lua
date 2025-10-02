local weaponEquipped = nil

local currentRange = nil
local cDif = nil
local mTargets = 0
local countDown = 300
local wTime = 0	
local sShoot = false 
local spwnT = false
local target = nil
local cTCoords = nil
local points, hits, count = 0, 0, 0 

AddEventHandler('ox_inventory:currentWeapon', function(currentWeapon)
    weaponEquipped = currentWeapon?.name
end)

RegisterNetEvent('kk-police:client:startRange', function(args)
    local input = lib.inputDialog('Mitu märklauda soovite?', {
        { type = "number", label = "Märklaudade arv (1 - 50)", default = 15 }
    })
    
    if input then
        if (input[1] >= 1) and (input[1] <= 50) then
            currentRange = args.range
            wTime = args.time
            cDif = args.difficulty
            mTargets = input[1]

            sShoot = true
            spwnT = true

            TriggerEvent('gunrange:start')
        end
    end
end)

CreateThread(function()
	while true do
        wait = 0

		if sShoot then
			if not spwnT then
				sShoot = false

				TriggerEvent('KKF.UI.ShowNotification', 'info', 'Lasketest lõpetatud!')
				print(cDif, points, count, hits, weaponEquipped)
			end

			if target then
				if HasEntityBeenDamagedByAnyPed(target) then
					if HasBulletImpactedInBox(cTCoords.x+0.06,cTCoords.y+0.12,cTCoords.z+0.46,  cTCoords.x-0.06,cTCoords.y,cTCoords.z+0.6,true,true) then
						points = points + 5
					elseif HasBulletImpactedInBox(cTCoords.x+0.11,cTCoords.y+0.12,cTCoords.z+0.41,  cTCoords.x-0.11,cTCoords.y,cTCoords.z+0.69,true,true) then
						points = points + 4
					elseif HasBulletImpactedInBox(cTCoords.x+0.16,cTCoords.y+0.12,cTCoords.z+0.33,  cTCoords.x-0.16,cTCoords.y,cTCoords.z+0.76,true,true) then
						points = points + 3
					elseif HasBulletImpactedInBox(cTCoords.x+0.21,cTCoords.y+0.12,cTCoords.z+0.25,  cTCoords.x-0.21,cTCoords.y,cTCoords.z+0.85,true,true) then
						points = points + 2
					else
						points = points + 1
					end

					hits = hits + 1
					DeleteObject(target)

					target = nil
					cTCoords = nil
				end
			end

            if countDown == 0 then
                if spwnT then
                    count = count + 1
                    cTCoords = cfg.gunRanges[currentRange].items[math.random(1, #cfg.gunRanges[currentRange].items)]

                    exports['kk-scripts']:requestModel(`prop_range_target_01`)
                    target = CreateObject(`prop_range_target_01`, cTCoords.x, cTCoords.y, cTCoords.z, false, false, true)

                    SetEntityHeading(target, 2.3)
                    Wait(wTime)
                    DeleteObject(target)

                    target = nil
                    cTCoords = nil

                    if count == mTargets then
                        spwnT = false
                    end
                end
            else
                countDown = countDown - 1
            end
        else
            wait = 500
		end

        Wait(wait)
	end
end)

for k,v in pairs(cfg.gunRanges) do
    exports.ox_target:addBoxZone({
        coords = v.target.coords,
        size = v.target.size,
        rotation = v.target.rotation,
        debug = false,
        options = {
            {
                icon = 'fa-solid fa-gun',
                label = 'Alusta lasketesti',
                distance = 1.5,
                canInteract = function()
                    return (KKF.PlayerData.job.name == 'police' and KKF.PlayerData.job.onDuty) and not sShoot
                end,
                onSelect = function()
                    if weaponEquipped then
                        currentRange = nil
                        count = 0
                        points = 0
                        hits = 0
                        countDown = 300
                        
                        local elements = {}

                        for _,v in pairs(cfg.rangeDifficulties) do
                            elements[#elements + 1] = {
                                title = v.label,
                                icon = v.icon,
                                event = 'kk-police:client:startRange',
                                args = {range = k, time = v.time, difficulty = v.label}
                            }
                        end
                
                        lib.registerContext({
                            id = 'gunrange_difficulty',
                            title = 'Vali raskusaste',
                            options = elements
                        })

                        lib.showContext('gunrange_difficulty')
                    else
                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil ei ole ühtegi relva käes!')
                    end
                end
            },
        }
    })
end