
RegisterNetEvent('KKF.Player.Loaded')
AddEventHandler('KKF.Player.Loaded', function(xPlayer)
    ESX.PlayerData = xPlayer
	Wait(2500)
end)

RegisterNetEvent('KKF.Player.JobUpdate')
AddEventHandler('KKF.Player.JobUpdate', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('KKF.Player.DutyChange')
AddEventHandler('KKF.Player.DutyChange', function(value)
	ESX.PlayerData.job.onDuty = value
end)

Citizen.CreateThread(function()
	while true do
		StartAudioScene('DLC_MPHEIST_TRANSITION_TO_APT_FADE_IN_RADIO_SCENE') 
		Citizen.Wait(10)
	end
end)


CreateThread(function()
    local blipCoord = AddBlipForCoord(-430.08792114258, 261.74505615234, 82.9970703125)
    SetBlipSprite(blipCoord, 176)
    SetBlipDisplay(blipCoord, 4)
    SetBlipScale(blipCoord, 0.7)
    SetBlipColour(blipCoord, nil)
    SetBlipAsShortRange(blipCoord, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Ööklubi")
    EndTextCommandSetBlipName(blipCoord)
end)


CreateThread(function()
    local alreadyEnteredZone = false

    while true do
        wait = 5
        local ped = PlayerPedId()
        local inZone = false

        local dist = #(GetEntityCoords(ped) - vector3(-430.08792114258, 261.74505615234, 82.9970703125))

        if dist <= 3.0 then
            wait = 5
            inZone  = true
            if IsControlJustPressed(0, 46) and dist <= 3.0 then
                Citizen.Wait(500)
                SetEntityCoords(PlayerPedId(), vec3(-1569.54, -3017.46,-75.30))
            else
                wait = 5
            end
        else
            wait = 2000
        end
        
        if inZone and not alreadyEnteredZone then
            alreadyEnteredZone = true
            ESX.ShowInteraction("Sisene klubisse", 'E')
        end

        if not inZone and alreadyEnteredZone then
            alreadyEnteredZone = false
            ESX.HideInteraction()
        end

        Wait(wait)
    end
end)

CreateThread(function()
    local alreadyEnteredZone = false

    while true do
        wait = 5
        local ped = PlayerPedId()
        local inZone = false

        local dist = #(GetEntityCoords(ped) - vector3(-1569.3890380859, -3017.525390625, -74.413940429688))

        if dist <= 3.0 then
            wait = 5
            inZone  = true
            if IsControlJustPressed(0, 46) and dist <= 3.0 then
                Citizen.Wait(500)
                SetEntityCoords(PlayerPedId(), vector3(-430.08792114258, 261.74505615234, 82.9970703125))
            else
                wait = 5
            end
        else
            wait = 2000
        end
        
        if inZone and not alreadyEnteredZone then
            alreadyEnteredZone = true
            ESX.ShowInteraction("Lahku klubist", 'E')
        end

        if not inZone and alreadyEnteredZone then
            alreadyEnteredZone = false
            ESX.HideInteraction()
        end

        Wait(wait)
    end
end)

-- exit vehicle outside

CreateThread(function()
    local alreadyEnteredZone = false

    while true do
        wait = 5
        if LocalPlayer.state['isLoggedIn'] then
            if ESX.PlayerData.job.name == 'bubblegum' then
                local ped = PlayerPedId()
                local inZone = false

                local dist = #(GetEntityCoords(ped) - vector3(-452.47912597656, 290.47912597656, 83.216064453125))

                if dist <= 3.0 then
                    wait = 5
                    inZone  = true
                    if IsControlJustPressed(0, 46) and dist <= 4.0 then
                        local vehicle = GetVehiclePedIsIn(ped, false)
                        if IsPedInAnyVehicle(PlayerPedId(), false) then
                            if DoesEntityExist(vehicle) then
                                Citizen.Wait(500)
                                SetEntityCoords(vehicle, -1641.3758544922, -2989.859375, -77.093017578125)
                                SetEntityHeading(vehicle, 269.29135131836)
                            end
                        else
                            Citizen.Wait(500)
                            SetEntityCoords(ped, -1641.3758544922, -2989.859375, -77.093017578125)
                            SetEntityHeading(ped, 269.29135131836)
                        end
                    else
                        wait = 5
                    end
                else
                    wait = 2000
                end
                
                if inZone and not alreadyEnteredZone then
                    alreadyEnteredZone = true
                    ESX.ShowInteraction("Sisene klubisse",'E')
                end

                if not inZone and alreadyEnteredZone then
                    alreadyEnteredZone = false
                    ESX.HideInteraction()
                end

                Wait(wait)
            else
                Wait(5000)
            end
        else
            Wait(5000)
        end
    end
end)

-- exit vehicle inside

CreateThread(function()
    local alreadyEnteredZone = false

    while true do
        wait = 5
        if LocalPlayer.state['isLoggedIn'] then
            if ESX.PlayerData.job.name == 'bubblegum' then
                local ped = PlayerPedId()
                local inZone = false

                local dist = #(GetEntityCoords(ped) - vector3(-1641.1647949219, -2989.7143554688, -77.10986328125))

                if dist <= 3.0 then
                    wait = 5
                    inZone  = true
                    if IsControlJustPressed(0, 46) and dist <= 4.0 then
                        Citizen.Wait(500)
                        local vehicle = GetVehiclePedIsIn(ped, false)
                        if IsPedInAnyVehicle(PlayerPedId(), false) then
                            if DoesEntityExist(vehicle) then
                                Citizen.Wait(500)
                                SetEntityCoords(vehicle, -452.47912597656, 290.47912597656, 83.216064453125)
                                SetEntityHeading(vehicle, 351.49606323242)
                            end
                        else
                            Citizen.Wait(500)
                            SetEntityCoords(ped, -452.47912597656, 290.47912597656, 83.216064453125)
                            SetEntityHeading(ped, 351.49606323242)
                        end
                    else
                        wait = 5
                    end
                else
                    wait = 2000
                end
                
                if inZone and not alreadyEnteredZone then
                    alreadyEnteredZone = true
                    ESX.ShowInteraction("Lahku klubist", 'E')
                end

                if not inZone and alreadyEnteredZone then
                    alreadyEnteredZone = false
                    ESX.HideInteraction()
                end

                Wait(wait)
            else
                Wait(2000)
            end
        else
            Wait(2000)
        end
    end
end)



CreateThread(function()
    -- Getting the object to interact with
	Wait(1000)
    AfterHoursNightclubs = exports['ipl_loader']:GetAfterHoursNightclubsObject()
	Wait(1000)

    -------------------------------------------
    -- Interior part

    -- Interior setup
    AfterHoursNightclubs.Ipl.Interior.Load()
    
    -- Setting the name of the club to The Palace
    AfterHoursNightclubs.Interior.Name.Set(AfterHoursNightclubs.Interior.Name.paradise, true)

    -- Glamorous style
    AfterHoursNightclubs.Interior.Style.Set(AfterHoursNightclubs.Interior.Style.edgy, true)

    -- Glam podiums
    AfterHoursNightclubs.Interior.Podium.Set(AfterHoursNightclubs.Interior.Podium.edgy, true)

    -- speakers
    AfterHoursNightclubs.Interior.Speakers.Set(AfterHoursNightclubs.Interior.Speakers.upgrade, true)

    -- security
    AfterHoursNightclubs.Interior.Security.Set(AfterHoursNightclubs.Interior.Security.on, true)
    
    -- Setting turntables
    AfterHoursNightclubs.Interior.Turntables.Set(AfterHoursNightclubs.Interior.Turntables.style03, true)

    -- Lights --
	AfterHoursNightclubs.Interior.Lights.Clear()
	
	--Laser--
	AfterHoursNightclubs.Interior.Lights.Lasers.Clear()
    --AfterHoursNightclubs.Interior.Lights.Lasers.Set(AfterHoursNightclubs.Interior.Lights.Lasers.green, true)
    AfterHoursNightclubs.Interior.Lights.Lasers.Set(AfterHoursNightclubs.Interior.Lights.Lasers.yellow, false)
	--AfterHoursNightclubs.Interior.Lights.Lasers.Set(AfterHoursNightclubs.Interior.Lights.Lasers.purple, false)
	--AfterHoursNightclubs.Interior.Lights.Lasers.Set(AfterHoursNightclubs.Interior.Lights.Lasers.green, false)
	--Bands--
	AfterHoursNightclubs.Interior.Lights.Bands.Clear()
	AfterHoursNightclubs.Interior.Lights.Bands.Set(AfterHoursNightclubs.Interior.Lights.Bands.white, true)
	--AfterHoursNightclubs.Interior.Lights.Bands.Set(AfterHoursNightclubs.Interior.Lights.Bands.green, true)
	AfterHoursNightclubs.Interior.Lights.Bands.Set(AfterHoursNightclubs.Interior.Lights.Bands.yellow, true)
   --Neons--
    AfterHoursNightclubs.Interior.Lights.Neons.Clear()
    AfterHoursNightclubs.Interior.Lights.Neons.Set(AfterHoursNightclubs.Interior.Lights.Neons.yellow, true)
	--AfterHoursNightclubs.Interior.Lights.Neons.Set(AfterHoursNightclubs.Interior.Lights.Neons.purple, true)
	--Drops--
	AfterHoursNightclubs.Interior.Lights.Droplets.Clear()
	--AfterHoursNightclubs.Interior.Lights.Droplets.Set(AfterHoursNightclubs.Interior.Lights.Droplets.green, true)
	--AfterHoursNightclubs.Interior.Lights.Droplets.Set(AfterHoursNightclubs.Interior.Lights.Droplets.purple, true)
	AfterHoursNightclubs.Interior.Lights.Droplets.Set(AfterHoursNightclubs.Interior.Lights.Droplets.yellow, true)
   
    -- Details
    AfterHoursNightclubs.Interior.Details.Enable(true)
    AfterHoursNightclubs.Interior.Details.Enable(AfterHoursNightclubs.Interior.Details.floorTradLights, true)
    AfterHoursNightclubs.Interior.Details.Enable(AfterHoursNightclubs.Interior.Details.dryIce, true)
    
    -- Enabling bottles behind the bar
    AfterHoursNightclubs.Interior.Bar.Enable(true)

    -- Enabling all booze bottles
    AfterHoursNightclubs.Interior.Booze.Enable(AfterHoursNightclubs.Interior.Booze, true)

    -- Adding trophies on the desk
    AfterHoursNightclubs.Interior.Trophy.Enable(AfterHoursNightclubs.Interior.Trophy.dancer, true, AfterHoursNightclubs.Interior.Trophy.Color.gold)
    
    -- Refreshing interior to apply changes
    RefreshInterior(AfterHoursNightclubs.interiorId, true)

    -------------------------------------------
    -- Exterior part

    -- La Mesa - Exterior
    -- No barriers
    AfterHoursNightclubs.Mesa.Barrier.Enable(true)

    -- Only "For sale" poster
    AfterHoursNightclubs.Mesa.Posters.Enable(AfterHoursNightclubs.Posters.forSale, true)

    -- Mission Row - Exterior
    -- Barriers
    AfterHoursNightclubs.Mesa.Barrier.Enable(true)

    -- Posters for Dixon and Madonna only
    AfterHoursNightclubs.Mesa.Posters.Enable({AfterHoursNightclubs.Posters.dixon, AfterHoursNightclubs.Posters.madonna}, true)
end)

AddEventHandler('club:djbooth', function()
    TriggerEvent('wasabi_boombox:interact')
end)
