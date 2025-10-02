--  server
RegisterServerEvent('kk-carwash:server:setWax', function(networkId)
	local src = source
    local vehicle = NetworkGetEntityFromNetworkId(networkId)

    if vehicle ~= nil and DoesEntityExist(vehicle) then
        local waxTime = 21600 -- 6h
        Entity(vehicle).state:set('wax', waxTime, true)

    else
        -- print('Sõidukit pole olemas')
    end
end)