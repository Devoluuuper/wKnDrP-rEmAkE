local isDead = false
local currentClothes = {
    ['shoes'] = {data = nil, id = 6, default = 34},
    ['top'] = {data = nil, id = 11, default = 15},
    ['shirt'] = {data = nil, id = 8, default = 15},
    ['pants'] = {data = nil, id = 4, default = 21},
    ['bag'] = {data = nil, id = 5, default = 0}, 
    ['mask'] = {data = nil, id = 1, default = 0},
    ['vest'] = {data = nil, id = 9, default = 0},
    ['hat'] = {data = nil, id = 0, default = 121},
    ['glasses'] = {data = nil, id = 1, default = 0}
}
local disabledVehicles = {
	[`buzzard`] = true,
	[`annihilator`] = true,
	[`cargobob`] = true,
	[`dump`] = true,
    [`oppressor`] = true,
	[`bulldozer`] = true,
	[`crusader`] = true,
	[`barracks3`] = true,
	[`barracks2`] = true,
	[`barracks`] = true,
	[`rhino`] = true,
	[`besra`] = true,
	[`hydra`] = true,
	[`lazer`] = true,
	[`titan"`] = true,
    [`jet`] = true,
    [`khanjali`] = true,
    [`apc`] = true,
    [`scarab`] = true,
    [`oppressor2`] = true,
    [`strikeforce`] = true,
    [`volatol`] = true
}

RegisterNetEvent('armor:client:putOn', function(value, item)
	local progress = exports['kk-taskbar']:startAction('armor', 'Paned kuulivesti selga', 5000, 'michael_tux_fidget', 'missmic4', {freeze = false, controls = false})

    if progress then
        TriggerServerEvent('KKF.Player.RemoveItem', item, 1)
        SetPedArmour(cache.ped, value)
    end
end)


------ search commandi pole vaja

-- RegisterCommand('search', function()
--     local currentPos = GetEntityCoords(cache.ped)
--     local playerId, playerPed, playerCoords = lib.getClosestPlayer(currentPos, 3.0, false)
	
--     if cache.vehicle then
--         TriggerEvent('KKF.UI.ShowNotification', 'error', 'Autos olles ei saa kedagi läbi otsida!')		
--         return
--     end
        
--     if LocalPlayer.state.isCuffed then
--         TriggerEvent('KKF.UI.ShowNotification', 'error', 'Käedraudus ei saa kedagi läbi otsida!')		
--         return
--     end
	
--     lib.callback('kk-society:getOnlineMembers', false, function(qtty)
--         if qtty >= 1 then
-- 	        if DoesEntityExist(playerPed) then
-- 	            ExecuteCommand("me alustab läbi otsimisega")
-- 	            local progress = exports['kk-taskbar']:startAction('search', 'Otsid isikut läbi', 5000, anim, dict, {freeze = true, controls = true})
--                 if progress then
-- 		            TriggerEvent('ox_inventory:openInventory', 'player', GetPlayerServerId(playerId))
--                 end
-- 	        else
-- 		        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ühtegi isikut ei ole läheduses.')
-- 	        end
--         else
--             TriggerEvent('KKF.UI.ShowNotification', 'error', 'Linnas on liiga vähe politseinikke.')
-- 	    end
-- 	end, 'police')
-- end)

lib.onCache('vehicle', function(vehicle)
    TriggerEvent("kkf:ui:seatBelt", false)

	if disabledVehicles[GetEntityModel(vehicle)] ~= nil then
		TaskLeaveVehicle(cache.ped, vehicle, 0); KKF.Game.DeleteEntity(vehicle)
		TriggerEvent('KKF.UI.ShowNotification', "error", "Selle sõidukiga ei saa sõita!")
	end
end)

RegisterNetEvent("kk-ambulance:setDeathStatus")
AddEventHandler(
    "kk-ambulance:setDeathStatus",
    function(val)
        isDead = val
    end
)

TriggerEvent(
    "chat:addSuggestion",
    "/transfervehicle",
    "Anna oma auto kellegile.",
    {
        {name = "id" },
        {name = "plate" }
    }
)

