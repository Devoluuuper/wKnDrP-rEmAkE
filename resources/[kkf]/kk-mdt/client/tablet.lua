canJail = false
local cachedDamages = {}

exports('canJail', function()
    return canJail
end)

TriggerEvent('chat:addSuggestion', '/giveLicense', 'Isikule litsentsi andmine.', {
    { name = 'state id'},
	{ name = 'name'}
}) 

CreateThread(function()
	KKF.PlayerData = KKF.GetPlayerData()
end)

RegisterNetEvent('KKF.Player.JobUpdate', function(job)
	KKF.PlayerData.job = job
end)

RegisterNetEvent('KKF.Player.DutyChange', function(value) 
    KKF.PlayerData.job.onDuty = value 
end)

RegisterNetEvent('KKF.Player.Loaded', function(xPlayer)
	KKF.PlayerData = xPlayer
end)

RegisterNetEvent('KKF.Player.Unloaded', function() 
	KKF.PlayerData = {}
end)

RegisterNetEvent('kk-mdt:client:openMenu', function()
    if (KKF.PlayerData.job.name == 'police' or KKF.PlayerData.job.name == 'ambulance') and KKF.PlayerData.job.onDuty then
        SendNUIMessage({action = 'open', data = {translate = {}, punishments = cfg.punishments, permissions = KKF.PlayerData.job.permissions, name = KKF.PlayerData.name, job = KKF.PlayerData.job.name, department = lib.callback.await('kk-mdt:requestDepartment', false).myDepartment}}); SetNuiFocus(true, true); exports['kk-scripts']:toggleTab(true)
    end
end)

RegisterNUICallback('closeTablet', function()
    SendNUIMessage({action = 'close'}); SetNuiFocus(false, false); exports['kk-scripts']:toggleTab(false)
end)

RegisterNUICallback('search', function(args, cb)
    lib.callback('kk-mdt:search', false, function(response)
        cb(response)
    end, args.value)
end) 

RegisterNUICallback('searchCandidations', function(args, cb)
    lib.callback('kk-mdt:searchCandidations', false, function(response)
        cb(response)
    end, args.value)
end)

RegisterNUICallback('searchStatements', function(args, cb)
    lib.callback('kk-mdt:searchStatements', false, function(response)
        cb(response)
    end, args.value)
end)

RegisterNUICallback('searchDepartmentMembers', function(args, cb)
    lib.callback('kk-mdt:searchDepartmentMembers', false, function(response)
        cb(response)
    end, args.value)
end)

RegisterNUICallback('searchVehicles', function(args, cb)
    lib.callback('kk-mdt:searchVehicles', false, function(response)
        for k,v in pairs(response) do
            response[k].vehicle.model = GetLabelText(GetDisplayNameFromVehicleModel(response[k].vehicle.model))
        end

        cb(response)
    end, args.value)
end)

RegisterNUICallback('loadVehicleProfile', function(args, cb)
    lib.callback('kk-mdt:loadVehicleProfile', false, function(response)
        response.vehicle.model = GetLabelText(GetDisplayNameFromVehicleModel(response.vehicle.model))

        cb(response)
    end, args.plate)
end)   

RegisterNUICallback('buyBadge', function(args, cb)
    lib.callback('kk-mdt:buyBadge', false, function(response)
        cb(response)
    end, args.worker)
end) 

RegisterNUICallback('saveWorkerProfile', function(args, cb)
    lib.callback('kk-mdt:saveWorkerProfile', false, function(response)
        cb(response)
    end, args.id, args.department, args.callsign)
end) 

RegisterNUICallback('addDepartmentButton', function(args, cb)
    lib.callback('kk-mdt:addDepartmentButton', false, function(response)
        cb(response)
    end)
end) 

RegisterNUICallback('toggleCertificate', function(args, cb)
    lib.callback('kk-mdt:toggleCertificate', false, function(response)
        cb(response)
    end, args.worker, args.cert)
end)

RegisterNUICallback('loadWorkerProfile', function(args, cb)
    lib.callback('kk-mdt:loadWorkerProfile', false, function(response)
        cb(response)
    end, args.worker)
end) 

RegisterNUICallback('loadCandidation', function(args, cb)
    lib.callback('kk-mdt:loadCandidation', false, function(response)
        if response then
            cb(response)
        else
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Antud avaldust ei eksisteeri enam!')
            cb(false)
        end
    end, args.value) 
end)

RegisterNUICallback('loadStatement', function(args, cb)
    lib.callback('kk-mdt:loadStatement', false, function(response)
        if response then
            cb(response)
        else
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Antud avaldust ei eksisteeri enam!')
            cb(false)
        end
    end, args.value) 
end)

RegisterNUICallback('removeCandidation', function(args, cb)
    lib.callback('kk-mdt:removeCandidation', false, function(response)
        cb(response)
    end, args.value)
end)

RegisterNUICallback('removeStatement', function(args, cb)
    lib.callback('kk-mdt:removeStatement', false, function(response)
        cb(response)
    end, args.value)
end)

RegisterNUICallback('loadProfile', function(args, cb)
    lib.callback('kk-mdt:loadProfile', false, function(response)
        if response then
            if response['licenses'] and type(response['licenses']) == 'string' then
                response['licenses'] = json.decode(response['licenses'])
            end

            if response['vehicles'] then
                for k,v in pairs(response['vehicles']) do
                    if v.vehicle and type(v.vehicle) == 'string' then
                        local vehicle = json.decode(v.vehicle)
                        response['vehicles'][k].label = GetLabelText(GetDisplayNameFromVehicleModel(vehicle.model))
                    end
                end
            end

            cb(response)
        else
            cb(false)
        end
    end, args.value)
end)


