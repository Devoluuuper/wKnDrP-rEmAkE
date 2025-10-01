Config = {}

Config.Locale = 'en'
Config.EnableESXIdentity = true
Config.MaxSalary = 8000

Config.AuthorizedVehicles = {
    police = { -- Firma nimi
		{name = 'Flatbed',model = 'flatbed', price = 25000}
    },
    ambulance = { -- Firma nimi
		{name = 'Flatbed',model = 'flatbed', price = 25000}
    },
    mechanic = { -- Firma nimi
        {name = 'Flatbed',model = 'flatbed', price = 25000}  -- Sõiduki mudel
    },
	angels = { -- Firma nimi
        {name = 'Flatbed',model = 'flatbed', price = 25000}  -- Sõiduki mudel
    },
    taxi = { -- Firma nimi
        {name = 'Takso auto',model = 'taxi', price = 23000}  -- Sõiduki mudel /spawn vehicle Dilettante2
    },
	burgershot = { -- Firma nimi
        {name = 'Kaubik',model = 'speedo4', price = 23000}  -- Sõiduki mudel /spawn vehicle Dilettante2
    },
	uwucafe = { -- Firma nimi
        {name = 'Kaubik',model = 'speedo4', price = 23000}  -- Sõiduki mudel /spawn vehicle Dilettante2
    },
	properties = { -- Firma nimi
		{name = 'Rumpo Custom',model = 'rumpo3', price = 40000}  -- Sõiduki mudel  
	},
	doj = {
		{name = 'Flatbed',model = 'flatbed', price = 25000}
	}
}

-- Config.Garages = {
--     ['police1'] = {
-- 		type = 'car',
--         job = 'police',
-- 		spawnPos = {x = 441.4, y = -974.73, z = 25.7, h = 175.39},
-- 		spawnPoints = {
-- 			{ h = 272.1259765625, z = 25.5054931640625, y = -976.1670532226564, x = 425.4857177734375},
-- 			{ h = 272.1259765625, z = 25.5054931640625, y = -978.8307495117188, x = 425.4989013671875},
-- 			{ h = 272.1259765625, z = 25.5054931640625, y = -981.5604248046876, x = 425.4329833984375},
-- 			{ h = 272.1259765625, z = 25.5054931640625, y = -984.2373657226564, x = 425.4593505859375},
-- 			{ h = 272.1259765625, z = 25.5054931640625, y = -989.050537109375, x = 425.4461669921875},
-- 			{ h = 269.2913513183594, z = 25.5054931640625, y = -991.6747436523438, x = 425.4329833984375},
-- 			{ h = 272.1259765625, z = 25.5054931640625, y = -994.3516235351564, x = 425.4461669921875},
-- 			{ h = 272.1259765625, z = 25.5054931640625, y = -997.107666015625, x = 425.4329833984375},
-- 			{ h = 272.1259765625, z = 25.5054931640625, y = -997.028564453125, x = 437.1560363769531},
-- 			{ h = 272.1259765625, z = 25.5054931640625, y = -997.041748046875, x = 445.3582458496094},
-- 			{ h = 90.70865631103516, z = 25.5054931640625, y = -994.2725219726564, x = 445.8197937011719},
-- 			{ h = 87.87401580810547, z = 25.5054931640625, y = -994.1802368164064, x = 437.5780334472656},
-- 			{ h = 272.1259765625, z = 25.5054931640625, y = -991.5823974609376, x = 436.7736206054688},
-- 			{ h = 269.2913513183594, z = 25.5054931640625, y = -991.5955810546876, x = 445.4901123046875},
-- 			{ h = 87.87401580810547, z = 25.5054931640625, y = -988.8790893554688, x = 445.8197937011719},
-- 			{ h = 87.87401580810547, z = 25.5054931640625, y = -988.984619140625, x = 437.5648498535156},
-- 			{ h = 272.1259765625, z = 25.5054931640625, y = -986.2022094726564, x = 437.1033020019531},
-- 			{ h = 87.87401580810547, z = 25.5054931640625, y = -986.123046875, x = 445.9252624511719}
-- 		}
-- 	},
-- 	['police2'] = {
-- 		type = 'helicopter',
-- 		job = 'police',
-- 		spawnPos = {x = 449.39, y = -985.79, z = 43.69, h = 0.79}, --449.39 -985.79 43.69 0.79
-- 		spawnPoints = {
-- 			{x = 449.26, y = -981.26, z = 43.69, h = 88.84} 
-- 		}
-- 	},	
-- 	['ambulance'] = { 
-- 		type = 'car',
-- 		job = 'ambulance',
-- 		spawnPos = {x = 315.73187255859377,y = -559.5164794921875,z = 28.757568359375},
-- 		spawnPoints = {
-- 			{x = 316.46, y = -550.53, z = 28.52, h = 270.613},
-- 			{x = 316.70, y = -545.06, z = 28.52, h = 270.613}
-- 		}
-- 	},
-- 	['ottos'] = {
-- 		type = 'car',
-- 		job = 'ottos', 
-- 		spawnPos = {x = 795.76239013672, y = -804.09039306641, z = 26.272491455078, h = 232.71153259277},
-- 		spawnPoints = { 
-- 			{x = 802.66076660156, y = -809.22998046875, z = 26.22924041748, h = 179.57202148438},
-- 			{x = 806.17230224609, y = -814.80084228516, z = 26.181341171265, h = 89.936073303223}
-- 		}
-- 	},	
-- 	['taxi'] = {
-- 		type = 'car',
-- 		job = 'taxi',
-- 		spawnPos = {x = 907.92, y = -168.7, z = 74.13, h = 219.46},
-- 		spawnPoints = {
-- 			{x = 916.29, y = -170.45, z = 74.04, h = 280.49}
-- 		}
-- 	},
-- 	['burgershot'] = {
-- 		type = 'car',
-- 		job = 'burgershot',
-- 		spawnPos = {x = -1170.9694824219, y = -899.62652587891, z = 13.817688941956},
-- 		spawnPoints = {
-- 			{x = -1163.2534179688, y = -890.92126464844, z = 14.14296913147, h = 123.34873962402},
-- 			{x = -1165.0656738281, y = -887.56439208984, z = 14.14852809906, h = 120.22749328613}
-- 		}
-- 	}, 
-- 	['uwucafe'] = {
-- 		type = 'car',
-- 		job = 'uwucafe',
-- 		spawnPos = {x = -597.53405761719, y = -1055.2087402344, z = 22.337768554688, h = 138.89762878418},
-- 		spawnPoints = {
-- 			{ x = -596.92749023438, y = -1058.8747558594, z = 22.135498046875, h = 90.708656311035}
-- 		}
-- 	}, 
-- 	['properties'] = {
-- 		type = 'car',
-- 		job = 'properties',
-- 		spawnPos = {x = -108.94944763183594,y = -602.887939453125,z = 36.2725830078125, h = 118.33},
-- 		spawnPoints = {
-- 			{x = -108.56703186035156,y = -614.914306640625,z = 35.5648193359375, h = 220.64},
-- 			{x = -104.29450225830078,y = -603.3757934570313,z = 35.5648193359375, h = 220.64}
-- 		}
-- 	},
-- } 



