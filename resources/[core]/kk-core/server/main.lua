local Inventory = nil

AddEventHandler('ox_inventory:loadInventory', function(module)
	Inventory = module
end)

local function checkWhitelist(identifier)
	print('Vaatan whitelisti: '..identifier)
    --local rowCount = MySQL.Sync.fetchScalar('SELECT COUNT(*) FROM ucp_whitelist WHERE steamhex = ? AND status = ?;', { identifier, 'accepted' })
	local rowCount = MySQL.Sync.fetchScalar('SELECT COUNT(identifier) FROM user_permissions WHERE identifier = ?;', { identifier })

    return rowCount > 0;
end

local function checkBlacklist(identifier)
    local rowCount = MySQL.Sync.fetchScalar('SELECT COUNT(*) FROM ucp_users WHERE steamhex = ? AND blacklist = ?;', { identifier, true })

	return rowCount > 0
end

local function CreateExtendedPlayer(playerId, identifier, adminLevel, accounts, inventory, weight, job, loadout, name, coords, licenses, phone, steamid)
	local self = {}

	self.accounts = accounts
	self.coords = coords
	self.adminLevel = adminLevel
	self.identifier = identifier
	self.inventory = inventory
	self.job = job
	self.loadout = loadout
	self.name = name
	self.playerId = playerId
	self.source = playerId
	self.variables = {}
	self.weight = weight
	self.maxWeight = Config.MaxWeight
	self.steamid = steamid
	self.licenses = licenses
	self.phone = phone

	self.getCoords = function(vector)
		local ped = GetPlayerPed(playerId)
		local pcoords = GetEntityCoords(ped)

		if vector then
			return vector3(pcoords.x, pcoords.y, pcoords.z)
		else
			return {x = pcoords.x, y = pcoords.y, z = pcoords.z}
		end
	end

	self.setMoney = function(money)
		money = KKF.Math.Round(money)
		self.setAccountMoney('money', money)
	end

	self.getMoney = function()
		return self.getAccount('money').money
	end

	self.addMoney = function(money)
		money = KKF.Math.Round(money)
		self.addAccountMoney('money', money)
	end

	self.removeMoney = function(money)
		money = KKF.Math.Round(money)
		Inventory.RemoveItem(self.source, 'money', money)
	end

	self.getIdentifier = function()
		return self.identifier
	end

	self.getSteamId = function()
		return self.steamid
	end

	self.isAdmin = function()
		return self.adminLevel > 0
	end

	self.set = function(k, v)
		self.variables[k] = v
	end

	self.get = function(k)
		return self.variables[k]
	end

	self.getAccounts = function(minimal)
		if minimal then
			local minimalAccounts = {}

			for k,v in ipairs(self.accounts) do
				minimalAccounts[v.name] = v.money
			end

			return minimalAccounts
		else
			return self.accounts
		end
	end

	self.getAccount = function(account)
		for k,v in ipairs(self.accounts) do
			if v.name == account then
				return v
			end
		end
	end

	self.getInventory = function(minimal)
		if minimal and next(self.inventory) then
			local inventory = {}
			for k, v in pairs(self.inventory) do
				if v.count and tonumber(v.count) > 0 then
					local metadata = v.metadata
					if v.metadata and next(v.metadata) == nil then metadata = nil end
					inventory[#inventory+1] = {
						name = v.name,
						count = tonumber(v.count),
						slot = k,
						metadata = metadata
					}
				end
			end
			return inventory
		end
		return self.inventory
	end

	self.getJob = function()
		return self.job
	end

	self.getLoadout = function(minimal)
		return {}
	end

	self.getName = function()
		return self.name
	end

	self.setName = function(newName)
		self.name = newName
	end

	self.removeLicense = function(license)
		if license then
			local currentLicenses = self.licenses
			currentLicenses[license] = false

			TriggerClientEvent('KKF.Player.ReloadLicenses', self.source, currentLicenses)
			KKF.SavePlayer(self)
		end
	end

	self.giveLicense = function(license)
		if license then
			local currentLicenses = self.licenses
			currentLicenses[license] = true

			TriggerClientEvent('KKF.Player.ReloadLicenses', self.source, currentLicenses)
			KKF.SavePlayer(self)
		end
	end

	self.getLicenses = function()
		return self.licenses
	end

	self.setAccountMoney = function(accountName, money)
		if money >= 0 then
			local account = self.getAccount(accountName)

			if account then
				local prevMoney = account.money
				local newMoney = KKF.Math.Round(money)
				account.money = newMoney
				if accountName ~= 'bank' then Inventory.SetItem(self.source, accountName, money) end
				TriggerClientEvent('KKF.Accounts.Set', self.source, account)
			end
		end
	end

	self.addAccountMoney = function(accountName, money)
		if money > 0 then
			local account = self.getAccount(accountName)

			if account then
				local newMoney = account.money + KKF.Math.Round(money)
				account.money = newMoney
				if accountName ~= 'bank' then Inventory.AddItem(self.source, accountName, money) end
				TriggerClientEvent('KKF.Accounts.Set', self.source, account)
			end
		end
	end

	self.removeAccountMoney = function(accountName, money)
		if money > 0 then
			local account = self.getAccount(accountName)

			if account then
				local newMoney = account.money - KKF.Math.Round(money)
				account.money = newMoney
				if accountName ~= 'bank' then Inventory.RemoveItem(self.source, accountName, money) end
				TriggerClientEvent('KKF.Accounts.Set', self.source, account)
			end
		end
	end

	self.getItem = function(name, metadata)
		return Inventory.GetItem(self.source, name, metadata)
	end

	self.addInventoryItem = function(name, count, metadata, slot)
		Inventory.AddItem(self.source, name, count or 1, metadata, slot)
	end

	self.removeInventoryItem = function(name, count, metadata)
		Inventory.RemoveItem(self.source, name, count, metadata)
	end

	self.setInventoryItem = function(name, count, metadata)
		Inventory.SetItem(self.source, name, count, metadata)
	end

	self.getWeight = function()
		return self.weight
	end

	self.getMaxWeight = function()
		return self.maxWeight
	end

	self.canCarryItem = function(name, count)
		return Inventory.CanCarryItem(self.source, name, count, metadata)
	end

	self.canSwapItem = function(firstItem, firstItemCount, testItem, testItemCount)
		return Inventory.CanSwapItem(self.source, firstItem, firstItemCount, testItem, testItemCount)
	end

	self.setMaxWeight = function(newWeight)
		self.maxWeight = newWeight
		return Inventory.Set(self.source, 'maxWeight', newWeight)
	end

	self.getDuty = function()
		return self.job.onDuty
	end

	self.toggleDuty = function()
		self.job.onDuty = not self.job.onDuty

		TriggerEvent('KKF.Player.DutyChange', self.source, self.job.onDuty)
		TriggerClientEvent('KKF.Player.DutyChange', self.source, self.job.onDuty)

		KKF.SavePlayer(self)
	end

	self.setDuty = function(value, silent)
		self.job.onDuty = value

		TriggerEvent('KKF.Player.DutyChange', self.source, value, silent)
		TriggerClientEvent('KKF.Player.DutyChange', self.source, value, silent)

		KKF.SavePlayer(self)
	end

	self.setJob = function(job, grade)
		grade = tostring(grade)
		local lastJob = json.decode(json.encode(self.job))

		if KKF.DoesJobExist(job, grade) then
			local jobObject, gradeObject = KKF.Jobs[job], KKF.Jobs[job].grades[grade]

			self.job.id    = jobObject.id
			self.job.name  = jobObject.name
			self.job.label = jobObject.label
			self.job.type = jobObject.type
			self.job.limit = jobObject.max_count
			self.job.properties = jobObject.properties

			self.job.grade        = tonumber(grade)
			self.job.grade_label  = gradeObject.label
			self.job.grade_salary = gradeObject.salary

			self.job.permissions = gradeObject.permissions

			TriggerEvent('KKF.Player.JobUpdate', self.source, self.job, lastJob)
			TriggerClientEvent('KKF.Player.JobUpdate', self.source, self.job)
		else
			print(('[kk-core] [^3WARNING^7] Ignoring invalid .setJob() usage for "%s"'):format(self.identifier))
		end

		KKF.SavePlayer(self)
	end

	self.addSociety = function(society, rank)
		rank = tostring(rank)

		if KKF.DoesJobExist(society, rank) then
			MySQL.Async.fetchAll('SELECT societies FROM users WHERE pid = ?', { self.identifier }, function(result)
				local societies = json.decode(result[1].societies)

				if not societies[society] then
					societies[society] = rank

					MySQL.Async.execute('UPDATE users SET societies = ? WHERE pid = ?', { json.encode(societies), self.identifier })
				else
					print(('KKF.Debug: Ignoring invalid .addSociety() usage for "%s"'):format(self.identifier))
				end
			end)
		else
			print(('KKF.Debug: Ignoring invalid .addSociety() usage for "%s"'):format(self.identifier))
		end
	end

	self.removeSociety = function(society)
		rank = tostring(rank)

		MySQL.Async.fetchAll('SELECT societies FROM users WHERE pid = ?', { self.identifier }, function(result)
			local societies = json.decode(result[1].societies)

			if societies[society] then
				societies[society] = nil

				MySQL.Async.execute('UPDATE users SET societies = ? WHERE pid = ?', { json.encode(societies), self.identifier })
			else
				print(('KKF.Debug: Ignoring invalid .addSociety() usage for "%s"'):format(self.identifier))
			end
		end)
	end

	self.updateWeaponAmmo = function(weaponName, ammoCount)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			if ammoCount < weapon.ammo then
				weapon.ammo = ammoCount
			end
		end
	end

	self.hasWeaponComponent = function(weaponName, weaponComponent)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			for k,v in ipairs(weapon.components) do
				if v == weaponComponent then
					return true
				end
			end

			return false
		else
			return false
		end
	end

	self.hasWeapon = function(weaponName)
		for k,v in ipairs(self.loadout) do
			if v.name == weaponName then
				return true
			end
		end

		return false
	end

	self.hasItem = function(item)
		return self.getItem(item).count > 0
	end

	self.syncInventory = function(weight, maxWeight, items, money)
		self.weight, self.maxWeight = weight, maxWeight
		self.inventory = items
		if money then
			for k, v in pairs(money) do
				local account = self.getAccount(k)
				if KKF.Math.Round(account.money) ~= v then
					account.money = v
					TriggerClientEvent('KKF.Accounts.Set', self.source, account)
				end
			end
		end
	end

	self.getPlayerSlot = function(slot)
		return self.inventory[slot]
	end

	self.getWeapon = function(weaponName)
		for k,v in ipairs(self.loadout) do
			if v.name == weaponName then
				return k, v
			end
		end

		return
	end

	return self
