-------------------------------------------------------- GANGI BAN

local gangDisabled = {
	'steam:110000xxxxxx',
}

--------------------------------------------------------

-------------------------------------------------------- POLICE BAN

local policeDisabled = {
	'steam:110000118dbfb63',
	'steam:11000014d26d5f2',
	'steam:11000013b1fbbe6',
	'steam:110000156dff0d0',
	'steam:110000144dee980',
	'steam:11000016ade9d59',
	'steam:110000169b031bc',
	'steam:11000014a9dac2d',
	'steam:1100001411a209d',
	'steam:11000014069c06b',
	'steam:110000148321427',
	'steam:110000149121ff2',
	'steam:11000015a41ca5a',
	'steam:1100001601ef326',
	'steam:110000118dbfb63',
	'steam:1100001429839db',
	'steam:110000142495ba1',
	'steam:11000015bd977c4',
	'steam:11000014a0064be',
	'steam:1100001640ca072',
	'steam:11000015ad4f03c',
	'steam:1100001178f8c1b',
	'steam:11000010125103c',
	'steam:110000144839f6c',
	'steam:110000155a5895f',
	'steam:110000136db57d9',
	'steam:1100001479d4516',
	'steam:11000013c1a221e',
	'steam:110000111b4ec54',
	'steam:11000013c1a221e',
	'steam:11000014a23c41e',
	'steam:11000013c2b0cdc',
	'steam:1100001442ed39f',
	'steam:11000014597a0b8'
}

--------------------------------------------------------

local accounts = {}

local function saveFactionData(faction)
	MySQL.update.await('UPDATE jobs SET money = ? WHERE name = ?', {accounts[faction].money, faction})
end

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
	local result = MySQL.query.await('SELECT name, money FROM jobs', {playerIdentifier})

	for k,v in pairs(result) do
		accounts[v.name] = {}
		accounts[v.name].money = v.money
	end
end)

SetInterval(function()
    local players = ESX.GetPlayers()

    for _, src in pairs(players) do
        local xPlayer = ESX.GetPlayerFromId(src)

        if xPlayer and xPlayer.job and xPlayer.job.name ~= 'none' and xPlayer.job.onDuty and xPlayer.job.type == 'job' then
            local playerMinutes = MySQL.prepare.await(
                'SELECT minutes FROM work_times WHERE DATE(date) = CURDATE() AND pid = ? AND faction = ?', 
                { xPlayer.identifier, xPlayer.job.name }
            )

            if playerMinutes then
                MySQL.update.await(
                    'UPDATE work_times SET minutes = minutes + 1 WHERE DATE(date) = CURDATE() AND pid = ? AND faction = ?', 
                    { xPlayer.identifier, xPlayer.job.name }
                )
            else
                MySQL.insert.await(
                    'INSERT INTO work_times (pid, faction, minutes) VALUES (?, ?, 1)', 
                    { xPlayer.identifier, xPlayer.job.name }
                )
            end
        end
    end
end, 60000)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    for k,v in pairs(accounts) do
        MySQL.update.await('UPDATE jobs SET money = ? WHERE name = ?', {v.money, k})
    end
end)

local function getMoney(faction)
    local faction = accounts[faction]

    if faction then
        return faction.money
    else
        return 0
    end
end

exports('getMoney', getMoney)

AddEventHandler('ESX.Faction.GetMoney', function(faction, cb)
    local faction = accounts[faction]

    if faction then
        cb(faction.money)
    else
        cb(0)
    end
end)

AddEventHandler('ESX.Faction.RemoveMoney', function(faction, amount)
    local account = accounts[faction]

    if account then
        account.money = account.money - amount; saveFactionData(faction)
    end
end)

AddEventHandler('ESX.Faction.AddMoney', function(faction, amount)
    local account = accounts[faction]

    if account then
        account.money = account.money + amount; saveFactionData(faction)
    end
end)

lib.callback.register('kk-factions:loadMembers', function(source)
    local kPlayer = ESX.GetPlayerFromId(source)
    if not kPlayer then return {}, nil end

    local jobs = ESX.GetJobs()
    local employees = {}

    local result = MySQL.query.await(
        'SELECT * FROM users WHERE LOWER(`societies`) LIKE ? ORDER BY pid DESC',
        { string.lower('%"' .. kPlayer.job.name .. '"%') }
    )

    for k, v in pairs(result) do
        local count = #employees + 1

        -- Turvaline JSON decode
        local factions = {}
        if v.factions then factions = json.decode(v.factions) or {} end

        local callsigns = {}
        if v.callsign then callsigns = json.decode(v.callsign) or {} end

        -- Õige ESX player objekt
        local xTarget = ESX.GetPlayerFromIdentifier(v.identifier)

        -- grade ja grade_label turvaliselt
        local grade = factions[kPlayer.job.name] or 0
        local grade_label = 'n/a'
        if jobs[kPlayer.job.name] and jobs[kPlayer.job.name].grades then
            local gradeInfo = jobs[kPlayer.job.name].grades[tostring(grade)]
            if gradeInfo and gradeInfo.label then
                grade_label = gradeInfo.label
            end
        end

        employees[count] = {
            pid = v.pid,
            callsign = callsigns[kPlayer.job.name] or "PUUDUB",
            name = v.firstname .. ' ' .. v.lastname,
            average_hours = MySQL.prepare.await(
                'SELECT AVG(minutes) / 60 AS average_hours FROM `work_times` WHERE date >= NOW() - INTERVAL 1 WEEK AND pid = ? AND faction = ?;',
                {v.pid, kPlayer.job.name}
            ) or 0,
            lastWork = v.lastwork or 'Puudub',
            job = {
                name = kPlayer.job.name,
                label = jobs[kPlayer.job.name] and jobs[kPlayer.job.name].label or 'n/a',
                grade = grade,
                grade_label = grade_label
            },
            online = xTarget and (
                        (kPlayer.job.type == 'gang' and xTarget.job.name == kPlayer.job.name) or
						(kPlayer.job.type == 'job' and xTarget.job.name == kPlayer.job.name and xTarget.job.onDuty)
                     ) or false
        }
    end

    return employees, kPlayer.job.name
end)



local function containsOnlyNumbers(inputString)
    return inputString:match("^%d+$") ~= nil
end

lib.callback.register('kk-factions:changeCallsign', function(source, target, callsign)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
		if kPlayer.job.permissions.changeMemberGrade then
			local callsigns = json.decode(MySQL.prepare.await('SELECT callsign FROM users WHERE pid = ?', { target }))
			
			if containsOnlyNumbers(callsign) then
				callsigns[kPlayer.job.name] = callsign
				exports['kk-factions']:sendLog(kPlayer.source, 'KUTSUNG', 'Muutis ' .. target .. ' kutsungiks ' .. callsign .. '.')

				MySQL.update.await('UPDATE users SET callsign = ? WHERE pid = ?', {json.encode(callsigns), target})
				TriggerEvent('kk-mdt:server:updateDepartment', target)

				local xTarget = ESX.GetPlayerFromIdentifier(target)
	
				if xTarget then
					if xTarget.job.name == kPlayer.job.name then
						xTarget.setJob(kPlayer.job.name, xTarget.job.grade)
					end
	
					TriggerClientEvent('KKF.UI.ShowNotification', xTarget.source, 'info', 'Teie kutsungit muudeti!')
				end
	
				return true
			else
				TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Kutsungi muutmine', 'Ebakorretkne kutsung!')
				return false
			end
		else
			TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Kutsungi muutmine', 'Teil ei ole piisavalt õigusi!')
			return false
		end
    else
        return false
    end
end)

