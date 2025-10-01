

-- Local variables
local locations = {}
local loadedProperties = {}
local currentProperty = nil
local lastProperty = nil

-- Utility function to check if table contains value
local function tableContains(table, element)
    if type(table) ~= 'table' then return false end
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

-- Helper function to check if player has keys
local function hasPropertyKeys(propertyId)
    return lib.callback.await('kk-properties2:hasKeys', false, propertyId) or false
end

-- Helper function to check if player can edit property with null check
local function canEditProperty(property)
    if not property or not property.owner then return false end
    local PlayerData = ESX.GetPlayerData()
    if property.owner.type == 'faction' then
        return PlayerData.job.name == property.owner.identifier and PlayerData.job.grade >= (property.owner.requiredGrade or 0)
    elseif property.owner.type == 'person' then
        return PlayerData.identifier == property.owner.identifier
    end
    return false
end

-- Helper function to check if player has access to garage
local function hasGarageAccess(property)
    if not property or not property.owner then return false end
    local PlayerData = ESX.GetPlayerData()
    local job = PlayerData.job.name
    local illegalJobs = {'lostmc', 'mafia', 'gang'} -- Customize with your illegal job names
    local legalJobs = {'police', 'mechanic', 'taxi'} -- Customize with your legal job names

    if property.owner.type == 'faction' then
        if property.owner.identifier == job then
            if tableContains(legalJobs, job) or tableContains(illegalJobs, job) then
                return true
            end
        end
    elseif property.owner.type == 'person' and PlayerData.identifier == property.owner.identifier then
        return true -- Owner always has access
    end
    return false
end

-- Player loaded event with enhanced error handling
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
    local success, result = pcall(function()
        locations = lib.callback.await('kk-properties2:fetchLocations', false, 15000) -- Increased timeout
    end)
    if success and locations and #locations > 0 then
        print('Fetched locations successfully:', json.encode(locations))
        for i = 1, #locations do
            if locations[i].type == 'shop' then
                local blip = AddBlipForCoord(locations[i].zone.coords.x, locations[i].zone.coords.y, locations[i].zone.coords.z)
                SetBlipSprite(blip, 59)
                SetBlipColour(blip, 0)
                SetBlipScale(blip, 0.7)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString('Kauplus')
                EndTextCommandSetBlipName(blip)
            end
            if canEditProperty(locations[i]) then
                print('Can edit property ID:', locations[i].id, 'Label:', locations[i].label)
                local blip = AddBlipForCoord(locations[i].zone.coords.x, locations[i].zone.coords.y, locations[i].zone.coords.z)
                SetBlipSprite(blip, 492)
                SetBlipColour(blip, 36)
                SetBlipScale(blip, 0.7)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(locations[i].label)
                EndTextCommandSetBlipName(blip)
            end
            -- Reload props from database for this property
            TriggerServerEvent('kk-properties2:server:requestDecorations', locations[i].id)
        end
    else
        print('Failed to fetch locations or empty result:', result or 'No data')
        locations = {}
    end
end)

-- Player unloaded event
RegisterNetEvent('esx:playerDropped')
AddEventHandler('esx:playerDropped', function()
    for i = 1, #locations do
        RemoveBlip(GetBlipFromEntity('property_' .. i)) -- Remove blip by name or ID if stored
    end
    locations = {}
    loadedProperties = {}
    currentProperty = nil
    lastProperty = nil
end)

-- Job update event
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    for i = 1, #locations do
        if canEditProperty(locations[i]) then
            local blip = AddBlipForCoord(locations[i].zone.coords.x, locations[i].zone.coords.y, locations[i].zone.coords.z)
            SetBlipSprite(blip, 492)
            SetBlipColour(blip, 36)
            SetBlipScale(blip, 0.7)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(locations[i].label)
            EndTextCommandSetBlipName(blip)
        else
            RemoveBlip(GetBlipFromEntity('property_' .. i)) -- Remove blip if no longer editable
        end
    end
end)

-- Get property index from ID
local function getPropertyFromId(id)
    for i = 1, #locations do
        if locations[i].id == id then
            return i
        end
    end
    return nil
end

-- Get current warehouse ID
local function currentWarehouse()
    if not currentProperty then return 0 end
    local property = getPropertyFromId(currentProperty)
    if property and locations[property].type == 'warehouse' then
        return locations[property].id
    end
    return 0
