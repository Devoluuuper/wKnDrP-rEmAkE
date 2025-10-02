Sync = {}

function RequestSyncExecution(native, entity, ...)
    if DoesEntityExist(entity) then
        TriggerServerEvent('sync:request', GetInvokingResource(), native, GetPlayerServerId(NetworkGetEntityOwner(entity)), NetworkGetNetworkIdFromEntity(entity), ...)
    end
end

function Sync.DeleteVehicle(vehicle)
    if NetworkHasControlOfEntity(vehicle) then
        DeleteVehicle(vehicle)
    else
        RequestSyncExecution('DeleteVehicle', vehicle)
    end
end

function Sync.DeleteEntity(entity)
    if NetworkHasControlOfEntity(entity) then
        DeleteEntity(entity)
    else
        RequestSyncExecution('DeleteEntity', entity)
    end
end

function Sync.DeletePed(ped)
    if NetworkHasControlOfEntity(ped) then
        DeletePed(ped)
    else
        RequestSyncExecution('DeletePed', ped)
    end
end

function Sync.DeleteObject(object)
    if NetworkHasControlOfEntity(object) then
        DeleteObject(object)
    else
        RequestSyncExecution('DeleteObject', object)
    end
end

function Sync.SetVehicleFuelLevel(vehicle, level)
    if NetworkHasControlOfEntity(vehicle) then
        SetVehicleFuelLevel(vehicle, level)
    else
        RequestSyncExecution('SetVehicleFuelLevel', vehicle, level)
    end
end

function Sync.SetVehicleTyreBurst(vehicle, index, onRim, p3)
    if NetworkHasControlOfEntity(vehicle) then
        SetVehicleTyreBurst(vehicle, index, onRim, p3)
    else
        RequestSyncExecution('SetVehicleTyreBurst', vehicle, index, onRim, p3)
    end
end

function Sync.SetVehicleDoorShut(vehicle, doorIndex, closeInstantly)
    if NetworkHasControlOfEntity(vehicle) then
        SetVehicleDoorShut(vehicle, doorIndex, closeInstantly)
    else
        RequestSyncExecution('SetVehicleDoorShut', vehicle, doorIndex, closeInstantly)
    end
end

function Sync.SetVehicleDoorOpen(vehicle, doorIndex, loose, openInstantly)
    if NetworkHasControlOfEntity(vehicle) then
        SetVehicleDoorOpen(vehicle, doorIndex, loose, openInstantly)
    else
        RequestSyncExecution('SetVehicleDoorOpen', vehicle, doorIndex, loose, openInstantly)
    end
end

function Sync.SetVehicleDoorBroken(vehicle, doorIndex, deleteDoor)
    if NetworkHasControlOfEntity(vehicle) then
        SetVehicleDoorBroken(vehicle, doorIndex, deleteDoor)
    else
        RequestSyncExecution('SetVehicleDoorBroken', vehicle, doorIndex, deleteDoor)
    end
end

function Sync.SetVehicleEngineOn(vehicle, value, instantly, noAutoTurnOn)
    if NetworkHasControlOfEntity(vehicle) then
        SetVehicleEngineOn(vehicle, value, instantly, noAutoTurnOn)
    else
        RequestSyncExecution('SetVehicleEngineOn', vehicle, value, instantly, noAutoTurnOn)
    end
end

function Sync.SetVehicleUndriveable(vehicle, toggle)
    if NetworkHasControlOfEntity(vehicle) then
        SetVehicleUndriveable(vehicle, toggle)
    else
        RequestSyncExecution('SetVehicleUndriveable', vehicle, toggle)
    end
end

function Sync.SetVehicleHandbrake(vehicle, toggle)
    if NetworkHasControlOfEntity(vehicle) then
        SetVehicleHandbrake(vehicle, toggle)
    else
        RequestSyncExecution('SetVehicleHandbrake', vehicle, toggle)
    end
end

function Sync.DecorSetFloat(entity, propertyName, value)
    if NetworkHasControlOfEntity(entity) then
        DecorSetFloat(entity, propertyName, value)
    else
        RequestSyncExecution('DecorSetFloat', entity, propertyName, value)
    end
end

function Sync.DecorSetBool(entity, propertyName, value)
    if NetworkHasControlOfEntity(entity) then
        DecorSetBool(entity, propertyName, value)
    else
        RequestSyncExecution('DecorSetBool', entity, propertyName, value)
    end
end

function Sync.DecorSetInt(entity, propertyName, value)
    if NetworkHasControlOfEntity(entity) then
        DecorSetInt(entity, propertyName, value)
    else
        RequestSyncExecution('DecorSetInt', entity, propertyName, value)
    end
end

function Sync.DetachEntity(entity, p1, collision)
    if NetworkHasControlOfEntity(entity) then
        DetachEntity(entity, p1, collision)
    else
        RequestSyncExecution('DetachEntity', entity, p1, collision)
    end
end

