local animations = {}
local players = {}

local loop = false
local move = false
local place = false
local favorites = {}
local walkStyle = nil
local currentExpression = nil

local playing = false

local ptfxOwner = false
local ptfxActive = false
local ptfxEntities = {}
local ptfxEntitiesTwo = {}

function requestAnimDict(animDict, cb)
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)

        while not HasAnimDictLoaded(animDict) do
            Wait(0)
        end
    end

    if cb then
        cb()
    end
end

local function removeEntities(data)
    for i = 1, #data do
        local entity = data[i]

        if entity then
            DeleteEntity(entity)
        end
    end
end

local function removePlayer(serverId)
    local Player = players[serverId]

    if Player and table.type(Player) ~= 'empty' then
        removeEntities(Player)
        players[serverId] = nil
    end
end

RegisterNetEvent('onPlayerDropped', function(serverId)
    removePlayer(serverId)
end)

local function getEntityFromStateBag(bagName, keyName)
    if bagName:find('entity:') then
        local netId = tonumber(bagName:gsub('entity:', ''), 10)

        local entity =  lib.waitFor(function()
            if NetworkDoesEntityExistWithNetworkId(netId) then return NetworkGetEntityFromNetworkId(netId) end
        end, ('%s received invalid entity! (%s)'):format(keyName, bagName), 10000)

        return entity
    elseif bagName:find('player:') then
        local serverId = tonumber(bagName:gsub('player:', ''), 10)
        local playerId = GetPlayerFromServerId(serverId)

        local entity = lib.waitFor(function()
            local ped = GetPlayerPed(playerId)
            if ped > 0 then return ped end
        end, ('%s received invalid entity! (%s)'):format(keyName, bagName), 10000)

        return serverId, entity
    end
end

local function createObject(ped, prop, bone, placement)
    local coords = GetEntityCoords(ped)
    local newProp = CreateObject(joaat(prop), coords.x, coords.y, coords.z + 0.2, false, false, false)

    if newProp then
        AttachEntityToEntity(newProp, ped, GetPedBoneIndex(ped, bone), placement[1] + 0.0, placement[2] + 0.0, placement[3] + 0.0, placement[4] + 0.0, placement[5] + 0.0, placement[6] + 0.0, true, true, false, true, 1, true)
    end

    SetModelAsNoLongerNeeded(prop)

    return newProp
end