end
exports('currentWarehouse', currentWarehouse)

-- Get current gang property ID
local function currentGang()
    if not currentProperty then return 0 end
    local property = getPropertyFromId(currentProperty)
    if property and locations[property].type == 'gang' then
        return locations[property].id
    end
    return 0
end
exports('currentGang', currentGang)

-- Handle property sale offer
RegisterNetEvent('kk-properties2:client:sellTarget')
AddEventHandler('kk-properties2:client:sellTarget', function(price)
    local confirmed = lib.alertDialog({
        header = 'Kinnisvara soetamine',
        content = 'Hind: $' .. price,
        centered = true,
        cancel = true
    })

    if confirmed == 'confirm' then
        TriggerServerEvent('kk-properties2:server:acceptProperty')
    else
        TriggerServerEvent('kk-properties2:server:declineProperty')
    end
end)

-- Update property lock
RegisterNetEvent('kk-properties2:client:updateLock')
AddEventHandler('kk-properties2:client:updateLock', function(id, key)
    local property = getPropertyFromId(id)
    if locations[property] then
        locations[property].key = key
    end
end)

-- Update property level
RegisterNetEvent('kk-properties2:client:updateLevel')
AddEventHandler('kk-properties2:client:updateLevel', function(id, level)
    local property = getPropertyFromId(id)
    if locations[property] then
        locations[property].level = level
    end
end)

-- Update property owner
RegisterNetEvent('kk-properties2:client:updateOwner')
AddEventHandler('kk-properties2:client:updateOwner', function(id, owner)
    local property = getPropertyFromId(id)
    if not property then return end
    RemoveBlip(GetBlipFromEntity('property_' .. property)) -- Remove old blip
    locations[property].owner = owner
    if canEditProperty(locations[property]) then
        local blip = AddBlipForCoord(locations[property].zone.coords.x, locations[property].zone.coords.y, locations[property].zone.coords.z)
        SetBlipSprite(blip, 492)
        SetBlipColour(blip, 36)
        SetBlipScale(blip, 0.7)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(locations[property].label)
        EndTextCommandSetBlipName(blip)
    end
end)

