cfg = {}

cfg.license = math.random(1100, 1200)
cfg.licencetime = 7 -- Päeva
cfg.licence_item = 'fishing_id'

cfg.skillname = 'fishing'

cfg.pedModel = `a_f_m_ktown_02`

cfg.fishingPed = vector4(-3275.3760, 964.6833, 8.3472, 359.5213)
-- cfg.fishingPed = {
--     x = -3275.4436,
--     y = 964.5685,
--     z = 8.3472,
--     w = 358.5619
-- }


cfg.shop = {
    fishingrod = {item = 'fishingrod', buy = 200, sell = nil },

    tamil = { item = 'tamil', buy = nil, sell = math.random(1, 5) },
    stick = { item = 'stick', buy = nil, sell = math.random(1, 5) },
    stump = { item = 'stump', buy = nil, sell = math.random(1, 5) },

    fish = { item = 'fish', buy = nil, sell = math.random(10, 50) },
    nori = { item = 'nori', buy = nil, sell = math.random(10, 50) },
    salmon = { item = 'salmon', buy = nil, sell = math.random(120, 140) },
    shrimp = {item = 'shrimp', buy = nil, sell = math.random(20, 30) },
    bass = {item = 'bass', buy = nil, sell = math.random(120, 140) },
    cod = {item = 'cod', buy = nil, sell = math.random(140, 160)  },
    eel = {item = 'eel', buy = nil, sell = math.random(210, 230)  },
    goldfish = {item = 'goldfish', buy = nil, sell = math.random(210, 230) },
    umadfish = {item = 'umadfish', buy = nil, sell = math.random(220, 230) },
    pufferfish = {item = 'pufferfish', buy = nil, sell = math.random(240, 260) },
    turtle = {item = 'turtle', buy = nil, sell = math.random(240, 260) },
    shark = {item = 'shark', buy = nil, sell = math.random(280, 2300) }
}


cfg.fishes = { 
    net ={ min = 1, max = 1, reqskill = 1},
    tamil ={ min = 1, max = 1, reqskill = 1},
    stick ={ min = 1, max = 1, reqskill = 1},
    stump ={ min = 1, max = 1, reqskill = 1},

    
    fish ={ min = 1, max = 2, reqskill = 1},
    bass = { min = 1, max = 1,reqskill = 1},
    

    nori ={ min = 1, max = 1, reqskill = 1},
    salmon = { min = 1, max = 1, reqskill = 1},
    shrimp = {min = 1, max = 1, reqskill = 1},
    cod = {min = 1, max = 1, reqskill = 1},
    eel = {min = 1, max = 1, reqskill = 1},
    goldfish = {min = 1, max = 1, reqskill = 1},
    umadfish = { min = 1, max = 1,reqskill = 1},
    pufferfish = {min = 1, max = 1, reqskill = 1},
    turtle = {min = 1, max = 1, reqskill = 1},
    shark = {min = 1, max = 1, reqskill = 2}
}

cfg.zones = {
    { 
        coords = vector3(-868.4610, 4428.1416, 14.7040),
        points = {
            vec3(-876.30773925781, 4432.9428710938, 0),
            vec3(-867.26019287109, 4411.0600585938, 0),
            vec3(-840.83563232422, 4428.8676757812, 0),
            vec3(-866.35095214844, 4450.6118164062, 0)
        }
    },


    { 
        coords = vector3(-254.7562, 4271.6406, 31.1422),
        points = {
            vec3(-256.65646362305, 4255.9877929688, 0),
            vec3(-257.96911621094, 4293.3823242188, 0),
            vec3(-203.5025177002, 4254.2236328125, 0),
        }
    },

    { 
        coords = vector3(-812.5591, 4439.2798, 16.7699),
        points = {
            vec3(-820.8955078125, 4430.0708007812, 0),
            vec3(-806.85632324219, 4430.2192382812, 0),
            vec3(-791.96459960938, 4459.6918945312, 0),
            vec3(-807.51995849609, 4457.658203125, 0),
        }
    },

    { 
        coords = vector3(-982.1570, 4362.4912, 11.1927),
        points = {
            vec3(-961.83129882812, 4357.3349609375, 0),
            vec3(-1014.8686523438, 4365.939453125, 0),
            vec3(-1012.9666748047, 4372.5708007812, 0),
            vec3(-956.51251220703, 4362.4565429688, 0),
        }
    },

}
