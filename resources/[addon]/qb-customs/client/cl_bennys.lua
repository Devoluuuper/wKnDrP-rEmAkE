-----------------------
----   Variables   ----
-----------------------
local PlayerData = KKF.GetPlayerData()
local CustomsData = {}

local isPlyInBennys = false
local originalCategory = nil
local originalMod = nil
local originalPrimaryColour = nil
local originalSecondaryColour = nil
local originalPearlescentColour = nil
local originalWheelColour = nil
local originalDashColour = nil
local originalInterColour = nil
local originalWindowTint = nil
local originalWheelCategory = nil
local originalWheel = nil
local originalWheelType = nil
local originalCustomWheels = nil
local originalNeonLightState = nil
local originalNeonLightSide = nil
local originalNeonColourR = nil
local originalNeonColourG = nil
local originalNeonColourB = nil
local originalXenonColour = nil
local originalOldLivery = nil
local originalPlateIndex = nil
local attemptingPurchase = false
local isPurchaseSuccessful = false
local radialMenuItemId = nil
local currentStation = nil

local inZone = false

-----------------------
----   Functions   ----
-----------------------

--#[Local Functions]#--
local function saveVehicle()
    local plyPed = PlayerPedId()
    local veh = GetVehiclePedIsIn(plyPed, false)
    local myCar = KKF.Game.GetVehicleProperties(veh)
    TriggerServerEvent('qb-customs:server:updateVehicle', myCar)
end

local function AllowJob(restrictionData, job)
    if type(restrictionData.job) == "table" then
        if restrictionData.permission then
            if not PlayerData.job.permissions[restrictionData.permission] then
                return false
            end
        end

        for _,restrictedJob in ipairs(restrictionData.job) do
            if restrictedJob == job and PlayerData.job.onDuty then return true end
        end
    else
        if restrictionData.job == "any" or restrictionData.job == job and PlayerData.job.onDuty or not restrictionData.job then return true end
    end
    if Config.Debug then print('Denied for not having allowed job. ('..job..')') end
    return false
end

local function AllowVehicleClass(restrictionData, vehicle)
    local vehicleClass = GetVehicleClass(vehicle)

    if restrictionData.deniedClasses then
        for _,class in ipairs(restrictionData.deniedClasses) do
            if vehicleClass == class then
                if Config.Debug then print('Denied for having denied vehicle class. ('..vehicleClass..')') end
                return false
            end
        end
    end

    if restrictionData.allowedClasses then
        for _,class in ipairs(restrictionData.allowedClasses) do
            if vehicleClass == class then return true end
        end
    end


    if (restrictionData.allowedClasses and restrictionData.allowedClasses[1] == nil) or not restrictionData.allowedClasses or vehicleClass == 0 then return true end
    if Config.Debug then print('Denied for not having allowed vehicle class. ('..vehicleClass..')') end
    return false
end

--#[Global Functions]#--
function AttemptPurchase(type, upgradeLevel)

    if upgradeLevel ~= nil then
        upgradeLevel = upgradeLevel + 2
    end
    TriggerServerEvent("qb-customs:server:attemptPurchase", type, upgradeLevel, currentStation)

    attemptingPurchase = true

    while attemptingPurchase do
        Wait(1)
    end

    if not isPurchaseSuccessful then
        PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    end

    return isPurchaseSuccessful
end

function RepairVehicle()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local getFuel = GetVehicleFuelLevel(plyVeh)

    SetVehicleFixed(plyVeh)
	SetVehicleDirtLevel(plyVeh, 0.0)
    SetVehiclePetrolTankHealth(plyVeh, 4000.0)
    SetVehicleFuelLevel(plyVeh, getFuel)

    for i = 0,5 do SetVehicleTyreFixed(plyVeh, i) end
end

function GetCurrentMod(id)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local mod = GetVehicleMod(plyVeh, id)
    local modName = GetLabelText(GetModTextLabel(plyVeh, id, mod))

    return mod, modName
end

function GetCurrentWheel()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local wheel = GetVehicleMod(plyVeh, 23)
    local wheelName = GetLabelText(GetModTextLabel(plyVeh, 23, wheel))
    local wheelType = GetVehicleWheelType(plyVeh)

    return wheel, wheelName, wheelType
