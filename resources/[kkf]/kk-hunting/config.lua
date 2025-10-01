cfg = {}
cfg.weapon = 'WEAPON_SNIPERRIFLE'
cfg.animals = {
    {model = `a_c_deer`, chance = 0},
    {model = `a_c_coyote`, chance = 0},
    {model = `a_c_boar`, chance = 0},
}

cfg.shops = {
    {
        target = {
            coords = vector3(-678.9861, 5834.3799, 17.3313),
            size = vector3(1.5, 1.5, 1.5),
            rotation = 0.0
        },
        items = {
            -- Buy
            hunting_gear = {item = 'hunting_gear', buy = 150, sell = nil},
            huntingbait = {item = 'huntingbait', buy = 25, sell = nil}, 
            
            -- Sell
            deer_meat = {item = 'a_c_deer', buy = nil, sell = 100},
            coyote_meat = {item = 'a_c_coyote', buy = nil, sell = 155},
            boar_meat = {item = 'a_c_boar', buy = nil, sell = 305},
        }
    }
}


cfg.locations = {
    {
        coords = vector3(-446.1848, 5822.7310, 48.9544),
        size = vector3(5.0, 5.0, 5.0),
        rotation = 0.0
    }
}


cfg.modelNames = {
    [-664053099] = 'a_c_deer',
    [-832573324] = 'a_c_coyote',
    [-832573324] = 'a_c_boar'
}
