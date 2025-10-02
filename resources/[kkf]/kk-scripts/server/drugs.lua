
KKF.RegisterUsableItem('weed_joint', function(source)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)

    if xPlayer then
        TriggerClientEvent('kk-needs:removeNeed', src, 'stress', math.random(1000, 5000))
        TriggerClientEvent('kk-drugs:client:animation', src, 'weed_joint')
        xPlayer.removeInventoryItem('weed_joint', 1)
    end
end)

KKF.RegisterUsableItem('coke', function(source)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)

    if xPlayer then
        TriggerClientEvent('kk-drugs:client:animation', src, 'coke')
        xPlayer.removeInventoryItem('coke', 1)
    end
end)

KKF.RegisterUsableItem('moonshine', function(source)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)

    if xPlayer then
        TriggerClientEvent('kk-drugs:client:animation', src, 'moonshine')
        xPlayer.removeInventoryItem('moonshine', 1)
    end
end)

KKF.RegisterUsableItem('milk', function(source)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)

    if xPlayer then
        TriggerClientEvent('kk-drugs:client:animation', src, 'milk')
        xPlayer.removeInventoryItem('milk', 1)
		TriggerClientEvent('kk-needs:setNeed', xPlayer.source, 'drunk', 0)
    end
end)