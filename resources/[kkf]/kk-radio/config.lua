Config = {}

Config.Item = {
    Require = true,
    name = "radio"
}

Config.KeyMappings = {
    Enabled = true, 
    Key = "UP"
}

Config.ClientNotification = function(msg, type)
    ------------------------------------------------------------------------------------------
    -- Insert your Notification System here. (script uses types ("success", "inform", "error"))
    -------------------------------------------------------------------------------------------
  
    ----- T-Notify -----
    -- if type == "inform" then type = "info" end
    -- exports['t-notify']:Alert({style = type,  message = msg})
    ----------------------
  
    --------- mythic_notify ------
    --exports["mythic_notify"]:DoHudText(type, msg)
    --------------------------------
    TriggerEvent('KKF.UI.ShowNotification', type, msg)
  end
  
  Config.ServerNotification = function(msg, type, player)
    ------------------------------------------------------------------------------------------
    -- Insert your Notification System here. (script uses types ("success", "inform", "error"))
    -------------------------------------------------------------------------------------------
  
    --------- mythic_notify ------
    -- TriggerClientEvent("mythic_notify:client:SendAlert", player, {type = type, text = msg}) 
    --------------------------------
  
    ----- T-Notify ---------------
    --  if type == "inform" then type = "info" end
    --  TriggerClientEvent('t-notify:client:Custom', player, {style = type,title = 'SubZero Interactive:Garages',message = msg,duration = 1000})
    --------------------------------
    TriggerClientEvent('KKF.UI.ShowNotification', player, type, msg)
end


--- Resticts in index order
Config.RestrictedChannels = {
    { -- Channel 1
        police = true,
        ambulance = false
    },
    { -- Channel 2
        police = true,
        ambulance = false
    },
    { -- Channel 3
        police = true,
        ambulance = true
    },
    { -- Channel 4
        police = true,
        ambulance = true
    },
    { -- Channel 5
        police = true,
        ambulance = true
    }
}

Config.MaxFrequency = 500

Config.messages = {
    ["not on radio"] = "Te pole kanaliga ühendatud.",
    ["on radio"] = "Olete selle kanaliga juba ühendatud.",
    ["joined to radio"] = "Olete ühendatud kanalisse: ",
    ["restricted channel error"] = "Selle kanaliga ei saa ühendust!",
    ["invalid radio"] = "See sagedus pole saadaval.",
    ["you on radio"] = "Olete selle kanaliga juba ühendatud.",
    ["you leave"] = "Lahkusite kanalilt.",
    ['volume radio'] = 'Uus helitugevus: ',
    ['decrease radio volume'] = 'Raadio on juba seatud maksimaalsele helitugevusele.',
    ['increase radio volume'] = 'Raadio on juba seadistatud kõige madalamale helitugevusele.',
    ['increase decrease radio channel'] = 'Uus kanal: ',
}
