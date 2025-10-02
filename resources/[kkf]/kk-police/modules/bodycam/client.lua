local showJob = nil
local axonOn = false
local playerLoaded = true

CreateThread(function()
    KKF.PlayerData = KKF.GetPlayerData()
end)

RegisterNetEvent('KKF.Player.Loaded', function(xPlayer)
    KKF.PlayerData = xPlayer
    playerLoaded = true
    Wait(2000)
    TriggerServerEvent('kk-police:bodycam:joined')
end)

RegisterNetEvent('KKF.Player.JobUpdate', function(job)
    KKF.PlayerData.job = job
    Wait(2000)
    TriggerServerEvent('kk-police:bodycam:joined')
end)

RegisterNetEvent('KKF.Player.DutyChange', function(value)
    KKF.PlayerData.job.onDuty = value
    Wait(2000)
    TriggerServerEvent('kk-police:bodycam:joined')
end)

RegisterCommand('bodycam', function() 
    axonOn = not axonOn
    TriggerServerEvent('kk-police:bodycam:joined') 
end)

TriggerEvent('chat:addSuggestion', '/bodycam', 'Lülita vormikaamerat välja/sisse.', {})

RegisterNetEvent('kk-police:bodycam:controls', function(name, department)
    if KKF.PlayerData.job and KKF.PlayerData.job.name == 'police' and KKF.PlayerData.job.onDuty and axonOn then
        showJob = KKF.PlayerData.job.grade_label .. ' - ' .. name

        SendNUIMessage({action = 'show', data = {name = name, rank = KKF.PlayerData.job.grade_label, department = department}})
    else
        SendNUIMessage({action = 'hide'})
    end
end)