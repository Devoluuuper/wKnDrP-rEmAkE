Config = {}
truckRobbery = {}

Config.atmReward = {min = 333, max = 666}
Config.atmTimeout = 60
Config.atmReputation = 6
Config.atmPoliceReq = 0

-- Jewelry

Config.ReqPoliceJewelry = 0

Config.Stores = {
	["Vangelico"] = { 
		pos = vec3(-629.00335693359,-230.81430053711,38.057048797607),       
        locations = {
            vec3(-626.32, -239.02, 38.06),
            vec3(-625.36, -238.2, 38.06),
            vec3(-627.12, -235.0, 38.06),
            vec3(-626.09, -234.25, 38.06),
            vec3(-626.61, -233.48, 38.06),
            vec3(-627.72, -234.19, 38.06),
            vec3(-624.15, -230.91, 38.06),
            vec3(-623.68, -228.54, 38.06),
            vec3(-621.45, -228.66, 38.06),
            vec3(-622.81, -232.8, 38.06),
            vec3(-620.32, -233.1, 38.06),
            vec3(-619.78, -230.76, 38.06),
            vec3(-620.11, -226.35, 38.06),
            vec3(-619.38, -227.36, 38.06),
            vec3(-618.01, -229.23, 38.06),
            vec3(-617.25, -230.29, 38.06),
            vec3(-618.93, -234.01, 38.06),
            vec3(-619.94, -234.74, 38.06),
            vec3(-625.24, -227.47, 38.06),
            vec3(-624.14, -226.82, 38.06)
        }
	}
}

Config.Items = {
    {name = 'ring', count = math.random(3,6)},
    {name = 'rolexwatch', count = math.random(3,6)}, 
    {name = 'goldwatch', count = math.random(2,5)}, 
    {name = 'neckless', count = math.random(4,7)}
}

Config.SafeItems = {
    {name = 'tiamond', count = math.random(5,10)},
    {name = 'ruby', count = math.random(10,15)}, 
    {name = 'sapphire', count = math.random(10,15)}, 
    {name = 'emerald', count = math.random(8,12)}
}

-- House

Config.ReqPoliceHouse = 0

Config.Places = {
    {pos = vector3(345.83, -1001.75, -99.2), useZ = true},
    {pos = vector3(348.76, -994.85, -99.2), useZ = true},
    {pos = vector3(339.23, -1003.87, -99.2), useZ = true},
    {pos = vector3(337.7, -995.06, -99.2), useZ = false},
    {pos = vector3(337.43, -998.42, -99.2), useZ = false}
}

Config.HouseItems = {
    {name = 'ring', count = 1},
    {name = 'lockpick', count = math.random(1,2)}, 
    {name = 'chips', count = math.random(1,3)}, 
    {name = 'monster', count = math.random(1,2)},
    {name = 'jewelry_id', count = 1}, 
    {name = 'fakeplate', count = 1},
    {name = 'ammo-pistol', count = 4},
    {name = 'fixkit', count = 1},
    {name = 'laptop', count = 1},
    {name = 'coke', count = math.random(1,3)},
    {name = 'coca_leaf', count = math.random(1,7)},
    {name = 'weed_joint', count = math.random(1,6)},
    {name = 'weed_pooch', count = math.random(1,2)},
    {name = 'moonshine', count = math.random(1,3)},
    {name = 'bock', count = math.random(1,2)}
}


----------- Shop
Config.ShopRobPolice  = 0
Config.shopReputation = 4
Config.shopTimeout = 30

Config.shopItems = {
    [1] = { -- Barber
        {item = 'bard', min = 1, max = 2}, 
        {item = 'hairdryer', min = 1, max = 2},
        {item = 'curlingiron', min = 1, max = 2},
        {item = 'hairdryer', min = 1, max = 2},
    },

    [2] = { -- Lottoo
        {item = 'scratch_ticket', min = 1, max = 1}, 
    },

    [3] = { -- Sigaretts
        {item = 'cigarett_pack', min = 1, max = 3}, 
        {item = 'cigarett_block', min = 1, max = 1},
        {item = 'cigarello_pack', min = 1, max = 3},
        {item = 'snus_pack', min = 1, max = 3},
        {item = 'snus_tower', min = 1, max = 1},
        {item = 'snus_pack_roheline', min = 1, max = 3},
        {item = 'snus_tower_roheline', min = 1, max = 1},
        {item = 'snus_pack_roosa', min = 1, max = 3},
        {item = 'snus_tower_roosa', min = 1, max = 1},
        {item = 'snus_pack_lilla', min = 1, max = 3},
        {item = 'snus_tower_lilla', min = 1, max = 1}
    },

    [4] = { -- Donuts
        {item = 'red_donut', min = 1, max = 3},
        {item = 'pink_donut', min = 1, max = 3},
        {item = 'blue_pink_donut', min = 1, max = 3},
        {item = 'blue_donut', min = 1, max = 3},
        {item = 'white_donut', min = 1, max = 3},
        {item = 'donut', min = 1, max = 3}
    },

    [5] = { -- Chips
        {item = 'chips', min = 1, max = 2},
        {item = 'cheese_chips', min = 1, max = 2},
        {item = 'salty_chips', min = 1, max = 2},
        {item = 'paprica_chips', min = 1, max = 2},
        {item = 'phatchips_pringles', min = 1, max = 2},
        {item = 'sticky_ribs_chips', min = 1, max = 2}
    },

    [6] = { -- Drinks
        {item = 'cola', min = 1, max = 2},
        {item = 'sprunk', min = 1, max = 2},
        {item = 'cola_bottle', min = 1, max = 2},
        {item = 'sprunk_bottle', min = 1, max = 2},
        {item = 'apple_juice', min = 1, max = 2},
        {item = 'orange_juice', min = 1, max = 2},
        {item = 'orango_tang', min = 1, max = 2},
        {item = 'milk', min = 1, max = 2}
    },

    [7] = { -- Clothes
        {item = 'boxers', min = 1, max = 1},
        {item = 'strew_hat', min = 1, max = 1},
        {item = 'gray_shirt', min = 1, max = 1},
        {item = 'white_shirt', min = 1, max = 1},
        {item = 'yellow_shirt', min = 1, max = 1},
        {item = 'brown_shirt', min = 1, max = 1},
        {item = 'orange_shirt', min = 1, max = 1},
        {item = 'yellow_dress', min = 1, max = 1},
        {item = 'bra', min = 1, max = 1},
        {item = 'w_underwear', min = 1, max = 1}
    },

    [8] = { -- Safe
        {item = 'money', min = 1000, max = 1500}
    },

    [9] = { -- Shoes
        {item = 'WEAPON_SHOE', min = 2, max = 4}
    },
}

