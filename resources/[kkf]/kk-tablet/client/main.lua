local function openTablet()
    SendNUIMessage({action = 'open', apps = lib.callback.await('kk-tablet:loadApps', false)}); SetNuiFocus(true, true); exports['kk-scripts']:toggleTab(true)
end

exports('openTablet', openTablet)

RegisterNUICallback('closeTablet', function()
    SendNUIMessage({action = 'close'}); SetNuiFocus(false, false); exports['kk-scripts']:toggleTab(false)
end)