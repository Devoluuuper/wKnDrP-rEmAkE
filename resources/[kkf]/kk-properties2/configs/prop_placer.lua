cfg.raycastDistance = 10
cfg.cryptoInterval = 10 --10
cfg.durabilityInterval = 144 --144

cfg.objects = {
    ['gr_prop_gr_bench_03b'] = { -- CRAFTING LÕHKEIANE JA MUU
        level = 1,
        price = 100,
        type = 'crafting',
        infoText = "Sellega saad valmistada erinevat sodi.",
    },
    ['bkr_prop_coke_table01a'] = { -- 
        level = 2,
        price = 15000,
        type = 'crafting',
        infoText = "Kokaiini pakendamiseks.",
    },

    -- ['water'] = { -- asdasdasd
    --     level = 1,
    --     price = 1500,
    --     durabilityLoss = 50,
    --     infoText = "placeholder.",
    -- },

    ['gr_prop_gr_bench_03a'] = { -- 
        level = 3,
        price = 25000,
        type = 'crafting',
        infoText = "Elektroonikakomponentide lammutamiseks."
    },

    ['gr_prop_gr_bench_04a'] = { -- 
        level = 3,
        price = 35000,
        type = 'crafting',
        infoText = "Erinevate asjade meisterdamiseks.",
    },

    ['hei_prop_carrier_cargo_05a_s'] = {
        level = 1,
        price = 500,
        type = 'stash',
        inventory = {
            slots = 25, 
            size = 500000
        },
        infoText = "Asjade hoiustamiseks.",
    },

    ['ba_prop_battle_crates_pistols_01a'] = {
        level = 2,
        price = 25000,
        durabilityLoss = 1,
        type = 'itemSwapper',
        infoText = "Püstolite protsessimiseks.",
        itemAction = 'pistol_maker',
        inventory = {
            slots = 4,
            size = 9040
        }
    },

    ['prop_tea_urn'] = {
        level = 2,
        price = 10000,
        durabilityLoss = 1,
        type = 'itemSwapper',
        itemAction = 'coke_maker',
        infoText = "Seade kokaiini filtreerimiseks.",
        inventory = {
            slots = 1,
            size = 20000
        }
    },

    ['bkr_prop_coke_press_01b'] = {
        level = 2,
        price = 15000,
        durabilityLoss = 1,
        type = 'itemSwapper',
        itemAction = 'coke_smasher',
        infoText = "Kokaiinipress.",
        inventory = {
            slots = 1,
            size = 20000
        }
    },

    ['ba_prop_battle_crates_wpn_mix_01a'] = {
        level = 3,
        price = 55000,
        durabilityLoss = 1,
        type = 'itemSwapper',
        itemAction = 'smg_maker',
        infoText = "Automaatrelvade protsessimiseks.",
        inventory = {
            slots = 2,
            size = 8000
        }
    },

    ['bzzz_plants_weed_rosin2_c'] = {
        level = 3,
        price = 15000,
        durabilityLoss = 1,
        type = 'itemSwapper',
        itemAction = 'weed_crusher',
        infoText = "Kanepipurusti.",
        inventory = {
            slots = 2,
            size = 20000
        }
    },

    ['ba_prop_battle_crates_rifles_01a'] = {
        level = 3,
        price = 75000,
        durabilityLoss = 1,
        type = 'itemSwapper',
        itemAction = 'rifle_maker',
        infoText = "Ründerelvade protsessimiseks.",
        inventory = {
            slots = 1,
            size = 3470
        }
    },

    ['bzzz_plants_weed_rosin1_c'] = {
        level = 3,
        price = 7500,
        durabilityLoss = 1,
        type = 'itemSwapper',
        itemAction = 'weed_package_maker',
        infoText = "Kanepipress.",
        inventory = {
            slots = 1,
            size = 7000
        }
    },

    ['gr_prop_gr_crates_weapon_mix_01b'] = {
        level = 3,
        price = 105000,
        durabilityLoss = 1,
        type = 'itemSwapper',
        itemAction = 'shotgun_maker',
        infoText = "Pumppüsside protsessimiseks.",
        inventory = {
            slots = 1,
            size = 4400
        }
    },

    -- ['prop_food_bin_01'] = {
    --     level = 3,
    --     price = 95000,
    --     durabilityLoss = 1,
    --     type = 'itemSwapper',
    --     itemAction = 'frostbite_maker',
    --     infoText = "sssssssssssssssssssssssss.",
    --     inventory = {
    --         slots = 1,
    --         size = 5000
    --     }
    -- },

    ['hei_prop_hei_ammo_pile'] = {
        level = 2,
        price = 9500,
        durabilityLoss = 1,
        type = 'itemSwapper',
        itemAction = 'ammo_maker',
        infoText = "Padrunite lahtipakkimiseks.",
        inventory = {
            slots = 1,
            size = 1000
        }
    },

    ['bzzz_crypto_miner_rack_anim'] = {
        level = 1,
        earn = 22, -- 3 crypto per cfg.cryptoInterval minutes
        durabilityLoss = 1,
        type = 'mining'
    },

    ['prop_dyn_pc_02'] = {
        level = 1,
        earn = 20, -- 3 crypto per cfg.cryptoInterval minutes
        type = 'mining',
        durabilityLoss = 49,
    },

    ['prop_dyn_pc'] = {
        level = 1,
        earn = 17, -- 3 crypto per cfg.cryptoInterval minutes
        type = 'mining',
        durabilityLoss = 2,
    },

    ['xm_prop_x17_res_pctower'] = {
        level = 1,
        earn = 19, -- 3 crypto per cfg.cryptoInterval minutes
        type = 'mining',
        durabilityLoss = 3,
    },

    ['prop_pc_01a'] = {
        level = 1,
        earn = 22, -- 3 crypto per cfg.cryptoInterval minutes
        type = 'mining',
        durabilityLoss = 5,
    },

    ['v_res_mddresser'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 225000
        }
    },
    
    ['v_med_p_sideboard'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 300000
        }
    },
    
    ['v_res_cabinet'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 450000
        }
    },
    
    ['v_res_d_dressingtable'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 75000
        }
    },
    
    ['v_res_mddesk'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 75000
        }
    },
    
    ['v_res_tre_sideboard'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 75000
        }
    },
    
    ['apa_mp_h_bed_chestdrawer_02'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 150000
        }
    },
    
    ['apa_mp_h_str_shelffloorm_02'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 450000
        }
    },
    
    ['apa_mp_h_str_sideboardl_06'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 375000
        }
    },
    
    ['apa_mp_h_str_sideboardl_09'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 300000
        }
    },
    
    ['apa_mp_h_str_sideboardl_11'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 375000
        }
    },
    
    ['apa_mp_h_str_sideboardl_13'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 375000
        }
    },
    
    ['apa_mp_h_str_sideboardl_14'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 300000
        }
    },
    
    ['apa_mp_h_str_sideboardm_02'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 262500
        }
    },
    
    ['bkr_prop_biker_garage_locker_01'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 150000
        }
    },
    
    ['hei_heist_bed_chestdrawer_04'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 150000
        }
    },
    
    ['prop_devin_box_closed'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 11250
        }
    },
    
    ['prop_fridge_01'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 150000
        }
    },
    
    ['prop_fridge_03'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 150000
        }
    },
    
    ['prop_ld_int_safe_01'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 112500
        }
    },
    
    ['prop_mil_crate_02'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 225000
        }
    },
    
    ['prop_mil_crate_01'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 225000
        }
    },
    
    ['prop_rub_cabinet'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 75000
        }
    },
    
    ['prop_toolchest_05'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 112500
        }
    },
    
    ['prop_trailr_fridge'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 150000
        }
    },
    
    ['prop_tv_cabinet_05'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 75000
        }
    },
    
    ['prop_wooden_barrel'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 75000
        }
    },
    
    ['v_corp_cabshelves01'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 375000
        }
    },
    
    ['v_corp_filecabtall'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 150000
        }
    },
    
    ['v_corp_lowcabdark01'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 225000
        }
    },
    
    ['v_corp_tallcabdark01'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 150000
        }
    },
    
    ['v_res_d_sideunit'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 112500
        }
    },
    
    ['v_res_fh_sidebrddine'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 262500
        }
    },
    
    ['v_res_fh_sidebrdlngb'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 262500
        }
    },
    
    ['v_res_fridgemoda'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 225000
        }
    },
    
    ['v_res_fridgemodsml'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 187500
        }
    },
    
    ['v_res_m_armoire'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 225000
        }
    },
    
    ['v_res_m_sidetable'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 75000
        }
    },
    
    ['v_res_mbbedtable'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 75000
        }
    },
    
    ['v_res_mbdresser'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 150000
        }
    },
    
    ['v_res_mbottoman'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 150000
        }
    },
    
    ['v_res_mconsolemod'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 225000
        }
    },
    
    ['v_res_mcupboard'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 75000
        }
    },
    
    ['v_res_mdchest'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 112500
        }
    },
    
    ['v_res_tre_bedsidetable'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 75000
        }
    },
    
    ['v_res_tre_bedsidetableb'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 75000
        }
    },
    
    ['v_res_tre_fridge'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 112500
        }
    },
    
    ['v_res_tre_smallbookshelf'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 112500
        }
    },
    
    ['v_res_tre_storagebox'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 75000
        }
    },
    
    ['v_res_tre_storageunit'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 112500
        }
    },
    
    ['v_res_tre_wardrobe'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 225000
        }
    },
    
    ['v_ret_hd_unit1_'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 75000
        }
    },

    ['miss_rub_couch_01'] = {

    },
    
    ['v_res_d_armchair'] = {
    
    },
    
    ['v_res_j_sofa'] = {
    
    },
    
    ['v_res_mp_stripchair'] = {
    
    },
    
    ['v_res_m_h_sofa_sml'] = {
    
    },

    ['prop_barrel_exp_01a'] = {
    
    },
    
    ['v_res_r_sofa'] = {
    
    },
    
    ['v_res_tre_sofa'] = {
    
    },
    
    ['v_res_tt_sofa'] = {
    
    },
    
    ['v_med_p_sofa'] = {
    
    },
    
    ['bkr_prop_clubhouse_sofa_01a'] = {
    
    },
    
    ['prop_couch_lg_02'] = {
    
    },
    
    ['apa_mp_h_yacht_sofa_02'] = {
    
    },
    
    ['prop_couch_01'] = {
    
    },
    
    ['prop_couch_03'] = {
    
    },
    
    ['prop_couch_04'] = {
    
    },
    
    ['prop_couch_lg_05'] = {
    
    },
    
    ['prop_couch_lg_06'] = {
    
    },
    
    ['prop_couch_lg_07'] = {
    
    },
    
    ['prop_couch_lg_08'] = {
    
    },
    
    ['prop_couch_sm1_07'] = {
    
    },
    
    ['prop_couch_sm2_07'] = {
    
    },
    
    ['prop_couch_sm_06'] = {
    
    },
    
    ['apa_mp_h_stn_sofa2seat_02'] = {
    
    },
    
    ['ex_mp_h_off_sofa_003'] = {
    
    },
    
    ['ex_mp_h_off_sofa_01'] = {
    
    },
    
    ['ex_mp_h_off_sofa_02'] = {
    
    },
    
    ['hei_heist_stn_sofa2seat_03'] = {
    
    },
    
    ['hei_heist_stn_sofa2seat_06'] = {
    
    },
    
    ['hei_heist_stn_sofa3seat_01'] = {
    
    },
    
    ['hei_heist_stn_sofa3seat_02'] = {
    
    },
    
    ['hei_heist_stn_sofa3seat_06'] = {
    
    },
    
    ['imp_prop_impexp_sofabed_01a'] = {
    
    },
    
    ['prop_t_sofa_02'] = {
    
    },
    
    ['apa_mp_h_stn_chairstrip_03'] = {
    
    },
    
    ['v_res_m_armchair'] = {
    
    },
    
    ['apa_mp_h_yacht_armchair_01'] = {
    
    },
    
    ['v_club_stagechair'] = {
    
    },
    
    ['prop_couch_sm_05'] = {
    
    },
    
    ['prop_couch_sm_07'] = {
    
    },
    
    ['prop_couch_sm_02'] = {
    
    },
    
    ['apa_mp_h_stn_chairarm_01'] = {
    
    },
    
    ['apa_mp_h_stn_chairarm_03'] = {
    
    },
    
    ['apa_mp_h_stn_chairarm_24'] = {
    
    },
    
    ['apa_mp_h_stn_chairarm_25'] = {
    
    },
    
    ['apa_mp_h_stn_chairstrip_04'] = {
    
    },
    
    ['apa_mp_h_stn_chairstrip_05'] = {
    
    },
    
    ['apa_mp_h_stn_chairstrip_08'] = {
    
    },
    
    ['v_res_d_bed'] = {
    
    },
    
    ['v_res_lestersbed'] = {
    
    },
    
    ['v_res_mbbed'] = {
    
    },
    
    ['v_res_mdbed'] = {
    
    },
    
    ['v_res_msonbed'] = {
    
    },
    
    ['v_res_tre_bed1'] = {
    
    },
    
    ['v_res_tre_bed2'] = {
    
    },
    
    ['apa_mp_h_bed_wide_05'] = {
    
    },
    
    ['apa_mp_h_bed_double_08'] = {
    
    },
    
    ['apa_mp_h_bed_double_09'] = {
    
    },
    
    ['apa_mp_h_yacht_bed_01'] = {
    
    },
    
    ['apa_mp_h_yacht_bed_02'] = {
    
    },
    
    ['ex_prop_exec_bed_01'] = {
    
    },
    
    ['gr_prop_bunker_bed_01'] = {
    
    },
    
    ['p_mbbed_s'] = {
    
    },
    
    ['v_res_fa_chair01'] = {
    
    },
    
    ['v_res_fh_barcchair'] = {
    
    },
    
    ['v_res_fh_dineeamesa'] = {
    
    },
    
    ['v_res_fh_dineeamesb'] = {
    
    },
    
    ['v_res_fh_dineeamesc'] = {
    
    },
    
    ['v_res_fh_easychair'] = {
    
    },
    
    ['v_res_fh_kitnstool'] = {
    
    },
    
    ['v_res_fh_singleseat'] = {
    
    },
    
    ['v_res_j_stool'] = {
    
    },
    
    ['v_res_mbchair'] = {
    
    },
    
    ['v_res_m_dinechair'] = {
    
    },
    
    ['v_res_study_chair'] = {
    
    },
    
    ['v_res_tre_chair'] = {
    
    },
    
    ['v_res_tre_stool'] = {
    
    },
    
    ['v_res_tre_stool_leather'] = {
    
    },
    
    ['v_med_p_deskchair'] = {
    
    },
    
    ['v_med_whickerchair1'] = {
    
    },
    
    ['v_ret_chair_white'] = {
    
    },
    
    ['v_ret_chair'] = {
    
    },
    
    ['prop_cs_office_chair'] = {
    
    },
    
    ['v_club_barchair'] = {
    
    },
    
    ['v_club_officechair'] = {
    
    },
    
    ['prop_armchair_01'] = {
    
    },
    
    ['prop_bar_stool_01'] = {
    
    },
    
    ['apa_mp_h_yacht_stool_01'] = {
    
    },
    
    ['apa_mp_h_stn_chairarm_12'] = {
    
    },
    
    ['apa_mp_h_stn_chairstool_12'] = {
    
    },
    
    ['prop_chair_03'] = {
    
    },
    
    ['apa_mp_h_din_chair_04'] = {
    
    },
    
    ['apa_mp_h_din_chair_08'] = {
    
    },
    
    ['apa_mp_h_din_chair_09'] = {
    
    },
    
    ['apa_mp_h_din_chair_12'] = {
    
    },
    
    ['apa_mp_h_din_chair_04'] = {
    
    },
    
    ['apa_mp_h_stn_chairarm_02'] = {
    
    },
    
    ['apa_mp_h_stn_chairarm_09'] = {
    
    },
    
    ['apa_mp_h_stn_chairarm_11'] = {
    
    },
    
    ['apa_mp_h_stn_chairarm_13'] = {
    
    },
    
    ['apa_mp_h_stn_chairarm_26'] = {
    
    },
    
    ['apa_mp_h_yacht_barstool_01'] = {
    
    },
    
    ['ba_prop_int_glam_stool'] = {
    
    },
    
    ['ba_prop_battle_club_chair_01'] = {
    
    },
    
    ['ba_prop_battle_club_chair_02'] = {
    
    },
    
    ['ba_prop_battle_club_chair_03'] = {
    
    },
    
    ['v_ret_gc_chair01'] = {
    
    },
    
    ['v_ret_gc_chair02'] = {
    
    },
    
    ['prop_arcade_01'] = {
    
    },
    
    ['v_res_fh_towerfan'] = {
    
    },
    
    ['v_res_fa_phone'] = {
    
    },
    
    ['v_res_fh_bedsideclock'] = {
    
    },
    
    ['v_res_fh_speakerdock'] = {
    
    },
    
    ['prop_tv_cabinet_04'] = {
    
    },
    
    ['prop_tv_cabinet_03'] = {
        type = 'stash',
        inventory = {
            slots = 25,
            size = 50000
        }
    },
    
    ['apa_mp_h_str_shelfwallm_01'] = {
    
    },
    
    ['prop_coathook_01'] = {
    
    },
    
    ['v_res_cherubvase'] = {
    
    },
    
    ['v_res_fh_aftershavebox'] = {
    
    },
    
    ['v_res_fh_flowersa'] = {
    
    },
    
    ['v_res_fh_fruitbowl'] = {
    
    },
    
    ['v_res_fh_sculptmod'] = {
    
    },
    
    ['v_res_j_magrack'] = {
    
    },
    
    ['v_res_jewelbox'] = {
    
    },
    
    ['v_res_mbbin'] = {
    
    },
    
    ['v_res_mbowlornate'] = {
    
    },
    
    ['v_res_mbronzvase'] = {
    
    },
    
    ['v_res_m_candle'] = {
    
    },
    
    ['v_res_m_candlelrg'] = {
    
    },
    
    ['ch_prop_whiteboard'] = {
    
    },
    
    ['v_ret_fh_ashtray'] = {
    
    },
    
    ['apa_mp_h_acc_rugwooll_04'] = {
    
    },
    
    ['ex_mp_h_acc_rugwoolm_04'] = {
    
    },
    
    ['apa_mp_h_acc_rugwoolm_03'] = {
    
    },
    
    ['apa_mp_h_acc_rugwooll_03'] = {
    
    },
    
    ['apa_mp_h_acc_rugwoolm_04'] = {
    
    },
    
    ['prop_amb_40oz_03'] = {
    
    },
    
    ['prop_amb_beer_bottle'] = {
    
    },
    
    ['prop_aviators_01'] = {
    
    },
    
    ['prop_beer_box_01'] = {
    
    },
    
    ['prop_binoc_01'] = {
    
    },
    
    ['prop_blox_spray'] = {
    
    },
    
    ['prop_bong_01'] = {
    
    },
    
    ['prop_boombox_01'] = {
    
    },
    
    ['prop_bowl_crisps'] = {
    
    },
    
    ['prop_candy_pqs'] = {
    
    },
    
    ['prop_carrier_bag_01'] = {
    
    },
    
    ['prop_ceramic_jug_01'] = {
    
    },
    
    ['prop_cigar_pack_01'] = {
    
    },
    
    ['prop_cigar_pack_02'] = {
    
    },
    
    ['prop_cs_beer_box'] = {
    
    },
    
    ['prop_cs_binder_01'] = {
    
    },
    
    ['prop_cs_bs_cup'] = {
    
    },
    
    ['prop_cs_champ_flute'] = {
    
    },
    
    ['prop_cs_duffel_01'] = {
    
    },
    
    ['prop_cs_ilev_blind_01'] = {
    
    },
    
    ['p_ld_bs_bag_01'] = {
    
    },
    
    ['prop_cs_ironing_board'] = {
    
    },
    
    ['prop_cs_kettle_01'] = {
    
    },
    
    ['prop_cs_lester_crate'] = {
    
    },
    
    ['prop_cs_script_bottle_01'] = {
    
    },
    
    ['prop_cs_script_bottle'] = {
    
    },
    
    ['prop_cs_whiskey_bottle'] = {
    
    },
    
    ['prop_peanut_bowl_01'] = {
    
    },
    
    ['prop_tumbler_01'] = {
    
    },
    
    ['prop_weed_bottle'] = {
    
    },
    
    ['p_cs_lighter_01'] = {
    
    },
    
    ['p_cs_papers_01'] = {
    
    },
    
    ['prop_champ_cool'] = {
    
    },
    
    ['prop_champ_01b'] = {
    
    },
    
    ['ba_prop_club_champset'] = {
    
    },
    
    ['v_res_fa_candle01'] = {
    
    },
    
    ['v_res_fa_candle02'] = {
    
    },
    
    ['v_res_fa_candle03'] = {
    
    },
    
    ['v_res_fa_candle04'] = {
    
    },
    
    ['v_med_bottles2'] = {
    
    },
    
    ['v_res_desktidy'] = {
    
    },
    
    ['v_med_p_notebook'] = {
    
    },
    
    ['ba_prop_battle_trophy_battler'] = {
    
    },
    
    ['ba_prop_battle_trophy_no1'] = {
    
    },
    
    ['prop_golf_bag_01c'] = {
    
    },
    
    ['bkr_prop_bkr_cash_scatter_01'] = {
    
    },
    
    ['bkr_prop_bkr_cashpile_01'] = {
    
    },
    
    ['bkr_prop_bkr_cash_roll_01'] = {
    
    },
    
    ['bkr_prop_bkr_cashpile_04'] = {
    
    },
    
    ['bkr_prop_weed_smallbag_01a'] = {
    
    },
    
    ['prop_gold_bar'] = {
    
    },
    
    ['beerrow_world'] = {
    
    },
    
    ['beerrow_local'] = {
    
    },
    
    ['p_cs_joint_02'] = {
    
    },
    
    ['p_tumbler_cs2_s'] = {
    
    },
    
    ['prop_amb_donut'] = {
    
    },
    
    ['prop_donut_02'] = {
    
    },
    
    ['prop_bar_shots'] = {
    
    },
    
    ['prop_bar_stirrers'] = {
    
    },
    
    ['prop_beer_amopen'] = {
    
    },
    
    ['prop_beer_blr'] = {
    
    },
    
    ['prop_beer_logger'] = {
    
    },
    
    ['prop_beer_stzopen'] = {
    
    },
    
    ['prop_bikerset'] = {
    
    },
    
    ['prop_bottle_brandy'] = {
    
    },
    
    ['prop_tequila_bottle'] = {
    
    },
    
    ['prop_tequila'] = {
    
    },
    
    ['prop_bottle_cognac'] = {
    
    },
    
    ['prop_bottle_macbeth'] = {
    
    },
    
    ['prop_brandy_glass'] = {
    
    },
    
    ['prop_mug_01'] = {
    
    },
    
    ['prop_mug_02'] = {
    
    },
    
    ['prop_mug_03'] = {
    
    },
    
    ['prop_pint_glass_01'] = {
    
    },
    
    ['prop_pizza_box_03'] = {
    
    },
    
    ['prop_sandwich_01'] = {
    
    },
    
    ['prop_cava'] = {
    
    },
    
    ['prop_drink_redwine'] = {
    
    },
    
    ['prop_cherenkov_02'] = {
    
    },
    
    ['vodkarow'] = {
    
    },
    
    ['prop_cherenkov_02'] = {
    
    },
    
    ['prop_cherenkov_03'] = {
    
    },
    
    ['prop_cocktail_glass'] = {
    
    },
    
    ['prop_cs_bottle_opener'] = {
    
    },
    
    ['prop_food_bs_chips'] = {
    
    },
    
    ['prop_cs_burger_01'] = {
    
    },
    
    ['prop_cs_hand_radio'] = {
    
    },
    
    ['prop_cs_hotdog_01'] = {
    
    },
    
    ['v_ret_csr_bin'] = {
    
    },
    
    ['v_ret_fh_wickbskt'] = {
    
    },
    
    ['v_ret_gc_bag01'] = {
    
    },
    
    ['v_ret_gc_bin'] = {
    
    },
    
    ['v_ret_gc_clock'] = {
    
    },
    
    ['v_ret_ps_bag_01'] = {
    
    },
    
    ['v_ret_ps_bag_02'] = {
    
    },
    
    ['v_ret_ta_book1'] = {
    
    },
    
    ['v_ret_ta_book2'] = {
    
    },
    
    ['v_ret_ta_book3'] = {
    
    },
    
    ['v_ret_ta_book4'] = {
    
    },
    
    ['v_ret_ta_camera'] = {
    
    },
    
    ['v_ret_ta_firstaid'] = {
    
    },
    
    ['v_ret_ta_hero'] = {
    
    },
    
    ['v_ret_ta_mag1'] = {
    
    },
    
    ['v_ret_ta_mag2'] = {
    
    },
    
    ['v_ret_ta_skull'] = {
    
    },
    
    ['prop_acc_guitar_01'] = {
    
    },
    
    ['prop_amb_handbag_01'] = {
    
    },
    
    ['prop_attache_case_01'] = {
    
    },
    
    ['prop_big_bag_01'] = {
    
    },
    
    ['prop_cs_shopping_bag'] = {
    
    },
    
    ['v_res_fa_book03'] = {
    
    },
    
    ['prop_tool_broom'] = {
    
    },
    
    ['prop_fire_exting_2a'] = {
    
    },
    
    ['v_res_vacuum'] = {
    
    },
    
    ['v_club_vusnaketank'] = {
    
    },
    
    ['v_club_vu_deckcase'] = {
    
    },
    
    ['prop_dummy_01'] = {
    
    },
    
    ['prop_egg_clock_01'] = {
    
    },
    
    ['prop_el_guitar_01'] = {
    
    },
    
    ['prop_el_guitar_02'] = {
    
    },
    
    ['prop_el_guitar_03'] = {
    
    },
    
    ['prop_floor_duster_01'] = {
    
    },
    
    ['prop_fruit_basket'] = {
    
    },
    
    ['prop_f_duster_02'] = {
    
    },
    
    ['prop_idol_case_01'] = {
    
    },
    
    ['prop_jewel_02a'] = {
    
    },
    
    ['prop_jewel_02b'] = {
    
    },
    
    ['prop_jewel_02c'] = {
    
    },
    
    ['prop_jewel_03a'] = {
    
    },
    
    ['prop_jewel_03b'] = {
    
    },
    
    ['prop_jewel_04a'] = {
    
    },
    
    ['prop_jewel_04b'] = {
    
    },
    
    ['prop_j_disptray_01'] = {
    
    },
    
    ['prop_j_disptray_01b'] = {
    
    },
    
    ['prop_j_disptray_02'] = {
    
    },
    
    ['prop_j_disptray_03'] = {
    
    },
    
    ['prop_j_disptray_04'] = {
    
    },
    
    ['prop_j_disptray_04b'] = {
    
    },
    
    ['prop_j_disptray_05'] = {
    
    },
    
    ['prop_j_disptray_05b'] = {
    
    },
    
    ['prop_ld_suitcase_01'] = {
    
    },
    
    ['prop_ld_suitcase_02'] = {
    
    },
    
    ['hei_p_attache_case_shut'] = {
    
    },
    
    ['prop_mr_rasberryclean'] = {
    
    },
    
    ['prop_paper_bag_01'] = {
    
    },
    
    ['prop_shopping_bags01'] = {
    
    },
    
    ['prop_shopping_bags02'] = {
    
    },
    
    ['p_ld_sax'] = {
    
    },
    
    ['p_ld_soc_ball_01'] = {
    
    },
    
    ['p_watch_01'] = {
    
    },
    
    ['p_watch_02'] = {
    
    },
    
    ['p_watch_03'] = {
    
    },
    
    ['p_watch_04'] = {
    
    },
    
    ['p_watch_05'] = {
    
    },
    
    ['p_watch_06'] = {
    
    },
    
    ['apa_mp_h_acc_candles_01'] = {
    
    },
    
    ['apa_mp_h_acc_candles_02'] = {
    
    },
    
    ['apa_mp_h_acc_candles_04'] = {
    
    },
    
    ['apa_mp_h_acc_candles_06'] = {
    
    },
    
    ['prop_bskball_01'] = {
    
    },
    
    ['v_res_r_figcat'] = {
    
    },
    
    ['v_res_r_figclown'] = {
    
    },
    
    ['v_res_r_figfemale'] = {
    
    },
    
    ['v_res_r_figflamenco'] = {
    
    },
    
    ['v_res_r_figgirl'] = {
    
    },
    
    ['v_res_r_figgirlclown'] = {
    
    },
    
    ['v_res_r_figoblisk'] = {
    
    },
    
    ['v_res_r_figpillar'] = {
    
    },
    
    ['v_res_sculpt_dec'] = {
    
    },
    
    ['v_res_sculpt_decd'] = {
    
    },
    
    ['v_res_sculpt_dece'] = {
    
    },
    
    ['v_res_sculpt_decf'] = {
    
    },
    
    ['v_res_skateboard'] = {
    
    },
    
    ['v_res_sketchpad'] = {
    
    },
    
    ['v_res_tissues'] = {
    
    },
    
    ['v_res_tre_basketmess'] = {
    
    },
    
    ['v_res_tre_bin'] = {
    
    },
    
    ['v_res_tre_cushiona'] = {
    
    },
    
    ['v_res_tre_cushionb'] = {
    
    },
    
    ['v_res_tre_cushionc'] = {
    
    },
    
    ['v_res_tre_cushiond'] = {
    
    },
    
    ['v_res_tre_fruitbowl'] = {
    
    },
    
    ['prop_idol_01'] = {
    
    },
    
    ['v_res_r_fighorsestnd'] = {
    
    },
    
    ['v_res_r_fighorse'] = {
    
    },
    
    ['v_res_r_figdancer'] = {
    
    },
    
    ['v_res_fa_idol02'] = {
    
    },
    
    ['v_res_m_statue'] = {
    
    },
    
    ['v_med_p_vaseround'] = {
    
    },
    
    ['ex_mp_h_acc_vase_05'] = {
    
    },
    
    ['apa_mp_h_acc_dec_head_01'] = {
    
    },
    
    ['apa_mp_h_acc_dec_sculpt_02'] = {
    
    },
    
    ['ex_mp_h_acc_dec_plate_02'] = {
    
    },
    
    ['apa_mp_h_acc_bowl_ceramic_01'] = {
    
    },
    
    ['apa_mp_h_acc_dec_plate_01'] = {
    
    },
    
    ['apa_mp_h_acc_vase_01'] = {
    
    },
    
    ['apa_mp_h_acc_vase_02'] = {
    
    },
    
    ['apa_mp_h_acc_vase_05'] = {
    
    },
    
    ['apa_mp_h_acc_vase_06'] = {
    
    },
    
    ['v_res_mplanttongue'] = {
    
    },
    
    ['prop_fib_plant_01'] = {
    
    },
    
    ['v_corp_bombplant'] = {
    
    },
    
    ['v_res_mflowers'] = {
    
    },
    
    ['v_res_mvasechinese'] = {
    
    },
    
    ['v_res_m_palmplant1'] = {
    
    },
    
    ['v_res_m_palmstairs'] = {
    
    },
    
    ['v_res_m_urn'] = {
    
    },
    
    ['v_res_rubberplant'] = {
    
    },
    
    ['v_res_tre_plant'] = {
    
    },
    
    ['v_res_tre_tree'] = {
    
    },
    
    ['v_med_p_planter'] = {
    
    },
    
    ['v_ret_flowers'] = {
    
    },
    
    ['v_ret_j_flowerdisp'] = {
    
    },
    
    ['v_ret_j_flowerdisp_white'] = {
    
    },
    
    ['v_res_m_vasefresh'] = {
    
    },
    
    ['v_res_rosevasedead'] = {
    
    },
    
    ['v_res_exoticvase'] = {
    
    },
    
    ['v_res_rosevase'] = {
    
    },
    
    ['apa_mp_h_acc_plant_palm_01'] = {
    
    },
    
    ['prop_plant_int_01a'] = {
    
    },
    
    ['prop_plant_int_01b'] = {
    
    },
    
    ['prop_plant_int_02a'] = {
    
    },
    
    ['prop_plant_int_02b'] = {
    
    },
    
    ['prop_plant_int_03a'] = {
    
    },
    
    ['prop_plant_int_03b'] = {
    
    },
    
    ['prop_plant_int_03c'] = {
    
    },
    
    ['prop_plant_int_04c'] = {
    
    },
    
    ['prop_plant_int_05b'] = {
    
    },
    
    ['prop_pot_plant_01a'] = {
    
    },
    
    ['prop_pot_plant_01b'] = {
    
    },
    
    ['prop_pot_plant_01c'] = {
    
    },
    
    ['prop_pot_plant_01d'] = {
    
    },
    
    ['prop_pot_plant_01e'] = {
    
    },
    
    ['prop_pot_plant_05a'] = {
    
    },
    
    ['prop_pot_plant_05b'] = {
    
    },
    
    ['p_int_jewel_plant_01'] = {
    
    },
    
    ['p_int_jewel_plant_02'] = {
    
    },
    
    ['apa_mp_h_acc_vase_flowers_01'] = {
    
    },
    
    ['apa_mp_h_acc_vase_flowers_02'] = {
    
    },
    
    ['apa_mp_h_acc_vase_flowers_03'] = {
    
    },
    
    ['apa_mp_h_acc_vase_flowers_04'] = {
    
    },
    
    ['v_corp_cd_desklamp'] = {
    
    },
    
    ['v_res_desklamp'] = {
    
    },
    
    ['v_res_d_lampa'] = {
    
    },
    
    ['v_res_fa_lamp1on'] = {
    
    },
    
    ['v_res_fh_floorlamp'] = {
    
    },
    
    ['v_res_fh_lampa_on'] = {
    
    },
    
    ['v_res_j_tablelamp1'] = {
    
    },
    
    ['v_res_j_tablelamp2'] = {
    
    },
    
    ['v_res_mdbedlamp'] = {
    
    },
    
    ['v_res_mtblelampmod'] = {
    
    },
    
    ['v_res_m_lampstand'] = {
    
    },
    
    ['v_res_m_lampstand2'] = {
    
    },
    
    ['v_res_m_lamptbl'] = {
    
    },
    
    ['v_res_tre_talllamp'] = {
    
    },
    
    ['v_ret_gc_lamp'] = {
    
    },
    
    ['v_med_p_floorlamp'] = {
    
    },
    
    ['v_club_vu_lamp'] = {
    
    },
    
    ['apa_mp_h_lit_floorlampnight_07'] = {
    
    },
    
    ['apa_mp_h_floorlamp_a'] = {
    
    },
    
    ['apa_mp_h_floorlamp_b'] = {
    
    },
    
    ['apa_mp_h_floorlamp_c'] = {
    
    },
    
    ['apa_mp_h_floor_lamp_int_08'] = {
    
    },
    
    ['apa_mp_h_lit_floorlampnight_14'] = {
    
    },
    
    ['apa_mp_h_lit_floorlamp_03'] = {
    
    },
    
    ['apa_mp_h_lit_floorlamp_06'] = {
    
    },
    
    ['apa_mp_h_lit_floorlamp_10'] = {
    
    },
    
    ['apa_mp_h_lit_floorlamp_13'] = {
    
    },
    
    ['apa_mp_h_lit_floorlamp_17'] = {
    
    },
    
    ['apa_mp_h_lit_lamptablenight_16'] = {
    
    },
    
    ['apa_mp_h_lit_lamptablenight_24'] = {
    
    },
    
    ['apa_mp_h_lit_lamptable_005'] = {
    
    },
    
    ['apa_mp_h_lit_lamptable_04'] = {
    
    },
    
    ['apa_mp_h_lit_lamptable_09'] = {
    
    },
    
    ['apa_mp_h_lit_lamptable_14'] = {
    
    },
    
    ['apa_mp_h_lit_lamptable_17'] = {
    
    },
    
    ['v_res_d_coffeetable'] = {
    
    },
    
    ['v_res_d_roundtable'] = {
    
    },
    
    ['v_res_fh_coftablea'] = {
    
    },
    
    ['v_res_fh_coftableb'] = {
    
    },
    
    ['v_res_fh_coftbldisp'] = {
    
    },
    
    ['v_res_fh_diningtable'] = {
    
    },
    
    ['v_res_j_coffeetable'] = {
    
    },
    
    ['v_res_j_lowtable'] = {
    
    },
    
    ['v_res_mdbedtable'] = {
    
    },
    
    ['v_res_msidetblemod'] = {
    
    },
    
    ['v_res_m_console'] = {
    
    },
    
    ['v_res_m_dinetble_replace'] = {
    
    },
    
    ['v_res_m_h_console'] = {
    
    },
    
    ['v_res_m_stool'] = {
    
    },
    
    ['v_res_tre_table2'] = {
    
    },
    
    ['v_med_p_coffeetable'] = {
    
    },
    
    ['v_med_p_desk'] = {
    
    },
    
    ['prop_yacht_table_01'] = {
    
    },
    
    ['prop_yacht_table_02'] = {
    
    },
    
    ['prop_yacht_table_03'] = {
    
    },
    
    ['v_ret_csr_table'] = {
    
    },
    
    ['v_res_mconsoletrad'] = {
    
    },
    
    ['v_ilev_liconftable_sml'] = {
    
    },
    
    ['v_ret_tablesml'] = {
    
    },
    
    ['apa_mp_h_yacht_coffee_table_02'] = {
    
    },
    
    ['apa_mp_h_yacht_side_table_01'] = {
    
    },
    
    ['apa_mp_h_yacht_side_table_02'] = {
    
    },
    
    ['apa_mp_h_tab_sidelrg_04'] = {
    
    },
    
    ['apa_mp_h_tab_sidelrg_07'] = {
    
    },
    
    ['ba_prop_int_trad_table'] = {
    
    },
    
    ['apa_mp_h_str_sideboards_02'] = {
    
    },
    
    ['apa_mp_h_din_table_04'] = {
    
    },
    
    ['apa_mp_h_tab_coffee_07'] = {
    
    },
    
    ['apa_mp_h_tab_coffee_08'] = {
    
    },
    
    ['apa_mp_h_tab_sidelrg_01'] = {
    
    },
    
    ['apa_mp_h_tab_sidelrg_02'] = {
    
    },
    
    ['ba_prop_int_edgy_table_01'] = {
    
    },
    
    ['ba_prop_int_edgy_table_02'] = {
    
    },
    
    ['apa_mp_h_tab_sidelrg_01'] = {
    
    },

    ['miss_rub_couch_01'] = {

    },
    
    ['v_res_d_armchair'] = {
    
    },
    
    ['v_res_j_sofa'] = {
    
    },
    
    ['v_res_mp_stripchair'] = {
    
    },
    
    ['v_res_m_h_sofa_sml'] = {
    
    },
    
    ['v_res_r_sofa'] = {
    
    },
    
    ['v_res_tre_sofa'] = {
    
    },
    
    ['v_res_tt_sofa'] = {
    
    },
    
    ['v_med_p_sofa'] = {
    
    },
    
    ['bkr_prop_clubhouse_sofa_01a'] = {
    
    },
    
    ['prop_couch_lg_02'] = {
    
    },
    
    ['apa_mp_h_yacht_sofa_02'] = {
    
    },
    
    ['prop_couch_01'] = {
    
    },
    
    ['prop_couch_03'] = {
    
    },
    
    ['prop_couch_04'] = {
    
    },
    
    ['prop_couch_lg_05'] = {
    
    },
    
    ['prop_couch_lg_06'] = {
    
    },
    
    ['prop_couch_lg_07'] = {
    
    },
    
    ['prop_couch_lg_08'] = {
    
    },
    
    ['prop_couch_sm1_07'] = {
    
    },
    
    ['prop_couch_sm2_07'] = {
    
    },
    
    ['prop_couch_sm_06'] = {
    
    },
    
    ['apa_mp_h_stn_sofa2seat_02'] = {
    
    },
    
    ['ex_mp_h_off_sofa_003'] = {
    
    },
    
    ['ex_mp_h_off_sofa_01'] = {
    
    },
    
    ['ex_mp_h_off_sofa_02'] = {
    
    },
    
    ['hei_heist_stn_sofa2seat_03'] = {
    
    },
    
    ['hei_heist_stn_sofa2seat_06'] = {
    
    },
    
    ['hei_heist_stn_sofa3seat_01'] = {
    
    },
    
    ['hei_heist_stn_sofa3seat_02'] = {
    
    },
    
    ['hei_heist_stn_sofa3seat_06'] = {
    
    },
    
    ['imp_prop_impexp_sofabed_01a'] = {
    
    },
    
    ['prop_t_sofa_02'] = {
    
    },
    
    ['apa_mp_h_stn_chairstrip_03'] = {
    
    },
    
    ['v_res_m_armchair'] = {
    
    },
    
    ['apa_mp_h_yacht_armchair_01'] = {
    
    },
    
    ['v_club_stagechair'] = {
    
    },
    
    ['prop_couch_sm_05'] = {
    
    },
    
    ['prop_couch_sm_07'] = {
    
    },
    
    ['prop_couch_sm_02'] = {
    
    },
    
    ['apa_mp_h_stn_chairarm_01'] = {
    
    },
    
    ['apa_mp_h_stn_chairarm_03'] = {
    
    },
    
    ['apa_mp_h_stn_chairarm_24'] = {
    
    },
    
    ['apa_mp_h_stn_chairarm_25'] = {
    
    },
    
    ['apa_mp_h_stn_chairstrip_04'] = {
    
    },
    
    ['apa_mp_h_stn_chairstrip_05'] = {
    
    },
    
    ['apa_mp_h_stn_chairstrip_08'] = {
    
    },
    
    ['v_res_d_bed'] = {
    
    },
    
    ['v_res_lestersbed'] = {
    
    },
    
    ['v_res_mbbed'] = {
    
    },
    
    ['v_res_mdbed'] = {
    
    },
    
    ['v_res_msonbed'] = {
    
    },
    
    ['v_res_tre_bed1'] = {
    
    },
    
    ['v_res_tre_bed2'] = {
    
    },
    
    ['apa_mp_h_bed_wide_05'] = {
    
    },
    
    ['apa_mp_h_bed_double_08'] = {
    
    },
    
    ['apa_mp_h_bed_double_09'] = {
    
    },
    
    ['apa_mp_h_yacht_bed_01'] = {
    
    },
    
    ['apa_mp_h_yacht_bed_02'] = {
    
    },
    
    ['ex_prop_exec_bed_01'] = {
    
    },
    
    ['gr_prop_bunker_bed_01'] = {
    
    },
    
    ['p_mbbed_s'] = {
    
    },
    
    ['v_res_fa_chair01'] = {
    
    },
    
    ['v_res_fh_barcchair'] = {
    
    },
    
    ['v_res_fh_dineeamesa'] = {
    
    },
    
    ['v_res_fh_dineeamesb'] = {
    
    },
    
    ['v_res_fh_dineeamesc'] = {
    
    },
    
    ['v_res_fh_easychair'] = {
    
    },
    
    ['v_res_fh_kitnstool'] = {
    
    },
    
    ['v_res_fh_singleseat'] = {
    
    },
    
    ['v_res_j_stool'] = {
    
    },
    
    ['v_res_mbchair'] = {
    
    },
    
    ['v_res_m_dinechair'] = {
    
    },
    
    ['v_res_study_chair'] = {
    
    },
    
    ['v_res_tre_chair'] = {
    
    },
    
    ['v_res_tre_stool'] = {
    
    },
    
    ['v_res_tre_stool_leather'] = {
    
    },
    
    ['v_med_p_deskchair'] = {
    
    },
    
    ['v_med_whickerchair1'] = {
    
    },
    
    ['v_ret_chair_white'] = {
    
    },
    
    ['v_ret_chair'] = {
    
    },
    
    ['prop_cs_office_chair'] = {
    
    },
    
    ['v_club_barchair'] = {
    
    },
    
    ['v_club_officechair'] = {
    
    },
    
    ['prop_armchair_01'] = {
    
    },
    
    ['prop_bar_stool_01'] = {
    
    },
    
    ['apa_mp_h_yacht_stool_01'] = {
    
    },
    
    ['apa_mp_h_stn_chairarm_12'] = {
    
    },
    
    ['apa_mp_h_stn_chairstool_12'] = {
    
    },
    
    ['prop_chair_03'] = {
    
    },
    
    ['apa_mp_h_din_chair_04'] = {
    
    },
    
    ['apa_mp_h_din_chair_08'] = {
    
    },
    
    ['apa_mp_h_din_chair_09'] = {
    
    },
    
    ['apa_mp_h_din_chair_12'] = {
    
    },
    
    ['apa_mp_h_stn_chairarm_02'] = {
    
    },
    
    ['apa_mp_h_stn_chairarm_09'] = {
    
    },
    
    ['apa_mp_h_stn_chairarm_11'] = {
    
    },
    
    ['apa_mp_h_stn_chairarm_13'] = {
    
    },
    
    ['apa_mp_h_stn_chairarm_26'] = {
    
    },
    
    ['apa_mp_h_yacht_barstool_01'] = {
    
    },
    
    ['ba_prop_int_glam_stool'] = {
    
    },
    
    ['ba_prop_battle_club_chair_01'] = {
    
    },
    
    ['ba_prop_battle_club_chair_02'] = {
    
    },
    
    ['ba_prop_battle_club_chair_03'] = {
    
    },
    
    ['v_ret_gc_chair01'] = {
    
    },
    
    ['v_ret_gc_chair02'] = {
    
    },
    
    ['prop_arcade_01'] = {
    
    },
    
    ['v_res_fh_towerfan'] = {
    
    },
    
    ['v_res_fa_phone'] = {
    
    },
    
    ['v_res_fh_bedsideclock'] = {
    
    },
    
    ['v_res_fh_speakerdock'] = {
    
    },
    
    ['prop_tv_cabinet_04'] = {
    
    },
    
    ['apa_mp_h_str_shelfwallm_01'] = {
    
    },
    
    ['prop_coathook_01'] = {
    
    },
    
    ['v_res_cherubvase'] = {
    
    },
    
    ['v_res_fh_aftershavebox'] = {
    
    },
    
    ['v_res_fh_flowersa'] = {
    
    },
    
    ['v_res_fh_fruitbowl'] = {
    
    },
    
    ['v_res_fh_sculptmod'] = {
    
    },
    
    ['v_res_j_magrack'] = {
    
    },
    
    ['v_res_jewelbox'] = {
    
    },
    
    ['v_res_mbbin'] = {
    
    },
    
    ['v_res_mbowlornate'] = {
    
    },
    
    ['v_res_mbronzvase'] = {
    
    },
    
    ['v_res_m_candle'] = {
    
    },
    
    ['v_res_m_candlelrg'] = {
    
    },
    
    ['ch_prop_whiteboard'] = {
    
    },
    
    ['v_ret_fh_ashtray'] = {
    
    },
    
    ['apa_mp_h_acc_rugwooll_04'] = {
    
    },
    
    ['ex_mp_h_acc_rugwoolm_04'] = {
    
    },
    
    ['apa_mp_h_acc_rugwoolm_03'] = {
    
    },
    
    ['apa_mp_h_acc_rugwooll_03'] = {
    
    },
    
    ['prop_amb_40oz_03'] = {
    
    },
    
    ['prop_amb_beer_bottle'] = {
    
    },
    
    ['prop_aviators_01'] = {
    
    },
    
    ['prop_beer_box_01'] = {
    
    },
    
    ['prop_binoc_01'] = {
    
    },
    
    ['prop_blox_spray'] = {
    
    },
    
    ['prop_bong_01'] = {
    
    },
    
    ['prop_boombox_01'] = {
    
    },
    
    ['prop_bowl_crisps'] = {
    
    },
    
    ['prop_candy_pqs'] = {
    
    },
    
    ['prop_carrier_bag_01'] = {
    
    },
    
    ['prop_ceramic_jug_01'] = {
    
    },
    
    ['prop_cigar_pack_01'] = {
    
    },
    
    ['prop_cigar_pack_02'] = {
    
    },
    
    ['prop_cs_beer_box'] = {
    
    },
    
    ['prop_cs_binder_01'] = {
    
    },
    
    ['prop_cs_bs_cup'] = {
    
    },
    
    ['prop_cs_champ_flute'] = {
    
    },
    
    ['prop_cs_duffel_01'] = {
    
    },
    
    ['prop_cs_ilev_blind_01'] = {
    
    },
    
    ['p_ld_bs_bag_01'] = {
    
    },
    
    ['prop_cs_ironing_board'] = {
    
    },
    
    ['prop_cs_kettle_01'] = {
    
    },
    
    ['prop_cs_lester_crate'] = {
    
    },
    
    ['prop_cs_script_bottle_01'] = {
    
    },
    
    ['prop_cs_script_bottle'] = {
    
    },
    
    ['prop_cs_whiskey_bottle'] = {
    
    },
    
    ['prop_peanut_bowl_01'] = {
    
    },
    
    ['prop_tumbler_01'] = {
    
    },
    
    ['prop_weed_bottle'] = {
    
    },
    
    ['p_cs_lighter_01'] = {
    
    },
    
    ['p_cs_papers_01'] = {
    
    },
    
    ['prop_champ_cool'] = {
    
    },
    
    ['prop_champ_01b'] = {
    
    },
    
    ['ba_prop_club_champset'] = {
    
    },
    
    ['v_res_fa_candle01'] = {
    
    },
    
    ['v_res_fa_candle02'] = {
    
    },
    
    ['v_res_fa_candle03'] = {
    
    },
    
    ['v_res_fa_candle04'] = {
    
    },
    
    ['v_med_bottles2'] = {
    
    },
    
    ['v_res_desktidy'] = {
    
    },
    
    ['v_med_p_notebook'] = {
    
    },
    
    ['ba_prop_battle_trophy_battler'] = {
    
    },
    
    ['ba_prop_battle_trophy_no1'] = {
    
    },
    
    ['prop_golf_bag_01c'] = {
    
    },
    
    ['bkr_prop_bkr_cash_scatter_01'] = {
    
    },
    
    ['bkr_prop_bkr_cashpile_01'] = {
    
    },
    
    ['bkr_prop_bkr_cash_roll_01'] = {
    
    },
    
    ['bkr_prop_bkr_cashpile_04'] = {
    
    },
    
    ['bkr_prop_weed_smallbag_01a'] = {
    
    },
    
    ['prop_gold_bar'] = {
    
    },
    
    ['beerrow_world'] = {
    
    },
    
    ['beerrow_local'] = {
    
    },
    
    ['p_cs_joint_02'] = {
    
    },
    
    ['p_tumbler_cs2_s'] = {
    
    },
    
    ['prop_amb_donut'] = {
    
    },
    
    ['prop_donut_02'] = {
    
    },
    
    ['prop_bar_shots'] = {
    
    },
    
    ['prop_bar_stirrers'] = {
    
    },
    
    ['prop_beer_amopen'] = {
    
    },
    
    ['prop_beer_blr'] = {
    
    },
    
    ['prop_beer_logger'] = {
    
    },
    
    ['prop_beer_stzopen'] = {
    
    },
    
    ['prop_bikerset'] = {
    
    },
    
    ['prop_bottle_brandy'] = {
    
    },
    
    ['prop_tequila_bottle'] = {
    
    },
    
    ['prop_tequila'] = {
    
    },
    
    ['prop_bottle_cognac'] = {
    
    },
    
    ['prop_bottle_macbeth'] = {
    
    },
    
    ['prop_brandy_glass'] = {
    
    },
    
    ['prop_mug_01'] = {
    
    },
    
    ['prop_mug_02'] = {
    
    },
    
    ['prop_mug_03'] = {
    
    },
    
    ['prop_pint_glass_01'] = {
    
    },
    
    ['prop_pizza_box_03'] = {
    
    },
    
    ['prop_sandwich_01'] = {
    
    },
    
    ['prop_cava'] = {
    
    },
    
    ['prop_drink_redwine'] = {
    
    },
    
    ['prop_cherenkov_02'] = {
    
    },
    
    ['vodkarow'] = {
    
    },
    
    ['prop_cherenkov_03'] = {
    
    },
    
    ['prop_cocktail_glass'] = {
    
    },
    
    ['prop_cs_bottle_opener'] = {
    
    },
    
    ['prop_food_bs_chips'] = {
    
    },
    
    ['prop_cs_burger_01'] = {
    
    },
    
    ['prop_cs_hand_radio'] = {
    
    },
    
    ['prop_cs_hotdog_01'] = {
    
    },
    
    ['v_ret_csr_bin'] = {
    
    },
    
    ['v_ret_fh_wickbskt'] = {
    
    },
    
    ['v_ret_gc_bag01'] = {
    
    },
    
    ['v_ret_gc_bin'] = {
    
    },
    
    ['v_ret_gc_clock'] = {
    
    },
    
    ['v_ret_ps_bag_01'] = {
    
    },
    
    ['v_ret_ps_bag_02'] = {
    
    },
    
    ['v_ret_ta_book1'] = {
    
    },
    
    ['v_ret_ta_book2'] = {
    
    },
    
    ['v_ret_ta_book3'] = {
    
    },
    
    ['v_ret_ta_book4'] = {
    
    },
    
    ['v_ret_ta_camera'] = {
    
    },
    
    ['v_ret_ta_firstaid'] = {
    
    },
    
    ['v_ret_ta_hero'] = {
    
    },
    
    ['v_ret_ta_mag1'] = {
    
    },
    
    ['v_ret_ta_mag2'] = {
    
    },
    
    ['v_ret_ta_skull'] = {
    
    },
    
    ['prop_acc_guitar_01'] = {
    
    },
    
    ['prop_amb_handbag_01'] = {
    
    },
    
    ['prop_attache_case_01'] = {
    
    },
    
    ['prop_big_bag_01'] = {
    
    },
    
    ['prop_cs_shopping_bag'] = {
    
    },
    
    ['v_res_fa_book03'] = {
    
    },
    
    ['prop_tool_broom'] = {
    
    },
    
    ['prop_fire_exting_2a'] = {
    
    },
    
    ['v_res_vacuum'] = {
    
    },
    
    ['v_club_vusnaketank'] = {
    
    },
    
    ['v_club_vu_deckcase'] = {
    
    },
    
    ['prop_dummy_01'] = {
    
    },
    
    ['prop_egg_clock_01'] = {
    
    },
    
    ['prop_el_guitar_01'] = {
    
    },
    
    ['prop_el_guitar_02'] = {
    
    },
    
    ['prop_el_guitar_03'] = {
    
    },
    
    ['prop_floor_duster_01'] = {
    
    },
    
    ['prop_fruit_basket'] = {
    
    },
    
    ['prop_f_duster_02'] = {
    
    },
    
    ['prop_idol_case_01'] = {
    
    },
    
    ['prop_jewel_02a'] = {
    
    },
    
    ['prop_jewel_02b'] = {
    
    },
    
    ['prop_jewel_02c'] = {
    
    },
    
    ['prop_jewel_03a'] = {
    
    },
    
    ['prop_jewel_03b'] = {
    
    },
    
    ['prop_jewel_04a'] = {
    
    },
    
    ['prop_jewel_04b'] = {
    
    },
    
    ['prop_j_disptray_01'] = {
    
    },
    
    ['prop_j_disptray_01b'] = {
    
    },
    
    ['prop_j_disptray_02'] = {
    
    },
    
    ['prop_j_disptray_03'] = {
    
    },
    
    ['prop_j_disptray_04'] = {
    
    },
    
    ['prop_j_disptray_04b'] = {
    
    },
    
    ['prop_j_disptray_05'] = {
    
    },
    
    ['prop_j_disptray_05b'] = {
    
    },
    
    ['prop_ld_suitcase_01'] = {
    
    },
    
    ['prop_ld_suitcase_02'] = {
    
    },
    
    ['hei_p_attache_case_shut'] = {
    
    },
    
    ['prop_mr_rasberryclean'] = {
    
    },
    
    ['prop_paper_bag_01'] = {
    
    },
    
    ['prop_shopping_bags01'] = {
    
    },
    
    ['prop_shopping_bags02'] = {
    
    },
    
    ['p_ld_sax'] = {
    
    },
    
    ['p_ld_soc_ball_01'] = {
    
    },
    
    ['p_watch_01'] = {
    
    },
    
    ['p_watch_02'] = {
    
    },
    
    ['p_watch_03'] = {
    
    },
    
    ['p_watch_04'] = {
    
    },
    
    ['p_watch_05'] = {
    
    },
    
    ['p_watch_06'] = {
    
    },
    
    ['apa_mp_h_acc_candles_01'] = {
    
    },
    
    ['apa_mp_h_acc_candles_02'] = {
    
    },
    
    ['apa_mp_h_acc_candles_04'] = {
    
    },
    
    ['apa_mp_h_acc_candles_06'] = {
    
    },
    
    ['prop_bskball_01'] = {
    
    },
    
    ['v_res_r_figcat'] = {
    
    },
    
    ['v_res_r_figclown'] = {
    
    },
    
    ['v_res_r_figfemale'] = {
    
    },
    
    ['v_res_r_figflamenco'] = {
    
    },
    
    ['v_res_r_figgirl'] = {
    
    },
    
    ['v_res_r_figgirlclown'] = {
    
    },
    
    ['v_res_r_figoblisk'] = {
    
    },
    
    ['v_res_r_figpillar'] = {
    
    },
    
    ['v_res_sculpt_dec'] = {
    
    },
    
    ['v_res_sculpt_decd'] = {
    
    },
    
    ['v_res_sculpt_dece'] = {
    
    },
    
    ['v_res_sculpt_decf'] = {
    
    },
    
    ['v_res_skateboard'] = {
    
    },
    
    ['v_res_sketchpad'] = {
    
    },
    
    ['v_res_tissues'] = {
    
    },
    
    ['v_res_tre_basketmess'] = {
    
    },
    
    ['v_res_tre_bin'] = {
    
    },
    
    ['v_res_tre_cushiona'] = {
    
    },
    
    ['v_res_tre_cushionb'] = {
    
    },
    
    ['v_res_tre_cushionc'] = {
    
    },
    
    ['v_res_tre_cushiond'] = {
    
    },
    
    ['v_res_tre_fruitbowl'] = {
    
    },
    
    ['prop_idol_01'] = {
    
    },
    
    ['v_res_r_fighorsestnd'] = {
    
    },
    
    ['v_res_r_fighorse'] = {
    
    },
    
    ['v_res_r_figdancer'] = {
    
    },
    
    ['v_res_fa_idol02'] = {
    
    },
    
    ['v_res_m_statue'] = {
    
    },
    
    ['v_med_p_vaseround'] = {
    
    },
    
    ['ex_mp_h_acc_vase_05'] = {
    
    },
    
    ['apa_mp_h_acc_dec_head_01'] = {
    
    },
    
    ['apa_mp_h_acc_dec_sculpt_02'] = {
    
    },
    
    ['ex_mp_h_acc_dec_plate_02'] = {
    
    },
    
    ['apa_mp_h_acc_bowl_ceramic_01'] = {
    
    },
    
    ['apa_mp_h_acc_dec_plate_01'] = {
    
    },
    
    ['apa_mp_h_acc_vase_01'] = {
    
    },
    
    ['apa_mp_h_acc_vase_02'] = {
    
    },
    
    ['apa_mp_h_acc_vase_05'] = {
    
    },
    
    ['apa_mp_h_acc_vase_06'] = {
    
    },
    
    ['v_res_mplanttongue'] = {
    
    },
    
    ['prop_fib_plant_01'] = {
    
    },
    
    ['v_corp_bombplant'] = {
    
    },
    
    ['v_res_mflowers'] = {
    
    },
    
    ['v_res_mvasechinese'] = {
    
    },
    
    ['v_res_m_palmplant1'] = {
    
    },
    
    ['v_res_m_palmstairs'] = {
    
    },
    
    ['v_res_m_urn'] = {
    
    },
    
    ['v_res_rubberplant'] = {
    
    },
    
    ['v_res_tre_plant'] = {
    
    },
    
    ['v_res_tre_tree'] = {
    
    },
    
    ['v_med_p_planter'] = {
    
    },
    
    ['v_ret_flowers'] = {
    
    },
    
    ['v_ret_j_flowerdisp'] = {
    
    },
    
    ['v_ret_j_flowerdisp_white'] = {
    
    },
    
    ['v_res_m_vasefresh'] = {
    
    },
    
    ['v_res_rosevasedead'] = {
    
    },
    
    ['v_res_exoticvase'] = {
    
    },
    
    ['v_res_rosevase'] = {
    
    },
    
    ['apa_mp_h_acc_plant_palm_01'] = {
    
    },
    
    ['prop_plant_int_01a'] = {
    
    },
    
    ['prop_plant_int_01b'] = {
    
    },
    
    ['prop_plant_int_02a'] = {
    
    },
    
    ['prop_plant_int_02b'] = {
    
    },
    
    ['prop_plant_int_03a'] = {
    
    },
    
    ['prop_plant_int_03b'] = {
    
    },
    
    ['prop_plant_int_03c'] = {
    
    },
    
    ['prop_plant_int_04c'] = {
    
    },
    
    ['prop_plant_int_05b'] = {
    
    },
    
    ['prop_pot_plant_01a'] = {
    
    },
    
    ['prop_pot_plant_01b'] = {
    
    },
    
    ['prop_pot_plant_01c'] = {
    
    },
    
    ['prop_pot_plant_01d'] = {
    
    },
    
    ['prop_pot_plant_01e'] = {
    
    },
    
    ['prop_pot_plant_05a'] = {
    
    },
    
    ['prop_pot_plant_05b'] = {
    
    },
    
    ['p_int_jewel_plant_01'] = {
    
    },
    
    ['p_int_jewel_plant_02'] = {
    
    },
    
    ['apa_mp_h_acc_vase_flowers_01'] = {
    
    },
    
    ['apa_mp_h_acc_vase_flowers_02'] = {
    
    },
    
    ['apa_mp_h_acc_vase_flowers_03'] = {
    
    },
    
    ['apa_mp_h_acc_vase_flowers_04'] = {
    
    },
    
    ['v_corp_cd_desklamp'] = {
    
    },
    
    ['v_res_desklamp'] = {
    
    },
    
    ['v_res_d_lampa'] = {
    
    },
    
    ['v_res_fa_lamp1on'] = {
    
    },
    
    ['v_res_fh_floorlamp'] = {
    
    },
    
    ['v_res_fh_lampa_on'] = {
    
    },
    
    ['v_res_j_tablelamp1'] = {
    
    },
    
    ['v_res_j_tablelamp2'] = {
    
    },
    
    ['v_res_mdbedlamp'] = {
    
    },
    
    ['v_res_mtblelampmod'] = {
    
    },
    
    ['v_res_m_lampstand'] = {
    
    },
    
    ['v_res_m_lampstand2'] = {
    
    },
    
    ['v_res_m_lamptbl'] = {
    
    },
    
    ['v_res_tre_talllamp'] = {
    
    },
    
    ['v_ret_gc_lamp'] = {
    
    },
    
    ['v_med_p_floorlamp'] = {
    
    },
    
    ['v_club_vu_lamp'] = {
    
    },
    
    ['apa_mp_h_lit_floorlampnight_07'] = {
    
    },
    
    ['apa_mp_h_floorlamp_a'] = {
    
    },
    
    ['apa_mp_h_floorlamp_b'] = {
    
    },
    
    ['apa_mp_h_floorlamp_c'] = {
    
    },
    
    ['apa_mp_h_floor_lamp_int_08'] = {
    
    },
    
    ['apa_mp_h_lit_floorlampnight_14'] = {
    
    },
    
    ['apa_mp_h_lit_floorlamp_03'] = {
    
    },
    
    ['apa_mp_h_lit_floorlamp_06'] = {
    
    },
    
    ['apa_mp_h_lit_floorlamp_10'] = {
    
    },
    
    ['apa_mp_h_lit_floorlamp_13'] = {
    
    },
    
    ['apa_mp_h_lit_floorlamp_17'] = {
    
    },
    
    ['apa_mp_h_lit_lamptablenight_16'] = {
    
    },
    
    ['apa_mp_h_lit_lamptablenight_24'] = {
    
    },
    
    ['apa_mp_h_lit_lamptable_005'] = {
    
    },
    
    ['apa_mp_h_lit_lamptable_04'] = {
    
    },
    
    ['apa_mp_h_lit_lamptable_09'] = {
    
    },
    
    ['apa_mp_h_lit_lamptable_14'] = {
    
    },
    
    ['apa_mp_h_lit_lamptable_17'] = {
    
    },
    
    ['v_res_d_coffeetable'] = {
    
    },
    
    ['v_res_d_roundtable'] = {
    
    },
    
    ['v_res_fh_coftablea'] = {
    
    },
    
    ['v_res_fh_coftableb'] = {
    
    },
    
    ['v_res_fh_coftbldisp'] = {
    
    },
    
    ['v_res_fh_diningtable'] = {
    
    },
    
    ['v_res_j_coffeetable'] = {
    
    },
    
    ['v_res_j_lowtable'] = {
    
    },
    
    ['v_res_mdbedtable'] = {
    
    },
    
    ['v_res_msidetblemod'] = {
    
    },
    
    ['v_res_m_console'] = {
    
    },
    
    ['v_res_m_dinetble_replace'] = {
    
    },
    
    ['v_res_m_h_console'] = {
    
    },
    
    ['v_res_m_stool'] = {
    
    },
    
    ['v_res_tre_table2'] = {
    
    },
    
    ['v_med_p_coffeetable'] = {
    
    },
    
    ['v_med_p_desk'] = {
    
    },
    
    ['prop_yacht_table_01'] = {
    
    },
    
    ['prop_yacht_table_02'] = {
    
    },
    
    ['prop_yacht_table_03'] = {
    
    },
    
    ['v_ret_csr_table'] = {
    
    },
    
    ['v_res_mconsoletrad'] = {
    
    },
    
    ['v_ilev_liconftable_sml'] = {
    
    },
    
    ['v_ret_tablesml'] = {
    
    },
    
    ['apa_mp_h_yacht_coffee_table_02'] = {
    
    },
    
    ['apa_mp_h_yacht_side_table_01'] = {
    
    },
    
    ['apa_mp_h_yacht_side_table_02'] = {
    
    },
    
    ['apa_mp_h_tab_sidelrg_04'] = {
    
    },
    
    ['apa_mp_h_tab_sidelrg_07'] = {
    
    },
    
    ['ba_prop_int_trad_table'] = {
    
    },
    
    ['apa_mp_h_str_sideboards_02'] = {
    
    },
    
    ['apa_mp_h_din_table_04'] = {
    
    },
    
    ['apa_mp_h_tab_coffee_07'] = {
    
    },
    
    ['apa_mp_h_tab_coffee_08'] = {
    
    },
    
    ['apa_mp_h_tab_sidelrg_02'] = {
    
    },
    
    ['ba_prop_int_edgy_table_01'] = {
    
    },
    
    ['ba_prop_int_edgy_table_02'] = {
    
    },
    
    ['apa_mp_h_tab_sidelrg_01'] = {
    
    }, 
    ['matataa_liquor_counter'] = {
    
    },
	-- kk-properties2 drugs
    ['v_res_fa_fan'] = {
        type = 'itemSwapper',
        itemAction = 'dryer',
        durabilityLoss = 1,

        inventory = {
            slots = 9,
            size = 20000
        }
    },

    ['prop_aircon_s_04a'] = {
        type = 'itemSwapper',
        itemAction = 'tabacco_dryer',

        inventory = {
            slots = 2,
            size = 20000
        }
    },

    ['prop_bandsaw_01'] = {
        type = 'itemSwapper',
        itemAction = 'atm_crusher',
        durabilityLoss = 1,

        inventory = {
            slots = 4,
            size = 200000
        }
    },

    ['sf_prop_sf_distillery_01a'] = {
        type = 'itemSwapper',
        itemAction = 'alcohol_maker',
        durabilityLoss = 1,

        inventory = {
            slots = 2,
            size = 50000
        }
    },

    ['prop_still'] = {
        type = 'itemSwapper',
        itemAction = 'moonshine_maker',
        durabilityLoss = 1,

        inventory = {
            slots = 2,
            size = 40000
        }
    },
	-- kkproperties2 drug lõpp
    -- kkproperties2 rahapesu
    ['bkr_prop_prtmachine_dryer_spin'] = {
        type = 'itemSwapper',
        itemAction = 'money_wash',
        durabilityLoss = 1,

        inventory = {
            slots = 2,
            size = 350
        }
    },
    -- kkproperties2 rahapesu lõpp
    -- toidukad ALL SIIT VAJA PILTE?

    ['prop_micro_02'] = { 
        type = 'crafting'
    },
    ['bzzz_foodpack_pizza_cutting-board001'] = { 
        type = 'crafting'
    },
    ['bzzz_foodpack_pizza_oven005'] = { 
        type = 'crafting'
    },
    ['prop_toaster_01'] = { 
        type = 'crafting'
    },
    ['v_res_mchopboard'] = { 
        type = 'crafting'
    },
    ['prop_micro_01'] = { 
        type = 'crafting'
    },
    ['v_res_fa_chopbrd'] = { 
        type = 'crafting'
    },
    ['prop_cooker_03'] = { 
        type = 'crafting'
    },
    ['prop_bbq_5'] = { 
        type = 'crafting'
    },
    ['v_res_pestle'] = { 
        type = 'crafting'
    },
    ['v_res_tre_mixer'] = { 
        type = 'crafting'
    },
    ['bzzz_electro_grill_kebab_e'] = { 
        type = 'crafting'
    },
    ['apa_mp_h_acc_coffeemachine_01'] = { 
        type = 'crafting'
    },
    ['prop_food_tray_01'] = {
        type = 'food_tray',
        inventory = {
            slots = 10,
            size = 40000
        }
    },

    ['bkr_prop_fakeid_papercutter'] = { 
        type = 'crafting'
    },

    ['bzzz_prop_crafting_mill_c'] = { 
        type = 'crafting'
    },

    ['bkr_prop_weed_table_01b'] = { 
        type = 'crafting'
    },

    ['prop_slush_dispenser'] = { 
        type = 'crafting'
    },

    ['prop_till_03'] = {
        type = 'terminal'
    },
    -- toiduka end
    -- NARX JA MUU
    ['bkr_prop_weed_table_01a'] = { -- NARXI PLOKK(KANEP)
        type = 'crafting'
    },
    
    ['bkr_prop_coke_scale_02'] = { -- Pakendamine(Tubakas)
        type = 'crafting'
    },

    ['vw_prop_vw_table_01a'] = { -- ASENDUSKUIVATUS
        type = 'crafting'
    },

    ['gr_prop_gr_speeddrill_01b'] = { -- CRAFTING EHTED
        type = 'crafting'
    },

    ['bkr_prop_weed_table_01a'] = { -- NARXI PLOKK(KANEP)
    type = 'crafting'
    },

    ['bkr_prop_coke_scale_02'] = { -- Pakendamine(Tubakas)
        type = 'crafting'
    },

    ['vw_prop_vw_table_01a'] = { -- ASENDUSKUIVATUS
        type = 'crafting'
    },

    ['gr_prop_gr_speeddrill_01b'] = { -- CRAFTING EHTED
        type = 'crafting'
    },
}