local function createProps(entity, props)
    if entity and props then
        local objects = {}

        if props.prop then
            lib.requestModel(props.prop)
            objects[#objects + 1] = createObject(entity, props.prop, props.propBone, props.propPlacement)
        end

        if props.propTwo then
            lib.requestModel(props.propTwo)
            objects[#objects + 1] = createObject(entity, props.propTwo, props.propTwoBone, props.propTwoPlacement)
        end
        
        return objects
    else
        return false
    end
end

AddStateBagChangeHandler('animationObjects', nil, function(bagName, keyName, value, _, replicated)
    if replicated then
        return
    end

    local serverId, pedHandle = getEntityFromStateBag(bagName, keyName)

    if serverId and not value then
        return removePlayer(serverId)
    end

    if pedHandle and pedHandle > 0 then
        local currentTable = players[serverId] or {}

        if #currentTable > 0 then
            removeEntities(currentTable)
            table.wipe(currentTable)
        end

        if value and table.type(value) ~= 'empty' then
            currentTable = createProps(pedHandle, value)
        end

        players[serverId] = currentTable
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if previewPed then
            DeletePed(previewPed) 
        end

        for _, v in pairs(players) do
            if v then
                removeEntities(v)
            end
        end

        LocalPlayer.state:set('animationObjects', false, true)
    end
end)

AddStateBagChangeHandler('instance', ('player:%s'):format(cache.serverId), function(_, _, value)
    if value == 0 then
        local currentObjects = players[cache.serverId] or {}

        if currentObjects then
            removeEntities(currentObjects)
            LocalPlayer.state:set('animationObjects', false, true)
        end
    end
end)

local function loadAnimations()
    local file = LoadResourceFile(cache.resource, 'animations.json')

    return file and json.decode(file) or {}
end

local function ptfxRemoval()
    if ptfxEntities then
        for _, v in pairs(ptfxEntities) do
            StopParticleFxLooped(v, false)
        end

        ptfxEntities = {}
    end
end

RegisterNetEvent('kk-emotes:client:removePtfx', function(syncPlayer)
    local targetParticles = ptfxEntitiesTwo[tonumber(syncPlayer)]

    if targetParticles then
        StopParticleFxLooped(targetParticles, false)
        ptfxEntitiesTwo[syncPlayer] = nil
    end
end)

local function globalCanInteract()
    if LocalPlayer.state.invBusy then
        return false
    end

    if exports['kk-taskbar']:canInteract() then
        return false
    end
    
    return true
end

exports('globalCanInteract', globalCanInteract)

local function cancelAnimation()
    if globalCanInteract() then
        if playing then
            ClearPedTasks(cache.ped)
            playing = false
        end

        local currentObjects = players[cache.serverId] or {}

        if currentObjects then
            removeEntities(currentObjects)
            LocalPlayer.state:set('animationObjects', false, true)
        end

        if ptfxActive then
            if ptfxOwner then
                TriggerServerEvent('kk-emotes:server:removePtfx')
                ptfxOwner = false
            end
            
            ptfxRemoval()
            ptfxActive = false
        end
    end
end

local cooldownTime <const> = cfg.cooldownTime 
local cooldown = nil

local function checkSex()
    local pedModel = GetEntityModel(cache.ped)

    for i = 1, #cfg.malePeds do
        if pedModel == GetHashKey(cfg.malePeds[i]) then
            return 'male'
        end
    end

    return 'female'
end

local function saveSettings(identifier)
    local emoteData = {
        loop = loop,
        move = move,
        place = place,
        favorites = favorites,
        walkStyle = walkStyle,
        currentExpression = currentExpression
    }

    TriggerEvent('KKF.UI.ShowNotification', 'success', 'Muudatused salvestatud!')
    SetResourceKvp('emote_settings_' .. identifier, json.encode(emoteData))
end

local function ptfxCreation(ped, prop, name, asset, placement, rgb)
    local ptfxSpawn = ped

    if prop then
        ptfxSpawn = prop
    end

    local newPtfx = StartNetworkedParticleFxLoopedOnEntityBone(name, ptfxSpawn, placement[1] + 0.0, placement[2] + 0.0, placement[3] + 0.0, placement[4] + 0.0, placement[5] + 0.0, placement[6] + 0.0, GetEntityBoneIndexByName(name, "VFX"), placement[7] + 0.0, 0, 0, 0, 1065353216, 1065353216, 1065353216, 0)

    if newPtfx then
        SetParticleFxLoopedColour(newPtfx, rgb[1] + 0.0, rgb[2] + 0.0, rgb[3] + 0.0)

        if ped == cache.ped then
            table.insert(ptfxEntities, newPtfx)
        else
            ptfxEntitiesTwo[GetPlayerServerId(NetworkGetEntityOwner(ped))] = newPtfx
        end

        ptfxActive = true
    end

    RemoveNamedPtfxAsset(asset)
end

local function playPtfx(ped, particles)
    if particles then
        lib.requestNamedPtfxAsset(particles.asset)
        UseParticleFxAssetNextCall(particles.asset)
        local attachedProp

        for _, v in pairs(GetGamePool('CObject')) do
            if IsEntityAttachedToEntity(ped, v) then
                attachedProp = v
                break
            end
        end

        if not attachedProp and not cfg.ptfxEntitiesTwo[NetworkGetEntityOwner(ped)] and not ptfxOwner and ped == cache.ped then
            attachedProp = cfg.propsEntities[1] or cfg.propsEntities[2]
        end

        ptfxCreation(ped, attachedProp or nil, particles.name, particles.asset, particles.placement, particles.rgb)
    end
end

RegisterNetEvent('kk-emotes:client:playPtfx', function(syncPlayer, particle)
    local mainPed = GetPlayerPed(GetPlayerFromServerId(syncPlayer))
    
    if mainPed > 0 and type(particle) == "table" then
        playPtfx(mainPed, particle)
    end
end)

local fakeProps = {}
local isInPreview = false
local keyBinds = {
	{
		code = 24,
		label = "Mängi animatsiooni",
	},
	{
		code = 25,
		label = "Katkesta",
	},
	{
		code = 241,
		label = "Vasakule",
	},
	{
		code = 242,
		label = "Paremale",
	},
}

local function RotationToDirection(rotation)
	local radianZ = rotation.z * 0.0174532924
	local radianX = rotation.x * 0.0174532924

	local x = -math.sin(radianZ) * math.cos(radianX)
	local y = math.cos(radianZ) * math.cos(radianX)
	local z = math.sin(radianX)

	return vec3(x, y, z)
end

local function RayCastGamePlayCamera(distance)
	local camCoord = GetGameplayCamCoord()
	local camRot = GetGameplayCamRot(0)
	local direction = RotationToDirection(camRot)
	local destination = camCoord + direction * distance

	local rayId = StartShapeTestRay(camCoord.x, camCoord.y, camCoord.z, destination.x, destination.y, destination.z,
		4294967295,
		cache.ped, 7)

	local _, hit, coords, _, entity = GetShapeTestResult(rayId)

	return hit, coords, entity, destination
end

local previewPed = nil

local function previewEmote(category, animationData, time, canMove)
	if not isInPreview then
        local promise = promise.new()
		isInPreview = true

		CreateThread(function()
			local ped = ClonePed(cache.ped, false, false, true)
            previewPed = ped

            SetEntityInvincible(ped, true)
            FreezeEntityPosition(ped, true)
            SetEntityLocallyVisible(ped)
            SetEntityAlpha(ped, 150, false)
            SetEntityCollision(ped, false, false)
            TaskSetBlockingOfNonTemporaryEvents(ped, false)

            if category ~= 'scenarios' then
                requestAnimDict(animationData.dances.dict)
                TaskPlayAnim(ped, animationData.dances.dict, animationData.dances.anim, 1.5, 1.5, -1, canMove, 0, false, false, false)
                RemoveAnimDict(animationData.dances.dict)
            else
                if animationData.scenarios.sex == 'position' then
                    local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0 - 0.5, -0.5)

                    TaskStartScenarioAtPosition(ped, animationData.scenarios.scene, coords.x, coords.y, coords.z, GetEntityHeading(ped), 0, 1, false)
                else
                    TaskStartScenarioInPlace(ped, animationData.scenarios.scene, 0, true)
                end
            end

            for i = 1, #fakeProps do
                DeleteEntity(fakeProps[i])
            end

            if animationData.props then
                fakeProps = createProps(ped, animationData.props)
            end

			local scaleform = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS")
			while not HasScaleformMovieLoaded(scaleform) do Wait(0); end

			PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
			PopScaleformMovieFunctionVoid()

			PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
			PushScaleformMovieFunctionParameterInt(200)
			PopScaleformMovieFunctionVoid()

			for i, key in ipairs(keyBinds) do
				if category == 'scenarios' and (key.label == "Vasakule" or key.label == "Paremale") then
					goto continue
				end

				PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
				PushScaleformMovieFunctionParameterInt(i)
				ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(0, key.code, true))
				BeginTextCommandScaleformString("STRING")
				AddTextComponentScaleform(key.label)
				EndTextCommandScaleformString()
				PopScaleformMovieFunctionVoid()

				::continue::
			end

			if category == 'scenarios' then
				PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
				PushScaleformMovieFunctionParameterInt(3)
				ScaleformMovieMethodAddParamPlayerNameString("")
				BeginTextCommandScaleformString("STRING")
				AddTextComponentScaleform("See on stsenaarium, te ei saa seda liigutada!")
				EndTextCommandScaleformString()
				PopScaleformMovieFunctionVoid()
			end

			PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
			PopScaleformMovieFunctionVoid()

			while isInPreview and DoesEntityExist(ped) do
				local target

				if category ~= 'scenarios' then
					local hit, hitcoords, _, destination = RayCastGamePlayCamera(cfg.maxDistancesForPreview
						[GetFollowPedCamViewMode()])
					target = hitcoords

					if hit ~= 1 then
						local _, groundZ = GetGroundZFor_3dCoord(destination.x, destination.y, destination.z, true)

						target = vector3(destination.x, destination.y, groundZ)
					end

					SetEntityCoords(ped, target.x, target.y, target.z, false, false, false, false)
				else
					target = GetEntityCoords(ped)
					local dist = #(GetEntityCoords(cache.ped) - target)

					if dist >= 10.0 then
						isInPreview = false
						SetScaleformMovieAsNoLongerNeeded(scaleform)

						DeleteEntity(ped)

						for _, prop in ipairs(fakeProps) do
							DeleteEntity(prop)
						end

						fakeProps = {}
					end
				end

				DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)

				for _, key in ipairs(keyBinds) do
					DisableControlAction(0, key.code, true)

					if IsDisabledControlPressed(0, key.code) then
						if key.label == "Mängi animatsiooni" then
							isInPreview = false
							SetScaleformMovieAsNoLongerNeeded(scaleform)

							if key.label == "Mängi animatsiooni" then
								local playerPed = cache.ped
								TaskGoStraightToCoord(playerPed, target.x, target.y, target.z, 1.0, -1,
									GetEntityHeading(ped), 0.0)

								local timer = GetGameTimer()

								while #(GetEntityCoords(playerPed) - target) >= 1.001 do
									if GetGameTimer() - timer >= 3000 then
										break
									end

									Wait(250)
								end

								SetEntityCoords(playerPed, target.x, target.y, target.z, false, false, false, false)
								SetEntityHeading(playerPed, GetEntityHeading(ped))

								Wait(500)

                                if category ~= 'scenarios' then
                                    if animationData.props then
                                        LocalPlayer.state:set('animationObjects', animationData.props, true)
                                    end

                                    requestAnimDict(animationData.dances.dict)
                                    TaskPlayAnim(cache.ped, animationData.dances.dict, animationData.dances.anim, 1.5, 1.5, time, canMove, 0, false, false, false)
                                    RemoveAnimDict(animationData.dances.dict)
                                else
                                    if animationData.scenarios.sex == 'position' then
                                        local coords = GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 0 - 0.5, -0.5)
                    
                                        TaskStartScenarioAtPosition(cache.ped, animationData.scenarios.scene, coords.x, coords.y, coords.z, GetEntityHeading(cache.ped), 0, 1, false)
                                    else
                                        TaskStartScenarioInPlace(cache.ped, animationData.scenarios.scene, 0, true)
                                    end
                                end
							end

                            DeleteEntity(ped); previewPed = nil

							for _, prop in ipairs(fakeProps) do
								DeleteEntity(prop)
							end

							fakeProps = {}

                            promise:resolve(true)
						elseif key.label == "Vasakule" then
							SetEntityHeading(ped, GetEntityHeading(ped) + 7.5)
						elseif key.label == "Paremale" then
							SetEntityHeading(ped, GetEntityHeading(ped) - 7.5)
                        elseif key.label == "Katkesta" then
                            isInPreview = false
                            DeleteEntity(ped); previewPed = nil

							for _, prop in ipairs(fakeProps) do
								DeleteEntity(prop)
							end

							fakeProps = {}

                            promise:resolve(false)
						end
					end
				end

				Wait(0)
			end

			SetScaleformMovieAsNoLongerNeeded(scaleform)
		end)

        return Citizen.Await(promise)
    else
        return false
	end
