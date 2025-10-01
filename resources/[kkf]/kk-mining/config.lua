cfg = {}
cfg.seller = vector4(1196.9982, -3253.4009, 7.0952, 85.4344)

cfg.blip = vector3(2951.3677, 2792.1428, 44.9241)

cfg.skillname = 'mining'

cfg.resettimer = 30 -- Minutes


cfg.smithing = {
    {coords = vector3(1087.4404, -2002.1445, 31.5240), size = vec3(1.5, 1.5, 1.0), rotation = 0},
    {coords = vector3(1111.1377, -2008.7025, 31.0734), size = vec3(1.5, 1.5, 1.0), rotation = 0}
}
    
cfg.locations = {
    {target = {coords = vector3(2972.3000, 2775.0532, 38.5131), size = vec3(1.5, 1.5, 1.0), rotation = 0.0}, health = 100},
    {target = {coords = vector3(2964.4441, 2773.7300, 39.1142), size = vec3(1.5, 1.5, 1.0), rotation = 0.0}, health = 100},
    {target = {coords = vector3(2937.3071, 2771.9019, 38.3840), size = vec3(1.5, 1.5, 1.0), rotation = 0.0}, health = 100},
    {target = {coords = vector3(2952.5637, 2768.3347, 39.0840), size = vec3(1.5, 1.5, 1.0), rotation = 0.0}, health = 100},

    -- {target = {coords = vector3(2938.0034, 2771.4485, 38.9734), size = vec3(1.5, 1.5, 1.0), rotation = 0.0}, health = 100},
    {target = {coords = vector3(2934.4329, 2784.4727, 39.2503), size = vec3(1.5, 1.5, 1.0), rotation = 0.0}, health = 100},
    {target = {coords = vector3(2928.3140, 2788.8542, 39.7230), size = vec3(1.5, 1.5, 1.0), rotation = 0.0}, health = 100},

    {target = {coords = vector3(2925.7065, 2795.1426, 40.7115), size = vec3(1.5, 1.5, 1.0), rotation = 0.0}, health = 100},
    {target = {coords = vector3(2921.0400, 2799.1782, 41.2199), size = vec3(1.5, 1.5, 1.0), rotation = 0.0}, health = 100},
    {target = {coords = vector3(2938.5010, 2813.1733, 42.5850), size = vec3(1.5, 1.5, 1.0), rotation = 0.0}, health = 100},
}
cfg.rewards = {
    {item = 'mug', min = 1, max = 1, reqskill = 1, addskill = 1},
    {item = 'rocks', reqskill = 1, addskill = 1},
    {item = 'coal', reqskill = 1, addskill = 1},


    {item = 'tin_ore', min = 1, max = 1, reqskill = 1, addskill = 1},
    {item = 'copper_ore', min = 1, max = 1, reqskill = 1, addskill = 1},
    {item = 'iron_ore', min = 1, max = 1, reqskill = 1, addskill = 1},
    {item = 'silver_ore',min = 1, max = 1,  reqskill = 1, addskill = 1},
    {item = 'gold_ore', min = 1, max = 1, reqskill = 1, addskill = 1},


    -- {item = 'steel_bar',min = 1, max = 1,  reqskill = 2, addskill = 1},
    -- {item = 'bronze_bar', min = 1, max = 1, reqskill = 4, addskill = 1},
    -- {item = 'iron_bar', min = 1, max = 1, reqskill = 4, addskill = 1},
    -- {item = 'silver_bar',min = 1, max = 1,  reqskill = 3, addskill = 1},
    -- {item = 'gold_bar',min = 1, max = 1,  reqskill = 4, addskill = 1},
        
}


cfg.shop = {
    {item = 'mug', price = math.random(10, 50)},
    {item = 'rocks', price = math.random(10, 50)},
    {item = 'coal', price = math.random(10, 50)},

    {item = 'steel_bar', price = math.random(10, 50)},
    {item = 'bronze_bar', price = math.random(10, 50)},
    {item = 'iron_bar', price = math.random(10, 50)},
    {item = 'silver_bar', price = math.random(10, 50)},
    {item = 'gold_bar', price = math.random(10, 50)},
}