function Sync.SetEntityCoords(entity, xPos, yPos, zPos, xAxis, yAxis, zAxis, clearArea)
    if NetworkHasControlOfEntity(entity) then
        SetEntityCoords(entity, xPos, yPos, zPos, xAxis, yAxis, zAxis, clearArea)
    else
        RequestSyncExecution('SetEntityCoords', entity, xPos, yPos, zPos, xAxis, yAxis, zAxis, clearArea)
    end
end

function Sync.SetEntityHeading(entity, heading)
    if NetworkHasControlOfEntity(entity) then
        SetEntityHeading(entity, heading)
    else
        RequestSyncExecution('SetEntityHeading', entity, heading)
    end
end

function Sync.FreezeEntityPosition(entity, freeze)
    if NetworkHasControlOfEntity(entity) then
        FreezeEntityPosition(entity, freeze)
    else
        RequestSyncExecution('FreezeEntityPosition', entity, freeze)
    end
end

function Sync.SetVehicleDoorsLocked(entity, status)
    if NetworkHasControlOfEntity(entity) then
        SetVehicleDoorsLocked(entity, status)
    else
        RequestSyncExecution('SetVehicleDoorsLocked', entity, status)
    end
end

function Sync.NetworkExplodeVehicle(vehicle, isAudible, isInvisible, p3)
    if NetworkHasControlOfEntity(vehicle) then
        NetworkExplodeVehicle(vehicle, isAudible, isInvisible, p3)
    else
        RequestSyncExecution('NetworkExplodeVehicle', vehicle, isAudible, isInvisible, p3)
    end
end

function Sync.SetBoatAnchor(vehicle, state)
    if NetworkHasControlOfEntity(vehicle) then
        SetBoatAnchor(vehicle, state)
    else
        RequestSyncExecution('SetBoatAnchor', vehicle, state)
    end
end

function Sync.SetBoatFrozenWhenAnchored(vehicle, state)
    if NetworkHasControlOfEntity(vehicle) then
        SetBoatFrozenWhenAnchored(vehicle, state)
    else
        RequestSyncExecution('SetBoatFrozenWhenAnchored', vehicle, state)
    end
end

function Sync.SetForcedBoatLocationWhenAnchored (vehicle, state)
    if NetworkHasControlOfEntity(vehicle) then
        SetForcedBoatLocationWhenAnchored(vehicle, state)
    else
        RequestSyncExecution('SetForcedBoatLocationWhenAnchored', vehicle, state)
    end
end

function Sync.SetVehicleOnGroundProperly(vehicle)
    if NetworkHasControlOfEntity(vehicle) then
        SetVehicleOnGroundProperly(vehicle)
    else
        RequestSyncExecution('SetVehicleOnGroundProperly', vehicle)
    end
end

function Sync.SetVehicleTyreFixed(vehicle, index)
    if NetworkHasControlOfEntity(vehicle) then
        SetVehicleTyreFixed(vehicle, index)
    else
        RequestSyncExecution('SetVehicleTyreFixed', vehicle, index)
    end
end

function Sync.SetVehicleEngineHealth(vehicle, health)
    if NetworkHasControlOfEntity(vehicle) then
        SetVehicleEngineHealth(vehicle, health + 0.0)
    else
        RequestSyncExecution('SetVehicleEngineHealth', vehicle, health  + 0.0)
    end
end

function Sync.SetVehicleBodyHealth(vehicle, health)
    if NetworkHasControlOfEntity(vehicle) then
        SetVehicleBodyHealth(vehicle, health + 0.0)
    else
        RequestSyncExecution('SetVehicleBodyHealth', vehicle, health  + 0.0)
    end
end

function Sync.SetVehicleDeformationFixed(vehicle)
    if NetworkHasControlOfEntity(vehicle) then
        SetVehicleDeformationFixed(vehicle)
    else
        RequestSyncExecution('SetVehicleDeformationFixed', vehicle)
    end
end

function Sync.SetVehicleFixed(vehicle)
    if NetworkHasControlOfEntity(vehicle) then
        SetVehicleFixed(vehicle)
    else
        RequestSyncExecution('SetVehicleFixed', vehicle)
    end
end

function Sync.SetVehicleDeformationFixed(vehicle)
    if NetworkHasControlOfEntity(vehicle) then
        SetVehicleDeformationFixed(vehicle)
    else
        RequestSyncExecution('SetVehicleDeformationFixed', vehicle)
    end
end

function Sync.SetEntityAsNoLongerNeeded(entity)
    if NetworkHasControlOfEntity(entity) then
        SetEntityAsNoLongerNeeded(entity)
    else
        RequestSyncExecution('SetEntityAsNoLongerNeeded', entity)
    end
end

function Sync.SetPedKeepTask(ped, keepTask)
    if NetworkHasControlOfEntity(ped) then
        SetPedKeepTask(ped, keepTask)
    else
        RequestSyncExecution('SetPedKeepTask', ped, keepTask)
    end
end

function Sync.SetVehicleTyresCanBurst(vehicle, enabled)
    if NetworkHasControlOfEntity(vehicle) then
        SetVehicleTyresCanBurst(vehicle, enabled)
    else
        RequestSyncExecution('SetVehicleTyresCanBurst', vehicle, enabled)
    end
end