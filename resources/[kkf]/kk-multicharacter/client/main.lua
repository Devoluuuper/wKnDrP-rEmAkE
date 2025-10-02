local camera = 0
local menuOpen, mapOpend, ableToCreate = false, false, false
local selectedCharacter, totalCharacters = 1, 0
local characterSpawns = {
    [1] = {
        pos = vec4(-1452.0, 226.64175415039, 57.783935546875, 5.6692910194397),
        data = {pid = 1, name = 'Example User', skin = {}, disabled = false},
        ped = 0
    },
    
    [2] = {
        pos = vec4(-1454.2153320312, 226.73406982422, 57.733276367188, 0.0),
        data = {pid = 2, name = 'Example User', skin = {}, disabled = false},
        ped = 0
    },

    [3] = {
        pos = vec4(-1456.6549072266, 226.95823669434, 57.632202148438, 342.99212646484),
        data = {pid = 3, name = 'Example User', skin = {}, disabled = false},
        ped = 0
    },

    [4] = {
        pos = vec4(-1458.8835449219, 228.23736572266, 57.632202148438, 328.81890869141),
        data = {pid = 4, name = 'Example User', skin = {}, disabled = false},
        ped = 0
    },

    [5] = {
        pos = vec4(-1461.6922607422, 229.27912902832, 57.649047851562, 311.81103515625),
        data = {pid = 5, name = 'Example User', skin = {}, disabled = false},
        ped = 0
    }
}

local function spawnCharacter(character, disabled)
    if not disabled then
        if totalCharacters > 0 then
            for k,v in pairs(characterSpawns) do
                ResetEntityAlpha(v.ped)
                DeleteEntity(v.ped)
            end

            SetTimeout(300, function()
                ClearFocus()
                DestroyAllCams(true)
                RenderScriptCams(false, true, 1, true, true)
            end)

            menuOpen = false; print('KKF.Debug: Valisid karakteri PID: ' .. character)
            TriggerServerEvent('kk-core:server:characterChosen', character); selectedCharacter = 1; totalCharacters = 0;
        end
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Selle karakteriga ei saa mängida!')
    end
end

local function createCharacter()
    if ableToCreate then SendNUIMessage({action = "registerCharacter"}); SetNuiFocus(true, true) end
end

local function doCamera()
    local camCoords = vec3(-1453.4373779297, 237.08572387695, 60.592651367188)
	camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetEntityCoords(cache.ped, vec3(-1446.052734375, 242.24176025391, 60.249755859375))
	SetCamRot(camera, -11.503, -0.0, 159.103, 2)
	--SetCamRot(camera, -5.2, 1.0, 180.00, 2)
	--SetCamRot(camera, -5.225195, 0.0, 177.008, 2)
	SetCamCoord(camera, camCoords.x, camCoords.y, camCoords.z)
	StopCamShaking(camera, true)
	SetCamFov(camera, 41.0)
	SetCamActive(camera, true)
	RenderScriptCams(true, false, 0, true, true)
end

RegisterNUICallback('closeMenu', function(args, cb)
    if args.type ~= 'just' then
        for k,v in pairs(characterSpawns) do
            ResetEntityAlpha(v.ped)
            DeleteEntity(v.ped)
        end

        SetNuiFocus(false, false); menuOpen = false; ableToCreate = false; totalCharacters = 0; selectedCharacter = 1
    else
        SetNuiFocus(false, false)
    end
end)

RegisterNUICallback('errorNotif', function(args, cb)
    TriggerEvent('KKF.UI.ShowNotification', 'error', 'Eesnimes/Perekonnanimes on lubatud ainult tähed!')
end)