end

AddEventHandler('playerConnecting', function(name, setCallback, deferrals, skr)
    deferrals.defer();

    local playerId = source;

    for i=1, 5 do
        deferrals.update('Andmete laadimine: '..i..'/5.')
        Wait(1000);
    end

    local identifier, kickReason = KKF.GetPlayerIdentifier(playerId) or false;

    if not identifier then
	    kickReason = 'Serveriga liitumiseks peab teil töötama steam!'
	elseif checkBlacklist(identifier) then
		kickReason = 'Olete serverist jäädavalt keelustatud! [BLACKLIST]'
    -- elseif not checkWhitelist(identifier) then
	--     kickReason = 'Serveriga liitumiseks peate olema läbinud rollimängutesti!'
    end

    if kickReason then
	    deferrals.done(kickReason);
    else
		TriggerEvent('kk-queue:server:playerConnect', name, setCallback, deferrals, playerId)
	end
end)


RegisterNetEvent('kk-core:server:registerCharacter')
AddEventHandler('kk-core:server:registerCharacter', function(data)
    local src = source
    local steamId = KKF.GetPlayerIdentifier(src)

	MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE firstname = ? AND lastname = ?', {data.firstname, data.lastname}, function(result)
		if not result[1] then
			exports['kk-banking2']:sendLog('Riigikassa', data.firstname .. ' ' .. data.lastname, 750, 'in')
			-- Esimesse lisada alguses (INSERT INTO users (identifier, firstname, lastname, dateofbirth, sex, phone, inventory) Pärast VALUES  @identifier, @firstname, @lastname, @dateofbirth, @sex,  @inventory tuleb ka lisada phone.
			MySQL.Async.execute('INSERT INTO users (identifier, firstname, lastname, dateofbirth, sex, phone, inventory) VALUES (@identifier, @firstname, @lastname, @dateofbirth, @sex, @phone, @inventory)', {
				['@identifier'] = steamId,
				['@firstname'] = data.firstname,
				['@lastname'] = data.lastname,
				['@dateofbirth'] = data.dateofbirth,
				['@sex'] = data.sex,
				-- ['@phone'] = exports['kk-phone']:generatePhoneNumber(),
				['@inventory'] = '[{"slot":1,"count":1,"name":"giftbox"}]'
			}, function(rowsChanged)
				TriggerClientEvent('KKF.ReloadCharacters', src)
			end)
		else
			TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'See nimi on juba kasutusel!')
			TriggerClientEvent('KKF.ReloadCharacters', src)
		end
	end)