end

function GetCurrentCustomWheelState()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local state = GetVehicleModVariation(plyVeh, 23)

    return state and 1 or 0
end

function GetOriginalWheel()
    return originalWheel
end

function GetOriginalCustomWheel()
    return originalCustomWheels
end

function GetCurrentWindowTint()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    return GetVehicleWindowTint(plyVeh)
end

function GetCurrentVehicleWheelSmokeColour()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local r, g, b = GetVehicleTyreSmokeColor(plyVeh)

    return r, g, b
end

function GetCurrentNeonState(id)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local isEnabled = IsVehicleNeonLightEnabled(plyVeh, id)

    return isEnabled and 1 or 0
end

function GetCurrentNeonColour()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local r, g, b = GetVehicleNeonLightsColour(plyVeh)

    return r, g, b
end

function GetCurrentXenonState()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local isEnabled = IsToggleModOn(plyVeh, 22)

    return isEnabled and 1 or 0
end

function GetCurrentXenonColour()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    return GetVehicleHeadlightsColour(plyVeh)
end

function GetCurrentTurboState()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local isEnabled = IsToggleModOn(plyVeh, 18)

    return isEnabled and 0 or -1
end

function CheckValidMods(category, id, wheelType)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local tempWheel = GetVehicleMod(plyVeh, 23)
    local tempWheelType = GetVehicleWheelType(plyVeh)
    local tempWheelCustom = GetVehicleModVariation(plyVeh, 23)
    local validMods = {}
    local amountValidMods = 0
    local PiipNames = {}

    if wheelType ~= nil then
        SetVehicleWheelType(plyVeh, wheelType)
    end

    if id == 14 then
        for k, _ in pairs(vehicleCustomisation) do
            if vehicleCustomisation[k].category == category then
                PiipNames = vehicleCustomisation[k].PiipNames

                break
            end
        end
    end

    local modAmount = GetNumVehicleMods(plyVeh, id)
    for i = 1, modAmount do
        local label = GetModTextLabel(plyVeh, id, (i - 1))
        local modName = GetLabelText(label)

        if modName == "NULL" then
            if id == 14 then
                if i <= #PiipNames then
                    modName = PiipNames[i].name
                else
                    modName = "Horn " .. i
                end
            else
                modName = category .. " " .. i
            end
        end

        validMods[i] =
        {
            id = (i - 1),
            name = modName
        }

        amountValidMods = amountValidMods + 1
    end

    if modAmount > 0 then
        table.insert(validMods, 1, {
            id = -1,
            name = "Stock " .. category
        })
    end

    if wheelType ~= nil then
        SetVehicleWheelType(plyVeh, tempWheelType)
        SetVehicleMod(plyVeh, 23, tempWheel, tempWheelCustom)
    end

    return validMods, amountValidMods
end

function RestoreOriginalMod()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    SetVehicleMod(plyVeh, originalCategory, originalMod)
    SetVehicleDoorsShut(plyVeh, true)

    originalCategory = nil
    originalMod = nil
end

function RestoreOriginalWindowTint()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    SetVehicleWindowTint(plyVeh, originalWindowTint)

    originalWindowTint = nil
end

function RestoreOriginalColours()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    SetVehicleColours(plyVeh, originalPrimaryColour, originalSecondaryColour)
    SetVehicleExtraColours(plyVeh, originalPearlescentColour, originalWheelColour)
    SetVehicleDashboardColour(plyVeh, originalDashColour)
    SetVehicleInteriorColour(plyVeh, originalInterColour)

    originalPrimaryColour = nil
    originalSecondaryColour = nil
    originalPearlescentColour = nil
    originalWheelColour = nil
    originalDashColour = nil
    originalInterColour = nil
end

function RestoreOriginalWheels()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    SetVehicleWheelType(plyVeh, originalWheelType)

    if originalWheelCategory ~= nil then
        SetVehicleMod(plyVeh, originalWheelCategory, originalWheel, originalCustomWheels)

        if GetVehicleClass(plyVeh) == 8 then --Motorcycle
            SetVehicleMod(plyVeh, 24, originalWheel, originalCustomWheels)
        end

        originalWheelType = nil
        originalWheelCategory = nil
        originalWheel = nil
        originalCustomWheels = nil
    end