end

local function playAnimation(animation)
    if globalCanInteract() then
        local currentTime = GetGameTimer()

        if cooldown and (currentTime - cooldown) < cooldownTime then
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ära kiirusta!')
            return
        end

        cooldown = currentTime
        local animationInfo = nil

        for i = 1, #animations do
            local info = animations[i]

            if info.title == animation then
                animationInfo = info
                break
            end
        end

        if animationInfo then
            if animationInfo.dances then
                if playing then
                    cancelAnimation()
                end
        
                if animationInfo.particles then
                    local nearbyPlayers = {}
                    local players = GetActivePlayers()

                    if #players > 1 then
                        for i = 1, #players do
                            nearbyPlayers[i] = GetPlayerServerId(players[i])
                        end

                        ptfxOwner = true
                        TriggerServerEvent('kk-emotes:server:syncPtfx', animationInfo.particles, nearbyPlayers)
                    else
                        playPtfx(cache.ped, animationInfo.particles)
                    end
                end
        
                local time = 1500
                local canMove = 1

                if loop then
                    time = -1
                else
                    if animationInfo.dances.duration then
                        SetTimeout(animationInfo.dances.duration, function() 
                            cancelAnimation()
                        end)
                    else
                        SetTimeout(time, function() 
                            cancelAnimation()
                        end)
                    end
                end

                if move then
                    canMove = 51
                end

                if place then
                    cooldown = cooldown - 2000
                    local result = previewEmote(animationInfo.type, animationInfo, time, canMove)

                    if result then
                        playing = 'animation'
                        return true
                    else
                        return false
                    end
                else
                    if animationInfo.props then
                        LocalPlayer.state:set('animationObjects', animationInfo.props, true)
                    end

                    requestAnimDict(animationInfo.dances.dict)
                    TaskPlayAnim(cache.ped, animationInfo.dances.dict, animationInfo.dances.anim, 1.5, 1.5, time, canMove, 0, false, false, false)
                    RemoveAnimDict(animationInfo.dances.dict)
        
                    playing = 'animation'
                    return true
                end
            elseif animationInfo.expressions then
                SetFacialIdleAnimOverride(cache.ped, animationInfo.expressions.expression, 0)
                currentExpression = animationInfo.expressions.expression
                saveSettings(LocalPlayer.state.identifier)

                return true
            elseif animationInfo.walks then
                lib.requestAnimSet(animationInfo.walks.style)
                SetPedMovementClipset(cache.ped, animationInfo.walks.style, 0)
                RemoveAnimSet(animationInfo.walks.style)
                walkStyle = animationInfo.walks.style
                saveSettings(LocalPlayer.state.identifier)
            elseif animationInfo.shared then
                local playerId, playerPed, playerCoords = lib.getClosestPlayer(GetEntityCoords(cache.ped), 3.0, false)
            
                if DoesEntityExist(playerPed) then
                    local targetId = GetPlayerServerId(playerId)

                    if targetId then
                        TriggerServerEvent('kk-emotes:server:sharedAnimation', targetId, animationInfo.shared)
                    else
                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ühtegi mängijat ei ole läheduses!')
                    end
                else
                    TriggerEvent('KKF.UI.ShowNotification', 'error', 'Ühtegi mängijat ei ole läheduses!')
                end
            elseif animationInfo.scenarios then
                local sex = checkSex()

                if not animationInfo.scenarios.sex == 'both' and not (sex == animationInfo.scenarios.sex) then
                    TriggerEvent('KKF.UI.ShowNotification', 'error', 'Sinu karakter ei võimalda selle animatsiooni mängimist!')
                else
                    if place then
                        cooldown = cooldown - 2000
                        local result = previewEmote(animationInfo.type, animationInfo, time, canMove)
        
                        if result then
                            playing = 'scenario'
                            return true
                        else
                            return false
                        end
                    else
                        if animationInfo.scenarios.sex == 'position' then
                            local coords = GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 0 - 0.5, -0.5)
        
                            TaskStartScenarioAtPosition(cache.ped, animationInfo.scenarios.scene, coords.x, coords.y, coords.z, GetEntityHeading(cache.ped), 0, 1, false)
                        else
                            TaskStartScenarioInPlace(cache.ped, animationInfo.scenarios.scene, 0, true)
                        end
        
                        playing = 'scenario'
                        return true
                    end
                end
            else
                print('Error triggering an emote.')
            end
        else
            return false
        end
    else
        return false
    end