-- Load property decorations
RegisterNetEvent('kk-properties2:client:loadDecorations')
AddEventHandler('kk-properties2:client:loadDecorations', function(id, decorations)
    local property = getPropertyFromId(id)
    if not property then return end
    print('Loading decorations for property ID:', id, 'Decorations:', json.encode(decorations))

    local oldProps = locations[property].props or {}
    for _, v in pairs(oldProps) do
        if v.object and DoesEntityExist(v.object) then
            exports.ox_target:removeLocalEntity(v.object, {
                'property_stash',
                'property_crafting_bkr',
                'property_check_durability',
                'property_placeable',
                'property_placeable_2'
            })
            DeleteObject(v.object)
        end
    end

    local newProps = {}
    if decorations then
        local propMap = {}
        for _, v in pairs(decorations) do
            if not propMap[v.permanentId] then
                propMap[v.permanentId] = true
                local hash = GetHashKey(v.model)
                if IsModelInCdimage(hash) then
                    exports['kk-scripts']:requestModel(hash)
                    local object = CreateObject(hash, v.position.x, v.position.y, v.position.z, false, false, false)
                    PlaceObjectOnGroundProperly(object)
                    FreezeEntityPosition(object, true)
                    SetEntityCoordsNoOffset(object, v.position.x, v.position.y, v.position.z)
                    SetEntityRotation(object, v.position.rotx or 0, v.position.roty or 0, v.position.rotz or 0)
                    SetEntityAsMissionEntity(object, true, true)
                    if not NetworkGetEntityIsNetworked(object) then
                        NetworkRegisterEntityAsNetworked(object)
                    end

                    v.dura = v.dura or 100
                    local placeable = cfg.objects[v.model]
                    if placeable then
                        if placeable.type == 'crafting' then
                            exports.ox_target:addLocalEntity(object, {
                                {
                                    name = 'property_crafting_bkr',
                                    distance = 1.5,
                                    icon = 'fa-solid fa-hammer',
                                    label = 'Ehituslaud',
                                    onSelect = function()
                                        exports['kk-crafting']:openCraftingMenu(v.model)
                                    end
                                }
                            })
                        elseif placeable.type == 'terminal' then
                            exports.ox_target:addLocalEntity(object, {
                                {
                                    name = 'property_placeable_2',
                                    distance = 1.5,
                                    icon = 'fa-solid fa-cash-register',
                                    label = 'Ava terminal',
                                    onSelect = function()
                                        if hasPropertyKeys(id) then
                                            local input = lib.inputDialog('Arve loomine', { { type = 'number', label = 'Arve summa', required = true } })
                                            if input and input[1] then
                                                local price = tonumber(input[1])
                                                lib.callback('kk-properties2:sendPayment', false, function(response)
                                                    if response then
                                                        KKF.UI.ShowNotification('Arve esitatud!', 'success')
                                                    else
                                                        KKF.UI.ShowNotification('Siit on juba arve esitatud!', 'error')
                                                    end
                                                end, id, v.permanentId, price)
                                            end
                                        else
                                            lib.callback('kk-properties2:recievePaymentInfo', false, function(info)
                                                if info then
                                                    local elements = {
                                                        {
                                                            icon = 'fa-solid fa-cash-register',
                                                            title = 'Summa: $' .. info.price .. ' + VAT ' .. exports['kk-taxes']:getTax('primary').value .. '%.'
                                                        },
                                                        {
                                                            icon = 'fa-solid fa-credit-card',
                                                            title = 'Maksa kaardiga',
                                                            serverEvent = 'kk-properties2:server:payTerminal',
                                                            args = { id = id, terminal = v.permanentId, type = 'bank' }
                                                        },
                                                        {
                                                            icon = 'fa-solid fa-money-bill',
                                                            title = 'Maksa sularahas',
                                                            serverEvent = 'kk-properties2:server:payTerminal',
                                                            args = { id = id, terminal = v.permanentId, type = 'cash' }
                                                        }
                                                    }
                                                    lib.registerContext({
                                                        id = 'payment_menu',
                                                        title = 'Restorani terminal',
                                                        options = elements
                                                    })
                                                    lib.showContext('payment_menu')
                                                else
                                                    KKF.UI.ShowNotification('Siia terminali ei ole esitatud ühtegi arvet!', 'error')
                                                end
                                            end, id, v.permanentId)
                                        end
                                    end
                                }
                            })
                        end

                        if placeable.inventory then
                            exports.ox_target:addLocalEntity(object, {
                                {
                                    name = 'property_stash',
                                    distance = 1.5,
                                    icon = 'fas fa-boxes',
                                    label = 'Ava kapp',
                                    onSelect = function()
                                        if hasPropertyKeys(id) or placeable.type == 'food_tray' then
                                            exports.ox_inventory:openInventory('stash', { id = 'property_' .. id .. '_' .. v.permanentId, owner = false })
                                        else
                                            KKF.UI.ShowNotification('Teil ei ole võtmeid!', 'error')
                                        end
                                    end
                                }
                            })
                        end
                    end

                    exports.ox_target:addLocalEntity(object, {
                        {
                            name = 'property_placeable',
                            distance = 1.5,
                            icon = 'fa-solid fa-hand',
                            label = 'Korja üles',
                            canInteract = function()
                                return canEditProperty(locations[property])
                            end,
                            onSelect = function()
                                local confirmed = lib.alertDialog({
                                    header = 'Objekti üles korjamine',
                                    content = 'Väärtuslikud asjad võivad hävida!',
                                    centered = true,
                                    cancel = true
                                })
                                if confirmed == 'confirm' then
                                    local progress = exports['kk-taskbar']:startAction('pick_object', 'Korjad objekti üles', math.random(3000, 5000), 'fixing_a_ped', 'mini@repair', { freeze = true, controls = true })
                                    if progress then
                                        TriggerServerEvent('kk-properties2:server:removePlacedObject', id, v.permanentId)
                                    end
                                end
                            end
                        },
                        {
                            name = 'property_check_durability',
                            distance = 1.5,
                            icon = 'fa-solid fa-battery-half',
                            label = 'Vaata seisukorda',
                            onSelect = function()
                                local percent = v.dura or 100
                                KKF.UI.ShowNotification('Eseme seisukord: ' .. percent .. '%', 'info')
                            end
                        }
                    })

                    v.object = object
                    table.insert(newProps, v)
                end
            end
        end
        locations[property].props = newProps
    else
        locations[property].props = decorations or {}
        print('No decorations loaded for property ID:', id)
    end
end)