lib.callback.register('kk-factions:requestCallsign', function(source, target)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
		if kPlayer.job.permissions.changeMemberGrade then
			local callsigns = json.decode(MySQL.prepare.await('SELECT callsign FROM users WHERE pid = ?', { target }))

			return callsigns[kPlayer.job.name] or '000'
		else
			TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Kutsungi muutmine', 'Teil ei ole piisavalt õigusi!')
			return 69
		end
    else
        return 69
    end
end)

lib.callback.register('kk-factions:requestRanks', function(source)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
		local ranks = MySQL.query.await('SELECT * FROM job_grades WHERE job_name = ? ORDER BY grade ASC', {kPlayer.job.name})
		
		if ranks then
			for i = 1, #ranks do
				ranks[i].permissions = json.decode(ranks[i].permissions)
			end
			
			return ranks
		else
			return {}
		end
    else
        return {}
    end
end) 

lib.callback.register('kk-factions:editRank', function(source, id)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
		if kPlayer.job.permissions.editGrade then
			local rank = MySQL.prepare.await('SELECT * FROM job_grades WHERE job_name = ? AND grade = ?', {kPlayer.job.name, id})
			
			if rank then
				rank.permissions = json.decode(rank.permissions)
				
				return rank
			else
				return {}
			end
		else
			TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Auastme redigeerimine', 'Teil ei ole piisavalt õigusi!')
			return {}
		end
    else
        return {}
    end
end)

lib.callback.register('kk-factions:loadVehicles', function(source)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
		if kPlayer.job.permissions.function1 then
			local vehicles = MySQL.query.await('SELECT vehicle, plate, stored, location, impoundable, police_impound FROM user_vehicles WHERE owner = ?', {'faction_' .. kPlayer.job.name})
			
			if vehicles then
				for i = 1, #vehicles do
					vehicles[i].location = vehicles[i].stored and exports['kk-garages']:getGarageLabel(vehicles[i].location) or vehicles[i].impoundable and 'KINDLUSTUS' or vehicles[i].police_impound and 'TEISALDUS' or 'TEADMATA'
					vehicles[i].vehicle = json.decode(vehicles[i].vehicle)
					vehicles[i].model = vehicles[i].vehicle.model -- lib.callback.await('ESX.RPC.GetLabelText', kPlayer.source, vehicles[i].vehicle.model)
					vehicles[i].vehicle = nil
				end
				
				return vehicles
			else
				return {}
			end
		else
			TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Omatud sõidukid', 'Teil ei ole piisavalt õigusi!')
			return {}
		end
    else
        return {}
    end
end)

lib.callback.register('kk-factions:loadWorkTimes', function(source, target)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
		if kPlayer.job.permissions.function3 then
			local returnable = {
				times = MySQL.query.await('SELECT * FROM work_times WHERE pid = ? AND faction = ? ORDER BY id DESC', {target, kPlayer.job.name}),
				month = 0,
				week = 0
			}

			local month = MySQL.query.await('SELECT minutes FROM work_times WHERE date >= NOW() - INTERVAL 1 MONTH AND pid = ? AND faction = ?', {target, kPlayer.job.name})

			for i = 1, #month do
				returnable.month += month[i].minutes
			end
			
			local week = MySQL.query.await('SELECT minutes FROM work_times WHERE date >= NOW() - INTERVAL 1 WEEK AND pid = ? AND faction = ?', {target, kPlayer.job.name})

			for i = 1, #week do
				returnable.week += week[i].minutes
			end

			return returnable
		else
			TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Liikme tööajad', 'Teil ei ole piisavalt õigusi!')
			return false
		end
    else
        return false
    end
end)

local function tableCount(table)
    local count = 0

    for k,v in pairs(table) do
        count += 1
    end

    return count
end

local function checkBlacklist(identifier)
	local returnable = false

	for i = 1, #gangDisabled do
		if gangDisabled[i] == identifier then
			returnable = true
			break
		end
	end

	return returnable
end

local function checkPoliceBlack(identifier)
	local returnable = false

	for i = 1, #policeDisabled do
		if policeDisabled[i] == identifier then
			returnable = true
			break
		end
	end

	return returnable
end

lib.callback.register('kk-factions:recruitPlayer', function(source, target, rank)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
		if kPlayer.job.permissions.addMember then
			local xTarget = ESX.GetPlayerFromId(target)

			if xTarget then
				local jobs = ESX.GetJobs()
				local person = MySQL.prepare.await('SELECT pid, identifier, societies, job, firstname, lastname FROM users WHERE pid = ?', {xTarget.identifier})

				if person then
					local factions = json.decode(person.factions)

					if not factions[kPlayer.job.name] then
						local factionSlots = MySQL.prepare.await('SELECT faction_slots FROM users WHERE pid = ?', {xTarget.identifier})

						if factionSlots > tableCount(factions) or kPlayer.job.type == 'organization' then
							local factionCount = MySQL.Sync.fetchScalar('SELECT COUNT(*) FROM users WHERE LOWER(`societies`) LIKE ?;', { string.lower('%"' .. kPlayer.job.name .. '"%') })

							if factionCount < kPlayer.job.limit or kPlayer.job.type == 'organization' then
								if (kPlayer.job.type == 'gang' and not checkBlacklist(xTarget.steamid)) or kPlayer.job.type ~= 'gang' then
									if (kPlayer.job.name == 'police' and not checkPoliceBlack(xTarget.steamid)) or kPlayer.job.name ~= 'police' then
										if tonumber(rank) ~= 99 then
											factions[kPlayer.job.name] = rank
											MySQL.update.await('UPDATE users SET societies = ? WHERE pid = ?', {json.encode(factions), xTarget.identifier})

											exports['kk-factions']:sendLog(kPlayer.source, 'FRAKTSIOONI LISAMINE', person.firstname .. ' ' .. person.lastname .. ' (' .. person.pid .. ') ' .. ' auastmele ' .. jobs[kPlayer.job.name].grades[rank].label .. '.')
											TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'success', 'Fraktsiooni lisamine', 'Lisasite ' .. person.firstname .. ' ' .. person.lastname .. ' fraktsiooni auastmele ' .. jobs[kPlayer.job.name].grades[rank].label .. '.')
											TriggerClientEvent('KKF.UI.ShowNotification', xTarget.source, 'info', 'Teid lisati fraktsiooni ' .. kPlayer.job.label .. ' auastmele ' .. jobs[kPlayer.job.name].grades[rank].label .. '.')

											local discord = MySQL.prepare.await('SELECT `discord` FROM `ucp_users` WHERE `identifier` = ?', { person.identifier })

											if discord then
												if cfg.discordRanks[kPlayer.job.name] then
													exports['kk-scripts']:addRole(discord, cfg.discordRanks[kPlayer.job.name])
												end
											end

											return true
										else
											TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Fraktsiooni lisamine', 'Te ei saa kedagi Admin auastmele värvata!')
											return false
										end
									else
										TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Fraktsiooni lisamine', 'Antud isikul ei ole võimalik liituda politsei fraktsiooniga!')
										return false
									end
								else
									TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Fraktsiooni lisamine', 'Antud isikul ei ole võimalik liituda grupeeringutega!')
									return false
								end
							else
								TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Fraktsiooni lisamine', 'Fraktsiooni kohad on täis! (' .. factionCount .. '/' .. kPlayer.job.limit .. ')')
								return false
							end
						else
							TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Fraktsiooni lisamine', 'Valitud isiku fraktsioonide arv ületab maksimumi!')
							return false
						end
					else
						TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Fraktsiooni lisamine', 'Valitud isik on juba fraktsiooni liige!')
						return false
					end
				else
					return false
				end	
			else
				TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Fraktsiooni lisamine', 'Valitud isik ei ole enam siin!')
				return false
			end
		else
			TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Liikme auastme muutmine', 'Teil ei ole piisavalt õigusi!')
			return false
		end
	else
		return false
	end
