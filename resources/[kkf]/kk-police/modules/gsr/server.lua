local gsrData = {}

local function removeGsr()
    for k, v in pairs(gsrData) do
        if v <= os.time(os.date("!*t")) then
            gsrData[k] = nil
        end
    end
end

RegisterServerEvent('kk-police:server:setGsr', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

	if xPlayer then
    	gsrData[xPlayer.identifier] = os.time(os.date("!*t")) + 30 * 60
	end
end)

RegisterNetEvent("kk-police:server:removeGsr", function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

	if xPlayer then
		if gsrData[xPlayer.identifier] ~= nil then
			gsrData[xPlayer.identifier] = nil
		end
	end
end)


RegisterNetEvent('kk-police:server:testGsr', function(serverId)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

	if xPlayer then
		if xPlayer.job.name == 'police' or xPlayer.job.name == 'doj' then
			local xTarget = ESX.GetPlayerFromId(serverId)

			if xTarget then
				TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'info', gsrData[xTarget.identifier] ~= nil and 'Test tuli tagasi kui: POSITIIVNE' or gsrData[xTarget.identifier] == nil and 'Test tuli tagasi kui: NEGATIIVNE')
			end
		end
	end
end)

lib.callback.register('kk-police:getGsrStatus', function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local returnable = nil

    if xPlayer then
		if gsrData[xPlayer.identifier] ~= nil then
			returnable = true
		else
			returnable = false
		end
	else 
		returnable = false
    end

    while returnable == nil do Wait(50) end; return returnable
end)

SetInterval(function()
    removeGsr()
end, 10 * 60 * 1000)