-- Resource stop cleanup
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        for i = 1, #locations do
            RemoveBlip(GetBlipFromEntity('property_' .. i)) -- Remove blip
            for _, v in pairs(locations[i].props or {}) do
                if v.object and DoesEntityExist(v.object) then
                    exports.ox_target:removeLocalEntity(v.object, {
                        'property_stash',
                        'property_crafting_bkr',
                        'property_check_durability',
                        'property_placeable',
                        'property_placeable_2'
                    })
                    DeleteObject(v.object)
                    print('Cleaned up prop object:', v.permanentId, 'for property ID:', locations[i].id)
                end
            end
            locations[i].props = {} -- Clear props table
        end
        locations = {}
        loadedProperties = {}
        currentProperty = nil
        lastProperty = nil
        print('^2[kk-properties2] Resource stopped, all props and data cleaned up.^7')
    end
end)

-- NUI Callbacks
RegisterNUICallback('buyKeysButton', function(args, cb)
    TriggerServerEvent('kk-properties2:server:newKey', currentProperty)
    cb('done')
end)

RegisterNUICallback('buyLockButton', function(args, cb)
    TriggerServerEvent('kk-properties2:server:newLock', currentProperty)
    cb('done')
end)

RegisterNUICallback('decorateButton', function(args, cb)
    cb('done')
    SetNuiFocus(false, false)
    exports['kk-scripts']:toggleTab(false)
    TriggerEvent('kk-properties2:client:startDecorating')
end)

RegisterNUICallback('sellPropertyButton', function(args, cb)
    cb('done')
    SetNuiFocus(false, false)
    exports['kk-scripts']:toggleTab(false)
    local input = lib.inputDialog('Kinnisvara müük', {
        { type = 'number', label = 'State ID', placeholder = '1337', required = true },
        { type = 'number', label = 'Hind', placeholder = '$50000', required = true }
    })
    if input and input[1] and input[2] then
        TriggerServerEvent('kk-properties2:server:sellProperty', currentProperty, input[1], input[2])
    end
end)

RegisterNUICallback('closeTablet', function(args, cb)
    cb('done')
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
    exports['kk-scripts']:toggleTab(false)
end)

RegisterNUICallback('payBill', function(args, cb)
    lib.callback('kk-properties2:payBill', false, function(response)
        if response then
            KKF.UI.ShowNotification('Tasusite arve!', 'success')
        else
            KKF.UI.ShowNotification('Teil ei ole pangas piisavalt raha!', 'error')
        end
        cb(response)
    end, currentProperty, args.id)
end)

RegisterNUICallback('sendCryptoToFaction', function(args, cb)
    lib.callback('kk-properties2:sendCryptoToFaction', false, function(response)
        if response then
            KKF.UI.ShowNotification('Saatsite fraktsiooni ' .. response.count .. ' eq-t!', 'success')
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
            KKF.UI.ShowNotification('Saatsite fraktsioonist kinnisvarasse ' .. response.count .. ' eq-t!', 'success')
            cb(response.crypto)
        else
            cb(false)
        end
    end, currentProperty, tonumber(args.count))
end)

RegisterNUICallback('buyShopItem', function(args, cb)
    print('NUI buyShopItem triggered with args:', json.encode(args)) -- Debug log
    if not currentProperty or not args.id then
        print('^1[kk-properties2] ERROR: Invalid currentProperty or args.id:', currentProperty, args.id, '^7')
        cb({ success = false, error = 'Invalid property or item selection' })
        return
    end
    lib.callback('kk-properties2:buyShopItem', false, function(response)
        print('Server response for buyShopItem:', json.encode(response)) -- Debug log
        cb(response)
    end, { propertyId = currentProperty, itemIndex = tonumber(args.id) }) -- Send as a table
end)

RegisterNUICallback('startMission', function(args, cb)
    lib.callback('kk-properties2:startMission', false, function(response)
        cb(response)
    end, currentProperty, args.id)
end)

