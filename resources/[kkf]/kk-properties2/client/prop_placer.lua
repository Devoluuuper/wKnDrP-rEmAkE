
local locations = {}
local currentProperty = nil
local lastProperty = nil
local previewActive = false
local currentEntity = nil

-- Helper function to get property index from ID
local function getPropertyFromId(id)
    for i = 1, #locations do
        if locations[i].id == id then
            return i
        end
    end
    return nil
end

-- Helper function to check if player can edit property
local function canEditProperty(property)
    if not property.owner then return false end
    local PlayerData = ESX.GetPlayerData()
    if property.owner.type == 'faction' then
        return PlayerData.job.name == property.owner.identifier and PlayerData.job.grade >= (property.owner.requiredGrade or 0)
    elseif property.owner.type == 'person' then
        return PlayerData.identifier == property.owner.identifier
    end
    return false
end

-- Helper function to check if player has property keys
local function hasPropertyKeys(propertyId)
    return lib.callback.await('kk-properties2:hasKeys', false, propertyId)
end

-- Object placement function
local function objectPlacement(model)
    local promise = promise.new()

    if not previewActive then
        if IsModelInCdimage(joaat(model)) then
            previewActive = true

            CreateThread(function()
                local coords = GetEntityCoords(PlayerPedId())

                if currentEntity and DoesEntityExist(currentEntity) then
                    DeleteEntity(currentEntity)
                end

                exports['kk-scripts']:requestModel(joaat(model))

                currentEntity = CreateObject(
                    joaat(model),
                    coords.x, coords.y, coords.z,
                    false, false, false
                )

                SetEntityInvincible(currentEntity, true)
                FreezeEntityPosition(currentEntity, true)
                SetEntityLocallyVisible(currentEntity)
                SetEntityCollision(currentEntity, false, false)
                TaskSetBlockingOfNonTemporaryEvents(currentEntity, false)

                local data = exports.object_gizmo:useGizmo(currentEntity)

                if data then
                    previewActive = false
                    DeleteEntity(currentEntity)

                    promise:resolve({
                        model = model,
                        coords = data.position,
                        rotation = data.rotation
                    })
                else
                    previewActive = false
                    DeleteEntity(currentEntity)
                    promise:resolve(false)
                end
            end)
        else
            print('kk-scripts:prop_placer: Model does not exist.')
            promise:resolve(false)
        end
    else
        promise:resolve(false)
    end

    return Citizen.Await(promise)
end
exports('objectPlacement', objectPlacement)

-- Spawn placeable object event
RegisterNetEvent('kk-properties2:client:spawnPlaceableObject', function(model)
    if not Objects[model] then
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'See ese ei ole paigaldatav!')
        return
    end
    if not currentProperty and not LocalPlayer.state.apartmentInstance then
        if not lastProperty then
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Sa ei saa seda eset siia maha panna!')
            return
        end
    end

    local property = getPropertyFromId(currentProperty or lastProperty)
    if not locations[property] or not (canEditProperty(locations[property]) or hasPropertyKeys(locations[property].id)) then
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Sul ei ole õigust siia eset panna!')
        return
    end

    local placement = exports['kk-properties2']:objectPlacement(model)
    if placement then
        TriggerServerEvent('kk-properties2:server:placeSpawnedObject', currentProperty or lastProperty, placement.model, placement.coords, placement.rotation, 100)
        TriggerEvent('KKF.UI.ShowNotification', 'success', 'Ese paigutatud edukalt!')
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Objekti paigutamine ebaõnnestus! Veendu, et oled õiges kohas.')
    end
end)

-- NUI Callbacks
RegisterNUICallback('sendCryptoToFaction', function(args, cb)
    lib.callback('kk-properties2:sendCryptoToFaction', false, function(response)
        if response then
            TriggerEvent('KKF.UI.ShowNotification', 'success', 'Saatsid fraktsioonile ' .. response.count .. ' eq-t!')
            cb(response.crypto)
        else
            cb(false)
        end
    end, currentProperty, tonumber(args.count))
end)

RegisterNUICallback('levelUp', function(args, cb)
    lib.callback('kk-properties2:levelUp', false, function(response)
        cb(response)
    end, currentProperty)
end)

RegisterNUICallback('factionCryptoInsert', function(args, cb)
    lib.callback('kk-properties2:factionCryptoInsert', false, function(response)
        if response then
            TriggerEvent('KKF.UI.ShowNotification', 'success', 'Saatsid fraktsioonist kinnisvarasse ' .. response.count .. ' eq-t!')
            cb(response.crypto)
        else
            cb(false)
        end
    end, currentProperty, tonumber(args.count))
end)

RegisterNUICallback('buyShopItem', function(args, cb)
    lib.callback('kk-properties2:buyShopItem', false, function(response)
        cb(response)
    end, currentProperty, args.id)
end)

RegisterNUICallback('startMission', function(args, cb)
    lib.callback('kk-properties2:startMission', false, function(response)
        cb(response)
    end, currentProperty, args.id)
end)

-- Client events for updates
RegisterNetEvent('kk-properties2:client:updateCrypto', function(id, count)
    local property = getPropertyFromId(id)
    if locations[property] and currentProperty == locations[property].id then
        SendNUIMessage({ action = 'updateCrypto', data = { crypto = tostring(count) } })
    end
end)

RegisterNetEvent('kk-properties2:client:updatePropDurability', function(propertyId, permanentId, dura)
    local property = getPropertyFromId(propertyId)
    if locations[property] then
        for _, v in pairs(locations[property].props) do
            if v.permanentId == permanentId then
                v.dura = dura
                break
            end
        end
    end
end)

RegisterNetEvent('kk-properties2:client:removeProp', function(propertyId, permanentId)
    local property = getPropertyFromId(propertyId)
    if locations[property] then
        for k, v in pairs(locations[property].props) do
            if v.permanentId == permanentId then
                if v.object and DoesEntityExist(v.object) then
                    exports.ox_target:removeLocalEntity(v.object, {'property_placeable'})
                    DeleteObject(v.object)
                end
                table.remove(locations[property].props, k)
                break
            end
        end
    end
end)

-- Sync locations with controller.lua
RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    locations = lib.callback.await('kk-properties2:fetchLocations', false)
end)

-- Ensure cleanup on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName and currentEntity and DoesEntityExist(currentEntity) then
        DeleteEntity(currentEntity)
        currentEntity = nil
    end
end)