TriggerEvent(
    "chat:addSuggestion",
    "/tel",
    "Jaga telefoninumbrit.",
    {}
)

local disconnectTexts = {}

CreateThread(
    function()
        if DoesEntityExist(PlayerPedId()) then
            for i = 0, 255, 1 do
                EnableDispatchService(i, false)
            end
        end

        KKF.PlayerData = KKF.GetPlayerData()
    end
)

CreateThread(function()
    SetRadarBigmapEnabled(false, false)
end)

RegisterNetEvent("KKF.Player.Loaded")
AddEventHandler(
    "KKF.Player.Loaded",
    function(xPlayer)
        KKF.PlayerData = xPlayer
		
		SetCanAttackFriendly(cache.ped, true, false)
        NetworkSetFriendlyFireOption(true)
    end
)

RegisterNetEvent('KKF.Clothing.Reload', function()
    if GetEntityModel(cache.ped) == `mp_f_freemode_01` then
        currentClothes['shoes'].default = 35
        currentClothes['top'].default = 15
        currentClothes['shirt'].default = 15
        currentClothes['pants'].default = 15
        currentClothes['bag'].default = 0
        currentClothes['mask'].default = 0
        currentClothes['vest'].default = 0
        currentClothes['hat'].default = -1
        currentClothes['glasses'].default = -1
    else
        currentClothes['shoes'].default = 34
        currentClothes['top'].default = 15
        currentClothes['shirt'].default = 15
        currentClothes['pants'].default = 21
        currentClothes['bag'].default = 0
        currentClothes['mask'].default = 0
        currentClothes['vest'].default = 0
        currentClothes['hat'].default = 121
        currentClothes['glasses'].default = 0
    end
end)

RegisterNetEvent('KKF.Player.Unloaded', function() 
	KKF.PlayerData = {}
end)

RegisterNetEvent("KKF.Player.JobUpdate")
AddEventHandler(
    "KKF.Player.JobUpdate",
    function(job)
        KKF.PlayerData.job = job
    end
)

RegisterNetEvent("KKF.Player.DutyChange")
AddEventHandler(
    "KKF.Player.DutyChange",
    function(value)
        KKF.PlayerData.job.onDuty = value
    end
)

function fixCurrent()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if DoesEntityExist(vehicle) then
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        SetVehicleUndriveable(vehicle, false)
    end
end

function fuelCurrent()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if DoesEntityExist(vehicle) then
        -- exports["cdn-fuel"]:SetFuel(vehicle, 100)
        Entity(vehicle).state.fuel = 100
    end
end

RegisterNetEvent('KKF.Player.ReloadLicenses', function(licenses)
	KKF.PlayerData.licenses = licenses
end)

RegisterNetEvent("kk:id:viewId")
AddEventHandler(
    "kk:id:viewId",
    function()
        TriggerServerEvent("kk-documents:server:viewId")
    end
)

RegisterNetEvent("kk:id:viewJobId")
AddEventHandler(
    "kk:id:viewJobId",
    function()
        TriggerServerEvent("kk-badge:server:viewBadge")
    end
)

RegisterNetEvent("kk:id:showId")
AddEventHandler(
    "kk:id:showId",
    function()
        TriggerServerEvent("kk-documents:server:showId")
    end
)

RegisterNetEvent("kk:id:showJobId")
AddEventHandler(
    "kk:id:showJobId",
    function()
        TriggerServerEvent("kk-badge:server:showBadge")
    end
)

