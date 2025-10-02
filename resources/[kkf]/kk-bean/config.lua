cfg = {}

cfg.position = vec4(-635.5, 236.5, 82.35, 0.0)

cfg.labels = {
    ['duty'] = { 'far fa-clipboard', 'Alusta/Lõpeta tööpäeva' },
    ['clothes'] = { 'fas fa-tshirt', 'Riidekapp' },
    ['plate'] = { 'fa-solid fa-burger', 'Kandik' },
    ['drinks'] = { 'fa-solid fa-droplet', 'Joogiautomaat' },
    ['drinks_new'] = { 'fa-solid fa-droplet', 'Joogiautomaat' },
    ['put_together'] = { 'fa-solid fa-hand', 'Komplekteerimine' },
    ['grill'] = { 'fa-solid fa-hand', 'Grilli' },
    ['chopping'] = { 'fa-solid fa-knife', 'Lõikelaud' }
}

cfg.points = {
    {
        type = 'clothes',

        target = {
            coords = vec3(-634.55, 225.05, 81.85),
            size = vec3(2.7, 0.7, 1.95),
            rotation = 0.0,
        }
    },

    {
        type = 'drinks',

        target = {
            coords = vec3(-635.5, 236.5, 82.35),
            size = vec3(0.7, 0.8, 0.5),
            rotation = 0.0,
        }
    },

    {
        type = 'drinks',

        target = {
            coords = vec3(-627.7, 222.85, 82.25),
            size = vec3(0.7, 0.55, 0.5),
            rotation = 0.0,
        }
    },

    {
        type = 'drinks_new',

        target = {
            coords = vec3(-636.05, 236.6, 82.25),
            size = vec3(0.35, 0.55, 0.45),
            rotation = 0.0,
        }
    },

    {
        type = 'put_together',

        target = {
            coords = vec3(-632.25, 224.55, 82.0),
            size = vec3(0.55, 0.6, 0.15),
            rotation = 0.0,
        }
    },

    {
        type = 'duty',

        target = {
            coords = vec3(-627.75, 225.9, 81.75),
            size = vec3(0.55, 0.6, 0.15),
            rotation = 0.0,
        }
    },

    {
        type = 'plate',

        target = {
            coords = vec3(-634.3, 235.2, 82.15),
            size = vec3(0.45, 0.6, 0.15),
            rotation = 355.25,
        }
    },
}