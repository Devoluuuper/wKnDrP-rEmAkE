Config = {
    PawnShopLocations = {
        vector3(412.4439697265625,314.76922607421877,103.11572265625)
    },

    PawnShopPrices = {
        ring = {
            label = 'Sõrmus',
            price = 341
        },
        rolexwatch = {
            label = 'Rolex käekell',
            price = 403
        },
        goldwatch = {
            label = 'Kuldkell',
            price = 527
        },
		tiamond = {
            label = 'Kallis Teemant',
            price = 1593
        },
		ruby = {
            label = 'Rubiin',
            price = 1105
        },
		sapphire = {
            label = 'Safiir',
            price = 1105
        },
		emerald = {
            label = 'Emerald',
            price = 1333
        },
		goldbar = {
            label = 'Kullakang',
            price = 1040
        },
        neckless = {
            label = 'Kaelakee',
            price = 510
        } 
    },

    PaymentList = {


        [1] = {
            owner = 'burgershot',
            target = {
                coords = vec3(-1190.65, -895.6, 14.2),
                size = vec3(0.5, 0.6, 0.5),
                rotation = 305.0,
            }
        },
        
        [2] = {
            owner = 'burgershot',
            target = {
                coords = vec3(-1189.05, -894.6, 14.0),
                size = vec3(0.6, 0.7, 0.9),
                rotation = 33.75,
            }
        },
        
        [3] = {
            owner = 'burgershot',
            target = {
                coords = vec3(-1187.5, -893.55, 14.1),
                size = vec3(0.6, 0.65, 0.7),
                rotation = 35.0,
            }
        },

        [4] = {
            owner = 'burgershot',
            target = {
                coords = vec3(-1194.8, -905.25, 14.0),
                size = vec3(0.55, 0.8, 0.65),
                rotation = 350.0,
            }
        },

        [5] = {
            owner = 'uwucafe',
            target = {
                coords = vec3(-584.05, -1061.45, 22.45),
                size = vec3(0.7, 0.35, 0.3),
                rotation = 359.75,
            }
        },

        [6] = {
            owner = 'uwucafe',
            target = {
                coords = vec3(-584.05, -1058.7, 22.45),
                size = vec3(0.5, 0.35, 0.25),
                rotation = 7.75,
            }
        },
        [7] = {
            owner = 'uwucafe',
            target = {
                coords = vec3(4909.7, -4929.5, 3.35),
                size = vec3(0.5, 0.6, 0.4),
                rotation = 335.0,
            }
        },

        [8] = {
            owner = 'bean',
            target = {
                coords = vec3(-634.4, 235.95, 82.25),
                size = vec3(0.55, 0.4, 0.4),
                rotation = 22.25,
            }
        },
        [9] = {
            owner = 'bean',
            target = {
                coords = vec3(4910.75, -4930.0, 3.35),
                size = vec3(0.4, 0.65, 0.45),
                rotation = 349.0,
            }
        },
        
        [10] = {
            owner = 'bean',
            target = {
                coords = vec3(-634.3, 234.6, 82.2),
                size = vec3(0.6, 0.5, 0.5),
                rotation = 347.5,
            }
        },

        [11] = {
            owner = 'bennys',
            target = {
                coords = vec3(-195.55, -1316.4, 31.25),
                size = vec3(0.5, 0.45, 0.5),
                rotation = 0.0,
            }
        },
        [12] = {
            owner = 'harmony',
            target = {
                coords = vec3(1187.1, 2638.1, 38.3),
                size = vec3(0.5, 0.6, 0.45),
                rotation = 0.0,
            }
        },

        [13] = {
            owner = 'hayes',
            target = {
                coords = vec3(952.55, -967.7, 39.5),
                size = vec3(0.55, 0.55, 0.45),
                rotation = 1.5,
            }
        },


        [14] = {
            owner = 'eventure',
            target = {
                coords = vec3(125.55, -3007.25, 7.0),
                size = vec3(0.5, 0.45, 0.45),
                rotation = 349.25,
            }
        },

        [15] = {
            owner = 'eventure',
            target = {
                coords = vec3(147.25, -3014.1, 7.0),
                size = vec3(0.5, 0.5, 0.75),
                rotation = 0.0,
            }
        },

        [16] = {
            owner = 'eventure',
            target = {
                coords = vec3(4901.6, -4943.15, 3.55),
                size = vec3(0.55, 0.35, 0.45),
                rotation = 333.5,
            }
        },

        [17] = {
            owner = 'eventure',
            target = {
                coords = vec3(4904.6, -4940.75, 3.55),
                size = vec3(0.5, 0.6, 0.50000000000001),
                rotation = 29.75,
            }
        },

        [18] = {
            owner = 'eventure',
            target = {
                coords = vec3(4906.7, -4939.95, 3.6),
                size = vec3(0.4, 0.6, 0.4),
                rotation = 28.25,
            }
        },

    },

    Peds = {
        { model="s_f_y_stripper_02", x=112.68, y=-1288.3, z=27.46, h=238.85, animation="mini@strip_club@private_dance@idle", animationName="priv_dance_idle"},
        { model="s_f_y_stripperlite", x=111.99, y=-1286.03, z=27.46, h=308.8, animation="mini@strip_club@lap_dance@ld_girl_a_song_a_p1", animationName="ld_girl_a_song_a_p1_f"},
        --{ model="s_f_y_stripperlite", x=113.00, y=-1287.01, z=28.46, a=294.26, animation="mini@strip_club@pole_dance@pole_dance1", animationName="pd_dance_01"},
        { model="csb_stripper_01", x=108.72, y=-1289.33, z=27.86, h=295.53, animation="mini@strip_club@private_dance@part2", animationName="priv_dance_p2"},
        { model="s_f_y_stripper_01", x=103.21, y=-1292.59, z=28.26, h=296.21, animation="mini@strip_club@private_dance@part1", animationName="priv_dance_p1"},
        { model="s_f_y_stripper_02", x=104.66, y=-1294.46, z=28.26, h=287.12, animation="mini@strip_club@lap_dance@ld_girl_a_song_a_p1", animationName="ld_girl_a_song_a_p1_f"},
        { model="a_f_y_topless_01", x=102.26, y=-1289.92, z=28.26, h=292.05, animation="mini@strip_club@private_dance@idle", animationName="priv_dance_idle"},
        { model="s_m_m_prisguard_01", x=1788.9494628906, y=2599.1208496094, z=44.792724609375, h=104.88188934326, animation="anim@amb@nightclub@peds@", animationName="rcmme_amanda1_stand_loop_cop"},
        { model="s_m_y_prismuscl_01", x = 1780.5098876953, y = 2572.8659667969, z = 44.792724609375, h = 53.858268737793, animation="anim@heists@heist_corona@single_team", animationName="single_team_loop_boss"}
        -- { model="ig_bankman", x = 149.36888122559, y = -1042.1033935547, z = 28.367990493774, h = 343.35427856445, animation="anim@heists@heist_corona@single_team", animationName="single_team_loop_boss"}, --3
        -- { model="ig_bankman", x = 313.80151367188, y = -280.43865966797, z = 53.164691925049, h = 338.2038269043, animation="anim@heists@heist_corona@single_team", animationName="single_team_loop_boss"}, --1
        -- { model="ig_bankman", x = -1211.9820556641, y = -331.94921875, z = 36.780944824219, h = 27.251558303833, animation="anim@heists@heist_corona@single_team", animationName="single_team_loop_boss"}, --2
        -- { model="ig_bankman", x = -2961.1362304688, y = 482.97409057617, z = 14.697009086609, h = 92.804962158203, animation="anim@heists@heist_corona@single_team", animationName="single_team_loop_boss"}, --4
        -- { model="ig_bankman", x = 1174.9703369141, y = 2708.2229003906, z = 37.087928771973, h = 183.37882995605, animation="anim@heists@heist_corona@single_team", animationName="single_team_loop_boss"}, --5
        -- { model="ig_bankman", x = -113.62679290771, y = 6470.6850585938, z = 30.626722335815, h = 180.9467010498, animation="anim@heists@heist_corona@single_team", animationName="single_team_loop_boss"}, --6
        -- { model="ig_bankman", x = -351.20272827148, y = -51.296775817871, z = 48.036472320557, h = 347.59219360352, animation="anim@heists@heist_corona@single_team", animationName="single_team_loop_boss"}, --7
        -- { model="ig_bankman", x = 257.33697509766, y = 228.06986999512, z = 105.28218078613, h = 159.98928833008, animation="anim@heists@heist_corona@single_team", animationName="single_team_loop_boss"}, --9 Praffic
    },

    BackWeapons = {
        ['WEAPON_SMG'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_sb_smg'},
        ['WEAPON_MG'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_mg_mg'},
        ['WEAPON_COMBATMG'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_mg_combatmg'},
        ['WEAPON_COMBATMG_MK2'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_mg_combatmgmk2'},
        ['WEAPON_GUSENBERG'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_sb_gusenberg'},
        ['WEAPON_ASSAULTSMG'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_sb_assaultsmg'},
        ['WEAPON_CARBINERIFLE'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_ar_carbinerifle'},
        ['WEAPON_CARBINERIFLE_MK2'] = {x = 0.075, y = -0.15, z = -0.12, xRot = 0.0, yRot = 185.0, zRot = 0.0, model = 'w_ar_carbineriflemk2'},
        ['WEAPON_SPECIALCARBINE'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_ar_specialcarbine'},
        ['WEAPON_BULLPUPRIFLE'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_ar_bullpuprifle'},
        ['WEAPON_BULLPUPRIFLE_MK2'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_ar_bullpupriflemk2'},
        ['WEAPON_BULLPUPSHOTGUN'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_sg_bullpupshotgun'},
        ['WEAPON_ASSAULTSHOTGUN'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_sg_assaultshotgun'},
        ['WEAPON_MUSKET'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_ar_musket'},
        ['WEAPON_HEAVYSHOTGUN'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_sg_heavyshotgun'},
        ['WEAPON_SNIPERRIFLE'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_sr_m24'},
        ['WEAPON_HEAVYSNIPER'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_sr_heavysniper'},
        ['WEAPON_HEAVYSNIPER_MK2'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_sr_heavysnipermk2'},
        ['WEAPON_MARKSMANRIFLE'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_sr_marksmanrifle'},
        ['WEAPON_SAWNOFFSHOTGUN'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_sg_sawnoff'},
        ['WEAPON_SMG_MK2'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_sb_smgmk2'},
        ['WEAPON_MINISMG'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_sb_minismg'},
        ['WEAPON_MACHINEPISTOL'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_sb_compactsmg'},
        ['WEAPON_MILITARYRIFLE'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_ar_advancedrifle'},
        ['WEAPON_HEAVYRIFLE'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_ar_heavyrifleh'},
        ['WEAPON_BAT'] = {x = 0.375, y = -0.15, z = 0.02, xRot = 0.0, yRot = -90.0, zRot = 0.0, model = 'w_me_bat'},	
        ['WEAPON_CROWBAR'] = {x = 0.375, y = -0.15, z = 0.02, xRot = 0.0, yRot = -90.0, zRot = 0.0, model = 'w_me_crowbar'},	
        ['WEAPON_GOLFCLUB'] = {x = 0.375, y = -0.15, z = 0.02, xRot = 0.0, yRot = -90.0, zRot = 0.0, model = 'w_me_gclub'},	
        ['WEAPON_HATCHET'] = {x = 0.375, y = -0.15, z = 0.02, xRot = 0.0, yRot = -90.0, zRot = 0.0, model = 'w_me_hatchet'},	
        ['WEAPON_MACHETE'] = {x = 0.375, y = -0.15, z = 0.02, xRot = 0.0, yRot = -90.0, zRot = 0.0, model = 'w_me_machette_lr'},
        ['WEAPON_WRENCH'] = {x = 0.375, y = -0.15, z = 0.02, xRot = 0.0, yRot = -90.0, zRot = 0.0, model = 'w_me_wrench'},	
        ['WEAPON_BATTLEAXE'] = {x = 0.375, y = -0.15, z = 0.02, xRot = 0.0, yRot = -90.0, zRot = 0.0, model = 'w_me_battleaxe'},	


        -- Addon
        ['WEAPON_COMBATPDW'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_sb_pdw'},
        ['WEAPON_M4'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_ar_m4'},
        ['WEAPON_SPECIALCARBINE_MK2'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_ar_specialcarbine'},
        ['WEAPON_M14'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_sr_m14'},
        ['WEAPON_PUMPSHOTGUN_MK2'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_sg_pumpshotgunmk2'},
        ['WEAPON_LTL'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_sg_ltl'},
        ['WEAPON_DBSHOTGUN'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_sg_doublebarrel'},
        ['WEAPON_ASSAULTRIFLE'] = {x = 0.075, y = -0.15, z = -0.12, xRot = 0.0, yRot = 185.0, zRot = 0.0,  model = 'w_ar_assaultrifle'},
        ['WEAPON_ASSAULTRIFLE_MK2'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_ar_assaultriflemk2'},
        ['WEAPON_COMPACTRIFLE'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_ar_assaultrifle_smg'},
        ['WEAPON_ADVANCEDRIFLE'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'W_AR_ADVANCEDRIFLE'},
        ['WEAPON_DRAGUNOV'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_sr_dragunov'},
        ['WEAPON_PUMPSHOTGUN'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_sg_pumpshotgun'},
        ['WEAPON_COMBATSHOTGUN'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_sg_pumpshotgunh4'},
        ['WEAPON_BATS'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_me_baseball_bat_metal'},
        ['WEAPON_KATANAS'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_me_katana_lr'},
        ['WEAPON_KATANA_2'] = {x = 0.375, y = -0.18, z = -0.05, xRot = 0.0, yRot = -90.0, zRot = 0.0, model = 'w_me_katana_2_saya'},
        ['WEAPON_MICROSMG'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_sb_microsmg'},
        ['WEAPON_MICROSMG2'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_sb_uzi'},
        ['WEAPON_MICROSMG3'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_sb_microsmg3'},  
        ['WEAPON_MINISMG2'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_sb_skorpion'},
        ['WEAPON_SNIPERRIFLE2'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_sr_sniperrifle2'},
        ['WEAPON_SLEDGEHAM'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_me_sledgeham'},
        ['WEAPON_STAFF'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_am_staff'},
        ['WEAPON_RUSSIANSNIPER'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'w_sr_russiansniper'},


        --- Airsoft
        ['WEAPON_AIRSOFTAK47'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'airsoftak'},
        ['WEAPON_AIRSOFTG36C'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'airsoftg36'},
        ['WEAPON_AIRSOFTM4'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'airsoftm4a1'},
        ['WEAPON_AIRSOFTM249'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'airsoftm249'},
        ['WEAPON_AIRSOFTUZIMICRO'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'airsoftmicrouzi'},
        ['WEAPON_AIRSOFTMP5'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'airsoftmp5'},
        ['WEAPON_AIRSOFTR700'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'airsoftr700'},
        ['WEAPON_AIRSOFTR870'] = {x = 0.075, y = -0.15, z = -0.02, xRot = 0.0, yRot = 165.0, zRot = 0.0, model = 'airsoft870'},
        ['WEAPON_BEANBAG'] = {x = 0.075, y = -0.15, z = -0.12, xRot = 0.0, yRot = 185.0, zRot = 0.0, model = 'w_sg_beanbag'},


        ['police_panto'] = {x = 0.075, y = -0.30, z = -0.02, xRot = 90.0, yRot = 180.0, zRot = 0.0, model = 'nkpanto'},

--[[        ['atmred'] = {x = -0.9, y = -0.3, z = 0.0, xRot = 0.0, yRot = 90.0, zRot = -0.0, model = 'flight_atm_02'},
        ['atmblue'] = {x = -0.9, y = -0.3, z = 0.0, xRot = 0.0, yRot = 90.0, zRot = -0.0, model = 'flight_atm_03'},
        ['atmgreen'] = {x = -0.9, y = -0.3, z = 0.0, xRot = 0.0, yRot = 90.0, zRot = -0.0, model = 'flight_fleeca_atm'},]]
    },
    
    Pickups = {
        1850631618,
        1948018762,
        1751145014,
        1817941018,
        3550712678,
        1426343849,
        4187887056,
        2753668402,
        4080829360,
        3748731225,
        2998219358,
        2244651441,
        2995980820,
        4264178988,
        1765114797,
        496339155,
        978070226,
        1274757841,
        1295434569,
        792114228,
        2406513688,
        2838846925,
        2528383651,
        2459552091,
        1577485217,
        768803961,
        483787975,
        2081529176,
        4189041807,
        2305275123,
        996550793,
        779501861,
        4263048111,
        3782592152,
        4246083230,
        3332236287,
        663586612,
        1587637620,
        693539241,
        2179883038,
        2297080999,
        2267924616,
        738282662,
        3812460080,
        2158727964,
        1852930709,
        1651898027,
        1263688126,
        2431639355,
        68603185,
        79909481,
        2689501965,
        2817147086,
        3285027633,
        2499414878,
        3463437675,
        1575005502,
        513448440,
        545862290,
        341217064,
        1897726628,
        3732468094,
        3500855031,
        3431676165,
        2773149623,
        2803366040,
        2228647636,
        1705498857,
        746606563,
        160266735,
        4260266856,
        1125567497,
        3094015579,
        3430731035,
        772217690,
        2780351145,
        83435908,
        1104334678,
        1704231442,
        3889104844,
        483577702,
        1735599485,
        544828034,
        292537574,
        3837603782,
        3730366643,
        2012476125,
        3224170789,
        2283450536,
        2223210455,
        4065984953,
        4199656437,
        3317114643,
        2633054488,
        157823901,
        2170382056,
        3812817136,
        1959050722,
        1000920287,
        2349845267,
        990867623,
        2673201481,
        1572258186,
        1835046764,
        1038697149,
        94531552,
        1649373715,
        3223238264,
        1548844439,
        1393009900,
        3220073531,
        3958938975,
        582047296,
        1983869217,
        4180625516,
        1613316560,
        837436873,
        1311775952,
        3832418740,
        3201593029,
        127042729,
        1601729296,
        2045070941,
        3392027813,
        2074855423,
        2010690963,
        884272848,
        3175998018,
        3759398940,
        4254904030,
        2329799797,
        2023061218,
        3993904883,
        266812085,
        4192395039,
        3626334911,
        4123384540,
        3182886821,
        1632369836,
        3722713114,
        3167076850,
        158843122,
        4041868857,
        3547474523,
        2942905513,
        155106086,
        3843167081,
        2173116527,
        3185079484,
        2837437579,
        4278878871,
        1234831722,
        4012602256,
        3432031091,
        2226947771,
        2316705120,
        2821026276,
        4284229131,
        2308161313,
        1491498856,
        3279969783,
        3708929359,
        3025681922,
    }
    
}