end)
lib.callback.register('kk-factions:setRank', function(source, target, rank)
    local kPlayer = ESX.GetPlayerFromId(source)
    if not kPlayer then return false end

    -- Kontrolli õigusi
    if not kPlayer.job.permissions.changeMemberGrade then
        TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Liikme auastme muutmine', 'Teil ei ole piisavalt õigusi!')
        return false
    end

    -- Võta sihtisik
    local person = MySQL.prepare.await('SELECT pid, societies, job, firstname, lastname FROM users WHERE pid = ?', {target})
    if not person then return false end

    -- Turvaline JSON decode
    local factions = {}
    if person.societies and person.societies ~= '' then
        factions = json.decode(person.societies) or {}
    end

    -- Kontrolli, kas isik kuulub sinu fraktsiooni
    if not factions[kPlayer.job.name] then
        TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Liikme auastme muutmine', 'Valitud isik ei kuulu sinu fraktsiooni!')
        return false
    end

    local sourceRank = kPlayer.job.grade or 0
    local targetRank = tonumber(factions[kPlayer.job.name]) or 0
    rank = tonumber(rank) or 0

    -- Kontrolli õigusi
    if not (sourceRank > targetRank and sourceRank > rank or sourceRank == 99) then
        TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Liikme auastme muutmine', 'Teil ei ole piisavalt õigusi!')
        return false
    end

    local jobs = ESX.GetJobs()
    local xTarget = ESX.GetPlayerFromIdentifier(target)

    -- Kui mängija online
    if xTarget then
        if xTarget.job.name == kPlayer.job.name then
            xTarget.setJob(kPlayer.job.name, rank)
        end
        TriggerClientEvent('KKF.UI.ShowNotification', xTarget.source, 'info', 'Teile seati fraktsioonis ' .. kPlayer.job.label .. ' auaste ' .. (jobs[kPlayer.job.name].grades[tostring(rank)] and jobs[kPlayer.job.name].grades[tostring(rank)].label or 'n/a') .. '.')
    else
        -- Offline uuendus
        if person.job == kPlayer.job.name then
            MySQL.update.await('UPDATE users SET job = ?, job_grade = ? WHERE pid = ?', {kPlayer.job.name, rank, target})
        end
    end

    -- Uuenda societies JSON
    factions[kPlayer.job.name] = rank
    MySQL.update.await('UPDATE users SET societies = ? WHERE pid = ?', {json.encode(factions), target})

    -- Logimine ja klient teavitamine
    exports['kk-factions']:sendLog(kPlayer.source, 'LIIKME AUASTME MUUTMINE', person.firstname .. ' ' .. person.lastname .. '(' .. person.pid .. ') ' .. ' auastmele ' .. (jobs[kPlayer.job.name].grades[tostring(rank)] and jobs[kPlayer.job.name].grades[tostring(rank)].label or 'n/a') .. '.')
    TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'success', 'Liikme auastme muutmine', 'Seadsite ' .. person.firstname .. ' ' .. person.lastname .. ' auastmeks ' .. (jobs[kPlayer.job.name].grades[tostring(rank)] and jobs[kPlayer.job.name].grades[tostring(rank)].label or 'n/a') .. '.')

    return true
end)

lib.callback.register('kk-factions:firePerson', function(source, target)
    local kPlayer = ESX.GetPlayerFromId(source)
    if not kPlayer then return false end

    -- Kontrolli õigusi
    if not kPlayer.job.permissions.removeMember then
        TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Fraktsioonist eemaldamine', 'Teil ei ole piisavalt õigusi!')
        return false
    end

    -- Võta sihtisik
    local person = MySQL.prepare.await('SELECT pid, societies, job, job_grade, firstname, lastname FROM users WHERE pid = ?', {target})
    if not person then return false end

    -- Turvaline JSON decode
    local factions = {}
    if person.societies then
        factions = json.decode(person.societies) or {}
    end

    -- Kontrolli, kas isik kuulub sinu fraktsiooni
    if not factions[kPlayer.job.name] then
        TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Fraktsioonist eemaldamine', 'Valitud isik ei kuulu sinu fraktsiooni!')
        return false
    end

    local sourceRank = kPlayer.job.grade or 0
    local targetRank = tonumber(factions[kPlayer.job.name]) or 0

    if sourceRank <= targetRank and sourceRank ~= 99 then
        TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Fraktsioonist eemaldamine', 'Teil ei ole piisavalt õigusi!')
        return false
    end

    -- Võta mängija objekt kui online
    local xTarget = ESX.GetPlayerFromIdentifier(target)
    if xTarget then
        -- Pane job “unemployed” ja grade 0
        xTarget.setJob('unemployed', 0)
        TriggerClientEvent('KKF.UI.ShowNotification', xTarget.source, 'info', 'Teid eemaldati ' .. kPlayer.job.label .. ' fraktsioonist.')
    else
        -- Offline update: tööta samuti
        MySQL.update.await('UPDATE users SET job = ?, job_grade = ? WHERE pid = ?', {'unemployed', 0, target})
    end

    -- Spetsiifilised fraktsioonid (näiteks taxi)
    if kPlayer.job.name == 'taxi' then
        MySQL.Sync.execute('DELETE FROM taxi_job WHERE pid = ?;', {target})
    end

    -- Eemalda fraktsioonist societies JSON
    factions[kPlayer.job.name] = nil
    MySQL.update.await('UPDATE users SET societies = ? WHERE pid = ?', {json.encode(factions), target})

    -- Logimine ja sündmused
    exports['kk-factions']:sendLog(kPlayer.source, 'LIIKME EEMALDAMINE', person.firstname .. ' ' .. person.lastname .. '(' .. person.pid .. ')')
    TriggerEvent('kk-factions:server:handler', 'fireMember', kPlayer.job.name, target)
    TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'success', 'Fraktsioonist eemaldamine', 'Eemaldasite ' .. person.firstname .. ' ' .. person.lastname .. ' fraktsioonist.')

    -- Gang / police spetsiifiline disabled
    if kPlayer.job.type == 'gang' or kPlayer.job.name == 'police' then
        MySQL.update.await('UPDATE users SET disabled = ? WHERE pid = ?', {1, target})
    end

    return true
