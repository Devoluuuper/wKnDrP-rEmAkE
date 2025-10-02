cfg = {}

cfg.removeFog = true

cfg.vehicleTempEnabled = true
cfg.vehicleCleaningEnabled = true

cfg.hoursPerDay = 2
cfg.secondsPerMinute = (60 / (24 / cfg.hoursPerDay))
cfg.minutesPerDay = cfg.secondsPerMinute * 24
cfg.secondsPerDay = cfg.minutesPerDay * 60

cfg.weathers = {'EXTRASUNNY', 'CLEAR',--[['OVERCAST', 'SMOG', 'FOGGY', 'CLOUDS', 'RAIN', 'THUNDER', --[['SNOW', 'BLIZZARD', 'SNOWLIGHT', 'XMAS', 'HALLOWEEN']]}

cfg.transition = {
    to = '',
    chance = 0,
}

cfg.weatherProgression = {
    weather = '',
    windSpeed = 0,
    windDir = 0,
    rainLevel = 0,
    temperature = 0,
}

cfg.timePerWeather = 20 * 60 -- 20 minutes
cfg.preproducedTransitions = 6 -- preproduce 6 weathers at a time
cfg.overrideTime = 30 -- 30 seconds to transition weather type

cfg.rainLevels = {
    RAIN = 0.25,
    THUNDER = 0.25,
    CLEARING = 0.1,
    HALLOWEEN = 0.5
}

-- These are the MAXIMUM wind speeds, they are math.random()'d on setting up a transition
cfg.windSpeeds = {
    EXTRASUNNY = 0.5,
    CLEAR = 1,
    CLEARING = 4,
    OVERCAST = 5,
    SMOG = 2,
    FOGGY = 4,
    CLOUDS = 5,
    RAIN = 8,
    THUNDER = 12,
    SNOW = 6,
    BLIZZARD = 12,
    SNOWLIGHT = 4,
    XMAS = 6,
    HALLOWEEN = 12
}

-- this is in Fahrenheit, because the game is playing in California, basically
cfg.temperatureRanges = {
    EXTRASUNNY = {90, 110},
    CLEAR = {80, 95},
    CLEARING = {75, 85},
    OVERCAST = {80, 80},
    SMOG = {90, 95},
    FOGGY = {80, 90},
    CLOUDS = {80, 90},
    RAIN = {75, 90},
    THUNDER = {75, 90},
    SNOW = {0, 32},
    BLIZZARD = {-15, 10},
    SNOWLIGHT = {0, 32},
    XMAS = {-5, 15},
    HALLOWEEN = {50, 80}
}

-- this follows a weighting system
-- MAKE SURE THIS IS SORTED FROM LOW TO HIGH
cfg.transitions = {
    ['EXTRASUNNY'] = {
        { to = 'CLEAR', chance = 50 },
        { to = 'OVERCAST', chance = 50 },
    },

    ['CLEAR'] = {
        { to = 'FOGGY', chance = 10 },
        { to = 'CLEAR', chance = 10 },
        { to = 'CLOUDS', chance = 25 },
        { to = 'SMOG', chance = 25 },
        { to = 'EXTRASUNNY', chance = 50 },
    },

    ['CLEARING'] = {
        { to = 'FOGGY', chance = 10 },
        { to = 'CLOUDS', chance = 25 },
        { to = 'SMOG', chance = 25 },
        { to = 'CLEAR', chance = 50 },
        { to = 'EXTRASUNNY', chance = 50 },
    },

    ['OVERCAST'] = {
        { to = 'RAIN', chance = 5 },
        { to = 'THUNDER', chance = 5 },
        { to = 'CLOUDS', chance = 25 },
        { to = 'SMOG', chance = 25 },
        { to = 'FOGGY', chance = 25 },
        { to = 'CLEAR', chance = 50 },
        { to = 'EXTRASUNNY', chance = 50 },
    },

    ['SMOG'] = {
        { to = 'CLEAR', chance = 100 },
    },

    ['FOGGY'] = {
        { to = 'RAIN', chance = 10 },
        { to = 'CLEAR', chance = 100 },
    },

    ['CLOUDS'] = {
        { to = 'RAIN', chance = 10 },
        { to = 'CLEARING', chance = 50 },
        { to = 'OVERCAST', chance = 50 },
    },

    ['RAIN'] = {
        { to = 'CLEARING', chance = 100 },
    },

    ['THUNDER'] = {
        { to = 'CLEARING', chance = 100 },
    },

    ['SNOW'] = {
        { to = 'CLEARING', chance = 5 },
        { to = 'OVERCAST', chance = 5 },
        { to = 'FOGGY', chance = 5 },
        { to = 'CLOUDS', chance = 5 },
        { to = 'XMAS', chance = 50 },
        { to = 'SNOWLIGHT', chance = 50 },
        { to = 'BLIZZARD', chance = 50 },
    },

    ['BLIZZARD'] = {
        { to = 'XMAS', chance = 50 },
        { to = 'SNOWLIGHT', chance = 50 },
    },

    ['SNOWLIGHT'] = {
        { to = 'SNOW', chance = 50 },
        { to = 'XMAS', chance = 50 },
    },

    ['XMAS'] = {
        { to = 'SNOW', chance = 50 },
        { to = 'SNOWLIGHT', chance = 50 },
        { to = 'BLIZZARD', chance = 50 },
    },

    ['HALLOWEEN'] = {
        { to = 'CLEARING', chance = 100 },
    }
}

-- some computed weather properties
cfg.includesSnow = {'XMAS', 'SNOW', 'BLIZZARD', 'SNOWLIGHT'}
cfg.includesRain = {'THUNDER', 'RAIN', 'HALLOWEEN', 'CLEARING'}
