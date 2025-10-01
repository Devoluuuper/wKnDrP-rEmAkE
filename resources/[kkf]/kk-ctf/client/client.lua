local isIllegal = false 
local eventStarted = false
local mapOpend = false
local controllers = {
    ['A'] = {
        owner = 'none',
        label = 'Vaba'
    },

    ['B'] = {
        owner = 'none',
        label = 'Vaba'
    },

    ['C'] = {
        owner = 'none',
        label = 'Vaba'
    }
}

if #controllers > 3 then return end 

CreateThread(function()
	while true do
        if IsPauseMenuActive() and not mapOpend then
            mapOpend = true
            SendNUIMessage({action = "hide"});
        elseif not IsPauseMenuActive() and mapOpend then
            mapOpend = false
            SendNUIMessage({action = "show"});
        end

		Wait(800)
	end
end)


local function checkOwned()
    local count = 0

    for k,v in pairs(controllers) do
        if v.owner == ESX.PlayerData.job.name then 
            count = count + 1
        end
    end

    return count
end 

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    for k,v in pairs(cfg.locations) do
        ESX.RemoveBlip('ctf_' .. k)
    end
end)

RegisterNetEvent('KKF.Player.Loaded', function(xPlayer)
    ESX.PlayerData = xPlayer

    Wait(3000)

    lib.callback('kk-ctf:checkIllegal', 500, function(response)
        isIllegal = response

        if eventStarted and isIllegal then
            for k,v in pairs(cfg.locations) do
                ESX.CreateBlip('ctf_' .. k, v.pos, '[' .. k .. '] Hõivamine', v.sprite, 1, 0.5, 0)
            end
        end
    end)
end)

RegisterNetEvent('KKF.Player.Unloaded', function()
	ESX.PlayerData = {}
    isIllegal = false

    for k,v in pairs(cfg.locations) do
        ESX.RemoveBlip('ctf_' .. k)
    end

    SendNUIMessage({action = "hideMenu"}); ESX.HideInteraction()
end)

RegisterNetEvent('KKF.Player.JobUpdate', function(job)
    ESX.PlayerData.job = job

    Wait(3000)

    lib.callback('kk-ctf:checkIllegal', 500, function(response)
        isIllegal = response

        if not isIllegal then
            for k,v in pairs(cfg.locations) do
                ESX.RemoveBlip('ctf_' .. k)
            end

            SendNUIMessage({action = "hideMenu"}); ESX.HideInteraction()
        end

        if eventStarted and isIllegal then
            for k,v in pairs(cfg.locations) do
                ESX.CreateBlip('ctf_' .. k, v.pos, '[' .. k .. '] Hõivamine', v.sprite, 1, 0.5, 0)
            end
        end
    end)
end)

RegisterNetEvent('kk-ctf:client:endCapturing', function(owners)
    SendNUIMessage({action = "hideMenu"}); eventStarted = false

    for k,v in pairs(cfg.locations) do
        ESX.RemoveBlip('ctf_' .. k)
    end

    if not isIllegal then return end

    TriggerEvent('KKF.UI.ShowNotification', 'success', 'Hõivamine on lõppenud!'); Wait(3000)
    TriggerEvent('KKF.UI.ShowNotification', 'ctf', 'Tööstusrajoon [A] on hõivatud: ' .. owners.a .. ' grupeeringu poolt', 7500);
    TriggerEvent('KKF.UI.ShowNotification', 'ctf', 'Stab City [B] on hõivatud: ' .. owners.b .. ' grupeeringu poolt', 7500);
    TriggerEvent('KKF.UI.ShowNotification', 'ctf', 'Davis Quartz [C] on hõivatud: ' .. owners.c .. ' grupeeringu poolt', 7500)
end)

