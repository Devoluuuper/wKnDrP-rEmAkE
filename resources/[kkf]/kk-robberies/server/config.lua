cfg = {}

-- {pos = vec3(0.0, 0.0, 0.0), currentUser = 0, type = 'bomb', done = false, item = 'c4_bank', door = 'v_ilev_bk_vaultdoor'}

cfg.bankLocations = { 
    ['LEGION_BANK'] = {
        pos = vec3(146.91429138184, -1045.8198242188, 29.364135742188),
        radius = 50.0,
        name = 'Leegioni pank',
        policeRequired = 1,
        tasks = {
            {pos = vec3(146.91429138184, -1045.8198242188, 29.364135742188), currentUser = 0, type = 'hack', done = false, item = 'hacking_tablet', door = 'v_ilev_gb_vauldr', heading = 250.994},
            {pos = vec3(151.17362976074, -1046.0571289062, 29.330444335938), currentUser = 0, type = 'drill', done = false, item = 'drill'},
            {pos = vec3(147.13845825195, -1047.7186279297, 29.330444335938), currentUser = 0, type = 'drill', done = false, item = 'drill'},
            {pos = vec3(150.02638244629, -1050.6724853516, 29.330444335938), currentUser = 0, type = 'drill', done = false, item = 'drill'},
            {pos = vec3(149.0901184082, -1048.6549072266, 29.330444335938), currentUser = 0, type = 'collect', done = false, item = false}
        },

        moneyReward = {min = 10000, max = 20000},
        rewards = {
            {name = 'money', min = 6000, max = 7000}
        },

        controller = 0
    },

    ['SANDY_BANK'] = {
        pos = vec3(1176.0263671875, 2712.8176269531, 38.075439453125),
        radius = 50.0,
        name = 'Sandy pank',
        policeRequired = 1,
        tasks = {
            {pos = vec3(1176.0263671875, 2712.8176269531, 38.075439453125), currentUser = 0, type = 'hack', done = false, item = 'hacking_tablet', door = 'v_ilev_gb_vauldr', heading = 90.000},
            {pos = vec3(1172.0307617188, 2711.3405761719, 38.05859375), currentUser = 0, type = 'drill', done = false, item = 'drill'},
            {pos = vec3(1175.0505371094, 2714.0834960938, 38.05859375), currentUser = 0, type = 'drill', done = false, item = 'drill'},
            {pos = vec3(1171.3714599609, 2716.3515625, 38.05859375), currentUser = 0, type = 'drill', done = false, item = 'drill'},
            {pos = vec3(1173.1384277344, 2714.439453125, 38.05859375), currentUser = 0, type = 'collect', done = false, item = false}
        },

        moneyReward = {min = 10000, max = 20000},
        rewards = {
            {name = 'money', min = 6000, max = 7000}
        },

        controller = 0
    }, 

    ['OCEAN_BANK'] = {
        pos = vec3(-2956.6550292969, 481.63516235352, 15.682006835938),
        radius = 50.0,
        name = 'Läänemaantee pank',
        policeRequired = 1,
        tasks = {
            {pos = vec3(-2956.6550292969, 481.63516235352, 15.682006835938), currentUser = 0, type = 'hack', done = false, item = 'hacking_tablet', door = 'hei_prop_heist_sec_door', heading = 357.542},
            {pos = vec3(-2957.9604492188, 485.73626708984, 15.665161132812), currentUser = 0, type = 'drill', done = false, item = 'drill'},
            {pos = vec3(-2955.3098144531, 482.50549316406, 15.665161132812), currentUser = 0, type = 'drill', done = false, item = 'drill'},
            {pos = vec3(-2952.9099121094, 486.21099853516, 15.665161132812), currentUser = 0, type = 'drill', done = false, item = 'drill'},
            {pos = vec3(-2954.8483886719, 484.54943847656, 15.665161132812), currentUser = 0, type = 'collect', done = false, item = false}
        },

        moneyReward = {min = 10000, max = 20000},
        rewards = {
            {name = 'money', min = 6000, max = 7000}
        },

        controller = 0
    }, 

    ['HAWICK_BANK'] = {
        pos = vec3(-353.81536865234, -55.279117584229, 49.02783203125),
        radius = 50.0,
        name = 'Hawick avenue pank',
        policeRequired = 1,
        tasks = {
            {pos = vec3(-353.81536865234, -55.279117584229, 49.02783203125), currentUser = 0, type = 'hack', done = false, item = 'hacking_tablet', door = 'v_ilev_gb_vauldr', heading = 250.860},
            {pos = vec3(-349.50329589844, -55.213184356689, 49.010986328125), currentUser = 0, type = 'drill', done = false, item = 'drill'},
            {pos = vec3(-353.41976928711, -56.742851257324, 49.010986328125), currentUser = 0, type = 'drill', done = false, item = 'drill'},
            {pos = vec3(-350.47912597656, -60.105491638184, 49.010986328125), currentUser = 0, type = 'drill', done = false, item = 'drill'},
            {pos = vec3(-351.63955688477, -57.824172973633, 49.010986328125), currentUser = 0, type = 'collect', done = false, item = false}
        },

        moneyReward = {min = 10000, max = 20000},
        rewards = {
            {name = 'money', min = 6000, max = 7000}
        },

        controller = 0
    },

    ['PINKCAGE_BANK'] = {
        pos = vec3(311.28790283203, -284.46594238281, 54.150146484375),
        radius = 50.0,
        name = 'Pinkcage pank',
        policeRequired = 1,
        tasks = {
            {pos = vec3(311.28790283203, -284.46594238281, 54.150146484375), currentUser = 0, type = 'hack', done = false, item = 'hacking_tablet', door = 'v_ilev_gb_vauldr', heading = 249.866},
            {pos = vec3(315.66595458984, -284.32086181641, 54.13330078125), currentUser = 0, type = 'drill', done = false, item = 'drill'},
            {pos = vec3(311.57803344727, -285.87692260742, 54.13330078125), currentUser = 0, type = 'drill', done = false, item = 'drill'},
            {pos = vec3(314.25494384766, -289.23956298828, 54.13330078125), currentUser = 0, type = 'drill', done = false, item = 'drill'},
            {pos = vec3(313.46374511719, -286.93185424805, 54.13330078125), currentUser = 0, type = 'collect', done = false, item = false}
        },

        moneyReward = {min = 10000, max = 20000},
        rewards = {
            {name = 'money', min = 6000, max = 7000}
        },

        controller = 0
    },

    ['DELPERRO_BANK'] = {
        pos = vec3(-1210.7868652344, -336.56701660156, 37.772216796875),
        radius = 50.0,
        name = 'Del Perro pank',
        policeRequired = 1,
        tasks = {
            {pos = vec3(-1210.7868652344, -336.56701660156, 37.772216796875), currentUser = 0, type = 'hack', done = false, item = 'hacking_tablet', door = 'v_ilev_gb_vauldr', heading = 296.864},
            {pos = vec3(-1207.806640625, -333.29669189453, 37.75537109375), currentUser = 0, type = 'drill', done = false, item = 'drill'},
            {pos = vec3(-1209.5208740234, -337.25274658203, 37.75537109375), currentUser = 0, type = 'drill', done = false, item = 'drill'},
            {pos = vec3(-1205.0505371094, -337.49011230469, 37.75537109375), currentUser = 0, type = 'drill', done = false, item = 'drill'},
            {pos = vec3(-1207.4901123047, -336.67251586914, 37.75537109375), currentUser = 0, type = 'collect', done = false, item = false}
        },

        moneyReward = {min = 10000, max = 20000},
        rewards = {
            {name = 'money', min = 6000, max = 7000}
        },

        controller = 0
    }
} 