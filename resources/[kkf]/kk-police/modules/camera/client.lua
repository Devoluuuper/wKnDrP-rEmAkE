local wait = false

RegisterNetEvent('kk-police:client:openCamera', function(identifier)
    SendNUIMessage({ action = 'open_image', id = identifier }); SetFollowPedCamViewMode(4)
    SetNuiFocus(true, true)
end)

RegisterNUICallback('updateDatabase', function(args, cb)
	if args.success then
		wait = false

		lib.callback('kk-police:updatePhoto', false, function()
			SendNUIMessage({action = 'close_image'}) 
			SetNuiFocus(false, false)
			SetFollowPedCamViewMode(0)
		end, args.player, args.image)

		TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'photo', 0.5)
	else
		wait = false

		SendNUIMessage({action = 'close_image'}) 
		SetNuiFocus(false, false)
		SetFollowPedCamViewMode(0)
	end
end)

RegisterNUICallback('postImage', function(args)
	if not wait then
		wait = true
		local x, y = GetActiveScreenResolution()

		exports['screenshot-basic']:requestScreenshot(function(data)
			SendNUIMessage({
				action = 'crop_image',
				data = {
					player = args.player,
					image_api = GlobalState.image_api,
		
					params = {
						['offsetX'] = args.left,
						['offsetY'] = args.top,
						['width']  = x / 8,
						['height'] = y / 4
					},

					image = tostring(data),
				}
			})
		end)
	end
end)

RegisterNUICallback('close_image', function(args)
    SendNUIMessage({action = 'close_image'}) 
	SetNuiFocus(false, false); SetFollowPedCamViewMode(0)
end)