-- Open property tablet
local function openTablet(property)
    if canEditProperty(locations[property]) or hasPropertyKeys(locations[property].id) then
        print('Opening tablet for property:', locations[property].label) -- Debug print
        SendNUIMessage({
            action = 'open',
            data = {
                label = locations[property].label,
                canEdit = canEditProperty(locations[property]),
                hasKeys = hasPropertyKeys(locations[property].id),
                keyPrice = cfg.keyPrice,
                lockPrice = cfg.lockPrice,
                logs = lib.callback.await('kk-properties2:getLogs', false, locations[property].id),
                bills = lib.callback.await('kk-properties2:getBills', false, locations[property].id),
                type = locations[property].type,
                warehouse = lib.callback.await('kk-properties2:getWarehouse', false, locations[property].id)
            }
        })
        SetNuiFocus(true, true)
        exports['kk-scripts']:toggleTab(true)
    end
end

-- Use remote to open tablet
RegisterNetEvent('kk-properties2:client:useRemote')
AddEventHandler('kk-properties2:client:useRemote', function(id, keyId)
    if currentProperty then
        local property = getPropertyFromId(currentProperty)
        if locations[property].id == id and (locations[property].type == 'warehouse' or locations[property].type == 'shop' or locations[property].type == 'gang') and locations[property].key == keyId then
            openTablet(property)
        else
            KKF.UI.ShowNotification('See pult ei tööta siin!', 'error')
        end
    else
        KKF.UI.ShowNotification('See pult ei tööta siin!', 'error')
    end
end)

-- Property zone management
CreateThread(function()
    while not ESX.GetPlayerData().identifier do
        Wait(500)
    end
    print('My identifier:', ESX.GetPlayerData().identifier)

    local success, result = pcall(function()
        locations = lib.callback.await('kk-properties2:fetchLocations', false, 15000) -- Increased timeout
    end)
    if success and locations and #locations > 0 then
        print('Fetched locations in CreateThread:', json.encode(locations))
    else
        print('Failed to fetch locations in CreateThread:', result or 'No data')
        locations = {}
    end

    for i = 1, #locations do
        print('Setting up zone for property ID:', locations[i].id, 'Panel:', json.encode(locations[i].panel))
        locations[i].propsBox = lib.zones.box({
            coords = locations[i].zone.coords,
            size = vec3(locations[i].zone.size.x * 1.5, locations[i].zone.size.y * 1.5, locations[i].zone.size.z * 1.5),
            rotation = locations[i].zone.rotation,
            debug = false, -- Enable debug to visualize the zone
            onEnter = function()
                loadedProperties[locations[i].id] = true
                if locations[i].garage then
                    local garageCoords
                    if type(locations[i].garage) == "vector3" or type(locations[i].garage) == "vector4" then
                        garageCoords = locations[i].garage
                    elseif type(locations[i].garage) == "table" and locations[i].garage.x and locations[i].garage.y and locations[i].garage.z then
                        garageCoords = vec3(locations[i].garage.x, locations[i].garage.y, locations[i].garage.z)
                    else
                        print(("⚠️ Vale garaaži info kinnisvaral ID %s"):format(locations[i].id))
                        return
                    end

                    if garageCoords then
                        local point = lib.points.new({
                            coords = garageCoords,
                            distance = 5,
                            canInteract = false
                        })
                        function point:onEnter()
                            self.canInteract = hasGarageAccess(locations[i]) or hasPropertyKeys(locations[i].id)
                            if self.canInteract then
                                TriggerEvent('kk-hud2:client:showInteract', 'Garaaž')
                                TriggerEvent('kk-garages:client:updateData', true, 'car', 'property_' .. locations[i].id, garageCoords, true)
                            end
                        end
                        function point:onExit()
                            self.canInteract = false
                            TriggerEvent('kk-hud2:client:hideInteract')
                            TriggerEvent('kk-garages:client:updateData', false, '', '')
                        end
                        function point:nearby()
                            if self.canInteract then
                                DrawMarker(2, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 14, 165, 233, 222, false, false, false, true, false, false, false)
                            end
                        end
                        locations[i].garage_zone = point
                    end
                end
                if LocalPlayer.state.adminMode then
                    print('Kinnisvara ID:', locations[i].id)
                end
            end,
        })

        locations[i].zoneBox = lib.zones.box({
            coords = locations[i].zone.coords,
            size = locations[i].zone.size,
            rotation = locations[i].zone.rotation,
            debug = false, -- Enable debug to visualize the zone
            onEnter = function()
                currentProperty = locations[i].id
                TriggerServerEvent('esx:setMetadata', 'currentProperty', currentProperty)
                print('Entered zone for property ID:', locations[i].id, 'Current position:', GetEntityCoords(cache.ped), 'Current property set to:', currentProperty)
                if not locations[i].panelBox then
                    local success, result = pcall(function()
                        locations[i].panelBox = exports.ox_target:addBoxZone({
                            coords = locations[i].panel.coords,
                            size = locations[i].panel.size,
                            rotation = locations[i].panel.rotation,
                            debug = true, -- Visualize the panel zone
                            options = {
                                {
                                    icon = 'fa-solid fa-house',
                                    label = 'Kinnisvara seaded',
                                    distance = 1.5,
                                    canInteract = function()
                                        local canEdit = canEditProperty(locations[i])
                                        local hasKeys = hasPropertyKeys(locations[i].id)
                                        print('Can edit:', canEdit, 'Has keys:', hasKeys, 'for property ID:', locations[i].id, 'Player position:', GetEntityCoords(cache.ped))
                                        return canEdit or hasKeys
                                    end,
                                    onSelect = function()
                                        openTablet(i)
                                        print('ISSI ELBO:', locations[i].id)
                                    end
                                },
                                {
                                    event = 'kk-skin:client:openOutfitMenu',
                                    icon = 'fa-solid fa-tshirt',
                                    label = 'Riidekapp',
                                    distance = 1.5
                                },
                                {
                                    serverEvent = 'kk-core:server:unload',
                                    icon = 'fa-solid fa-person-booth',
                                    label = 'Vaheta karakterit',
                                    distance = 1.5
                                }
                            }
                        })
                    end)
                    if not success then
                        print('⚠️ Failed to create panelBox for property ID', locations[i].id, 'Error:', result)
                    else
                        print('PanelBox created successfully for property ID:', locations[i].id)
                    end
                end
            end,
            onExit = function()
                lastProperty = locations[i].id
                currentProperty = nil
                TriggerServerEvent('esx:setMetadata', 'currentProperty', nil)
                if locations[i] and locations[i].panelBox then
                    exports.ox_target:removeZone(locations[i].panelBox)
                    locations[i].panelBox = nil
                    print('PanelBox removed for property ID:', locations[i].id)
                else
                    print('⚠️ panelBox is nil for property ID', locations[i].id, 'on exit')
                end
            end
        })
    end

    TriggerEvent('chat:addSuggestion', '/propertyKeys', 'Kinnisvara võtme võtmine.', { { name = 'id', help = 'Property ID' } })
    TriggerEvent('chat:addSuggestion', '/revokeProperty', 'Omasta kinnisvara.', { { name = 'id', help = 'Property ID' } })
end)

