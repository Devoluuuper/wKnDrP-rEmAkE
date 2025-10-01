RegisterNUICallback('searchCandidations', function(args, cb)
    lib.callback('kk-mdt:searchCandidations', false, function(response)
        cb(response)
    end, args.value)
end)

function OpenCandidateDialog()
    local dialog = lib.inputDialog("Kandideeri", {
        {label = "Ees- ja perekonnanimi", type = "input"},
        {label = "E-post", type = "input"},
        {label = "Motivatsioonikiri", type = "input", multiline = true}
    })

    if dialog then
        local fullName = dialog[1]
        local email = dialog[2]
        local motivation = dialog[3]

        if fullName == "" or email == "" or motivation == "" then
            lib.notify({
                title = "Viga",
                description = "Palun täida kõik väljad.",
                type = "error"
            })
            return
        end

        -- Corrected lib.callback call
        lib.callback('kk-mdt:insertCandidateWithTime', false, function(result)
            if result and result.success then
                lib.notify({
                    title = "Edu",
                    description = "Kandideerimine õnnestus!",
                    type = "success"
                })
            else
                lib.notify({
                    title = "Viga",
                    description = result and result.message or "Midagi läks valesti",
                    type = "error"
                })
            end
        end, fullName, email, motivation) -- Arguments passed after the callback function
    end
end

-- Ox_target setup
for _, loc in ipairs(cfg.cand) do
    exports.ox_target:addBoxZone({
        coords = loc.coords,
        size = loc.size,
        rotation = loc.rotation,
        debug = false,
        options = {
            {
                name = 'apply_candidate',
                event = 'kk-mdt:openCandidateDialog',
                icon = 'fa-solid fa-user',
                label = 'Kandideeri',
            },
        }
    })
end

-- Event inputDialoogi avamiseks
RegisterNetEvent('kk-mdt:openCandidateDialog', function()
    OpenCandidateDialog()
end)