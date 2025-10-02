local framework = 'QBCORE'
local itemNames = {}

CreateThread(function()
    if GetResourceState('qb-core') == 'starting' or GetResourceState('qb-core') == 'started' then
        framework = 'QBCORE'
    elseif GetResourceState('kk-core') == 'starting' or GetResourceState('kk-core') == 'started' then
        framework = 'KKF'
    end
end)

CreateThread(function()
    -- QBCORE
    if framework == 'QBCORE' then
        QBCore = exports['qb-core']:GetCoreObject()

        for item, data in pairs(exports.ox_inventory:Items()) do
            itemNames[item] = data.label
        end

        function getPlayerFromId(source)
            local Player = QBCore.Functions.GetPlayer(source)
            if Player then
                return { 
                    source = Player.PlayerData.source, 
                    identifier = Player.PlayerData.citizenid 
                }
            end
            return nil
        end

        function getItem(source, item)
            return exports.ox_inventory:GetItem(source, item)
        end

        function addItem(source, item, count)
            local Player = QBCore.Functions.GetPlayer(source)
            if Player then
                exports.ox_inventory:AddItem(source, item, count)
            end
        end

        function removeItem(source, item, count)
            exports.ox_inventory:RemoveItem(source, item, count)
        end

        function showNotification(source, type, msg)
            TriggerEvent('KKF.UI.ShowNotification', source, type or 'info', msg)
        end

        function itemLabel(item)
            return itemNames[item] or item
        end

    -- KKF
    elseif framework == 'KKF' then
        KKF = exports['kk-core']:getSharedObject()

        for item, data in pairs(exports.ox_inventory:Items()) do
            itemNames[item] = data.label
        end

        function getPlayerFromId(source)
            local xPlayer = KKF.GetPlayerFromId(source)
            if xPlayer then
                return { 
                    source = source, 
                    identifier = xPlayer.getIdentifier() 
                }
            end
            return nil
        end

        function getItem(source, item)
            return exports.ox_inventory:GetItem(source, item)
        end

        function addItem(source, item, count)
            local xPlayer = KKF.GetPlayerFromId(source)
            if xPlayer then
                exports.ox_inventory:AddItem(source, item, count)
            end
        end

        function removeItem(source, item, count)
            exports.ox_inventory:RemoveItem(source, item, count)
        end

        function showNotification(source, type, msg)
            TriggerEvent('KKF.UI.ShowNotification', source, type or 'info', msg)
        end

        function itemLabel(item)
            return itemNames[item] or item
        end
    end
end)
