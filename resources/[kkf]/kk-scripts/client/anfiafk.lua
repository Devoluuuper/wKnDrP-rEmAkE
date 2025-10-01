local warnings = 0
local currentPos = {}

Citizen.CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())

        if currentPos == playerCoords or exports['kk-mining']:currentlyMining() then
            if warnings >= 220 then
                warnings = 0
                
                if not exports['kk-skillbar']:skillBar(100, 1) then
                    TriggerServerEvent('kk-scripts:server:kickPlayer')
                end
            else
                warnings = warnings + 1
            end
        else
            currentPos = playerCoords
            warnings = 0
        end

        Wait(5000)
    end
end)