local function createScaleforms()
    local scaleform = RequestScaleformMovie("instructional_buttons")

    while not HasScaleformMovieLoaded(scaleform) do Wait(0) end

    DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 0, 0)
    
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT");
    ScaleformMovieMethodAddParamInt(0);
    PushScaleformMovieMethodParameterString("~INPUT_CELLPHONE_SELECT~");
    PushScaleformMovieMethodParameterString("Vali karakter");
    EndScaleformMovieMethod();

    BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT");
    ScaleformMovieMethodAddParamInt(1);
    PushScaleformMovieMethodParameterString("~INPUT_CELLPHONE_RIGHT~");
    PushScaleformMovieMethodParameterString("Liigu paremale");
    EndScaleformMovieMethod();

    BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT");
    ScaleformMovieMethodAddParamInt(2);
    PushScaleformMovieMethodParameterString("~INPUT_CELLPHONE_LEFT~");
    PushScaleformMovieMethodParameterString("Liigu vasakule");
    EndScaleformMovieMethod();

    if ableToCreate then
        BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT");
        ScaleformMovieMethodAddParamInt(3);
        PushScaleformMovieMethodParameterString("~INPUT_PICKUP~");
        PushScaleformMovieMethodParameterString("Loo karakter");
        EndScaleformMovieMethod();
    end 

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    while menuOpen do
        DisableAllControlActions(0)
        EnableControlAction(0, 174, true)
        EnableControlAction(0, 18, true)
        EnableControlAction(0, 175, true)
        EnableControlAction(0, 38, true)
        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
        Wait(0)
    end
end

local function requestModel(modelHash, cb)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) and IsModelInCdimage(modelHash) then
		RequestModel(modelHash)

		while not HasModelLoaded(modelHash) do
			Wait(0)
		end
	end

	if cb then cb() end
end

RegisterNetEvent('kk-multicharacter:client:loadCharacters', function(characters, maxSlots)
    if menuOpen then return end
    menuOpen = true;

    doCamera()

    if #characters < maxSlots then ableToCreate = true; end

    for k,v in pairs(characters) do
        totalCharacters += 1 
        characterSpawns[k].data.disabled = v.disabled;
        characterSpawns[k].data.name = v.firstname .. ' ' .. v.lastname; 
        characterSpawns[k].data.pid = v.pid; characterSpawns[k].data.skin = v.skin or { model = 'mp_m_freemode_01' }

        requestModel(characterSpawns[k].data.skin.model, function()
            characterSpawns[k].ped = CreatePed(3, characterSpawns[k].data.skin.model, characterSpawns[k].pos.x, characterSpawns[k].pos.y, characterSpawns[k].pos.z, 0.72, false, false)
            SetEntityHeading(characterSpawns[k].ped, characterSpawns[k].pos.w)

            local gamerTag = CreateFakeMpGamerTag(characterSpawns[k].ped, characterSpawns[k].data.name)
            SetMpGamerTagVisibility(gamerTag, 6, characterSpawns[k].data.disabled)
            
            setPedAppearance(characterSpawns[k].ped, characterSpawns[k].data.skin, characterSpawns[k].data.skin.model)
            FreezeEntityPosition(characterSpawns[k].ped, true); SetEntityInvincible(characterSpawns[k].ped, true)
            SetEntityAlpha(characterSpawns[k].ped, 130, false)
        end)
    end

    ResetEntityAlpha(characterSpawns[1].ped)
    createScaleforms()
end)

CreateThread(function()
    while true do
        wait = 0

        if menuOpen then
            if IsControlJustReleased(0, 175) then
                local newNumber = selectedCharacter + 1

                if newNumber ~= totalCharacters + 1 then
                    SetEntityAlpha(characterSpawns[selectedCharacter].ped, 130, false); selectedCharacter = newNumber; ResetEntityAlpha(characterSpawns[selectedCharacter].ped);
                end
            elseif IsControlJustReleased(0, 174) then
                local newNumber = selectedCharacter - 1

                if newNumber ~= 0 then
                    SetEntityAlpha(characterSpawns[selectedCharacter].ped, 130, false); selectedCharacter = newNumber; ResetEntityAlpha(characterSpawns[selectedCharacter].ped);
                end
            elseif IsControlJustReleased(0, 18) then
                spawnCharacter(characterSpawns[selectedCharacter].data.pid, characterSpawns[selectedCharacter].data.disabled)
            elseif IsControlJustReleased(0, 38) then
                createCharacter()
            end
        else
            wait = 1000
        end

        Wait(wait)
    end
end)

CreateThread(function()
	while true do
        if IsPauseMenuActive() and not mapOpend then
            mapOpend = true
        elseif not IsPauseMenuActive() and mapOpend then
            mapOpend = false
            for k,v in pairs(characterSpawns) do 
                local gamerTag = CreateFakeMpGamerTag(v.ped, v.data.name)
                SetMpGamerTagVisibility(gamerTag, 6, v.data.disabled)
            end
        end

		Wait(1000)
	end
end)