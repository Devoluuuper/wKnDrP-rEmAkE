local ox_target = exports.ox_target
local targets = {}; local isSitting = false
local modelTargets = {
    {
        models = {-742198632, 1926087217, 384625750, 90130747, 844145437, -525238304, -1527269738, 1506123827, -1358251024, 2084853348, -2046364835, -1619027728},
        options = {
            {
                name = 'cleanH',
                event = 'kk-police:client:cleanHands',
                icon = 'fas fa-hands-wash',
                label = 'Pese käsi',
                distance = 1.5
            },
            {
                name = 'drinkW',
                event = 'kk-scripts:client:drinkWater',
                icon = 'fas fa-hands-wash',
                label = 'Joo vett',
                distance = 1.5
            }
        }
    },

    {
        models = {`s_m_m_prisguard_01`},
        options = {
            {
                name = 'guard',
                event = 'kk-jail:openjailmenu',
                icon = 'fas fa-phone',
                label = 'Vangi valvur',
                distance = 1.5
            },
        }
    },
	

    {
        models = {
            GetHashKey('prop_bench_01a'),
            GetHashKey('prop_bench_01b'),
            GetHashKey('prop_bench_01c'),
            GetHashKey('prop_bench_02'),
            GetHashKey('prop_bench_03'),
            GetHashKey('prop_bench_04'),
            GetHashKey('prop_bench_05'),
            GetHashKey('prop_bench_06'),
            GetHashKey('prop_bench_07'),
            GetHashKey('prop_bench_08'),
            GetHashKey('prop_bench_09'),
            GetHashKey('prop_bench_10'),
            GetHashKey('prop_bench_11'),
            GetHashKey('prop_fib_3b_bench'),
            GetHashKey('prop_ld_bench01'),
            GetHashKey('prop_wait_bench_01'),
            GetHashKey('v_club_stagechair '),
            GetHashKey('hei_prop_heist_off_chair'),
            GetHashKey('hei_prop_hei_skid_chair'),
            GetHashKey('prop_chair_01a'),
            GetHashKey('prop_chair_01b'),
            GetHashKey('prop_chair_02'),
            GetHashKey('prop_chair_03'),
            GetHashKey('prop_chair_04a'),
            GetHashKey('prop_chair_04b'),
            GetHashKey('prop_chair_05'),
            GetHashKey('prop_chair_06'),
            GetHashKey('prop_chair_07'),
            GetHashKey('prop_chair_08'),
            GetHashKey('prop_chair_09'),
            GetHashKey('prop_chair_10'),
            GetHashKey('prop_chateau_chair_01'),
            GetHashKey('prop_clown_chair'),
            GetHashKey('prop_cs_office_chair'),
            GetHashKey('prop_direct_chair_01'),
            GetHashKey('prop_direct_chair_02'),
            GetHashKey('prop_gc_chair02'),
            GetHashKey('prop_off_chair_01'),
            GetHashKey('prop_off_chair_03'),
            GetHashKey('prop_off_chair_04 '),
            GetHashKey('prop_off_chair_04b'),
            GetHashKey('prop_off_chair_04_s'),
            GetHashKey('prop_off_chair_05'),
            GetHashKey('prop_old_deck_chair'),
            GetHashKey('prop_old_wood_chair'),
            GetHashKey('prop_rock_chair_01'),
            GetHashKey('prop_skid_chair_01'),
            GetHashKey('prop_skid_chair_02 '),
            GetHashKey('prop_skid_chair_03'),
            GetHashKey('prop_sol_chair'),
            GetHashKey('prop_wheelchair_01'),
            GetHashKey('prop_wheelchair_01_s'),
            GetHashKey('p_armchair_01_s'),
            GetHashKey('p_clb_officechair_s'),
            GetHashKey('p_dinechair_01_s'),
            GetHashKey('p_ilev_p_easychair_s'),
            GetHashKey('p_soloffchair_s'),
            GetHashKey('p_yacht_chair_01_s'),
            GetHashKey('v_club_officechair'),
            GetHashKey('v_corp_bk_chair3'),
            GetHashKey('v_corp_cd_chair'),
            GetHashKey('v_corp_offchair'),
            GetHashKey('v_ilev_chair02_ped'),
            GetHashKey('v_ilev_hd_chair'),
            GetHashKey('v_ilev_p_easychair'),
            GetHashKey('v_ret_gc_chair03'),
            GetHashKey('prop_ld_farm_chair01'),
            GetHashKey('prop_table_04_chr'),
            GetHashKey('prop_table_05_chr'),
            GetHashKey('prop_table_06_chr'),
            GetHashKey('v_ilev_leath_chr'),
            GetHashKey('prop_table_01_chr_a'),
            GetHashKey('prop_table_01_chr_b'),
            GetHashKey('prop_table_02_chr'),
            GetHashKey('prop_table_03b_chr'),
            GetHashKey('prop_table_03_chr'),
            GetHashKey('prop_torture_ch_01'),
            GetHashKey('v_ilev_fh_dineeamesa'),
            GetHashKey('v_ilev_fh_kitchenstool'),
            GetHashKey('v_ilev_tort_stool'),
            GetHashKey('hei_prop_yah_seat_01'),
            GetHashKey('hei_prop_yah_seat_02'),
            GetHashKey('hei_prop_yah_seat_03'),
            GetHashKey('prop_waiting_seat_01'),
            GetHashKey('prop_yacht_seat_01'),
            GetHashKey('prop_yacht_seat_02'),
            GetHashKey('prop_yacht_seat_03'),
            GetHashKey('prop_hobo_seat_01'),
            GetHashKey('prop_rub_couch01'),
            GetHashKey('miss_rub_couch_01'),
            GetHashKey('prop_ld_farm_couch01'),
            GetHashKey('prop_ld_farm_couch02'),
            GetHashKey('prop_rub_couch02'),
            GetHashKey('prop_rub_couch03'),
            GetHashKey('prop_rub_couch04'),
            GetHashKey('p_lev_sofa_s'),
            GetHashKey('p_res_sofa_l_s'),
            GetHashKey('p_v_med_p_sofa_s'),
            GetHashKey('p_yacht_sofa_01_s'),
            GetHashKey('v_ilev_m_sofa'),
            GetHashKey('v_res_tre_sofa_s'),
            GetHashKey('v_tre_sofa_mess_a_s'),
            GetHashKey('v_tre_sofa_mess_b_s'),
            GetHashKey('v_tre_sofa_mess_c_s'),
            GetHashKey('prop_roller_car_01'),
            GetHashKey('prop_roller_car_02'),
            GetHashKey('v_ret_gc_chair02'),
            GetHashKey('v_serv_ct_chair02')
        },
        options = {
            {
                name = 'sitDown',
                icon = 'fa-solid fa-couch',
                label = 'Istu maha',
                distance = 1.5,
                onSelect = function(data)
                    lib.callback('kk-scripts:sitDown', false, function(response)
                        if response then
                            local entityPos = GetEntityCoords(data.entity)
                            local x, y, z = table.unpack(entityPos); isSitting = true
                            
                            KKF.ShowInteraction('Tõuse püsti', 'E')
                            TaskStartScenarioAtPosition(cache.ped, 'PROP_HUMAN_SEAT_CHAIR_MP_PLAYER', entityPos.x, entityPos.y, entityPos.z + 0.5, GetEntityHeading(data.entity) + 180.0, 0, true, true)
    
                            while isSitting do
                                if IsControlJustReleased(0, 38) then
                                    TriggerServerEvent('kk-scripts:server:leaveChair', NetworkGetNetworkIdFromEntity(data.entity)); isSitting = false
                                end
    
                                Wait(5)
                            end
    
                            KKF.HideInteraction(); SetEntityCoords(cache.ped, vec3(x, y, z + 0.5)) ClearPedTasksImmediately(cache.ped);
                        else
                            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Keegi istub juba sellel toolil.')
                        end
                    end, NetworkGetNetworkIdFromEntity(data.entity))
                end
            }
        }
    }
}

