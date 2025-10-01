local objects = {}

local function spawnAttachedObject(ped, model, bone, off1, off2, off3, rot1, rot2, rot3)
    if DoesEntityExist(ped) then
        lib.requestModel(model)
        local object = CreateObject(model, 1.0, 1.0, 1.0, 1, 1, 0)
        objects[#objects + 1] = object

        SetEntityCollision(object, false, false)
        AttachEntityToEntity(object, ped, GetPedBoneIndex(ped, bone), off1 or 0, off2 or 0, off3 or 0, rot1 or 0, rot2 or 0, rot3 or 0, 0, 1, 0, 1, 0, 1)

        return object
    else
        return false
    end
end

exports('spawnAttachedObject', spawnAttachedObject)

RegisterNetEvent('kk-scripts:client:clearObjects', function()
    for i = 1, #objects do
        if DoesEntityExist(objects[i]) then
            ESX.Game.DeleteEntity(objects[i])
        end
    end

    objects = {}
end)


local function requestModel(modelHash, cb)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) and IsModelInCdimage(modelHash) then
		RequestModel(modelHash)

		while not HasModelLoaded(modelHash) do
			Wait(0)
		end
	end

	if cb then cb() end
end

exports('requestModel', requestModel) -- exports['kk-scripts']:requestModel



-- lib.onCache('vehicle', function(value)
--     local vehicle = value

--     if vehicle then
--         if Entity(vehicle).state.serverModel then
--             if Entity(vehicle).state.serverModel ~= GetEntityModel(vehicle) then
--                 DeleteEntity(vehicle)

--                 print('Bugged vehicle delete ' .. vehicle .. '!')
--             end
--         end
--     end
-- end)