Config.drugs = {
    CATEGORY_LOW = {
        ['cigarett_pack'] = {
            reward = { min = 100, max = 150 },
            reputation = 2
        },

        ['cigarello_pack'] = {
            reward = { min = 150, max = 200 },
            reputation = 4
        },

        ['snus_pack'] = {
            reward = { min = 200, max = 250 },
            reputation = 6
        },

        ['weed_pooch'] = {
            reward = { min = 400, max = 500 },
            reputation = 12
        },

        ['oxy'] = {
            reward = { min = 400, max = 500 },
            reputation = 15
        },
    },

    CATEGORY_MED = {
        ['cigarett_pack'] = {
            reward = { min = 100, max = 150 },
            reputation = 2
        },

        ['cigarello_pack'] = {
            reward = { min = 150, max = 200 },
            reputation = 4
        },

        ['snus_pack'] = {
            reward = { min = 200, max = 250 },
            reputation = 6
        },

        ['weed_pooch'] = {
            reward = { min = 400, max = 500 },
            reputation = 12
        },

        ['oxy'] = {
            reward = { min = 400, max = 500 },
            reputation = 15
        },

--[[        ['weed_joint'] = {
            reward = { min = 40, max = 50 },
            reputation = 10
        },]]

        ['hash'] = {
            reward = { min = 20, max = 40 },
            reputation = 20
        },
    },

    CATEGORY_HIGH = {
        ['cigarett_pack'] = {
            reward = { min = 100, max = 150 },
            reputation = 2
        },

        ['cigarello_pack'] = {
            reward = { min = 150, max = 200 },
            reputation = 4
        },

        ['snus_pack'] = {
            reward = { min = 200, max = 250 },
            reputation = 6
        },

        ['weed_pooch'] = {
            reward = { min = 400, max = 500 },
            reputation = 12
        },

        ['oxy'] = {
            reward = { min = 400, max = 500 },
            reputation = 15
        },

        ['heroin_pooch'] = {
            reward = { min = 20, max = 40 },
            reputation = 30
        },

        ['coke_pooch'] = {
            reward = { min = 800, max = 1200 },
            reputation = 18
        },

        ['amphetamine_pooch'] = {
            reward = { min = 20, max = 40 },
            reputation = 50
        },

        ['lsd'] = {
            reward = { min = 20, max = 40 },
            reputation = 60
        }
    }
}