-- Client-side export for ox_inventory item usage
exports('clientPlaceProp', function(item, slot)
    local model = item.name -- Get model from item name
    print('Kasutan itemit:', model)

    if not cfg.objects[model] then
        print('Model not in cfg.objects:', model)
        KKF.UI.ShowNotification('See ese ei ole paigaldatav!', 'error')
        return
    end

    if not currentProperty and not LocalPlayer.state.apartmentInstance then
        KKF.UI.ShowNotification('Sa ei saa seda eset siia maha panna!', 'error')
        return
    end

    local property = getPropertyFromId(currentProperty or lastProperty)
    if not locations[property] or not (canEditProperty(locations[property]) or hasPropertyKeys(locations[property].id)) then
        KKF.UI.ShowNotification('Sul ei ole õigusi siia panna!', 'error')
        return
    end

    -- objectPlacement
    local placement = exports['kk-properties2']:objectPlacement(model)
    if not placement then
        KKF.UI.ShowNotification('Objekti paigutamine ebaõnnestus!', 'error')
        return
    end

    local durability = (slot.metadata and slot.metadata.durability) or 100
    if durability <= 0 then
        KKF.UI.ShowNotification('Ese on katki!', 'error')
        return
    end

    TriggerServerEvent('kk-properties2:server:placeSpawnedObject', currentProperty or lastProperty, placement.model, placement.coords, placement.rotation, durability)
end)

