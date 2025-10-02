-- Callback dokumendi ja juhtumite toomiseks (ilma ID-kaardita)
lib.callback.register('kk-doj:fetchDocument', function(source)
    local xPlayer = KKF.GetPlayerFromId(source)
    if not xPlayer then 
        return nil, {}  -- ei ole mängijat, tagasta nil ja tühjad case'id
    end

    -- Tee identification objekt KKF-st saadud andmete põhjal
    local identification = {
        firstname = xPlayer.getName() or xPlayer.firstname or "N/A",  -- kasutaja eesnimi
        lastname = xPlayer.lastname or "N/A",                        -- perekonnanimi
        pid = xPlayer.identifier or 1,                                -- mingi unikaalne id
        dateofbirth = os.date("%Y-%m-%d", os.time() - 18*365*24*60*60) -- näiteks 18 aastat tagasi
    }

    -- SQL päring olemasolevate DOJ juhtumite jaoks
    local caseData = MySQL.Sync.fetchAll(
        'SELECT id, case_id, description, phone, mail, created_at FROM doj_cases WHERE identifier = @identifier',
        { ['@identifier'] = xPlayer.identifier }
    )

    return identification, caseData
end)

-- Callback info saatmiseks ja SQL insert (return versioon)
lib.callback.register('kk-doj:sendInfo', function(source, mail, phone, caseId, description)
    local xPlayer = KKF.GetPlayerFromId(source)
    if not xPlayer then 
        return false
    end

    local result = MySQL.Sync.execute(
        'INSERT INTO doj_cases (identifier, case_id, description, phone, mail, created_at) VALUES (@identifier, @case_id, @description, @phone, @mail, NOW())',
        {
            ['@identifier'] = xPlayer.identifier,
            ['@case_id'] = caseId,
            ['@description'] = description,
            ['@phone'] = phone,
            ['@mail'] = mail
        }
    )

    return result > 0
end)

-- Valikuline teavitamine
RegisterNetEvent('kk-doj:notify', function(targetSrc, type, msg)
    TriggerClientEvent('KKF.UI.ShowNotification', targetSrc, type, msg)
end)
