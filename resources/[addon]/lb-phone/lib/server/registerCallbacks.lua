---@class CallbackOptions
---@field preventSpam? boolean # Prevents the same callback from being called until the previous one has finished
---@field rateLimit? number # How many times this callback can be called per player per minute
---@field defaultReturn? any # Default return value if the callback is not called or fails

---@type { [string]: EventHandler }
local registeredCallbacks = {}

---<b>Key:</b> Resource name<br><b>Value:</b> Array of callbacks that have been registered by the resource
---@type { [string]: string[] }
local exportCallbacks = {}

---<b>Key:</b> Player source<br><b>Value:</b> Lookup table of callback names and how many times they have been called in the last minute
---@type { [number]: { [string]: number } }
local callbackRateLimits = {}

---<b>Key:</b> Source<br><b>Value:</b> Lookup table of callbacks that have been triggered but not yet finished
---@type { [number]: { [string]: boolean } }
local triggeredCallbacks = {}

---@param source number
---@param callbackName string
---@param options CallbackOptions
---@return boolean
local function CanPlayerTriggerCallback(source, callbackName, options)
    if not options then
        return true
    end

    if options.preventSpam then
        if not triggeredCallbacks[source] then
            triggeredCallbacks[source] = {}
        end

        if triggeredCallbacks[source][callbackName] then
            debugprint(("callback '%s' is already being processed for player %s"):format(callbackName, source))
            return false
        end
    end

    if options.rateLimit then
        if not callbackRateLimits[source] then
            callbackRateLimits[source] = {}
        end

        local callsPastMinute = math.max(callbackRateLimits[source][callbackName] or 0, 0)

        if callsPastMinute >= options.rateLimit then
            debugprint(("callback '%s' has reached rate limit for player %s"):format( callbackName, source))
            return false
        end

        callbackRateLimits[source][callbackName] = callsPastMinute + 1

        SetTimeout(60000, function()
            if not callbackRateLimits[source] or not callbackRateLimits[source][callbackName] or callbackRateLimits[source][callbackName] <= 0 then
                return
            end

            callbackRateLimits[source][callbackName] = callbackRateLimits[source][callbackName] - 1
        end)
    end

    if options.preventSpam then
        triggeredCallbacks[source][callbackName] = true
    end

    return true
end

---@param event string
---@param handler fun(source: number, ...) : ...any
---@param options? CallbackOptions
function RegisterCallback(event, handler, options)
    assert(registeredCallbacks[event] == nil, ("event '%s' is already registered"):format(event))

    registeredCallbacks[event] = RegisterNetEvent("lb-phone:cb:" .. event, function(requestId, ...)
        local src = source

        if options and not CanPlayerTriggerCallback(src, event, options) then
            TriggerClientEvent("lb-phone:cb:response", src, requestId, options.defaultReturn)
            return
        end

        local params = { ... }
        local startTime = os.nanotime()

        local success, errorMessage = pcall(function()
            TriggerClientEvent("lb-phone:cb:response", src, requestId, handler(src, table.unpack(params)))

            local finishTime = os.nanotime()
            local ms = (finishTime - startTime) / 1e6

            debugprint(("Callback ^5%s^7 took %.4fms"):format(event, ms))
        end)

        if not success then
            local stackTrace = Citizen.InvokeNative(`FORMAT_STACK_TRACE` & 0xFFFFFFFF, nil, 0, Citizen.ResultAsString())

            print(("^1SCRIPT ERROR: Callback '%s' failed: %s^7\n%s"):format(event, errorMessage or "", stackTrace or ""))
            TriggerClientEvent("lb-phone:cb:response", src, requestId, options and options.defaultReturn or nil)
        end

        if options and options.preventSpam and triggeredCallbacks[src] then
            triggeredCallbacks[src][event] = nil
        end
    end)
end

---@param event string
---@param handler fun(source: number, cb: fun(...), ...)
---@param options? CallbackOptions
function RegisterLegacyCallback(event, handler, options)
    RegisterNetEvent("lb-phone:cb:" .. event, function(requestId, ...)
        local src = source

        if options and not CanPlayerTriggerCallback(src, event, options) then
            TriggerClientEvent("lb-phone:cb:response", src, requestId, options.defaultReturn)
            return
        end

        local params = { ... }
        local startTime = os.nanotime()

        local success, errorMessage = pcall(function()
            handler(src, function(...)
                TriggerClientEvent("lb-phone:cb:response", src, requestId, ...)

                local finishTime = os.nanotime()
                local ms = (finishTime - startTime) / 1e6

                debugprint(("Callback ^5%s^7 took %.4fms"):format(event, ms))
            end, table.unpack(params))
        end)

        if not success then
            local stackTrace = Citizen.InvokeNative(`FORMAT_STACK_TRACE` & 0xFFFFFFFF, nil, 0, Citizen.ResultAsString())

            print(("^1SCRIPT ERROR: Callback '%s' failed: %s^7\n%s"):format(event, errorMessage or "", stackTrace or ""))
            TriggerClientEvent("lb-phone:cb:response", src, requestId, options and options.defaultReturn or nil)
        end

        if options and options.preventSpam and triggeredCallbacks[src] then
            triggeredCallbacks[src][event] = nil
        end
    end)
end

---@param event string
---@param callback fun(source: number, phoneNumber: string, ...) : ...
---@param defaultReturn any
---@param options? CallbackOptions
function BaseCallback(event, callback, defaultReturn, options)
    if options and options.defaultReturn and defaultReturn == nil then
        defaultReturn = options.defaultReturn
    end

    RegisterCallback(event, function(source, ...)
        local phoneNumber = GetEquippedPhoneNumber(source)

        if not phoneNumber then
            debugprint(("^1%s^7: no phone number found for %s | %s"):format(event, GetPlayerName(source), source))
            return defaultReturn
        end

        return callback(source, phoneNumber, ...)
    end, options)
end

---@param resource string
---@param event string
---@return boolean
local function CanResourceRegisterCallback(resource, event)
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

    return true
end

---@param event string
---@param handler fun(source: number, phoneNumber: string, ...) : any
---@param options? CallbackOptions
exports("RegisterCallback", function(event, handler, options)
    local resource = GetInvokingResource()

    if CanResourceRegisterCallback(resource, event) then
        RegisterCallback(event, handler, options)
    end
end)

---@param event string
---@param handler fun(source: number, phoneNumber: string, ...) : any
---@param options? CallbackOptions
exports("BaseCallback", function(event, handler, options)
    local resource = GetInvokingResource()

    if CanResourceRegisterCallback(resource, event) then
        BaseCallback(event, handler, nil, options)
    end
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

AddEventHandler("playerDropped", function()
    local src = source

    triggeredCallbacks[src] = nil
    callbackRateLimits[src] = nil
end)