Config.pedList = {
    'a_f_m_bevhills_01',
    'a_f_m_bevhills_02',
    'a_f_m_business_02',
    'a_f_m_downtown_01',
    'a_f_m_eastsa_01',
    'a_f_m_eastsa_02',
    'a_f_m_fatbla_01',
    'a_f_m_fatwhite_01',
    'a_f_m_ktown_01',
    'a_f_m_ktown_02',
    'a_f_m_prolhost_01',
    'a_f_m_salton_01',
    'a_f_m_skidrow_01',
    'a_f_m_soucent_01',
    'a_f_m_soucent_02',
    'a_f_m_soucentmc_01',
    'a_f_m_tourist_01',
    'a_f_m_tramp_01',
    'a_f_m_trampbeac_01',
    'a_f_o_genstreet_01',
    'a_f_o_indian_01',
    'a_f_o_ktown_01',
    'a_f_o_salton_01',
    'a_f_o_soucent_01',
    'a_f_o_soucent_02',
    'a_f_y_beach_01',
    'a_f_y_bevhills_01',
    'a_f_y_bevhills_02',
    'a_f_y_bevhills_03',
    'a_f_y_bevhills_03',
    'a_f_y_business_01',
    'a_f_y_business_02',
    'a_f_y_business_03',
    'a_f_y_business_04',
    'a_f_y_clubcust_01',
    'a_f_y_clubcust_02',
    'a_f_y_clubcust_03',
    'a_f_y_eastsa_01',
    'a_f_y_eastsa_02',
    'a_f_y_eastsa_03',
    'a_f_y_epsilon_01',
    'a_f_y_femaleagent',
    'a_f_y_fitness_01',
    'a_f_y_fitness_02',
    'a_f_y_genhot_01',
    'a_f_y_golfer_01',
    'a_f_y_hiker_01',
    'a_f_y_hippie_01',
    'a_f_y_hipster_01',
    'a_f_y_hipster_02',
    'a_f_y_hipster_03',
    'a_f_y_hipster_04',
    'a_f_y_indian_01',
    'a_f_y_juggalo_01',
    'a_f_y_runner_01',
    'a_f_y_rurmeth_01',
    'a_f_y_scdressy_01',
    'a_f_y_skater_01',
    'a_f_y_soucent_01',
    'a_f_y_soucent_02',
    'a_f_y_soucent_03',
    'a_f_y_tennis_01',
    'a_f_y_tourist_01',
    'a_f_y_tourist_02',
    'a_f_y_vinewood_01',
    'a_f_y_vinewood_02',
    'a_f_y_vinewood_03',
    'a_f_y_vinewood_04',
    'a_f_y_yoga_01',
    'a_f_y_gencaspat_01',
    'a_f_y_smartcaspat_01',
	'a_m_m_afriamer_01',
    'a_m_m_beach_01',
    'a_m_m_beach_02',
    'a_m_m_bevhills_01',
	'a_m_y_breakdance_01',
	'a_m_y_busicas_01',
	'a_m_y_business_01',
	'a_m_y_business_02',
	'a_m_y_business_03',
	'a_m_y_clubcust_01',
	'a_m_y_clubcust_02',
	'a_m_y_clubcust_03',
	'a_m_y_cyclist_01',
	'a_m_y_dhill_01',
	'a_m_y_downtown_01',
	'a_m_y_eastsa_01',
	'a_m_y_eastsa_02',
	'a_m_y_epsilon_01',
	'a_m_y_epsilon_02',
	'a_m_y_gay_01',
	'a_m_y_gay_02',
	'a_m_y_genstreet_01',
	'a_m_y_genstreet_02',
	'a_m_y_golfer_01',
	'a_m_y_hasjew_01',
	'a_m_y_hiker_01',
	'a_m_y_hippy_01',
	'a_m_y_hipster_01',
	'a_m_y_hipster_02',
	'a_m_y_hipster_03',
	'a_m_y_indian_01',
	'a_m_y_jetski_01',
	'a_m_y_juggalo_01',
	'a_m_y_ktown_01',
	'a_m_y_ktown_02',
	'a_m_y_latino_01',
	'a_m_y_methhead_01',
	'a_m_y_mexthug_01',
	'a_m_y_motox_01',
	'a_m_y_motox_02',
	'a_m_y_musclbeac_01',
	'a_m_y_musclbeac_02',
	'a_m_y_polynesian_01',
	'a_m_y_roadcyc_01',
	'a_m_y_runner_01',
	'a_m_y_runner_02',
	'a_m_y_salton_01',
	'a_m_y_skater_01',
	'a_m_y_skater_02',
	'a_m_y_soucent_01',
	'a_m_y_soucent_02',
	'a_m_y_soucent_03',
	'a_m_y_soucent_04',
	'a_m_y_stbla_01',
	'a_m_y_stbla_02',
	'a_m_y_stlat_01',
	'a_m_y_stwhi_01',
	'a_m_y_stwhi_02',
	'a_m_y_sunbathe_01',
	'a_m_y_surfer_01',
	'a_m_y_vindouche_01',
	'a_m_y_vinewood_01',
	'a_m_y_vinewood_02',
	'a_m_y_vinewood_03',
	'a_m_y_vinewood_04',
	'a_m_y_yoga_01',
	'a_m_m_mlcrisis_01',
	'a_m_y_gencaspat_01',
	'a_m_y_smartcaspat_01',
}


Config.gangZones = {}

