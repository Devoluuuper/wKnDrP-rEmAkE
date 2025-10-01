local isBusy, timeoutA, itemNames, currentBench = false, 0, {}, nil

local function getItemData(itemId)
    local response = nil

    for k,v in pairs(Config.Items) do
        if k == itemId then
            response = v
        end
    end

    return response
end

CreateThread(function()
    ESX.PlayerData = ESX.GetPlayerData()

    for item, data in pairs(exports.ox_inventory:Items()) do 
        itemNames[item] = {
            name = data.label,
            description = data.description
        }
    end
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

RegisterNUICallback('close', function(args, cb)
    cb('1')

    SetNuiFocus(false, false); SendNUIMessage({action = 'close'})
end)

CreateThread(function()
    while true do
        if timeoutA > 0 then
            timeoutA = timeoutA - 1
        end

        Wait(60000)
    end
end)

local function isInTable(itemId, bench)
    local returnable = false

    for k,v in pairs(Config.Items[itemId].tables) do
        if v == bench then
            returnable = true
        end
    end

    return returnable
end

local function randomString(v)
	local length = math.random(10,v)
	local array = {}
	for i = 1, length do
		array[i] = string.char(math.random(55, 123))
	end
	return table.concat(array)
end

local function openCraftMenu(bench)
    local menu = {}

    if not cache.vehicle and not isBusy then
        currentBench = bench

        lib.callback('kk-skills:requestSkill', false, function(levelList)
            for index, value in pairs(Config.Items) do
                if isInTable(index, bench) then
                    local requirements = {}
    
                    for item, count in pairs(value.needs) do
                        requirements[#requirements + 1] = {
                            label = itemNames[item].name .. ' (' .. count .. 'x)',
                            item = item
                        }
                    end

                    local skip = false

                    if not itemNames[value.item] then
                        print(value.item .. ' 2')
                        skip = true
                    end
    
                    if not skip then
                        menu[index] = {
                            name = itemNames[value.item].name,
                            description = itemNames[value.item].description,
                            requirements = requirements,
                            time = value.progressTime / 1000 .. 's',
                            itemId = value.item,
                            amount = value.amount,
                            skill = value.skill,
                            blurred = (value.skill and levelList[value.skill.name].lvl < value.skill.lvlRequired) or false
                        }
                    end
                else
                    menu[index] = 'none'
                end
            end
    
            SendNUIMessage({action = 'open', data = menu}); SetNuiFocus(true, true)
        end)
    end
end

exports('openCraftMenu', openCraftMenu)

RegisterNUICallback('buildItem', function(args, cb)
    cb('1')

    if timeoutA == 0 then
        local timeToDo = tonumber(args.count)
        if timeToDo == nil then return end

        local closeLoop = false

        for i = 1, timeToDo do
            Wait(100);

            if not closeLoop then
                local result = lib.callback.await('kk-crafting:hasTheItems', false, args.item)
                local currentItemData = getItemData(args.item)

                if result then
                    SetNuiFocus(false, false); SendNUIMessage({action = 'close'})
                    
                    local level = nil

                    if currentItemData.skill then
                        level = lib.callback.await('kk-skills:getLevel', false, currentItemData.skill.name)
                    end

                    if (currentItemData.skill and level >= currentItemData.skill.lvlRequired) or not currentItemData.skill then
                        local currentItemLabel = itemNames[currentItemData.item].name
                        isBusy = true

                        if Config.Sounds[currentBench] then
                            TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 1.5, Config.Sounds[currentBench], 0.1)
                        end
        
                        local progress = exports['kk-taskbar']:startAction('craft', 'Valmistan eset ' .. string.lower(currentItemLabel), currentItemData.progressTime, 'base', 'amb@prop_human_bum_bin@base', {freeze = true, controls = true})

                        if progress then
                            local response = lib.callback.await('kk-crafting:craftingSuccess', false, args.item)
                            
                            if currentItemData.timeout then
                                timeoutA = 3
                            end
    
                            isBusy = false
                        else
                            closeLoop = true
                            isBusy = false
                        end
                    else
                        closeLoop = true
                        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teie kogemus ei vasta nõuetele!')
                    end
                else
                    closeLoop = true
                    TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil ei ole piisavalt materjale!')
                end
            else
                return
            end
        end
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Te ei saa hetkel esemeid teha, oodake ' .. timeoutA ..' minutit!')
    end
end)