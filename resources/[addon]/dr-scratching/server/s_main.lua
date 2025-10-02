local players = {}
local totalSumChance = 0

local ox_inventory = exports.ox_inventory
CreateThread(function()
  for _,priceInfo in pairs(Config.Prices) do
    totalSumChance = totalSumChance + priceInfo['chance']
  end 
end)

RegisterNetEvent("dr-scratching:handler", function(returncooldown, cooldown)
  local _source <const> = source
  local tempsrc <const> = tonumber(_source)
  local playerName, playerIdentifier = GetPlayerName(_source), GetPlayerIdentifier(_source, 0)
  local xPlayer <const> = KKF.GetPlayerFromId(_source)
  local count <const> = ox_inventory:GetItem(source, 'scratch_ticket', nil, false).count
  local randomNumber <const> = math.random(1, totalSumChance)
  local add = 0

  if returncooldown then
    if Config.ShowCooldownNotifications then
      TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Oota...')
    end
    return
  end

  if count >= 1 then
    xPlayer.removeInventoryItem('scratch_ticket', 1)
    TriggerClientEvent("dr-scratching:setCooldown", _source)
    if Config.ShowUsedTicketNotification then
      -- xPlayer.showNotification(_U('used_scratchticket'))
    end
  else
    exports['kk-scripts']:sendLog(xPlayer.identifier, 'MUU', 'Mängija triggered event ilma kraapimispiletita')    return
  end

  TriggerClientEvent("dr-scratching:startScratchingEmote", _source)

  for key,priceInfo in pairs(Config.Prices) do
    local chance = priceInfo['chance']
    if randomNumber > add and randomNumber <= add + chance then
      local price_is_item = priceInfo['price']['item']['price_is_item']
      local amount = priceInfo['price']['item']['item_amount']
      local price_type, price = nil

      if not price_is_item then
          price = priceInfo['price']['price_money']
          price_type = 'money'
      else 
        price = priceInfo['price']['item']['item_label']
        price_type = 'item'
      end
      players[tempsrc] = tostring(price)
      TriggerClientEvent("dr-scratching:nuiOpenCard", _source, key, price, amount, price_type)
      return price
    end
    add = add + chance
  end
end)

RegisterNetEvent("dr-scratching:deposit", function(key, price, amount, type)
  local _source = source
  local playerName, playerIdentifier = GetPlayerName(_source), GetPlayerIdentifier(_source, 0)
  local xPlayer = KKF.GetPlayerFromId(_source)
  local tempsrc = tonumber(_source)
  local giveItem = false
  local giveMoney = false
  local passed = false
  local priceAmount = nil

  if players[tempsrc] ~= tostring(price) then
		exports['kk-scripts']:sendLog(xPlayer.identifier, 'MUU', 'Mängija triggered event, mille nimele on määratud mittevastav hind. Määratud hind: ' .. players[tempsrc] .. ' Requested price: ' .. tostring(price) .. '.')    players[tempsrc] = nil
    return
  end

  if type == 'money' then
    local winningAmount = tonumber(price)
    if winningAmount == nil or winningAmount < 0 then
      exports['kk-scripts']:sendLog(xPlayer.identifier, 'MUU', 'Kehtetu hind, esitatud rahahind: '.. winningAmount)players[tempsrc] = nil
      return
    end
    giveMoney = true
  else
    giveItem = true
  end
  for priceKey,priceInfo in pairs(Config.Prices) do
    if priceKey == key then
      priceAmount = priceInfo["price"]["item"]["item_amount"]
      
      if type == 'item' and giveItem == true then
        if tonumber(amount) == priceAmount then
          local price = priceInfo["price"]["item"]["item_name"]
          xPlayer.addInventoryItem(price, priceAmount)
        else
          exports['kk-scripts']:sendLog(xPlayer.identifier, 'MUU', 'Mängijal õnnestus triggerida deposit mittevastava asjaga.')
          players[tempsrc] = nil
          return
        end
      elseif type == 'money' and giveMoney == true then
        if tonumber(amount) == priceAmount then
          KKF.UpdateCheck(xPlayer.source, 'add', price)
          TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'info', 'Võitsid ja $'.. price ..' on lisatud sulle palgalehele.')
         
        else
          exports['kk-scripts']:sendLog(xPlayer.identifier, 'MUU', 'Mängijal õnnestus triggerida deposit mittevastava rahasummaga.')
          players[tempsrc] = nil
          return
        end
      end
    end
  end
    players[tempsrc] = nil
    return
end)

RegisterNetEvent("dr-scratching:stopScratching", function(price, amount, type)
  local _source = source
  local playerName, playerIdentifier = GetPlayerName(_source), GetPlayerIdentifier(_source, 0)
  local tempsrc = tonumber(_source)

  players[tempsrc] = nil
  return
end)