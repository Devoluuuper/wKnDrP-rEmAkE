cfg = {}
cfg.debug = false
cfg.stand = joaat('prop_lectern_01')
cfg.boxProp = joaat('bzzz_plant_cotton_pot_b')
-- cfg.boxProp = joaat('prop_tool_box_03')


cfg.useskill = true
cfg.skillname = 'farming'




cfg.wateritem = 'water'
cfg.fertilizeritem = 'fertilizer'

cfg.addwater = 50
cfg.addfertilizer = 50

cfg.farms = {
    {
        name = "farm",
        panel = vec4(2219.8286132812, 4771.0024414062, 39.794189453125, 178.58267211914),
        zone = {
            coords = vec3(2227.5, 4782.9, 40.0),
            size = vec3(6.25, 26.0, 4.0),
            rotation = 344.0,
        },

        objects = {
            vec4(2223.1911621094,4772.0043945312,40.030029296875,348.6614074707),
            vec4(2223.9604, 4774.6220, 40.0750, 348.1890),
            vec4(2224.7297, 4777.2396, 40.1199, 347.7165),
            vec4(2225.4989, 4779.8572, 40.1649, 347.2441),
            vec4(2226.2681, 4782.4748, 40.2098, 346.7717),
            vec4(2227.0374, 4785.0924, 40.2547, 346.2992),
            vec4(2227.806640625,4787.7099609375,40.299682617188,345.82678222656),

            vec4(2225.0769042969, 4770.6196289062, 40.01318359375, 345.82678222656),
            vec4(2225.8879, 4773.2724, 40.0553, 345.8268),
            vec4(2226.6989, 4775.9251, 40.0975, 345.8268),
            vec4(2227.5099, 4778.5779, 40.1396, 345.8268),
            vec4(2228.3209, 4781.2306, 40.1817, 345.8268),
            vec4(2229.1319, 4783.8834, 40.2239, 345.8268),            
            vec4(2229.9428710938, 4786.5361328125, 40.265991210938, 345.82678222656)
        }
    },
    {
        name = "farm2",
        panel = vec4(2228.0703125, 4767.1254882812, 39.676147460938, 170.07873535156),
        zone = {
            coords = vec3(2234.95, 4779.9, 40.0),
            size = vec3(6.05, 25.35, 4.0),
            rotation = 344.25,
        },

        objects = {
            vec4(2230.6154785156, 4769.103515625, 39.912109375, 340.15747070312),
            vec4(2231.3715, 4771.6265, 39.9514, 341.1024),
            vec4(2232.1275, 4774.1496, 39.9907, 342.0472),
            vec4(2232.8835, 4776.6726, 40.0300, 342.9921),
            vec4(2233.6396, 4779.1956, 40.0693, 343.9370),
            vec4(2234.3956, 4781.7187, 40.1086, 344.8819),            
            vec4(2235.1516113281, 4784.2416992188, 40.14794921875, 345.82678222656),

            vec4(2237.5385742188, 4783.6616210938, 40.030029296875, 158.74015808105),
            vec4(2236.7935, 4781.2375, 40.0076, 159.2126),
            vec4(2236.0484, 4778.8133, 39.9851, 159.6850),
            vec4(2235.3033, 4776.3892, 39.9626, 160.1575),
            vec4(2234.5583, 4773.9650, 39.9402, 160.6299),
            vec4(2233.8132, 4771.5409, 39.9177, 161.1024),
            vec4(2233.0681152344, 4769.1166992188, 39.895263671875, 161.57479858398)
        }
    },
    {
        name = "farm3",
        panel = vec4(2234.9802246094, 4765.384765625, 39.81103515625, 153.07086181641),
        zone = {
            coords = vec3(2241.55, 4777.95, 40.0),
            size = vec3(6.4, 26.3, 4.0),
            rotation = 343.75,
        },

        objects = {
            vec4(2237.3537597656, 4767.0463867188, 39.861572265625, 345.82678222656),
            vec4(2238.1032, 4769.6024, 39.8840, 345.8268),
            vec4(2238.8527, 4772.1584, 39.9065, 345.8268),
            vec4(2239.6022, 4774.7144, 39.9290, 345.8268),
            vec4(2240.3516, 4777.2703, 39.9514, 345.8268),
            vec4(2241.1011, 4779.8263, 39.9739, 345.8268),
            vec4(2241.8505859375, 4782.3823242188, 39.996337890625, 345.82678222656),

            vec4(2243.9868164062, 4781.9340820312, 39.962646484375, 158.74015808105),
            vec4(2243.2747, 4779.4396, 39.9374, 158.7402),
            vec4(2242.5626, 4776.9450, 39.9121, 158.7402),
            vec4(2241.8505, 4774.4505, 39.8868, 158.7402),
            vec4(2241.1384, 4771.9560, 39.8615, 158.7402),
            vec4(2240.4263, 4769.4615, 39.8362, 158.7402),
            vec4(2239.7143554688, 4766.966796875, 39.81103515625, 158.74015808105)
        }
    },
    {
        name = "farm4",
        panel = vec4(2241.6264648438, 4763.26171875, 39.676147460938, 170.07873535156),
        zone = {
            coords = vec3(2248.3, 4776.0, 40.0),
            size = vec3(5.7, 26.65, 4.0),
            rotation = 343.75,
        },

        objects = {
            vec4(2244.0, 4765.3979492188, 39.709838867188, 342.99212646484),
            vec4(2244.7495, 4767.9781, 39.7407, 342.9921),
            vec4(2245.4990, 4770.5583, 39.7716, 342.9921),
            vec4(2246.2485, 4773.1385, 39.8025, 342.9921),
            vec4(2246.9980, 4775.7187, 39.8334, 342.9921),
            vec4(2247.7475, 4778.2989, 39.8643, 342.9921),
            vec4(2248.4968261719, 4780.87890625, 39.895263671875, 342.99212646484),

            vec4(2250.6726074219, 4780.5361328125, 39.87841796875, 161.57479858398),
            vec4(2249.9737, 4778.0284, 39.8475, 162.0472),
            vec4(2249.2748, 4775.5207, 39.8165, 162.5196),
            vec4(2248.5759, 4773.0130, 39.7856, 162.9920),
            vec4(2247.8770, 4770.5053, 39.7547, 163.4644),
            vec4(2247.1781, 4768.0006, 39.7237, 163.9368),
            vec4(2246.4790039062, 4765.490234375, 39.692993164062, 164.4094543457)
        }
    },
    {
        name = "farm5",
        panel = vec4(2251.2395019531, 4760.9931640625, 39.524536132812, 158.74015808105),
        zone = {
            coords = vec3(2257.4, 4774.0, 40.0),
            size = vec3(5.95, 26.0, 4.0),
            rotation = 344.5,
        },

        objects = {
            vec4(2253.2570800781, 4762.826171875, 39.457153320312, 345.82678222656),
            vec4(2253.9846, 4765.3911, 39.4909, 345.8268),
            vec4(2254.7121, 4767.9560, 39.5246, 345.8268),
            vec4(2255.4396, 4770.5209, 39.5583, 345.8268),
            vec4(2256.1671, 4773.0858, 39.5920, 345.8268),
            vec4(2256.8946, 4775.6507, 39.6257, 345.8268),
            vec4(2257.6220703125, 4778.2153320312, 39.659301757812, 345.82678222656),

            vec4(2259.6396484375, 4777.384765625, 39.625610351562, 158.74015808105),
            vec4(2258.9055, 4774.7430, 39.6003, 159.6851),
            vec4(2258.1714, 4772.1012, 39.5750, 160.6300),
            vec4(2257.4373, 4769.4594, 39.5497, 161.5749),
            vec4(2256.7032, 4766.8176, 39.5244, 162.5198),
            vec4(2255.9691, 4764.1758, 39.4991, 163.4647),            
            vec4(2255.2351074219, 4761.5341796875, 39.473999023438, 164.4094543457)
        }
    },
    {
        name = "farm6",
        panel = vec4(2262.263671875, 4758.1713867188, 38.968505859375, 170.07873535156),
        zone = {
            coords = vec3(2268.45, 4769.5, 39.0),
            size = vec3(6.25, 23.5, 4.0),
            rotation = 345.0,
        },

        objects = {
            vec4(2264.8088378906, 4761.138671875, 39.22119140625, 345.82678222656),
            vec4(2265.4286, 4763.3804, 39.2521, 345.3543),
            vec4(2266.0484, 4765.6221, 39.2830, 344.8818),
            vec4(2266.6682, 4767.8638, 39.3139, 344.4093),
            vec4(2267.2880, 4770.1055, 39.3448, 343.9368),
            vec4(2267.9078, 4772.3472, 39.3757, 343.4643),            
            vec4(2268.5275878906, 4774.5888671875, 39.406616210938, 342.99212646484),

            vec4(2270.8220214844, 4774.193359375, 39.372924804688, 158.74015808105),
            vec4(2270.1429, 4771.7451, 39.3167, 159.2126),
            vec4(2269.4638, 4769.2968, 39.2605, 159.6850),
            vec4(2268.7847, 4766.8485, 39.2043, 160.1574),
            vec4(2268.1056, 4764.4002, 39.1481, 160.6298),
            vec4(2267.4265, 4761.9519, 39.0919, 161.1022),            
            vec4(2266.7473144531, 4759.5034179688, 39.035888671875, 161.57479858398)
        }
    },
    {
        name = "farm8",
        panel = vec4(2269.3713378906, 4756.0087890625, 38.446166992188, 172.91339111328),
        zone = {
            coords = vec3(2275.95, 4768.4, 39.0),
            size = vec3(6.3, 25.55, 3.7),
            rotation = 343.5,
        },

        objects = {
            vec4(2271.982421875, 4758.9755859375, 38.968505859375, 342.99212646484),
            vec4(2272.6417, 4761.2503, 38.9994, 343.4645),
            vec4(2273.3010, 4763.5250, 39.0303, 343.9369),
            vec4(2273.9603, 4765.7997, 39.0612, 344.4093),
            vec4(2274.6196, 4768.0744, 39.0921, 344.8817),
            vec4(2275.2789, 4770.3491, 39.1230, 345.3541),            
            vec4(2275.9384765625, 4772.6240234375, 39.15380859375, 345.82678222656),

            vec4(2278.7077636719, 4772.1362304688, 39.035888671875, 161.57479858398),
            vec4(2278.0792, 4769.8263, 39.0134, 161.1024),
            vec4(2277.4506, 4767.5164, 38.9909, 160.6300),
            vec4(2276.8220, 4765.2065, 38.9684, 160.1576),
            vec4(2276.1934, 4762.8966, 38.9459, 159.6852),
            vec4(2275.5648, 4760.5867, 38.9234, 159.2128),            
            vec4(2274.9362792969, 4758.2768554688, 38.901123046875, 158.74015808105)
        }
    },   
}