end

function RestoreOriginalNeonStates()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    SetVehicleNeonLightEnabled(plyVeh, originalNeonLightSide, originalNeonLightState)

    originalNeonLightState = nil
    originalNeonLightSide = nil
end

function RestoreOriginalNeonColours()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    SetVehicleNeonLightsColour(plyVeh, originalNeonColourR, originalNeonColourG, originalNeonColourB)

    originalNeonColourR = nil
    originalNeonColourG = nil
    originalNeonColourB = nil
end

function RestoreOriginalXenonColour()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    SetVehicleHeadlightsColour(plyVeh, originalXenonColour)
    SetVehicleLights(plyVeh, 0)

    originalXenonColour = nil
end

function RestoreOldLivery()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    SetVehicleLivery(plyVeh, originalOldLivery)
end

function RestorePlateIndex()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    SetVehicleNumberPlateTextIndex(plyVeh, originalPlateIndex)
end

function PreviewMod(categoryID, modID)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    if originalMod == nil and originalCategory == nil then
        originalCategory = categoryID
        originalMod = GetVehicleMod(plyVeh, categoryID)
    end

    if categoryID == 39 or categoryID == 40 or categoryID == 41 then
        SetVehicleDoorOpen(plyVeh, 4, false, true)
    elseif categoryID == 37 or categoryID == 38 then
        SetVehicleDoorOpen(plyVeh, 5, false, true)
    end

    SetVehicleMod(plyVeh, categoryID, modID)
end

function PreviewWindowTint(windowTintID)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    if originalWindowTint == nil then
        originalWindowTint = GetVehicleWindowTint(plyVeh)
    end

    SetVehicleWindowTint(plyVeh, windowTintID)
end

function PreviewColour(paintType, paintCategory, paintID)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    SetVehicleModKit(plyVeh, 0)
    if originalDashColour == nil and originalInterColour == nil and originalPrimaryColour == nil and originalSecondaryColour == nil and originalPearlescentColour == nil and originalWheelColour == nil then
        originalPrimaryColour, originalSecondaryColour = GetVehicleColours(plyVeh)
        originalPearlescentColour, originalWheelColour = GetVehicleExtraColours(plyVeh)
        originalDashColour = GetVehicleDashboardColour(plyVeh)
        originalInterColour = GetVehicleInteriorColour(plyVeh)
    end
    if paintType == 0 then --Primary Colour
        if paintCategory == 1 then --Metallic Paint
            SetVehicleColours(plyVeh, paintID, originalSecondaryColour)
            SetVehicleExtraColours(plyVeh, originalPearlescentColour, originalWheelColour)
        else
            SetVehicleColours(plyVeh, paintID, originalSecondaryColour)
        end
    elseif paintType == 1 then --Secondary Colour
        SetVehicleColours(plyVeh, originalPrimaryColour, paintID)
    elseif paintType == 2 then --Pearlescent Colour
        SetVehicleExtraColours(plyVeh, paintID, originalWheelColour)
    elseif paintType == 3 then --Wheel Colour
        SetVehicleExtraColours(plyVeh, originalPearlescentColour, paintID)
    elseif paintType == 4 then --Dash Colour
        SetVehicleDashboardColour(plyVeh, paintID)
    elseif paintType == 5 then --Interior Colour
        SetVehicleInteriorColour(plyVeh, paintID)
    end
end

function PreviewWheel(categoryID, wheelID, wheelType)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local doesHaveCustomWheels = GetVehicleModVariation(plyVeh, 23)

    if originalWheelCategory == nil and originalWheel == nil and originalWheelType == nil and originalCustomWheels == nil then
        originalWheelCategory = categoryID
        originalWheelType = GetVehicleWheelType(plyVeh)
        originalWheel = GetVehicleMod(plyVeh, 23)
        originalCustomWheels = GetVehicleModVariation(plyVeh, 23)
    end

    SetVehicleWheelType(plyVeh, wheelType)
    SetVehicleMod(plyVeh, categoryID, wheelID, doesHaveCustomWheels)

    if GetVehicleClass(plyVeh) == 8 then --Motorcycle
        SetVehicleMod(plyVeh, 24, wheelID, doesHaveCustomWheels)
    end
