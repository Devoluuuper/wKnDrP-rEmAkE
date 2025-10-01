local framework = 'QBCORE'
local itemNames = {}

CreateThread(function()
    if GetResourceState('qb-core') == 'starting' or GetResourceState('qb-core') == 'started' then
        framework = 'QBCORE'
    elseif GetResourceState('kk-core') == 'starting' or GetResourceState('kk-core') == 'started' then
        framework = 'ESX'
    end
end)

CreateThread(function()
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
                if item == 'bank' or item == 'money' then
                    Player.Functions.AddMoney(item == 'money' and 'cash' or 'bank', tonumber(count))
                else
                    exports.ox_inventory:AddItem(source, item, count)
                end
            end
        end

        function removeItem(source, item, count, metadata)
            exports.ox_inventory:RemoveItem(source, item, count, metadata)
        end

        function getItemSlots(source, itemTable, metadata)
            return exports.ox_inventory:GetItemSlots(source, itemTable, metadata)
        end

        function showNotification(source, type, msg)
            TriggerClientEvent('KKF.UI.ShowNotification', source, msg, type or 'info')
        end

        function sendLog(identifier, message)
            exports['kk-scripts']:sendLog(identifier, 'MUU', message)
        end

        function itemLabel(item)
            return itemNames[item] or item
        end

    elseif framework == 'ESX' then
        ESX = exports['kk-core']:getSharedObject()

        for item, data in pairs(exports.ox_inventory:Items()) do
            itemNames[item] = data.label
        end

        function getPlayerFromId(source)
            local xPlayer = ESX.GetPlayerFromId(source)
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
            local xPlayer = ESX.GetPlayerFromId(source)
            if xPlayer then
                if item == 'bank' then
                    xPlayer.addAccountMoney('bank', tonumber(count))
                elseif item == 'money' then
                    xPlayer.addMoney(tonumber(count))
                else
                    exports.ox_inventory:AddItem(source, item, count)
                end
            end
        end

        function removeItem(source, item, count, metadata)
            exports.ox_inventory:RemoveItem(source, item, count, metadata)
        end

        function getItemSlots(source, itemTable, metadata)
            return exports.ox_inventory:GetItemSlots(source, itemTable, metadata)
        end

        function showNotification(source, type, msg)
            TriggerClientEvent('KKF.UI.ShowNotification', source, msg, type or 'info')
        end

        function sendLog(identifier, message)
            exports['kk-scripts']:sendLog(identifier, 'MUU', message)
        end

        function itemLabel(item)
            return itemNames[item] or item
        end
    end
end)
