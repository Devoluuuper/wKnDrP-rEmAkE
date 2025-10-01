local ESX = exports["kk-core"]:getSharedObject()

local animDict, anim = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer'
local huDict, huAnim = 'missminuteman_1ig_2', 'handsup_base'
local lockpickDic, lockpickAnim = 'veh@break_in@0h@p_m_one@', 'low_force_entry_ds'

local foundCar = 0
local hasCurrentKey = false

-- Kontrollib, kas mängijal on võti
function hasKey(plate)
    return exports.ox_inventory:Search('count', 'vehicle_key', { plate = ESX.Math.Trim(plate) }) > 0
end
exports('hasKey', hasKey)

-- Lisa võti
local function addKey(plate)
    TriggerServerEvent('kk-vehicles:server:addKey', plate)
end
exports('addKey', addKey)

-- Eemalda võti
local function removeKey(plate)
    TriggerServerEvent('kk-vehicles:server:removeKey', plate)
end
exports('removeKey', removeKey)

-- Utility: numberplate
local function getPlate(vehicle)
    return ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
end

-- Mootori olek
local function setEngineStatus(vehicle)
    if not vehicle then return false end
    local engineStatus = GetIsVehicleEngineRunning(vehicle)

    SetVehicleUndriveable(vehicle, not engineStatus)

    if GetPedInVehicleSeat(vehicle, -1) > 0 then
        SetVehicleEngineOn(vehicle, engineStatus, false, true)
    else
        SetVehicleEngineOn(vehicle, engineStatus, true, true)
    end

    return engineStatus
end

-- Job info
local PlayerJob = {}

-- Kui resource käivitub, laeme töö kohe sisse
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        local data = lib.callback.await('esx:getPlayerData', false)
        if data and data.job then
            PlayerJob = data.job
        end
    end
end)

-- ESX eventid
RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    PlayerJob = xPlayer.job
end)

RegisterNetEvent('esx:onPlayerLogout', function()
    PlayerJob = {}
end)

RegisterNetEvent('esx:setJob', function(job)
    PlayerJob = job
end)

-- Kontroll, kas on politsei
local function isPolice()
    return PlayerJob.name == 'police'
end

-- Kontroll, kas sõiduk kuulub mängijale
local function isOwned(vehicle)
    return lib.callback.await('kk-vehicles:isPlayerOwned', false, getPlate(vehicle))
end

-- Kontroll, kas boosting on lubatud
local function boostingCheck(vehicle, inside, plate)
    local boostingInfo = Entity(vehicle).state.boostingData
    local identifier = ESX.GetPlayerData().identifier

    if boostingInfo ~= nil and (
        (not boostingInfo.groupIdentifiers and boostingInfo.cid ~= identifier) or
        (boostingInfo.groupIdentifiers and not boostingInfo.groupIdentifiers[identifier])
    ) then
        TriggerEvent('KKF.UI.ShowNotification', 'Te ei oska siin midagi teha!')
        return false
    else
        if boostingInfo ~= nil and boostingInfo.advancedSystem then
            TriggerEvent('KKF.UI.ShowNotification', 'See sõiduk vajab täiustatud süsteeme!')
            return false
        else
            return true
        end
    end
end