RegisterNetEvent('kk-properties2:client:spawnPlaceableObject')
AddEventHandler('kk-properties2:client:spawnPlaceableObject', function(model)
    print('Attempting to spawn object:', model, 'Current property:', currentProperty, 'Last property:', lastProperty) -- Debug
    if not cfg.objects[model] then
        print('Model not in Objects config:', model)
        KKF.UI.ShowNotification('See ese ei ole paigaldatav!', 'error')
        return
    end
    if not currentProperty and not LocalPlayer.state.apartmentInstance then
        print('No current property or apartment instance, trying last property')
        if not lastProperty then
            print('No last property available')
            KKF.UI.ShowNotification('Sa ei saa seda eset siia maha panna!', 'error')
            return
        end
    end

    local property
    local coords = GetEntityCoords(cache.ped, true)
    coords = vec3(coords.x, coords.y, coords.z - 1.0)

    if not LocalPlayer.state.apartmentInstance then
        if not currentProperty then
            property = getPropertyFromId(lastProperty)
            if not locations[property] or not (canEditProperty(locations[property]) or hasPropertyKeys(locations[property].id)) then
                print('No permission for last property:', lastProperty)
                KKF.UI.ShowNotification('Sa ei saa seda eset siia maha panna!', 'error')
                return
            end
            currentProperty = lastProperty -- Temporarily set for this action
        else
            property = getPropertyFromId(currentProperty)
            if not locations[property] or not (canEditProperty(locations[property]) or hasPropertyKeys(locations[property].id)) then
                print('No permission for current property:', currentProperty)
                KKF.UI.ShowNotification('Sa ei saa seda eset siia maha panna!', 'error')
                return
            end
        end
    end

    print('Calling objectPlacement for model:', model) -- Debug gizmo start
    local placement = exports['kk-properties2']:objectPlacement(model)
    if placement then
        print('objectPlacement returned:', json.encode(placement)) -- Debug gizmo result
        local distance = #(GetEntityCoords(cache.ped) - placement.coords)
        if distance > 15.0 then
            print('Placement too far:', distance)
            KKF.UI.ShowNotification('Asetasid objekti liiga kaugele!', 'error')
            return
        end

        local slot = exports.ox_inventory:GetSlotWithItem(cache.serverId, model)
        if not slot then
            local items = exports.ox_inventory:Search('slots', model)
            if items and #items > 0 then
                slot = items[1]
            end
        end

        if not slot then
            print('No slot found for model:', model)
            KKF.UI.ShowNotification('Sa ei oma seda eset oma inventaris!', 'error')
            return
        end

        local durability = slot.metadata and slot.metadata.durability or 100
        if durability <= 0 then
            print('Durability too low:', durability)
            KKF.UI.ShowNotification('See ese on katki ja ei saa seda asetada!', 'error')
            return
        end

        print('Triggering server event for property:', currentProperty, 'Model:', model, 'Coords:', placement.coords, 'Rotation:', placement.rotation, 'Durability:', durability)
        if currentProperty then
            TriggerServerEvent('kk-properties2:server:placeSpawnedObject', currentProperty, placement.model, placement.coords, placement.rotation, durability)
        else
            TriggerServerEvent('kk-apartments:server:placeSpawnedObject', LocalPlayer.state.apartmentInstance, placement.model, placement.coords, placement.rotation, durability)
        end
    else
        print('objectPlacement failed or cancelled for model:', model)
        KKF.UI.ShowNotification('Objekti paigutamine ebaõnnestus! Veendu, et oled õiges kohas.', 'error')
    end
end)

RegisterCommand('testprop', function(source, args, rawCommand)
    local model = 'hei_prop_carrier_cargo_05a_s'
    local propertyId = 2 -- Replace with your property ID (e.g., "Test House")
    local coords = GetEntityCoords(cache.ped) -- Use current player position
    local rotation = {x = 0.0, y = 0.0, z = GetEntityHeading(cache.ped)} -- Use player heading for rotation
    local durability = 100

    print('Executing /testprop - Model:', model, 'Property ID:', propertyId, 'Coords:', json.encode(coords), 'Rotation:', json.encode(rotation), 'Durability:', durability)

    -- Simulate permission check
    local property = getPropertyFromId(propertyId)
    if not locations[property] or not (canEditProperty(locations[property]) or hasPropertyKeys(locations[property].id)) then
        print('No permission for property ID:', propertyId)
        KKF.UI.ShowNotification('Sa ei saa seda eset siia maha panna!', 'error')
        return
    end

    -- Trigger server event directly
    TriggerServerEvent('kk-properties2:server:placeSpawnedObject', propertyId, model, coords, rotation, durability)
    print('Server event triggered for property ID:', propertyId)
end, false)