end)

RegisterNetEvent('kk-core:server:characterChosen')
AddEventHandler('kk-core:server:characterChosen', function(pid)
	local src = source
	local steamId = KKF.GetPlayerIdentifier(src)

	MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = ? AND pid = ?', {steamId, pid}, function(result)
		if result[1] then
    		loadKKFPlayer(pid, src)
		end
	end)
end)

RegisterNetEvent('KKF.Player.SessionStarted', function(playerId)
	local src = source

	if playerId then
		src = playerId
	else
		src = source
	end

	MySQL.Async.fetchAll('SELECT character_slots FROM ucp_users WHERE steamhex = ?', { KKF.GetPlayerIdentifier(src) }, function(ucp)
		
		MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = ?', { KKF.GetPlayerIdentifier(src) }, function(result)
			SetPlayerRoutingBucket(src, src)
			TriggerClientEvent('KKF.SetupCharacters', src)

			for k,v in pairs(result) do
				result[k].skin = json.decode(v.skin)
			end

			if ucp[1] then
				TriggerClientEvent('kk-multicharacter:client:loadCharacters', src, result, ucp[1].character_slots)
			else
				TriggerClientEvent('kk-multicharacter:client:loadCharacters', src, result, 2)
			end
		end) 
	end)
end)

function loadKKFPlayer(identifier, playerId)
    local userData = {
        accounts = {},
        inventory = {},
        job = {},
        loadout = {},
        playerName = GetPlayerName(playerId),
        weight = 0
    }

    MySQL.Async.fetchAll("SELECT * FROM users WHERE pid = ?", { identifier }, function(result)
		MySQL.Async.fetchAll("SELECT * FROM user_permissions WHERE identifier = ?", { result[1].identifier }, function(result2)
			local job, grade, jobObject, gradeObject = result[1].job, tostring(result[1].job_grade)
			local foundAccounts, foundItems = {}, {}

			-- Accounts
			if result[1].accounts and result[1].accounts ~= "" then
				local accounts = json.decode(result[1].accounts)

				for account, money in pairs(accounts) do
					foundAccounts[account] = money
				end
			end

			for account, label in pairs(Config.Accounts) do
				table.insert(
					userData.accounts,
					{
						name = account,
						money = foundAccounts[account] or Config.StartingAccountMoney[account] or 0,
						label = label
					}
				)
			end

			-- Job
			if KKF.DoesJobExist(job, grade) then
				jobObject, gradeObject = KKF.Jobs[job], KKF.Jobs[job].grades[grade]
			else
				print(("[^3WARNING^7] Ignoring invalid job for %s [job: %s, grade: %s]"):format(identifier, job, grade))
				job, grade = "unemployed", "0"
				jobObject, gradeObject = KKF.Jobs[job], KKF.Jobs[job].grades[grade]
			end

			userData.steamId = result[1].identifier
			userData.phone = result[1].phone

			userData.job.id = jobObject.id
			userData.job.name = jobObject.name
			userData.job.label = jobObject.label
			userData.job.type = jobObject.type
			userData.job.limit = jobObject.max_count
			userData.job.properties = jobObject.properties

			userData.job.grade = tonumber(grade)
			userData.job.grade_label = gradeObject.label
			userData.job.grade_salary = gradeObject.salary

			userData.job.permissions = gradeObject.permissions

			if result[1].duty > 0 then
				userData.job.onDuty = true
			else
				userData.job.onDuty = false
			end

			userData.adminLevel = result2[1] and result2[1].lvl or not result2[1] and 0

			-- Inventory
			if result[1].inventory and result[1].inventory ~= '' then
				userData.inventory = json.decode(result[1].inventory)
			end

			-- Loadout
			if result[1].loadout and result[1].loadout ~= "" then
				local loadout = json.decode(result[1].loadout)

				for name, weapon in pairs(loadout) do
					local label = KKF.GetWeaponLabel(name)

					if label then
						if not weapon.components then
							weapon.components = {}
						end
						if not weapon.tintIndex then
							weapon.tintIndex = 0
						end

						table.insert(
							userData.loadout,
							{
								name = name,
								ammo = weapon.ammo,
								label = label,
								components = weapon.components,
								tintIndex = weapon.tintIndex
							}
						)
					end
				end
			end

			-- Position
			if result[1].position and result[1].position ~= "" then
				userData.coords = json.decode(result[1].position)
			else
				print(
					'[^3WARNING^7] Column ^5"position"^0 in ^5"users"^0 table is missing required default value. Using backup coords, fix your database.'
				)
				userData.coords = {x = -269.4, y = -955.3, z = 31.2, heading = 205.8}
			end

			-- Skin
			userData.skin = json.decode(result[1].skin)
			userData.tattoos = json.decode(result[1].tattoos)

			-- Identity
			if result[1].firstname and result[1].firstname ~= "" then
				userData.firstname = result[1].firstname
				userData.lastname = result[1].lastname
				userData.playerName = userData.firstname .. " " .. userData.lastname
				if result[1].dateofbirth then
					userData.dateofbirth = result[1].dateofbirth
				end
				if result[1].sex then
					userData.sex = result[1].sex
				end
			end
			
			userData.licenses = json.decode(result[1].licenses)
			local xPlayer = CreateExtendedPlayer(playerId, identifier, userData.adminLevel, userData.accounts, userData.inventory, userData.weight, userData.job, userData.loadout, userData.playerName, userData.coords, userData.licenses, userData.phone, userData.steamId)
			KKF.Players[playerId] = xPlayer

			if userData.firstname then
				xPlayer.set("firstName", userData.firstname)
				xPlayer.set("lastName", userData.lastname)
				if userData.dateofbirth then
					xPlayer.set("dateofbirth", userData.dateofbirth)
				end
				if userData.sex then
					xPlayer.set("sex", userData.sex)
				end
			end

			TriggerEvent("KKF.Player.Loaded", playerId, xPlayer)
			TriggerClientEvent('KKF.Player.Loaded', xPlayer.source, {
				name = xPlayer.getName(),
				accounts = xPlayer.getAccounts(),
				coords = xPlayer.getCoords(),
				identifier = xPlayer.getIdentifier(),
				inventory = xPlayer.getInventory(),
				job = xPlayer.getJob(),
				loadout = xPlayer.getLoadout(),
				maxWeight = xPlayer.getMaxWeight(),
				money = xPlayer.getMoney(),
				licenses = xPlayer.getLicenses(),
				dead = false
			})

			MySQL.Async.fetchAll('SELECT * FROM ucp_users WHERE steamhex = ?', { xPlayer.steamid }, function(result)
				if result and result[1] then 
					MySQL.Sync.execute('UPDATE ucp_users SET last_online = ? WHERE steamhex = ?', { os.date('%Y-%m-%d %X'), xPlayer.steamid })
				end
			end)

			if userData.skin == nil then
				TriggerClientEvent('KKF.SpawnFirstTime', playerId, userData.sex)
				SetPlayerRoutingBucket(playerId, playerId)
			else
				if result[1].jail_time > 0 then
					TriggerClientEvent('KKF.SpawnCharacter', playerId, userData.coords, userData.skin, userData.tattoos, userData.skin, true)
				elseif result[1].ajail > 0 then
					TriggerClientEvent('KKF.SpawnCharacter', playerId, userData.coords, userData.skin, userData.tattoos, userData.skin, true)
				elseif result[1].last_apartment ~= nil then
					MySQL.Sync.execute('UPDATE users SET last_apartment = NULL WHERE pid = ?', {xPlayer.identifier})
					TriggerClientEvent('KKF.SpawnCharacter', playerId, {x = -270.95, y = -957.86, z = 31.22}, userData.skin, userData.tattoos, userData.skin, true)
				elseif result[1].last_property ~= nil then
					MySQL.Sync.execute('UPDATE users SET last_property = NULL WHERE pid = ?', {xPlayer.identifier})
					TriggerClientEvent('KKF.SpawnCharacter', playerId, exports['kk-properties']:getHouseLocation(result[1].last_property), userData.skin, userData.tattoos, userData.skin, true)
				elseif result[1].last_warehouse ~= nil then
					MySQL.Sync.execute('UPDATE users SET last_warehouse = NULL WHERE pid = ?', {xPlayer.identifier})
					TriggerClientEvent('KKF.SpawnCharacter', playerId, exports['kk-properties']:getLocation(result[1].last_warehouse), userData.skin, userData.tattoos, userData.skin, true)
				else
					TriggerClientEvent('kk-scripts:client:openSpawn', playerId, userData.coords, userData.skin, userData.tattoos)
				end

				SetPlayerRoutingBucket(playerId, 0)
			end

			TriggerEvent('ox_inventory:setPlayerInventory', xPlayer, userData.inventory)
			
			exports.ox_inventory:RegisterStash('apartment' .. xPlayer.identifier, 'Korter', 5, 20000, true)
			exports.ox_inventory:RegisterStash('apartment' .. xPlayer.identifier .. 'high', 'Korter', 50, 150000, true)

			print(
				('[^2INFO^0] Player ^5"%s" ^0has connected to the server. ID: ^5%s^7'):format(
					xPlayer.getName(),
					playerId
				)
			)
		end)
	end)