RegisterNetEvent("KKF:misc:createDisconnectText")
AddEventHandler(
    "KKF:misc:createDisconnectText",
    function(playerid, playerCoords, disconnectText)
        table.insert(
            disconnectTexts,
            {
                coords = {x = playerCoords.x, y = playerCoords.y, z = playerCoords.z},
                text = disconnectText,
                id = playerid
            }
        )
        Citizen.Wait(60000)
        if disconnectTexts ~= nil then
            for i = 1, #disconnectTexts, 1 do
                if disconnectTexts[i].id == playerid then
                    table.remove(disconnectTexts, i)
                    break
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            wait = 0
            SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0) -- disable regen

            if disconnectTexts ~= nil then
                for i = 1, #disconnectTexts, 1 do
                    local playerPed = PlayerPedId()
                    local coords = GetEntityCoords(playerPed)

                    if
                        GetDistanceBetweenCoords(
                            coords,
                            disconnectTexts[i].coords.x,
                            disconnectTexts[i].coords.y,
                            disconnectTexts[i].coords.z,
                            true
                        ) < 10.0
                     then
                        KKF.Functions.DrawText3D(
                            vector3(
                                disconnectTexts[i].coords.x,
                                disconnectTexts[i].coords.y,
                                disconnectTexts[i].coords.z
                            ),
                            disconnectTexts[i].text,
                            1.5
                        )
                    end
                end
            else
                wait = 2000
            end

            Wait(wait)
        end
    end
)
-- prollyfpskiller idknow -- EDIT: OLI FPSKILLER
Citizen.CreateThread(function()
	while true do 
	    Wait(5000)
        
		local playerLocalisation = GetEntityCoords(cache.ped)
		ClearAreaOfCops(playerLocalisation.x, playerLocalisation.y, playerLocalisation.z, 50.0)
	end
end)

local Ran = false

AddEventHandler(
    "playerSpawned",
    function()
        if not Ran then
            ShutdownLoadingScreenNui()
            Ran = true
        end
    end
)

CreateThread(function()
    while true do 
        if KKF then
            local ped = PlayerPedId()

            if not IsPedInAnyVehicle(ped, false) and GetEntitySpeed(ped) > 2.5 then
                if IsControlJustPressed(1, 19) then
                    Tackle()
                end
            else
                Wait(250)
            end
        end

        Wait(1)
    end
end)

RegisterNetEvent('tackle:client:GetTackled', function()
	SetPedToRagdoll(PlayerPedId(), math.random(1000, 6000), math.random(1000, 6000), 0, 0, 0, 0) 
	TimerEnabled = true
	Wait(1500)
	TimerEnabled = false
end)

function Tackle()
    local currentPos = GetEntityCoords(cache.ped)
    local playerId, playerPed, playerCoords = lib.getClosestPlayer(currentPos, 2.0, false)
    
    if DoesEntityExist(playerPed) then
        TriggerServerEvent("tackle:server:TacklePlayer", GetPlayerServerId(playerId))
        TackleAnim()
    end
end

function TackleAnim()
    local ped = PlayerPedId()

    if not LocalPlayer.state.isCuffed and not IsPedRagdoll(ped) then
        lib.requestAnimDict("swimming@first_person@diving")
        if IsEntityPlayingAnim(ped, "swimming@first_person@diving", "dive_run_fwd_-45_loop", 3) then
            ClearPedTasksImmediately(ped)
        else
            TaskPlayAnim(ped, "swimming@first_person@diving", "dive_run_fwd_-45_loop" ,3.0, 3.0, -1, 49, 0, false, false, false)
            Wait(250)
            ClearPedTasksImmediately(ped)
            SetPedToRagdoll(ped, 150, 150, 0, 0, 0, 0)
        end
    end
end

local function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

