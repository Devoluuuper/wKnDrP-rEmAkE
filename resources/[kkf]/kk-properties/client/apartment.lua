local point = lib.points.new(vec3(-270.95, -957.86, 31.22), 3.0, {})
local ox_inventory = exports.ox_inventory
local currentApartment = 0
local data = {
    interior = vec3(266.117, -1007.388, -102.009)
}

SetInterval(function()
	if currentApartment ~= 0 then
		if IsPedDeadOrDying(cache.ped, 1) then
            TriggerEvent('kk-apartments:client:leave')
		end
	end
end, 5000)

function point:onEnter()
    ESX.ShowInteraction('Sisene korterisse', 'E')
end

function point:onExit()
    ESX.HideInteraction()
end

function point:nearby()
    if self.currentDistance < 3.0 and IsControlJustReleased(0, 38) then
        if LocalPlayer.state['isLoggedIn'] then
            lib.registerContext({
                id = 'apartment_menu',
                title = 'Korter',
                options = {
                    {
                        title = 'Sisene oma korterisse',
                        description = '',
                        event = 'kk-apartments:client:enterOwn'
                    },
                    {
                        title = 'Sisene teise inimese korterisse',
                        description = '',
                        arrow = true,
                        event = 'kk-apartments:client:visit'
                    }
                },
            })

            lib.showContext('apartment_menu')
        end
    end
end

RegisterNetEvent('kk-apartments:client:enterOwn', function(first)
    SetTimeout(2000, function()
        TriggerEvent('kk-scripts:client:reloadWeapons')
    end)
    TriggerEvent('InteractSound_CL:PlayOnOne', 'DoorOpen', 0.7)
    Wait(500)
    TriggerEvent('InteractSound_CL:PlayOnOne', 'DoorClose', 0.7)
    if not first then SetEntityCoords(cache.ped, data.interior) end; currentApartment = ESX.PlayerData.identifier
    TriggerServerEvent('kk-properties:server:routingBucket', true)
    TriggerEvent('cd_easytime:PauseSync', true)
end)

RegisterNetEvent('kk-apartments:client:leave', function()
    TriggerEvent('InteractSound_CL:PlayOnOne', 'DoorOpen', 0.7)
    Wait(500)
    TriggerEvent('InteractSound_CL:PlayOnOne', 'DoorClose', 0.7)
    SetEntityCoords(cache.ped, vec3(-270.95, -957.86, 31.22)); currentApartment = 0
    TriggerServerEvent('kk-properties:server:routingBucket', false)
    TriggerEvent('cd_easytime:PauseSync', false)
    Wait(500)
    SetTimeout(2000, function()
        TriggerEvent('kk-scripts:client:reloadWeapons')
    end)
end)

RegisterNetEvent('kk-apartments:client:visit', function()
    local input = lib.inputDialog('Korteri külastamine', {'Sõbra isikukood'})

    if input then
        local pid = tonumber(input[1])
        
        TriggerServerEvent('kk-apartments:server:askPermission', pid)
    end
end)

RegisterNetEvent('kk-apartments:client:acceptForm', function(data)
    if currentApartment == ESX.PlayerData.identifier then
        local alert = lib.alertDialog({
            header = 'Majahoidja',
            content = 'Kas soovite lasta ' .. data.name .. ' enda korterisse?',
            centered = true,
            cancel = true
        })

        TriggerServerEvent('kk-apartments:server:acceptResponse', data.id, alert)
    end
end)

RegisterNetEvent('kk-properties:client:openStash', function()
    TriggerEvent('InteractSound_CL:PlayOnOne', 'stash', 0.4)

    ox_inventory:openInventory('stash', 'apartment' .. currentApartment)
end)

RegisterNetEvent('kk-properties:client:openStash:high', function()
    TriggerEvent('InteractSound_CL:PlayOnOne', 'stash', 0.4)
    
    ox_inventory:openInventory('stash', 'apartment' .. currentApartment .. 'high')
end)

RegisterNetEvent('kk-apartments:client:enterApartment', function(id)
    currentApartment = id; TriggerServerEvent('kk-properties:server:routingBucket', true, id)
end) 

RegisterNetEvent('kk-apartments:client:recTier', function(response)
    if response then
        data.interior = vec3(response.x, response.y, response.z)
    end
end)

RegisterNetEvent('KKF.Player.Loaded', function(xPlayer)
    ESX.CreateBlip('apartments', vec3(-270.95, -957.86, 31.22), 'Korter', 475, nil, 0.7)

    TriggerServerEvent('kk-apartments:server:getHouseData')
end)

RegisterNetEvent('KKF.Player.Unloaded', function()
    data.interior = vec3(266.117, -1007.388, -102.009)
end)

RegisterNetEvent('kk-apartments:client:getHouseData', function()
    TriggerServerEvent('kk-apartments:server:getHouseData')
end)