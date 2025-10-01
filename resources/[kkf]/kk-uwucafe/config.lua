cfg = {}

cfg.position = vec4(-586.25, -1049.9, 22.45, 0.00)

cfg.labels = {
    ['duty'] = { 'far fa-clipboard', 'Alusta/Lõpeta tööpäeva' },
    ['clothes'] = { 'fas fa-tshirt', 'Riidekapp' },
    ['plate'] = { 'fa-solid fa-burger', 'Kandik' },
    ['drinks'] = { 'fa-solid fa-droplet', 'Joogiautomaat' },
    ['put_together'] = { 'fa-solid fa-hand', 'Komplekteerimine' },
    ['grill'] = { 'fa-solid fa-hand', 'Grilli' },
    ['chopping'] = { 'fa-solid fa-knife', 'Lõikelaud' }
}

cfg.points = {
    {
        type = 'clothes',

        target = {
            coords = vec3(-586.25, -1049.9, 22.45),
            size = vec3(0.1, 2.3, 2.25),
            rotation = 0.0,
        }
    },

    {
        type = 'drinks',

        target = {
            coords = vec3(-586.85, -1061.9, 22.55),
            size = vec3(0.6, 0.8, 0.6),
            rotation = 0.0,
        }
    },

    {
        type = 'put_together',

        target = {
            coords = vec3(-591.05, -1056.5, 22.05),
            size = vec3(0.7, 2.7, 1.35),
            rotation = 0.0,
        }
    },

    {
        type = 'chopping',

        target = {
            coords = vec3(-591.0, -1063.2, 21.95),
            size = vec3(0.65, 2.6, 1.25),
            rotation = 0.0,
        }
    },

    {
        type = 'grill',

        target = {
            coords = vec3(-590.9, -1059.8, 22.7),
            size = vec3(0.8, 1.3, 1.4),
            rotation = 0.0,
        }
    },

    {
        type = 'duty',

        target = {
            coords = vec3(-596.15, -1052.4, 22.5),
            size = vec3(0.6, 0.35, 0.65),
            rotation = 0.0,
        }
    },

    {
        type = 'plate',

        target = {
            coords = vec3(-584.05, -1062.05, 22.5),
            size = vec3(0.55, 0.75, 0.3),
            rotation = 0.0,
        }
    },

    {
        type = 'plate',

        target = {
            coords = vec3(-584.0, -1059.3, 22.5),
            size = vec3(0.6, 0.75, 0.3),
            rotation = 0.0,
        }
    },

    {
        type = 'plate', -- eventure

        target = {
            coords = vec3(4910.25, -4929.75, 3.25),
            size = vec3(0.55, 0.45, 0.2),
            rotation = 336.0,
        }
    },

    {
        type = 'plate', -- eventure

        target = {
            coords = vec3(4901.1, -4923.5, 3.0),
            size = vec3(0.55, 0.55, 0.45000000000001),
            rotation = 6.5,
        }
    },

    {
        type = 'plate', -- eventure

        target = {
            coords = vec3(4888.1, -4934.2, 3.0),
            size = vec3(0.55, 0.55, 0.5),
            rotation = 0.0,
        }
    },

    {
        type = 'plate', -- eventure

        target = {

            coords = vec3(4885.25, -4925.9, 3.0),
            size = vec3(0.55, 0.6, 0.5),
            rotation = 28.0,
        }
    },

    {
        type = 'plate', -- eventure

        target = {

            coords = vec3(4884.0, -4915.75, 3.0),
            size = vec3(0.5, 0.55, 0.5),
            rotation = 34.0,
        }
    },

    {
        type = 'plate', -- eventure

        target = {
            coords = vec3(4901.95, -4942.65, 3.3),
            size = vec3(0.55, 0.6, 0.55),
            rotation = 41.5,
        }
    },

    {
        type = 'plate', -- eventure

        target = {
            coords = vec3(4905.15, -4940.6, 3.45),
            size = vec3(0.5, 0.5, 0.25),
            rotation = 25.0,
        }
    },

    {
        type = 'plate', -- eventure

        target = {
            coords = vec3(4907.35, -4939.7, 3.45),
            size = vec3(0.55, 0.5, 0.25),
            rotation = 15.0,
        }
    },
}