for k,v in pairs(currentClothes) do
    RegisterNetEvent('KKF.Clothes.' .. firstToUpper(k), function()
        if k == 'hat' or k == 'glasses' then
            if not currentClothes[k].data then
			    local progress = exports['kk-taskbar']:startAction('cloth', 'Tegeled riietega', 3000, 'michael_tux_fidget', 'missmic4', {freeze = false, controls = false})
                
                if progress then
                    currentClothes[k].data = {item = GetPedPropIndex(cache.ped, currentClothes[k].id), txt = GetPedPropTextureIndex(cache.ped, currentClothes[k].id)}
            
                    SetPedPropIndex(cache.ped, currentClothes[k].id, currentClothes[k].default, 0, 1)
                end
            else
			    local progress = exports['kk-taskbar']:startAction('cloth', 'Tegeled riietega', 3000, 'michael_tux_fidget', 'missmic4', {freeze = false, controls = false})

                if progress then
                    SetPedPropIndex(cache.ped, currentClothes[k].id, currentClothes[k].data.item, currentClothes[k].data.txt, 1)
            
                    currentClothes[k].data = nil
                end
            end
        elseif k == 'mask' and GetEntityModel(cache.ped) ~= `mp_f_freemode_01` and GetEntityModel(cache.ped) ~= `mp_m_freemode_01` then
            if not currentClothes[k].data then
                local progress = exports['kk-taskbar']:startAction('cloth', 'Tegeled riietega', 3000, 'michael_tux_fidget', 'missmic4', {freeze = false, controls = false})

                if progress then
                    currentClothes[k].data = {}

                    lib.callback('KKF.Entity.SpawnObject', false, function(networkId)
                        if networkId then
                            while not NetworkDoesEntityExistWithNetworkId(networkId) do
                                Wait(10)
                            end

                            currentClothes[k].data.item = NetworkGetEntityFromNetworkId(networkId)

                            SetEntityCollision(currentClothes[k].data.item, false, false)
                            AttachEntityToEntity(currentClothes[k].data.item, cache.ped, GetPedBoneIndex(cache.ped, 31086), vector3(0.0, 0.0, -0.015), vector3(0.0, 280.0, 180.0), false, true, false, false, 0, true)
                        end
                    end, 'prop_player_gasmask', GetEntityCoords(cache.ped), GetEntityHeading(playerPed))
                end
            else
			    local progress = exports['kk-taskbar']:startAction('cloth', 'Tegeled riietega', 3000, 'michael_tux_fidget', 'missmic4', {freeze = false, controls = false})

                if progress then
                    DetachEntity(currentClothes[k].data.item, cache.ped); KKF.Game.DeleteEntity(currentClothes[k].data.item)
                    currentClothes[k].data = nil
                end
            end
        else
            if not currentClothes[k].data then
			    local progress = exports['kk-taskbar']:startAction('cloth', 'Tegeled riietega', 3000, 'michael_tux_fidget', 'missmic4', {freeze = false, controls = false})

                if progress then 
                    currentClothes[k].data = {item = GetPedDrawableVariation(cache.ped, currentClothes[k].id), txt = GetPedTextureVariation(cache.ped, currentClothes[k].id)}
            
                    SetPedComponentVariation(cache.ped, currentClothes[k].id, currentClothes[k].default, 0, 1)

                    if k == 'top' then
                        currentClothes[k].data.hands = GetPedTextureVariation(cache.ped, 3)
                        SetPedComponentVariation(cache.ped, 3, 15, 0, 1)
                    end
                end
            else
			    local progress = exports['kk-taskbar']:startAction('cloth', 'Tegeled riietega', 3000, 'michael_tux_fidget', 'missmic4', {freeze = false, controls = false})

                if progress then 
                    SetPedComponentVariation(cache.ped, currentClothes[k].id, currentClothes[k].data.item, currentClothes[k].data.txt, 1)

                    if k == 'top' then
                        SetPedComponentVariation(cache.ped, 3, currentClothes[k].data.hands + 1, 0, 1)
                    end
            
                    currentClothes[k].data = nil
                end
            end
        end
    end)
end

--dog

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		SetCanAttackFriendly(GetPlayerPed(-1), true, false)
		NetworkSetFriendlyFireOption(true)
		if GetEntityModel(PlayerPedId()) ~= GetHashKey("a_c_shepherd") then
			SetPedSuffersCriticalHits(GetPlayerPed(-1), false)
		end
	end
end)

RegisterNetEvent("KKF.Player.Loaded")
AddEventHandler("KKF.Player.Loaded",function(xPlayer)
	Citizen.CreateThread( function()
		Citizen.Wait(2500)
		if GetEntityModel(PlayerPedId()) == GetHashKey("a_c_shepherd") then
			while true do
				Citizen.Wait(1000)
				RestorePlayerStamina(PlayerId(), 1.0)
			end
		end
	end)
end)

