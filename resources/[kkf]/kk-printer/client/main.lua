local ValidExtensionsText = '.png, .jpg, .jpeg'
local ValidExtensions = {
    [".png"] = true,
    [".jpg"] = true,
    ["jpeg"] = true
}

RegisterNetEvent('KKF.Player.Loaded', function(xPlayer)
	KKF.PlayerData = xPlayer
end)

RegisterNetEvent('KKF.Player.Unloaded', function()
	KKF.PlayerData = {}
end)

RegisterNetEvent('KKF.Player.JobUpdate', function(job)
	KKF.PlayerData.job = job
end)

RegisterNetEvent('KKF.Player.DutyChange', function(value)
	KKF.PlayerData.job.onDuty = value
end)

local function openPrinter()
	local input = lib.inputDialog('Dokumendi printimine', {
		{type = 'input', label = 'Nimetus', description = 'Dokumendi nimi', required = true},
		{type = 'input', label = 'Link', description = '.jpg / .png / .jpeg', required = true},
		{type = 'number', label = 'Koopiaid', description = '1, 3, 6, 12', min = 0}
	})

	if input then
		input[3] = tonumber(input[3])

		if input[1] and input[2] and input[3] then
			if input[3] > 0 then
				local extension = string.sub(input[2], -4)
				local validexts = ValidExtensions

				if validexts[extension] then
					lib.callback('KKF.Item.Amount', false, function(qtty)
						if qtty >= input[3] then
							for i = 1, input[3] do
								local progress = exports['kk-taskbar']:startAction('printingDocuments', 'Prindid dokumente', 4500, 'idle_a', 'amb@code_human_police_investigate@idle_a', {freeze = true, controls = true})

								if progress then
									TriggerServerEvent('kk-printer:server:savePaperDocument', input[1], input[2])
								else
									break
								end
							end
						else
							TriggerEvent('KKF.UI.ShowNotification', 'error', 'Teil ei ole piisavalt A4 lehti.')
						end
					end, 'a4')
				else
					TriggerEvent('KKF.UI.ShowNotification', 'error', 'Sisestage korrektne koopiate arv!')
				end
			else
                TriggerEvent('KKF.UI.ShowNotification', 'error', 'Seda faililaiendit ei saa kasutada, ainult ' .. ValidExtensionsText ..' on lubatud.')
            end
		end
	end
end

RegisterNetEvent('kk-printer:client:viewDocument', function(url)
    SendNUIMessage({
        action = "openDocument",
        url = url
    })

    SetNuiFocus(true, true)
end)

RegisterNUICallback('closeDocument', function()
    SetNuiFocus(false, false)
end)

for k,v in pairs(cfg.locations) do
    local point = lib.points.new(v.pos, 1.5, {job = v.job})
    
    function point:onEnter()
        -- if KKF.PlayerData.job.name == point.job and KKF.PlayerData.job.onDuty and KKF.PlayerData.job.permissions.function7 then
		if KKF.PlayerData.job.name == point.job and KKF.PlayerData.job.onDuty then
			KKF.ShowInteraction('Prindi', 'E')
        end
    end
    
    function point:onExit()
        -- if KKF.PlayerData.job.name == point.job and KKF.PlayerData.job.onDuty and KKF.PlayerData.job.permissions.function7 then
		if KKF.PlayerData.job.name == point.job and KKF.PlayerData.job.onDuty then
			KKF.HideInteraction()
        end
    end
    
    function point:nearby()
        if self.currentDistance < 2.0 and IsControlJustReleased(0, 38) then
            -- if KKF.PlayerData.job.name == point.job and KKF.PlayerData.job.onDuty and KKF.PlayerData.job.permissions.function7 then
			if KKF.PlayerData.job.name == point.job and KKF.PlayerData.job.onDuty then
				openPrinter()
            end
        end
    end
end

CreateThread(function()
	while not LocalPlayer.state['isLoggedIn'] do
		Wait(500)
	end

    exports.ox_inventory:displayMetadata({
        documentName = 'Nimetus'
    })
end)