---@type { [string]: EventHandler }
local registeredCallbacks = {}

---<b>Key:</b> Resource name<br><b>Value:</b> Array of callbacks that have been registered by the resource
---@type { [string]: string[] }
local exportCallbacks = {}

---@param event string
---@param handler fun(...) : ...any
function RegisterClientCallback(event, handler)
    assert(type(event) == "string", "event must be a string")
    assert(registeredCallbacks[event] == nil, ("event '%s' is already registered"):format(event))

    registeredCallbacks[event] = RegisterNetEvent("lb-phone:cb:" .. event, function(requestId, ...)
        local params = { ... }
        local startTime = GetGameTimer()

        local success, errorMessage = pcall(function()
            TriggerServerEvent("lb-phone:cb:response", requestId, handler(table.unpack(params)))

            local ms = GetGameTimer() - startTime

            debugprint(("Callback ^5%s^7 took %ims"):format(event, ms))
        end)

        if not success then
            local stackTrace = Citizen.InvokeNative(`FORMAT_STACK_TRACE` & 0xFFFFFFFF, nil, 0, Citizen.ResultAsString())

            print(("^1SCRIPT ERROR: Client callback '%s' failed: %s^7\n%s"):format(event, errorMessage or "", stackTrace or ""))
        end
    end) --[[@as EventHandler]]
end

---@param event string
---@param handler fun(...) : ...any
exports("RegisterClientCallback", function(event, handler)
    local resource = GetInvokingResource()

    if registeredCallbacks[event] then
        infoprint("error", ("Callback '%s' is already registered"):format(event))

        return false
    end

    if not exportCallbacks[resource] then
        exportCallbacks[resource] = {}
    end

    if table.contains(exportCallbacks[resource], event) then
        infoprint("error", ("Callback '%s' is already registered by resource '%s'"):format(event, resource))

        return false
    end

    table.insert(exportCallbacks[resource], event)

    RegisterClientCallback(event, handler)
end)

---@param resource string
AddEventHandler("onResourceStop", function(resource)
    local callbacks = exportCallbacks[resource]

    if not callbacks then
        return
    end

    for i = 1, #callbacks do
        local event = callbacks[i]
        local eventHandler = registeredCallbacks[event]

        if eventHandler then
            RemoveEventHandler(eventHandler)
        end

        registeredCallbacks[event] = nil
    end

    exportCallbacks[resource] = nil
end)
