local sliderCallback = nil

RegisterNUICallback('callback', function(data, cb)
    SetNuiFocus(false, false)
    sliderCallback(data.success)
    cb('ok')
end)

AddEventHandler('kk-minigame:client:openSlider', function(callback, speed, numbers)
    sliderCallback = callback
    SetNuiFocus(true, true)
    SendNUIMessage({type = "open", speed = speed, numbers = numbers})
end)