local CALLBACK_TIMEOUT <const> = 15

---@type { [number]: { cb: fun(...), event: string } }
local waitingCallbacks = {}

---@param requestId number
---@param ... any
RegisterNetEvent("lb-phone:cb:response", function(requestId, ...)
    local callback = waitingCallbacks[requestId]

    if callback then
        local success, errorMessage = pcall(callback.cb, ...)

        if not success then
            local stackTrace = Citizen.InvokeNative(`FORMAT_STACK_TRACE` & 0xFFFFFFFF, nil, 0, Citizen.ResultAsString())

            print(("^1SCRIPT ERROR: Callback response '%s' failed: %s^7\n%s"):format(callback.event, errorMessage or "", stackTrace or ""))
        end

        waitingCallbacks[requestId] = nil
    end
end)

local function GenerateRequestId()
    local requestId = math.random(999999999)

    while waitingCallbacks[requestId] do
        requestId = math.random(999999999)
    end

    return requestId
end

---@param event string
---@param source number
---@param cb fun(...)
function TriggerClientCallback(event, source, cb, ...)
    local requestId = GenerateRequestId()

    waitingCallbacks[requestId] = { cb = cb, event = event }

    SetTimeout(CALLBACK_TIMEOUT * 1000, function()
        if waitingCallbacks[requestId] then
            infoprint("error", ("Client callback ^1%s^7 timed out after %is. Triggered on %i"):format(event, CALLBACK_TIMEOUT, source))

            waitingCallbacks[requestId].cb()
            waitingCallbacks[requestId] = nil
        end
    end)

    TriggerClientEvent("lb-phone:cb:" .. event, source, requestId, ...)
end

exports("TriggerClientCallback", TriggerClientCallback)

---@param event string
---@param source number
---@param ... any
function AwaitClientCallback(event, source, ...)
    local responsePromise = promise.new()

    TriggerClientCallback(event, source, function(...)
        responsePromise:resolve({ ... })
    end, ...)

    local result = Citizen.Await(responsePromise)

    return table.unpack(result)
end

exports("AwaitClientCallback", AwaitClientCallback)