end)



lib.callback.register('kk-factions:searchLogs', function(source, pid, search, page)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
		if kPlayer.job.permissions.function9 then
			if pid ~= '' or search ~= '' then
				local limit = (page - 1) * 5
				local sql = 'WHERE faction = @faction'

				if pid ~= '' and search ~= '' then
					sql = 'WHERE faction = @faction AND pid LIKE @pid AND text LIKE @search'
				elseif pid ~= '' and search == '' then
					sql = 'WHERE faction = @faction AND pid LIKE @pid'
				elseif pid == '' and search ~= '' then
					sql = 'WHERE faction = @faction AND text LIKE @search'
				end

				local result = MySQL.query.await('SELECT * FROM society_logs ' .. sql .. ' ORDER BY id DESC LIMIT ' .. limit .. ', 5', {
					['@faction'] = kPlayer.job.name,
					['@pid'] = '%' .. pid .. '%',
					['@search'] = '%' .. search .. '%'
				})

				if result then
					local count = MySQL.Sync.fetchScalar('SELECT COUNT(*) FROM society_logs ' .. sql, {
						['@faction'] = kPlayer.job.name,
						['@pid'] = '%' .. pid .. '%',
						['@search'] = '%' .. search .. '%'
					})

					return {logs = result, count = count / 5, page = page}
				else
					TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Logid', 'Süsteemis ei ole ühtegi sissekannet!')
					return false
				end
			else
				TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Logid', 'Tühja päringut ei saa esitada!')
				return false
			end
		else
			TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Logid', 'Teil ei ole piisavalt õigusi!')
			return false
		end
    else
        return false
    end
end)

lib.callback.register('kk-factions:loadAnnouncments', function(source)
    local Player = ESX.GetPlayerFromId(source)

    if Player then
        if Player.job.permissions.intranet then
            return MySQL.query.await('SELECT * FROM faction_announcements WHERE faction = ?', {Player.job.name})
        else
            return false
        end
	else 
		return false
    end
end)

lib.callback.register('kk-factions:deleteAnnouncement', function(source, id)
    local Player = ESX.GetPlayerFromId(source)
    if not Player then return false end

    if not Player.job.permissions.intranet_admin then
        TriggerClientEvent('kk-factions:client:sendNotification', Player.source, 'error', 'Teadaande kustutamine', 'Teil ei ole piisavalt õigusi!')
        return false
    end
    exports['kk-factions']:sendLog(Player.source, 'SISEVEEB', 'Teadaande ' .. id .. ' kustutamine.')
    MySQL.Async.execute('DELETE FROM faction_announcements WHERE id = ?', {id})
    local playerIds = ESX.GetPlayers('job', Player.job.name) or {}
    for _, pid in ipairs(playerIds) do
        local xTarget = ESX.GetPlayerFromId(pid)
        if xTarget and xTarget.job.onDuty and xTarget.job.permissions.intranet and xTarget.source ~= Player.source then
            TriggerClientEvent('kk-factions:client:reloadAnnouncments', xTarget.source)
        end
    end

    TriggerClientEvent('kk-factions:client:sendNotification', Player.source, 'success', 'Teadaande kustutamine', 'Teadaanne kustutatud!')
    return true
end)


lib.callback.register('kk-factions:createAnnouncement', function(source, title, description)
	local kPlayer = ESX.GetPlayerFromId(source)
	if not kPlayer then return false end

	if not kPlayer.job.permissions.intranet_admin then
		TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Teadaande loomine', 'Teil ei ole piisavalt õigusi!')
		return false
	end

	if title == '' or description == '' then
		TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Teadaande loomine', 'Sisesta kõik vajalikud andmed!')
		return false
	end

	-- Lisa teadaanne andmebaasi
	exports['kk-factions']:sendLog(kPlayer.source, 'SISEVEEB', 'Teadaande loomine.')
	MySQL.insert.await('INSERT INTO faction_announcements (sender, faction, title, context) VALUES (?, ?, ?, ?)', 
		{kPlayer.name, kPlayer.job.name, title, description})

	-- Võta kõik sama tööga mängijad ja saada sündmus
	local playerIds = ESX.GetPlayers('job', kPlayer.job.name) or {}
	for _, pid in ipairs(playerIds) do
		local xTarget = ESX.GetPlayerFromId(pid) -- nüüd on xTarget objekt
		if xTarget and xTarget.job.onDuty and xTarget.job.permissions.intranet and xTarget.source ~= kPlayer.source then
			TriggerClientEvent('kk-factions:client:reloadAnnouncments', xTarget.source)
			TriggerClientEvent('InteractSound_CL:PlayOnOne', xTarget.source, 'MDT', 0.3)
			TriggerClientEvent('KKF.UI.ShowNotification', xTarget.source, 'info', 'Uus teadaanne siseveebis teemal ' .. title .. '!', 5000)
		end
	end

	TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'success', 'Teadaande loomine', 'Teadaanne loodud!')
	return true
end)


lib.callback.register('kk-factions:finishAnnouncementEditing', function(source, id, title, description)
	local kPlayer = ESX.GetPlayerFromId(source)
	if not kPlayer then return false end

	if not kPlayer.job.permissions.intranet_admin then
		TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Teadaande muutmine', 'Teil ei ole piisavalt õigusi!')
		return false
	end

	if title == '' or description == '' then
		TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Teadaande muutmine', 'Sisesta kõik vajalikud andmed!')
		return false
	end

	-- Uuendame andmebaasis
	exports['kk-factions']:sendLog(kPlayer.source, 'SISEVEEB', 'Teadaande redigeerimine (' .. id .. ').')
	MySQL.update.await('UPDATE faction_announcements SET sender = ?, title = ?, context = ?, time = CURRENT_TIME() WHERE id = ?', 
		{kPlayer.name, title, description, id})

	local playerIds = ESX.GetPlayers('job', kPlayer.job.name) or {}
	for _, pid in ipairs(playerIds) do
		local xTarget = ESX.GetPlayerFromId(pid)
		if xTarget and xTarget.job.onDuty and xTarget.job.permissions.intranet and xTarget.source ~= kPlayer.source then
			TriggerClientEvent('kk-factions:client:reloadAnnouncments', xTarget.source)
			TriggerClientEvent('InteractSound_CL:PlayOnOne', xTarget.source, 'MDT', 0.3)
			TriggerClientEvent('KKF.UI.ShowNotification', xTarget.source, 'info', 'Uus teadaanne siseveebis teemal ' .. title .. '!', 5000)
		end
	end

	TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'success', 'Teadaande muutmine', 'Teadaanne muudetud!')
	return true
end)


