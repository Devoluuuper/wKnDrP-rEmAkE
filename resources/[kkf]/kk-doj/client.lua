local ox_inventory = exports.ox_inventory

RegisterNetEvent('KKF.Player.Loaded', function(xPlayer)
    ESX.PlayerData = xPlayer; ESX.CreateBlip('doj', vec3(-542.35, -197.16, 38.24), 'Linnavalitsus', 182, 2, 0.7, 0)
end)

RegisterNetEvent('KKF.Player.Unloaded', function()
	ESX.PlayerData = {}; ESX.RemoveBlip('doj')
end)

RegisterNetEvent('KKF.Player.DutyChange', function(value)
	ESX.PlayerData.job.onDuty = value
end)

for k,v in pairs(cfg.locations) do
    local point = lib.points.new(v.pos, 2.0)
    
    function point:onEnter()
        if ESX.PlayerData.job.name == 'doj' then
            ESX.ShowInteraction(v.text)
        end
    end
    
    function point:onExit()
        if ESX.PlayerData.job.name == 'doj' then
            ESX.HideInteraction(); exports['kk-police']:setIsInv(false)
        end
    end
    
    function point:nearby()
        if self.currentDistance < 2.0 and IsControlJustReleased(0, 38) then
            if ESX.PlayerData.job.name == 'doj' then
                if k == 'stash' and ESX.PlayerData.job.onDuty and ESX.PlayerData.job.properties.stash then
                    if ESX.PlayerData.job.permissions.stash then
                        ox_inventory:openInventory('stash', ESX.PlayerData.job.name)
                    else
                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil puudub ligipääs fraktsiooni seifile.')
                    end
                elseif k == 'buy' then
                    if ESX.PlayerData.job.permissions.leaderMenu then
                        TriggerEvent('kk-police:client:shop')
                    else
                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil puudub ligipääs relvaostule.')
                    end
                elseif k == 'duty' then
                    TriggerServerEvent('kk-scripts:server:toggleDuty')
                else
                    TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ei saa seda tegevust sooritada olles off duty.')
                end
            end
        end
    end
end