end

RegisterNetEvent('kk-emotes:client:animationAccept', function(source, data)
    local confirmed = lib.alertDialog({
        header = 'Jagatud animatioon',
        content = 'Mängija "' .. source .. '" sinuga koos jagatud animatsiooni mängida.',
        centered = true,
        cancel = true
    })

    TriggerServerEvent('kk-emotes:server:animationAccepted', (confirmed == 'confirm'), source, data)
end)

local function getPlayerPedFromServerId(serverId)
    -- Get the player's client index from their server ID
    local player = GetPlayerFromServerId(serverId)
    
    -- If player exists, return their Ped
    if player ~= -1 then
        return GetPlayerPed(player)
    end
    
    -- Return nil if no valid player was found
    return nil
end

RegisterNetEvent('kk-emotes:client:startShared', function(data, targetId, owner)
    if type(data) == "table" and targetId then
        if playing then
            cancelAnimation()
        end

        Wait(350)

        local targetPlayer = getPlayerPedFromServerId(targetId)

        if targetPlayer then
            SetTimeout(data[4] or 3000, function()
                playing = false
            end)

            playing = true

            if not owner then
                local targetHeading = GetEntityHeading(targetPlayer)
                local targetCoords = GetOffsetFromEntityInWorldCoords(targetPlayer, 0.0, data[3] + 0.0, 0.0)

                SetEntityHeading(cache.ped, targetHeading - 180.1)
                SetEntityCoordsNoOffset(cache.ped, targetCoords.x, targetCoords.y, targetCoords.z, 0)
            end

            requestAnimDict(data[1])
            TaskPlayAnim(cache.ped, data[1], data[2], 2.0, 2.0, data[4] or 3000, 1, 0, false, false, false)
            RemoveAnimDict(data[1])
        end
    end
end)

