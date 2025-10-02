local inBed = false
local animationPlaying = false

local bedOccupying = nil
local bedOccupyingData = nil
local currentHospital = nil

RegisterNetEvent('KKF.Player.Unloaded', function()
	if bedOccupying then
		TriggerServerEvent('kk-ambulance:server:leaveIntensive', currentHospital, bedOccupying)

		bedOccupying = nil
		bedOccupyingData = nil
		currentHospital = nil
	end
end)

RegisterNetEvent('kk-ambulance:client:startIntensive', function(bed)
    inBed = true; animationPlaying = true
    bedOccupying = bed[1]; bedOccupyingData = bed[2]; currentHospital = bed[3]

    local heading = bedOccupyingData.coords.w

    SetEntityCoords(cache.ped, bedOccupyingData.coords.x, bedOccupyingData.coords.y, bedOccupyingData.coords.z + 0.65)
    FreezeEntityPosition(cache.ped, true)
    lib.requestAnimDict('anim@gangops@morgue@table@')
    TaskPlayAnim(cache.ped, 'anim@gangops@morgue@table@', 'ko_front' ,8.0, -8.0, -1, 1, 0, false, false, false)

    if bedOccupyingData.model then
        local entity = GetClosestObjectOfType(bedOccupyingData.coords.x, bedOccupyingData.coords.y, bedOccupyingData.coords.z, 1.0, bedOccupyingData.model, false, false, false)

        if DoesEntityExist(entity) then
            heading = GetEntityHeading(entity)
        end
    end

    SetEntityHeading(cache.ped, heading)

    while inBed do
        wait = 0

		if not IsEntityPlayingAnim(cache.ped, 'anim@gangops@morgue@table@', 'ko_front', 3) and animationPlaying then
			lib.requestAnimDict('anim@gangops@morgue@table@')
			TaskPlayAnim(cache.ped, 'anim@gangops@morgue@table@', 'ko_front', 8.0, 8.0, -1, 33, 0, 0, 0, 0)
			wait = 5000
		elseif animationPlaying then
			ClearPedTasksImmediately(cache.ped)
			wait = 0
		end

        Wait(wait)
    end

    animationPlaying = false
    FreezeEntityPosition(cache.ped, false)
    ClearPedTasksImmediately(cache.ped)
end)

RegisterNetEvent('kk-ambulance:server:leaveIntensive', function()
    inBed = false;
end)