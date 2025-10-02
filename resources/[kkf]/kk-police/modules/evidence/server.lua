local evidence = {}
local systemTime = os.time()

lib.callback.register('kk-evidence:systemTime', function(source)
    return systemTime
end)

RegisterNetEvent('kk-evidence:server:saveEvidence', function(coords, interior, data)
    local id = math.random(100000, 999999)
    evidence[id] = {
        coords = coords,
        interior = interior,
        data = data,
        time = os.time()
    }

    TriggerClientEvent('kk-evidence:client:loadEvidence', -1, evidence)
end)

RegisterNetEvent('kk-evidence:server:collect', function(id)
    local xPlayer = KKF.GetPlayerFromId(source)
    -- Check if player has empty_evidence_bag and if so then remove it and add filled_evidence_bag with that metadata .. exports.ox_inventory:RemoveItem(source, 'empty_evidence_bag', 1)


    if evidence[id] then
        local evidenceData = evidence[id]

        evidence[id] = nil


        exports.ox_inventory:AddItem(source, 'filled_evidence_bag', 1, {
            evidenceId = id,
            date = os.date('%d/%m/%Y %H:%M', evidenceData.time),
            analyzed = false,
            type = evidenceData.data.type,
        })

        TriggerClientEvent('KKF.UI.ShowNotification', source, 'success', 'Sa korjasid üles tõendid!')
    else
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Tõendeid ei leitud!')
    end

    TriggerClientEvent('kk-evidence:client:loadEvidence', -1, evidence)
end)


lib.callback.register('kk-evidence:getEvidence', function(source)
    return evidence
end)

RegisterNetEvent('kk-evidence:server:removeEverything', function()
    evidence = {}

    TriggerClientEvent('kk-evidence:client:loadEvidence', -1, evidence)
end)


lib.callback.register('kk-evidence:analyse', function(source)
    print('[DEBUG] Callback "kk-evidence:analyse" triggered for source:', source)

    local xPlayer = KKF.GetPlayerFromId(source)
    if not xPlayer then
        return false
    end

    local inventory = exports.ox_inventory:Search(source, 'slots', 'filled_evidence_bag')

    local analyzedCount = 0

    if inventory and #inventory > 0 then
        for _, item in pairs(inventory) do
            if not item.metadata.analyzed then
                item.metadata.analyzed = true
                exports.ox_inventory:SetMetadata(source, item.slot, item.metadata)
                analyzedCount += 1
            else
            end
        end

        if analyzedCount > 0 then
            TriggerClientEvent('KKF.UI.ShowNotification', source, 'success', 'Kõik tõendid on analüüsitud ja salvestatud andmebaasi!')
        else
            TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Sul ei ole ühtegi analüüsimata tõendikotti!')
        end
    else
        TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', 'Sul ei ole ühtegi tõendikotti!')
    end
    local result = analyzedCount > 0
    return result
end)