end

function PreviewNeon(side, enabled)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    if originalNeonLightState == nil and originalNeonLightSide == nil then
        if IsVehicleNeonLightEnabled(plyVeh, side) then
            originalNeonLightState = 1
        else
            originalNeonLightState = 0
        end

        originalNeonLightSide = side
    end

    SetVehicleNeonLightEnabled(plyVeh, side, enabled)
end

function PreviewNeonColour(r, g, b)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    if originalNeonColourR == nil and originalNeonColourG == nil and originalNeonColourB == nil then
        originalNeonColourR, originalNeonColourG, originalNeonColourB = GetVehicleNeonLightsColour(plyVeh)
    end

    SetVehicleNeonLightsColour(plyVeh, r, g, b)
end

function PreviewXenonColour(colour)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    if originalXenonColour == nil then
        originalXenonColour = GetVehicleHeadlightsColour(plyVeh)
    end

    SetVehicleLights(plyVeh, 2)
    SetVehicleHeadlightsColour(plyVeh, colour)
end

function PreviewOldLivery(liv)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    if originalOldLivery == nil then
        originalOldLivery = GetVehicleLivery(plyVeh)
    end

    SetVehicleLivery(plyVeh, tonumber(liv))
end

function PreviewPlateIndex(index)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    if originalPlateIndex == nil then
        originalPlateIndex = GetVehicleNumberPlateTextIndex(plyVeh)
    end

    SetVehicleNumberPlateTextIndex(plyVeh, tonumber(index))
end

function ApplyMod(categoryID, modID)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    if categoryID == 18 then
        ToggleVehicleMod(plyVeh, categoryID, modID+1)
    elseif categoryID == 11 or categoryID == 12 or categoryID== 13 or categoryID == 15 or categoryID == 16 then --Performance Upgrades
        originalCategory = categoryID
        originalMod = modID

        SetVehicleMod(plyVeh, categoryID, modID)
    else
        originalCategory = categoryID
        originalMod = modID

        SetVehicleMod(plyVeh, categoryID, modID)
    end
end

function ApplyExtra(extraID)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local isEnabled = IsVehicleExtraTurnedOn(plyVeh, extraID)
    if isEnabled == 1 then
        SetVehicleExtra(plyVeh, tonumber(extraID), 1)
        SetVehiclePetrolTankHealth(plyVeh,4000.0)
    else
        SetVehicleExtra(plyVeh, tonumber(extraID), 0)
        SetVehiclePetrolTankHealth(plyVeh,4000.0)
    end
end

function ApplyWindowTint(windowTintID)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    originalWindowTint = windowTintID

    SetVehicleWindowTint(plyVeh, windowTintID)
end

function ApplyColour(paintType, paintCategory, paintID)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local vehPrimaryColour, vehSecondaryColour = GetVehicleColours(plyVeh)
    local vehPearlescentColour, vehWheelColour = GetVehicleExtraColours(plyVeh)

    if paintType == 0 then --Primary Colour
        if paintCategory == 1 then --Metallic Paint
            SetVehicleColours(plyVeh, paintID, vehSecondaryColour)
            -- SetVehicleExtraColours(plyVeh, paintID, vehWheelColour)
            SetVehicleExtraColours(plyVeh, originalPearlescentColour, vehWheelColour)
            originalPrimaryColour = paintID
            -- originalPearlescentColour = paintID
        else
            SetVehicleColours(plyVeh, paintID, vehSecondaryColour)
            originalPrimaryColour = paintID
        end
    elseif paintType == 1 then --Secondary Colour
        SetVehicleColours(plyVeh, vehPrimaryColour, paintID)
        originalSecondaryColour = paintID
    elseif paintType == 2 then --Pearlescent Colour
        SetVehicleExtraColours(plyVeh, paintID, vehWheelColour)
        originalPearlescentColour = paintID
    elseif paintType == 3 then --Wheel Colour
        SetVehicleExtraColours(plyVeh, vehPearlescentColour, paintID)
        originalWheelColour = paintID
    elseif paintType == 4 then --Dash Colour
        SetVehicleDashboardColour(plyVeh, paintID)
        originalDashColour = paintID
    elseif paintType == 5 then --Interior Colour
        SetVehicleInteriorColour(plyVeh, paintID)
        originalInterColour = paintID
    end