Config.shops = {
    { -- Hoodi juuksur
        doors = {199},
        places = {
            {
                itemId = 1,

                target = {
                    coords = vec3(139.15, -1708.2, 28.75),
                    size = vec3(0.75, 0.6, 0.85),
                    rotation = 234.25
                }
            }
        }
    },

    { -- Hoodi tankla
        doors = {200, 201},
        places = {
            {
                itemId = 2,

                target = {
                    coords = vec3(-47.9, -1760.2, 29.65),
                    size = vec3(0.55, 1.0, 0.45),
                    rotation = 51.0,
                }
            },

            {
                itemId = 3,

                target = {
                    coords = vec3(-46.2, -1759.3, 30.05),
                    size = vec3(0.3, 1.3, 1.15),
                    rotation = 320.0,
                }
            },

--[[            {
                itemId = 4,

                target = {
                    coords = vec3(-49.0, -1754.6, 29.4),
                    size = vec3(3.0, 1, 1.95),
                    rotation = 5.25,
                }
            },
]]
            {
                itemId = 5,

                target = {
                    coords = vec3(-51.7, -1752.65, 29.25),
                    size = vec3(4.9, 1.15, 1.65),
                    rotation = 4.5,
                }
            },

            {
                itemId = 6,

                target = {
                    coords = vec3(-52.95, -1750.5, 29.25),
                    size = vec3(3.0, 1.0, 1.6),
                    rotation = 3.75,
                }
            },

            {
                itemId = 8, -- safe

                target = {
                    coords = vec3(-44.0, -1748.0, 28.95),
                    size = vec3(1, 1, 1.1),
                    rotation = 51.5,
                }
            }
        }
    },

    { -- Hoodi riidepood
        doors = {202, 203},
        places = {
            {
                itemId = 7,

                target = {
                    coords = vec3(77.0, -1394.55, 29.15),
                    size = vec3(2.75, 2.65, 1.5),
                    rotation = 0.0,
                }
            },

            
            {
                itemId = 7,

                target = {
                    coords = vec3(74.7, -1401.2, 29.8),
                    size = vec3(2.7, 0.4, 2.8),
                    rotation = 0.0,
                }
            },

            {
                itemId = 7,

                target = {
                    coords = vec3(80.5, -1401.35, 29.5),
                    size = vec3(2.55, 0.65, 2.2),
                    rotation = 0.0,
                }
            },

            {
                itemId = 7,

                target = {
                    coords = vec3(81.85, -1396.45, 29.55),
                    size = vec3(0.65, 1.2, 2.35),
                    rotation = 0.0,
                }
            },

            {
                itemId = 9,

                target = {
                    coords = vec3(77.55, -1400.6, 29.6),
                    size = vec3(2.7, 0.95, 2.35),
                    rotation = 0.0,
                }
            }
        }
    },

    { -- Kesklinna pood
        doors = {204, 205},
        places = {
            {
                itemId = 2, -- loto

                target = {
                    coords = vec3(25.65, -1348.6, 29.8),
                    size = vec3(0.35, 0.85, 0.4),
                    rotation = 13.25,
                }
            },

            {
                itemId = 3, -- sigarets

                target = {
                    coords = vec3(23.75, -1347.2, 30.3),
                    size = vec3(0.35, 1.75, 1.45),
                    rotation = 0.25,
                }
            },

--[[            {
                itemId = 4, -- donuts

                target = {
                    coords = vec3(26.2, -1342.25, 29.45),
                    size = vec3(1, 0.55, 1.9),
                    rotation = 0.0,
                }
            },]]

            {
                itemId = 5, -- chips

                target = {
                    coords = vec3(29.0, -1344.95, 29.4),
                    size = vec3(1.05, 2.9, 1.8),
                    rotation = 0.0,
                }
            },

            {
                itemId = 6, -- drinks

                target = {
                    coords = vec3(31.2, -1345.2, 29.4),
                    size = vec3(1.05, 2.45, 1.8),
                    rotation = 0.0,
                }
            },

            
            {
                itemId = 8, -- safe

                target = {
                    coords = vec3(31.8, -1339.3, 29.9),
                    size = vec3(1, 1, 1),
                    rotation = 0.5,
                }
            }
        }
    },

    { -- Paffi pood
        doors = {206},
        places = {
            {
                itemId = 2, -- loto

                target = {
                    coords = vec3(1134.95, -983.85, 46.65),
                    size = vec3(0.4, 1.0, 0.45),
                    rotation = 8.25,
                }
            },

            {
                itemId = 3, -- sigarets

                target = {
                    coords = vec3(1132.4, -982.05, 46.85),
                    size = vec3(0.55, 1.45, 1.35),
                    rotation = 8.75,
                }
            },

            {
                itemId = 5, -- chips

                target = {
                    coords = vec3(1137.85, -982.75, 46.25),
                    size = vec3(2.35, 1, 1.65),
                    rotation = 7.25,
                }
            }
        }
    },

    { -- Mirror juuksur
        doors = {209},
        places = {
            {
                itemId = 1,

                target = {
                    coords = vec3(1213.15, -474.8, 65.7),
                    size = vec3(0.8, 0.7, 0.85),
                    rotation = 0.0,
                }
            }
        }
    },

    { -- Mirrori tankla
        doors = {210, 211},
        places = {
            {
                itemId = 2, -- loto

                target = {
                    coords = vec3(1165.79, -325.2, 69.4),
                    size = vec3(1.0, 0.2, 0.45),
                    rotation = 9.0,
                }
            },

            {
                itemId = 3, -- sigar

                target = {
                    coords = vec3(1166.15, -323.2, 69.95),
                    size = vec3(0.3, 1.5, 1.45),
                    rotation = 11.5,
                }
            },

--[[            {
                itemId = 4, -- donuts

                target = {
                    coords = vec3(1160.75, -322.3, 69.2),
                    size = vec3(1.05, 2.65, 1.95),
                    rotation = 325.0,
                }
            },]]

            {
                itemId = 5, -- chips

                target = {
                    coords = vec3(1157.5, -322.95, 69.1),
                    size = vec3(1.05, 5.05, 1.75),
                    rotation = 325.0,
                }
            },

            {
                itemId = 6, -- drinks

                target = {
                    coords = vec3(1154.85, -322.75, 69.1),
                    size = vec3(1.05, 2.8, 1.75),
                    rotation = 325.0,
                }
            },

            {
                itemId = 8, -- safe

                target = {
                    coords = vec3(1158.85, -314.15, 68.8),
                    size = vec3(1, 0.9, 1.2),
                    rotation = 11.5,
                }
            }
        }
    },

    { -- Suur pank pood
        doors = {212, 213},
        places = {
            {
                itemId = 2, -- loto

                target = {
                    coords = vec3(373.4, 324.85, 103.9),
                    size = vec3(0.3, 0.9, 0.5),
                    rotation = 350.5,
                }
            },

            {
                itemId = 3, -- sigar

                target = {
                    coords = vec3(371.95, 326.7, 104.35),
                    size = vec3(0.4, 1.85, 1.4),
                    rotation = 346.5,
                }
            },

--[[            {
                itemId = 4, -- donuts

                target = {
                    coords = vec3(375.45, 330.9, 103.6),
                    size = vec3(0.95, 0.55, 2.05),
                    rotation = 347.25,
                }
            },]]

            {
                itemId = 5, -- chips

                target = {
                    coords = vec3(377.4, 327.65, 103.55),
                    size = vec3(1.15, 2.9, 1.9),
                    rotation = 344.5,
                }
            },

            {
                itemId = 6, -- drinks

                target = {
                    coords = vec3(379.55, 326.85, 103.5),
                    size = vec3(1.05, 2.3, 1.85),
                    rotation = 345.0,
                }
            },

            {
                itemId = 8, -- safe

                target = {
                    coords = vec3(381.45, 332.5, 104.0),
                    size = vec3(0.6, 1.0, 1.0),
                    rotation = 346.5,
                }
            }
        }
    },

    { -- Alta riidepood
        doors = {214},
        places = {
            {
                itemId = 7,

                target = {
                    coords = vec3(123.45, -216.55, 54.65),
                    size = vec3(1.15, 2.35, 2.15),
                    rotation = 249.75,
                }
            },

            {
                itemId = 7,

                target = {
                    coords = vec3(131.55, -215.8, 54.75),
                    size = vec3(0.7, 2.1, 2.4),
                    rotation = 340.25,
                }
            },

            {
                itemId = 7,

                target = {
                    coords = vec3(126.55, -219.85, 54.75),
                    size = vec3(1.5, 2.25, 2.4),
                    rotation = 339.5,
                }
            },

            {
                itemId = 7,

                target = {
                    coords = vec3(121.9, -220.5, 54.7),
                    size = vec3(2.65, 1.25, 2.3),
                    rotation = 340.0,
                }
            },

            {
                itemId = 9,

                target = {
                    coords = vec3(117.15, -222.45, 54.8),
                    size = vec3(0.8, 2.15, 2.5),
                    rotation = 340.75,
                }
            }
        }
    },

    { -- Alta juuksur
        doors = {215},
        places = {
            {
                itemId = 1,

                target = {
                    coords = vec3(-35.05, -153.05, 56.6),
                    size = vec3(0.75, 0.7, 0.95),
                    rotation = 258.25,
                }
            }
        }
    },

    { -- Pilu pood
        doors = {216, 217},
        places = {
            {
                itemId = 2, -- loto

                target = {
                    coords = vec3(-705.55, -916.25, 19.45),
                    size = vec3(0.9, 0.2, 0.45),
                    rotation = 0.0,
                }
            },

            {
                itemId = 3, -- sigar

                target = {
                    coords = vec3(-704.8, -914.3, 19.95),
                    size = vec3(0.25, 1.35, 1.4),
                    rotation = 0.0,
                }
            },

--[[            {
                itemId = 4, -- donuts

                target = {
                    coords = vec3(-709.85, -912.4, 19.2),
                    size = vec3(2.9, 1.3, 1.95),
                    rotation = 45.0,
                }
            },]]

            {
                itemId = 5, -- chips

                target = {
                    coords = vec3(-713.35, -912.55, 19.05),
                    size = vec3(1.1, 4.95, 1.65),
                    rotation = 315.0,
                }
            },

            {
                itemId = 6, -- drinks

                target = {
                    coords = vec3(-715.6, -911.85, 19.05),
                    size = vec3(1.15, 3.25, 1.65),
                    rotation = 314.25,
                }
            }, 	

            {
                itemId = 8, -- safe

                target = {
                    coords = vec3(-710.4, -904.15, 18.7),
                    size = vec3(0.85, 0.9, 1.05),
                    rotation = 0.0,
                }
            }
        }
    },

    { -- Ranna riidepood
        doors = {218, 219},
        places = {
            {
                itemId = 7,

                target = {
                    coords = vec3(-822.95, -1075.85, 11.1),
                    size = vec3(2.95, 2.7, 1.5),
                    rotation = 30.0,
                }
            },

            {
                itemId = 7,

                target = {
                    coords = vec3(-830.0, -1077.15, 11.6),
                    size = vec3(0.65, 2.6, 2.55),
                    rotation = 31.0,
                }
            }, 

            {
                itemId = 9,

                target = {
                    coords = vec3(-828.0, -1079.4, 11.7),
                    size = vec3(1.2, 3.2, 2.8),
                    rotation = 30.25,
                }
            }, 

            {
                itemId = 7,

                target = {
                    coords = vec3(-827.15, -1082.2, 11.55),
                    size = vec3(0.65, 2.45, 2.45),
                    rotation = 30.0,
                }
            }, 

            {
                itemId = 7,

                target = {
                    coords = vec3(-822.2, -1080.95, 11.5),
                    size = vec3(1.15, 0.65, 2.35),
                    rotation = 32.0,
                }
            }, 
        }
    },

    { -- Ranna juuksur
        doors = {220},
        places = {
            {
                itemId = 1,

                target = {
                    coords = vec3(-1281.5, -1119.0, 6.5),
                    size = vec3(0.8, 0.55, 1.0),
                    rotation = 0.0,
                }
            }
        }
    },

    { -- Burgerkingi pood
        doors = {221},
        places = {
            {
                itemId = 2, -- loto

                target = {
                    coords = vec3(-1221.05, -907.1, 12.6),
                    size = vec3(0.35, 1.0, 0.5),
                    rotation = 305.0,
                }
            },

            {
                itemId = 3, -- sigarets

                target = {
                    coords = vec3(-1221.5, -910.05, 12.75),
                    size = vec3(1.45, 0.5, 1.3),
                    rotation = 34.5,
                }
            },

            {
                itemId = 5, -- chips

                target = {
                    coords = vec3(-1223.3, -904.9, 12.2),
                    size = vec3(1.1, 2.25, 1.7),
                    rotation = 35.0,
                }
            }
        }
    },

    { -- Ranna riidepood
        doors = {222},
        places = {
            {
                itemId = 7,

                target = {
                    coords = vec3(-1195.15, -775.4, 17.4),
                    size = vec3(1.3, 2.15, 2.1),
                    rotation = 37.5,
                }
            },

            {
                itemId = 7,

                target = {
                    coords = vec3(-1202.45, -771.45, 17.75),
                    size = vec3(2.1, 0.8, 2.9),
                    rotation = 35.0,
                }
            },

            {
                itemId = 7,

                target = {
                    coords = vec3(-1191.75, -772.75, 17.5),
                    size = vec3(1.7, 2.3, 2.35),
                    rotation = 36.5,
                }
            },

            {
                itemId = 7,

                target = {
                    coords = vec3(-1196.0, -771.0, 17.35),
                    size = vec3(2.3, 1.4, 2.25),
                    rotation = 36.5,
                }
            },

            {
                itemId = 9,

                target = {
                    coords = vec3(-1186.75, -773.85, 17.65),
                    size = vec3(2.1, 0.6, 2.7),
                    rotation = 37.0,
                }
            }
        }
    },

    { -- Korteri pood
        doors = {223},
        places = {
            {
                itemId = 2, -- loto

                target = {
                    coords = vec3(-1487.65, -377.3, 40.4),
                    size = vec3(1.0, 0.3, 0.5),
                    rotation = 315.0,
                }
            },

            {
                itemId = 3, -- sigarets

                target = {
                    coords = vec3(-1484.6, -377.25, 40.6),
                    size = vec3(1.45, 0.6, 1.25),
                    rotation = 316.25,
                }
            },

            {
                itemId = 5, -- chips

                target = {
                    coords = vec3(-1489.3, -380.0, 40.0),
                    size = vec3(1.0, 2.3, 1.65),
                    rotation = 315.0,
                }
            }
        }
    },

    { -- Cartel pood
        doors = {224, 225},
        places = {
            {
                itemId = 2, -- loto

                target = {
                    coords = vec3(-1817.85, 792.75, 138.3),
                    size = vec3(0.2, 1.15, 0.45),
                    rotation = 313.75,
                }
            },

            {
                itemId = 3, -- sigar

                target = {
                    coords = vec3(-1818.7, 794.55, 138.85),
                    size = vec3(1.35, 0.25, 1.55),
                    rotation = 314.25,
                }
            },

--[[            {
                itemId = 4, -- donuts

                target = {
                    coords = vec3(-1823.75, 792.5, 138.15),
                    size = vec3(1.0, 3.0, 1.9),
                    rotation = 358.5,
                }
            },]]

            {
                itemId = 5, -- chips

                target = {
                    coords = vec3(-1826.15, 789.9, 138.1),
                    size = vec3(1.0, 5.25, 1.65),
                    rotation = 358.25,
                }
            },

            {
                itemId = 6, -- drinks

                target = {
                    coords = vec3(-1828.35, 788.95, 138.15),
                    size = vec3(1.0, 2.9, 1.65),
                    rotation = 356.75,
                }
            },

            {
                itemId = 8, -- safe

                target = {
                    coords = vec3(-1829.6, 798.3, 137.7),
                    size = vec3(1, 1, 1.1),
                    rotation = 42.5,
                }
            }
        }
    },

    { -- Lääne mnt pood
        doors = {226},
        places = {
            {
                itemId = 2, -- loto

                target = {
                    coords = vec3(-2966.8, 392.4, 15.25),
                    size = vec3(0.25, 1, 0.4),
                    rotation = 356.75,
                }
            },

            {
                itemId = 3, -- sigarets

                target = {
                    coords = vec3(-2964.75, 390.15, 15.45),
                    size = vec3(0.5, 1.45, 1.25),
                    rotation = 356.25,
                }
            },

            {
                itemId = 5, -- chips

                target = {
                    coords = vec3(-2970.0, 391.9, 14.9),
                    size = vec3(2.25, 1, 1.7),
                    rotation = 356.75,
                }
            }
        }
    },

    { -- Chumash1 pood
        doors = {227, 228},
        places = {
            {
                itemId = 2, -- loto

                target = {
                    coords = vec3(-3038.15, 586.05, 8.2),
                    size = vec3(0.8, 0.35, 0.4),
                    rotation = 25.5,
                }
            },

            {
                itemId = 3, -- sigar

                target = {
                    coords = vec3(-3038.85, 583.85, 8.7),
                    size = vec3(1.85, 0.5, 1.4),
                    rotation = 18.75,
                }
            },

--[[            {
                itemId = 4, -- donuts

                target = {
                    coords = vec3(-3044.3, 584.65, 7.9),
                    size = vec3(0.55, 0.9, 1.95),
                    rotation = 17.5,
                }
            },]]

            {
                itemId = 5, -- chips

                target = {
                    coords = vec3(-3042.65, 588.1, 7.85),
                    size = vec3(2.8, 1.05, 1.85),
                    rotation = 17.5,
                }
            },

            {
                itemId = 6, -- drinks

                target = {
                    coords = vec3(-3043.1, 590.35, 7.85),
                    size = vec3(2.3, 1.1, 1.85),
                    rotation = 18.75,
                }
            },

            {
                itemId = 8, -- safe

                target = {
                    coords = vec3(-3048.85, 588.95, 8.3),
                    size = vec3(1, 0.65, 1.0),
                    rotation = 17.5,
                }
            }
        }
    },

    { -- Chumash2 pood
        doors = {229, 230},
        places = {
            {
                itemId = 2, -- loto

                target = {
                    coords = vec3(-3240.9, 1001.05, 13.15),
                    size = vec3(0.85, 0.3, 0.5),
                    rotation = 0.0,
                }
            },

            {
                itemId = 3, -- sigar

                target = {
                    coords = vec3(-3242.45, 999.3, 13.55),
                    size = vec3(1.85, 0.4, 1.3),
                    rotation = 355.25,
                }
            },

--[[            {
                itemId = 4, -- donuts

                target = {
                    coords = vec3(-3247.15, 1002.1, 12.85),
                    size = vec3(0.5, 1.0, 2.0),
                    rotation = 355.25,
                }
            },]]

            {
                itemId = 5, -- chips

                target = {
                    coords = vec3(-3244.2, 1004.6, 12.75),
                    size = vec3(3.0, 1, 1.8),
                    rotation = 354.5,
                }
            },

            {
                itemId = 6, -- drinks

                target = {
                    coords = vec3(-3243.8, 1006.85, 12.8),
                    size = vec3(2.35, 1.05, 1.9),
                    rotation = 355.25,
                }
            },

            {
                itemId = 8, -- safe

                target = {
                    coords = vec3(-3249.65, 1007.9, 13.2),
                    size = vec3(0.95, 0.5, 0.95),
                    rotation = 355.0,
                }
            }
        }
    },

    { -- Chumash riidepood
        doors = {231},
        places = {
            {
                itemId = 7,

                target = {
                    coords = vec3(-3172.6, 1051.05, 20.9),
                    size = vec3(2.2, 1.3, 2.05),
                    rotation = 335.5,
                }
            },

            {
                itemId = 7,

                target = {
                    coords = vec3(-3174.1, 1047.4, 21.0),
                    size = vec3(2.65, 1.45, 2.25),
                    rotation = 335.0,
                }
            },

            {
                itemId = 7,

                target = {
                    coords = vec3(-3169.55, 1047.7, 21.0),
                    size = vec3(1.45, 2.2, 2.3),
                    rotation = 337.25,
                }
            },

            {
                itemId = 7,

                target = {
                    coords = vec3(-3164.15, 1051.25, 21.1),
                    size = vec3(0.8, 2.2, 2.5),
                    rotation = 336.5,
                }
            },

            {
                itemId = 9,

                target = {
                    coords = vec3(-3178.95, 1045.65, 21.0),
                    size = vec3(0.75, 2.0, 2.25),
                    rotation = 335.5,
                }
            }
        }
    },

    { -- Sõjaväe riidepood
        doors = {232, 233},
        places = {
            {
                itemId = 7,

                target = {
                    coords = vec3(-1101.6, 2708.15, 18.85),
                    size = vec3(2.75, 2.85, 1.45),
                    rotation = 310.0,
                }
            },

            {
                itemId = 7,

                target = {
                    coords = vec3(-1099.75, 2703.35, 19.3),
                    size = vec3(1.2, 0.8, 2.45),
                    rotation = 42.25,
                }
            },

            {
                itemId = 7,

                target = {
                    coords = vec3(-1104.4, 2701.1, 19.2),
                    size = vec3(0.65, 2.45, 2.2),
                    rotation = 41.75,
                }
            },

            {
                itemId = 7,

                target = {
                    coords = vec3(-1108.15, 2705.45, 19.4),
                    size = vec3(0.65, 2.6, 2.6),
                    rotation = 42.75,
                }
            },

            {
                itemId = 9,

                target = {
                    coords = vec3(-1105.95, 2703.55, 19.4),
                    size = vec3(1.0, 3.0, 2.4),
                    rotation = 40.5,
                }
            }
        }
    },

    { -- Harmony pood
        doors = {234, 235},
        places = {
            {
                itemId = 2, -- loto

                target = {
                    coords = vec3(547.7, 2672.5, 42.45),
                    size = vec3(0.35, 1.0, 0.45),
                    rotation = 16.25,
                }
            },

            {
                itemId = 3, -- sigar

                target = {
                    coords = vec3(549.75, 2671.3, 42.95),
                    size = vec3(0.45, 1.95, 1.45),
                    rotation = 8.0,
                }
            },

--[[            {
                itemId = 4, -- donuts

                target = {
                    coords = vec3(548.0, 2666.1, 42.15),
                    size = vec3(1, 0.45, 1.95),
                    rotation = 8.0,
                }
            },
]]
            {
                itemId = 5, -- chips

                target = {
                    coords = vec3(545.0, 2668.4, 42.1),
                    size = vec3(1.1, 2.9, 1.85),
                    rotation = 6.75,
                }
            },

            {
                itemId = 6, -- drinks

                target = {
                    coords = vec3(542.75, 2668.4, 42.1),
                    size = vec3(1.1, 2.35, 1.85),
                    rotation = 7.75,
                }
            },

            {
                itemId = 8, -- safe

                target = {
                    coords = vec3(543.15, 2662.45, 42.55),
                    size = vec3(0.2, 0.9, 0.95),
                    rotation = 7.75,
                }
            }
        }
    },

    { -- Harmony riidepood
        doors = {236},
        places = {
            {
                itemId = 7,

                target = {
                    coords = vec3(619.4, 2757.15, 42.15),
                    size = vec3(2.3, 1.3, 2.1),
                    rotation = 3.75,
                }
            },

            {
                itemId = 7,

                target = {
                    coords = vec3(612.25, 2753.1, 42.35),
                    size = vec3(0.95, 2.1, 2.55),
                    rotation = 4.0,
                }
            },

            {
                itemId = 7,

                target = {
                    coords = vec3(615.15, 2758.8, 42.25),
                    size = vec3(1.4, 2.35, 2.35),
                    rotation = 3.75,
                }
            },

            {
                itemId = 7,

                target = {
                    coords = vec3(619.05, 2761.3, 42.15),
                    size = vec3(2.3, 1.45, 2.3),
                    rotation = 4.25,
                }
            },

            {
                itemId = 9,

                target = {
                    coords = vec3(622.55, 2764.95, 42.2),
                    size = vec3(0.65, 2.05, 2.25),
                    rotation = 5.0,
                }
            }
        }
    },

    { -- Harmony panga pood
        doors = {237},
        places = {
            {
                itemId = 2, -- loto

                target = {
                    coords = vec3(1164.4, 2710.35, 38.35),
                    size = vec3(1.1, 0.3, 0.4),
                    rotation = 0.0,
                }
            },

            {
                itemId = 3, -- sigarets

                target = {
                    coords = vec3(1166.55, 2712.5, 38.7),
                    size = vec3(1.5, 0.5, 1.55),
                    rotation = 0.0,
                }
            },

            {
                itemId = 5, -- chips

                target = {
                    coords = vec3(1165.15, 2707.25, 38.0),
                    size = vec3(0.95, 2.3, 1.65),
                    rotation = 0.0,
                }
            }
        }
    },

    { -- Harmony panga riidepood
        doors = {238, 239},
        places = {
            {
                itemId = 7,

                target = {
                    coords = vec3(1195.05, 2708.55, 37.95),
                    size = vec3(2.8, 2.85, 1.4),
                    rotation = 0.0,
                }
            },

            {
                itemId = 7,

                target = {
                    coords = vec3(1193.15, 2703.7, 38.4),
                    size = vec3(1.25, 0.6, 2.35),
                    rotation = 0.0,
                }
            },

            {
                itemId = 7,

                target = {
                    coords = vec3(1188.2, 2705.1, 38.4),
                    size = vec3(0.8, 2.55, 2.4),
                    rotation = 0.0,
                }
            },

            {
                itemId = 7,

                target = {
                    coords = vec3(1188.3, 2710.9, 38.45),
                    size = vec3(0.7, 2.6, 2.45),
                    rotation = 0.0,
                }
            },

            {
                itemId = 9,

                target = {
                    coords = vec3(1188.7, 2708.0, 38.45),
                    size = vec3(0.55, 2.9, 2.4),
                    rotation = 358.75,
                }
            }
        }
    },

    { -- Ida mnt pood
        doors = {240, 241},
        places = {
            {
                itemId = 2, -- loto

                target = {
                    coords = vec3(2558.55, 381.95, 108.9),
                    size = vec3(0.8, 0.3, 0.4),
                    rotation = 4.25,
                }
            },

            {
                itemId = 3, -- sigar

                target = {
                    coords = vec3(2557.05, 380.1, 109.4),
                    size = vec3(1.95, 0.4, 1.4),
                    rotation = 358.5,
                }
            },

--[[            {
                itemId = 4, -- donuts

                target = {
                    coords = vec3(2552.3, 382.7, 108.65),
                    size = vec3(0.65, 1.1, 2.05),
                    rotation = 357.5,
                }
            },]]

            {
                itemId = 5, -- chips

                target = {
                    coords = vec3(2555.0, 385.4, 108.6),
                    size = vec3(2.95, 1, 1.95),
                    rotation = 357.5,
                }
            },

            {
                itemId = 6, -- drinks

                target = {
                    coords = vec3(2555.3, 387.65, 108.55),
                    size = vec3(2.45, 1, 1.85),
                    rotation = 357.0,
                }
            },

            {
                itemId = 8, -- safe

                target = {
                    coords = vec3(2549.45, 388.35, 109.0),
                    size = vec3(0.9, 0.5, 1.0),
                    rotation = 358.75,
                }
            }
        }
    },

    { -- Kaevanduse pood
        doors = {242, 243},
        places = {
            {
                itemId = 2, -- loto

                target = {
                    coords = vec3(2679.75, 3279.85, 55.55),
                    size = vec3(0.9, 0.25, 0.45),
                    rotation = 339.75,
                }
            },

            {
                itemId = 3, -- sigar

                target = {
                    coords = vec3(2677.6, 3278.8, 55.9),
                    size = vec3(1.95, 0.45, 1.15),
                    rotation = 331.25,
                }
            },

--[[            {
                itemId = 4, -- donuts

                target = {
                    coords = vec3(2674.5, 3283.35, 55.25),
                    size = vec3(0.6, 1.1, 2.0),
                    rotation = 330.0,
                }
            },]]

            {
                itemId = 5, -- chips

                target = {
                    coords = vec3(2678.05, 3284.5, 55.2),
                    size = vec3(3.05, 1.05, 1.9),
                    rotation = 331.75,
                }
            },

            {
                itemId = 6, -- drinks

                target = {
                    coords = vec3(2679.45, 3286.3, 55.15),
                    size = vec3(2.3, 1.05, 1.8),
                    rotation = 331.75,
                }
            },

            {
                itemId = 8, -- safe

                target = {
                    coords = vec3(2674.55, 3289.65, 55.65),
                    size = vec3(0.6, 0.95, 1.0),
                    rotation = 60.0,
                }
            }
        }
    },

    { -- Sandy juuksur
        doors = {244},
        places = {
            {
                itemId = 1,

                target = {
                    coords = vec3(1932.55, 3732.3, 32.3),
                    size = vec3(0.5, 0.7, 0.9),
                    rotation = 37.5,
                }
            }
        }
    },

    { -- Sandy pood
        doors = {245, 246},
        places = {
            {
                itemId = 2, -- loto

                target = {
                    coords = vec3(1961.8, 3739.5, 32.65),
                    size = vec3(0.25, 0.9, 0.45),
                    rotation = 38.0,
                }
            },

            {
                itemId = 3, -- sigar

                target = {
                    coords = vec3(1959.4, 3739.75, 33.15),
                    size = vec3(0.45, 1.9, 1.45),
                    rotation = 30.75,
                }
            },

--[[            {
                itemId = 4, -- donuts

                target = {
                    coords = vec3(1959.05, 3745.25, 32.35),
                    size = vec3(1, 0.55, 2.0),
                    rotation = 29.25,
                }
            },]]

            {
                itemId = 5, -- chips

                target = {
                    coords = vec3(1962.9, 3744.25, 32.25),
                    size = vec3(3.1, 1.15, 1.75),
                    rotation = 300.0,
                }
            },

            {
                itemId = 6, -- drinks

                target = {
                    coords = vec3(1964.85, 3745.2, 32.3),
                    size = vec3(2.4, 1.05, 1.9),
                    rotation = 300.0,
                }
            },

            {
                itemId = 8, -- safe

                target = {
                    coords = vec3(1962.3, 3750.6, 32.8),
                    size = vec3(0.6, 1.0, 1.0),
                    rotation = 30.5,
                }
            }
        }
    },

    { -- Grapeseed riidepood
        doors = {247, 248},
        places = {
            {
                itemId = 7,

                target = {
                    coords = vec3(1692.05, 4824.25, 41.85),
                    size = vec3(2.75, 2.9, 1.5),
                    rotation = 6.5,
                }
            },

            {
                itemId = 7,

                target = {
                    coords = vec3(1687.0, 4825.5, 42.2),
                    size = vec3(0.65, 1.25, 2.3),
                    rotation = 7.75,
                }
            },

            {
                itemId = 7,

                target = {
                    coords = vec3(1687.7, 4830.6, 42.25),
                    size = vec3(2.5, 0.85, 2.4),
                    rotation = 7.25,
                }
            },

            {
                itemId = 7,

                target = {
                    coords = vec3(1693.45, 4831.35, 42.3),
                    size = vec3(2.65, 0.9, 2.5),
                    rotation = 8.5,
                }
            },

            {
                itemId = 9,

                target = {
                    coords = vec3(1690.7, 4830.45, 42.25),
                    size = vec3(2.65, 1, 2.4),
                    rotation = 8.0,
                }
            }
        }
    },

    { -- Grapeseed tankla
        doors = {249, 250},
        places = {
            {
                itemId = 2, -- loto

                target = {
                    coords = vec3(1695.55, 4923.9, 42.3),
                    size = vec3(1.0, 0.25, 0.45),
                    rotation = 55.75,
                }
            },

            {
                itemId = 3, -- sigar

                target = {
                    coords = vec3(1696.7, 4922.15, 42.7),
                    size = vec3(0.35, 1.4, 1.25),
                    rotation = 54.75,
                }
            },

--[[            {
                itemId = 4, -- donuts

                target = {
                    coords = vec3(1701.2, 4925.35, 42.05),
                    size = vec3(1.1, 2.9, 1.95),
                    rotation = 9.5,
                }
            },]]

            {
                itemId = 5, -- chips

                target = {
                    coords = vec3(1703.0, 4928.25, 42.0),
                    size = vec3(1, 5.0, 1.85),
                    rotation = 10.0,
                }
            },

            {
                itemId = 6, -- drinks

                target = {
                    coords = vec3(1704.95, 4929.85, 42.0),
                    size = vec3(1, 2.75, 1.85),
                    rotation = 9.5,
                }
            },

            {
                itemId = 8, -- safe

                target = {
                    coords = vec3(1708.2, 4921.0, 41.6),
                    size = vec3(1, 1, 1.1),
                    rotation = 325.75,
                }
            }
        }
    },

    { -- Paleto tankla
        doors = {251, 252},
        places = {
            {
                itemId = 2, -- loto

                target = {
                    coords = vec3(1728.35, 6413.5, 35.35),
                    size = vec3(0.3, 0.95, 0.45),
                    rotation = 339.75,
                }
            },

            {
                itemId = 3, -- sigar

                target = {
                    coords = vec3(1727.3, 6415.6, 35.8),
                    size = vec3(0.4, 1.9, 1.35),
                    rotation = 333.75,
                }
            },

--[[            {
                itemId = 4, -- donuts

                target = {
                    coords = vec3(1731.65, 6419.0, 35.05),
                    size = vec3(1, 0.5, 2.0),
                    rotation = 332.25,
                }
            },]]

            {
                itemId = 5, -- chips

                target = {
                    coords = vec3(1732.85, 6415.3, 35.0),
                    size = vec3(1.05, 3.15, 1.9),
                    rotation = 333.5,
                }
            },

            {
                itemId = 6, -- drinks

                target = {
                    coords = vec3(1734.85, 6414.1, 34.95),
                    size = vec3(1, 2.3, 1.8),
                    rotation = 333.25,
                }
            },

            {
                itemId = 8, -- safe

                target = {
                    coords = vec3(1738.05, 6419.2, 35.4),
                    size = vec3(0.75, 1.0, 1.0),
                    rotation = 334.5,
                }
            }
        }
    },

    { -- Paleto #2 tankla
        doors = {253, 254},
        places = {
            {
                itemId = 2, -- loto

                target = {
                    coords = vec3(160.45, 6639.8, 32.0),
                    size = vec3(0.35, 0.9, 0.45),
                    rotation = 324.0,
                }
            },

            {
                itemId = 3, -- sigar

                target = {
                    coords = vec3(160.15, 6642.15, 32.5),
                    size = vec3(0.25, 1.85, 1.45),
                    rotation = 315.25,
                }
            },

--[[            {
                itemId = 4, -- donuts

                target = {
                    coords = vec3(165.3, 6643.9, 31.75),
                    size = vec3(1.05, 0.65, 2.05),
                    rotation = 314.75,
                }
            },]]

            {
                itemId = 5, -- chips

                target = {
                    coords = vec3(165.35, 6640.1, 31.65),
                    size = vec3(1.05, 2.95, 1.9),
                    rotation = 316.5,
                }
            },

            {
                itemId = 6, -- drinks

                target = {
                    coords = vec3(166.75, 6638.4, 31.65),
                    size = vec3(1.25, 2.4, 1.9),
                    rotation = 314.25,
                }
            },

            {
                itemId = 8, -- safe

                target = {
                    coords = vec3(171.3, 6642.2, 32.1),
                    size = vec3(0.9, 0.65, 1.05),
                    rotation = 45.0,
                }
            }
        }
    },

    { -- Paleto riidepood
        doors = {256, 257},
        places = {
            {
                itemId = 7,

                target = {
                    coords = vec3(4.75, 6514.75, 31.65),
                    size = vec3(2.85, 2.85, 1.5),
                    rotation = 43.5,
                }
            },

            {
                itemId = 7,

                target = {
                    coords = vec3(3.0, 6519.6, 32.0),
                    size = vec3(1.2, 0.8, 2.3),
                    rotation = 45.0,
                }
            },

            {
                itemId = 7,

                target = {
                    coords = vec3(7.55, 6522.0, 32.2),
                    size = vec3(0.8, 2.6, 2.7),
                    rotation = 40.75,
                }
            },

            {
                itemId = 7,

                target = {
                    coords = vec3(11.5, 6517.75, 32.0),
                    size = vec3(0.8, 2.65, 2.25),
                    rotation = 43.0,
                }
            },

            {
                itemId = 9,

                target = {
                    coords = vec3(9.25, 6519.55, 32.15),
                    size = vec3(0.85, 3.0, 2.55),
                    rotation = 43.25,
                }
            }
        }
    },

    { -- Paleto juuksur
        doors = {258},
        places = {
            {
                itemId = 1,

                target = {
                    coords = vec3(-278.55, 6225.9, 31.15),
                    size = vec3(0.75, 0.75, 0.9),
                    rotation = 320.0,
                }
            }
        }
    },
}

