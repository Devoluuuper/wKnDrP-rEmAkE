local resourceStartHandler
local currentResourceName = GetCurrentResourceName()

resourceStartHandler = AddEventHandler('onClientResourceStart', function(resourceName)
    if resourceName ~= currentResourceName then return end
    while NetworkIsSessionStarted() ~= 1 do Wait(0) end
    TriggerServerEvent('kk-queue:server:playerActivated')
    RemoveEventHandler(resourceStartHandler)
end)