local function loadTargets()
    for k,v in pairs(modelTargets) do
        ox_target:addModel(v.models, v.options)
    end

    targets[#targets + 1] = ox_target:addBoxZone({
        coords = vec3(-59.41, -1208.19, 28.33),
        size = vec3(1, 1, math.abs(29.18 - 25.18)),
        rotation = 45,
        debug = false,
        options = {
            {
                event = 'kk-factions:akuma:openTask',
                icon = 'fas fa-hand-paper',
                label = 'Räägi mehega',
                distance = 1.5,
                canInteract = function(entity, distance, coords)
                    return KKF.PlayerData.job.name == 'akuma'
                end
            }
        }
    })

    targets[#targets + 1] = ox_target:addBoxZone({
        coords = vec3(621.3, 7.9, 83.65),
        size = vec3(0.8, 1.65, 0.45),
        rotation = 340.25,
        debug = false,
        options = {
            {
                serverEvent = 'kk-police:server:buyNewId',
                icon = 'fa-solid fa-id-card',
                label = 'Uus isikutunnistus'
            },

            { 
                event = 'kk-police:client:application',
                icon = 'fa-solid fa-clipboard',
                label = 'Kandideeri'
            }, 

            { 
                event = 'kk-police:client:statement',
                icon = 'fa-solid fa-clipboard',
                label = 'Avaldus'
            },

            { 
                event = 'kk-police:client:punishmentCheck',
                icon = 'fas fa-user-ninja',
                label = 'Karistusregister'
            }
        }
    })

    targets[#targets + 1] = ox_target:addBoxZone({
        coords = vec3(-56.75, -1098.5, 26.0),
        size = vec3(2.5, 4.75, 5.0),
        rotation = 300.0,
        debug = false,
        options = {
            {
                event = 'kk-vehicleshop:client:open',
                icon = 'fa-solid fa-car',
                label = 'Ava autopood',
                distance = 1.5
            }
        }
    })

    targets[#targets + 1] = ox_target:addBoxZone({
        coords = vec3(-616.86236572266, -1621.9044189453, 33.01),
        size = vec3(1.3, 3.6, math.abs(33.5 - 32.01)),
        rotation = 177,
        debug = false,
        options = {
            {
                serverEvent = 'kk-trashbins:server:sell',
                icon = 'fas fa-dollar-sign',
                label = 'Müü bottlet',
                distance = 1.5
            }
        }
    })

    targets[#targets + 1] = ox_target:addBoxZone({
        coords = vec3(266.11, -1008.3, -100.73),
        size = vec3(1.0, 1.6, math.abs(-99.53 - -103.53)),
        rotation = 1,
        debug = false,
        options = {
            {
                event = 'kk-apartments:client:leave',
                icon = 'fas fa-sign-out-alt',
                label = 'Lahku korterist',
                distance = 1.5
            }
        }
    })

    targets[#targets + 1] = ox_target:addBoxZone({
        coords = vec3(-785.88, 323.65, 212.0),
        size = vec3(2.0, 1, math.abs(213.5 - 209.5)),
        rotation = 0,
        debug = false,
        options = {
            {
                event = 'kk-apartments:client:leave',
                icon = 'fas fa-sign-out-alt',
                label = 'Lahku korterist',
                distance = 1.5
            }
        }
    })

    targets[#targets + 1] = ox_target:addBoxZone({
        coords = vec3(259.7, -1004.73, -99.01),
        size = vec3(1.0, 1.8, math.abs(-97.76 - -101.76)),
        rotation = 359,
        debug = false,
        options = {
            {
                event = 'wardrobe:clothingShop',
                icon = 'fas fa-tshirt',
                label = 'Riidekapp',
                distance = 1.5
            },

            {
                serverEvent = 'kk-core:server:unload',
                icon = 'fas fa-person-booth',
                label = 'Vaheta karakterit',
                distance = 1.5
            }
        }
    })

    targets[#targets + 1] = ox_target:addBoxZone({
        coords = vec3(-793.66, 326.84, 210.8),
        size = vec3(4.2, 4.6, math.abs(213.0 - 209.0)),
        rotation = 4,
        debug = false,
        options = {
            {
                event = 'wardrobe:clothingShop',
                icon = 'fas fa-tshirt',
                label = 'Riidekapp',
                distance = 1.5
            },

            {
                serverEvent = 'kk-core:server:unload',
                icon = 'fas fa-person-booth',
                label = 'Vaheta karakterit',
                distance = 1.5
            }
        }
    })

    targets[#targets + 1] = ox_target:addBoxZone({
        coords = vec3(-767.06, 328.01, 211.4),
        size = vec3(3.8, 1, math.abs(213.6 - 210.2)),
        rotation = 4,
        debug = false,
        options = {
            {
                event = 'kk-properties:client:openStash:high',
                icon = 'fas fa-box',
                label = 'Ava kapp',
                distance = 1.5
            }
        }
    })

    targets[#targets + 1] = ox_target:addBoxZone({
        coords = vec3(-790.66, 329.8, 210.8),
        size = vec3(1.8, 1, math.abs(211.25 - 207.05)),
        rotation = 0,
        debug = false,
        options = {
            {
                event = 'kk-properties:client:openStash',
                icon = 'fas fa-box',
                label = 'Ava kapp',
                distance = 1.5
            }
        }
    })


    targets[#targets + 1] = ox_target:addBoxZone({
        coords = vec3(-1602.13, -3012.61, -77.8),
        size = vec3(1.5, 1.0, math.abs(-77.6 - -81.6)),
        rotation = 0,
        debug = false,
        options = {
            {
                event = 'club:djbooth',
                icon = 'fa-solid fa-headphones',
                label = 'DJ Booth',
                distance = 1.5,
                canInteract = function(entity, distance, coords)
                    return KKF.PlayerData.job.name == 'bubblegum' and KKF.PlayerData.job.onDuty
                end
            }
        }
    })

    targets[#targets + 1] = ox_target:addBoxZone({
        coords = vec3(266.67, -999.38, -99.01),
        size = vec3(1.6, 1.0, math.abs(-98.81 - -102.81)),
        rotation = 0,
        debug = false,
        options = {
            {
                event = 'kk-properties:client:openStash',
                icon = 'fas fa-box',
                label = 'Ava kapp',
                distance = 1.5
            }
        }
    })

    targets[#targets + 1] = ox_target:addBoxZone({
        coords = vec3(-796.48, 329.11, 217.04),
        size = vec3(1.0, 1.6, math.abs(217.84 - 213.84)),
        rotation = 0,
        debug = false,
        options = {
            {
                event = 'kk-properties:client:openHouseStash',
                icon = 'fas fa-box',
                label = 'Ava kapp',
                distance = 1.5
            },

--[[        {
                event = 'kk-properties:client:upgradeHouseStash',
                icon = 'fa-solid fa-arrow-up',
                label = 'Uuenda kappi',
                distance = 1.5
            }           ]]
        }
    })

    targets[#targets + 1] = ox_target:addSphereZone({
        coords = vec3(441.91, -982.05, 30.69),
        radius = 0.4,
        debug = false,
        options = {
            {
                event = 'kk-police:client:sendMessageToOfficers',
                icon = 'far fa-clipboar',
                label = 'Esita avaldus'
            }
        }
    })
end

RegisterNetEvent('KKF.Player.Loaded', function(xPlayer)
    KKF.PlayerData = xPlayer; loadTargets()
end)

RegisterNetEvent('KKF.Player.JobUpdate', function(job)
	KKF.PlayerData.job = job
end)

RegisterNetEvent('KKF.Player.DutyChange', function(value)
	KKF.PlayerData.job.onDuty = value
end)

local function unloadTargets()
    for k,v in pairs(targets) do
        ox_target:removeZone(v); targets[k] = nil
    end

    for k,v in pairs(modelTargets) do
        local options = {}

        for k2,v2 in pairs(v.options) do
            options[#options + 1] = v2.name
        end

        ox_target:removeModel(v.models, options)
    end
end

RegisterNetEvent('KKF.Player.Unloaded', function()
    KKF.PlayerData = {}; unloadTargets()
end)