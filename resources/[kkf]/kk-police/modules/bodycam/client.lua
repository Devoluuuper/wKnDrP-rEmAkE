local showJob = nil
local axonOn = false
local playerLoaded = true

CreateThread(function()
    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('KKF.Player.Loaded', function(xPlayer)
    ESX.PlayerData = xPlayer
    playerLoaded = true
    Wait(2000)
    TriggerServerEvent('kk-police:bodycam:joined')
end)

RegisterNetEvent('KKF.Player.JobUpdate', function(job)
    ESX.PlayerData.job = job
    Wait(2000)
    TriggerServerEvent('kk-police:bodycam:joined')
end)

RegisterNetEvent('KKF.Player.DutyChange', function(value)
    ESX.PlayerData.job.onDuty = value
    Wait(2000)
    TriggerServerEvent('kk-police:bodycam:joined')
end)

RegisterCommand('bodycam', function() 
    axonOn = not axonOn
    TriggerServerEvent('kk-police:bodycam:joined') 
end)

TriggerEvent('chat:addSuggestion', '/bodycam', 'Lülita vormikaamerat välja/sisse.', {})

RegisterNetEvent('kk-police:bodycam:controls', function(name, department)
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.onDuty and axonOn then
        showJob = ESX.PlayerData.job.grade_label .. ' - ' .. name

        SendNUIMessage({action = 'show', data = {name = name, rank = ESX.PlayerData.job.grade_label, department = department}})
    else
        SendNUIMessage({action = 'hide'})
    end
end)