lib.callback.register('kk-factions:editAnnouncement', function(source, id)
	local kPlayer = ESX.GetPlayerFromId(source)

	if kPlayer then
		return MySQL.prepare.await('SELECT title, context FROM faction_announcements WHERE id = ?', {id})
	else
		return false
	end
end)
ESX.CreateRank = function(jobName, gradeId, label, short, salary, permissions)
    local exists = MySQL.prepare.await('SELECT grade FROM job_grades WHERE job_name = ? AND grade = ?', {jobName, gradeId})
    if exists then
        return false
    end

    MySQL.insert.await('INSERT INTO job_grades (job_name, grade, label, short, salary, permissions) VALUES (?, ?, ?, ?, ?, ?)', {
        jobName,
        gradeId,
        label,
        short,
        salary,
        json.encode(permissions)
    })

    ESX.ReloadJobs()
    return true
end

lib.callback.register('kk-factions:createRank', function(source, id, label, short, salary, permissions)
	local kPlayer = ESX.GetPlayerFromId(source)

	if kPlayer then
		if kPlayer.job.permissions.addGrade then
			if id ~= '' and label ~= '' and salary ~= '' then
				local sourceRank = kPlayer.job.grade or 0
				local targetRank = tonumber(id)

				if sourceRank > targetRank or sourceRank == 99 then
					local status = ESX.CreateRank(kPlayer.job.name, id, label, short, salary, permissions)

					if status then
						exports['kk-factions']:sendLog(kPlayer.source, 'AUASTME LOOMINE', 'ID: ' .. id .. '; NIMI: ' .. label .. '; LÜHEND: ' .. short .. '; PALK: ' .. salary .. ';')
						TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'success', 'Auastme loomine', 'Lõite uue auastme nimega ' .. label .. '!')
						return true
					else
						TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Auastme loomine', 'Antud ID-ga auaste juba eksisteerib!')
						return false
					end
				else
					TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Auastme loomine', 'Teil ei ole piisavalt õigusi!')
					return false
				end
			else
				TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Auastme loomine', 'Sisesta kõik vajalikud andmed!')
				return false
			end
		else
			TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Auastme loomine', 'Teil ei ole piisavalt õigusi!')
			return false
		end
	else
		return false
	end
end)
ESX.DeleteRank = function(jobName, gradeId)
    local hasMembers = MySQL.scalar.await('SELECT COUNT(*) FROM users WHERE job = ? AND job_grade = ?', {
        jobName, gradeId
    })

    if hasMembers > 0 then
        return false
    end

    local affectedRows = MySQL.update.await('DELETE FROM job_grades WHERE job_name = ? AND grade = ?', {
        jobName, gradeId
    })

    if affectedRows > 0 then
        return gradeId
    end

    return false
end
lib.callback.register('kk-factions:deleteRank', function(source, id)
	local kPlayer = ESX.GetPlayerFromId(source)

	if kPlayer then
		if kPlayer.job.permissions.deleteGrade then
			local sourceRank = kPlayer.job.grade or 0
			local targetRank = tonumber(id) or 0

			if sourceRank > targetRank or sourceRank == 99 then
				local status = ESX.DeleteRank(kPlayer.job.name, id)

				if status then
					exports['kk-factions']:sendLog(kPlayer.source, 'AUASTME EEMALDAMINE', 'ID: ' .. id .. ';')
					TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'success', 'Auastme eemaldamine', 'Kustutasite auastme ' .. status .. '!')
					return true
				else
					TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Auastme eemaldamine', 'Enne auastme kustutamist eemalda liikmed vastavalt auastmelt!')
					return false
				end
			else
				TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Auastme eemaldamine', 'Teil ei ole piisavalt õigusi!')
				return false
			end
		else
			TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Auastme eemaldamine', 'Teil ei ole piisavalt õigusi!')
			return false
		end
	else
		return false
	end
end)

lib.callback.register('kk-factions:saveRank', function(source, id, label, short, salary, permissions)
    local kPlayer = ESX.GetPlayerFromId(source)
    if not kPlayer then return false end

    if not kPlayer.job.permissions.editGrade then
        TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Auastme redigeerimine', 'Teil ei ole piisavalt õigusi!')
        return false
    end

    if label == '' or salary == '' then
        TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Auastme redigeerimine', 'Kõik vajalikud andmed peavad olema täidetud!')
        return false
    end

    local sourceRank = kPlayer.job.grade or 0
    local targetRank = tonumber(id) or 0

    if sourceRank <= targetRank and sourceRank ~= 99 then
        TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Auastme redigeerimine', 'Teil ei ole piisavalt õigusi!')
        return false
    end

    local status = MySQL.prepare.await('SELECT label FROM job_grades WHERE grade = ? AND job_name = ?;', { id, kPlayer.job.name })
    if not status then
        TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Auastme redigeerimine', 'Auaste ei eksisteeri enam!')
        return false
    end

    -- Update job grade
    MySQL.update.await('UPDATE job_grades SET label = ?, short = ?, salary = ?, permissions = ? WHERE grade = ? AND job_name = ?', {
        label, short, salary, json.encode(permissions), id, kPlayer.job.name
    })
    ESX.ReloadJobs()

    for _, playerId in pairs(ESX.GetPlayers()) do
        local xTarget = ESX.GetPlayerFromId(playerId)
        if xTarget and xTarget.job.name == kPlayer.job.name and xTarget.job.grade == id then
            xTarget.setJob(kPlayer.job.name, id)
        end
    end

    exports['kk-factions']:sendLog(kPlayer.source, 'AUASTME REDIGEERIMINE', 'ID: ' .. id .. '; NIMI: ' .. label .. '; PALK: ' .. salary .. ';')
    TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'success', 'Auastme redigeerimine', 'Lõpetasite auastme redigeerimise!')
    return true
end)


local function getData(model, faction)
	local returnable = {} 

	for k,v in pairs(cfg.vehicles[faction]) do
		if k == model then
			returnable = v
		end
	end

	return returnable
end

lib.callback.register('kk-factions:buyVehicle', function(source, model, garage)
	local kPlayer = ESX.GetPlayerFromId(source)

	if kPlayer then
		if kPlayer.job.permissions.function2 then
			local data = getData(model, kPlayer.job.name)
			local realPrice = data.price + ESX.Math.Round(ESX.Math.Percent(exports['kk-taxes']:getTax('primary').value, data.price))

			TriggerEvent('ESX.Faction.GetMoney', kPlayer.job.name, function(money)
				if money >= realPrice then
					local plate = exports['kk-vehicleshop']:generatePlate()
					local vehicleLabel = lib.callback.await('ESX.RPC.GetLabelText', kPlayer.source, model)

					TriggerEvent('ESX.Faction.RemoveMoney', kPlayer.job.name, realPrice)

					exports['kk-factions']:sendLog(kPlayer.source, 'SÕIDUKI OST', 'Sõiduki MUDEL: ' .. vehicleLabel .. '; REG.NR ' .. plate .. '; HIND: $' .. realPrice .. '.')
					exports['kk-scripts']:sendLog(kPlayer.identifier, 'FRAKTSIOONID', 'Soetas sõiduki (MUDEL: ' .. vehicleLabel .. '; PLATE: ' .. plate .. ') $' .. realPrice .. ' eest.')

					MySQL.insert.await('INSERT INTO user_vehicles (owner, vehicle, plate, type, stored, location) VALUES (?, ?, ?, ?, ?, ?)', {
						'faction_' .. kPlayer.job.name,
						json.encode({model = GetHashKey(model), plate = plate}),
						plate,
						data.type,
						true,
						garage
					})

					exports['kk-vehicles']:addKey(kPlayer.source, plate)
					MySQL.insert.await('INSERT INTO `user_vehicles_data` (`plate`) VALUES (?)', { plate })

					TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'success', 'Sõiduki soetamine', 'Soetasite sõiduki ' .. vehicleLabel .. ' hinnaga $' .. realPrice .. '.')
					return true
				else
					TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Sõiduki soetamine', 'Fraktsioonis ei ole piisavalt raha!')
					return false
				end
			end)
		else
			TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Sõiduki soetamine', 'Teil ei ole piisavalt õigusi!')
			return false
		end
	else
		return false
	end
