RegisterNUICallback('loadCase', function(args, cb)
    lib.callback('kk-mdt:loadCase', false, function(response)
        cb(response)
    end, args.id)
end)

RegisterNUICallback('searchCases', function(args, cb)
    lib.callback('kk-mdt:searchCases', false, function(response)
        cb(response)
    end, args.value)
end)

RegisterNUICallback('createNewCase', function(args, cb)
    lib.callback('kk-mdt:createNewCase', false, function(response)
        cb(response)
    end)
end)

RegisterNUICallback('requestInfo', function(args, cb)
    lib.callback('kk-mdt:requestInfo', false, function(response)
        cb(response)
    end, args.case)
end)

RegisterNUICallback('updateInfo', function(args, cb)
    lib.callback('kk-mdt:updateInfo', false, function(response)
        cb(response)
    end, args.case, args.title, args.description)
end)

RegisterNUICallback('searchCasePlayer', function(data, cb)
    lib.callback('kk-mdt:searchCasePlayer', false, function(response)
        cb(response)
    end, data.search)
end)



RegisterNUICallback('addPersonCase', function(args, cb)
    lib.callback('kk-mdt:addPersonCase', false, function(response)
        cb(response)
    end, args.case, args.identifier, args.type, args.role)
end)

RegisterNUICallback('addDispatchMembers', function(args, cb)
    lib.callback('kk-mdt:addDispatchMembers', false, function(response)
        cb(response)
    end, args.case)
end)

RegisterNUICallback('joinCase', function(args, cb)
    lib.callback('kk-mdt:joinCase', false, function(response)
        cb(response)
    end, args.case)
end)

RegisterNUICallback('removeCaseMember', function(args, cb)
    lib.callback('kk-mdt:removeCaseMember', false, function(response)
        cb(response)
    end, args.case, args.identifier)
end)

RegisterNUICallback('removeCaseOfficer', function(args, cb)
    lib.callback('kk-mdt:removeCaseOfficer', false, function(response)
        cb(response)
    end, args.case, args.identifier)
end)

RegisterNUICallback('requestProtocolData', function(args, cb)
    lib.callback('kk-mdt:requestProtocolData', false, function(response)
        cb(response)
    end, args.case, args.identifier)
end)

RegisterNUICallback('updateProtocolData', function(args, cb)
    lib.callback('kk-mdt:updateProtocolData', false, function(response)
        cb(response)
    end, args.case, args.identifier, args.role, args.punishments, args.fine, args.jail, args.reduction, args.guilt)
end)

RegisterNUICallback('requestOfficerData', function(args, cb)
    lib.callback('kk-mdt:requestOfficerData', false, function(response)
        cb(response)
    end, args.case, args.identifier)
end)

RegisterNUICallback('updateOfficerData', function(args, cb)
    lib.callback('kk-mdt:updateOfficerData', false, function(response)
        cb(response)
    end, args.case, args.identifier, args.role)
end)

RegisterNUICallback('addConfiscatedItem', function(args, cb)
    lib.callback('kk-mdt:addConfiscatedItem', false, function(response)
        cb(response)
    end, args.case, args.identifier, args.item, args.amount)
end)

RegisterNUICallback('removeConfiscatedItem', function(args, cb)
    lib.callback('kk-mdt:removeConfiscatedItem', false, function(response)
        cb(response)
    end, args.case, args.identifier, args.uuid)
end)

RegisterNUICallback('caseFileStatus', function(args, cb)
    lib.callback('kk-mdt:caseFileStatus', false, function(response)
        cb(response)
    end, args.case, args.status)
end)

RegisterNUICallback('confirmPunishment', function(args, cb)
    if args.punishments and #args.punishments == 0 then
        TriggerEvent('KKF.UI.ShowNotification', 'error', 'Karistust ei saa rakendada, kui ühtegi karistust ei ole määratud!')
        cb(false)
        return
    end

    lib.callback('kk-mdt:confirmPunishment', false, function(response)
        if tonumber(args.jail) > 0 then
            -- saadab vanglasse kasutades configi
            exports['kk-jail']:SendToJail(args.identifier, tonumber(args.jail))
        end
        cb(response)
    end, args.case, args.identifier, args.role, args.punishments, args.fine, args.jail, args.reduction, args.faultPoints, args.guilt)
end)



RegisterNUICallback('addVehicleItem', function(args, cb)
    lib.callback('kk-mdt:addVehicleItem', false, function(response)
        cb(response)
    end, args.case, args.vehicle, args.plate)
end)

RegisterNUICallback('removeVehicleItem', function(args, cb)
    lib.callback('kk-mdt:removeVehicleItem', false, function(response)
        cb(response)
    end, args.case, args.uuid)
end)

RegisterNUICallback('doesVehicleExist', function(args, cb)
    lib.callback('kk-mdt:doesVehicleExist', false, function(response)
        if not response then
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Antud sõidukit ei eksisteeri andmebaasis!')  
        end
        
        cb(response)
    end, args.plate)
end)

RegisterNUICallback('policeCaseDelete', function(args, cb)
    local confirmed = lib.alertDialog({
        header = 'Juhtumi kustutamine',
        content = 'Väärtuslik teave võib hävida!',
        centered = true,
        cancel = true
    })

    if confirmed == 'confirm' then
        lib.callback('kk-mdt:policeCaseDelete', false, function(response)
            if not response then
                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Antud juhtumit enam ei eksisteeri!')  
            end
            
            cb(response)
        end, args.case)
    else
        cb(false)
    end
end)