end

AddEventHandler('chatMessage', function(playerId, author, message)
	if message:sub(1, 1) == '/' and playerId > 0 then
		CancelEvent()
		local commandName = message:sub(1):gmatch("%w+")()

	end
end)

AddEventHandler('playerDropped', function(reason)
	local playerId = source
	local xPlayer = KKF.GetPlayerFromId(playerId)

	if xPlayer then
		MySQL.Async.fetchAll('SELECT * FROM ucp_users WHERE steamhex = ?', { xPlayer.steamid }, function(result)
			if result and result[1] then 
				MySQL.Sync.execute('UPDATE ucp_users SET last_online = ? WHERE steamhex = ?', { os.date('%Y-%m-%d %X'), xPlayer.steamid })
			end
		end)

		TriggerEvent('KKF.Player.Dropped', playerId, reason)

		KKF.SavePlayer(xPlayer, function()
			KKF.Players[playerId] = nil
		end)
	end
end)

RegisterNetEvent('KKF:useItem')
AddEventHandler('KKF:useItem', function(source, itemName)
	local xPlayer = KKF.GetPlayerFromId(source) 
	local item = Inventory:GetItem(xPlayer.source, itemName)
	if item.count > 0 then
		if item.closeonuse then TriggerClientEvent("ox_inventory:closeInventory", source) end
		KKF.UseItem(source, itemName)
	end
end)

AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
	if eventData.secondsRemaining == 60 then
		Citizen.CreateThread(function()
			Citizen.Wait(50000)
			KKF.SavePlayers()
		end)
	end
end)

AddEventHandler('KKF.GetPlayerFromId', function(source, cb) cb(KKF.Players[tonumber(source)]) end)
AddEventHandler('KKF.GetPlayerFromIdentifier', function(identifier, cb) cb(KKF.GetPlayerFromIdentifier(identifier)) end)

-- SetInterval(function()
--     local xPlayers = KKF.GetPlayers()

--     for i=1, #xPlayers, 1 do
--         local xPlayer = KKF.GetPlayerFromId(xPlayers[i])

--         if GetResourceKvpInt('salaryTime_' .. xPlayer.identifier) == 60 then
-- 			local job     = xPlayer.job.name
-- 			local salary  = xPlayer.job.grade_salary
			
-- 			if salary > 0 then
-- 				if job == 'unemployed' then -- unemployed
-- 					KKF.UpdateCheck(xPlayer.source, 'add', salary)
-- 				else
-- 					TriggerEvent('Society.GetMoney', xPlayer.job.name, function(money)
-- 						if money >= salary then
-- 							TriggerEvent('Society.RemoveMoney', xPlayer.job.name, salary); KKF.UpdateCheck(xPlayer.source, 'add', salary)
-- 						else
-- 							TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Teie fraktsioonil ei ole piisavalt raha, et teile palka maksta.')
-- 						end
-- 					end)
-- 				end
-- 			end

-- 			SetResourceKvpInt('salaryTime_' .. xPlayer.identifier, 0)
--         else
--             SetResourceKvpInt('salaryTime_' .. xPlayer.identifier, GetResourceKvpInt('salaryTime_' .. xPlayer.identifier) + 1)
--         end
--     end
-- end, 60000)