end)

lib.callback.register('kk-factions:changeFaction', function(source, item)
	local kPlayer = ESX.GetPlayerFromId(source)

	if kPlayer then
		if item.job ~= kPlayer.job.name then
			local result = MySQL.prepare.await('SELECT societies FROM users WHERE pid = ?', {kPlayer.identifier})
			local factions = json.decode(result); local jobs = ESX.GetJobs()

			if factions[item.job] == item.grade then
				kPlayer.setJob(item.job, item.grade);

				TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'success', 'Fraktsiooni valimine', 'Valisite uueks aktiivseks fraktsiooniks ' .. jobs[item.job].label .. '.')
				return true
			else
				TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Fraktsiooni valimine', 'Te ei kuulu enam antud fraktsiooni!')
				return false
			end
		else
			TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Fraktsiooni valimine', 'Olete juba antud fraktsiooni valinud aktiivseks!')
			return false
		end
	else
		return false
	end
end)

lib.callback.register('kk-factions:leaveFaction', function(source, item)
	local kPlayer = ESX.GetPlayerFromId(source)

	if kPlayer then
		local result = MySQL.prepare.await('SELECT societies FROM users WHERE pid = ?', {kPlayer.identifier})
		local factions = json.decode(result); local jobs = ESX.GetJobs()

		if factions[item.job] then
			if item.job == 'taxi' then
				MySQL.Sync.execute('DELETE FROM taxi_job WHERE pid = ?;', {kPlayer.identifier})
			end

			if kPlayer.job.name == item.job then
				kPlayer.setJob('none', 0);
			end
			 
			factions[item.job] = nil
			MySQL.update.await('UPDATE users SET societies = ? WHERE pid = ?', {json.encode(factions), kPlayer.identifier})
			exports['kk-factions']:sendLog(kPlayer.source, 'LAHKUMINE', 'Lahkus fraktsioonist.')

			local discord = MySQL.prepare.await('SELECT `discord` FROM `ucp_users` WHERE `identifier` = ?', { kPlayer.steamid })
	
			if discord then
				if cfg.discordRanks[kPlayer.job.name] then
					exports['kk-scripts']:removeRole(discord, cfg.discordRanks[kPlayer.job.name])
				end
			end

			TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'success', 'Fraktsioonist lahkumine', 'Lahkusite ' .. jobs[item.job].label .. ' fraktsioonist.')
			return true
		else
			TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Fraktsioonist lahkumine', 'Te ei kuulugi antud fraktsiooni!')
			return false
		end
	else
		return false
	end
end)

local function factionRacers(faction)
	local returnable = {}
	local result = MySQL.query.await('SELECT pid, firstname, lastname, factions FROM `users` WHERE LOWER(`factions`) LIKE ?', { '%"' .. string.lower(faction) .. '"%' })

	for k,v in pairs(result) do
		returnable[#returnable + 1] = {
			name = v.firstname .. ' ' .. v.lastname,
			elo = MySQL.prepare.await('SELECT rating FROM ra_racing_user_settings WHERE player_identifier = ?', { v.pid }) or 0
		}
	end	

	return returnable
end

