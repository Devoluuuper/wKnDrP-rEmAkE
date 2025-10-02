local lastPoint = nil
local isWorking = false
local currentPoint = nil

local jobBlip = nil

marker = {r = 0, g = 0, b = 100, x = 1.5, y = 1.5, z = 0.5}

local function isCleaning()
    return isWorking
end

exports('isCleaning', isCleaning)

local function createBlip(location)
    RemoveBlip(jobBlip)
	jobBlip = AddBlipForCoord(cfg.workingPoints[location].x, cfg.workingPoints[location].y, cfg.workingPoints[location].z)
	
	SetBlipSprite (jobBlip, 1)
	SetBlipDisplay(jobBlip, 4)
	SetBlipScale  (jobBlip, 0.7)
	SetBlipColour (jobBlip, 46)
	SetBlipAsShortRange(jobBlip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Töökoht")
	EndTextCommandSetBlipName(jobBlip)
end

local cleanTimeout = false
local doneCount = 0

local function createPoint(location)
    TriggerEvent('KKF.UI.ShowNotification', 'info', 'Uus punkt on märgitud kaardil.')

    if currentPoint then
        currentPoint:remove();
    end

    createBlip(location)
    
    local point = lib.points.new(vec3(cfg.workingPoints[location].x, cfg.workingPoints[location].y, cfg.workingPoints[location].z), 5.0, { position = vec3(cfg.workingPoints[location].x, cfg.workingPoints[location].y, cfg.workingPoints[location].z)})
     
    function point:nearby()
        DrawMarker(2, self.position, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 30, 30, 150, 222, false, false, 0, true, false, false, false)	
     
        if self.currentDistance < 1 then
            if IsControlJustReleased(0, 38) then
                if not cleanTimeout then
                    cleanTimeout = true

                    local object = exports['kk-scripts']:spawnAttachedObject(cache.ped, joaat('prop_tool_broom'), 28422, -0.005, 0.0, 0.0, 360.0, 360.0, 0.0)
                    local progress = exports['kk-taskbar']:startAction('cleaning', 'Koristad...', 10000, 'idle_a', 'amb@world_human_janitor@male@idle_a', {freeze = true, controls = true})

                    if progress then
                        doneCount += 1

                        if doneCount >= 4 then
                            lib.callback.await('kk-jail:reduceSentence', false)
                            doneCount = 0
                        end

                        currentPoint:remove();

                        if isWorking then
                            for i = 1, #cfg.workingPoints do
                                if lastPoint ~= i then
                                    lastPoint = i
                                    createPoint(lastPoint)
                    
                                    break
                                end
                            end
                        end
                    end

                    Sync.DeleteEntity(object);

                    SetTimeout(2000, function()
                        cleanTimeout = false
                    end)
                end
            end
        end
    end

    currentPoint = point
end

RegisterNetEvent('kk-jail:client:startWorking', function()
    if not isWorking then
        TriggerEvent('KKF.UI.ShowNotification', 'info', 'Alustasite tööd! Asukoht on märgitud kaardil.')
        isWorking = true

        for i = 1, #cfg.workingPoints do
            if lastPoint == nil then
                lastPoint = i
                createPoint(lastPoint)

                break
            end

            if lastPoint ~= i then
                lastPoint = i
                createPoint(lastPoint)

                break
            end
        end
    end
end)

RegisterNetEvent('kk-jail:client:endCleaning', function()
    if isWorking then
        TriggerEvent('KKF.UI.ShowNotification', 'info', 'Töö lõpetatud!')
        currentPoint:remove();
        RemoveBlip(jobBlip);
        isWorking = false;
    end
end)