---------- Cash Register
Config.cashPolicereq = 0
Config.cashReward = {min = 333, max = 666}
Config.cashTimeout = 30

Config.cashRegisters = {
    vec3(24.725276947021, -1346.7956542969, 29.482055664062),
    vec3(-46.668132781982, -1759.2263183594, 29.414672851562),
    vec3(1133.6571044922, -982.45715332031, 46.399291992188),
    vec3(1165.6483154297, -323.57803344727, 69.197021484375),
    vec3(372.73846435547, 326.91427612305, 103.55383300781),
    vec3(-705.21759033203, -914.51867675781, 19.20361328125),
    vec3(-1221.8637695312, -908.75604248047, 12.3121337890627),
    vec3(-1485.7978515625, -377.77581787109, 40.14794921875),
    vec3(-1818.8835449219, 794.0966796875, 138.06225585938),
    vec3(-2965.75390625, 390.75164794922, 15.041748046875),
    vec3(-3039.4284667969, 584.26812744141, 7.8974609375),
    vec3(160.95825195312, 6642.1186523438, 31.689331054688),
    vec3(1728.0, 6415.7407226562, 35.02563476562),
    vec3(1696.7473144531, 4922.6635742188, 42.052001953125),
    vec3(1959.7846679688, 3740.3603515625, 32.329711914062),
    vec3(1166.0966796875, 2711.2351074219, 38.142822265625),
    vec3(549.19122314453, 2670.6857910156, 42.1530761718753),
    vec3(2677.3713378906, 3279.7451171875, 55.2285156251),
    vec3(2556.5935058594, 380.78240966797, 108.6087646484),
    vec3(1392.9099121094, 3606.5803222656, 34.97509765625),

    vec3(136.54945373535, -1709.6043701172, 29.279907226562),
    vec3(-33.151649475098, -150.5802154541, 57.065185546875),
    vec3(-279.99560546875, 6228.791015625, 31.689331054688),
    vec3(1210.7340087891, -473.15603637695, 66.19775390625),
    vec3(-1284.2373046875, -1118.017578125, 6.987548828125),
    vec3(1933.2131347656, 3729.2307128906, 32.835205078125)
}

