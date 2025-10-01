UnitsRadar = {
    serverID = GetPlayerServerId(PlayerId()),
    active = {},
    distant = {},
    _panic = {},
	__index = self
}

TriggerEvent('chat:addSuggestion', '/panic', 'Paanikanupp.') 
TriggerEvent('chat:addSuggestion', '/radar', 'GPS seade.')

function UnitsRadar:updateAll(activeBlips)
    activeBlips[self.serverID] = nil

    for k, v in pairs(activeBlips) do
        self:update(k, v.coords.x, v.coords.y, v.coords.z, v.heading, v.label, v.callsign, v.color)
    end
end

function UnitsRadar:update(playerID, x, y, z, heading, label, callsign, color)
    local player = GetPlayerFromServerId(playerID)
    local wasDistant = self.distant[playerID]

    self.distant[playerID] = (player == -1)

    if (wasDistant and not self.distant[playerID]) or (not wasDistant and self.distant[playerID]) then
        self:remove(playerID, false) -- The player's gotten into your scope / outside your scope -> remove the existing blip, it'll be re-created below with the new parameters
    end

    if self.active[playerID] == nil then
        self.active[playerID] = self.distant[playerID] and AddBlipForCoord(x, y, z) or AddBlipForEntity(GetPlayerPed(player))
        SetBlipCategory(self.active[playerID], 7)
        SetBlipSprite(self.active[playerID], 1)
        SetBlipAsShortRange(self.active[playerID], true)
        SetBlipDisplay(self.active[playerID], 4)
        SetBlipShowCone(self.active[playerID], true)
        BeginTextCommandSetBlipName("STRING")

        if callsign then
            ShowNumberOnBlip(self.active[playerID], tonumber(callsign))
        end

        AddTextComponentString(label)
        EndTextCommandSetBlipName(self.active[playerID])
    elseif self.distant[playerID] then
        SetBlipCoords(self.active[playerID], x, y, z)
    end

    if number then
        ShowNumberOnBlip(self.active[playerID], tonumber(callsign))
    end

    SetBlipColour(self.active[playerID], color)
end

function UnitsRadar:remove(playerID, removeDistant)
    if self.active[playerID] then
        RemoveBlip(self.active[playerID])
        self.active[playerID] = nil

        if removeDistant ~= false then
            self.distant[playerID] = nil
        end
    end
end

function UnitsRadar:removeAll()
    for k, v in pairs(self.active) do
        self:remove(k)
    end
end

RegisterNetEvent('police:removeUnit', function(playerID, unsubscribe)
    UnitsRadar:remove(playerID)
end)

RegisterNetEvent('police:removeBlips', function()
    UnitsRadar:removeAll()
end)

RegisterNetEvent('police:updateBlips', function(blips)
    UnitsRadar:updateAll(blips)
end)

RegisterNetEvent('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        ClearGpsMultiRoute()
    end
end)

TriggerEvent('chat:addSuggestion', '/311', 'Ametkondliku teate saatmine.', { { name = 'sisu'} }) 