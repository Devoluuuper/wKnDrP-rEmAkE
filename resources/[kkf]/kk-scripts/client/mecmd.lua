local nbrDisplaying = 0

RegisterNetEvent("KKF:chat:me", function(text, source)
    local playerId = GetPlayerFromServerId(source)

    if playerId ~= -1 or source == GetPlayerServerId(PlayerId()) then
        local isDisplaying = true
        local offset = 0 + (nbrDisplaying * 0.07)
        nbrDisplaying += 1

        CreateThread(function()
            while isDisplaying do
                local sourceCoords = GetEntityCoords(GetPlayerPed(playerId))
                local nearCoords = GetEntityCoords(PlayerPedId())
                local distance = #(sourceCoords - nearCoords)
    
                if distance < 25.0 then
                    KKF.Functions.DrawText3D(vec3(sourceCoords['x'], sourceCoords['y'], sourceCoords['z'] + offset), text)
                end

                Wait(0)
            end        
        end)

        SetTimeout(5500, function()
            isDisplaying = false
            nbrDisplaying -= 1
        end)
    end
end)


TriggerEvent('chat:addSuggestion', '/me', 'Väljenda karakteri tegevusi.', {
    { name="sisu" }
})