local ox_inventory = exports.ox_inventory
local labs = {}
local PlayerData = {}


RegisterNUICallback("sellLab", function(args, cb)
    local PlayerData = ESX.GetPlayerData()
    
    if PlayerData.job.name == cfg.job then
        local currentPos = GetEntityCoords(PlayerPedId())
        local playerId, playerPed, playerCoords = lib.getClosestPlayer(currentPos, 3.0, false)
        
        if DoesEntityExist(playerPed) then
            local price = tonumber(args.hind)

            if price >= cfg.labminprice then
                lib.callback('kk-properties:sellLab', false, function(response)
                    if response then
                        SendNUIMessage({action = 'showNotification', data = {title = 'Labori müük', text = 'Labori müük õnnestus', type = 'success'}})
                    else
                        SendNUIMessage({action = 'showNotification', data = {title = 'Labori müük', text = 'Ostjal on probleeme labori ostmisega', type = 'error'}})
                    end
                end, GetPlayerServerId(playerId), price)
            else
                SendNUIMessage({action = 'showNotification', data = {title = 'Labori müük', text = 'Labori hind peab jääma '..cfg.labminprice..'$'..' - '..cfg.labmaxprice..'$ Vahele' , type = 'error'}})
            end
        else
            SendNUIMessage({action = 'showNotification', data = {title = 'Labori müük', text = 'Kedagi pole läheduses!', type = 'error'}})
        end
    end
end)

RegisterNUICallback("searchlabs", function(args, cb)
    lib.callback('kk-properties:searchlabs', false, function(cb)

        local info = {}

        for k,v in pairs(cb) do

            local data = {
                id = v.id,
                owner = v.playerName ..' | '.. v.owner,
                name = v.name,
                password = v.password,
                location = GetStreetNameFromHashKey(GetStreetNameAtCoord(v.enter.x, v.enter.y, v.enter.z)),
            }

            table.insert(info, data)
        end
        SendNUIMessage({ action = "loadLabs", data = info })
    end, args.context)
end)

RegisterNUICallback("markLocationlab", function(args, cb)
    print(args.id)
    lib.callback('kk-properties:lab:getLocation', false, function(loc)
        SetNewWaypoint(loc.x, loc.y)
	end, args.id)
end)