end

function ApplyWheel(categoryID, wheelID, wheelType)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local doesHaveCustomWheels = GetVehicleModVariation(plyVeh, 23)

    originalWheelCategory = categoryID
    originalWheel = wheelID
    originalWheelType = wheelType

    SetVehicleWheelType(plyVeh, wheelType)
    SetVehicleMod(plyVeh, categoryID, wheelID, doesHaveCustomWheels)

    if GetVehicleClass(plyVeh) == 8 then --Motorcycle
        SetVehicleMod(plyVeh, 24, wheelID, doesHaveCustomWheels)
    end
end

function ApplyCustomWheel(state)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    SetVehicleMod(plyVeh, 23, GetVehicleMod(plyVeh, 23), state)

    if GetVehicleClass(plyVeh) == 8 then --Motorcycle
        SetVehicleMod(plyVeh, 24, GetVehicleMod(plyVeh, 24), state)
    end
end

function ApplyNeon(side, enabled)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    originalNeonLightState = enabled
    originalNeonLightSide = side

    SetVehicleNeonLightEnabled(plyVeh, side, enabled)
end

function ApplyNeonColour(r, g, b)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    originalNeonColourR = r
    originalNeonColourG = g
    originalNeonColourB = b

    SetVehicleNeonLightsColour(plyVeh, r, g, b)
end

function ApplyXenonLights(category, state)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    ToggleVehicleMod(plyVeh, category, state)
end

function ApplyXenonColour(colour)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    originalXenonColour = colour

    SetVehicleHeadlightsColour(plyVeh, colour)
end

function ApplyOldLivery(liv)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    originalOldLivery = liv

    SetVehicleLivery(plyVeh, liv)
end

function ApplyPlateIndex(index)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    originalPlateIndex = index
    SetVehicleNumberPlateTextIndex(plyVeh, index)
end

function ApplyTyreSmoke(r, g, b)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    ToggleVehicleMod(plyVeh, 20, true)
    SetVehicleTyreSmokeColor(plyVeh, r, g, b)
end

function ExitBennys()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    saveVehicle()

    DisplayMenuContainer(false)
    FreezeEntityPosition(plyVeh, false)
    SetEntityCollision(plyVeh, true, true)

    SetTimeout(100, function()
        DestroyMenus()
    end)

    if next(CustomsData) then
        SetupInteraction()
    end

    isPlyInBennys = false
end