cfg.swapInterval = 2.0 -- minutes

exports('getSwapInterval', function()
    return cfg.swapInterval
end)

cfg.swapItems = {
    ['rolls'] = {
        progress = 0.15, -- per cfg.swapInterval minutes
        type = 'money_wash',
        reward = {'money', 1000}
    },
    ['sulp'] = {
        progress = 4.0, -- per cfg.swapInterval minutes
        type = 'alcohol_maker',
        reward = {'alcohol', 2}
    },
    ['sulp_strong'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'moonshine_maker',
        reward = {'moonshine', 2}
    },
    ['wet_weed'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed', 1}
    },
    ['wet_weed2'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed2', 1}
    },
    ['wet_weed5'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed5', 1}
    },
    ['wet_weed8'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed8', 1}
    },
    ['wet_weed11'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed11', 1}
    },
    ['wet_weed14'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed14', 1}
    },
    ['wet_weed17'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed17', 1}
    },
    ['wet_weed20'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed20', 1}
    },
    ['wet_weed23'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed23', 1}
    },
    ['wet_weed_green'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_green', 1}
    },
    ['wet_weed_maroon'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_maroon', 1}
    },
    ['wet_weed_natur'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_natur', 1}
    },
    ['wet_weed_purple'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_purple', 1}
    },
    ['wet_weed_red'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_red', 1}
    },
    ['wet_weed_romance'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_romance', 1}
    },
    ['wet_weed_sea'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_sea', 1}
    },
    ['wet_weed_sunny'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_sunny', 1}
    },
    ['wet_weed_yellow'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_yellow', 1}
    },
    ['wet_weed_green2'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_green2', 1}
    },
    ['wet_weed_maroon2'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_maroon2', 1}
    },
    ['wet_weed_natur2'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_natur2', 1}
    },
    ['wet_weed_purple2'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_purple2', 1}
    },
    ['wet_weed_red2'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_red2', 1}
    },
    ['wet_weed_romance2'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_romance2', 1}
    },
    ['wet_weed_sea2'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_sea2', 1}
    },
    ['wet_weed_sunny2'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_sunny2', 1}
    },
    ['wet_weed_yellow2'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_yellow2', 1}
    },
    ['wet_weed_green5'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_green5', 1}
    },
    ['wet_weed_maroon5'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_maroon5', 1}
    },
    ['wet_weed_natur5'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_natur5', 1}
    },
    ['wet_weed_purple5'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_purple5', 1}
    },
    ['wet_weed_red5'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_red5', 1}
    },
    ['wet_weed_romance5'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_romance5', 1}
    },
    ['wet_weed_sea5'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_sea5', 1}
    },
    ['wet_weed_sunny5'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_sunny5', 1}
    },
    ['wet_weed_yellow5'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_yellow5', 1}
    },
    ['wet_weed_green8'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_green8', 1}
    },
    ['wet_weed_maroon8'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_maroon8', 1}
    },
    ['wet_weed_natur8'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_natur8', 1}
    },
    ['wet_weed_purple8'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_purple8', 1}
    },
    ['wet_weed_red8'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_red8', 1}
    },
    ['wet_weed_romance8'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_romance8', 1}
    },
    ['wet_weed_sea8'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_sea8', 1}
    },
    ['wet_weed_sunny8'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_sunny8', 1}
    },
    ['wet_weed_yellow8'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_yellow8', 1}
    },
    ['wet_weed_green11'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_green11', 1}
    },
    ['wet_weed_maroon11'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_maroon11', 1}
    },
    ['wet_weed_natur11'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_natur11', 1}
    },
    ['wet_weed_purple11'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_purple11', 1}
    },
    ['wet_weed_red11'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_red11', 1}
    },
    ['wet_weed_romance11'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_romance11', 1}
    },
    ['wet_weed_sea11'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_sea11', 1}
    },
    ['wet_weed_sunny11'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_sunny11', 1}
    },
    ['wet_weed_yellow11'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_yellow11', 1}
    },
    ['wet_weed_green14'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_green14', 1}
    },
    ['wet_weed_maroon14'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_maroon14', 1}
    },
    ['wet_weed_natur14'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_natur14', 1}
    },
    ['wet_weed_purple14'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_purple14', 1}
    },
    ['wet_weed_red14'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_red14', 1}
    },
    ['wet_weed_romance14'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_romance14', 1}
    },
    ['wet_weed_sea14'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_sea14', 1}
    },
    ['wet_weed_sunny14'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_sunny14', 1}
    },
    ['wet_weed_yellow14'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_yellow14', 1}
    },
    ['wet_weed_green17'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_green17', 1}
    },
    ['wet_weed_maroon17'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_maroon17', 1}
    },
    ['wet_weed_natur17'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_natur17', 1}
    },
    ['wet_weed_purple17'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_purple17', 1}
    },
    ['wet_weed_red17'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_red17', 1}
    },
    ['wet_weed_romance17'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_romance17', 1}
    },
    ['wet_weed_sea17'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_sea17', 1}
    },
    ['wet_weed_sunny17'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_sunny17', 1}
    },
    ['wet_weed_yellow17'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_yellow17', 1}
    },
    ['wet_weed_green20'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_green20', 1}
    },
    ['wet_weed_maroon20'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_maroon20', 1}
    },
    ['wet_weed_natur20'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_natur20', 1}
    },
    ['wet_weed_purple20'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_purple20', 1}
    },
    ['wet_weed_red20'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_red20', 1}
    },
    ['wet_weed_romance20'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_romance20', 1}
    },
    ['wet_weed_sea20'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_sea20', 1}
    },
    ['wet_weed_sunny20'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_sunny20', 1}
    },
    ['wet_weed_yellow20'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_yellow20', 1}
    },
    ['wet_weed_green23'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_green23', 1}
    },
    ['wet_weed_maroon23'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_maroon23', 1}
    },
    ['wet_weed_natur23'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_natur23', 1}
    },
    ['wet_weed_purple23'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_purple23', 1}
    },
    ['wet_weed_red23'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_red23', 1}
    },
    ['wet_weed_romance23'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_romance23', 1}
    },
    ['wet_weed_sea23'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_sea23', 1}
    },
    ['wet_weed_sunny23'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_sunny23', 1}
    },
    ['wet_weed_yellow23'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_yellow23', 1}
    },
    ['wet_weed_yellow23'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'dryer',
        reward = {'dried_weed_yellow23', 1}
    },
    ['wet_tabaccoleaf'] = {
        progress = 2.0, -- per cfg.swapInterval minutes
        type = 'tabacco_dryer',
        reward = {'dried_tabacco', 1}
    },
    ['wet_tabacco'] = {
        progress = 2.0, -- per cfg.swapInterval minutes
        type = 'tabacco_dryer',
        reward = {'tabacco_powder', 1}
    },
    ['atm1'] = {
        progress = 2.0, -- per cfg.swapInterval minutes
        type = 'atm_crusher',
        reward = {'rolls', 5}
    },
    ['atm2'] = {
        progress = 2.0, -- per cfg.swapInterval minutes
        type = 'atm_crusher',
        reward = {'rolls', 5}
    },
    ['atm3'] = {
        progress = 2.0, -- per cfg.swapInterval minutes
        type = 'atm_crusher',
        reward = {'rolls', 10}
    },
    ['wpn_taurus_core'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'pistol_maker',
        reward = {'WEAPON_PISTOL', 1}
    },
    ['wpn_p2000_core'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'pistol_maker',
        reward = {'WEAPON_COMBATPISTOL', 1}
    },
    ['wpn_pistol50_core'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'pistol_maker',
        reward = {'WEAPON_PISTOL50', 1}
    },
    ['wpn_ewb_core'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'pistol_maker',
        reward = {'WEAPON_HEAVYPISTOL', 1}
    },
    ['pistol_package_blueprint'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'ammo_maker',
        reward = {'pistol_package', 2}
    },
    ['rifle_package_blueprint'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'ammo_maker',
        reward = {'rifle_package', 2}
    },
    ['shotgun_package_blueprint'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'ammo_maker',
        reward = {'shotgun_package', 2}
    },
    ['wpn_microsmg_core'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'smg_maker',
        reward = {'WEAPON_MICROSMG', 1}
    },
    ['wpn_smgmk2_core'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'smg_maker',
        reward = {'WEAPON_SMG_MK2', 1}
    },
    ['wpn_assaultsmg_core'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'smg_maker',
        reward = {'WEAPON_ASSAULTSMG', 1}
    },
    ['wpn_combatpdw_core'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'smg_maker',
        reward = {'WEAPON_COMBATPDW', 1}
    },
    ['wpn_machinepistol_core'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'smg_maker',
        reward = {'WEAPON_MACHINEPISTOL', 1}
    },
    ['wpn_minismg_core'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'smg_maker',
        reward = {'WEAPON_MINISMG', 1}
    },
    ['wpn_assaultrifle_core'] = {
        progress = 0.25, -- per cfg.swapInterval minutes
        type = 'rifle_maker',
        reward = {'WEAPON_ASSAULTRIFLE', 1}
    },
    ['wpn_assaultrifle_mk2_core'] = {
        progress = 0.25, -- per cfg.swapInterval minutes
        type = 'rifle_maker',
        reward = {'WEAPON_ASSAULTRIFLE_MK2', 1}
    },
    ['wpn_carbinerifle_core'] = {
        progress = 0.25, -- per cfg.swapInterval minutes
        type = 'rifle_maker',
        reward = {'WEAPON_CARBINERIFLE', 1}
    },
    ['wpn_advancedrifle_core'] = {
        progress = 0.25, -- per cfg.swapInterval minutes
        type = 'rifle_maker',
        reward = {'WEAPON_ADVANCEDRIFLE', 1}
    },
    ['wpn_bullpuprifle_mk2_core'] = {
        progress = 0.25, -- per cfg.swapInterval minutes
        type = 'rifle_maker',
        reward = {'WEAPON_BULLPUPRIFLE_MK2', 1}
    },
    ['wpn_pumpshotgun_blueprint'] = {
        progress = 0.25, -- per cfg.swapInterval minutes
        type = 'shotgun_maker',
        reward = {'WEAPON_PUMPSHOTGUN', 1}
    },
    ['wpn_sawnoffshotgun_blueprint'] = {
        progress = 0.25, -- per cfg.swapInterval minutes
        type = 'shotgun_maker',
        reward = {'WEAPON_SAWNOFFSHOTGUN', 1}
    },
    ['wpn_bullpupshotgun_blueprint'] = {
        progress = 0.25, -- per cfg.swapInterval minutes
        type = 'shotgun_maker',
        reward = {'WEAPON_BULLPUPSHOTGUN', 1}
    },
    ['wpn_combatshotgun_blueprint'] = {
        progress = 0.25, -- per cfg.swapInterval minutes
        type = 'shotgun_maker',
        reward = {'WEAPON_COMBATSHOTGUN', 1}
    },
    ['coke_base'] = {
        progress = 1.0, -- per cfg.swapInterval minutes
        type = 'coke_smasher',
        reward = {'coke', 1}
    },
    ['coke_mix'] = {
        progress = 1.25, -- per cfg.swapInterval minutes
        type = 'coke_maker',
        reward = {'coke_pasta', 1}
    },
    ['dried_weed_green'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_green2'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_green5'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_green8'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_green11'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_green14'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_green17'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_green20'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_green23'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_maroon'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_maroon2'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_maroon5'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_maroon8'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_maroon11'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_maroon14'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_maroon17'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_maroon20'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_maroon23'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_natur'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_natur2'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_natur5'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_natur8'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_natur11'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_natur14'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },    
    ['dried_weed_natur17'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_natur20'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_natur23'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_purple'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_purple2'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_purple5'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_purple8'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_purple11'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_purple14'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_purple17'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_purple20'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_purple23'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_red'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_red2'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_red5'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_red8'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_red11'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_red14'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_red17'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_red20'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_red23'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_romance'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_romance2'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_romance5'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_romance8'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_romance11'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_romance14'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_romance17'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_romance20'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_romance23'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_sea'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_sea2'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_sea5'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_sea8'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_sea11'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_sea14'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_sea17'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_sea20'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_sea23'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_sunny'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_sunny2'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_sunny5'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_sunny8'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_sunny11'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_sunny14'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_sunny17'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_sunny20'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_sunny23'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_yellow'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_yellow2'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_yellow5'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_yellow8'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_yellow11'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_yellow14'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_yellow17'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_yellow20'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed_yellow23'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed2'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed5'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed8'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed11'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed14'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed17'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed20'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['dried_weed23'] = {
        progress = 0.5, -- per cfg.swapInterval minutes
        type = 'weed_crusher',
        reward = {'weed_powder', 1}
    },
    ['weed_powder_bigger'] = {
        progress = 0.25, -- per cfg.swapInterval minutes
        type = 'weed_package_maker',
        reward = {'weed_package', 1}
    },
    ['unstable_frost'] = {
        progress = 0.25, -- per cfg.swapInterval minutes
        type = 'frostbite_maker',
        reward = {'frostbite_pack', 1}
    }
}

exports('getSwapItems', function()
    return cfg.swapItems
end)

function getPlaceableData(model)
    local returnable = false

    if cfg.objects[model] then
        returnable = cfg.objects[model]
        returnable.model = model
    end

    return returnable
end

exports('getPlaceableData', getPlaceableData)

exports('getPlaceable', function()
    return cfg.objects
end)

cfg.levels = {
    [1] = {
        price = 4000
    },

    [2] = {
        price = 10000
    },

    [3] = {
        price = 50000
    }
}

cfg.missions = {
    {
        crypto = {min = 3000, max = 8000},
        give = {'device_mission_a', 1},
        recieve = {'pistol_package_blueprint', 2}
    },

    {
        crypto = {min = 7000, max = 12000},
        give = {'device_mission_b', 1},
        recieve = {'rifle_package_blueprint', 2}
    },

    {
        crypto = {min = 13000, max = 25000},
        give = {'device_mission_c', 1},
        recieve = {'shotgun_package_blueprint', 2}
    },
}

exports('getMissions', function()
    return cfg.missions
end)