RegisterNUICallback('updateWantedVehicle', function(args, cb)
    lib.callback('kk-mdt:updateWantedVehicle', false, function(response)
        cb(response)
    end, args.plate, args.value)
end)

RegisterNUICallback('updateWantedProfile', function(args, cb)
    lib.callback('kk-mdt:updateWantedProfile', false, function(response)
        cb(response)
    end, args.plate, args.value)
end)

RegisterNUICallback('saveNotes', function(args, cb)
    lib.callback('kk-mdt:saveNotes', false, function(response)
        cb(response)
    end, args.pid, args.value)
end)

RegisterNUICallback('removeLicense', function(args, cb)
    lib.callback('kk-mdt:removeLicense', false, function(response)
        cb(response)
    end, args.target, args.license)
end) 

RegisterNUICallback('createDiagnose', function(args, cb)
    if (tonumber(args.intensive) > 0 and inIntensive) or (tonumber(args.intensive) == 0 and (not inIntensive or inIntensive)) then
        lib.callback('kk-mdt:createDiagnose', false, function(response)
            cb(response)
        end, args.target, args.description, args.done, args.damages, args.bill, args.intensive, args.prescriptions)
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Intensiivi saatmiseks peate olema vastavas tsoonis!')
        cb(false)
    end
end)

RegisterNUICallback('createCase', function(args, cb)
    if (tonumber(args.jail) > 0 and (canJail or exports['kk-jail']:inPrison())) or (tonumber(args.jail) == 0 and (not (canJail or exports['kk-jail']:inPrison()) or (canJail or exports['kk-jail']:inPrison()))) then
        lib.callback('kk-mdt:createCase', false, function(response)
            cb(response)
        end, args.target, args.description, args.fine, args.jail, args.punishments, args.strikePoints)
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Vanglasse saatmiseks peate olema vastavas tsoonis!')
        cb(false)
    end
end)

RegisterNUICallback('loadStaffPage', function(args, cb)
    lib.callback('kk-mdt:loadStaffPage', false, function(response)
        cb(response)
    end)
end) 

RegisterNUICallback('loadDepartment', function(args, cb)
    lib.callback('kk-mdt:loadDepartment', false, function(response)
        cb(response)
    end, args.department)
end) 

RegisterNUICallback('saveDepartment', function(args, cb)
    lib.callback('kk-mdt:saveDepartment', false, function(response)
        cb(response)
    end, args.id, args.label, args.blip_color, args.logo)
end)

RegisterNUICallback('deleteDepartment', function(args, cb)
    lib.callback('kk-mdt:deleteDepartment', false, function(response)
        cb(response)
    end, args.id)
end)

RegisterNUICallback('niceBehaviorAccept', function(args, cb)
    if canJail or exports['kk-jail']:inPrison() then
        lib.callback('kk-mdt:niceBehaviorAccept', false, function(response)
            cb(response)
        end, args.id, args.desc, args.value, args.name)
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Selle tegevuse jaoks peate olema vangla territooriumil!')
    end
end)

RegisterNUICallback('diplaAccept', function(args, cb)
    if canJail or exports['kk-jail']:inPrison() then
        lib.callback('kk-mdt:diplaAccept', false, function(response)
            cb(response)
        end, args.id, args.desc, args.value, args.name)
    else
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Selle tegevuse jaoks peate olema vangla territooriumil!')
    end
end)

RegisterNUICallback('refreshDocPage', function(args, cb)
    lib.callback('kk-mdt:refreshDocPage', false, function(response)
        cb(response)
    end)
end)

RegisterNUICallback('setPage', function(args, cb)
    SendNUIMessage({action = 'setPage', page = args.page}); cb('1')
end)

RegisterNUICallback('loadDamages', function(args, cb)
    if #cachedDamages > 0 then
        local data = {}

        for k,v in pairs(cachedDamages) do
            if #v.damages > 0 then
                for k2,v2 in pairs(v.damages) do
                    data[#data + 1] = { name = v.body, type = v2.damage_type}
                end
            end
        end

        cb(data)
    else
        cb(false)
    end
end)

exports('cacheDamages', function(val)
	cachedDamages = val
end)

for k,v in pairs(cfg.intensives) do
    lib.zones.box({
        coords = v.coords,
        size = v.size,
        rotation = v.rotation,
        debug = false,
        onEnter = function()
            inIntensive = true
        end,
        onExit = function()
            inIntensive = false
        end
    })
end

for k,v in pairs(cfg.cellBlocks) do
    lib.zones.box({
        coords = v.coords,
        size = v.size,
        rotation = v.rotation,
        debug = false,
        onEnter = function()
            canJail = true
        end,
        onExit = function()
            canJail = false
        end
    })
end

RegisterNUICallback('profileImage', function(args, cb)
    --if canJail then
        lib.callback('kk-mdt:profileImage', false, function(response)
            if response then
                TriggerEvent('kk-police:client:openCamera', args.pid)
            end

            cb(response)
        end, args.pid)
    --else
    --    TriggerEvent('KKF.UI.ShowNotification', 'error', 'Pildi muutmiseks peate olema vastavas tsoonis!')
    --    cb(false)
    --end 
end) 