-- RegisterServerEvent('KKF.ExchangeCheck', function()
-- 	local xPlayer = KKF.GetPlayerFromId(source)

-- 	if xPlayer then
-- 		local payCheck = GetResourceKvpInt('paycheck_' .. xPlayer.identifier)

-- 		if payCheck > 0 then
-- 			KKF.UpdateCheck(source, 'remove', payCheck); xPlayer.addAccountMoney('bank', payCheck)

-- 			exports['kk-banking2']:sendLog('Palgaleht', xPlayer.name, payCheck, 'in')
-- 			TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'info', 'Kogunenud palk lisatakse teie pangakontole.')
-- 		else
-- 			TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'error', 'Teil ei ole kogutud palka!')
-- 		end
-- 	end
-- end)

local INTERVAL = 60 * 60 * 1000 

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(INTERVAL)

        local players = KKF.GetPlayers()
        for _, playerId in ipairs(players) do
            local xPlayer = KKF.GetPlayerFromId(playerId)
            if xPlayer then
                local job = xPlayer.job.name
                local grade = xPlayer.job.grade
                local result = MySQL.Sync.fetchAll('SELECT salary FROM job_grades WHERE job_name = ? AND grade = ?', { job, grade })
                local payAmount = 0
                if result[1] then
                    payAmount = tonumber(result[1].salary) or 0
                end

                if payAmount > 0 then
                    local factionResult = MySQL.Sync.fetchAll('SELECT money FROM jobs WHERE name = ?', { job })
                    local factionMoney = 0
                    if factionResult[1] then
                        factionMoney = tonumber(factionResult[1].money) or 0
                    end

                    if factionMoney >= payAmount then
                        local newFactionMoney = factionMoney - payAmount
                        MySQL.update.await('UPDATE jobs SET money = ? WHERE name = ?', { newFactionMoney, job })

                        xPlayer.addAccountMoney('bank', payAmount)

                        exports['kk-banking2']:sendLog('Palgandus', xPlayer.name, payAmount, 'Palgandus')

                        -- TriggerClientEvent('KKF.UI.ShowNotification', xPlayer.source, 'info', 'Saite palka fraktsioonilt: $' .. payAmount)
                    else
                     --TriggerClientEvent(xPlayer.source, 'KKF.UI.ShowNotification', 'error', 'Fraktsioonil pole piisavalt raha palga maksmiseks!')
                    end
                end
            end
        end
    end