function EnterLocation(override)
    local locationData = Config.Locations[CustomsData.location]
    local categories = (override and override.categories) or {
        repair = false,
        mods = false,
        armor = false,
        respray = false,
        liveries = false,
        wheels = false,
        tint = false,
        plate = false,
        extras = false,
        neons = false,
        xenons = false,
        horn = false,
        turbo = false,
        cosmetics = false,
    }

    local canEnter = false
    local repairOnly = true
    if next(CustomsData) then
        for k,v in pairs(locationData.categories) do
            if not canEnter and v then
                if k ~= "repair" then repairOnly = false end
                canEnter = true
            end
            categories[k] = v
        end
    elseif override then canEnter = true end

    if Config.Debug then
        print('***************************************************************************')
        print(string.format('EnterLocation Debug Start | CanEnter: %s | Repair Only: %s | Override: %s', canEnter, repairOnly, json.encode(override)))
        print('***************************************************************************')
        if next(locationData) then for k,v in pairs(locationData) do print(k, json.encode(v)) end end
        for k,v in pairs(categories) do print(k,v) end
        print('***************************************************************************')
        print('EnterLocation Debug End')
        print('***************************************************************************')
    end

    if not canEnter then
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ei saa siin midagi teha!')
        ExitBennys()
        return
    end

    KKF.HideInteraction()

    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local isMotorcycle

    if GetVehicleClass(plyVeh) == 8 then --Motorcycle
        isMotorcycle = true
    else
        isMotorcycle = false
    end

    SetVehicleModKit(plyVeh, 0)
    SetEntityCoords(plyVeh, ((override and override.coords) or CustomsData.coords))
    SetEntityHeading(plyVeh, ((override and override.heading) or CustomsData.heading))
    FreezeEntityPosition(plyVeh, true)
    SetEntityCollision(plyVeh, false, true)

    local welcomeLabel = (locationData and locationData.settings.welcomeLabel) or "Welcome to Benny's Motorworks!"
    InitiateMenus(isMotorcycle, GetVehicleBodyHealth(plyVeh), categories, welcomeLabel)

    SetTimeout(100, function()
        if GetVehicleBodyHealth(plyVeh) < 1000.0 and categories.repair then
            DisplayMenu(true, "repairMenu")
        else
            DisplayMenu(true, "mainMenu")
        end

        DisplayMenuContainer(true)
        PlaySoundFrontend(-1, "OK", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    end)

    isPlyInBennys = true
    DisableControls(repairOnly)
end


function DisableControls(repairOnly)
    CreateThread(function()
        while isPlyInBennys do
            DisableControlAction(1, 38, true) --Key: E
            DisableControlAction(1, 172, true) --Key: Up Arrow
            DisableControlAction(1, 173, true) --Key: Down Arrow
            DisableControlAction(1, 177, true) --Key: Backspace
            DisableControlAction(1, 176, true) --Key: Enter
            DisableControlAction(1, 71, true) --Key: W (veh_accelerate)
            DisableControlAction(1, 72, true) --Key: S (veh_brake)
            DisableControlAction(1, 34, true) --Key: A
            DisableControlAction(1, 35, true) --Key: D
            DisableControlAction(1, 75, true) --Key: F (veh_exit)

            if IsDisabledControlJustReleased(1, 172) then --Key: Arrow Up
                MenuScrollFunctionality("up")
                PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
            end

            if IsDisabledControlJustReleased(1, 173) then --Key: Arrow Down
                MenuScrollFunctionality("down")
                PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
            end

            if IsDisabledControlJustReleased(1, 176) then --Key: Enter
                MenuManager(true, repairOnly)
                PlaySoundFrontend(-1, "OK", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
            end

            if IsDisabledControlJustReleased(1, 177) then --Key: Backspace
                MenuManager(false)
                PlaySoundFrontend(-1, "NO", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
            end

            Wait(0)
        end
    end)
end

function GetLocations()
    lib.callback('qb-customs:getLocations', false, function(locations)
        Config.Locations = locations
    end)
end

-- function CheckForKeypress()
--     if next(CustomsData) then
--         CreateThread(function()
--             while next(CustomsData) and not isPlyInBennys do
--                 if IsControlJustReleased(0, 38) then if CheckRestrictions(CustomsData.location) then EnterLocation(); currentStation = CustomsData.location return else TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil puudub ligipääs siia!') end end
--                 Wait(0)
--             end
--         end)
--     end
-- end
RegisterNetEvent('kk-customs:client:enterLocation', function()
    if CustomsData then
        if CheckRestrictions(CustomsData.location) then 
            EnterLocation(); currentStation = CustomsData.location  
        else 
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil puudub ligipääs siia!') 
        end
    end
end)

exports('inZone', function()
    return inZone
end)

-- If a player isnt in a vehicle, when they enter the zone, the closet vehicle is checked
-- The vehicle is checked if it has collision disabled and nobody in the driver seat
-- If so it will set the collision to true and unfreeze the entity =D
function CheckForGhostVehicle()
    if GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 then return end
    local closestVehicle, closestDistance = KKF.Game.GetClosestVehicle(GetEntityCoords(PlayerPedId()))
    if closestVehicle ~= -1 and closestDistance < 10.0 and GetEntityCollisionDisabled(closestVehicle) and GetPedInVehicleSeat(closestVehicle, -1) == 0 then
        FreezeEntityPosition(closestVehicle, false)
        SetEntityCollision(closestVehicle, true, true)
    end
end

function CheckRestrictions(location)
    local PlayerPed = PlayerPedId()
    local _location = Config.Locations[location]
    local restrictions = _location.restrictions

    if Config.Debug then
        print('***************************************************************************')
        print('Restriction Debug')
        print('***************************************************************************')
    end

    local isEnabled = _location.settings.enabled
    local vehicle = GetVehiclePedIsIn(PlayerPed, false)
    local allowedJob = AllowJob(restrictions, PlayerData.job.name)
    local allowedClass = AllowVehicleClass(restrictions, GetVehiclePedIsIn(PlayerPed, false))

    if Config.Debug then
        print(string.format('Is Enabled: %s\nVehicle: %s\nallowedJob: \nallowedClass: %s', isEnabled, vehicle, allowedJob, allowedClass))
        print('***************************************************************************')
    end
    return isEnabled and vehicle ~= 0 and allowedJob and allowedClass
end

function SetupInteraction()
    -- local text = '[E] - ' .. CustomsData.drawtextui; CheckForKeypress()
    KKF.ShowInteraction(CustomsData.drawtextui, 'E')
end

exports('GetCustomsData', function() if next(CustomsData) ~= nil then return CustomsData else return nil end end)
-----------------------
----   Threads     ----
-----------------------

-- Location Creation
CreateThread(function()
    while not PlayerData.job do Wait(2500) end
    for location, data in pairs(Config.Locations) do
        -- PolyZone + Drawtext + Locations Management
        for i, spot in ipairs(data.zones) do
            local _name = location.."-customs-"..i

            local newSpot = lib.zones.box({
                coords = spot.coords,
                size = vec3(spot.width, spot.length, math.abs(spot.maxZ - spot.minZ)),
                rotation = spot.heading,
                debug = false,
                onEnter = function()
                    CustomsData = {
                        ['location'] = location,
                        ['spot'] = _name,
                        ['coords'] = vector3(spot.coords.x, spot.coords.y, spot.coords.z),
                        ['heading'] = spot.heading,
                        ['drawtextui'] = data.drawtextui.text,
                    }

                    if CheckRestrictions(CustomsData.location) then
                        SetupInteraction(); inZone = true
                    end
                    
                    CheckForGhostVehicle()
                end,
                onExit = function()
                    CustomsData = {}

                    KKF.HideInteraction(); currentStation = nil; inZone = false
                end
            })
        end
    end
end)
-----------------------
---- Client Events ----
-----------------------

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() and KKF.GetPlayerData() ~= {} then
        GetLocations()
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() and isPlyInBennys then
        ExitBennys()
    end
end)

RegisterNetEvent('KKF.Player.Loaded', function(xPlayer)
    PlayerData = xPlayer; GetLocations()
end)

RegisterNetEvent('KKF.Player.JobUpdate', function(job)
    PlayerData.job = job
end)

RegisterNetEvent('KKF.Player.DutyChange', function(value)
    PlayerData.job.onDuty = value
end)

RegisterNetEvent('qb-customs:client:UpdateLocation', function(location, type, key, value)
    Config.Locations[location][type][key] = value
end)

RegisterNetEvent("qb-customs:client:purchaseSuccessful", function()
    isPurchaseSuccessful = true
    attemptingPurchase = false
end)

RegisterNetEvent("qb-customs:client:purchaseFailed", function()
    isPurchaseSuccessful = false
    attemptingPurchase = false
    TriggerEvent('KKF.UI.ShowNotification', 'error', 'Fraktsioonil ei ole piisavalt raha!')
end)

RegisterNetEvent('qb-customs:client:EnterCustoms', function(override)
    if not override.coords or not override.heading then override = nil end
    if not IsPedInAnyVehicle(PlayerPedId(), false) or isPlyInBennys or (not next(CustomsData) and not override) then return end
    if not override and next(CustomsData) and not CheckRestrictions(CustomsData.location) then return end

    EnterLocation(override)
end)