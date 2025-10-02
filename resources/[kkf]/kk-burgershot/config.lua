cfg = {}

cfg.position = vec4(-1194.8, -905.25, 14.0, 0)

cfg.labels = {
    ['duty'] = { 'far fa-clipboard', 'Alusta/Lõpeta tööpäeva' },
    ['clothes'] = { 'fas fa-tshirt', 'Riidekapp' },
    ['chopping'] = { 'fa-solid fa-knife', 'Lõikelaud' },
    ['put_together'] = { 'fa-solid fa-hand', 'Komplekteerimine' },
    ['plate'] = { 'fa-solid fa-burger', 'Kandik' },
    ['fryer'] = { 'fa-solid fa-hand', 'Fritüür' },
    ['grill'] = { 'fa-solid fa-hand', 'Grilli' },
    ['drinks'] = { 'fa-solid fa-droplet', 'Joogiautomaat' },
    ['ice_cream'] = { 'fa-solid fa-ice-cream', 'Jäätisemasin' }
}

cfg.points = {
    {
        type = 'plate',

        target = {
            coords = vec3(-1191.45, -896.1, 14.0),
            size = vec3(0.55, 1.2, 0.2),
            rotation = 305.0,
        }
    },

    {
        type = 'plate',

        target = {
            coords = vec3(-1189.8, -895.1, 14.0),
            size = vec3(1.0, 0.7, 1),
            rotation = 35.0,
        }
    },

    {
        type = 'plate',

        target = {
            coords = vec3(-1188.3, -894.1, 14.0),
            size = vec3(1, 0.7, 0.6),
            rotation = 34.5,
        }
    },

    {
        type = 'plate',

        target = {
            coords = vec3(-1193.95, -905.45, 13.8),
            size = vec3(0.65, 1.2, 0.45),
            rotation = 350.0,
        }
    },

    {
        type = 'clothes',

        target = {
            coords = vec3(-1180.5, -893.0, 13.75),
            size = vec3(0.5, 3.0, 1.85),
            rotation = 303.0,
        }
    },

    {
        type = 'duty',

        target = {
            coords = vec3(-1177.1, -897.0, 14.0),
            size = vec3(0.4, 0.6, 0.5),
            rotation = 305.0,
        }
    },

    {
        type = 'chopping',

        target = {
            coords = vec3(-1185.25, -902.1, 13.6),
            size = vec3(0.9, 1.85, 1.0),
            rotation = 303.75,
        }
    },

    {
        type = 'put_together',

        target = {
            coords = vec3(-1186.1, -899.45, 13.35),
            size = vec3(1.0, 1.95, 1.15),
            rotation = 33.5,
        }
    },
    
    {
        type = 'fryer',

        target = {
            coords = vec3(-1187.55, -899.55, 13.75),
            size = vec3(1.2, 1.1, 0.55),
            rotation = 33.75,     
        }
    },

    {
        type = 'grill',

        target = {
            coords = vec3(-1186.9, -900.6, 13.3),
            size = vec3(1.4, 0.9, 1.15),
            rotation = 34.5,
        }
    },

    {
        type = 'drinks',

        target = {
            coords = vec3(-1191.6, -897.75, 14.2),
            size = vec3(1.3, 0.45, 0.65),
            rotation = 304.25,
        }
    },

    {
        type = 'drinks',

        target = {
            coords = vec3(-1191.35, -905.35, 14.0),
            size = vec3(1, 1, 1.35),
            rotation = 35.0,
        }
    },

    {
        type = 'ice_cream',

        target = {
            coords = vec3(-1190.95, -898.5, 14.25),
            size = vec3(0.55, 0.7, 1.0),
            rotation = 305.0,
        }
    },

    {
        type = 'ice_cream',

        target = {
            coords = vec3(-1196.55, -904.7, 14.35),
            size = vec3(0.55, 0.6, 0.85),
            rotation = 350.0,
        }
    }
}

cfg.callZones = {
    {
        coords = vec3(-1190.45, -906.0, 14.5),
        size = vec3(20.0, 11.6, 3.9),
        rotation = 33.75,
    }
}