local function searchAnimation(animation)
    local animationInfo = nil
    local formatted = '/e ' .. animation

    for i = 1, #animations do
        local info = animations[i]

        if info.subtitle == formatted then
            animationInfo = info.title
            break
        end
    end

    if cache.vehicle then
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Autos ei saa animatsiooni mängida!')
        return false
    end

    if animationInfo then
        return playAnimation(animationInfo)
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Seda animatsiooni ei leitud!')
        return false
    end
end

RegisterNUICallback('playAnimation', function(data, cb)
    cb(playAnimation(data.title))
end)

RegisterNUICallback('cancelAnimation', function(data, cb)
    cb(cancelAnimation())
end)

RegisterNUICallback('deleteObjects', function(data, cb)
    cb(removePlayer(cache.serverId))
end)

RegisterCommand('e', function(_, args)
    if args and args[1] then
        if args[1] ~= 'c' then
            return searchAnimation(args[1])
        elseif args[1] == 'menu' then
            TriggerEvent('kk-emotes:client:openMenu')
        else
            return cancelAnimation()
        end
    else
        return TriggerEvent('KKF.UI.ShowNotification', 'error', 'Seda animatsiooni ei leitud!')
    end
end)

RegisterKeyMapping('e c', 'Katkesta animatsioon.', 'keyboard', 'C')

