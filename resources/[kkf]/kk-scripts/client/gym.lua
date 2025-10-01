local lastLocation = nil; local isBusy = false
local currentExercise = nil
local blips = {{pos = vec3(-1201.22, -1568.86, 4.62)}}
local places = {
	{pos = vec3(-1199.03, -1574.45, 4.61), type = 'arms'},
    {pos = vec3(-1196.98, -1572.83, 4.61), type = 'arms'},

	{pos = vec3(-1204.7, -1561.1, 4.61), type = 'pushup'},

    {pos = vec3(-1202.44, -1570.6, 4.61), type = 'yoga'},

    {pos = vec3(-1200.04, -1563.72, 4.62), type = 'situps'},

    {pos = vec3(-1204.62, -1564.69, 4.61), type = 'chins'},
	--vangla
	{pos = vec3(1744.7652587891,2477.9965820313,45.759208679199), type = 'yoga'},
	{pos = vec3(1746.5635986328,2481.5717773438,45.740669250488), type = 'chins'},
	{pos = vec3(1743.8979492188,2483.0788574219,45.740669250488), type = 'arms'}
}

exports('currentExercise', function()
    return currentExercise
end)

CreateThread(function()
	for k, v in pairs(blips) do
		v.blip = AddBlipForCoord(v.pos)
		SetBlipSprite(v.blip, 311)
		SetBlipDisplay(v.blip, 4)
		SetBlipScale(v.blip, 0.7)
		SetBlipAsShortRange(v.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Jõusaal')
		EndTextCommandSetBlipName(v.blip)
	end
end)

local function doExecise(type)
    if isBusy then return end

    local playerPed = PlayerPedId()

	if not IsPedInAnyVehicle(playerPed, false) then 
    	local anim, dict = '', false

        if lastLocation ~= type then
            isBusy = true

            if type == 'arms' then
                anim = 'world_human_muscle_free_weights'; dict = false
            elseif type == 'pushup' then 
                if GetEntityModel(playerPed) == -1667301416 then
                    dict = 'timetable@reunited@ig_2'	
                    anim = 'jimmy_getknocked'
                else
                    anim = 'world_human_push_ups'; dict = false					
                end
            elseif type == 'yoga' then 
                anim = 'world_human_yoga'; dict = false
            elseif type == 'situps' then 
                if GetEntityModel(playerPed) == -1667301416 then
                    dict = 'mini@triathlon'; anim = 'idle_d'
                else
                    anim = 'world_human_sit_ups'; dict = false							
                end							
            elseif type == 'chins' then 
                anim = 'prop_human_muscle_chin_ups'; dict = false
            end

            -- TaskBar DOCS
            local progress = exports['kk-taskbar']:startAction('exercise', 'Teed harjutust', 30000, anim, dict, {freeze = true, controls = true})

            if progress then
                TriggerEvent('KKF.UI.ShowNotification', 'info', 'Said harjutuse Tehtud. Proovige nüüd mõnda teist harjutust.')
                TriggerEvent('kk-needs:client:removeNeed', 'stress', math.random(5000, 7500))

                lastLocation = type; isBusy = false
            else
                isBusy = false
            end
        else
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Proovige vahepeal mõnda teist harjutust.')
        end
    end
end

RegisterNetEvent('kk-gym:client:interact', function()
    doExecise(currentExercise)
end)

for k,v in pairs(places) do
	local point = lib.points.new(v.pos, 2.0, {type = v.type})
	
	function point:onEnter()
		currentExercise = self.type
	end
	
	function point:onExit()
		currentExercise = nil
	end

    function point:nearby()
        DrawMarker(2, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.3, 0.3, 0.3, 2, 132, 199, 50, false, true, 2, nil, nil, false)
    end
end