local nbrDisplaying = 0

local function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
	SetTextDropshadow(255, 255, 255, 255, 255)
    SetTextColour(215, 215, 215, 255)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)

    ClearDrawOrigin()
end

RegisterNetEvent("KKF:chat:me", function(text, source)
    local playerId = GetPlayerFromServerId(source)

    if playerId ~= -1 or source == GetPlayerServerId(PlayerId()) then
        local isDisplaying = true
        local offset = 0 + (nbrDisplaying*0.14)
        nbrDisplaying = nbrDisplaying + 1

        CreateThread(function()
            while isDisplaying do
                Citizen.Wait(0)
                local sourceCoords = GetEntityCoords(GetPlayerPed(playerId))
                local nearCoords = GetEntityCoords(PlayerPedId())
                local distance = Vdist2(sourceCoords, nearCoords)
    
                if distance < 25.0 then
                    DrawText3D(sourceCoords['x'], sourceCoords['y'], sourceCoords['z'] + offset, text)
                end
            end        
        end)
        
        nbrDisplaying = nbrDisplaying - 1

        SetTimeout(5500, function()
            isDisplaying = false
        end)
    end
end)

TriggerEvent('chat:addSuggestion', '/me', 'Väljenda karakteri tegevusi.', {
    { name="sisu" }
})