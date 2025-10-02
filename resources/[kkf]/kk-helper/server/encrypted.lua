local cooldowns = {}
local activeTasks = {}
local maxTasks = 12
local cooldownTime = 10
local itemNames = {}

-- Laadi mängija taskid andmebaasist
local function loadPlayerTasks(playerId)
    local result = MySQL.Sync.fetchAll('SELECT data FROM helper_job WHERE pid = @pid', {
        ['@pid'] = playerId
    })

    if result[1] and result[1].data then
        local decoded = json.decode(result[1].data)
        if decoded then
            return {
                default = decoded.default or 1
            }
        end
    end
    return { default = 1 }
end

-- Salvesta mängija taskid
local function savePlayerTasks(playerId, data)
    local encoded = json.encode(data)
    MySQL.Sync.execute([[
        INSERT INTO helper_job (pid, data) VALUES (@pid, @data)
        ON DUPLICATE KEY UPDATE data = @data
    ]], {
        ['@pid'] = playerId,
        ['@data'] = encoded
    })
end

-- Järgmise taski määramine
local function getNextTask(playerData)
    if not cfg or not cfg.locations or not cfg.locations['default'] or not cfg.locations['default'].tasks then
        return nil, nil
    end

    local tasks = cfg.locations['default'].tasks
    local nextId = playerData.default or 1

    if nextId > #tasks then
        return nil, nil
    end

    local task = tasks[nextId]
    if not task then
        return nil, nil
    end

    return nextId, task
end

-- Aktiivse taski leidmine mängija jaoks
local function getActiveTaskForPlayer(playerId)
    for source, data in pairs(activeTasks) do
        if data.playerId == playerId then
            return source, data
        end
    end
    return nil, nil
end

-- Lib callbacks KKF
lib.callback.register('kk-helper:recieveContract', function(source, npcKey)
    local xPlayer = KKF.GetPlayerFromId(source)
    if not xPlayer then return end

    local now = os.time()
    if cooldowns[source] and (now - cooldowns[source] < cooldownTime) then
        return
    end

    local playerId = xPlayer.getIdentifier()
    local playerData = loadPlayerTasks(playerId)

    if playerData.default and playerData.default > maxTasks then
        return cfg.translations[cfg.language]['no_need']
    end

    local activeSource, activeTask = getActiveTaskForPlayer(playerId)
    if activeTask then
        return 'active'
    end

    local index, task = getNextTask(playerData)
    if not task then
        return cfg.translations[cfg.language]['no_need']
    end

    activeTasks[source] = {
        playerId = playerId,
        taskIndex = index,
        task = task
    }

    cooldowns[source] = now

    return task
end)

lib.callback.register('kk-helper:startContract', function(source)
    local taskData = activeTasks[source]
    if not taskData then return end
    return taskData.task.location
end)

lib.callback.register('kk-helper:deliver', function(source)
    local xPlayer = KKF.GetPlayerFromId(source)
    if not xPlayer then return false end

    local taskData = activeTasks[source]
    if not taskData then return false end

    local playerId = taskData.playerId
    local task = taskData.task

    -- Kontrolli vajalikke esemeid
    for item, count in pairs(task.items) do
        local playerItem = xPlayer.getInventoryItem(item)
        if not playerItem or playerItem.count < count then
            TriggerClientEvent('KKF.UI.ShowNotification', source, 'error', cfg.translations[cfg.language]['not_needed'])
            return false
        end
    end

    -- Eemalda esemed
    for item, count in pairs(task.items) do
        xPlayer.removeInventoryItem(item, count)
    end

    -- Anna tasu
    xPlayer.addInventoryItem(task.reward.name, task.reward.count or 1)

    -- Salvesta progress
    local playerData = loadPlayerTasks(playerId)
    playerData.default = (playerData.default or 1) + 1
    savePlayerTasks(playerId, playerData)

    -- Kustuta aktiivne task
    activeTasks[source] = nil

    TriggerClientEvent('KKF.UI.ShowNotification', source, 'success', cfg.translations[cfg.language]['nice_work'])

    return true
end)

-- Cancel task
RegisterNetEvent('kk-helper:cancelTask', function(confirmed)
    local src = source
    if confirmed == 'cancel' and activeTasks[src] then
        activeTasks[src] = nil
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', cfg.translations[cfg.language]['not_great_time'])
    end
end)
