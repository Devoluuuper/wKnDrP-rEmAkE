local ox_inventory = exports.ox_inventory
local localCache = nil
local isInside = false

local radioChannel = GetHashKey('burgershot_radio')

CreateThread(function()
    KKF.PlayerData = KKF.GetPlayerData()

    KKF.CreateBlip('burgershot', cfg.position, 'Burgershot', 106, 46, 0.7)

    for i = 1, #cfg.callZones do
        lib.zones.box({
            coords = cfg.callZones[i].coords,
            size = cfg.callZones[i].size,
            rotation = cfg.callZones[i].rotation,
            debug = false,
    
            onEnter = function()
                exports['pma-voice']:setVoiceProperty('radioEnabled', true)
    
                if LocalPlayer.state.radioChannel then
                    localCache = LocalPlayer.state.radioChannel
                end
    
                exports['pma-voice']:setRadioChannel(radioChannel)
            end,
    
            onExit = function()
                exports['pma-voice']:setVoiceProperty('radioEnabled', false)
                exports['pma-voice']:setRadioChannel(0)

                if localCache then
                    exports['pma-voice']:setVoiceProperty('radioEnabled', true)
                    exports['pma-voice']:setRadioChannel(localCache)
                    localCache = nil
                end
            end
        })
    end
end)

RegisterNetEvent('KKF.Player.Loaded', function(playerData)
	KKF.PlayerData = playerData
end)

RegisterNetEvent('KKF.Player.Unloaded', function() 
	KKF.PlayerData = {}
end)

RegisterNetEvent('KKF.Player.JobUpdate', function(job)
	KKF.PlayerData.job = job
end)

RegisterNetEvent('KKF.Player.DutyChange', function(value)
	KKF.PlayerData.job.onDuty = value
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
                    return v.type == 'plate' or (KKF.PlayerData.job.name == 'burgershot' and (KKF.PlayerData.job.onDuty or v.type == 'duty'))
                end,

                onSelect = function()
                    if v.type == 'clothes' then
                        TriggerEvent('wardrobe:clothingShop')
                    elseif v.type == 'duty' then
                        TriggerServerEvent('kk-scripts:server:toggleDuty')
                    elseif v.type == 'plate' then
                        ox_inventory:openInventory('stash', { id = 'burgershot_tray_' .. k, owner = false })
                    else
                        exports['kk-crafting']:openCraftMenu('burgershot_' .. v.type)
                    end
                end
            }
        }
    })
end