RegisterNetEvent('kk-ctf:client:startCapturing', function()
    if isIllegal then

        TriggerEvent('KKF.UI.ShowNotification', 'ctf', 'Tööstusrajoon [A] on vabanenud grupeeringute mõjust!', 7500); 
        TriggerEvent('KKF.UI.ShowNotification', 'ctf', 'Stab City [B] on vabanenud grupeeringute mõjust!', 7500);
        TriggerEvent('KKF.UI.ShowNotification', 'ctf', 'Davis Quartz [C] on vabanenud grupeeringute mõjust!', 7500)


        for k,v in pairs(cfg.locations) do
            ESX.CreateBlip('ctf_' .. k, v.pos, '[' .. k .. '] Hõivamine', v.sprite, 1, 0.5, 0)
        end
    end

    eventStarted = true
end)

RegisterNetEvent('kk-ctf:client:updateControllers', function(owners)
    controllers = owners

    if isIllegal and eventStarted then
        SendNUIMessage({action = "updateData", controllers = {a = controllers['A'].label, b = controllers['B'].label, c = controllers['C'].label}})
    end
end)

RegisterNetEvent('kk-ctf:client:startUptake', function(point)
    if not eventStarted then return end

    if checkOwned() >= 2 then
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teie grupeering ei saa nii palju punkte hõivata.')
    else
        if controllers[point[1]].owner ~= ESX.PlayerData.job.name then 
            TriggerEvent('KKF.UI.ShowNotification', 'ctf', 'Alustasid punkti hõivamist.')
            
            local progress = exports['kk-taskbar']:startAction('uptake', 'Alustad hõivamist', 70000, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', false, {freeze = true, controls = true})

            if progress then
                lib.callback('kk-ctf:startCapturing', 500, function(response)
                    TriggerEvent('KKF.UI.ShowNotification', 'success', 'Hõivasite punkti ' .. point[1] .. '! Hoidke seda hästi, sest hõivamine ei ole veel läbi.')
                end, point[1])
            end
        else
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Antud punkt on juba teie grupeeringu poolt hõivatud.')
        end
    end 
end)

RegisterNetEvent('kk-ctf:client:openTable', function(name)
    if eventStarted then return end
    exports['kk-crafting']:openCraftMenu('ctf_'..string.lower(name[1]))
end)

local function openMenu(type, name)
    lib.callback('kk-ctf:checkOwner', 500, function(response)
        if response or eventStarted then
            local elements = {}

            if eventStarted then
                elements[#elements + 1] = {
                    title = 'Alusta hõivamist',
                    description = 'Tüüp: ' .. name[2],
                    event = 'kk-ctf:client:startUptake',
                    args = name
                }
            else
                elements[#elements + 1] = {
                    title = 'Ava laud',
                    description = 'Tüüp: ' .. name[2],
                    event = 'kk-ctf:client:openTable',
                    args = name
                }
            end
            
            lib.registerContext({
                id = 'territory_menu',
                title = 'Punkt ' .. name[1],
                options = elements
            })
        
            lib.showContext('territory_menu')
        else
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Antud punkt ei kuulu teile.')
        end
    end, name[1])
end

for k,v in pairs(cfg.locations) do
    local point = lib.points.new(v.pos, v.radius, { type = v.type, name = {k, v.name} })

    function point:onEnter()
        if isIllegal then
            ESX.ShowInteraction('Ava punkt', 'E')

            if eventStarted then 
                SendNUIMessage({action = "showMenu"})
            end
        end
    end
    
    function point:onExit()
        if isIllegal then
            ESX.HideInteraction()

            if eventStarted then
                SendNUIMessage({action = "hideMenu"})
            end
        end
    end
    
    function point:nearby()
        if isIllegal then
            DrawMarker(23, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 6.0, 6.0, 6.0, 20, 20, 200, 50, false, true, 2, nil, nil, false)
        
            if self.currentDistance < 5.0 and IsControlJustReleased(0, 38) then
                openMenu(self.type,self.name)
            end
        end 
    end
end