-- All gang zones, you can add more
--[[
    Let's explain the format for each zone:
        name - short name for the zone used in database and server cache
        label - actual full name of the zone
        neighbors - zones that have borders with this zone
        zoneParts - list of border points in the world coordinates
        drugPreference - price multipliers for each drug category
]]
Config.gangZones['ROCKF'] = {
    name = 'ROCKF',
    label = 'Rockford Hills',
    neighbors = {
        'MORN',
        'WVINE',
        'MOVIE',
        'KOREAT',
        'BURTON'
    },
    zoneParts = {
        { x1 = -1379.12, y1 = -257.26, x2 = -1299.88, y2 = -38.12 },
        { x1 = -920.61, y1 = -465.30, x2 = -521.31, y2 = -407.48 },
        { x1 = -1299.5, y1 = -407.3, x2 = -550.21, y2 = -126.82 },
        { x1 = -1299.55, y1 = -126.82, x2 = -743.39, y2 = 445.02 },
        { x1 = -743.39, y1 = -126.82, x2 = -594.91, y2 = 13.48 },
    },
    drugPreference = {
        CATEGORY_LOW = 1.0,
        CATEGORY_MED = 0.5,
        CATEGORY_HIGH = 1.3
    }
}
Config.gangZones['MORN'] = {
    name = 'MORN',
    label = 'Morningwood',
    neighbors = {
        'ROCKF',
        'MOVIE'
    },
    zoneParts = {
        { x1 = -1635.47, y1 = -500.0, x2 = -1379.12, y2 = -107.29 },
        { x1 = -1379.12, y1 = -511.5, x2 = -1299.88, y2 = -257.26 },
    },
    drugPreference = {
        CATEGORY_LOW = 1.0,
        CATEGORY_MED = 0.5,
        CATEGORY_HIGH = 1.0
    }
}
Config.gangZones['MOVIE'] = {
    name = 'MOVIE',
    label = 'Richards Majestic',
    neighbors = {
        'MORN',
        'KOREAT',
        'ROCKF',
        'VCANA'
    },
    zoneParts = {
        { x1 = -1380.23, y1 = -849.50, x2 = -1172.24, y2 = -511.48 },
        { x1 = -1172.24, y1 = -576.61, x2 = -1072.88, y2 = -543.51 },
        { x1 = -1172.24, y1 = -722.8, x2 = -1127.62, y2 = -576.61 },
        { x1 = -1172.24, y1 = -543.51, x2 = -998.41, y2 = -511.48 },
        { x1 = -1299.88, y1 = -511.48, x2 = -920.5, y2 = -407.23 },
    },
    drugPreference = {
        CATEGORY_LOW = 0.3,
        CATEGORY_MED = 0.3,
        CATEGORY_HIGH = 1.0
    }
}
Config.gangZones['KOREAT'] = {
    name = 'KOREAT',
    label = 'Little Seoul',
    neighbors = {
        'ROCKF',
        'VCANA',
        'MOVIE',
        'STRAW',
        'PBOX'
    },
    zoneParts = {
        { x1 = -1127.62, y1 = -723.01, x2 = -1072.88, y2 = -576.61 },
        { x1 = -1072.88, y1 = -723.01, x2 = -998.41, y2 = -543.51 },
        { x1 = -931.96, y1 = -849.49, x2 = -774.41, y2 = -723.01 },
        { x1 = -865.98, y1 = -907.78, x2 = -774.41, y2 = -849.49 },
        { x1 = -812.41, y1 = -1019.71, x2 = -774.41, y2 = -907.78 },
        { x1 = -998.41, y1 = -723.01, x2 = -403.51, y2 = -511.48 },
        { x1 = -920.61, y1 = -511.48, x2 = -521.31, y2 = -465.30 },
        { x1 = -573.84, y1 = -1425.40, x2 = -403.51, y2 = -1158.02 },
        { x1 = -774.41, y1 = -1158.02, x2 = -354.71, y2 = -723.01 },
    },
    drugPreference = {
        CATEGORY_LOW = 1.0,
        CATEGORY_MED = 1.0,
        CATEGORY_HIGH = 0.5
    }
}
Config.gangZones['MIRR'] = {
    name = 'MIRR',
    label = 'Mirror Park',
    neighbors = {
        'EAST_V',
        'LMESA'
    },
    zoneParts = {
        { x1 = 869.70, y1 = -820.90, x2 = 1391.07, y2 = -282.32 },
    },
    drugPreference = {
        CATEGORY_LOW = 1.0,
        CATEGORY_MED = 0.15,
        CATEGORY_HIGH = 0.05
    }
}
Config.gangZones['LMESA'] = {
    name = 'LMESA',
    label = 'La Mesa',
    neighbors = {
        'MIRR',
        'TEXTI',
        'SKID',
        'RANCHO',
        'CYPRE',
        'EBURO'
    },
    zoneParts = {
        { x1 = 921.45, y1 = -1901.45, x2 = 1118.89, y2 = -1708.33 },
        { x1 = 505.03, y1 = -1158.02, x2 = 934.14, y2 = -1006.57 },
        { x1 = 618.7, y1 = -1708.33, x2 = 1118.89, y2 = -1158.02 },
        { x1 = 505.03, y1 = -1006.57, x2 = 888.46, y2 = -820.90 },
        { x1 = 505.03, y1 = -820.90, x2 = 869.70, y2 = -510.0 },
    },
    drugPreference = {
        CATEGORY_LOW = 0.5,
        CATEGORY_MED = 0.5,
        CATEGORY_HIGH = 0.2
    }
}
Config.gangZones['STRAW'] = {
    name = 'STRAW',
    label = 'Strawberry',
    neighbors = {
        'KOREAT',
        'PBOX',
        'SKID',
        'RANCHO',
        'DAVIS',
        'CHAMH'
    },
    zoneParts = {
        { x1 = -63.92, y1 = -1700.53, x2 = 91.27, y2 = -1425.40 },
        { x1 = -403.51, y1 = -1425.40, x2 = 359.48, y2 = -1158.02 },
    },
    drugPreference = {
        CATEGORY_LOW = 0.7,
        CATEGORY_MED = 1.0,
        CATEGORY_HIGH = 0.3
    }
}
Config.gangZones['RANCHO'] = {
    name = 'RANCHO',
    label = 'Rancho',
    neighbors = {
        'STRAW',
        'CYPRE',
        'SKID',
        'LMESA',
        'DAVIS'
    },
    zoneParts = {
        { x1 = 359.48, y1 = -1761.99, x2 = 618.43, y2 = -1158.02 },
        { x1 = 271.51, y1 = -1761.99, x2 = 359.48, y2 = -1613.16 },
        { x1 = 222.40, y1 = -2022.57, x2 = 505.03, y2 = -1761.99 },
        { x1 = 123.73, y1 = -2168.95, x2 = 505.03, y2 = -2022.57 },
    },
    drugPreference = {
        CATEGORY_LOW = 0.8,
        CATEGORY_MED = 0.9,
        CATEGORY_HIGH = 0.25
    }
}
Config.gangZones['CHAMH'] = {
    name = 'CHAMH',
    label = 'Chamberlain Hills',
    neighbors = {
        'STRAW',
        'DAVIS'
    },
    zoneParts = {
        { x1 = -283.92, y1 = -1761.99, x2 = -63.92, y2 = -1425.40 },
    },
    drugPreference = {
        CATEGORY_LOW = 0.9,
        CATEGORY_MED = 1.2,
        CATEGORY_HIGH = 0.2
    }
}
Config.gangZones['DAVIS'] = {
    name = 'DAVIS',
    label = 'Davis Quartz',
    neighbors = {
        'STRAW',
        'RANCHO',
        'CHAHM'
    },
    zoneParts = {
        { x1 = -63.92, y1 = -1761.99, x2 = 271.51, y2 = -1700.53 },
        { x1 = 91.27, y1 = -1700.53, x2 = 271.51, y2 = -1613.16 },
        { x1 = 91.27, y1 = -1613.16, x2 = 359.48, y2 = -1425.40 },
        { x1 = -139.74, y1 = -2022.57, x2 = -9.70, y2 = -1761.99 },
        { x1 = -9.70, y1 = -2022.57, x2 = 115.40, y2 = -1761.99 },
        { x1 = 115.40, y1 = -2022.57, x2 = 222.40, y2 = -1761.99 },
    },
    drugPreference = {
        CATEGORY_LOW = 0.8,
        CATEGORY_MED = 1.0,
        CATEGORY_HIGH = 0.4
    }
}
Config.gangZones['PBOX'] = {
    name = 'PBOX',
    label = 'Pillbox Hill',
    neighbors = {
        'TEXTI',
        'SKID',
        'KOREAT',
        'STRAW'
    },
    zoneParts = {
        { x1 = -276.21, y1 = -722.91, x2 = 285.43, y2 = -573.01 },
        { x1 = -354.71, y1 = -1158.02, x2 = 119.43, y2 = -722.91 },
        { x1 = 199.43, y1 = -877.91, x2 = 285.43, y2 = -722.91 },
        { x1 = 119.43, y1 = -1158.02, x2 = 199.43, y2 = -722.91 },
    },
    drugPreference = {
        CATEGORY_LOW = 0.8,
        CATEGORY_MED = 0.8,
        CATEGORY_HIGH = 1.1
    }
}
--[[Config.gangZones['TEXTI'] = {
    name = 'TEXTI',
    label = 'Textile City',
    neighbors = {
        'LMESA',
        'PBOX',
        'SKID'
    },
    zoneParts = {
        { x1 = 285.43, y1 = -877.91, x2 = 505.03, y2 = -510.0 },
    },
    drugPreference = {
        CATEGORY_LOW = 0.9,
        CATEGORY_MED = 0.7,
        CATEGORY_HIGH = 0.5
    }
}
Config.gangZones['SKID'] = {
    name = 'SKID',
    label = 'Mission Row',
    neighbors = {
        'LMESA',
        'PBOX',
        'TEXTI',
        'RANCHO',
        'STRAW'
    },
    zoneParts = {
        { x1 = 199.43, y1 = -1158.02, x2 = 505.03, y2 = -877.91 },
    },
    drugPreference = {
        CATEGORY_LOW = 1.2,
        CATEGORY_MED = 1.2,
        CATEGORY_HIGH = 1.2
    }
}]]
Config.gangZones['DTVINE'] = {
    name = 'DTVINE',
    label = 'Downtown Vinewood',
    neighbors = {
        'WVINE',
        'HAWICK',
        'ALTA',
        'EAST_V'
    },
    zoneParts = {
        { x1 = 48.53, y1 = -20.78, x2 = 695.87, y2 = 445.02 },
    },
    drugPreference = {
        CATEGORY_LOW = 1.0,
        CATEGORY_MED = 0.85,
        CATEGORY_HIGH = 1.2
    }
}
Config.gangZones['WVINE'] = {
    name = 'WVINE',
    label = 'West Vinewood',
    neighbors = {
        'BURTON',
        'ROCKF',
        'DTVINE',
        'HAWICK'
    },
    zoneParts = {
        { x1 = -743.39, y1 = 13.47, x2 = 48.53, y2 = 445.02 },
        { x1 = -246.39, y1 = -20.78, x2 = 48.53, y2 = 13.48 },
    },
    drugPreference = {
        CATEGORY_LOW = 0.85,
        CATEGORY_MED = 1.0,
        CATEGORY_HIGH = 1.2
    }
}
Config.gangZones['BURTON'] = {
    name = 'BURTON',
    label = 'Burton',
    neighbors = {
        'WVINE',
        'HAWICK',
        'ALTA',
        'ROCKF'
    },
    zoneParts = {
        { x1 = -594.91, y1 = -126.82, x2 = -246.39, y2 = 13.48 },
        { x1 = -550.21, y1 = -310.80, x2 = -246.39, y2 = -126.82 },
        { x1 = -246.39, y1 = -378.61, x2 = -90.0, y2 = -20.78 },
        { x1 = -246.39, y1 = -452.98, x2 = -90.0, y2 = -378.61 },
    },
    drugPreference = {
        CATEGORY_LOW = 0.8,
        CATEGORY_MED = 0.8,
        CATEGORY_HIGH = 0.7
    }
}
Config.gangZones['VCANA'] = {
    name = 'VCANA',
    label = 'Vespucci Canals',
    neighbors = {
        'MORN',
        'MOVIE',
        'KOREAT',
        'VESP'
    },
    zoneParts = {
        { x1 = -1319.77, y1 = -1074.78, x2 = -1095.41, y2 = -960.49 },
        { x1 = -1272.77, y1 = -960.49, x2 = -1095.41, y2 = -849.49 },
        { x1 = -1250.79, y1 = -1174.30, x2 = -1095.41, y2 = -1074.78 },
        { x1 = -1249.24, y1 = -1237.30, x2 = -1095.41, y2 = -1174.30 },
        { x1 = -1232.34, y1 = -1287.02, x2 = -1095.41, y2 = -1237.30 },
        { x1 = -1202.04, y1 = -1389.87, x2 = -1095.41, y2 = -1287.02 },
        { x1 = -1182.04, y1 = -1450.40, x2 = -1095.41, y2 = -1389.87 },
        { x1 = -1095.41, y1 = -1214.40, x2 = -774.41, y2 = -1019.71 },
        { x1 = -1095.41, y1 = -1019.71, x2 = -812.41, y2 = -907.78 },
        { x1 = -1095.41, y1 = -907.78, x2 = -865.98, y2 = -849.49 },
        { x1 = -1172.0, y1 = -849.49, x2 = -931.96, y2 = -723.01 },
    },
    drugPreference = {
        CATEGORY_LOW = 1.2,
        CATEGORY_MED = 0.4,
        CATEGORY_HIGH = 0.8
    }
}
Config.gangZones['ALTA'] = {
    name = 'ALTA',
    label = 'Alta',
    neighbors = {
        'BURTON',
        'DTVINE',
        'EAST_V',
        'HAWICK'
    },
    zoneParts = {
        { x1 = -90.0, y1 = -480.90, x2 = 695.99, y2 = -177.0 },
    },
    drugPreference = {
        CATEGORY_LOW = 1.0,
        CATEGORY_MED = 1.0,
        CATEGORY_HIGH = 1.0
    }
}
Config.gangZones['EBURO'] = {
    name = 'EBURO',
    label = 'El Burro Heights',
    neighbors = {
        'LMESA'
    },
    zoneParts = {
        { x1 = 1118.89, y1 = -1901.45, x2 = 1485.92, y2 = -1391.50 },
    },
    drugPreference = {
        CATEGORY_LOW = 0.5,
        CATEGORY_MED = 0.5,
        CATEGORY_HIGH = 0.3
    }
}
Config.gangZones['CYPRE'] = {
    name = 'CYPRE',
    label = 'Cypress Flats',
    neighbors = {
        'RANCHO',
        'LMESA'
    },
    zoneParts = {
        { x1 = 618.7, y1 = -2718.48, x2 = 921.45, y2 = -1708.33 },
        { x1 = 921.45, y1 = -2718.48, x2 = 1048.54, y2 = -1901.45 },
    },
    drugPreference = {
        CATEGORY_LOW = 0.5,
        CATEGORY_MED = 0.5,
        CATEGORY_HIGH = 0.2
    }
}
Config.gangZones['BEACH'] = {
    name = 'BEACH',
    label = 'Vespucci Beach',
    neighbors = {
        'VCANA'
    },
    zoneParts = {
        { x1 = -1450.59, y1 = -1287.02, x2 = -1232.34, y2 = -1237.30 },
        { x1 = -1450.59, y1 = -1237.30, x2 = -1249.24, y2 = -1174.30 },
        { x1 = -1450.59, y1 = -1174.30, x2 = -1250.79, y2 = -1074.78 },
        { x1 = -1450.59, y1 = -1389.87, x2 = -1202.04, y2 = -1287.02 },
        { x1 = -1450.59, y1 = -1600.40, x2 = -1182.04, y2 = -1389.87 },
    },
    drugPreference = {
        CATEGORY_LOW = 1.0,
        CATEGORY_MED = 0.5,
        CATEGORY_HIGH = 0.75
    }
}
Config.gangZones['HAWICK'] = {
    name = 'HAWICK',
    label = 'Hawick',
    neighbors = {
        'EAST_V',
        'ALTA',
        'DTVINE',
        'BURTON',
        'WVINE'
    },
    zoneParts = {
        { x1 = -90.0, y1 = -177.0, x2 = 695.87, y2 = -20.78 },
    },
    drugPreference = {
        CATEGORY_LOW = 1.0,
        CATEGORY_MED = 1.0,
        CATEGORY_HIGH = 0.9
    }
}
Config.gangZones['EAST_V'] = {
    name = 'EAST_V',
    label = 'East Vinewood',
    neighbors = {
        'HAWICK',
        'DTVINE',
        'ALTA'
    },
    zoneParts = {
        { x1 = 696.0, y1 = -282.5, x2 = 1391.0, y2 = -35.97 },
    },
    drugPreference = {
        CATEGORY_LOW = 0.5,
        CATEGORY_MED = 0.5,
        CATEGORY_HIGH = 0.6
    }
}
Config.gangZones['GRAPES'] = {
    name = 'GRAPES',
    label = 'Grapeseed',
    neighbors = {
        'SANDY'
    },
    zoneParts = {
        { x1 = 1605.27, y1 = 4543.62, x2 = 2413.98, y2 = 5269.38 },
        { x1 = 2413.98, y1 = 5138.80, x2 = 2498.52, y2 = 5269.38 },
        { x1 = 2413.98, y1 = 4778.17, x2 = 2561.79, y2 = 5138.80 },
        { x1 = 2413.98, y1 = 4417.53, x2 = 2632.58, y2 = 4778.17 },
        { x1 = 2413.98, y1 = 4036.53, x2 = 2734.72, y2 = 4417.53 },
        { x1 = 1605.27, y1 = 4820.46, x2 = 1648.42, y2 = 4931.77 },
    },
    drugPreference = {
        CATEGORY_LOW = 0.3,
        CATEGORY_MED = 0.3,
        CATEGORY_HIGH = 0.2
    }
}
Config.gangZones['SANDY'] = {
    name = 'SANDY',
    label = 'Sandy Shores',
    neighbors = {
        'GRAPES'
    },
    zoneParts = {
        { x1 = 1295.66, y1 = 3455.35, x2 = 2145.09, y2 = 4012.51 },
        { x1 = 2413.98, y1 = 3554.05, x2 = 2807.76, y2 = 4036.53 },
        { x1 = 2145.09, y1 = 3554.05, x2 = 2413.98, y2 = 3819.50 },
        { x1 = 2145.09, y1 = 3294.46, x2 = 2693.05, y2 = 3554.05 },
        { x1 = 2083.31, y1 = 3925.83, x2 = 2145.09, y2 = 3954.88 },
        { x1 = 2057.38, y1 = 3954.88, x2 = 2145.09, y2 = 4012.50 },
        { x1 = 1990.20, y1 = 3973.64, x2 = 2057.38, y2 = 4012.51 },
        { x1 = 1976.69, y1 = 3981.51, x2 = 1990.20, y2 = 3995.50 },
        { x1 = 1752.23, y1 = 3995.50, x2 = 1990.20, y2 = 4012.50 },
        { x1 = 1691.23, y1 = 3983.57, x2 = 1752.23, y2 = 4012.50 },
        { x1 = 1691.23, y1 = 3967.40, x2 = 1713.04, y2 = 3983.58 },
        { x1 = 1446.97, y1 = 3954.97, x2 = 1691.23, y2 = 4012.50 },
        { x1 = 1446.97, y1 = 3930.21, x2 = 1683.75, y2 = 3954.97 },
        { x1 = 1446.97, y1 = 3888.02, x2 = 1508.13, y2 = 3930.21 },
        { x1 = 1508.13, y1 = 3888.02, x2 = 1540.87, y2 = 3904.46 },
        { x1 = 1532.13, y1 = 3856.76, x2 = 1584.82, y2 = 3888.02 },
        { x1 = 1446.97, y1 = 3819.74, x2 = 1532.13, y2 = 3888.02 },
        { x1 = 1295.66, y1 = 3888.02, x2 = 1446.97, y2 = 4012.51 },
        { x1 = 1295.66, y1 = 3812.33, x2 = 1388.96, y2 = 3888.02 },
        { x1 = 1295.66, y1 = 3741.06, x2 = 1356.98, y2 = 3812.33 },
        { x1 = 1295.66, y1 = 3713.35, x2 = 1325.48, y2 = 3741.06 },
    },
    drugPreference = {
        CATEGORY_LOW = 0.4,
        CATEGORY_MED = 0.4,
        CATEGORY_HIGH = 0.1
    }
}
Config.gangZones['PALETO'] = {
    name = 'PALETO',
    label = 'Paleto Bay',
    neighbors = {},
    zoneParts = {
        { x1 = -333.95, y1 = 6006.86, x2 = -188.97, y2 = 6147.87 },
        { x1 = -282.23, y1 = 6147.87, x2 = -137.25, y2 = 6288.88 },
        { x1 = -137.25, y1 = 6195.79, x2 = 7.74, y2 = 6336.80 },
        { x1 = -59.31, y1 = 6336.80, x2 = 66.28, y2 = 6452.00 },
        { x1 = 66.28, y1 = 6409.34, x2 = 211.26, y2 = 6518.35 },
        { x1 = 110.86, y1 = 6518.35, x2 = 516.84, y2 = 6614.36 },
        { x1 = -680.83, y1 = 6147.87, x2 = -282.23, y2 = 6288.88 },
        { x1 = -598.05, y1 = 6288.88, x2 = -137.25, y2 = 6477.81 },
        { x1 = 66.28, y1 = 6518.35, x2 = 110.86, y2 = 6614.36 },
        { x1 = -357.76, y1 = 6477.81, x2 = 66.28, y2 = 6614.36 },
        { x1 = 10.82, y1 = 6614.36, x2 = 133.50, y2 = 7165.53 },
        { x1 = -188.97, y1 = 6006.86, x2 = -39.51, y2 = 6147.87 },
        { x1 = -137.25, y1 = 6147.87, x2 = -39.51, y2 = 6195.79 },
        { x1 = 7.74, y1 = 6195.79, x2 = 66.28, y2 = 6336.80 },
        { x1 = -137.25, y1 = 6336.80, x2 = -59.31, y2 = 6477.81 },
        { x1 = -59.31, y1 = 6452.00, x2 = 66.28, y2 = 6477.81 },
        { x1 = -481.00, y1 = 6006.37, x2 = -333.95, y2 = 6147.87 },
        { x1 = -112.83, y1 = 6614.36, x2 = 10.82, y2 = 6786.93 },
        { x1 = -202.03, y1 = 6614.36, x2 = -112.83, y2 = 6703.23 },
        { x1 = -164.47, y1 = 6703.23, x2 = -112.83, y2 = 6744.03 },
        { x1 = 133.50, y1 = 6614.36, x2 = 465.00, y2 = 6785.33 },
        { x1 = 133.50, y1 = 6785.33, x2 = 387.30, y2 = 6900.54 },
        { x1 = 133.50, y1 = 6900.54, x2 = 284.08, y2 = 6996.90 },
        { x1 = 133.50, y1 = 6996.90, x2 = 224.78, y2 = 7065.80 },
        { x1 = 465.00, y1 = 6705.98, x2 = 617.57, y2 = 6745.77 },
        { x1 = 387.30, y1 = 6785.33, x2 = 473.72, y2 = 6840.19 },
        { x1 = 284.08, y1 = 6900.54, x2 = 386.59, y2 = 6949.75 },
        { x1 = 133.50, y1 = 7065.80, x2 = 193.80, y2 = 7165.53 },
        { x1 = 224.78, y1 = 6996.90, x2 = 277.79, y2 = 7065.80 },
        { x1 = 284.08, y1 = 6949.75, x2 = 332.08, y2 = 6996.90 },
        { x1 = 387.30, y1 = 6840.19, x2 = 430.30, y2 = 6900.54 },
        { x1 = 465.00, y1 = 6745.77, x2 = 541.00, y2 = 6785.33 },
        { x1 = 465.00, y1 = 6614.36, x2 = 617.57, y2 = 6705.98 },
        { x1 = -43.31, y1 = 6882.58, x2 = 10.82, y2 = 7165.53 },
        { x1 = -103.31, y1 = 6786.93, x2 = 10.82, y2 = 6882.58 },
        { x1 = -234.25, y1 = 6006.86, x2 = -188.97, y2 = 6046.44 },
        { x1 = -61.55, y1 = 6006.86, x2 = -39.51, y2 = 6025.03 },
        { x1 = -165.24, y1 = 6006.86, x2 = -149.20, y2 = 6021.46 },
        { x1 = -58.57, y1 = 6115.46, x2 = -39.51, y2 = 6147.87 },
        { x1 = -117.17, y1 = 6056.50, x2 = -39.51, y2 = 6115.46 },
        { x1 = -108.56, y1 = 6006.86, x2 = -88.03, y2 = 6017.70 },
        { x1 = -128.49, y1 = 6020.11, x2 = -93.62, y2 = 6045.88 },
    },
    drugPreference = {
        CATEGORY_LOW = 0.2,
        CATEGORY_MED = 0.2,
        CATEGORY_HIGH = 0.1
    }
}