-- RegisterNetEvent('kk-scripts:client:flipVehicle', function()
--     if not cache.vehicle then
--         local pos = GetEntityCoords(cache.ped)
--         local veh = KKF.Game.GetClosestVehicle(pos)
--         local dist = #(GetEntityCoords(veh) - pos)

--         if DoesEntityExist(veh) and dist < 3.0 then
--             local roll = GetEntityRoll(veh)

--             if (roll > 75.0 or roll < -75.0) then
--                 local progress = exports['kk-taskbar']:startAction('flipVehicle', 'Keerad sõidukit ümber', 18000, 'pushcar_offcliff_m', 'missfinale_c2ig_11', {freeze = true, controls = true})

--                 if progress then
--                     local vehPos = GetEntityRotation(veh, 2)

--                     SetEntityRotation(veh, vehPos[1], 0, vehPos[3], 2, true)
--                     SetVehicleOnGroundProperly(veh)
--                 end
--             else
--                 TriggerEvent('KKF.UI.ShowNotification', 'error', 'Sõiduk ei ole pahupidi!')
--             end
--         else
--             TriggerEvent('KKF.UI.ShowNotification', 'error', 'Läheduses ei ole ühtegi sõidukit.')
--         end
--     else
--         TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ei saa sõidukit flippida autost seest.')
--     end 
-- end)

exports.ox_target:addGlobalVehicle({
    {
		name = 'flipVehicle',
		distance = 2.0,
		icon = 'fa-solid fa-rotate',
		label = 'Flipi sõiduk',
		canInteract = function(entity)
            local roll = GetEntityRoll(entity)

			return not cache.vehicle and (roll > 75.0 or roll < -75.0)
		end,
		onSelect = function(data)
            local progress = exports['kk-taskbar']:startAction('flipVehicle', 'Keerad sõidukit ümber', 18000, 'pushcar_offcliff_m', 'missfinale_c2ig_11', {freeze = true, controls = true})

            if progress then
                local vehPos = GetEntityRotation(data.entity, 2)

                SetEntityRotation(data.entity, vehPos[1], 0, vehPos[3], 2, true)
                SetVehicleOnGroundProperly(data.entity)
            end
		end
	}
})

RegisterNetEvent('KKF.Player.SetHealth', function(value)
    SetEntityHealth(cache.ped, value);
end)


