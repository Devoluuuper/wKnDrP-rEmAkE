cfg = {}

-- cfg.locations = {
--     ['ottos'] = {
--         stash = vec3(840.01318359375, -826.91870117188, 26.331176757812),
--         duty = vec3(834.18463134766, -828.63293457031, 26.331176757812),
--         polyZone = {
--             pos = vec3(830.9, -812.78, 26.33),
--             vals = {21.6, 11.8},
--             heading = 0,
--             minZ = 25.23,
--             maxZ = 30.63
--         }
--     },

--     ['driftmotors'] = {
--         stash = vec3(97.96484375, 6619.3056640625, 32.430786132812),
--         duty = vec3(100.8659362793, 6618.9755859375, 32.430786132812),
--         polyZone = {
--             pos = vec3(106.54, 6623.06, 31.79),
--             vals = {17.4, 10.0},
--             heading = 315,
--             minZ = 30.39,
--             maxZ = 34.39
--         }
--     }
-- }



cfg.locations = {
    ['driftmotors'] = {
        stash = {
            coords = vec3(97.96484375, 6619.3056640625, 32.430786132812),
            size = vec3(1.05, 3.7, 2.45),
            rotation = 0.0,
        },

        duty = {
            coords = vec3(100.8659362793, 6618.9755859375, 32.430786132812),
            size = vec3(2.9, 0.7, 2.3),
            rotation = 0.0,
        },

        parts = {
            coords = vec3(105.9976, 6629.2715, 32.0424),
            size = vec3(0.55, 0.45, 0.4),
            rotation = 0.0,
        },

        unboxing = {
            coords = vec3(-326.05, -139.7, 39.3),
            size = vec3(1, 0.75, 1),
            rotation = 69.5,
        },


        polyZone = {
            coords = vec3(106.54, 6623.06, 31.79),
            size = vec3(69.25, 33.0, 10.0),
            rotation = 0.0,
        }
    },
    -- ['lscustoms'] = {
    --     stash = {
    --         coords = vec3(-330.7, -146.4, 39.7),
    --         size = vec3(5.65, 2.0, 2.65),
    --         rotation = 340.0,
    --     },

    --     duty = {
    --         coords = vec3(-323.5, -146.7, 39.5),
    --         size = vec3(2.15, 0.55, 2.3),
    --         rotation = 340.0,        
    --     },

    --     parts = {
    --         coords = vec3(-332.3, -133.25, 39.05),
    --         size = vec3(0.6, 0.8, 0.55),
    --         rotation = 340.0,
    --     },

    --     unboxing = {
    --         coords = vec3(-326.05, -139.7, 39.3),
    --         size = vec3(1, 0.75, 1),
    --         rotation = 69.5,
    --     },

    --     polyZone = {
    --         coords = vec3(-350.25, -125.1, 40.5),
    --         size = vec3(55.25, 27.2, 7.0),
    --         rotation = 340.0,
    --     }
    -- },

    -- ['harmony'] = {
    --     stash = {
    --         coords = vec3(1184.85, 2639.4, 38.15),
    --         size = vec3(1.0, 4.65, 2.8),
    --         rotation = 1.5,
    --     },

    --     duty = {
    --         coords = vec3(1187.0, 2635.25, 38.5),
    --         size = vec3(0.5, 0.4, 0.5),
    --         rotation = 0.0,
    --     },

    --     parts = {
    --         coords = vec3(1186.25, 2638.2, 38.5),
    --         size = vec3(0.5, 0.55, 0.6),
    --         rotation = 25.75,
    --     },

    --     unboxing = {
    --         coords = vec3(1171.55, 2639.65, 38.15),
    --         size = vec3(1, 0.75, 1),
    --         rotation = 270.0,
    --     },

    --     polyZone = {
    --         coords = vec3(1174.2, 2648.5, 38.0),
    --         size = vec3(23.7, 51.0, 8.1),
    --         rotation = 0.0,
    --     }
    -- },

    -- ['spade'] = {
    --     stash = {
    --         coords = vec3(741.55, -1270.2, 27.45),
    --         size = vec3(1, 2.5, 2.75),
    --         rotation = 0.0,
    --     },

    --     duty = {
    --         coords = vec3(753.2, -1297.1, 26.35),
    --         size = vec3(4.25, 0.35, 2.15),
    --         rotation = 0.0,
    --     },

    --     parts = {
    --         coords = vec3(761.85, -1299.05, 26.15),
    --         size = vec3(0.75, 0.55, 0.45),
    --         rotation = 0.0,
    --     },

    --     unboxing = {
    --         coords = vec3(744.35, -1300.1, 26.45),
    --         size = vec3(1, 0.75, 1),
    --         rotation = 0.0,
    --     },

    --     polyZone = {
    --         coords = vec3(749.0, -1286.0, 36.0),
    --         size = vec3(70.0, 66.0, 24.0),
    --         rotation = 0.0,
    --     }
    -- },

    -- ['eventure'] = {
    --     stash = {
    --         coords = vec3(154.45, -3011.35, 7.15),
    --         size = vec3(0.45, 2.25, 2.25),
    --         rotation = 0.0,
    --     },

    --     duty = {
    --         coords = vec3(151.75, -3014.0, 7.05),
    --         size = vec3(0.45, 1.65, 2.15),
    --         rotation = 0.0,
    --     },

    --     parts = {
    --         coords = vec3(125.4, -3014.8, 7.0),
    --         size = vec3(0.5, 0.5, 0.5),
    --         rotation = 356.0,
    --     },

    --     unboxing = {
    --         coords = vec3(126.55, -3016.55, 7.1),
    --         size = vec3(1, 0.75, 1),
    --         rotation = 179.5,
    --     },

    --     polyZone = {
    --         coords = vec3(146, -3029, 7.0),
    --         size = vec3(51.65, 47.0, 7.2000000000006),
    --         rotation = 0.0,
    --     }
    -- }
}


cfg.zones = {
    {
        name = "paletemehaanikuparandusala",
        coords = vec3(111.0, 6621.0, 32.55),
        size = vec3(13.0, 16.0, 3.65),
        rotation = 45.0,
    },

    {
        name = "lennujaamaparandusala",
        coords = vec3(-1146.0, -1999.0, 14.55),
        size = vec3(24.0, 38.0, 5),
        rotation = 315.0,
    },
}



cfg.prices = {
    brakes = {4, 6, 8, 10, 12},
    engine = {5, 10, 15, 20, 25},
    suspension = {4, 6, 8, 10, 12},
    transmission = {4, 6, 8, 10, 12},
    turbo = {15}
}


cfg.trailers = {
    'flatbed',
    'nkmule5'
}

cfg.placement = {
    [`nkmule5`] = {-2.3, -0.28}
}

-- cfg.properties = {
--     {
--         coords = vec3(1144.0, -776.0, 58.9),
--         size = vec3(14.0, 8.0, 5.0),
--         rotation = 0.0,
--     },

--     {
--         coords = vec3(533.85, -178.3, 55.25),
--         size = vec3(10.0, 24.25, 7.0),
--         rotation = 0.0,
--     },
-- }