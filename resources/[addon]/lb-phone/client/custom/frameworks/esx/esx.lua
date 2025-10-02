if Config.Framework ~= "KKF" then
    return
end

debugprint("Loading KKF")

local export, obj = pcall(function()
    return exports['kk-core']:getSharedObject()
end)

if export then
    KKF = obj
else
    while not KKF do
        TriggerEvent("KKF:getSharedObject", function(obj)
            KKF = obj
        end)

        Wait(500)
    end
end

local isFirstPlayerLoaded = true

RegisterNetEvent("KKF:playerLoaded", function(playerData)
    KKF.PlayerData = playerData
    KKF.PlayerLoaded = true

    if not isFirstPlayerLoaded then
        FetchPhone()
    end

    isFirstPlayerLoaded = false
end)

RegisterNetEvent("KKF:onPlayerLogout", function()
    LogOut()
end)

while not KKF.PlayerLoaded do
    Wait(500)
end

FrameworkLoaded = true

debugprint("KKF loaded")

RegisterNetEvent("KKF:setAccountMoney", function(account)
    if account.name ~= "bank" then
        return
    end

    SendReactMessage("wallet:setBalance", math.floor(account.money))
end)