Config.cashWeapons = {
    `WEAPON_BAT`
}


------------- truck
truckRobbery.minTruckPolice = 0
truckRobbery.point = vec3(362.75604248047, -66.0, 68.169189453125)
truckRobbery.locations = {
    vec4(1250.9538574219, 2700.1845703125, 37.603637695312, 175.74803161621),
    vec4(662.88793945312, 2744.9011230469, 41.546508789062, 187.08660888672),
    vec4(1627.7010498047, 3559.6616210938, 34.84033203125, 303.30709838867),
    vec4(1609.5164794922, 3890.0043945312, 32.09375, 240.94488525391),

    vec4(190.65495300293, 2799.0856933594, 45.253540039062, 5.6692910194397),
    vec4(206.26812744141, 3039.4020996094, 42.405883789062, 277.79528808594),
    vec4(333.66592407227, 3419.3142089844, 36.10400390625, 300.47244262695),
    vec4(452.09671020508, 3567.2702636719, 32.835205078125, 348.6614074707),
    vec4(883.67474365234, 3649.5166015625, 32.464477539062, 189.92126464844),
    vec4(941.8681640625, 3613.0417480469, 32.262329101562, 87.874015808105),
    vec4(1278.1186523438, 3629.630859375, 32.649780273438, 11.338582038879),
    vec4(1338.9099121094, 3601.2790527344, 34.18310546875, 104.88188934326),
    vec4(2023.806640625, 3915.8901367188, 33.424926757812, 116.22047424316),
    vec4(2084.1889648438, 3857.6440429688, 32.767822265625, 116.22047424316),
    vec4(2131.4372558594, 3634.8264160156, 37.418334960938, 53.858268737793),
    vec4(2173.9516601562, 3359.9208984375, 45.000732421875, 303.30709838867),
    vec4(2328.8439941406, 3135.2702636719, 47.781005859375, 82.204727172852),
    vec4(2045.8681640625, 3181.2131347656, 44.630004882812, 144.56690979004),
    vec4(1769.3802490234, 3305.8286132812, 40.771484375, 246.61416625977),
    vec4(1770.8176269531, 3349.6484375, 40.21533203125, 300.47244262695)
}