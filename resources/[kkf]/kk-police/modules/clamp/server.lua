
local clampState = {}


lib.callback.register('kk-police:isClamped', function(source, networkId)
    -- Check if the vehicle is clamped
    return clampState[networkId] or false
end)

lib.callback.register('kk-police:setClamp', function(source, networkId, status)
    -- Toggle the clamp state for the vehicle
    clampState[networkId] = status
    -- Return the status to the client (true if success, false otherwise)
    return true
end)
