RegisterNetEvent("kk-badge:client:showBadge")
AddEventHandler(
    "kk-badge:client:showBadge",
    function(badgeInfo, pid)
        local person_src = pid
        local pid = GetPlayerFromServerId(person_src)
        local targetPed = GetPlayerPed(pid)
        local myCoords = GetEntityCoords(PlayerPedId())
        local targetCoords = GetEntityCoords(targetPed)

        if pid ~= -1 then
            if #(myCoords - targetCoords) <= 3.5 then
                SendNUIMessage(
                    {
                        action = 'showBadge',
                        name = badgeInfo.name,
                        rank = string.upper(badgeInfo.rank),
                        serial = '#' .. badgeInfo.serial,
                        picture = badgeInfo.picture,
                        department = badgeInfo.department 
                    }
                )
            end
        end
    end
)

RegisterNetEvent("kk-badge:client:viewBadge")
AddEventHandler(
    "kk-badge:client:viewBadge",
    function(badgeInfo, pid)
        SendNUIMessage(
            {
                action = 'showBadge',
                name = badgeInfo.name,
                rank = string.upper(badgeInfo.rank),
                serial = '#' .. badgeInfo.serial,
                picture = badgeInfo.picture,
                department = badgeInfo.department 
            }
        )
    end
)

RegisterNetEvent("kk-badge:client:animation")
AddEventHandler(
    "kk-badge:client:animation",
    function()
        lib.requestModel(GetHashKey("prop_fib_badge"))

        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local badgeProp = CreateObject(GetHashKey("prop_fib_badge"), coords.x, coords.y, coords.z + 0.2, true, true, true)
        SetEntityCollision(badgeProp, false, false)
        local boneIndex = GetPedBoneIndex(ped, 28422)

        AttachEntityToEntity(
            badgeProp,
            ped,
            boneIndex,
            0.065,
            0.029,
            -0.035,
            80.0,
            -1.90,
            75.0,
            true,
            true,
            false,
            true,
            1,
            true
        )

        lib.requestAnimDict('paper_1_rcm_alt1-9')
        TaskPlayAnim(ped, "paper_1_rcm_alt1-9", "player_one_dual-9", 15.0, -15, 5000, 49, 0, 0, 0, 0)
        Citizen.Wait(3000)
        ClearPedTasks(ped)
        DeleteObject(badgeProp)
    end
)