local function factionElo(faction)
	local total = 0
	local counts = {}
	local result = MySQL.query.await('SELECT pid, firstname, lastname, factions FROM `users` WHERE LOWER(`factions`) LIKE ?', { '%"' .. string.lower(faction) .. '"%' })

	for k,v in pairs(result) do
		local count = MySQL.prepare.await('SELECT rating FROM ra_racing_user_settings WHERE player_identifier = ?', { v.pid }) or 0
		
		total += count
		counts[#counts + 1] = count
	end	

	return total / #counts
end

local function taxiElo()
	local total = 0
	local counts = {}
	local result = MySQL.query.await('SELECT done FROM `taxi_job`', {})

	for k,v in pairs(result) do
		total += v.done
		counts[#counts + 1] = v.done
	end	

	return total / #counts
end

local function factionsWithRacers()
	local result = MySQL.query.await('SELECT * FROM `factions` WHERE type = ?', { 'racers' })

	for k,v in pairs(result) do
		result[k].elo = factionElo(result[k].name)
	end

	return result
end

lib.callback.register('kk-factions:requestFactions', function(source)
	local kPlayer = ESX.GetPlayerFromId(source)

	if kPlayer then
		local racerData = nil
		local taxiData = nil
		local result = MySQL.prepare.await('SELECT societies FROM users WHERE pid = ?', {kPlayer.identifier})
		local factions = json.decode(result); local returnable = {}; local jobs = ESX.GetJobs()

	--local zones = MySQL.query.await('SELECT * FROM `gang_zones` WHERE `faction` = ? ORDER BY `reputation` DESC', {kPlayer.job.name})

		-- for i = 1, #zones do
		-- 	zones[i].zone = exports['kk-factions']:getZoneLabel(zones[i].zone)
		-- end

		for k,v in pairs(factions) do
			returnable[k] = {label = jobs[k].label, type = jobs[k].type, grade = {id = v, label = jobs[k].grades[tostring(v)].label}}
			if kPlayer.job.name == k then returnable[k].selected = true end
		end

		if kPlayer.job.type == 'racers' then
			racerData = {
				own_elo = factionElo(kPlayer.job.name), -- fraksi üldelo
				own = factionRacers(kPlayer.job.name),
				total = factionsWithRacers()
			}
		end

		if kPlayer.job.name == 'taxi' then
			local mine = MySQL.prepare.await('SELECT done FROM taxi_job WHERE pid = ?;', { kPlayer.identifier })

			taxiData = {
				done = mine and mine .. ', fraktsioonis keskmine on ' .. taxiElo() or 'X, fraktsioonis on keskmine ' .. taxiElo(),
				stats = MySQL.query.await('SELECT * FROM taxi_job ORDER BY `done` DESC', {})
			}

			for k,v in pairs(taxiData.stats) do
				v.name = MySQL.prepare.await('SELECT firstname FROM users WHERE pid = ?;', { v.pid }) .. ' ' .. MySQL.prepare.await('SELECT lastname FROM users WHERE pid = ?;', { v.pid })
			end
		end

		return returnable, exports['kk-factions']:getCrypto(kPlayer.job.name), zones, racerData, taxiData
	else
		return false
	end
end)


lib.callback.register('kk-factions:getOnlineMembers', function(source, jobName)
	return ESX.GetDutyCount(jobName)
end)

lib.callback.register('kk-factions:getMoney', function(source)
	local kPlayer = ESX.GetPlayerFromId(source)

	if kPlayer then
		return getMoney(kPlayer.job.name)
	else
		return 0
	end
end)

lib.callback.register('kk-factions:loadGarages', function(source, car)
	local kPlayer = ESX.GetPlayerFromId(source)

	if kPlayer then
		if kPlayer.job.permissions.function2 then
			local data = getData(car, kPlayer.job.name)
			local garages = exports['kk-garages']:getFactionGarages(kPlayer.job.name, data.type)

			if tableCount(garages) > 0 then
				return garages
			else
				TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Sõiduki soetamine', 'Antud sõiduki jaoks puudub vastav garaaž!')
				return false
			end
		else
			TriggerClientEvent('kk-factions:client:sendNotification', kPlayer.source, 'error', 'Sõiduki soetamine', 'Teil ei ole piisavalt õigusi!')
			return false
		end
	else
		return false
	end
end)

lib.callback.register('kk-factions:loadBuyableVehicles', function(source)
	local Player = ESX.GetPlayerFromId(source)

	if Player then
		return cfg.vehicles[Player.job.name]
	else
		return false
	end
end)

exports('getVehiclePrice', function(model)
	local returnable = nil

	for k,v in pairs(cfg.vehicles) do
		for k2,v2 in pairs(v) do
			if joaat(k2) == model then
				returnable = v2.price
			end
		end
	end

    return returnable
end)

lib.callback.register('kk-factions:factionOwned', function(source, plate)
	local kPlayer = ESX.GetPlayerFromId(source)

	if kPlayer then
		local result = MySQL.Sync.fetchScalar('SELECT COUNT(*) FROM user_vehicles WHERE owner = ? AND plate = ?;', { 'faction_' .. kPlayer.job.name, plate })

		return result > 0
	else
		return false
	end
end)

local function canSell(faction)
	local returnable = false

	for k,v in pairs(cfg.sellFunctions) do
		if v == faction then
			returnable = true
		end
	end

	return returnable
end

exports('canSell', canSell)

local cacheInfo = {}

RegisterCommand('sellFactionVehicle', function(source, args)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
		if canSell(kPlayer.job.name) and kPlayer.job.permissions.function12 then
			if args[1] and args[2] then
				local Target = ESX.GetPlayerFromId(args[1])

				if Target then
					if Target.source ~= kPlayer.source then
						local playerPed = GetPlayerPed(kPlayer.source)
						local targetPed = GetPlayerPed(Target.source)

						if #(GetEntityCoords(targetPed) - GetEntityCoords(playerPed)) < 5.0 then
							local vehicle = GetVehiclePedIsIn(playerPed, false)

							if DoesEntityExist(vehicle) then
								local policeVehicle = exports['kk-vehicleshop']:canSellVehicle(GetEntityModel(vehicle))

								if policeVehicle then
									if not Player(kPlayer.source).state.adminMode and not kPlayer.isAdmin() then
										return TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
									end
								end

								local vehicleShopPrice = exports['kk-factions']:getVehiclePrice(GetEntityModel(vehicle)) or exports['kk-vehicleshop']:getVehiclePrice(GetEntityModel(vehicle))

                                local price = tonumber(args[2]) or 0
                                local tax = ESX.Math.Round(ESX.Math.Percent(exports['kk-taxes']:getTax('primary').value, price))
									
								local minimumPrice = ESX.Math.Round(vehicleShopPrice / 2)

								if price >= minimumPrice then
									local plate = ESX.Functions.GetPlate(vehicle)
									local result = MySQL.prepare.await('SELECT * FROM user_vehicles WHERE owner = ? AND plate = ?;', { 'faction_' .. kPlayer.job.name, plate })

									if result then
										if result.scratch == 0 then
											cacheInfo[Target.source] = {
												entity = NetworkGetNetworkIdFromEntity(vehicle),
												label = lib.callback.await('ESX.RPC.GetLabelText', kPlayer.source, GetEntityModel(vehicle)),
												model = GetEntityModel(vehicle),
												seller = {source = kPlayer.source, identifier = kPlayer.identifier},
												plate = plate,
												tax = tax,
												price = price
											}

											SetTimeout(30000, function()
												if cacheInfo[Target.source] then
													TriggerClientEvent('ESX.UI.ShowNotifcation', Target.source, 'info', 'Teile esitatud pakkumine aegus!')
													cacheInfo[Target.source] = nil
												end
											end)

											TriggerClientEvent('ESX.UI.ShowNotifcation', kPlayer.source, 'info', 'Esitasite pakkumise!')
											TriggerClientEvent('kk-factions:client:sellVehicle', Target.source, price)
										else
											TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'VIN-koodita sõiduki müük ei ole võimalik!')
										end
									else
										TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Antud sõiduk ei kuulu teile!')
									end
								else
									TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Sõiduki minimaalne hind on $' .. minimumPrice .. '!')
								end
							else
								TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Te ei ole üheski sõidukis!')
							end
						else
							TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Valitud isik ei ole teie läheduses!')
						end
					else
						TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Te ei saa iseendale sõidukit müüa!')
					end
				else
					TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Sisestatud mängija ei viibi serveris!')
				end
			end
		else
			TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
		end
    end
end)

RegisterNetEvent('kk-factions:server:acceptVehicle', function()
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        local info = cacheInfo[kPlayer.source]

        if info then
			local price = info.price + info.tax
			local account = (kPlayer.job.name == 'eventure' and kPlayer.job.onDuty) and 'money' or 'bank'

            if kPlayer.getAccount(account).money >= price then
                local Seller = ESX.GetPlayerFromIdentifier(info.seller.identifier)

                if Seller then
                    if exports['kk-garages']:canBuyVehicle(kPlayer.identifier) then
                        kPlayer.removeAccountMoney(account, price)
						TriggerEvent('ESX.Faction.AddMoney', Seller.job.name, info.price)

                        MySQL.update.await('UPDATE `user_vehicles` SET `owner` = ? WHERE `plate` = ?', { kPlayer.identifier, info.plate })
        
                        TriggerClientEvent('KKF.UI.ShowNotification', info.seller.source, 'info', 'Kirjutasite sõiduki ' .. info.plate .. ' omandi ümber! Teenisite $' .. info.price .. '.')
                        TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'info', 'Sõiduki ' .. info.plate .. ' kirjutati teie nimele! Maksite $' .. price .. '.')
        
						exports['kk-factions']:sendLog(info.seller.source, 'SÕIDUKI MÜÜK', 'Kirjutas fraktsiooni sõiduki REG.NR ' .. info.plate .. ' SID: ' .. kPlayer.identifier .. ' nimele hind $' .. price .. '.')
						exports['kk-scripts']:sendLog(info.seller.identifier, 'SÕIDUKID', 'Kirjutas fraktsiooni sõiduki REG.NR ' .. info.plate .. ' targeti nimele hind $' .. price .. '.', kPlayer.identifier)
                    else
                        TriggerClientEvent('KKF.UI.ShowNotification', info.seller.source, 'error', 'Ostjal ei ole piisavalt sõidukikohti!')
                        TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt sõidukikohti!')
                    end
                else
                    TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Müüja lahkus!')
                end
            else
                TriggerClientEvent('KKF.UI.ShowNotification', info.seller.source, 'error', 'Ostjal ei ole piisavalt raha!')
            end

            cacheInfo[kPlayer.source] = nil
        end
    end
end)