end)


RegisterServerEvent('kk-core:server:unload', function()
	local src = source
	local xPlayer = KKF.GetPlayerFromId(src)

	if xPlayer then
		TriggerEvent('KKF.Player.Unloaded', xPlayer.source)
	end
end)

AddEventHandler('KKF.Player.Unloaded', function(playerId)
    local xPlayer = KKF.GetPlayerFromId(playerId)

    if xPlayer then
        TriggerEvent('KKF.Player.Dropped', playerId)

		KKF.SavePlayer(xPlayer, function()
			KKF.Players[playerId] = nil

			TriggerEvent("KKF.Player.SessionStarted", playerId)
			TriggerClientEvent("KKF.Player.Unloaded", playerId)
			TriggerEvent('eblips:remove', playerId)
		end)
    end
end)

RegisterCommand('unload', function(source)
	local src = source
	local xPlayer = KKF.GetPlayerFromId(src)

	if xPlayer then
		if xPlayer.adminLevel > 2 then
			if Player(xPlayer.source).state.adminMode then
				if not Player(xPlayer.source).state.isDead then
					TriggerEvent('KKF.Player.Unloaded', xPlayer.source)
				else
					TriggerClientEvent("chatMessage", xPlayer.source, "SÜSTEEM", 1, "Te ei saa surnuna unloadida.")
				end
			else
				TriggerClientEvent("chatMessage", xPlayer.source, "SÜSTEEM", 1, "Te ei ole veel administraatori õigusi sisse lülitanud.")
			end
		else
			TriggerClientEvent("chatMessage", xPlayer.source, "SÜSTEEM", 1, "Te ei ole arendaja.")
		end
	end
end)

 --- commands