-- This does not need to be edited as it's complete
Config.zoneNames = {
    ['AIRP'] = 'Los Santos International Airport',
    ['ALAMO'] = 'Alamo Sea',
    ['ALTA'] = 'Alta',
    ['ARMYB'] = 'Fort Zancudo',
    ['BANHAMC'] = 'Banham Canyon Dr',
    ['BANNING'] = 'Banning',
    ['BEACH'] = 'Vespucci Beach',
    ['BHAMCA'] = 'Banham Canyon',
    ['BRADP'] = 'Braddock Pass',
    ['BRADT'] = 'Braddock Tunnel',
    ['BURTON'] = 'Burton',
    ['CALAFB'] = 'Calafia Bridge',
    ['CANNY'] = 'Raton Canyon',
    ['CCREAK'] = 'Cassidy Creek',
    ['CHAMH'] = 'Chamberlain Hills',
    ['CHIL'] = 'Vinewood Hills',
    ['CHU'] = 'Chumash',
    ['CMSW'] = 'Chiliad Mountain State Wilderness',
    ['CYPRE'] = 'Cypress Flats',
    ['DAVIS'] = 'Davis',
    ['DELBE'] = 'Del Perro Beach',
    ['DELPE'] = 'Del Perro',
    ['DELSOL'] = 'La Puerta',
    ['DESRT'] = 'Grand Senora Desert',
    ['DOWNT'] = 'Downtown',
    ['DTVINE'] = 'Downtown Vinewood',
    ['EAST_V'] = 'East Vinewood',
    ['EBURO'] = 'El Burro Heights',
    ['ELGORL'] = 'El Gordo Lighthouse',
    ['ELYSIAN'] = 'Elysian Island',
    ['GALFISH'] = 'Galilee',
    ['GOLF'] = 'GWC and Golfing Society',
    ['GRAPES'] = 'Grapeseed',
    ['GREATC'] = 'Great Chaparral',
    ['HARMO'] = 'Harmony',
    ['HAWICK'] = 'Hawick',
    ['HORS'] = 'Vinewood Racetrack',
    ['HUMLAB'] = 'Humane Labs and Research',
    ['JAIL'] = 'Bolingbroke Penitentiary',
    ['KOREAT'] = 'Little Seoul',
    ['LACT'] = 'Land Act Reservoir',
    ['LAGO'] = 'Lago Zancudo',
    ['LDAM'] = 'Land Act Dam',
    ['LEGSQU'] = 'Legion Square',
    ['LMESA'] = 'La Mesa',
    ['LOSPUER'] = 'La Puerta',
    ['MIRR'] = 'Mirror Park',
    ['MORN'] = 'Morningwood',
    ['MOVIE'] = 'Richards Majestic',
    ['MTCHIL'] = 'Mount Chiliad',
    ['MTGORDO'] = 'Mount Gordo',
    ['MTJOSE'] = 'Mount Josiah',
    ['MURRI'] = 'Murrieta Heights',
    ['NCHU'] = 'North Chumash',
    ['NOOSE'] = 'N.O.O.S.E',
    ['OCEANA'] = 'Pacific Ocean',
    ['PALCOV'] = 'Paleto Cove',
    ['PALETO'] = 'Paleto Bay',
    ['PALFOR'] = 'Paleto Forest',
    ['PALHIGH'] = 'Palomino Highlands',
    ['PALMPOW'] = 'Palmer-Taylor Power Station',
    ['PBLUFF'] = 'Pacific Bluffs',
    ['PBOX'] = 'Pillbox Hill',
    ['PROCOB'] = 'Procopio Beach',
    ['RANCHO'] = 'Rancho',
    ['RGLEN'] = 'Richman Glen',
    ['RICHM'] = 'Richman',
    ['ROCKF'] = 'Rockford Hills',
    ['RTRAK'] = 'Redwood Lights Track',
    ['SANAND'] = 'San Andreas',
    ['SANCHIA'] = 'San Chianski Mountain Range',
    ['SANDY'] = 'Sandy Shores',
    ['SKID'] = 'Mission Row',
    ['SLAB'] = 'Stab City',
    ['STAD'] = 'Maze Bank Arena',
    ['STRAW'] = 'Strawberry',
    ['TATAMO'] = 'Tataviam Mountains',
    ['TERMINA'] = 'Terminal',
    ['TEXTI'] = 'Textile City',
    ['TONGVAH'] = 'Tongva Hills',
    ['TONGVAV'] = 'Tongva Valley',
    ['VCANA'] = 'Vespucci Canals',
    ['VESP'] = 'Vespucci',
    ['VINE'] = 'Vinewood',
    ['WINDF'] = 'Ron Alternates Wind Farm',
    ['WVINE'] = 'West Vinewood',
    ['ZANCUDO'] = 'Zancudo River',
    ['ZP_ORT'] = 'Port of South Los Santos',
    ['ZQ_UAR'] = 'Davis Quartz'
}