cfg.plantList = {
    ['wheat_seed'] = { -- nisu
        transission = {
            'prop_bzzz_gardenpack_barley003',
            'prop_bzzz_gardenpack_barley002',
            'prop_bzzz_gardenpack_barley001'
        },

        reward = {
            item = 'wheat',
            count = { min = 1, max = 8},
            skill = 0.1
        }
    },

    ['oats_seed'] = { -- kaer
        transission = {
            'prop_bzzz_gardenpack_barley003',
            'prop_bzzz_gardenpack_barley002',
            'prop_bzzz_gardenpack_barley001'
        },

        reward = {
            item = 'oats',
            count = { min = 1, max = 8},
            skill = 0.1
        }
    },

    ['rye_seed'] = { -- rukkis
        transission = {
            'prop_bzzz_gardenpack_barley003',
            'prop_bzzz_gardenpack_barley002',
            'prop_bzzz_gardenpack_barley001'
        },

        reward = {
            item = 'rye',
            count = { min = 1, max = 8},
            skill = 0.1
        }
    },

    ['corn_seed'] = { -- mais
        transission = {
            'prop_bzzz_gardenpack_cornstalk003',
            'prop_bzzz_gardenpack_cornstalk002',
            'prop_bzzz_gardenpack_cornstalk001'
        },

        reward = {
            item = 'corn',
            count = { min = 1, max = 8},
            skill = 0.1
        }
    },

    ['hops_seed'] = { -- humal
        transission = {
            'prop_bzzz_gardenpack_hops003',
            'prop_bzzz_gardenpack_hops002',
            'prop_bzzz_gardenpack_hops001'
        },

        reward = {
            item = 'hops',
            count = { min = 1, max = 8},
            skill = 0.1
        }
    },

    ['poppy_seed'] = { -- moon
        transission = {
            'prop_bzzz_gardenpack_poppy003',
            'prop_bzzz_gardenpack_poppy002',
            'prop_bzzz_gardenpack_poppy001'
        },

        reward = {
            item = 'poppy',
            count = { min = 1, max = 8},
            skill = 0.1
        }
    },

    ['tabacco_seed'] = { -- tubakas
        transission = {
            'prop_bzzz_gardenpack_tabacco003',
            'prop_bzzz_gardenpack_tabacco002',
            'bzzz_new_tobacco_plant_a'
        },

        reward = {
            item = 'wet_tabaccoleaf',
            count = { min = 1, max = 8},
            skill = 0.1
        }
    },

    ['cotton_seed'] = { -- puuvill
        transission = {
            'bzzz_plant_cotton_a',
            'bzzz_plant_cotton_b',
            'bzzz_plant_cotton_c'
        },

        reward = {
            item = 'cotton',
            count = { min = 1, max = 10},
            skill = 0.1
        }
    },

    ['cucumber_seed'] = { -- kurk
        transission = {
            'bzzz_plants_cucumber_01',
            'bzzz_plants_cucumber_02',
            'bzzz_plants_cucumber_03'
        },

        reward = {
            item = 'cucumber',
            count = { min = 1, max = 8},
            skill = 0.1
        }
    },

    ['eggplant_seed'] = { -- baklažaan
        transission = {
            'bzzz_plants_eggplant_01',
            'bzzz_plants_eggplant_02',
            'bzzz_plants_eggplant_03'
        },

        reward = {
            item = 'eggplant',
            count = { min = 1, max = 8},
            skill = 0.1
        }
    },

    ['onion_seed'] = { -- sibul
        transission = {
            'bzzz_plants_onion_01',
            'bzzz_plants_onion_02',
            'bzzz_plants_onion_03',
            'bzzz_plants_onion_04'
        },

        reward = {
            item = 'onion',
            count = { min = 1, max = 8},
            skill = 0.1
        }
    },

    ['pineapple_seed'] = { -- ananass
        transission = {
            'bzzz_plants_pineapple_a',
            'bzzz_plants_pineapple_b',
            'bzzz_plants_pineapple_c'
        },

        reward = {
            item = 'pineapple',
            count = { min = 1, max = 8},
            skill = 0.1
        }
    },

    ['carrot_seed'] = { -- porgand
        transission = {
            'bzzz_garden_plant_carrot_a',
            'bzzz_garden_plant_carrot_b',
            'bzzz_garden_plant_carrot_c'
        },

        reward = {
            item = 'carrot',
            count = { min = 1, max = 8},
            skill = 0.1
        }
    },

    ['potato_seed'] = { -- kartul
        transission = {
            'bzzz_plants_potato_01',
            'bzzz_plants_potato_02',
            'bzzz_plants_potato_03'
        },

        reward = {
            item = 'potato',
            count = { min = 1, max = 8},
            skill = 0.1
        }
    },

    ['pumpkin_seed'] = { -- kõrvits
        transission = {
            'bzzz_plant_pumpkin_01',
            'bzzz_plant_pumpkin_02'
        },

        reward = {
            item = 'pumpkin',
            count = { min = 1, max = 8},
            skill = 0.1
        }
    },

    ['salad_seed'] = { -- kapsas
        transission = {
            'bzzz_plant_salad_01',
            'bzzz_plant_salad_02'
        },

        reward = {
            item = 'cabbage',
            count = { min = 1, max = 8},
            skill = 0.1
        }
    },

    ['strawberry_seed'] = { -- maasikas
        transission = {
            'bzzz_plants_strawberry_01',
            'bzzz_plants_strawberry_02',
            'bzzz_plants_strawberry_03'
        },

        reward = {
            item = 'strawberry',
            count = { min = 1, max = 8},
            skill = 0.1
        }
    },

    ['tomato_seed'] = { -- tomat
        transission = {
            'bzzz_plants_tomato_01',
            'bzzz_plants_tomato_02',
            'bzzz_plants_tomato_03'
        },

        reward = {
            item = 'tomatoes',
            count = { min = 1, max = 8},
            skill = 0.1
        }
    },

    ['melon_seed'] = { -- arbuus
        transission = {
            'bzzz_plants_melon_01',
            'bzzz_plants_melon_02',
            'bzzz_plants_melon_03'
        },

        reward = {
            item = 'watermelon',
            count = { min = 1, max = 8},
            skill = 0.1
        }
    },
}

cfg.farmPrice = 10000
cfg.waitTime = { min = 120000, max = 170000 } -- (ms)
cfg.updateinterval = 1