local targets, itemNames = {}, {}
local ox_target = exports.ox_target

local function unloadTargets()
    for k,v in pairs(targets) do
        ox_target:removeZone(v); targets[k] = nil
    end
end

local function loadTargets()
    for k,v in pairs(targets) do
        ox_target:removeZone(v); targets[k] = nil
    end

    for k,v in pairs(cfg.craftingPoints) do
        targets[#targets + 1] = ox_target:addBoxZone({
            coords = v.coords,
            size = v.size,
            rotation = v.heading,
            debug = false,
            options = {
                {
                    icon = v.icon,
                    label = v.text,
                    distance = 1.5,
    
                    onSelect = function(args)
                        exports['kk-crafting']:openCraftMenu(v.craftingPoint)
                    end
                }
            }
        })
    end

    for k,v in pairs(cfg.shops) do
        KKF.CreateBlip('cloth_job' .. k, v.target.coords, 'Riiete müük', 73, 1, 0.4)

        targets[#targets + 1] = ox_target:addBoxZone({
            coords = v.target.coords,
            size = v.target.size,
            rotation = v.target.heading,
            debug = false,
            options = {
                {
                    icon = 'fa-solid fa-money-bill',
                    label = 'Müü kaupa',
                    distance = 1.5,
    
                    onSelect = function(args)
                        TriggerServerEvent('kk-clotheshop:server:sellStuff', k)
                    end
                }
            }
        })
    end
end

CreateThread(function()
    loadTargets()

    for item, data in pairs(exports.ox_inventory:Items()) do 
        itemNames[item] = data.label
    end
end)

RegisterNetEvent('KKF.Player.Loaded', function(playerData)
    loadTargets()
end)

RegisterNetEvent('KKF.Player.Unloaded', function()
    unloadTargets()
end)