RegisterCommand('clear', function(source, args)
	local xPlayer = KKF.GetPlayerFromId(source)

	if xPlayer then
		TriggerClientEvent('chat:clear', xPlayer.source)
	end
end)

RegisterCommand('clearAll', function(source, args)
	local xPlayer = KKF.GetPlayerFromId(source)

	if xPlayer then
		if xPlayer.isAdmin() then
			if Player(xPlayer.source).state.adminMode then
				TriggerClientEvent('chat:clear', -1)
				exports['kk-scripts']:sendLog(xPlayer.identifier, 'A-TEAM', 'Kustutas kõigi vestlusakna.')
			else
				TriggerClientEvent("chatMessage", xPlayer.source, "SÜSTEEM", 1, "Te ei ole veel administraatori õigusi sisse lülitanud.")
			end
		else
			TriggerClientEvent("chatMessage", xPlayer.source, "SÜSTEEM", 1, "Te ei ole administraator.")
		end
	end
end)

RegisterCommand('saveAll', function(source, args)
	local xPlayer = KKF.GetPlayerFromId(source)

	if xPlayer then
		if xPlayer.adminLevel > 3 then
			if Player(xPlayer.source).state.adminMode then
				KKF.SavePlayers()
			else
				TriggerClientEvent("chatMessage", xPlayer.source, "SÜSTEEM", 1, "Te ei ole veel administraatori õigusi sisse lülitanud.")
			end
		else
			TriggerClientEvent("chatMessage", xPlayer.source, "SÜSTEEM", 1, "Te ei ole administraator.")
		end
	end
end)
-- commands end


 --- kk-factions 
KKF.CreateRank = function(jobName, gradeId, label, short, salary, permissions)
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

    KKF.ReloadJobs()
    return true
end


KKF.DeleteRank = function(jobName, gradeId)
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

-- RegisterCommand('setCoords', function(source, args)
-- 	local xPlayer = KKF.GetPlayerFromId(source)

-- 	if xPlayer then
-- 		if xPlayer.adminLevel > 3 then
-- 			if Player(xPlayer.source).state.adminMode then
-- 				SetEntityCoords(GetPlayerPed(xPlayer.source), tonumber(args[1]), tonumber(args[2]), tonumber(args[3]))
-- 			else
-- 				TriggerClientEvent("chatMessage", xPlayer.source, "SÜSTEEM", 1, "Te ei ole veel administraatori õigusi sisse lülitanud.")
-- 			end
-- 		else
-- 			TriggerClientEvent("chatMessage", xPlayer.source, "SÜSTEEM", 1, "Te ei ole arendaja.")
-- 		end
-- 	end
-- end)

-- RegisterCommand('save', function(source, args)
-- 	local xPlayer = KKF.GetPlayerFromId(source)

-- 	if xPlayer then
-- 		if xPlayer.adminLevel > 3 then
-- 			if Player(xPlayer.source).state.adminMode then
-- 				KKF.SavePlayer(xPlayer)
-- 			else
-- 				TriggerClientEvent("chatMessage", xPlayer.source, "SÜSTEEM", 1, "Te ei ole veel administraatori õigusi sisse lülitanud.")
-- 			end
-- 		else
-- 			TriggerClientEvent("chatMessage", xPlayer.source, "SÜSTEEM", 1, "Te ei ole arendaja.")
-- 		end
-- 	end
-- end)


-- RegisterCommand('töö', function(source, args)
-- 	local xPlayer = KKF.GetPlayerFromId(source)

-- 	if xPlayer then
-- 		local duty = "EI"

-- 		if xPlayer.job.onDuty then duty = "JAH" end
	
-- 		TriggerClientEvent("chatMessage", xPlayer.source, "SÜSTEEM", 2, 'Töö: ' .. xPlayer.job.label .. ' - ' .. xPlayer.job.grade_label .. ' | Tööl: ' .. duty)
-- 	end
-- end)

