local ESX = exports["kk-core"]:getSharedObject()

function getPlate(vehicle)
    if DoesEntityExist(vehicle) then
        local plate = Entity(vehicle).state.plate or GetVehicleNumberPlateText(vehicle)
        return ESX.Math.Trim(plate)
    end
    return nil
end

exports('getPlate', getPlate)

function getPrice(model)
    if cfg.vehicles[model] and cfg.vehicles[model].price then
        return cfg.vehicles[model].price
    else
        return nil
    end
end

exports('getPrice', getPrice)
