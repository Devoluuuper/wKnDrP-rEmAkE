local ox_inventory = exports.ox_inventory
local localCache = nil
local isInside = false

local radioChannel = GetHashKey('bean_radio')

CreateThread(function()
    ESX.PlayerData = ESX.GetPlayerData()

    ESX.CreateBlip('bean', cfg.position, 'Bean Machine', 408, 28, 0.7)
end)

RegisterNetEvent('KKF.Player.Loaded', function(playerData)
	ESX.PlayerData = playerData
end)

RegisterNetEvent('KKF.Player.Unloaded', function() 
	ESX.PlayerData = {}
end)

RegisterNetEvent('KKF.Player.JobUpdate', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('KKF.Player.DutyChange', function(value)
	ESX.PlayerData.job.onDuty = value
end)

for k,v in pairs(cfg.points) do
    exports.ox_target:addBoxZone({
        coords = v.target.coords,
        size = v.target.size,
        rotation = v.target.rotation,
        debug = false,
        options = {
            {
                icon = cfg.labels[v.type] and cfg.labels[v.type][1] or '?',
                label = cfg.labels[v.type] and cfg.labels[v.type][2] or '?',
                distance = 1.5,

                canInteract = function()
                    return v.type == 'plate' or (ESX.PlayerData.job.name == 'bean' and (ESX.PlayerData.job.onDuty or v.type == 'duty'))
                end,

                onSelect = function()
                    if v.type == 'clothes' then
                        TriggerEvent('wardrobe:clothingShop')
                    elseif v.type == 'duty' then
                        TriggerServerEvent('kk-scripts:server:toggleDuty')
                    elseif v.type == 'plate' then
                        ox_inventory:openInventory('stash', { id = 'bean_tray_' .. k, owner = false })
                    else
                        exports['kk-crafting']:openCraftMenu('bean_' .. v.type)
                    end
                end
            }
        }
    })
end