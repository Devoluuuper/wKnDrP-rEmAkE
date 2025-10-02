
local limiterOn = false
local resetSpeedOnEnter = true


Citizen.CreateThread(function()
  local resetSpeedOnEnter = true
  while true do
    Citizen.Wait(0)
    local playerPed = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(playerPed,false)
    if GetPedInVehicleSeat(vehicle, -1) == playerPed and IsPedInAnyVehicle(playerPed, false) then

      if resetSpeedOnEnter then
        maxSpeed = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
        SetEntityMaxSpeed(vehicle, maxSpeed)
		TriggerEvent("KKF:ui:limiter", false)
        resetSpeedOnEnter = false
      end
      -- Disable speed limiter
      if IsControlJustReleased(0,137) and not limiterOn then
	  cruise = GetEntitySpeed(vehicle)
        SetEntityMaxSpeed(vehicle, cruise)
		cruise = math.floor(cruise * 3.6 + 0.5)
		TriggerEvent("KKF:ui:limiter", true)
		TriggerServerEvent("InteractSound_SV:PlayOnSource", "radiooff", 0.20)
		limiterOn = true
	  else
            if IsControlJustReleased(0,137) and limiterOn then			
        maxSpeed = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
        SetEntityMaxSpeed(vehicle, maxSpeed)
		limiterOn = false
        TriggerEvent("KKF:ui:limiter", false)
		TriggerServerEvent("InteractSound_SV:PlayOnSource", "radiooff", 0.20)
        end
      end
    else
      resetSpeedOnEnter = true
    end
  end
end)

