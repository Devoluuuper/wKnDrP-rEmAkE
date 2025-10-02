UnitsRadar = {
    active = {},
    subscribers = {},
	__index = self,
	init = function(o)
		o = o or {active = {}, subscribers = {}}
		setmetatable(o, self)
		self.__index = self
		return o
	end
}

function UnitsRadar:subscribe(serverID) -- Allows to "spectate" units radar without being shown on the map
    self.subscribers[serverID] = true
end

function UnitsRadar:unsubscribe(serverID) 
    self.subscribers[serverID] = nil
end

function UnitsRadar:addUnit(serverID, label, color, subscribe)
    if self.active[serverID] then self:removeUnit(serverID) end

    self.active[serverID] = {
        label = label,
        color = tonumber(color) or 1
    }

    if subscribe ~= false then
        self:subscribe(serverID)
    end
end

function UnitsRadar:removeUnit(serverID, unsubscribe)
    if self.active[serverID] then
        for k, v in pairs(self.subscribers) do
            TriggerClientEvent('taxi:removeUnit', k, serverID)
        end

        if unsubscribe ~= false then
            self:unsubscribe(serverID)
            TriggerClientEvent('taxi:removeBlips', serverID)
        end

        self.active[serverID] = nil
    end
end

function UnitsRadar:updateBlips(frequency)
    frequency = tonumber(frequency) or 3000
    self.blips = true

    Citizen.CreateThread(
        function()
            while self.blips do
                Citizen.Wait(frequency)
                local playerPed = nil

                for k, v in pairs(self.active) do
                    playerPed = GetPlayerPed(k)
                    self.active[k].coords = GetEntityCoords(playerPed)
                end

                playerPed = nil
                
                for k, v in pairs(self.subscribers) do
                    TriggerClientEvent('taxi:updateBlips', k, self.active)
                end
            end
            for k, v in pairs(self.subscribers) do
                TriggerClientEvent('taxi:removeBlips', k)
            end
        end
    )
    return function()
        self.blips = false
    end
end

UnitsRadar:updateBlips()

RegisterNetEvent('taxi:removeUnit')
AddEventHandler(
    'taxi:removeUnit',
    function(serverID, color)
        serverID = tonumber(serverID)

        if source > 0 or not serverID or serverID < 1 then
            return
        end

        UnitsRadar:removeUnit(serverID)
    end
)

AddEventHandler('KKF.Player.JobUpdate', function(source, job, lastJob)
    local kPlayer = KKF.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.job.name == 'taxi' and kPlayer.job.onDuty then
            UnitsRadar:addUnit(source, kPlayer.job.grade_label .. ' ' .. kPlayer.name, 5)
        else
            UnitsRadar:removeUnit(source)
        end
    end
end)

AddEventHandler('KKF.Player.DutyChange', function(source)
    local kPlayer = KKF.GetPlayerFromId(source)

    if kPlayer then
        if kPlayer.job.name == 'taxi' and kPlayer.job.onDuty then
            UnitsRadar:addUnit(source, kPlayer.job.grade_label .. ' ' .. kPlayer.name, 5)
        else
            UnitsRadar:removeUnit(source)
        end
    end
end)

AddEventHandler('KKF.Player.Loaded', function(source)
    local kPlayer = KKF.GetPlayerFromId(source)

    if kPlayer then
        SetTimeout(5000, function()
            if kPlayer.job.name == 'taxi' and kPlayer.job.onDuty then
                UnitsRadar:addUnit(source, kPlayer.job.grade_label .. ' ' .. kPlayer.name, 5)
            else
                UnitsRadar:removeUnit(source)
            end
        end)
    end
end)

RegisterNetEvent('playerDropped', function()
    UnitsRadar:removeUnit(source)
end)

AddEventHandler('KKF.Player.Dropped', function(source)
    UnitsRadar:removeUnit(source)
end)