local function loadSettings(identifier)
    local emoteData = GetResourceKvpString('emote_settings_' .. identifier)

    if not emoteData then
        emoteData = {
            loop = false,
            move = false,
            place = false,
            favorites = {},
            walkStyle = nil,
            currentExpression = nil
        }

        SetResourceKvp('emote_settings_' .. identifier, json.encode(emoteData))
    else
        emoteData = json.decode(emoteData)
    end

    loop = emoteData.loop
    move = emoteData.move
    place = emoteData.place
    favorites = emoteData.favorites
    walkStyle = emoteData.walkStyle
    currentExpression = emoteData.currentExpression

    SetTimeout(5000, function()
        if walkStyle then
            lib.requestAnimSet(walkStyle)
            SetPedMovementClipset(cache.ped, walkStyle, 0)
            RemoveAnimSet(walkStyle)
        end
    
        if currentExpression then
            SetFacialIdleAnimOverride(cache.ped, currentExpression, 0)
        end
    end)

    print('Emote settings have been loaded for identifier: ' .. identifier)
end

local function unloadSettings()
    loop = false
    move = false
    place = false
    favorites = {}
    walkStyle = nil
    currentExpression = nil
end

CreateThread(function()
    if LocalPlayer.state.isLoggedIn then
        loadSettings(LocalPlayer.state.identifier)
    end

    while not LocalPlayer.state.isLoggedIn do
        Wait(2000)
    end

    LocalPlayer.state:set('animationObjects', false, true)
    Wait(2000)

    animations = loadAnimations()

    TriggerEvent('chat:addSuggestion', '/e', 'Mängi animatsiooni.', {
        { name = 'emote'},
    })
end)

RegisterNetEvent('KKF.Player.Loaded', function(playerData)
    loadSettings(playerData.identifier)
end)

RegisterNetEvent('KKF.Player.Unloaded', function() 
    unloadSettings()
end)

local menuOpen = false

RegisterNUICallback('closeMenu', function(data, cb)
    menuOpen = false
    SetNuiFocus(false, false)
    cb(true)
end)

RegisterNUICallback('syncSettings', function(data, cb)
    loop = data.loop
    move = data.move
    place = data.place
    favorites = data.favorites

    saveSettings(LocalPlayer.state.identifier)

    cb(true)
end)

RegisterNetEvent('kk-emotes:client:openMenu', function()
    if globalCanInteract() then
        menuOpen = true
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = 'openMenu',
            settings = {
                loop = loop,
                move = move,
                place = place,
                favorites = favorites
            }
        })

        CreateThread(function()
            while menuOpen do
                InvalidateIdleCam()
                InvalidateVehicleIdleCam()

                Wait(1000)
            end
        end)
    end
end)