-- Update crypto
RegisterNetEvent('kk-properties2:client:updateCrypto')
AddEventHandler('kk-properties2:client:updateCrypto', function(id, count)
    local property = getPropertyFromId(id)
    if locations[property] and currentProperty == locations[property].id then
        SendNUIMessage({ action = 'updateCrypto', data = { crypto = tostring(count) } })
    end
end)

-- Update prop durability
RegisterNetEvent('kk-properties2:client:updatePropDurability')
AddEventHandler('kk-properties2:client:updatePropDurability', function(propertyId, permanentId, dura)
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

-- Remove prop
RegisterNetEvent('kk-properties2:client:removeProp')
AddEventHandler('kk-properties2:client:removeProp', function(propertyId, permanentId)
    local property = getPropertyFromId(propertyId)
    if locations[property] then
        for k, v in pairs(locations[property].props) do
            if v.permanentId == permanentId then
                if v.object and DoesEntityExist(v.object) then
                    exports.ox_target:removeLocalEntity(v.object, { 'property_placeable', 'property_stash', 'property_placeable_2' })
                    DeleteObject(v.object)
                end
                table.remove(locations[property].props, k)
                break
            end
        end
    end
end)

-- Property seller ped
local point = nil
local entity = nil

CreateThread(function()
    while not ESX.GetPlayerData().identifier do
        Wait(500)
    end

    exports['kk-scripts']:requestModel(`a_m_m_business_01`)
    entity = CreatePed(4, `a_m_m_business_01`, cfg.sellPed.x, cfg.sellPed.y, cfg.sellPed.z - 1, cfg.sellPed.w or 0, false, false)
    SetBlockingOfNonTemporaryEvents(entity, true)
    SetPedDiesWhenInjured(entity, false)
    SetPedCanPlayAmbientAnims(entity, true)
    SetPedCanRagdollFromPlayerImpact(entity, false)
    SetEntityInvincible(entity, true)
    FreezeEntityPosition(entity, true)

    local blip = AddBlipForCoord(cfg.sellPed.x, cfg.sellPed.y, cfg.sellPed.z)
    SetBlipSprite(blip, 525)
    SetBlipColour(blip, 5)
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Maakler')
    EndTextCommandSetBlipName(blip)

    point = lib.points.new({ coords = GetEntityCoords(entity), distance = 2 })
    function point:onEnter()
        exports['rm_dialognpc']:createDialog(entity, {
            pedModel = `a_m_m_business_01`,
            pedName = "Maakler",
            title = 'Olete äkki huvitatud kinnisvara rentimisest?',
            coords = { { coords = GetEntityCoords(entity) } },
            buttons = {
                { title = "Jah, ikka", event = "kk-properties2:client:buyProperty", icon = "fa-solid fa-thumbs-up" },
                { title = "Ei, tänan", icon = "fa-solid fa-ban" }
            }
        }, 'Müük')
    end
end)

-- Open property shop
local shopOpen = false
RegisterNetEvent('kk-properties2:client:buyProperty')
AddEventHandler('kk-properties2:client:buyProperty', function()
    shopOpen = true
    SendNUIMessage({ action = 'openShop', data = lib.callback.await('kk-properties2:fetchBuyable', false) })
    SetNuiFocus(true, true)
    CreateThread(function()
        while shopOpen do
            InvalidateIdleCam()
            InvalidateVehicleIdleCam()
            Wait(1000)
        end
    end)
end)

RegisterNUICallback('closeShop', function(args, cb)
    shopOpen = false
    SendNUIMessage({ action = 'closeShop' })
    SetNuiFocus(false, false)
    cb('done')
end)

RegisterNUICallback('buyProperty', function(data, cb)
    lib.callback('kk-properties2:buyProperty', false, function(response)
        cb(response)
    end, data.id)
end)

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() and DoesEntityExist(entity) then
        DeleteEntity(entity)
        entity = nil
        RemoveBlip(GetBlipFromEntity('p_seller')) -- Remove seller blip
    end
end)