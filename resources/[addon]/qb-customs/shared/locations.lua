--[[
    ['Innocence'] = {
    settings = {
        label = 'Bennys Motorworks', -- Text label for anything that wants it
        welcomeLabel = "Welcome to Benny's Motorworks!", -- Welcome label in the UI
        enabled = true, -- If the location can be used at all
    },
    blip = {
        label = 'Bennys Motorworks',
        coords = vector3(-205.6992, -1312.7377, 31.1588),
        sprite = 72,
        scale = 0.65,
        color = 0,
        display = 4,
        enabled = true,
    },
    categories = { -- Only include the categories you want. A category not listed defaults to FALSE.
        mods = true, -- Performance Mods
        repair = true,
        armor = true,
        respray = true,
        liveries = true,
        wheels = true,
        tint = true,
        plate = true,
        extras = true,
        neons = true,
        xenons = true,
        horn = true,
        turbo = true,
        cosmetics = true, -- Cosmetic Mods
    },
    drawtextui = {
        text = "Bennys Motorworks",
    },
    restrictions = { -- A person must pass ALL the restriction checks. Remove an item below to automatically pass that check.
        job = "any", -- Allowed job. Can be an array of strings for multiple jobs. Any for all jobs
        allowedClasses = {}, -- Array of allowed classes. Empty will allow any but denied classes.
        deniedClasses = {}, -- Array of denied classes.
    },
    zones = {
        { coords = vector3(-212.55, -1320.56, 31.0), length = 6.0, width = 4.0, heading = 270.0, minZ = 29.88, maxZ = 33.48 },
        { coords = vector3(-222.47, -1329.73, 31.0), length = 6.0, width = 4.4, heading = 270.0, minZ = 29.88, maxZ = 33.48 },
    }
},

Vehicle Classes:
0: Compacts     1: Sedans       2: SUVs         3: Coupes       4: Muscle       5: Sports Classics
6: Sports       7: Super        8: Motorcycles  9: Off-road     10: Industrial  11: Utility
12: Vans        13: Cycles      14: Boats       15: Helicopters 16: Planes      17: Service
18: Emergency   19: Military    20: Commercial  21: Trains
 ]]

Config = Config or {}

Config.Locations = {
    ['Ottos'] = {
        settings = {
            label = "Otto's Motorworks",
            welcomeLabel = "Tere tulemast Otto's Motorworksi!",
            enabled = true,
        },
        categories = {
            mods = false,
            repair = true,
            turbo = false,
            respray = true,
            liveries = true,
            wheels = true,
            tint = true,
            plate = true,
            extras = true,
            neons = true,
            xenons = true,
            horn = true,
            cosmetics = true,
        },
        drawtextui = {
            text = "Otto's Motorworks"
        },
        restrictions = {
            job = { 'ottos' },
            deniedClasses = { 18 },
        },
        zones = {
            { coords = vector3(830.28131103516, -805.54284667969, 25.657104492188), length = 6.0, width = 4.0, heading = 90.0, minZ = 24.0, maxZ = 26.0 },
            { coords = vector3(830.13629150391, -813.33624267578, 25.657104492188), length = 6.0, width = 4.0, heading = 90.0, minZ = 24.0, maxZ = 26.0 },
            { coords = vector3(830.29449462891, -820.24615478516, 25.657104492188), length = 6.0, width = 4.0, heading = 90.0, minZ = 24.0, maxZ = 26.0 },
            { coords = vector3(828.43518066406, -791.24835205078, 26.617553710938), length = 6.0, width = 4.0, heading = 59.52, minZ = 26.0, maxZ = 27.0 }
        }
    },
	
	['driftmotors'] = {
        settings = {
            label = "Drift Motors Motorworks",
            welcomeLabel = "Tere tulemast Drift Motors Motorworksi!",
            enabled = true,
        },
        categories = {
            mods = false,
            repair = true,
            turbo = false,
            respray = true,
            liveries = true,
            wheels = true,
            tint = true,
            plate = true,
            extras = true,
            neons = true,
            xenons = true,
            horn = true,
            cosmetics = true,
        },
        drawtextui = {
            text = "Drift Motors Motorworks"
        },
        restrictions = {
            job = { 'driftmotors' },
            deniedClasses = { 18 },
        },
        zones = {
            { coords = vector3(104.38681030274, 6621.9296875, 31.504028320312), length = 6.0, width = 4.0, heading = 42.0, minZ = 30.0, maxZ = 35.0 },
            { coords = vector3(110.96703338624, 6626.228515625, 31.504028320312), length = 6.0, width = 4.0, heading = 42.0, minZ = 30.0, maxZ = 35.0 },
            { coords = vector3(100.27252960206, 6634.1801757812, 31.1669921875), length = 6.0, width = 4.0, heading = 136.0, minZ = 30.0, maxZ = 35.0 }
        }
    },

    ['MRPD'] = {
        settings = {
            label = 'MRPD Motorworks',
            welcomeLabel = "Tere tulemast MRPD Motorworksi!",
            enabled = true,
        },
        categories = {
            mods = false,
            repair = true,
            respray = true,
            turbo = false,
            liveries = true,
            tint = true,
            extras = true,
            plate = true,
            cosmetics = true,
        },
        drawtextui = {
            text = "MRPD Motorworks",
        },
        restrictions = {
            job = { 'police', 'doj' },
            allowedClasses = { 18 },
        },
        zones = {
            { coords = vector3(450.17, -975.71, 25.7), length = 4.4, width = 9.2, heading = 451.09451293945, minZ = 24.7, maxZ = 28.7 },
            { coords = vector3(438.65933227539, -1026.3297119141, 28.06665039062), length = 4.4, width = 9.2, heading = 2.8346455097198, minZ = 24.7, maxZ = 28.7 }
        }
}
    }