local trafficSignModels = {
    `prop_snow_streetlight01`,
	`prop_snow_streetlight_01_frag_`,
	`prop_snow_streetlight_09`,
	`prop_streetlight_01`,
	`prop_streetlight_01b`,
	`prop_streetlight_02`,
	`prop_streetlight_03`,
	`prop_streetlight_03b`,
	`prop_streetlight_03c`,
	`prop_streetlight_03d`,
	`prop_streetlight_03e`,
	`prop_streetlight_04`,
	`prop_streetlight_05`,
	`prop_streetlight_05_b`,
	`prop_streetlight_06`,
	`prop_streetlight_07a`,
	`prop_streetlight_07b`,
	`prop_streetlight_08`,
	`prop_streetlight_09`,
	`prop_streetlight_10`,
	`prop_streetlight_11a`,
	`prop_streetlight_11b`,
	`prop_streetlight_11c`,
	`prop_streetlight_12a`,
	`prop_streetlight_12b`,
	`prop_streetlight_14a`,
	`prop_streetlight_15a`,
	`prop_streetlight_16a`,
    `prop_traffic_03b`,
    `prop_traffic_rail_1a`,
    `prop_traffic_01a`,
    `prop_traffic_01d`,
    `prop_traffic_rail_3`,
    `prop_traffic_rail_1c`,
    `prop_traffic_02a`,
    `prop_traffic_03a`,
    `prop_traffic_02b`,
    `prop_traffic_rail_2`,
    `prop_traffic_01b`,
    `prop_consign_01b`,
    `prop_consign_02a`,
    `prop_consign_01a`,
    `prop_consign_01c`,
    
    joaat('prop_snow_sign_road_06g'),
    joaat('prop_snow_sign_road_01a'),
    joaat('prop_snow_sign_road_06e'),
    joaat('prop_sign_road_03u'),
    joaat('prop_sign_road_04v'),
    joaat('prop_sign_road_05m'),
    joaat('prop_sign_road_06r'),
    joaat('prop_sign_road_05h'),
    joaat('prop_sign_road_04b'),
    joaat('prop_sign_road_04c'),
    joaat('prop_sign_road_06d'),
    joaat('prop_sign_road_03g'),
    joaat('prop_sign_road_03t'),
    joaat('prop_sign_road_06o'),
    joaat('prop_sign_road_05l'),
    joaat('prop_sign_road_06s'),
    joaat('prop_sign_road_09b'),
    joaat('prop_sign_road_02a'),
    joaat('prop_sign_road_03s'),
    joaat('prop_sign_road_05r'),
    joaat('prop_sign_road_03r'),
    joaat('prop_sign_road_06b'),
    joaat('prop_sign_road_06m'),
    joaat('prop_sign_road_06c'),
    joaat('prop_sign_road_06l'),
    joaat('prop_sign_road_01b'),
    joaat('prop_sign_road_04i'),
    joaat('prop_sign_road_04l'),
    joaat('prop_sign_road_04s'),
    joaat('prop_sign_road_03q'),
    joaat('prop_sign_road_05u'),
    joaat('prop_sign_road_04w'),
    joaat('prop_sign_road_04z'),
    joaat('prop_sign_road_04za'),
    joaat('prop_sign_road_03a'),
    joaat('prop_sign_road_06n'),
    joaat('prop_sign_road_03m'),
    joaat('prop_sign_road_06k'),
    joaat('prop_sign_road_06q'),
    joaat('prop_sign_road_04d'),
    joaat('prop_sign_road_04f'),
    joaat('prop_sign_road_05c'),
    joaat('prop_sign_road_05za'),
    joaat('prop_sign_road_05a'),
    joaat('prop_sign_road_04n'),
    joaat('prop_sign_road_03o'),
    joaat('prop_sign_road_03d'),
    joaat('prop_sign_road_04a'),
    joaat('prop_sign_road_08a'),
    joaat('prop_sign_road_05f'),
    joaat('prop_sign_road_06a'),
    joaat('prop_sign_road_04o'),
    joaat('prop_sign_road_restriction_10'),
    joaat('prop_sign_road_06g'),
    joaat('prop_sign_road_01c'),
    joaat('prop_sign_road_04y'),
    joaat('prop_sign_road_05i'),
    joaat('prop_sign_road_05q'),
    joaat('prop_sign_road_04g_l1'),
    joaat('prop_sign_road_04g'),
    joaat('prop_sign_road_03v'),
    joaat('prop_sign_road_04k'),
    joaat('prop_sign_road_05s'),
    joaat('prop_sign_road_03c'),
    joaat('prop_sign_road_04z'),
    joaat('prop_sign_road_05j'),
    joaat('prop_sign_road_06j'),
    joaat('prop_sign_road_04t'),
    joaat('prop_sign_road_03b'),
    joaat('prop_sign_road_05g'),
    joaat('prop_sign_road_05w'),
    joaat('prop_sign_road_09a'),
    joaat('prop_sign_road_05b'),
    joaat('prop_sign_road_03x'),
    joaat('prop_sign_road_03n'),
    joaat('prop_sign_road_01a'),
    joaat('prop_sign_road_04m'),
    joaat('prop_sign_road_03j'),
    joaat('prop_sign_road_03f'),
    joaat('prop_sign_road_03z'),
    joaat('prop_sign_road_06p'),
    joaat('prop_sign_road_03l'),
    joaat('prop_sign_road_06e'),
    joaat('prop_sign_road_05d'),
    joaat('prop_sign_road_04q'),
    joaat('prop_sign_road_09e'),
    joaat('prop_sign_road_05o'),
    joaat('prop_sign_road_04r'),
    joaat('prop_sign_road_08b'),
    joaat('prop_sign_road_06f'),
    joaat('prop_sign_road_03h'),
    joaat('prop_sign_road_04j'),
    joaat('prop_sign_road_04p'),
    joaat('prop_sign_road_05k'),
    joaat('prop_sign_road_03i'),
    joaat('prop_sign_road_05v'),
    joaat('prop_sign_road_07b'),
    joaat('prop_sign_road_03p'),
    joaat('prop_sign_road_callbox'),
    joaat('prop_sign_road_04h'),
    joaat('prop_sign_road_05y'),
    joaat('prop_sign_road_06i'),
    joaat('prop_sign_road_07a'),
    joaat('prop_sign_road_03k'),
    joaat('prop_sign_road_06h'),
    joaat('prop_sign_road_09d'),
    joaat('prop_sign_road_05e'),
    joaat('prop_sign_road_09c'),
    joaat('prop_sign_road_09f'),
    joaat('prop_sign_road_04x'),
    joaat('prop_sign_road_03w'),
    joaat('prop_sign_road_05x'),
    joaat('prop_sign_road_03y'),
    joaat('prop_sign_road_05t'),
    joaat('prop_sign_road_05p'),
    joaat('prop_sign_road_04u'),
    joaat('prop_sign_road_04e'),
    joaat('prop_sign_road_05n'),
    joaat('prop_sign_road_05z'),
    joaat('prop_sign_road_03e'),

    joaat('prop_dumpster_01a'),
    joaat('prop_dumpster_02a'),
    joaat('prop_dumpster_01b'),
    joaat('prop_dumpster_3a'),
    joaat('prop_dumpster_4a'),
    joaat('prop_dumpster_4b'),
    joaat('prop_bin_14b'),
    joaat('prop_bin_08a'),
    joaat('prop_bin_05a'),
    joaat('prop_bin_07c'),
    joaat('prop_recyclebin_02_c'),
    joaat('prop_recyclebin_02b'),
    joaat('prop_recyclebin_02_d'),
    joaat('prop_recyclebin_02a'),
    joaat('prop_bin_02a'),
    joaat('prop_bin_03a'),
    joaat('prop_bin_06a'),
    joaat('prop_bin_08open'),
    joaat('prop_bin_12a'),
    joaat('prop_cs_bin_01'),
    joaat('prop_cs_bin_01_skinned'),
    joaat('prop_cs_bin_02'),

    joaat('prop_cs_bin_03'),
    joaat('prop_snow_bin_02'),
    joaat('prop_snow_bin_01'),
    joaat('zprop_bin_01a_old'),
    joaat('p_dumpster_t'),
    joaat('prop_cs_dumpster_01a'),
    joaat('prop_dumpster_02b'),
    joaat('prop_news_disp_06a'),
    joaat('prop_news_disp_05a'),
    joaat('prop_news_disp_03c'),
    joaat('prop_news_disp_03a'),
    joaat('prop_news_disp_02e'),
    joaat('prop_news_disp_02d'),
    joaat('prop_news_disp_02c'),
    joaat('prop_news_disp_02b'),
    joaat('prop_news_disp_02a_s'),
    joaat('prop_news_disp_02a'),
    joaat('prop_news_disp_01a'),
    joaat('prop_postbox_01a'),

    joaat('prop_elecbox_01a'),
    joaat('port_xr_elecbox_1'),
    joaat('port_xr_elecbox_2'),
    joaat('port_xr_elecbox_3'),
    joaat('prop_byard_elecbox03'),
    joaat('prop_byard_elecbox04'),
    joaat('prop_elecbox_18'),
    joaat('prop_elecbox_19'),
    joaat('prop_elecbox_20'),
    joaat('prop_elecbox_21'),
    joaat('prop_elecbox_23'),
    joaat('prop_elecbox_25'),
    joaat('prop_elecbox_01b'),
    joaat('prop_elecbox_04a'),
    joaat('prop_elecbox_07a'),
    joaat('prop_elecbox_11'),
    joaat('prop_elecbox_13'),
    joaat('prop_elecbox_02a'),
    joaat('prop_elecbox_02b'),
    joaat('prop_elecbox_09'),
    joaat('prop_elecbox_05a'),
    joaat('prop_elecbox_06a')
}


local function deleteTrafficSign(sign)
    CreateThread(function()
        Wait(500)
        SetEntityAsMissionEntity(sign, true, true)
        DeleteObject(sign)
    end)
end

AddEventHandler("entityDamaged", function(entity, culprit, weapon, baseDamage)
    if IsEntityAnObject(entity) and HasEntityBeenDamagedByAnyVehicle(entity) then
        local model = GetEntityModel(entity)

        for _, v in ipairs(trafficSignModels) do
            if model == v then
                deleteTrafficSign(entity)
                break
            end
        end
    end
end)