RegisterNetEvent('kk-factions:server:declineVehicle', function()
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        local info = cacheInfo[kPlayer.source]

        if info then
            TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Loobusite pakkumisest!')
            TriggerClientEvent('KKF.UI.ShowNotification', info.seller.source, 'error', 'Ostja loobus pakkumisest!')

            cacheInfo[kPlayer.source] = nil
        end
    end
end)

RegisterCommand('setFactionVehicle', function(source, args)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
		if canSell(kPlayer.job.name) and kPlayer.job.permissions.function12 then
			local playerPed = GetPlayerPed(kPlayer.source)
			local vehicle = GetVehiclePedIsIn(playerPed, false)

			if DoesEntityExist(vehicle) then
				local plate = ESX.Functions.GetPlate(vehicle)
				local isMine = MySQL.Sync.fetchScalar('SELECT COUNT(*) FROM `user_vehicles` WHERE `plate` = ? AND `owner` = ?', { plate, kPlayer.identifier }) > 0

				if isMine then
					MySQL.update.await('UPDATE `user_vehicles` SET `owner` = ? WHERE `plate` = ?', { 'faction_' .. kPlayer.job.name, plate })
					exports['kk-factions']:sendLog(kPlayer.source, 'SÕIDUKID', 'Kirjutas fraktsiooni sõiduki REG.NR ' .. plate .. '.')
					exports['kk-scripts']:sendLog(kPlayer.identifier, 'SÕIDUKID', 'Kirjutas fraktsiooni sõiduki REG.NR ' .. plate .. '.')
					TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'success', 'Kirjutasite sõiduki ' .. plate .. ' fraktsiooni!')
				else
					TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Antud sõiduk ei kuulu teile!')
				end
			else
				TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Te ei ole üheski sõidukis!')
			end
		else
			TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
		end
    end
end)

exports('getAllVehicles', function()
	local returnable = {}

	for k,v in pairs(cfg.vehicles) do
		for k2,v2 in pairs(v) do
			returnable[k2] = v2
		end
	end

	return returnable
end)

exports('getVehicleClass', function(model)
    local returnable = nil

	for k,v in pairs(cfg.vehicles) do
		for k2,v2 in pairs(v) do
			if joaat(k2) == model then
				if v2.class then
					returnable = v2.class
				end
			end
		end
	end	
	
    return returnable
end)

local announceCooldown = false

RegisterCommand('announce', function(source, args)
	local kPlayer = ESX.GetPlayerFromId(source)

	if kPlayer then
		if not announceCooldown then
			if args[1] and args[2] then
				if kPlayer.job.type ~= 'gang' and kPlayer.job.type ~= 'racers' then
					if kPlayer.job.permissions.announce then
						local secs = tonumber(args[1])
						local price = secs * 1000;

						TriggerEvent('ESX.Faction.GetMoney', kPlayer.job.name, function(money)
							if money >= price then
								local duration = secs * 1000
								local message = table.concat(args, ' ', 2)

								TriggerEvent('ESX.Faction.RemoveMoney', kPlayer.job.name, price)
								exports['kk-factions']:sendLog(kPlayer.source, 'TEADAANNE', 'Sekundid: ' .. secs .. '; Hind: ' .. price .. '; Sisu: ' .. message)

								TriggerClientEvent('kk-factions:client:displayEAS', -1, message, duration, kPlayer.job.label)
								announceCooldown = true

								SetTimeout(duration, function()
									announceCooldown = false
								end)
							else
								TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Fraktsioonil ei ole piisavalt raha!')
							end
						end)
					else
						TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
					end
				else
					TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Teil ei ole piisavalt õigusi!')
				end
			else
				TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Sisesta kõik andmed!')
			end
		else
			TriggerClientEvent('KKF.UI.ShowNotification', kPlayer.source, 'error', 'Palun oota natukene!')
		end
	end
end)

RegisterCommand('delete_owned_vehicles', function(source, args)
	if source == 0 then
		if args[1] then
			local vehicles = MySQL.query.await('SELECT * FROM `user_vehicles` WHERE owner = ?', { args[1] })

			for k,v in pairs(vehicles) do
				MySQL.Sync.execute('DELETE FROM `user_vehicles` WHERE plate = ?;', { tostring(v.plate) })
				MySQL.Sync.execute('DELETE FROM `user_vehicles_data` WHERE plate = ?;', { tostring(v.plate) })
			end

			print('done')
		else
			print('args puudu')
		end
	end
end)

AddEventHandler('ESX.Player.Loaded', function(source)
    local kPlayer = ESX.GetPlayerFromId(source)

    if kPlayer then
        local factions = json.decode(MySQL.prepare.await('SELECT `factions` FROM `users` WHERE pid = ?', { kPlayer.identifier })) or {}
        local discord = MySQL.prepare.await('SELECT `discord` FROM `ucp_users` WHERE `identifier` = ?', { kPlayer.steamid })

		if discord then
			for k,v in pairs(cfg.discordRanks) do
				if factions[k] then
					Wait(math.random(5000, 10000))
					exports['kk-scripts']:addRole(discord, v)
				end
			end
		end
    end
end)

local function sendLog(playerId, action, text)
    local kPlayer = ESX.GetPlayerFromId(playerId)

    if kPlayer then
        MySQL.insert.await('INSERT INTO society_logs (action, pid, faction, text) VALUES (?, ?, ?, ?)', {
            action,
            kPlayer.get('firstName') .. ' ' .. kPlayer.get('lastName') .. ' (' .. kPlayer.identifier .. ')',
            kPlayer.job.name,
            text
        })
    else
        print('VIGA FRAXI LOGI SAATMISEL')
    end
end

exports('sendLog', sendLog)

AddEventHandler('kk-factions:server:revokeFaction', function(faction)
	local jobs = ESX.GetJobs()

	if jobs[faction] then
		local members = MySQL.query.await('SELECT `pid`, `job`, `job_grade`, `societies` FROM users WHERE LOWER(`societies`) LIKE ?', { string.lower('%"' .. faction .. '"%') })

		for i = 1, #members do
			local currentIdentifier = members[i].pid
			local currentFactions = json.decode(members[i].factions)

			local currentJob = members[i].job
			local currentGrade = members[i].job_grade

			currentFactions[faction] = nil

			local kTarget = ESX.GetPlayerFromIdentifier(currentIdentifier)

			if kTarget then
				if kTarget.job.name == faction then
					kTarget.setJob('none', 0)
				end
			else
				if currentJob == faction then
					currentJob = 'none'
					currentGrade = 0
				end
			end

			MySQL.update.await('UPDATE `users` SET `factions` = ?, `job` = ?, `job_grade` = ? WHERE `pid` = ?', { json.encode(currentFactions), currentJob, currentGrade, currentIdentifier })
		end
	end
end)